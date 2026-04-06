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

/// Local placement matrix for an image within its sub-sprite (in SSF2 local pixel space).
/// tx/ty are in pixels (already divided by 20 from twips).
/// sx/sy are scale magnitudes (always positive).
/// rotation is in degrees, derived from the matrix b/c shear components.
#[derive(Debug, Clone, Copy)]
pub struct ImageLocalMatrix {
    pub tx: f64,
    pub ty: f64,
    pub sx: f64,
    pub sy: f64,
    /// Rotation in degrees (from matrix a/b components). 0 = no rotation.
    pub rotation: f64,
}

impl Default for ImageLocalMatrix {
    fn default() -> Self { Self { tx: 0.0, ty: 0.0, sx: 1.0, sy: 1.0, rotation: 0.0 } }
}

/// A single image layer placed at a specific depth in one frame.
#[derive(Debug, Clone)]
pub struct FrameImageEntry {
    pub depth: u16,
    pub shape_id: u16,
    pub symbol_name: String,
    /// Local placement matrix within the sub-sprite (before root MC transform)
    pub local_matrix: ImageLocalMatrix,
    /// World-space position after applying root MC transform (pixels, SSF2 y-down).
    /// Use these for Fraymakers IMAGE symbol x/y/scaleX/scaleY (after y-flip).
    pub world_tx: f64,
    pub world_ty: f64,
    pub world_sx: f64,
    pub world_sy: f64,
    /// World-space rotation in degrees (local rotation + root MC rotation, if any).
    pub world_rotation: f64,
}

/// Per-animation per-frame image references.
/// Each frame may have multiple entries (one per depth/layer).
/// Entries within a frame are ordered by depth (ascending = back-to-front).
#[derive(Debug, Clone)]
pub struct AnimFrameImages {
    /// frame_index → ordered list of (depth, shape_id, symbol_name)
    pub frames: BTreeMap<u16, Vec<FrameImageEntry>>,
    pub total_frames: u16,
    /// Number of distinct depth slots used across all frames (= number of IMAGE layers to create)
    pub max_depth_slots: usize,
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

    // 3. Extract root MC transforms for applying to image positions
    let xform_map = crate::sprite_parser::extract_xframe_transforms(swf_data, char_name, ssf2_to_fm)
        .unwrap_or_default();

    // 4. Build per-animation per-frame image references from DefineSprite tags
    let mut anim_images = build_anim_frame_images(&swf, char_name, ssf2_to_fm, &symbols, &shape_to_bitmap, &xform_map);
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
    xform_map: &BTreeMap<String, crate::sprite_parser::XframeTransform>,
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

            // Root MC transform for this animation
            let root_xf = xform_map.get(&fm_name).copied()
                .unwrap_or(crate::sprite_parser::XframeTransform::default());

            let mut current_frame: u16 = 0;
            // depth → (shape_id, symbol_name, local_matrix) — the active display list
            let mut display_list: BTreeMap<u16, (u16, String, ImageLocalMatrix)> = BTreeMap::new();
            let mut frames: BTreeMap<u16, Vec<FrameImageEntry>> = BTreeMap::new();

            for stag in &sprite.tags {
                match stag {
                    swf::Tag::ShowFrame => {
                        // Snapshot the display list as this frame's entries
                        if !display_list.is_empty() {
                            let entries: Vec<FrameImageEntry> = display_list.iter()
                                .map(|(&depth, (id, sym, mat))| {
                                    // Apply root MC transform to get world-space coords.
                                    // Root MC scale (sx/sy) affects position but not rotation
                                    // (root is never rotated in SSF2, only scaled for character size).
                                    let world_tx = root_xf.tx + mat.tx * root_xf.sx;
                                    let world_ty = root_xf.ty + mat.ty * root_xf.sy;
                                    let world_sx = mat.sx * root_xf.sx.abs();
                                    let world_sy = mat.sy * root_xf.sy.abs();
                                    // Rotation is purely local (root doesn't rotate)
                                    let world_rotation = mat.rotation;
                                    FrameImageEntry {
                                        depth,
                                        shape_id: *id,
                                        symbol_name: sym.clone(),
                                        local_matrix: *mat,
                                        world_tx,
                                        world_ty,
                                        world_sx,
                                        world_sy,
                                        world_rotation,
                                    }
                                })
                                .collect();
                            frames.insert(current_frame, entries);
                        }
                        current_frame += 1;
                    }
                    swf::Tag::PlaceObject(po) => {
                        let inst_name = po.name.as_ref()
                            .map(|n| String::from_utf8_lossy(n.as_bytes()).to_string())
                            .unwrap_or_default();

                        // Skip collision box instances
                        if crate::sprite_parser::BoxType::from_instance_name(&inst_name).is_some() {
                            continue;
                        }

                        let depth = po.depth;
                        let local_mat = po.matrix.map(|m| {
                            let a = m.a.to_f64();
                            let b = m.b.to_f64();
                            let c = m.c.to_f64();
                            let d = m.d.to_f64();
                            // Decompose: scale = sqrt(a²+b²), rotation = atan2(b,a)
                            let sx = (a*a + b*b).sqrt();
                            let sy = (c*c + d*d).sqrt();
                            let rotation = b.atan2(a).to_degrees();
                            ImageLocalMatrix {
                                tx: m.tx.get() as f64 / 20.0,
                                ty: m.ty.get() as f64 / 20.0,
                                sx,
                                sy,
                                rotation,
                            }
                        }).unwrap_or_default();

                        match &po.action {
                            swf::PlaceObjectAction::Place(char_id)
                            | swf::PlaceObjectAction::Replace(char_id) => {
                                let sym_name = symbols.get(char_id).cloned()
                                    .unwrap_or_else(|| format!("id_{}", char_id));
                                let lower = sym_name.to_lowercase();
                                if lower.contains("collisonbox") || lower.contains("collisionbox")
                                    || lower.contains("_fla.")
                                {
                                    continue;
                                }
                                display_list.insert(depth, (*char_id, sym_name, local_mat));
                            }
                            swf::PlaceObjectAction::Modify => {
                                // Update matrix of existing entry
                                if let Some(entry) = display_list.get_mut(&depth) {
                                    entry.2 = local_mat;
                                }
                            }
                        }
                    }
                    swf::Tag::RemoveObject(ro) => {
                        display_list.remove(&ro.depth);
                    }
                    _ => {}
                }
            }

            log::debug!("image_extractor: fm='{}' raw_frames={} from {} sprite frames", fm_name, frames.len(), sprite.num_frames);
            if !frames.is_empty() {
                // Fill in frames that didn't get an explicit ShowFrame snapshot (inherit previous)
                let total = sprite.num_frames;
                let mut last_entry: Option<Vec<FrameImageEntry>> = None;
                for f in 0..total {
                    if let Some(entry) = frames.get(&f) {
                        last_entry = Some(entry.clone());
                    } else if let Some(ref entry) = last_entry {
                        frames.insert(f, entry.clone());
                    }
                }
                // Compute max depth slots across all frames
                let max_depth_slots = frames.values().map(|v| v.len()).max().unwrap_or(1);

                // Check if this animation should be split into sub-animations
                // (same split table as sprite_parser)
                let frame_labels = extract_frame_labels_from_sprite(&sprite.tags);
                let sub_splits = crate::sprite_parser::sub_anim_image_splits(&fm_name, &frame_labels, total);

                if sub_splits.is_empty() {
                    result.insert(fm_name, AnimFrameImages {
                        frames,
                        total_frames: total,
                        max_depth_slots,
                    });
                } else {
                    for (sub_fm_name, start_frame, end_frame) in sub_splits {
                        let slice_len = end_frame.saturating_sub(start_frame);
                        let sliced: BTreeMap<u16, Vec<FrameImageEntry>> = frames.iter()
                            .filter(|(&f, _)| f >= start_frame && f < end_frame)
                            .map(|(&f, v)| (f - start_frame, v.clone()))
                            .collect();
                        let sub_max = sliced.values().map(|v| v.len()).max().unwrap_or(1);
                        log::debug!("image_extractor: sub-anim '{}': frames {}..{} ({} img frames, {} depth slots)",
                            sub_fm_name, start_frame, end_frame, sliced.len(), sub_max);
                        result.insert(sub_fm_name, AnimFrameImages {
                            frames: sliced,
                            total_frames: slice_len,
                            max_depth_slots: sub_max,
                        });
                    }
                }
            }
        }
    }

    result
}

/// Apply image fallbacks for procedural/synthetic animations (same table as sprite_parser)
/// Extract frame labels from a sprite tag list (same logic as sprite_parser)
fn extract_frame_labels_from_sprite(tags: &[swf::Tag]) -> Vec<(String, u16)> {
    let mut frame_num: u16 = 0;
    let mut labels: Vec<(String, u16)> = Vec::new();
    for tag in tags {
        match tag {
            swf::Tag::ShowFrame => { frame_num += 1; }
            swf::Tag::FrameLabel(fl) => {
                let label = fl.label.to_str_lossy(encoding_rs::WINDOWS_1252).to_string();
                labels.push((label, frame_num));
            }
            _ => {}
        }
    }
    labels.sort_by_key(|(_, f)| *f);
    labels
}

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
            Some(existing) => existing.frames.is_empty() || existing.frames.values().all(|entries| entries.iter().all(|e| e.symbol_name.starts_with("id_"))),
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
                        // DefineBitsLossless2 ColorMap8 palette is RGBA (not ARGB).
                        // SWF spec: format=3 with alpha uses swf_rgba = {R, G, B, A}.
                        // Only format=5 (Rgb32) uses ARGB order.
                        let r = palette[base];
                        let g = palette[base + 1];
                        let b = palette[base + 2];
                        let a = palette[base + 3];
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
