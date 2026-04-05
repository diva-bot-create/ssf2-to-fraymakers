/// Palette generation for Fraymakers costumes
///
/// SSF2 sprites are full-color. We:
/// 1. Sample pixels from all extracted sprites
/// 2. K-means quantize to PALETTE_SIZE colors
/// 3. Build a palette_preview.png (Kx1 pixels, one color per slot)
/// 4. Remap every sprite pixel to its palette index (R = index, G = 0, B = 0, A = original)
/// 5. Generate costumes.palettes with Base + 3 hue-shifted alt costumes
///
/// The R/G map shader reads each sprite pixel's R as the X coordinate into
/// palette_preview.png to get the actual color (with costume remapping applied).

use image::{GenericImageView, ImageBuffer, Rgba};
use serde_json::{json, Value};
use std::path::Path;
use std::fs;

const PALETTE_SIZE: usize = 32;
const KMEANS_ITER: usize = 25;
const MAX_PIXEL_SAMPLES: usize = 15_000;

// ─── UUID (same deterministic approach as entity_gen) ─────────────────────────

fn det_uuid(seed: &str) -> String {
    use std::collections::hash_map::DefaultHasher;
    use std::hash::{Hash, Hasher};
    let mut h = DefaultHasher::new();
    seed.hash(&mut h);
    let v = h.finish();
    let seed2: String = seed.chars().rev().collect();
    let mut h2 = DefaultHasher::new();
    seed2.hash(&mut h2);
    let v2 = h2.finish();
    format!("{:08x}-{:04x}-4{:03x}-{:04x}-{:012x}",
        (v >> 32) as u32, (v >> 16) as u16, (v & 0xfff) as u16,
        ((v2 >> 48) & 0x3fff | 0x8000) as u16, v2 & 0xffffffffffff_u64)
}

// ─── Result type ──────────────────────────────────────────────────────────────

pub struct PaletteResult {
    pub palettes_json: String,
    pub palettes_meta_json: String,
    pub preview_png: Vec<u8>,
    pub preview_meta_json: String,
    /// GUID of the palettes collection (for entity paletteMap)
    pub collection_guid: String,
    /// $id of the Base costume map (for entity paletteMap)
    pub base_map_id: String,
}

// ─── K-means color quantization ───────────────────────────────────────────────

fn color_dist_sq(a: &[u8; 3], b: &[u8; 3]) -> u32 {
    let dr = (a[0] as i32 - b[0] as i32).pow(2);
    let dg = (a[1] as i32 - b[1] as i32).pow(2);
    let db = (a[2] as i32 - b[2] as i32).pow(2);
    (dr + dg + db) as u32
}

fn nearest_idx(rgb: &[u8; 3], palette: &[[u8; 3]]) -> usize {
    palette.iter().enumerate()
        .min_by_key(|(_, c)| color_dist_sq(rgb, c))
        .map(|(i, _)| i)
        .unwrap_or(0)
}

fn kmeans(samples: &[[u8; 3]], k: usize) -> Vec<[u8; 3]> {
    if samples.is_empty() { return vec![[128u8; 3]; k]; }

    // Initialize: evenly spaced samples (better coverage than random)
    let step = (samples.len() / k).max(1);
    let mut centroids: Vec<[u8; 3]> = (0..k)
        .map(|i| samples[(i * step).min(samples.len() - 1)])
        .collect();

    for _ in 0..KMEANS_ITER {
        let mut sums = vec![[0u64; 3]; k];
        let mut counts = vec![0u64; k];

        for s in samples {
            let idx = nearest_idx(s, &centroids);
            sums[idx][0] += s[0] as u64;
            sums[idx][1] += s[1] as u64;
            sums[idx][2] += s[2] as u64;
            counts[idx] += 1;
        }

        let mut changed = false;
        for i in 0..k {
            if counts[i] > 0 {
                let new_c = [
                    (sums[i][0] / counts[i]) as u8,
                    (sums[i][1] / counts[i]) as u8,
                    (sums[i][2] / counts[i]) as u8,
                ];
                if new_c != centroids[i] { changed = true; }
                centroids[i] = new_c;
            }
        }
        if !changed { break; }
    }

    // Sort by luminance for consistent ordering
    centroids.sort_by_key(|c| {
        (c[0] as u32 * 299 + c[1] as u32 * 587 + c[2] as u32 * 114) / 1000
    });
    centroids
}

// ─── Hue rotation (RGB → HSV → rotate H → RGB) ───────────────────────────────

fn rotate_hue(rgb: [u8; 3], degrees: f32) -> [u8; 3] {
    let r = rgb[0] as f32 / 255.0;
    let g = rgb[1] as f32 / 255.0;
    let b = rgb[2] as f32 / 255.0;

    let max = r.max(g).max(b);
    let min = r.min(g).min(b);
    let delta = max - min;

    let h = if delta < 0.001 { 0.0 }
        else if (max - r).abs() < 0.001 { 60.0 * (((g - b) / delta) % 6.0) }
        else if (max - g).abs() < 0.001 { 60.0 * ((b - r) / delta + 2.0) }
        else { 60.0 * ((r - g) / delta + 4.0) };

    let h = ((h + degrees) % 360.0 + 360.0) % 360.0;
    let s = if max < 0.001 { 0.0 } else { delta / max };
    let v = max;

    let c = v * s;
    let x = c * (1.0 - ((h / 60.0) % 2.0 - 1.0).abs());
    let m = v - c;

    let (r2, g2, b2) = if h < 60.0       { (c, x, 0.0) }
        else if h < 120.0 { (x, c, 0.0) }
        else if h < 180.0 { (0.0, c, x) }
        else if h < 240.0 { (0.0, x, c) }
        else if h < 300.0 { (x, 0.0, c) }
        else              { (c, 0.0, x) };

    [((r2 + m) * 255.0).round() as u8,
     ((g2 + m) * 255.0).round() as u8,
     ((b2 + m) * 255.0).round() as u8]
}

// ─── Main entry point ─────────────────────────────────────────────────────────

pub fn generate_palettes_and_remap(
    char_id: &str,
    char_name: &str,
    sprites_dir: &Path,
) -> anyhow::Result<PaletteResult> {
    // ── 1. Collect pixel samples from all sprites ──────────────────────────────
    let png_paths: Vec<_> = fs::read_dir(sprites_dir)?
        .filter_map(|e| e.ok())
        .map(|e| e.path())
        .filter(|p| p.extension().map(|x| x == "png").unwrap_or(false))
        .collect();

    log::info!("palette_gen: sampling {} sprites for color quantization", png_paths.len());

    let sample_per_sprite = (MAX_PIXEL_SAMPLES / png_paths.len().max(1)).max(3);
    let mut all_pixels: Vec<[u8; 3]> = Vec::with_capacity(MAX_PIXEL_SAMPLES);

    for path in &png_paths {
        let img = match image::open(path) {
            Ok(i) => i,
            Err(_) => continue,
        };
        let (w, h) = img.dimensions();
        let total = (w * h) as usize;
        let step = (total / sample_per_sprite).max(1);
        for (i, (_, _, px)) in img.pixels().enumerate() {
            if i % step == 0 && px[3] > 64 {
                all_pixels.push([px[0], px[1], px[2]]);
            }
        }
    }

    if all_pixels.is_empty() {
        all_pixels = vec![[255, 0, 0], [0, 255, 0], [0, 0, 255]];
    }

    log::info!("palette_gen: {} pixel samples collected, running k-means (k={})", all_pixels.len(), PALETTE_SIZE);

    // ── 2. Quantize to PALETTE_SIZE colors ────────────────────────────────────
    let palette = kmeans(&all_pixels, PALETTE_SIZE);

    // ── 3. Build palette_preview.png (PALETTE_SIZE × 1, one color per slot) ──
    // Pixel at (i, 0) = palette color i
    // Sprite pixels encode: R = palette index (0..PALETTE_SIZE-1), G = 0, B = 0
    let mut preview_img: ImageBuffer<Rgba<u8>, Vec<u8>> =
        ImageBuffer::new(PALETTE_SIZE as u32, 1);
    for (i, rgb) in palette.iter().enumerate() {
        preview_img.put_pixel(i as u32, 0, Rgba([rgb[0], rgb[1], rgb[2], 255]));
    }
    let mut preview_png = Vec::new();
    preview_img.write_to(
        &mut std::io::Cursor::new(&mut preview_png),
        image::ImageFormat::Png,
    )?;

    // Sprites stay as full-color PNGs — we don't remap to R/G indices.
    // SSF2 sprites weren't authored for the palette shader, so we leave them intact.
    // Costume swaps in FrayTools will work at the .palettes level but won't
    // visually recolor the sprites automatically (that requires hand-authored R/G maps).

    // ── 5. Generate costumes.palettes JSON ────────────────────────────────────
    let collection_guid = det_uuid(&format!("{}::palettes_guid", char_id));
    let preview_meta_guid = det_uuid(&format!("{}::palette_preview_meta", char_id));
    let palettes_meta_guid = det_uuid(&format!("{}::palettes_file_meta", char_id));

    // Color slot declarations
    let color_slots: Vec<Value> = palette.iter().enumerate().map(|(i, rgb)| {
        let slot_id = det_uuid(&format!("{}::palette_color_{}", char_id, i));
        let hex = format!("0xFF{:02X}{:02X}{:02X}", rgb[0], rgb[1], rgb[2]);
        json!({ "$id": slot_id, "color": hex, "name": format!("color_{:02}", i), "pluginMetadata": {} })
    }).collect();

    // Helper: build a map's color entries (with optional hue rotation)
    let build_map_colors = |hue_rot: f32| -> Vec<Value> {
        palette.iter().enumerate().map(|(i, rgb)| {
            let slot_id = det_uuid(&format!("{}::palette_color_{}", char_id, i));
            let c = if (hue_rot - 0.0).abs() < 0.01 { *rgb } else { rotate_hue(*rgb, hue_rot) };
            let hex = format!("0xFF{:02X}{:02X}{:02X}", c[0], c[1], c[2]);
            json!({ "paletteColorId": slot_id, "targetColor": hex })
        }).collect()
    };

    let base_map_id = det_uuid(&format!("{}::palette_map_base", char_id));

    let alt_costumes = [
        ("Alt 1 (Blue)",   90.0f32),
        ("Alt 2 (Green)", 150.0f32),
        ("Alt 3 (Purple)", 270.0f32),
        ("Alt 4 (Yellow)", 45.0f32),
        ("Alt 5 (Red)",   180.0f32),
        ("Alt 6 (Cyan)",  210.0f32),
    ];

    let mut maps: Vec<Value> = vec![json!({
        "$id": base_map_id,
        "colors": build_map_colors(0.0),
        "name": "Default",
        "pluginMetadata": {
            "com.fraymakers.FraymakersMetadata": { "isBase": true }
        }
    })];

    for (idx, (name, hue)) in alt_costumes.iter().enumerate() {
        let map_id = det_uuid(&format!("{}::palette_map_alt{}", char_id, idx));
        maps.push(json!({
            "$id": map_id,
            "colors": build_map_colors(*hue),
            "name": name,
            "pluginMetadata": {
                "com.fraymakers.FraymakersMetadata": { "isBase": false }
            }
        }));
    }

    let palettes_json = serde_json::to_string_pretty(&json!({
        "colors": color_slots,
        "export": true,
        "guid": collection_guid,
        "id": format!("{}Costumes", char_name),
        "imageAsset": preview_meta_guid,
        "maps": maps,
        "pluginMetadata": {
            "com.fraymakers.FraymakersMetadata": { "version": "0.3.1" }
        },
        "plugins": ["com.fraymakers.FraymakersMetadata"],
        "tags": [],
        "version": 1
    }))?;

    // .meta for costumes.palettes
    let palettes_meta_json = serde_json::to_string_pretty(&json!({
        "export": true,
        "guid": palettes_meta_guid,
        "id": format!("{}Costumes", char_name),
        "pluginMetadata": {},
        "plugins": [],
        "tags": [],
        "version": 2
    }))?;

    // .meta for palette_preview.png
    let preview_meta_json = serde_json::to_string_pretty(&json!({
        "export": false,
        "guid": preview_meta_guid,
        "id": "",
        "pluginMetadata": {},
        "plugins": [],
        "tags": [],
        "version": 2
    }))?;

    log::info!("palette_gen: generated {} color palette + {} costumes (base + {})",
        PALETTE_SIZE, maps.len(), maps.len() - 1);

    Ok(PaletteResult {
        palettes_json,
        palettes_meta_json,
        preview_png,
        preview_meta_json,
        collection_guid,
        base_map_id,
    })
}
