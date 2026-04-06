/// Fraymakers .entity file generator
///
/// Generates the JSON entity file compatible with FrayTools.
/// Format based on the official Fraymakers character template:
/// https://github.com/Fraymakers/character-template
///
/// Key differences from our previous format:
/// - IMAGE symbols use `imageAsset` (GUID ref to .meta file) not `path`
/// - COLLISION_BOX keyframes reference symbol $ids (geometry in symbols)
/// - COLLISION_BODY keyframes reference symbol $ids
/// - All keyframes have `tweened`, `tweenType`, `pluginMetadata`
/// - Layers have `hidden`, `locked`, `pluginMetadata` (with box type metadata)
/// - Entity top-level has `pluginMetadata`, `plugins`, `version`, etc.
/// - Each PNG gets a .meta sidecar file with a GUID

use crate::extractor::CharacterData;
use crate::sprite_parser::{AnimationBoxData, BoxType};
use crate::image_extractor::{AnimFrameImages, ImageExtractionResult};
use serde_json::{json, Value};
use std::collections::BTreeMap;

// ─── UUID helpers ─────────────────────────────────────────────────────────────

fn det_uuid(seed: &str) -> String {
    crate::uuid_gen::det_uuid(seed)
}

fn uuid(char_id: &str, context: &str) -> String {
    det_uuid(&format!("{}::{}", char_id, context))
}

// ─── Box type → Fraymakers metadata type string ──────────────────────────────

fn box_type_to_fm(bt: BoxType) -> &'static str {
    match bt {
        BoxType::Hitbox     => "HIT_BOX",
        BoxType::Hurtbox    => "HURT_BOX",
        BoxType::GrabBox    => "GRAB_BOX",
        BoxType::ItemBox    => "HURT_BOX",  // no item box type in FM, treat as hurtbox
        BoxType::ShieldBox  => "REFLECT_BOX",
        BoxType::ReflectBox => "REFLECT_BOX",
        BoxType::AbsorbBox  => "COUNTER_BOX",
        BoxType::LedgeBox   => "LEDGE_GRAB_BOX",
    }
}

/// Convert an SSF2 instance name to a Fraymakers layer name.
/// SSF2 naming → FM naming:
///   attackBox  → hitbox0   (SSF2 "attack" = FM "hit")
///   attackBox2 → hitbox1
///   attackBox3 → hitbox2
///   hitBox     → hurtbox0  (SSF2 "hit" = FM "hurt")
///   hitBox2    → hurtbox1
///   hurtBox    → hurtbox0
///   grabBox    → grabbox0
///   ledgeBox   → ledgegrabbox0
///   etc.
fn ssf2_box_name_to_fm(inst_name: &str) -> String {
    let lower = inst_name.to_lowercase();

    // Extract numeric suffix: "attackBox2" → suffix=2, "hitBox" → suffix=0 (none = 0)
    // SSF2 uses 1-based suffixes (attackBox=first, attackBox2=second)
    // FM uses 0-based (hitbox0, hitbox1)
    let (prefix_lower, raw_num) = if let Some(pos) = lower.find(|c: char| c.is_ascii_digit()) {
        let num: usize = lower[pos..].parse().unwrap_or(1);
        (&lower[..pos], num)
    } else {
        (lower.as_str(), 1usize)
    };
    // Convert to 0-based: raw_num 1 → index 0, raw_num 2 → index 1
    let index = raw_num.saturating_sub(1);

    match prefix_lower {
        p if p.starts_with("attackbox") || p.starts_with("attack_box") =>
            format!("hitbox{}", index),
        p if p.starts_with("hitbox") || p.starts_with("hurtbox") =>
            format!("hurtbox{}", index),
        p if p.starts_with("grabbox") || p.starts_with("grab") =>
            format!("grabbox{}", index),
        p if p.starts_with("itembox") | p.starts_with("item_box") =>
            format!("itembox{}", index),
        p if p.starts_with("shieldbox") =>
            format!("shieldbox{}", index),
        p if p.starts_with("reflectbox") =>
            format!("reflectbox{}", index),
        p if p.starts_with("absorbbox") =>
            format!("absorbbox{}", index),
        p if p.starts_with("ledgebox") || p.starts_with("ledgegrab") =>
            format!("ledgegrabbox{}", index),
        _ => format!("{}{}", prefix_lower.trim_end_matches('_'), index),
    }
}

/// Extract the numeric index from a Fraymakers box layer name.
/// "hitbox0" → 0, "hurtbox1" → 1, "grabbox0" → 0
fn fm_box_index(fm_name: &str) -> usize {
    fm_name.chars().rev()
        .take_while(|c| c.is_ascii_digit())
        .collect::<String>()
        .chars().rev()
        .collect::<String>()
        .parse()
        .unwrap_or(0)
}

fn box_color(bt: BoxType) -> &'static str {
    match bt {
        BoxType::Hitbox     => "0xff0000",
        BoxType::Hurtbox    => "0xfcba03",
        BoxType::GrabBox    => "0xff00ff",
        BoxType::ItemBox    => "0xffff00",
        BoxType::ShieldBox  => "0x48f748",
        BoxType::ReflectBox => "0x48f748",
        BoxType::AbsorbBox  => "0x42ecff",
        BoxType::LedgeBox   => "0xbababa",
    }
}

// ─── Meta file generation ─────────────────────────────────────────────────────

/// Generate .meta JSON sidecar for a PNG image asset
pub fn generate_meta(guid: &str) -> String {
    serde_json::to_string_pretty(&json!({
        "export": false,
        "guid": guid,
        "id": "",
        "pluginMetadata": {},
        "plugins": [],
        "tags": [],
        "version": 2
    })).unwrap()
}

// ─── Main generator ───────────────────────────────────────────────────────────

pub fn generate_entity(
    data: &CharacterData,
    char_id: &str,
    sprite_boxes: &BTreeMap<String, AnimationBoxData>,
    img_result: &ImageExtractionResult,
) -> String {
    let mut keyframes: Vec<Value> = Vec::new();
    let mut layers: Vec<Value> = Vec::new();
    let mut symbols: Vec<Value> = Vec::new();
    let mut animations: Vec<Value> = Vec::new();

    // ── Build image asset GUID map (symbol_name → meta GUID) ──────────────────
    // Each image gets a deterministic GUID for its .meta file
    let mut image_guids: BTreeMap<String, String> = BTreeMap::new();
    for (_, img) in &img_result.images {
        let meta_guid = uuid(char_id, &format!("meta_{}", img.symbol_name));
        image_guids.insert(img.symbol_name.clone(), meta_guid);
    }

    // IMAGE symbols are now created per-placement (per anim/frame) to carry correct
    // world-space x/y/scaleX/scaleY from the root MC transform + local sub-sprite matrix.
    // We collect them during the animation loop below.
    // (The old per-bitmap shared symbol approach is replaced.)

    // ── Build frame script lookup ─────────────────────────────────────────────
    let _frame_script_map: BTreeMap<String, String> = data.scripts.iter()
        .filter(|s| !s.is_ext_method)
        .map(|s| (s.name.clone(), s.code.clone()))
        .collect();

    for (anim_name, anim_info) in &data.animations {
        let frame_count = sprite_boxes.get(anim_name)
            .map(|sb| sb.total_frames as u32)
            .unwrap_or((anim_info.frames as u32).max(1))
            .max(1);
        let anim_id = uuid(char_id, &format!("anim_{}", anim_name));
        let mut anim_layer_ids: Vec<String> = Vec::new();

        // ── 1. LABEL layer ────────────────────────────────────────────────────
        {
            let layer_id = uuid(char_id, &format!("layer_label_{}", anim_name));
            let kf_id = uuid(char_id, &format!("kf_label_{}", anim_name));
            keyframes.push(json!({
                "$id": kf_id,
                "type": "LABEL",
                "length": 1,
                "name": anim_name,
                "pluginMetadata": {}
            }));
            layers.push(json!({
                "$id": layer_id,
                "name": "Labels",
                "type": "LABEL",
                "keyframes": [kf_id],
                "hidden": false,
                "locked": false,
                "pluginMetadata": {}
            }));
            anim_layer_ids.push(layer_id);
        }

        // ── 2. FRAME_SCRIPT layer ─────────────────────────────────────────────
        // Each script gets a 1-frame keyframe. Frames without code get blank
        // keyframes (symbol: null). This matches FrayTools' expectation that
        // script keyframes fire once on their start frame only.
        {
            let layer_id = uuid(char_id, &format!("layer_script_{}", anim_name));

            // Find the SSF2 name for this animation
            let ssf2_name = data.ssf2_to_fm_anim.iter()
                .find(|(_, fm)| fm.as_str() == anim_name.as_str())
                .map(|(ssf2, _)| ssf2.clone());

            // Get the sub-animation frame offset (for split anims like jab1/jab2)
            let frame_offset = sprite_boxes.get(anim_name)
                .map(|sb| sb.sprite_frame_offset as u32)
                .unwrap_or(0);

            // Collect per-frame scripts: parse "{ssf2_name}__frame{N}" names,
            // subtract frame_offset to get local frame index.
            let mut frame_code: BTreeMap<u32, String> = BTreeMap::new();
            if let Some(ref ssf2) = ssf2_name {
                let prefix = format!("{}__frame", ssf2);
                for script in &data.scripts {
                    if script.is_ext_method { continue; }
                    if let Some(rest) = script.name.strip_prefix(&prefix) {
                        if let Ok(global_frame) = rest.parse::<u32>() {
                            if global_frame >= frame_offset {
                                let local_frame = global_frame - frame_offset;
                                if local_frame < frame_count {
                                    // Strip the outer "function name() {" wrapper and
                                    // trailing "}", keeping only the function body.
                                    // The body lines are indented by one tab; de-indent them.
                                    let body = extract_function_body(&script.code);
                                    frame_code.insert(local_frame, body);
                                }
                            }
                        }
                    }
                }
            }

            // Build keyframe sequence: for each frame with code, emit a 1-frame
            // script keyframe. Fill gaps with blank keyframes. After the last
            // script frame, fill remaining frames with a blank keyframe.
            let mut script_kf_ids: Vec<String> = Vec::new();
            let mut cursor: u32 = 0;

            let script_frames: Vec<u32> = frame_code.keys().copied().collect();
            for &sf in &script_frames {
                // Gap before this script frame
                if sf > cursor {
                    let gap_kf_id = uuid(char_id, &format!("kf_script_gap_{}_{}", anim_name, cursor));
                    keyframes.push(json!({
                        "$id": gap_kf_id,
                        "type": "FRAME_SCRIPT",
                        "length": sf - cursor,
                        "code": "",
                        "pluginMetadata": {}
                    }));
                    script_kf_ids.push(gap_kf_id);
                }
                // Script keyframe (1 frame)
                let kf_id = uuid(char_id, &format!("kf_script_{}_f{}", anim_name, sf));
                keyframes.push(json!({
                    "$id": kf_id,
                    "type": "FRAME_SCRIPT",
                    "length": 1,
                    "code": frame_code[&sf],
                    "pluginMetadata": {}
                }));
                script_kf_ids.push(kf_id);
                cursor = sf + 1;
            }
            // Trailing blank to fill remaining frames
            if cursor < frame_count {
                let tail_kf_id = uuid(char_id, &format!("kf_script_tail_{}", anim_name));
                keyframes.push(json!({
                    "$id": tail_kf_id,
                    "type": "FRAME_SCRIPT",
                    "length": frame_count - cursor,
                    "code": "",
                    "pluginMetadata": {}
                }));
                script_kf_ids.push(tail_kf_id);
            }

            // If no scripts at all, still need one blank keyframe spanning the animation
            if script_kf_ids.is_empty() {
                let kf_id = uuid(char_id, &format!("kf_script_empty_{}", anim_name));
                keyframes.push(json!({
                    "$id": kf_id,
                    "type": "FRAME_SCRIPT",
                    "length": frame_count,
                    "code": "",
                    "pluginMetadata": {}
                }));
                script_kf_ids.push(kf_id);
            }

            layers.push(json!({
                "$id": layer_id,
                "name": "Scripts",
                "type": "FRAME_SCRIPT",
                "keyframes": script_kf_ids,
                "hidden": false,
                "locked": false,
                "language": "",
                "pluginMetadata": {}
            }));
            anim_layer_ids.push(layer_id);
        }

        // ── 3. COLLISION_BODY layer ───────────────────────────────────────────
        {
            let layer_id = uuid(char_id, &format!("layer_body_{}", anim_name));
            let kf_id = uuid(char_id, &format!("kf_body_{}", anim_name));
            let sym_id = uuid(char_id, &format!("sym_body_{}", anim_name));

            // Create a COLLISION_BODY symbol
            symbols.push(json!({
                "$id": sym_id,
                "alpha": Value::Null,
                "color": Value::Null,
                "foot": 0,
                "head": 86,
                "hipWidth": 40,
                "hipXOffset": 0,
                "hipYOffset": 0,
                "pluginMetadata": {},
                "type": "COLLISION_BODY",
                "x": 0
            }));

            keyframes.push(json!({
                "$id": kf_id,
                "type": "COLLISION_BODY",
                "length": frame_count,
                "symbol": sym_id,
                "tweened": false,
                "tweenType": "LINEAR",
                "pluginMetadata": {}
            }));
            layers.push(json!({
                "$id": layer_id,
                "name": "Body",
                "type": "COLLISION_BODY",
                "keyframes": [kf_id],
                "hidden": false,
                "locked": false,
                "defaultAlpha": 0.5,
                "defaultColor": "0xffa500",
                "defaultFoot": 0,
                "defaultHead": 86,
                "defaultHipWidth": 40,
                "defaultHipXOffset": 0,
                "defaultHipYOffset": 0,
                "pluginMetadata": {}
            }));
            anim_layer_ids.push(layer_id);
        }

        // ── 4. COLLISION_BOX layers ───────────────────────────────────────────
        if let Some(anim_box_data) = sprite_boxes.get(anim_name) {
            let mut instances_in_anim: std::collections::BTreeSet<String> = std::collections::BTreeSet::new();
            for boxes in anim_box_data.frames.values() {
                for b in boxes {
                    instances_in_anim.insert(b.instance_name.clone());
                }
            }

            for inst_name in instances_in_anim.iter() {
                let box_type = BoxType::from_instance_name(inst_name).unwrap_or(BoxType::Hurtbox);
                let fm_box_type = box_type_to_fm(box_type);
                let color = box_color(box_type);
                // Convert SSF2 instance name to FM layer name (hitBox→hurtbox0, attackBox→hitbox0)
                let fm_layer_name = ssf2_box_name_to_fm(inst_name);
                let box_idx = fm_box_index(&fm_layer_name);
                let layer_id = uuid(char_id, &format!("layer_box_{}_{}", anim_name, inst_name));

                let mut box_kf_ids: Vec<String> = Vec::new();
                let total = anim_box_data.total_frames as u32;
                let mut frame_idx: u32 = 0;

                // Collect sorted frames that have this instance
                let mut active_frames: Vec<(u16, &crate::sprite_parser::FrameBox)> = Vec::new();
                for (f, boxes) in &anim_box_data.frames {
                    if let Some(b) = boxes.iter().find(|b| b.instance_name == *inst_name) {
                        active_frames.push((*f, b));
                    }
                }
                active_frames.sort_by_key(|(f, _)| *f);

                if active_frames.is_empty() { continue; }

                // Build runs: merge consecutive frames with identical geometry
                // into one keyframe; a gap in frame numbers means a blank keyframe.
                // This correctly handles RemoveObject (box absent on frame N even
                // if it was present on N-1 and reappears on N+1).
                let mut i = 0;
                while i < active_frames.len() {
                    let (start_frame, fb) = active_frames[i];

                    // Merge consecutive frames with the same box geometry
                    let mut run_end = i; // inclusive index of last frame in run
                    while run_end + 1 < active_frames.len() {
                        let (next_f, next_fb) = active_frames[run_end + 1];
                        let (cur_f, _) = active_frames[run_end];
                        // Must be exactly the next frame AND same geometry
                        let consecutive = next_f == cur_f + 1;
                        let same_geom = (next_fb.x - fb.x).abs() < 0.01
                            && (next_fb.y - fb.y).abs() < 0.01
                            && (next_fb.width - fb.width).abs() < 0.01
                            && (next_fb.height - fb.height).abs() < 0.01
                            && (next_fb.rotation - fb.rotation).abs() < 0.01;
                        if consecutive && same_geom {
                            run_end += 1;
                        } else {
                            break;
                        }
                    }
                    let run_len = (active_frames[run_end].0 - start_frame + 1) as u32;

                    // Gap keyframe (blank) before this run
                    if start_frame as u32 > frame_idx {
                        let gap_kf_id = uuid(char_id, &format!("kf_box_gap_{}_{}_{}", anim_name, inst_name, frame_idx));
                        keyframes.push(json!({
                            "$id": gap_kf_id,
                            "type": "COLLISION_BOX",
                            "length": (start_frame as u32) - frame_idx,
                            "symbol": Value::Null,
                            "tweened": false,
                            "tweenType": "LINEAR",
                            "pluginMetadata": {}
                        }));
                        box_kf_ids.push(gap_kf_id);
                        frame_idx = start_frame as u32;
                    }

                    // Create COLLISION_BOX symbol for this run.
                    // itemBox rotates around the hand attachment point (bottom-center).
                    // All other boxes rotate around their center.
                    let sym_id = uuid(char_id, &format!("sym_box_{}_{}_{}", anim_name, inst_name, start_frame));
                    let (pivot_x, pivot_y) = if box_type == crate::sprite_parser::BoxType::ItemBox {
                        (round2(fb.width / 2.0), round2(fb.height))  // bottom-center = hand
                    } else {
                        (round2(fb.width / 2.0), round2(fb.height / 2.0))  // center
                    };
                    symbols.push(json!({
                        "$id": sym_id,
                        "alpha": 0.5,
                        "color": color,
                        "pivotX": pivot_x,
                        "pivotY": pivot_y,
                        "pluginMetadata": {},
                        // FrayTools uses CCW-positive; SWF atan2(b,a) is CW-positive in y-down.
                        "rotation": round2(-fb.rotation),
                        "scaleX": round2(fb.width),
                        "scaleY": round2(fb.height),
                        "type": "COLLISION_BOX",
                        "x": round2(fb.x),
                        "y": round2(fb.y)
                    }));

                    let kf_id = uuid(char_id, &format!("kf_box_{}_{}_{}", anim_name, inst_name, start_frame));
                    keyframes.push(json!({
                        "$id": kf_id,
                        "type": "COLLISION_BOX",
                        "length": run_len,
                        "symbol": sym_id,
                        "tweened": false,
                        "tweenType": "LINEAR",
                        "pluginMetadata": {}
                    }));
                    box_kf_ids.push(kf_id);
                    frame_idx = start_frame as u32 + run_len;
                    i = run_end + 1;
                }

                // Tail gap
                if frame_idx < total {
                    let tail_kf_id = uuid(char_id, &format!("kf_box_tail_{}_{}_{}", anim_name, inst_name, frame_idx));
                    keyframes.push(json!({
                        "$id": tail_kf_id,
                        "type": "COLLISION_BOX",
                        "length": total - frame_idx,
                        "symbol": Value::Null,
                        "tweened": false,
                        "tweenType": "LINEAR",
                        "pluginMetadata": {}
                    }));
                    box_kf_ids.push(tail_kf_id);
                }

                if box_kf_ids.is_empty() { continue; }

                layers.push(json!({
                    "$id": layer_id,
                    "name": fm_layer_name,
                    "type": "COLLISION_BOX",
                    "keyframes": box_kf_ids,
                    "hidden": false,
                    "locked": false,
                    "defaultAlpha": 0.5,
                    "defaultColor": color,
                    "pluginMetadata": {
                        "com.fraymakers.FraymakersMetadata": {
                            "collisionBoxType": fm_box_type,
                            "index": box_idx
                        }
                    }
                }));
                anim_layer_ids.push(layer_id);
            }
        }

        // ── 5. IMAGE layers (one per depth slot, back-to-front) ────────────────────
        {
            let num_slots = img_result.anim_images.get(anim_name)
                .map(|a| a.max_depth_slots.max(1))
                .unwrap_or(1);

            for slot in 0..num_slots {
                let img_layer_id = uuid(char_id, &format!("layer_image_{}_{}", anim_name, slot));
                let mut img_kf_ids: Vec<String> = Vec::new();

                if let Some(anim_imgs) = img_result.anim_images.get(anim_name) {
                    let total = frame_count;
                    let mut f: u32 = 0;
                    while f < total {
                        let entry = anim_imgs.frames.get(&(f as u16))
                            .and_then(|v| v.get(slot));

                        // Key for run-length: same symbol AND same world transform
                        let sym_name = entry.map(|e| e.symbol_name.as_str());
                        let shape_id = entry.map(|e| e.shape_id);
                        let world_tx  = entry.map(|e| round2(e.world_tx)).unwrap_or(0.0);
                        let world_ty  = entry.map(|e| round2(e.world_ty)).unwrap_or(0.0);
                        let world_sx  = entry.map(|e| round2(e.world_sx)).unwrap_or(1.0);
                        let world_sy  = entry.map(|e| round2(e.world_sy)).unwrap_or(1.0);
                        let world_rot = entry.map(|e| round2(e.world_rotation)).unwrap_or(0.0);

                        // Run-length encode consecutive frames with identical symbol + world transform
                        let mut run = 1u32;
                        while f + run < total {
                            let next = anim_imgs.frames.get(&((f + run) as u16))
                                .and_then(|v| v.get(slot));
                            let matches = next.map(|e| e.symbol_name.as_str()) == sym_name
                                && next.map(|e| round2(e.world_tx))       == Some(world_tx).filter(|_| sym_name.is_some())
                                && next.map(|e| round2(e.world_ty))       == Some(world_ty).filter(|_| sym_name.is_some())
                                && next.map(|e| round2(e.world_sx))       == Some(world_sx).filter(|_| sym_name.is_some())
                                && next.map(|e| round2(e.world_sy))       == Some(world_sy).filter(|_| sym_name.is_some())
                                && next.map(|e| round2(e.world_rotation)) == Some(world_rot).filter(|_| sym_name.is_some());
                            if matches { run += 1; } else { break; }
                        }

                        let kf_id = uuid(char_id, &format!("kf_image_{}_s{}_f{}", anim_name, slot, f));

                        // Resolve bitmap and create a per-placement IMAGE symbol with world coords
                        let bitmap_img = shape_id.and_then(|sid| {
                            let bmp_id = img_result.shape_to_bitmap.get(&sid).copied().unwrap_or(sid);
                            img_result.images.get(&bmp_id)
                        }).or_else(|| {
                            sym_name.and_then(|sn| {
                                img_result.images.values().find(|img| img.symbol_name == sn)
                            })
                        });

                        let symbol_ref = if let Some(img) = bitmap_img {
                            // Create a per-placement symbol (unique per anim/slot/frame)
                            let per_placement_sym_id = uuid(char_id,
                                &format!("sym_img_{}_s{}_f{}", anim_name, slot, f));
                            let meta_guid = image_guids.get(&img.symbol_name)
                                .cloned().unwrap_or_default();

                            // FrayTools uses y-down (negative = above foot), same as SSF2.
                            // x/y = top-left corner of the image (unrotated).
                            // Pivot = image center (rotation origin).
                            // Rotation is in degrees from the SWF matrix decomposition.
                            let img_w = img.width as f64;
                            let img_h = img.height as f64;
                            let fm_sx = round2(world_sx.abs());
                            let fm_sy = round2(world_sy.abs());
                            let fm_x = round2(world_tx);
                            let fm_y = round2(world_ty);
                            let pivot_x = round2(img_w * fm_sx / 2.0);
                            let pivot_y = round2(img_h * fm_sy / 2.0);

                            symbols.push(json!({
                                "$id": per_placement_sym_id,
                                "alpha": 1,
                                "imageAsset": meta_guid,
                                "pivotX": pivot_x,
                                "pivotY": pivot_y,
                                "pluginMetadata": {},
                                // FrayTools uses CCW-positive; SWF atan2(b,a) is CW-positive in y-down.
                                "rotation": round2(-world_rot),
                                "scaleX": fm_sx,
                                "scaleY": fm_sy,
                                "type": "IMAGE",
                                "x": fm_x,
                                "y": fm_y
                            }));
                            Some(per_placement_sym_id)
                        } else {
                            None
                        };

                        keyframes.push(json!({
                            "$id": kf_id,
                            "type": "IMAGE",
                            "length": run,
                            "symbol": symbol_ref.map(Value::String).unwrap_or(Value::Null),
                            "tweened": false,
                            "tweenType": "LINEAR",
                            "pluginMetadata": {}
                        }));
                        img_kf_ids.push(kf_id);
                        f += run;
                    }
                } else if slot == 0 {
                    // No image data — single null keyframe for slot 0 only
                    let kf_id = uuid(char_id, &format!("kf_image_{}_s0_f0", anim_name));
                    keyframes.push(json!({
                        "$id": kf_id,
                        "type": "IMAGE",
                        "length": frame_count,
                        "symbol": Value::Null,
                        "tweened": false,
                        "tweenType": "LINEAR",
                        "pluginMetadata": {}
                    }));
                    img_kf_ids.push(kf_id);
                }

                layers.push(json!({
                    "$id": img_layer_id,
                    "name": format!("Image {}", slot),
                    "type": "IMAGE",
                    "keyframes": img_kf_ids,
                    "hidden": false,
                    "locked": false,
                    "pluginMetadata": {}
                }));
                anim_layer_ids.push(img_layer_id);
            }
        }

        animations.push(json!({
            "$id": anim_id,
            "name": anim_name,
            "layers": anim_layer_ids,
            "pluginMetadata": {}
        }));
    }

    let entity = json!({
        "animations": animations,
        "export": true,
        "guid": uuid(char_id, "entity_guid"),
        "id": char_id,
        "keyframes": keyframes,
        "layers": layers,
        "paletteMap": Value::Null,
        "pluginMetadata": {
            "com.fraymakers.FraymakersMetadata": {
                "objectType": "CHARACTER",
                "version": "0.4.0"
            }
        },
        "plugins": ["com.fraymakers.FraymakersMetadata"],
        "symbols": symbols,
        "tags": [],
        "terrains": [],
        "tilesets": [],
        "version": 14
    });

    serde_json::to_string_pretty(&entity).unwrap_or_else(|_| "{}".to_string())
}

/// Generate entity with paletteMap filled in
pub fn generate_entity_with_palette(
    data: &CharacterData,
    char_id: &str,
    sprite_boxes: &BTreeMap<String, AnimationBoxData>,
    img_result: &ImageExtractionResult,
    palette_collection_guid: &str,
    palette_map_id: &str,
) -> String {
    let json_str = generate_entity(data, char_id, sprite_boxes, img_result);
    let mut entity: serde_json::Value = serde_json::from_str(&json_str).unwrap_or(serde_json::json!({}));
    entity["paletteMap"] = serde_json::json!({
        "paletteCollection": palette_collection_guid,
        "paletteMap": palette_map_id
    });
    serde_json::to_string_pretty(&entity).unwrap_or(json_str)
}

/// Get image GUIDs for .meta file generation
pub fn get_image_meta_guids(
    char_id: &str,
    img_result: &ImageExtractionResult,
) -> BTreeMap<String, String> {
    let mut result = BTreeMap::new();
    for (_, img) in &img_result.images {
        let meta_guid = uuid(char_id, &format!("meta_{}", img.symbol_name));
        result.insert(img.png_path.clone(), meta_guid);
    }
    result
}

fn round2(v: f64) -> f64 {
    (v * 100.0).round() / 100.0
}

/// Strip the `function name() {` wrapper from a script and return just the body,
/// with one level of leading tab removed from each line.
fn extract_function_body(code: &str) -> String {
    let mut lines: Vec<&str> = code.lines().collect();
    // Drop leading blank lines
    while lines.first().map(|l| l.trim().is_empty()).unwrap_or(false) {
        lines.remove(0);
    }
    // Drop trailing blank lines
    while lines.last().map(|l| l.trim().is_empty()).unwrap_or(false) {
        lines.pop();
    }
    if lines.is_empty() {
        return String::new();
    }
    // First line should be `function name() {` — drop it
    if lines.first().map(|l| l.trim_start().starts_with("function ")).unwrap_or(false) {
        lines.remove(0);
    }
    // Last line should be `}` — drop it
    if lines.last().map(|l| l.trim() == "}").unwrap_or(false) {
        lines.pop();
    }
    // De-indent by one tab
    let body: Vec<&str> = lines.iter()
        .map(|l| l.strip_prefix('\t').unwrap_or(l))
        .collect();
    body.join("\n")
}
