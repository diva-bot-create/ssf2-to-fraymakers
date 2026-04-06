/// SSF2 → Fraymakers API mapping table.
///
/// SSF2 (ActionScript 3) uses a MovieClip timeline model with SSF2API/SSF2Character
/// wrappers. Fraymakers uses Haxe with Entity/Character/GameObject class hierarchy.
///
/// This module provides:
///   1. Method-level mappings (SSF2 call → FM equivalent)
///   2. Property mappings (SSF2 property access → FM getter/setter)
///   3. Constant mappings (SSF2 state constants → FM CState/etc)
///   4. Pattern-level transformations (multi-statement → single FM call)

use std::collections::BTreeMap;

// ─── Method Mappings ──────────────────────────────────────────────────────────
// (ssf2_receiver, ssf2_method) → (fm_receiver, fm_method, note)
// receiver = "" means static/global, "self" means self.self in SSF2 → self in FM

#[derive(Debug, Clone)]
pub struct MethodMapping {
    pub fm_receiver: &'static str,    // "" = same receiver, "self" = entity self
    pub fm_method: &'static str,
    pub arg_transform: ArgTransform,
    pub note: &'static str,
}

#[derive(Debug, Clone)]
pub enum ArgTransform {
    /// Pass args through unchanged
    Identity,
    /// Drop all args
    NoArgs,
    /// Remap arg indices: e.g. [1, 0] means swap first two
    Reorder(Vec<usize>),
    /// First N args only
    TakeFirst(usize),
    /// Custom transformation tag (handled in code)
    Custom(&'static str),
}

pub fn build_method_map() -> BTreeMap<(&'static str, &'static str), MethodMapping> {
    let mut m = BTreeMap::new();
    let id = ArgTransform::Identity;

    // ── SSF2Character → FM Character/Entity ──────────────────────────────

    // Movement & State
    m.insert(("", "endAttack"), MethodMapping {
        fm_receiver: "self", fm_method: "endAnimation",
        arg_transform: ArgTransform::NoArgs,
        note: "SSF2 endAttack() → FM endAnimation()",
    });
    m.insert(("", "setState"), MethodMapping {
        fm_receiver: "self", fm_method: "toState",
        arg_transform: id.clone(),
        note: "SSF2 setState(state) → FM toState(state)",
    });
    m.insert(("", "inState"), MethodMapping {
        fm_receiver: "self", fm_method: "inState",
        arg_transform: id.clone(),
        note: "",
    });
    m.insert(("", "isFacingRight"), MethodMapping {
        fm_receiver: "self", fm_method: "isFacingRight",
        arg_transform: ArgTransform::NoArgs,
        note: "",
    });
    m.insert(("", "isFacingLeft"), MethodMapping {
        fm_receiver: "self", fm_method: "isFacingLeft",
        arg_transform: ArgTransform::NoArgs,
        note: "",
    });

    // Position / velocity
    m.insert(("", "getX"), MethodMapping {
        fm_receiver: "self", fm_method: "getX",
        arg_transform: ArgTransform::NoArgs, note: "",
    });
    m.insert(("", "getY"), MethodMapping {
        fm_receiver: "self", fm_method: "getY",
        arg_transform: ArgTransform::NoArgs, note: "",
    });
    m.insert(("", "setX"), MethodMapping {
        fm_receiver: "self", fm_method: "setX",
        arg_transform: id.clone(), note: "",
    });
    m.insert(("", "setY"), MethodMapping {
        fm_receiver: "self", fm_method: "setY",
        arg_transform: id.clone(), note: "",
    });
    m.insert(("", "setXSpeed"), MethodMapping {
        fm_receiver: "self", fm_method: "setXVelocity",
        arg_transform: id.clone(), note: "SSF2 setXSpeed → FM setXVelocity",
    });
    m.insert(("", "setYSpeed"), MethodMapping {
        fm_receiver: "self", fm_method: "setYVelocity",
        arg_transform: id.clone(), note: "SSF2 setYSpeed → FM setYVelocity",
    });
    m.insert(("", "getXSpeed"), MethodMapping {
        fm_receiver: "self", fm_method: "getXVelocity",
        arg_transform: ArgTransform::NoArgs, note: "",
    });
    m.insert(("", "getYSpeed"), MethodMapping {
        fm_receiver: "self", fm_method: "getYVelocity",
        arg_transform: ArgTransform::NoArgs, note: "",
    });

    // Hitbox / Attack
    m.insert(("", "updateAttackBoxStats"), MethodMapping {
        fm_receiver: "self", fm_method: "updateHitboxStats",
        arg_transform: id.clone(),
        note: "SSF2 updateAttackBoxStats(id, stats) → FM updateHitboxStats(id, stats)",
    });
    m.insert(("", "refreshAttackID"), MethodMapping {
        fm_receiver: "self", fm_method: "reactivateHitboxes",
        arg_transform: ArgTransform::NoArgs,
        note: "SSF2 refreshAttackID → FM reactivateHitboxes",
    });

    // Animation
    m.insert(("", "gotoAndPlay"), MethodMapping {
        fm_receiver: "self", fm_method: "playAnimation",
        arg_transform: id.clone(),
        note: "SSF2 gotoAndPlay(label) → FM playAnimation(name)",
    });
    m.insert(("", "gotoAndStop"), MethodMapping {
        fm_receiver: "self", fm_method: "playAnimation",
        arg_transform: id.clone(),
        note: "SSF2 gotoAndStop(label) → FM playAnimation(name) /* TODO: stop after */",
    });
    m.insert(("", "play"), MethodMapping {
        fm_receiver: "self", fm_method: "resume",
        arg_transform: ArgTransform::NoArgs,
        note: "",
    });
    m.insert(("", "stop"), MethodMapping {
        fm_receiver: "self", fm_method: "pause",
        arg_transform: ArgTransform::NoArgs,
        note: "",
    });

    // Controls
    m.insert(("", "getControls"), MethodMapping {
        fm_receiver: "self", fm_method: "getHeldControls",
        arg_transform: ArgTransform::NoArgs,
        note: "SSF2 getControls → FM getHeldControls",
    });
    m.insert(("", "getPressedControls"), MethodMapping {
        fm_receiver: "self", fm_method: "getPressedControls",
        arg_transform: ArgTransform::NoArgs, note: "",
    });

    // Grabbing
    m.insert(("", "grab"), MethodMapping {
        fm_receiver: "self", fm_method: "attemptGrab",
        arg_transform: id.clone(),
        note: "SSF2 grab(target) → FM attemptGrab(foe)",
    });
    m.insert(("", "shootOutOpponent"), MethodMapping {
        fm_receiver: "self", fm_method: "releaseAllCharacters",
        arg_transform: ArgTransform::NoArgs,
        note: "",
    });

    // Projectile
    m.insert(("", "fireProjectile"), MethodMapping {
        fm_receiver: "self", fm_method: "/* TODO: spawn projectile */",
        arg_transform: id.clone(),
        note: "SSF2 fireProjectile needs manual conversion — FM uses CustomGameObject",
    });

    // Scale
    m.insert(("", "getScaleX"), MethodMapping {
        fm_receiver: "self", fm_method: "getScaleX",
        arg_transform: ArgTransform::NoArgs, note: "",
    });
    m.insert(("", "getScaleY"), MethodMapping {
        fm_receiver: "self", fm_method: "getScaleY",
        arg_transform: ArgTransform::NoArgs, note: "",
    });
    m.insert(("", "setScaleX"), MethodMapping {
        fm_receiver: "self", fm_method: "setScaleX",
        arg_transform: id.clone(), note: "",
    });
    m.insert(("", "setScaleY"), MethodMapping {
        fm_receiver: "self", fm_method: "setScaleY",
        arg_transform: id.clone(), note: "",
    });

    // Visibility
    m.insert(("", "setVisible"), MethodMapping {
        fm_receiver: "self", fm_method: "setVisible",
        arg_transform: id.clone(), note: "",
    });

    // Damage
    m.insert(("", "getDamage"), MethodMapping {
        fm_receiver: "self", fm_method: "getDamage",
        arg_transform: ArgTransform::NoArgs, note: "",
    });
    m.insert(("", "addDamage"), MethodMapping {
        fm_receiver: "self", fm_method: "addDamage",
        arg_transform: id.clone(), note: "",
    });

    // Events
    m.insert(("", "addEventListener"), MethodMapping {
        fm_receiver: "self", fm_method: "addEventListener",
        arg_transform: id.clone(), note: "Event types need remapping",
    });
    m.insert(("", "removeEventListener"), MethodMapping {
        fm_receiver: "self", fm_method: "removeEventListener",
        arg_transform: id.clone(), note: "",
    });

    // ── SSF2API static methods → FM equivalents ──────────────────────────

    m.insert(("SSF2API", "print"), MethodMapping {
        fm_receiver: "", fm_method: "Engine.log",
        arg_transform: id.clone(),
        note: "SSF2API.print → Engine.log",
    });
    m.insert(("SSF2API", "random"), MethodMapping {
        fm_receiver: "", fm_method: "Random.getFloat",
        arg_transform: ArgTransform::Custom("random_0_1"),
        note: "SSF2API.random() → Random.getFloat(0, 1)",
    });
    m.insert(("SSF2API", "randomInteger"), MethodMapping {
        fm_receiver: "", fm_method: "Random.getInt",
        arg_transform: id.clone(),
        note: "SSF2API.randomInteger(min,max) → Random.getInt(min,max)",
    });
    m.insert(("SSF2API", "getElapsedFrames"), MethodMapping {
        fm_receiver: "", fm_method: "Engine.getElapsedFrames",
        arg_transform: ArgTransform::NoArgs,
        note: "",
    });
    m.insert(("SSF2API", "isReady"), MethodMapping {
        fm_receiver: "", fm_method: "true /* SSF2API.isReady always true in FM */",
        arg_transform: ArgTransform::NoArgs,
        note: "Guard check — FM is always ready",
    });
    m.insert(("SSF2API", "playSound"), MethodMapping {
        fm_receiver: "self", fm_method: "/* TODO: playSound */",
        arg_transform: id.clone(),
        note: "SSF2API.playSound → FM AudioClip or entity sfx",
    });
    m.insert(("SSF2API", "stopSound"), MethodMapping {
        fm_receiver: "", fm_method: "/* TODO: stopSound */",
        arg_transform: id.clone(), note: "",
    });
    m.insert(("SSF2API", "shakeCamera"), MethodMapping {
        fm_receiver: "", fm_method: "Camera.shake",
        arg_transform: id.clone(),
        note: "SSF2API.shakeCamera(intensity) → Camera.shake(...)",
    });
    m.insert(("SSF2API", "lightFlash"), MethodMapping {
        fm_receiver: "", fm_method: "/* TODO: lightFlash */",
        arg_transform: id.clone(), note: "No direct FM equivalent",
    });
    m.insert(("SSF2API", "getCharacter"), MethodMapping {
        fm_receiver: "", fm_method: "/* TODO: getCharacter */",
        arg_transform: id.clone(), note: "FM uses Match.getCharacters()",
    });
    m.insert(("SSF2API", "getCharacters"), MethodMapping {
        fm_receiver: "", fm_method: "Match.getCharacters",
        arg_transform: ArgTransform::NoArgs, note: "",
    });
    m.insert(("SSF2API", "attachEffect"), MethodMapping {
        fm_receiver: "", fm_method: "/* TODO: Vfx.spawn */",
        arg_transform: id.clone(),
        note: "SSF2API.attachEffect → FM Vfx system",
    });

    m
}

// ─── Property Mappings ────────────────────────────────────────────────────────
// SSF2 property name → (FM getter, FM setter)

pub fn build_property_map() -> BTreeMap<&'static str, (&'static str, &'static str)> {
    let mut m = BTreeMap::new();

    // SSF2 → FM property mappings
    m.insert("x",           ("getX()",          "setX"));
    m.insert("y",           ("getY()",          "setY"));
    m.insert("scaleX",      ("getScaleX()",     "setScaleX"));
    m.insert("scaleY",      ("getScaleY()",     "setScaleY"));
    m.insert("alpha",       ("getAlpha()",      "setAlpha"));
    m.insert("visible",     ("getVisible()",    "setVisible"));
    m.insert("rotation",    ("getRotation()",   "setRotation"));
    m.insert("currentFrame",("getCurrentFrame()", "playFrame"));

    m
}

// ─── SSF2 State → FM CState Mappings ──────────────────────────────────────────

pub fn build_state_map() -> BTreeMap<&'static str, &'static str> {
    let mut m = BTreeMap::new();

    // SSF2 CState / character states → FM CState constants
    // SSF2 uses numeric values; FM uses CState.CONSTANT
    m.insert("IDLE",            "CState.STAND");
    m.insert("STAND",          "CState.STAND");
    m.insert("WALK",           "CState.WALK_LOOP");
    m.insert("RUN",            "CState.RUN");
    m.insert("DASH",           "CState.DASH");
    m.insert("JUMP",           "CState.JUMP_IN");
    m.insert("JUMP_SQUAT",    "CState.JUMP_SQUAT");
    m.insert("FALL",           "CState.FALL");
    m.insert("FALL_SPECIAL",   "CState.FALL_SPECIAL");
    m.insert("LAND",           "CState.LAND");
    m.insert("CROUCH",         "CState.CROUCH_LOOP");
    m.insert("SHIELD",         "CState.SHIELD_LOOP");

    // Attacks
    m.insert("JAB",            "CState.JAB");
    m.insert("JAB1",           "CState.JAB");
    m.insert("JAB2",           "CState.JAB");
    m.insert("JAB3",           "CState.JAB");
    m.insert("DASH_ATTACK",    "CState.DASH_ATTACK");
    m.insert("TILT_FORWARD",   "CState.TILT_FORWARD");
    m.insert("TILT_UP",        "CState.TILT_UP");
    m.insert("TILT_DOWN",      "CState.TILT_DOWN");
    m.insert("STRONG_FORWARD", "CState.STRONG_FORWARD_ATTACK");
    m.insert("STRONG_UP",      "CState.STRONG_UP_ATTACK");
    m.insert("STRONG_DOWN",    "CState.STRONG_DOWN_ATTACK");
    m.insert("AERIAL_NEUTRAL", "CState.AERIAL_NEUTRAL");
    m.insert("AERIAL_FORWARD", "CState.AERIAL_FORWARD");
    m.insert("AERIAL_BACK",    "CState.AERIAL_BACK");
    m.insert("AERIAL_UP",      "CState.AERIAL_UP");
    m.insert("AERIAL_DOWN",    "CState.AERIAL_DOWN");
    m.insert("SPECIAL_NEUTRAL","CState.SPECIAL_NEUTRAL");
    m.insert("SPECIAL_SIDE",   "CState.SPECIAL_SIDE");
    m.insert("SPECIAL_UP",     "CState.SPECIAL_UP");
    m.insert("SPECIAL_DOWN",   "CState.SPECIAL_DOWN");
    m.insert("GRAB",           "CState.GRAB");
    m.insert("GRAB_HOLD",      "CState.GRAB_HOLD");
    m.insert("THROW_FORWARD",  "CState.THROW_FORWARD");
    m.insert("THROW_BACK",     "CState.THROW_BACK");
    m.insert("THROW_UP",       "CState.THROW_UP");
    m.insert("THROW_DOWN",     "CState.THROW_DOWN");

    // Defense
    m.insert("SHIELD_IN",     "CState.SHIELD_IN");
    m.insert("SHIELD_OUT",    "CState.SHIELD_OUT");
    m.insert("ROLL",          "CState.ROLL");
    m.insert("SPOT_DODGE",    "CState.SPOT_DODGE");
    m.insert("PARRY",         "CState.PARRY_IN");

    // Hurt / KO
    m.insert("HURT",           "CState.HURT_LIGHT");
    m.insert("TUMBLE",         "CState.TUMBLE");
    m.insert("KO",             "CState.KO");

    // Ledge
    m.insert("LEDGE_IN",      "CState.LEDGE_IN");
    m.insert("LEDGE_LOOP",    "CState.LEDGE_LOOP");
    m.insert("LEDGE_CLIMB",   "CState.LEDGE_CLIMB");
    m.insert("LEDGE_ATTACK",  "CState.LEDGE_ATTACK");
    m.insert("LEDGE_ROLL",    "CState.LEDGE_ROLL");
    m.insert("LEDGE_JUMP",    "CState.LEDGE_JUMP");

    m
}

// ─── SSF2 Event → FM GameObjectEvent Mappings ─────────────────────────────────

pub fn build_event_map() -> BTreeMap<&'static str, &'static str> {
    let mut m = BTreeMap::new();

    m.insert("STATE_CHANGE",     "GameObjectEvent.LINK_FRAMES");
    m.insert("HIT",             "GameObjectEvent.HIT_DEALT");
    m.insert("HIT_RECEIVED",    "GameObjectEvent.HIT_RECEIVED");
    m.insert("LAND",            "GameObjectEvent.LAND");
    m.insert("GRAB",            "GameObjectEvent.GRAB_DEALT");
    m.insert("GRAB_RECEIVED",   "GameObjectEvent.GRAB_RECEIVED");
    m.insert("SHIELD_HIT",     "GameObjectEvent.SHIELD_HIT_DEALT");
    m.insert("HITSTOP_START",   "GameObjectEvent.ENTER_HITSTOP");
    m.insert("HITSTOP_END",     "GameObjectEvent.EXIT_HITSTOP");
    m.insert("LEFT_GROUND",     "GameObjectEvent.LEFT_GROUND");

    m
}

// ─── SSF2 Hitbox Property → FM HitboxStats Property Mappings ──────────────────

pub fn build_hitbox_prop_map() -> BTreeMap<&'static str, &'static str> {
    let mut m = BTreeMap::new();

    m.insert("damage",         "damage");
    m.insert("direction",      "angle");
    m.insert("power",          "baseKnockback");
    m.insert("kbGrowth",       "knockbackGrowth");
    m.insert("kbConstant",     "baseKnockback");
    m.insert("hitStun",        "hitstun");
    m.insert("selfHitStun",    "selfHitstop");
    m.insert("shieldDamage",   "shieldDamageMultiplier");
    m.insert("priority",       "/* TODO: no FM equivalent for priority */");
    m.insert("hitSound",       "attackStrength");
    m.insert("refreshRate",    "/* TODO: no FM equivalent for refreshRate */");

    m
}

// ─── SSF2 "self.self" Pattern ──────────────────────────────────────────────────
// In decompiled SSF2 sub-MC code, "self.self" refers to the character instance.
// In Fraymakers, the Script.hx `self` already IS the character/entity.
// So "self.self.endAttack()" → "self.endAnimation()"
//
// This is handled at the text level in the post-processor.

/// Apply text-level SSF2→FM API translations to decompiled Haxe code.
/// This is a post-processing step run on the output of the decompiler.
pub fn translate_ssf2_to_fm(code: &str) -> String {
    let mut result = code.to_string();

    // ── self.self → self ──
    // SSF2 sub-MC closures capture the character as "self.self"
    // The assignment `self.self = /* ? */` is the sub-MC saving a ref to parent character.
    // In FM, Script.hx `self` already IS the character, so this is a no-op we can elide.
    result = result.replace("self.self = /* ? */;", "// self reference (implicit in FM)");
    result = result.replace("self.self = /* ? */", "self /* parent character */");
    result = result.replace("self.self.", "self.");
    // Also handle: if (SSF2API.isReady() && self.self) → if (true)
    // "SSF2API.isReady() && self.self" pattern → just drop the self.self check
    result = result.replace("&& self.self)", ")");
    result = result.replace("if (true && self.self)", "if (true /* FM: self always valid */)");
    // Other self.self null-guard patterns
    result = result.replace("|| self.self)", ") /* self always valid */");
    result = result.replace("if ((self.self && true)", "if ((true /* self always valid */)");
    // Also handle (self.self && true) without if prefix
    result = result.replace("(self.self && true)", "(true /* self always valid */)");
    // Final catch-all: any remaining self.self that wasn't a method call (boolean checks etc)
    result = result.replace("self.self", "self /* was self.self */");
    result = result.replace("if (self.self && ", "if (/* self always valid */ true && ");
    result = result.replace("|| self.self", " /* || self always valid */");

    // ── SSF2API static calls ──
    result = result.replace("SSF2API.print(", "Engine.log(");
    result = result.replace("SSF2API.isReady()", "true");
    result = result.replace("SSF2API.random()", "Random.getFloat(0, 1)");
    result = result.replace("SSF2API.randomInteger(", "Random.getInt(");
    result = result.replace("SSF2API.getElapsedFrames()", "Engine.getElapsedFrames()");
    result = result.replace("SSF2API.getCharacters()", "Match.getCharacters()");

    // ── Method renames ──
    result = result.replace(".endAttack()", ".endAnimation()");
    result = result.replace(".refreshAttackID()", ".reactivateHitboxes()");
    result = result.replace(".updateAttackBoxStats(", ".updateHitboxStats(");
    result = result.replace(".getControls()", ".getHeldControls()");
    result = result.replace(".setXSpeed(", ".setXVelocity(");
    result = result.replace(".setYSpeed(", ".setYVelocity(");
    result = result.replace(".getXSpeed()", ".getXVelocity()");
    result = result.replace(".getYSpeed()", ".getYVelocity()");

    // ── SSF2 global variable pattern ──
    // self.setGlobalVariable("key", val) → self.setCustomVar("key", val) or metadata
    result = result.replace(".setGlobalVariable(", ".updateAnimationStatsMetadata(/* TODO: setGlobalVariable */ ");
    result = result.replace(".getGlobalVariable(", ".getAnimationStatsMetadata(/* TODO: getGlobalVariable */ ");

    // ── Sound calls ──
    result = result.replace(".playVoiceSound(", ".playAttackVoice(/* voice index: */");
    result = result.replace(".playSoundFX(", "/* TODO: playSoundFX */Engine.playAudio(");

    // ── Event types ──
    result = result.replace("SSF2Event.STATE_CHANGE", "GameObjectEvent.LINK_FRAMES");
    result = result.replace("SSF2Event.HIT", "GameObjectEvent.HIT_DEALT");
    result = result.replace("SSF2Event.LAND", "GameObjectEvent.LAND");

    // ── Timer/effect patterns ──
    result = result.replace(".createTimer(", ".addTimer(");
    result = result.replace(".destroyTimer(", ".removeTimer(");
    result = result.replace(".removeAllEffects()", "/* TODO: removeAllEffects */");
    result = result.replace(".addEffectToList(", "/* TODO: addEffectToList */ ");

    // ── Hitbox property renames in object literals ──
    result = result.replace("direction:", "angle:");
    result = result.replace("power:", "baseKnockback:");
    result = result.replace("kbGrowth:", "knockbackGrowth:");
    result = result.replace("kbConstant:", "baseKnockback:");
    result = result.replace("hitStun:", "hitstun:");
    result = result.replace("selfHitStun:", "selfHitstop:");

    result
}

/// Load SSF2→FM method mappings from the JSON file at `mappings/api_methods.json`
/// relative to the project root. Falls back to empty map if file not found.
pub fn load_api_methods_json(mappings_dir: &std::path::Path) -> Vec<(String, String)> {
    let path = mappings_dir.join("api_methods.json");
    let Ok(text) = std::fs::read_to_string(&path) else { return vec![]; };
    let mut pairs = Vec::new();
    // Simple JSON scan: extract "method_name": { "fm": "replacement" ... } pairs
    // We use a regex-free approach: scan for quoted keys and their fm values
    let mut pos = 0;
    let bytes = text.as_bytes();
    while pos < bytes.len() {
        // Find a key (method name) — bare string between quotes
        if let Some(key_start) = text[pos..].find('"') {
            let abs_ks = pos + key_start + 1;
            if let Some(key_end) = text[abs_ks..].find('"') {
                let key = &text[abs_ks..abs_ks + key_end];
                let after_key = abs_ks + key_end + 1;
                // Look for {"fm": "..."}  nearby
                if let Some(obj_start) = text[after_key..].find('{') {
                    let abs_os = after_key + obj_start;
                    if let Some(obj_end) = text[abs_os..].find('}') {
                        let obj = &text[abs_os..abs_os + obj_end + 1];
                        if let Some(fm_pos) = obj.find("\"fm\"") {
                            let after_fm = abs_os + fm_pos + 4;
                            if let Some(val_start) = text[after_fm..].find('"') {
                                let abs_vs = after_fm + val_start + 1;
                                if let Some(val_end) = text[abs_vs..].find('"') {
                                    let fm_val = &text[abs_vs..abs_vs + val_end];
                                    // Only include if key is a valid method name (no spaces, no slashes)
                                    if !key.contains(' ') && !key.contains('/') && !key.starts_with('_') {
                                        pairs.push((key.to_string(), fm_val.to_string()));
                                    }
                                    pos = abs_vs + val_end + 1;
                                    continue;
                                }
                            }
                        }
                        pos = abs_os + obj_end + 1;
                        continue;
                    }
                }
                pos = after_key;
                continue;
            }
        }
        break;
    }
    pairs
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_basic_translations() {
        let input = r#"self.self.endAttack();
SSF2API.print("hello");
self.self.updateAttackBoxStats(1, { damage: 5, direction: 45, power: 10 });
SSF2API.isReady()
self.self.refreshAttackID();"#;

        let output = translate_ssf2_to_fm(input);
        assert!(output.contains("self.endAnimation()"));
        assert!(output.contains("Engine.log(\"hello\")"));
        assert!(output.contains("self.updateHitboxStats(1, { damage: 5, angle: 45, baseKnockback: 10 })"));
        assert!(output.contains("true"));
        assert!(output.contains("self.reactivateHitboxes()"));
    }
}
