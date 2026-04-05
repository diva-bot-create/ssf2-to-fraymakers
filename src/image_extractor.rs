/// Extracts bitmap images from SWF tags and writes them as PNGs.
///
/// SWF structure for character sprites:
///   DefineSprite (animation) → PlaceObject (shape_id) → DefineShape (bitmap fill) → DefineBitsLossless
///
/// We extract the raw bitmaps and name the PNGs by their symbol name (e.g. mario_i0.png).
/// We also build a shape_id → bitmap_id mapping so callers can resolve
/// DefineSprite PlaceObject references to actual image files.

use anyhow::{Context, Result};
use std::collections::BTreeMap;
use std::fs;
use std::path::Path;

#[derive(Debug, Clone)]
pub struct ExtractedImage {
    pub bitmap_id: u16,
    pub symbol_name: String,
    pub width: u32,
    pub height: u32,
    pub png_path: String, // relative path within character output dir
}

/// Maps shape/character IDs to bitmap IDs (DefineShape → bitmap fill ID)
pub type ShapeToBitmapMap = BTreeMap<u16, u16>;

/// Per-animation per-frame image references
#[derive(Debug, Clone)]
pub struct AnimFrameImages {
    /// frame_index → (shape_id, symbol_name)
    pub frames: BTreeMap<u16, (u16, String)>,
    pub total_frames: u16,
}

/// Result of image extraction
pub struct ImageExtractionResult {
    /// bitmap_id → ExtractedImage (the raw PNG files)
    pub images: BTreeMap<u16, ExtractedImage>,
    /// shape_id → bitmap_id (for resolving PlaceObject refs)
    pub shape_to_bitmap: ShapeToBitmapMap,
    /// fm_anim_name → per-frame image references
    pub anim_images: BTreeMap<String, AnimFrameImages>,
}

/// Extract all bitmap images from the SWF, build mappings, and save as PNGs.
pub fn extract_images(
    swf_data: &[u8],
    output_dir: &Path,
    char_name: &str,
    ssf2_to_fm: &BTreeMap<String, String>,
) -> Result<ImageExtractionResult> {
    let swf_buf = swf::decompress_swf(swf_data)
        .context("Failed to decompress SWF")?;
    let swf = swf::parse_swf(&swf_buf)
        .context("Failed to parse SWF tags")?;

    // Build symbol table: char_id → class_name
    let mut symbols: BTreeMap<u16, String> = BTreeMap::new();
    for tag in &swf.tags {
        if let swf::Tag::SymbolClass(links) = tag {
            for link in links {
                let name = String::from_utf8_lossy(link.class_name.as_bytes()).to_string();
                symbols.insert(link.id, name);
            }
        }
    }

    // 1. Build shape_id → bitmap_id map from DefineShape tags
    let mut shape_to_bitmap: ShapeToBitmapMap = BTreeMap::new();
    for tag in &swf.tags {
        if let swf::Tag::DefineShape(shape) = tag {
            // Look for bitmap fill in fill styles
            for fill in &shape.styles.fill_styles {
                if let swf::FillStyle::Bitmap { id, .. } = fill {
                    shape_to_bitmap.insert(shape.id, *id);
                    break; // take first bitmap fill
                }
            }
        }
    }
    log::info!("Shape→bitmap mappings: {}", shape_to_bitmap.len());

    // 2. Extract all bitmaps to PNGs
    let sprites_dir = output_dir.join("library/sprites");
    fs::create_dir_all(&sprites_dir)?;

    let mut images: BTreeMap<u16, ExtractedImage> = BTreeMap::new();

    for tag in &swf.tags {
        match tag {
            swf::Tag::DefineBitsLossless(bmp) => {
                let id = bmp.id;
                let w = bmp.width as u32;
                let h = bmp.height as u32;

                // Find the symbol name: prefer the shape's symbol that references this bitmap
                let sym = find_symbol_for_bitmap(id, &symbols, &shape_to_bitmap)
                    .unwrap_or_else(|| symbols.get(&id).cloned()
                        .unwrap_or_else(|| format!("bitmap_{}", id)));

                match decode_lossless(bmp) {
                    Ok(rgba_data) => {
                        let filename = format!("{}.png", sanitize_name(&sym));
                        let png_path = sprites_dir.join(&filename);
                        write_png(&png_path, w, h, &rgba_data)?;

                        images.insert(id, ExtractedImage {
                            bitmap_id: id,
                            symbol_name: sym,
                            width: w,
                            height: h,
                            png_path: format!("library/sprites/{}", filename),
                        });
                    }
                    Err(e) => {
                        log::debug!("Failed to decode lossless bitmap {}: {}", id, e);
                    }
                }
            }
            swf::Tag::DefineBitsJpeg3(jpeg) => {
                let id = jpeg.id;
                let sym = find_symbol_for_bitmap(id, &symbols, &shape_to_bitmap)
                    .unwrap_or_else(|| symbols.get(&id).cloned()
                        .unwrap_or_else(|| format!("jpeg_{}", id)));

                match decode_jpeg3(jpeg) {
                    Ok((w, h, rgba_data)) => {
                        let filename = format!("{}.png", sanitize_name(&sym));
                        let png_path = sprites_dir.join(&filename);
                        write_png(&png_path, w, h, &rgba_data)?;

                        images.insert(id, ExtractedImage {
                            bitmap_id: id,
                            symbol_name: sym,
                            width: w,
                            height: h,
                            png_path: format!("library/sprites/{}", filename),
                        });
                    }
                    Err(e) => {
                        log::debug!("Failed to decode JPEG3 bitmap {}: {}", id, e);
                    }
                }
            }
            _ => {}
        }
    }

    log::info!("Extracted {} images to {}", images.len(), sprites_dir.display());

    // 3. Build per-animation per-frame image references from DefineSprite tags
    let mut anim_images = build_anim_frame_images(&swf, char_name, ssf2_to_fm, &symbols, &shape_to_bitmap);
    // Apply same fallbacks as sprite_parser for animations with no image data
    apply_image_fallbacks(&mut anim_images);
    log::info!("Animation image mappings: {} animations (after fallbacks)", anim_images.len());

    Ok(ImageExtractionResult {
        images,
        shape_to_bitmap,
        anim_images,
    })
}

/// Find the symbol name for a bitmap by looking up which shape references it
fn find_symbol_for_bitmap(
    bitmap_id: u16,
    symbols: &BTreeMap<u16, String>,
    shape_to_bitmap: &ShapeToBitmapMap,
) -> Option<String> {
    // Find a shape that references this bitmap and has a symbol name
    for (shape_id, bmp_id) in shape_to_bitmap {
        if *bmp_id == bitmap_id {
            if let Some(sym) = symbols.get(shape_id) {
                return Some(sym.clone());
            }
        }
    }
    None
}

/// Build per-animation per-frame image references by walking DefineSprite display lists.
/// For each animation sprite, track which shape (image) is placed on each frame.
fn build_anim_frame_images(
    swf: &swf::Swf,
    char_name: &str,
    ssf2_to_fm: &BTreeMap<String, String>,
    symbols: &BTreeMap<u16, String>,
    shape_to_bitmap: &ShapeToBitmapMap,
) -> BTreeMap<String, AnimFrameImages> {
    use crate::sprite_parser::extract_ssf2_anim_name;

    let char_lower = char_name.to_lowercase();
    let mut result = BTreeMap::new();

    for tag in &swf.tags {
        if let swf::Tag::DefineSprite(sprite) = tag {
            let sym = symbols.get(&sprite.id)
                .map(|s| s.as_str())
                .unwrap_or("");

            // Only process character animation sprites
            if !sym.contains("_fla.") { continue; }

            let ssf2_name = match extract_ssf2_anim_name(sym, &char_lower, ssf2_to_fm) {
                Some(name) => name,
                None => {
                    log::debug!("image_extractor: no SSF2 name for sprite '{}'", sym);
                    continue;
                }
            };
            // Convert SSF2 name → FM name (same as sprite_parser does)
            let fm_name = ssf2_to_fm.get(&ssf2_name).cloned().unwrap_or_else(|| ssf2_name.clone());
            log::debug!("image_extractor: sprite '{}' → ssf2='{}' fm='{}'", sym, ssf2_name, fm_name);

            let mut current_frame: u16 = 0;
            let mut frames: BTreeMap<u16, (u16, String)> = BTreeMap::new();
            let mut current_image_id: Option<u16> = None;
            let mut current_image_sym: Option<String> = None;

            for stag in &sprite.tags {
                match stag {
                    swf::Tag::ShowFrame => {
                        // Record current image for this frame
                        if let (Some(id), Some(ref sym_name)) = (current_image_id, &current_image_sym) {
                            frames.insert(current_frame, (id, sym_name.clone()));
                        }
                        current_frame += 1;
                    }
                    swf::Tag::PlaceObject(po) => {
                        // Track the image being placed (non-box shapes)
                        let inst_name = po.name.as_ref()
                            .map(|n| String::from_utf8_lossy(n.as_bytes()).to_string())
                            .unwrap_or_default();

                        // Skip collision box instances
                        if crate::sprite_parser::BoxType::from_instance_name(&inst_name).is_some() {
                            continue;
                        }

                        // This is an image being placed (bitmap directly or shape with bitmap fill)
                        let placed_id = match &po.action {
                            swf::PlaceObjectAction::Place(id) => Some(*id),
                            swf::PlaceObjectAction::Replace(id) => Some(*id),
                            _ => None,
                        };
                        if let Some(char_id) = placed_id {
                            let sym_name = symbols.get(&char_id).cloned()
                                .unwrap_or_else(|| format!("id_{}", char_id));
                            // Skip collision-related shapes (CollisonBox, etc.)
                            let lower = sym_name.to_lowercase();
                            if lower.contains("collisonbox") || lower.contains("collisionbox")
                                || lower.contains("_fla.") // sub-sprites, not images
                            {
                                continue;
                            }
                            current_image_id = Some(char_id);
                            current_image_sym = Some(sym_name);
                        }
                    }
                    _ => {}
                }
            }

            log::debug!("image_extractor: fm='{}' raw_frames={} from {} sprite frames, img_id={:?}", fm_name, frames.len(), sprite.num_frames, current_image_id);
            if !frames.is_empty() {
                // Fill in frames that didn't get an explicit PlaceObject (inherit from previous)
                let total = sprite.num_frames;
                let mut last_entry: Option<(u16, String)> = None;
                for f in 0..total {
                    if let Some(entry) = frames.get(&f) {
                        last_entry = Some(entry.clone());
                    } else if let Some(ref entry) = last_entry {
                        frames.insert(f, entry.clone());
                    }
                }

                result.insert(fm_name, AnimFrameImages {
                    frames,
                    total_frames: total,
                });
            }
        }
    }

    result
}

/// Apply image fallbacks for procedural/synthetic animations (same table as sprite_parser)
fn apply_image_fallbacks(result: &mut BTreeMap<String, AnimFrameImages>) {
    let fallbacks: &[(&str, &str)] = &[
        ("stunned", "hurt"), ("star_ko", "hurt"), ("starko", "hurt"),
        ("screenko", "hurt"), ("buried", "crouch"), ("fly", "jump_aerial"),
        ("swim", "fall"), ("ladder", "idle"), ("wall_stick", "fall"),
        ("special", "idle"), ("carry", "grab"), ("land_heavy", "land"),
        ("ledge_lean", "ledge_hang"), ("victory", "taunt"), ("defeat", "hurt"),
        ("respawn", "idle"), ("special_down_air", "special_down"),
        ("item_float", "idle"), ("item_screw", "special_up"),
        ("tumble", "fall"), ("frozen", "idle"),
    ];

    let mut to_insert: Vec<(String, AnimFrameImages)> = Vec::new();
    for (missing, donor) in fallbacks {
        // Override if missing entirely OR if present but has no actual image frames
        let needs_fallback = match result.get(*missing) {
            None => true,
            Some(existing) => existing.frames.is_empty() || existing.frames.values().all(|(_, sym)| sym.starts_with("id_")),
        };
        if !needs_fallback { continue; }
        if let Some(donor_data) = result.get(*donor) {
            to_insert.push((missing.to_string(), donor_data.clone()));
        }
    }
    for (name, data) in to_insert {
        result.insert(name, data);
    }
}

/// Decode DefineBitsLossless/DefineBitsLossless2 → RGBA pixels
fn decode_lossless(bmp: &swf::DefineBitsLossless) -> Result<Vec<u8>> {
    use flate2::read::ZlibDecoder;
    use std::io::Read;

    let mut decoder = ZlibDecoder::new(&bmp.data[..]);
    let mut decompressed = Vec::new();
    decoder.read_to_end(&mut decompressed)?;

    let w = bmp.width as usize;
    let h = bmp.height as usize;

    match bmp.format {
        swf::BitmapFormat::ColorMap8 { num_colors } => {
            let nc = num_colors as usize + 1;
            let has_alpha = bmp.version == 2;
            let bytes_per_color = if has_alpha { 4 } else { 3 };
            let palette_size = nc * bytes_per_color;

            if decompressed.len() < palette_size {
                anyhow::bail!("Palette data too short");
            }

            let palette = &decompressed[..palette_size];
            let pixel_data = &decompressed[palette_size..];

            // Row stride padded to 4-byte boundary
            let row_stride = (w + 3) & !3;
            let mut rgba = Vec::with_capacity(w * h * 4);

            for y in 0..h {
                let row_start = y * row_stride;
                for x in 0..w {
                    let idx = pixel_data.get(row_start + x).copied().unwrap_or(0) as usize;
                    let ci = idx.min(nc - 1);
                    let base = ci * bytes_per_color;
                    if has_alpha {
                        let a = palette[base];
                        let r = palette[base + 1];
                        let g = palette[base + 2];
                        let b = palette[base + 3];
                        rgba.extend_from_slice(&[r, g, b, a]);
                    } else {
                        let r = palette[base];
                        let g = palette[base + 1];
                        let b = palette[base + 2];
                        rgba.extend_from_slice(&[r, g, b, 255]);
                    }
                }
            }
            Ok(rgba)
        }
        swf::BitmapFormat::Rgb15 => {
            anyhow::bail!("RGB15 format not supported");
        }
        swf::BitmapFormat::Rgb32 => {
            let mut rgba = Vec::with_capacity(w * h * 4);
            if bmp.version == 2 {
                // ARGB premultiplied
                for pixel in decompressed.chunks_exact(4) {
                    let a = pixel[0];
                    let r = pixel[1];
                    let g = pixel[2];
                    let b = pixel[3];
                    if a == 0 {
                        rgba.extend_from_slice(&[0, 0, 0, 0]);
                    } else {
                        let r = ((r as u16 * 255) / a as u16).min(255) as u8;
                        let g = ((g as u16 * 255) / a as u16).min(255) as u8;
                        let b = ((b as u16 * 255) / a as u16).min(255) as u8;
                        rgba.extend_from_slice(&[r, g, b, a]);
                    }
                }
            } else {
                for pixel in decompressed.chunks_exact(4) {
                    let r = pixel[1];
                    let g = pixel[2];
                    let b = pixel[3];
                    rgba.extend_from_slice(&[r, g, b, 255]);
                }
            }
            Ok(rgba)
        }
    }
}

/// Decode DefineBitsJpeg3 → (width, height, RGBA pixels)
fn decode_jpeg3(jpeg: &swf::DefineBitsJpeg3) -> Result<(u32, u32, Vec<u8>)> {
    use image::io::Reader as ImageReader;
    use std::io::Cursor;

    let reader = ImageReader::new(Cursor::new(&jpeg.data))
        .with_guessed_format()?;
    let img = reader.decode()?;
    let rgb = img.to_rgba8();
    let w = rgb.width();
    let h = rgb.height();
    let mut rgba = rgb.into_raw();

    if !jpeg.alpha_data.is_empty() {
        use flate2::read::ZlibDecoder;
        use std::io::Read;
        let mut decoder = ZlibDecoder::new(&jpeg.alpha_data[..]);
        let mut alpha = Vec::new();
        decoder.read_to_end(&mut alpha)?;

        for (i, a) in alpha.iter().enumerate() {
            if let Some(px) = rgba.get_mut(i * 4 + 3) {
                *px = *a;
            }
        }
    }

    Ok((w, h, rgba))
}

/// Write RGBA pixel data as PNG
fn write_png(path: &Path, width: u32, height: u32, rgba: &[u8]) -> Result<()> {
    use image::{ImageBuffer, Rgba};
    let img: ImageBuffer<Rgba<u8>, _> = ImageBuffer::from_raw(width, height, rgba.to_vec())
        .context("Failed to create image buffer")?;
    img.save(path)?;
    Ok(())
}

fn sanitize_name(name: &str) -> String {
    name.replace(|c: char| !c.is_alphanumeric() && c != '_' && c != '-', "_")
}
