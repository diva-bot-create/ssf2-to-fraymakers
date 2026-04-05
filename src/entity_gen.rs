/// Fraymakers .entity file generator
///
/// Generates the JSON entity file used by FrayTools for sprite animation, layering,
/// and collision data. Structure based on kung-fu-man reference character.
///
/// Layer order per animation (bottom→top in FrayTools):
///   1. LABEL         — animation name keyframe
///   2. FRAME_SCRIPT  — Haxe code per frame
///   3. COLLISION_BODY — the main body/hurtbox (static per animation)
///   4. COLLISION_BOX* — per-frame hitboxes/hurtboxes from SSF2 sprites
///   5. IMAGE          — sprite image reference

use crate::extractor::CharacterData;
use crate::sprite_parser::{AnimationBoxData, BoxType};
use serde_json::{json, Value};
use std::collections::BTreeMap;

// ─── UUID helpers ─────────────────────────────────────────────────────────────

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
        (v >> 32) as u32,
        (v >> 16) as u16,
        (v & 0xfff) as u16,
        ((v2 >> 48) & 0x3fff | 0x8000) as u16,
        v2 & 0xffffffffffff_u64)
}

fn uuid(char_id: &str, context: &str) -> String {
    det_uuid(&format!("{}::{}", char_id, context))
}

// ─── Box type → Fraymakers color ─────────────────────────────────────────────

fn box_color(bt: BoxType) -> &'static str {
    match bt {
        BoxType::Hitbox    => "0xFF0000",  // red — active attack
        BoxType::Hurtbox   => "0x00FF00",  // green — vulnerable
        BoxType::GrabBox   => "0xFF8800",  // orange — grab range
        BoxType::ItemBox   => "0xFFFF00",  // yellow — item pickup
        BoxType::ShieldBox => "0x0088FF",  // blue — shield
        BoxType::ReflectBox => "0xFF00FF", // magenta — reflector
        BoxType::AbsorbBox => "0x00FFFF",  // cyan — absorb
        BoxType::LedgeBox  => "0x884400",  // brown — ledge grab
    }
}

// ─── Main generator ───────────────────────────────────────────────────────────

pub fn generate_entity(
    data: &CharacterData,
    char_id: &str,
    sprite_boxes: &BTreeMap<String, AnimationBoxData>,
) -> String {
    let mut keyframes: Vec<Value> = Vec::new();
    let mut layers: Vec<Value> = Vec::new();
    let mut animations: Vec<Value> = Vec::new();

    // Build frame script map: fm_anim_name -> code
    // Frame scripts: SSF2 frame methods are state dispatchers; map them by the xframe value
    let mut frame_script_map: BTreeMap<String, String> = BTreeMap::new();
    for script in &data.scripts {
        if !script.is_ext_method {
            // script.name is like "frame1"; look up the xframe → SSF2 name → FM name mapping
            // We stored xframe_map in CharacterData already; the animations BTreeMap uses FM names
            // For now: emit the full frame script code as a reference comment block
            frame_script_map.insert(script.name.clone(), script.code.clone());
        }
    }

    // Collect all unique box instance names across all animations, to build object declarations
    let mut all_box_instances: std::collections::BTreeSet<String> = std::collections::BTreeSet::new();
    for anim_data in sprite_boxes.values() {
        for boxes in anim_data.frames.values() {
            for b in boxes {
                all_box_instances.insert(b.instance_name.clone());
            }
        }
    }

    for (anim_name, anim_info) in &data.animations {
        let frame_count = (anim_info.frames as u32).max(1);
        let anim_id = uuid(char_id, &format!("anim_{}", anim_name));

        let mut anim_layer_ids: Vec<String> = Vec::new();

        // ── 1. LABEL layer ────────────────────────────────────────────────────
        let label_layer_id = uuid(char_id, &format!("layer_label_{}", anim_name));
        let label_kf_id = uuid(char_id, &format!("kf_label_{}", anim_name));
        keyframes.push(json!({
            "$id": label_kf_id,
            "type": "LABEL",
            "length": 1,
            "name": anim_name,
            "pluginMetadata": {}
        }));
        layers.push(json!({
            "$id": label_layer_id,
            "name": "Labels",
            "type": "LABEL",
            "keyframes": [label_kf_id],
            "hidden": false,
            "locked": false,
            "pluginMetadata": {}
        }));
        anim_layer_ids.push(label_layer_id);

        // ── 2. FRAME_SCRIPT layer ─────────────────────────────────────────────
        let script_layer_id = uuid(char_id, &format!("layer_script_{}", anim_name));
        let script_kf_id = uuid(char_id, &format!("kf_script_{}", anim_name));
        // Use the ssf2_to_fm_anim reverse map to find the matching frame script
        let script_code = {
            // Find the SSF2 name for this FM animation
            let ssf2_name = data.ssf2_to_fm_anim.iter()
                .find(|(_, fm)| fm.as_str() == anim_name.as_str())
                .map(|(ssf2, _)| ssf2.clone());
            // Find a matching frame script by iterating xframe_map
            let mut code = String::new();
            if let Some(ssf2) = ssf2_name {
                // Look for a frame script whose code contains self.xframe = "<ssf2>"
                let pattern = format!("xframe = \"{}\"", ssf2);
                for script in &data.scripts {
                    if !script.is_ext_method && script.code.contains(&pattern) {
                        code = script.code.clone();
                        break;
                    }
                }
            }
            code
        };
        keyframes.push(json!({
            "$id": script_kf_id,
            "type": "FRAME_SCRIPT",
            "length": frame_count,
            "code": script_code,
            "pluginMetadata": {}
        }));
        layers.push(json!({
            "$id": script_layer_id,
            "name": "Scripts",
            "type": "FRAME_SCRIPT",
            "keyframes": [script_kf_id],
            "hidden": false,
            "locked": false,
            "language": "",
            "pluginMetadata": {}
        }));
        anim_layer_ids.push(script_layer_id);

        // ── 3. COLLISION_BODY layer (main body / standing hurtbox) ────────────
        let body_layer_id = uuid(char_id, &format!("layer_body_{}", anim_name));
        let body_kf_id = uuid(char_id, &format!("kf_body_{}", anim_name));
        // Default body size — will be overridden per-character once we have sprite sheet data
        keyframes.push(json!({
            "$id": body_kf_id,
            "type": "COLLISION_BODY",
            "length": frame_count,
            "x": -30,
            "y": -80,
            "width": 60,
            "height": 80,
            "angle": 0,
            "color": "0x00FF00",
            "flipX": false,
            "pluginMetadata": {}
        }));
        layers.push(json!({
            "$id": body_layer_id,
            "name": "Hurtbox",
            "type": "COLLISION_BODY",
            "keyframes": [body_kf_id],
            "hidden": false,
            "locked": false,
            "pluginMetadata": {}
        }));
        anim_layer_ids.push(body_layer_id);

        // ── 4. Per-box-type COLLISION_BOX layers from SSF2 sprite data ────────
        if let Some(anim_box_data) = sprite_boxes.get(anim_name) {
            // Group all box instance names that appear in this animation
            let mut instances_in_anim: std::collections::BTreeSet<String> = std::collections::BTreeSet::new();
            for boxes in anim_box_data.frames.values() {
                for b in boxes {
                    instances_in_anim.insert(b.instance_name.clone());
                }
            }

            // One layer per instance name (e.g. "hitBox", "attackBox", "hitBox2")
            for inst_name in &instances_in_anim {
                let box_type = BoxType::from_instance_name(inst_name)
                    .unwrap_or(BoxType::Hurtbox);
                let layer_name = format!("{} ({})", inst_name, box_type.as_str());
                let layer_id = uuid(char_id, &format!("layer_box_{}_{}", anim_name, inst_name));

                // Build per-frame keyframes for this instance
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

                // Build run-length keyframes: consecutive frames with same box = one keyframe
                let mut i = 0;
                while i < active_frames.len() {
                    let (start_frame, fb) = active_frames[i];

                    // Find the run length — count consecutive frames where box is present
                    // (frames without this box between start and next occurrence = implicit gap)
                    let next_frame = active_frames.get(i + 1).map(|(f, _)| *f);
                    let run_len = if let Some(nf) = next_frame {
                        (nf - start_frame) as u32
                    } else {
                        total.saturating_sub(start_frame as u32).max(1)
                    };

                    // If there's a gap before this frame, emit an empty/invisible keyframe
                    if start_frame as u32 > frame_idx {
                        let gap_kf_id = uuid(char_id, &format!("kf_box_gap_{}_{}_{}", anim_name, inst_name, frame_idx));
                        keyframes.push(json!({
                            "$id": gap_kf_id,
                            "type": "COLLISION_BOX",
                            "length": (start_frame as u32) - frame_idx,
                            "collisionBoxes": [],
                            "pluginMetadata": {}
                        }));
                        box_kf_ids.push(gap_kf_id);
                        frame_idx = start_frame as u32;
                    }

                    let kf_id = uuid(char_id, &format!("kf_box_{}_{}_{}", anim_name, inst_name, start_frame));
                    // SWF Y axis is down; Fraymakers Y axis is up — negate Y
                    let fm_y = -fb.y - fb.height; // flip: top-left in FM = -(SSF2 top-left + height)
                    keyframes.push(json!({
                        "$id": kf_id,
                        "type": "COLLISION_BOX",
                        "length": run_len,
                        "collisionBoxes": [{
                            "x": round2(fb.x),
                            "y": round2(fm_y),
                            "width": round2(fb.width),
                            "height": round2(fb.height),
                            "angle": 0,
                            "type": box_type.as_str(),
                            "color": box_color(box_type),
                            "flipX": false
                        }],
                        "pluginMetadata": {}
                    }));
                    box_kf_ids.push(kf_id);
                    frame_idx = start_frame as u32 + run_len;
                    i += 1;
                }

                // Fill any remaining frames with empty keyframe
                if frame_idx < total {
                    let tail_kf_id = uuid(char_id, &format!("kf_box_tail_{}_{}_{}", anim_name, inst_name, frame_idx));
                    keyframes.push(json!({
                        "$id": tail_kf_id,
                        "type": "COLLISION_BOX",
                        "length": total - frame_idx,
                        "collisionBoxes": [],
                        "pluginMetadata": {}
                    }));
                    box_kf_ids.push(tail_kf_id);
                }

                if box_kf_ids.is_empty() { continue; }

                layers.push(json!({
                    "$id": layer_id,
                    "name": layer_name,
                    "type": "COLLISION_BOX",
                    "keyframes": box_kf_ids,
                    "hidden": false,
                    "locked": false,
                    "pluginMetadata": {}
                }));
                anim_layer_ids.push(layer_id);
            }
        }

        // ── 5. IMAGE layer ────────────────────────────────────────────────────
        let img_layer_id = uuid(char_id, &format!("layer_image_{}", anim_name));
        let img_kf_id = uuid(char_id, &format!("kf_image_{}", anim_name));
        keyframes.push(json!({
            "$id": img_kf_id,
            "type": "IMAGE",
            "length": frame_count,
            "symbol": Value::Null,
            "tweened": false,
            "tweenType": "LINEAR",
            "pluginMetadata": {}
        }));
        layers.push(json!({
            "$id": img_layer_id,
            "name": "Image",
            "type": "IMAGE",
            "keyframes": [img_kf_id],
            "hidden": false,
            "locked": false,
            "pluginMetadata": {}
        }));
        anim_layer_ids.push(img_layer_id);

        animations.push(json!({
            "$id": anim_id,
            "name": anim_name,
            "layers": anim_layer_ids,
            "pluginMetadata": {}
        }));
    }

    // ── Object declarations (one per unique instance name found in all animations) ──
    let mut objects: Vec<Value> = vec![
        json!({ "$id": uuid(char_id, "obj_body"), "name": "body", "type": "COLLISION_BODY" }),
    ];
    for inst_name in &all_box_instances {
        let bt = BoxType::from_instance_name(inst_name).unwrap_or(BoxType::Hurtbox);
        objects.push(json!({
            "$id": uuid(char_id, &format!("obj_{}", inst_name)),
            "name": inst_name,
            "type": "COLLISION_BOX",
            "boxType": bt.as_str(),
            "color": box_color(bt)
        }));
    }

    let entity = json!({
        "animations": animations,
        "keyframes": keyframes,
        "layers": layers,
        "symbols": [],
        "objects": objects,
        "guid": uuid(char_id, "entity_guid"),
        "id": "character",
        "export": true
    });

    serde_json::to_string_pretty(&entity).unwrap_or_else(|_| "{}".to_string())
}

fn round2(v: f64) -> f64 {
    (v * 100.0).round() / 100.0
}
