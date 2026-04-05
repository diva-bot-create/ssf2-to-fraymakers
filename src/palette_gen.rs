/// Palette generation for Fraymakers costumes
///
/// SSF2 costume data lives in the engine SWF, not the character file.
/// Instead we:
/// 1. Extract unique colors from the idle/stand sprites (most representative)
/// 2. K-means quantize to PALETTE_SIZE color slots
/// 3. Build palette_preview.png (PALETTE_SIZE × 1 pixels, one color per slot)
/// 4. Generate costumes.palettes:
///    - "Default" = the exact extracted colors
///    - 5 hue-shifted alts (classic fighting game costume set)
///
/// Sprites stay full-color (not remapped to R/G indices), so the palette system
/// provides a starting point for manual costume authoring in FrayTools.

use image::{GenericImageView, ImageBuffer, Rgba};
use serde_json::{json, Value};
use std::path::Path;
use std::fs;

const PALETTE_SIZE: usize = 32;
const KMEANS_ITER:  usize = 30;

// ─── UUID ─────────────────────────────────────────────────────────────────────

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

// ─── Result ───────────────────────────────────────────────────────────────────

pub struct PaletteResult {
    pub palettes_json:      String,
    pub palettes_meta_json: String,
    pub preview_png:        Vec<u8>,
    pub preview_meta_json:  String,
    pub collection_guid:    String,
    pub base_map_id:        String,
}

// ─── K-means ──────────────────────────────────────────────────────────────────

fn dist_sq(a: &[u8; 3], b: &[u8; 3]) -> u32 {
    let dr = a[0] as i32 - b[0] as i32;
    let dg = a[1] as i32 - b[1] as i32;
    let db = a[2] as i32 - b[2] as i32;
    (dr*dr + dg*dg + db*db) as u32
}

fn nearest(rgb: &[u8; 3], palette: &[[u8; 3]]) -> usize {
    palette.iter().enumerate()
        .min_by_key(|(_, c)| dist_sq(rgb, c))
        .map(|(i, _)| i).unwrap_or(0)
}

fn kmeans(samples: &[[u8; 3]], k: usize) -> Vec<[u8; 3]> {
    if samples.is_empty() { return vec![[128u8; 3]; k]; }
    let step = (samples.len() / k).max(1);
    let mut centroids: Vec<[u8; 3]> = (0..k)
        .map(|i| samples[(i * step).min(samples.len()-1)])
        .collect();
    for _ in 0..KMEANS_ITER {
        let mut sums  = vec![[0u64; 3]; k];
        let mut counts = vec![0u64; k];
        for s in samples {
            let idx = nearest(s, &centroids);
            sums[idx][0] += s[0] as u64;
            sums[idx][1] += s[1] as u64;
            sums[idx][2] += s[2] as u64;
            counts[idx]  += 1;
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
    centroids.sort_by_key(|c| (c[0] as u32 * 299 + c[1] as u32 * 587 + c[2] as u32 * 114) / 1000);
    centroids
}

// ─── Hue rotation ─────────────────────────────────────────────────────────────

fn rotate_hue(rgb: [u8; 3], deg: f32) -> [u8; 3] {
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
    let h = ((h + deg) % 360.0 + 360.0) % 360.0;
    let s = if max < 0.001 { 0.0 } else { delta / max };
    let v = max;
    let c = v * s;
    let x = c * (1.0 - ((h / 60.0) % 2.0 - 1.0).abs());
    let m = v - c;
    let (r2, g2, b2) = if h < 60.0        { (c, x, 0.0) }
        else if h < 120.0  { (x, c, 0.0) }
        else if h < 180.0  { (0.0, c, x) }
        else if h < 240.0  { (0.0, x, c) }
        else if h < 300.0  { (x, 0.0, c) }
        else               { (c, 0.0, x) };
    [((r2+m)*255.0).round() as u8, ((g2+m)*255.0).round() as u8, ((b2+m)*255.0).round() as u8]
}

// ─── Main entry point ─────────────────────────────────────────────────────────

pub fn generate_palettes_and_remap(
    char_id: &str,
    char_name: &str,
    sprites_dir: &Path,
) -> anyhow::Result<PaletteResult> {

    // ── 1. Collect all sprite PNGs, prefer idle/stand frames ─────────────────
    let all_pngs: Vec<_> = fs::read_dir(sprites_dir)?
        .filter_map(|e| e.ok())
        .map(|e| e.path())
        .filter(|p| p.extension().map(|x| x == "png").unwrap_or(false))
        .collect();

    // Prioritize idle sprites (mario_i*, mario_stand*) for most accurate base colors
    let idle_pngs: Vec<_> = all_pngs.iter()
        .filter(|p| {
            let name = p.file_name().unwrap_or_default().to_string_lossy().to_lowercase();
            name.contains("_i") || name.contains("stand") || name.contains("idle")
        })
        .cloned()
        .collect();

    let source_pngs = if idle_pngs.len() >= 3 { &idle_pngs } else { &all_pngs };
    log::info!("palette_gen: sampling {} sprites ({} idle) for color extraction",
        all_pngs.len(), idle_pngs.len());

    // ── 2. Sample pixels ──────────────────────────────────────────────────────
    let target_samples = 20_000usize;
    let per_sprite = (target_samples / source_pngs.len().max(1)).max(10);
    let mut pixels: Vec<[u8; 3]> = Vec::with_capacity(target_samples);

    for path in source_pngs {
        let img = match image::open(path) { Ok(i) => i, Err(_) => continue };
        let (w, h) = img.dimensions();
        let total = (w * h) as usize;
        let step = (total / per_sprite).max(1);
        for (i, (_, _, px)) in img.pixels().enumerate() {
            if i % step == 0 && px[3] > 64 {
                pixels.push([px[0], px[1], px[2]]);
            }
        }
    }

    if pixels.is_empty() {
        pixels = vec![[220, 50, 50], [50, 50, 220], [50, 180, 50]];
    }

    log::info!("palette_gen: {} pixel samples, running k-means (k={})", pixels.len(), PALETTE_SIZE);

    // ── 3. Quantize ───────────────────────────────────────────────────────────
    let palette = kmeans(&pixels, PALETTE_SIZE);

    // ── 4. Build palette_preview.png (PALETTE_SIZE × 1) ──────────────────────
    let mut preview_img: ImageBuffer<Rgba<u8>, Vec<u8>> = ImageBuffer::new(PALETTE_SIZE as u32, 1);
    for (i, rgb) in palette.iter().enumerate() {
        preview_img.put_pixel(i as u32, 0, Rgba([rgb[0], rgb[1], rgb[2], 255]));
    }
    let mut preview_png = Vec::new();
    preview_img.write_to(&mut std::io::Cursor::new(&mut preview_png), image::ImageFormat::Png)?;

    // ── 5. Build costumes.palettes JSON ───────────────────────────────────────
    let collection_guid    = det_uuid(&format!("{}::palettes_guid",       char_id));
    let preview_meta_guid  = det_uuid(&format!("{}::palette_preview_meta", char_id));
    let palettes_meta_guid = det_uuid(&format!("{}::palettes_file_meta",   char_id));

    // Color slot declarations (one per palette entry)
    let color_slots: Vec<Value> = palette.iter().enumerate().map(|(i, rgb)| {
        let slot_id = det_uuid(&format!("{}::palette_color_{}", char_id, i));
        let hex = format!("0xFF{:02X}{:02X}{:02X}", rgb[0], rgb[1], rgb[2]);
        json!({ "$id": slot_id, "color": hex, "name": format!("color_{:02}", i), "pluginMetadata": {} })
    }).collect();

    // Helper: build map color entries (optionally hue-rotated)
    let build_map_colors = |hue_rot: f32| -> Vec<Value> {
        palette.iter().enumerate().map(|(i, rgb)| {
            let slot_id = det_uuid(&format!("{}::palette_color_{}", char_id, i));
            let c = if hue_rot.abs() < 0.1 { *rgb } else { rotate_hue(*rgb, hue_rot) };
            json!({ "paletteColorId": slot_id, "targetColor": format!("0xFF{:02X}{:02X}{:02X}", c[0], c[1], c[2]) })
        }).collect()
    };

    let base_map_id = det_uuid(&format!("{}::palette_map_base", char_id));

    // Classic 5-costume fighting game set
    let alt_costumes: &[(&str, f32)] = &[
        ("Alt 1 (Red)",    180.0),
        ("Alt 2 (Green)",  120.0),
        ("Alt 3 (Blue)",    60.0),
        ("Alt 4 (Yellow)", -60.0),
        ("Alt 5 (White)",   0.0),   // desaturated version handled below
    ];

    let mut maps: Vec<Value> = vec![json!({
        "$id": base_map_id,
        "colors": build_map_colors(0.0),
        "name": "Default",
        "pluginMetadata": { "com.fraymakers.FraymakersMetadata": { "isBase": true } }
    })];

    for (idx, (name, hue)) in alt_costumes.iter().enumerate() {
        let map_id = det_uuid(&format!("{}::palette_map_alt{}", char_id, idx));
        let colors = if *name == "Alt 5 (White)" {
            // Desaturated/greyscale version
            palette.iter().enumerate().map(|(i, rgb)| {
                let slot_id = det_uuid(&format!("{}::palette_color_{}", char_id, i));
                let lum = (rgb[0] as u32 * 299 + rgb[1] as u32 * 587 + rgb[2] as u32 * 114) / 1000;
                let g = lum as u8;
                json!({ "paletteColorId": slot_id, "targetColor": format!("0xFF{:02X}{:02X}{:02X}", g, g, g) })
            }).collect::<Vec<_>>()
        } else {
            build_map_colors(*hue)
        };
        maps.push(json!({
            "$id": map_id,
            "colors": colors,
            "name": name,
            "pluginMetadata": { "com.fraymakers.FraymakersMetadata": { "isBase": false } }
        }));
    }

    let palettes_json = serde_json::to_string_pretty(&json!({
        "colors": color_slots,
        "export": true,
        "guid": collection_guid,
        "id": format!("{}Costumes", char_name),
        "imageAsset": preview_meta_guid,
        "maps": maps,
        "pluginMetadata": { "com.fraymakers.FraymakersMetadata": { "version": "0.3.1" } },
        "plugins": ["com.fraymakers.FraymakersMetadata"],
        "tags": [],
        "version": 1
    }))?;

    let palettes_meta_json = serde_json::to_string_pretty(&json!({
        "export": true,
        "guid": palettes_meta_guid,
        "id": format!("{}Costumes", char_name),
        "pluginMetadata": {},
        "plugins": [],
        "tags": [],
        "version": 2
    }))?;

    let preview_meta_json = serde_json::to_string_pretty(&json!({
        "export": false,
        "guid": preview_meta_guid,
        "id": "",
        "pluginMetadata": {},
        "plugins": [],
        "tags": [],
        "version": 2
    }))?;

    log::info!("palette_gen: {} color slots, {} costumes (Default + {} alts)",
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
