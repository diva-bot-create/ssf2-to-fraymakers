/// Fraymakers .entity file generator
///
/// Generates the JSON entity file used by FrayTools for sprite animation, layering,
/// and collision data. Structure based on kung-fu-man reference character.

use crate::extractor::CharacterData;
use serde_json::{json, Value};
use std::collections::BTreeMap;

/// Generate a deterministic UUID from a seed string.
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

pub fn generate_entity(data: &CharacterData, char_id: &str) -> String {
    let mut keyframes: Vec<Value> = Vec::new();
    let mut layers: Vec<Value> = Vec::new();
    let mut animations: Vec<Value> = Vec::new();

    // Build frame script map: anim_name -> code
    let mut frame_script_map: BTreeMap<String, String> = BTreeMap::new();
    // NOTE: SSF2 frame script names are "frame1", "frame10", etc. — global timeline frame numbers.
    // Without knowing each animation's frame range on the SSF2 timeline, we cannot auto-assign
    // frame scripts to specific animations. FRAME_SCRIPT keyframes are left empty for manual assignment.
    for script in &data.scripts {
        if !script.is_ext_method {
            let anim_name = if script.name.starts_with("frame") {
                script.name[5..].to_lowercase()
            } else {
                script.name.to_lowercase()
            };
            frame_script_map.insert(anim_name.clone(), script.code.clone());
        }
    }

    for (anim_name, anim_info) in &data.animations {
        let frame_count = (anim_info.frames as u32).max(1);
        let anim_id = uuid(char_id, &format!("anim_{}", anim_name));

        // 1. LABEL layer
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

        // 2. FRAME_SCRIPT layer
        let script_layer_id = uuid(char_id, &format!("layer_script_{}", anim_name));
        let script_kf_id = uuid(char_id, &format!("kf_script_{}", anim_name));
        let script_code = frame_script_map.get(anim_name).map(|s| s.as_str()).unwrap_or("");
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

        // 3. COLLISION_BODY layer (hurtbox)
        let body_layer_id = uuid(char_id, &format!("layer_body_{}", anim_name));
        let body_kf_id = uuid(char_id, &format!("kf_body_{}", anim_name));
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

        // 4. IMAGE layer
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

        animations.push(json!({
            "$id": anim_id,
            "name": anim_name,
            "layers": [label_layer_id, script_layer_id, body_layer_id, img_layer_id],
            "pluginMetadata": {}
        }));
    }

    // Collision objects
    let objects = vec![
        json!({ "$id": uuid(char_id, "obj_hurtbox"), "name": "hurtbox", "type": "COLLISION_BODY" }),
        json!({ "$id": uuid(char_id, "obj_hitbox_1"), "name": "hitbox_1", "type": "COLLISION_BOX" }),
    ];

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
