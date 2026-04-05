use anyhow::Result;
use serde::{Deserialize, Serialize};
use std::collections::BTreeMap;
use crate::swf_parser::SwfFile;
use crate::abc_parser::{self, AttackData as AbcAttack, CharStats as AbcStats};

// ─── Output types for haxe_gen ───────────────────────────────────────────────

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CharacterData {
    pub name: String,
    pub attacks: Vec<Attack>,
    pub stats: CharacterStats,
    pub animations: BTreeMap<String, AnimationInfo>,
    pub scripts: Vec<ScriptInfo>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Attack {
    pub name: String,           // Fraymakers name (e.g. "aerial_neutral")
    pub ssf2_name: String,      // Original SSF2 name (e.g. "a_air")
    pub hitboxes: Vec<Hitbox>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Hitbox {
    pub damage:           f64,
    pub angle:            f64,
    pub base_knockback:   f64,
    pub knockback_growth: f64,
    pub hitstop:          i32,
    pub self_hitstop:     i32,
    pub hitstun:          i32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CharacterStats {
    pub weight:           f64,
    pub gravity:          f64,
    pub fall_speed:       f64,
    pub fast_fall_speed:  f64,
    pub walk_speed:       f64,
    pub dash_speed:       f64,
    pub air_mobility:     f64,
    pub max_jumps:        i32,
    pub jump_height:      f64,
    pub double_jump_height: f64,
    pub air_friction:     f64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AnimationInfo {
    pub name:   String,
    pub frames: u16,
    pub speed:  f32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ScriptInfo {
    pub name: String,
    pub code: String,
    pub is_ext_method: bool,
}

impl Default for CharacterStats {
    fn default() -> Self {
        Self {
            weight: 100.0, gravity: 0.0, fall_speed: 0.0, fast_fall_speed: 0.0,
            walk_speed: 0.0, dash_speed: 0.0, air_mobility: 0.0,
            max_jumps: 2, jump_height: 0.0, double_jump_height: 0.0, air_friction: 0.0,
        }
    }
}

// ─── Main extraction logic ───────────────────────────────────────────────────

pub fn extract(swf: &SwfFile, char_name: &str) -> Result<CharacterData> {
    log::info!("Extracting character data for '{}'", char_name);

    let mut all_attacks: BTreeMap<String, Vec<Hitbox>> = BTreeMap::new();
    let mut char_stats = CharacterStats::default();
    let mut animations: BTreeMap<String, AnimationInfo> = BTreeMap::new();
    let mut scripts: Vec<ScriptInfo> = Vec::new();

    // Parse each ABC block (usually just one)
    for (block_idx, abc_data) in swf.abc_blocks.iter().enumerate() {
        log::info!("Parsing ABC block {} ({} bytes)", block_idx, abc_data.len());

        match abc_parser::parse(abc_data) {
            Ok(abc) => {
                let extracted = abc_parser::extract_character(&abc, char_name)?;

                // Merge attacks
                for (name, attack_data) in &extracted.attacks {
                    let hitboxes = convert_hitboxes(&attack_data.hitboxes);
                    all_attacks.entry(name.clone()).or_default().extend(hitboxes);
                }

                // Use stats if found
                if let Some(s) = &extracted.stats {
                    char_stats = convert_stats(&s.values);
                }

                // Decompiled Ext methods → Script.hx
                for (method_name, code) in &extracted.ext_methods {
                    scripts.push(ScriptInfo {
                        name: method_name.clone(),
                        code: code.clone(),
                        is_ext_method: true,
                    });
                }

                // Frame scripts → will go to .entity file (not Script.hx)
                for (method_name, actions) in &extracted.frame_scripts {
                    let code = render_frame_script(method_name, actions);
                    scripts.push(ScriptInfo { name: method_name.clone(), code, is_ext_method: false });
                }

                // Extract animation info from symbol names
                for (id, sym_name) in &swf.symbols {
                    if let Some(anim_name) = extract_animation_name(sym_name, char_name) {
                        animations.entry(anim_name.clone()).or_insert(AnimationInfo {
                            name: anim_name,
                            frames: 0,
                            speed: 1.0,
                        });
                    }
                }

                log::info!("ABC block {}: {} attacks, stats={}, {} frame scripts, {} symbols→animations",
                    block_idx,
                    extracted.attacks.len(),
                    extracted.stats.is_some(),
                    extracted.frame_scripts.len(),
                    animations.len(),
                );
            }
            Err(e) => {
                log::warn!("Failed to parse ABC block {}: {}", block_idx, e);
            }
        }
    }

    // Convert attacks map to sorted vec
    let attacks: Vec<Attack> = all_attacks.into_iter().map(|(name, hitboxes)| Attack {
        ssf2_name: name.clone(),
        name: name.clone(),
        hitboxes,
    }).collect();

    log::info!("Total: {} attacks, {} animations extracted", attacks.len(), animations.len());

    Ok(CharacterData {
        name: char_name.to_string(),
        attacks,
        stats: char_stats,
        animations,
        scripts,
    })
}

// ─── Conversion helpers ───────────────────────────────────────────────────────

fn convert_hitboxes(raw: &[BTreeMap<String, f64>]) -> Vec<Hitbox> {
    raw.iter().map(|obj| {
        let get = |k: &str| obj.get(k).copied().unwrap_or(0.0);
        Hitbox {
            damage:           get("damage"),
            angle:            get("direction").max(get("angle")),
            base_knockback:   get("power").max(get("weightKB")),
            knockback_growth: get("kbConstant"),
            hitstop:          get("hitStun") as i32,
            self_hitstop:     get("selfHitStun") as i32,
            hitstun:          get("hitLag") as i32,
        }
    }).collect()
}

fn convert_stats(vals: &BTreeMap<String, f64>) -> CharacterStats {
    // SSF2 key name → Fraymakers field mapping
    // SSF2 stores: weight1, norm_xSpeed (walk), max_xSpeed (dash),
    //              max_ySpeed (fallSpeed), fastFallSpeed, gravity,
    //              accel_rate_air (airMobility), max_jump (double jumps)
    let get = |keys: &[&str]| {
        keys.iter().find_map(|k| vals.get(*k)).copied().unwrap_or(0.0)
    };
    CharacterStats {
        weight:             get(&["weight1", "weight"]),
        gravity:            get(&["gravity"]),
        fall_speed:         get(&["max_ySpeed", "fallSpeed"]),
        fast_fall_speed:    get(&["fastFallSpeed"]),
        walk_speed:         get(&["norm_xSpeed", "walkSpeed"]),
        dash_speed:         get(&["max_xSpeed", "dashSpeed"]),
        air_mobility:       get(&["accel_rate_air", "airMobility"]),
        max_jumps:          get(&["max_jump", "maxJumps"]) as i32 + 1, // SSF2 max_jump=1 = 2 total jumps
        jump_height:        get(&["jumpSpeed", "jumpHeight"]),
        double_jump_height: get(&["jumpSpeedMidair", "doubleJumpHeight"]),
        air_friction:       get(&["decel_rate_air", "airFriction"]),
    }
}

fn render_frame_script(method_name: &str, actions: &[crate::abc_parser::FrameAction]) -> String {
    let mut out = format!("// {}\nfunction {}_framescript(frame:Int) {{\n\tswitch (frame) {{\n", method_name, method_name);
    let mut current_frame = u32::MAX;
    for action in actions {
        if action.frame != current_frame {
            if current_frame != u32::MAX { out.push_str("\t\t}\n"); }
            out.push_str(&format!("\t\tcase {}:\n", action.frame));
            current_frame = action.frame;
        }
        out.push_str(&format!("\t\t\t// SSF2: {}({})\n", action.action, action.args.join(", ")));
    }
    if current_frame != u32::MAX { out.push_str("\t\t}\n"); }
    out.push_str("\t}\n}\n");
    out
}

/// Extract a clean animation name from a symbol like "mario_fla.NAir_40"
fn extract_animation_name(sym_name: &str, char_name: &str) -> Option<String> {
    // Skip non-animation symbols
    if sym_name.contains('.') {
        // "mario_fla.NAir_40" → "NAir_40"
        let local = sym_name.split('.').last()?;
        // Strip trailing _NNN frame number
        let name = local.trim_end_matches(|c: char| c.is_numeric() || c == '_');
        if name.is_empty() || name.len() < 2 { return None; }
        return Some(name.to_lowercase());
    }
    None
}
