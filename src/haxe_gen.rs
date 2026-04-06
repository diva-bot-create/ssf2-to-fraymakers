/// Fraymakers character file generator.
/// Produces output matching the official character-template structure:
/// https://github.com/Fraymakers/character-template
/// Reference character: https://github.com/ZacharyClayton721/kung-fu-man-fraymakers

use anyhow::Result;
use std::fs;
use std::path::Path;
use crate::extractor::{CharacterData, Hitbox};
use crate::entity_gen;
use crate::fraytools_project;
use crate::palette_gen;
use crate::uuid_gen::det_uuid;

pub fn generate(output_dir: &Path, char_name: &str, data: &CharacterData, sprite_boxes: &std::collections::BTreeMap<String, crate::sprite_parser::AnimationBoxData>, img_result: &crate::image_extractor::ImageExtractionResult, costumes_json: Option<&Path>, sounds: &[crate::sound_extractor::SoundEntry]) -> Result<()> {
    let char_id = char_name.to_lowercase().replace(" ", "");
    let char_dir = output_dir.join(&char_id);
    let scripts_dir = char_dir.join("library/scripts/Character");
    fs::create_dir_all(&scripts_dir)?;

    log::info!("Generating Fraymakers character package in {}", char_dir.display());

    fs::write(scripts_dir.join("HitboxStats.hx"),   generate_hitbox_stats(data, &char_id))?;
    fs::write(scripts_dir.join("CharacterStats.hx"), generate_character_stats(data, &char_id))?;
    fs::write(scripts_dir.join("AnimationStats.hx"), generate_animation_stats(data))?;
    fs::write(scripts_dir.join("Script.hx"),         generate_script(data, &char_id))?;

    // .fraytools project file
    fs::write(char_dir.join(format!("{}.fraytools", char_name)), fraytools_project::generate_fraytools_project(char_name))?;

    // manifest.json (based on character-template)
    fs::write(char_dir.join("library/manifest.json"), generate_manifest(&char_id, char_name))?;

    // Character.entity
    let entities_dir = char_dir.join("library/entities");
    fs::create_dir_all(&entities_dir)?;
    fs::write(entities_dir.join("Character.entity"), entity_gen::generate_entity(data, &char_id, sprite_boxes, img_result))?;

    // Generate .meta sidecar files for each sprite PNG
    let meta_guids = entity_gen::get_image_meta_guids(&char_id, img_result);
    let sprites_dir = char_dir.join("library/sprites");
    let mut meta_count = 0;
    for (png_rel_path, guid) in &meta_guids {
        let meta_path = sprites_dir.join(format!("{}.meta", png_rel_path.trim_start_matches("library/sprites/")));
        if let Some(parent) = meta_path.parent() {
            fs::create_dir_all(parent)?;
        }
        fs::write(&meta_path, entity_gen::generate_meta(guid))?;
        meta_count += 1;
    }
    log::info!("Generated {} .meta sidecar files", meta_count);

    // ── Palette / costumes ──────────────────────────────────────────────────
    match palette_gen::generate_palettes_and_remap(&char_id, char_name, &sprites_dir, costumes_json) {
        Ok(pal) => {
            // costumes.palettes + .meta
            fs::write(char_dir.join("library/costumes.palettes"), &pal.palettes_json)?;
            fs::write(char_dir.join("library/costumes.palettes.meta"), &pal.palettes_meta_json)?;
            // palette_preview.png + .meta (reference image for the R/G map shader)
            fs::write(sprites_dir.join("palette_preview.png"), &pal.preview_png)?;
            fs::write(sprites_dir.join("palette_preview.png.meta"), &pal.preview_meta_json)?;
            // Write the entity with the paletteMap filled in
            let entity_json = entity_gen::generate_entity_with_palette(
                data, &char_id, sprite_boxes, img_result,
                &pal.collection_guid, &pal.base_map_id,
            );
            fs::write(entities_dir.join("Character.entity"), entity_json)?;
        }
        Err(e) => {
            log::warn!("palette_gen failed (sprites will have no palette): {}", e);
        }
    }

    // Stats summary for debugging
    let stats_json = serde_json::json!({
        "char_id": char_id,
        "display_name": char_name,
        "attacks_extracted": data.attacks.len(),
        "stats_extracted": data.stats.weight != 0.0,
        "animations": data.animations.len(),
        "frame_scripts": data.scripts.len(),
        "ssf2_to_fm_anim": data.ssf2_to_fm_anim,
    });
    fs::write(char_dir.join("conversion_stats.json"), serde_json::to_string_pretty(&stats_json)?)?;

    // ── Sound content entries ─────────────────────────────────────────────────────────────────
    if !sounds.is_empty() {
        generate_sound_entries(&char_dir, char_name, sounds)?;
        log::info!("Generated sound entries for {} sounds", sounds.len());
    }

    log::info!("Generated: {} attacks, {} animations, {} frame scripts",
        data.attacks.len(), data.animations.len(), data.scripts.len());
    Ok(())
}

// ─── SSF2 → Fraymakers stat scaling ─────────────────────────────────────────
// SSF2 uses pixel-per-frame units at 60fps.
// Fraymakers uses its own unit system. Approximate conversions based on
// studying template characters vs SSF2 data.

fn ssf2_gravity_to_fm(v: f64) -> f64 { (v / 1.3 * 0.84).max(0.3) }
fn ssf2_speed_to_fm(v: f64) -> f64   { (v / 13.0 * 9.25).max(0.5) }
fn ssf2_jump_to_fm(v: f64) -> f64    { (v / 17.4 * 15.0).max(5.0) }
fn ssf2_walk_to_fm(v: f64) -> f64    { (v / 4.0 * 3.25).max(1.0) }
fn ssf2_dash_to_fm(v: f64) -> f64    { (v / 11.0 * 8.5).max(2.0) }
fn ssf2_air_to_fm(v: f64) -> f64     { (v.abs() / 0.15 * 0.20).max(0.05) }

fn fmt(v: f64) -> String {
    if v == v.round() && v.abs() < 1000.0 {
        format!("{}", v as i64)
    } else {
        format!("{:.2}", v).trim_end_matches('0').trim_end_matches('.').to_string()
    }
}

// ─── HitboxStats.hx ─────────────────────────────────────────────────────────

fn generate_hitbox_stats(data: &CharacterData, char_id: &str) -> String {
    let attack_lookup: std::collections::BTreeMap<_, _> = data.attacks.iter()
        .map(|a| (a.name.as_str(), a))
        .collect();

    let mut out = format!(
        "// Hitbox stats for {} — converted from SSF2\n\
        // SSF2 field mapping:\n\
        //   damage → damage\n\
        //   direction → angle\n\
        //   power/weightKB → baseKnockback\n\
        //   kbConstant → knockbackGrowth\n\
        //   hitStun → hitstop  (frames of freeze on hit)\n\
        //   selfHitStun → selfHitstop\n\
        //   hitLag → hitstun   (frames victim can't act)\n\
        // limb values inferred from move type — review before use.\n\
        {{\n",
        data.name
    );

    let sections: &[(&str, &[&str])] = &[
        ("LIGHT ATTACKS",  &["jab1","jab2","jab3","dash_attack","tilt_forward","tilt_up","tilt_down"]),
        ("STRONG ATTACKS", &["strong_forward_attack","strong_up_attack","strong_down_attack"]),
        ("AERIAL ATTACKS", &["aerial_neutral","aerial_forward","aerial_back","aerial_up","aerial_down"]),
        ("SPECIAL ATTACKS",&["special_neutral","special_neutral_air","special_side","special_side_air","special_up","special_up_air","special_down","special_down_air"]),
        ("THROWS",         &["throw_up","throw_down","throw_forward","throw_back"]),
        ("MISC ATTACKS",   &["ledge_attack","crash_attack","emote"]),
    ];

    let standard: std::collections::HashSet<&str> = sections.iter()
        .flat_map(|(_, moves)| moves.iter().copied()).collect();

    for (section, moves) in sections {
        out.push_str(&format!("\n\t//{}\n", section));
        for &move_name in *moves {
            if let Some(attack) = attack_lookup.get(move_name) {
                out.push_str(&format_attack(move_name, &attack.hitboxes, false));
            } else if move_name == "emote" {
                out.push_str("\temote: {\n\t\thitbox0: {}\n\t},\n");
            } else {
                out.push_str(&format_attack_todo(move_name));
            }
        }
    }

    // Extra attacks from SSF2 that don't map to standard moves
    let extras: Vec<_> = data.attacks.iter()
        .filter(|a| !standard.contains(a.name.as_str())).collect();
    if !extras.is_empty() {
        out.push_str("\n\t//SSF2-SPECIFIC (no direct Fraymakers equivalent — map or remove)\n");
        for attack in extras {
            out.push_str(&format_attack(&attack.name, &attack.hitboxes, true));
        }
    }

    out.push_str("}\n");
    out
}

fn guess_limb(move_name: &str) -> &'static str {
    let m = move_name;
    if m.contains("throw")    { return "AttackLimb.BODY"; }
    if m.contains("down")     { return "AttackLimb.FOOT"; }
    if m.contains("aerial")   { return "AttackLimb.FOOT"; }
    if m.contains("tilt_up") || m.contains("strong_up") { return "AttackLimb.FIST"; }
    if m.contains("neutral")  { return "AttackLimb.FOOT"; }
    if m.contains("jab")      { return "AttackLimb.FIST"; }
    if m.contains("tilt") || m.contains("forward") { return "AttackLimb.FIST"; }
    if m.contains("special")  { return "AttackLimb.FIST"; }
    if m.contains("ledge") || m.contains("crash") { return "AttackLimb.FOOT"; }
    "AttackLimb.FIST"
}

fn format_attack(name: &str, hitboxes: &[Hitbox], is_extra: bool) -> String {
    let limb = guess_limb(name);
    let prefix = if is_extra { "\t// SSF2: " } else { "\t" };
    let mut out = format!("{}{}: {{\n", prefix, name);
    for (i, hb) in hitboxes.iter().enumerate() {
        // SSF2 hitLag of 255 means -1 (no hitstun override)
        let hitstun = if hb.hitstun == 255 || hb.hitstun == -1 { -1 } else { hb.hitstun };
        let hitstop = if hb.hitstop <= 0 { -1 } else { hb.hitstop };
        let self_hitstop = if hb.self_hitstop <= 0 { -1 } else { hb.self_hitstop };

        out.push_str(&format!(
            "\t\thitbox{}: {{ damage: {}, angle: {}, baseKnockback: {}, knockbackGrowth: {}, hitstop: {}, selfHitstop: {}",
            i,
            hb.damage as i32,
            hb.angle as i32,
            hb.base_knockback as i32,
            hb.knockback_growth as i32,
            hitstop,
            self_hitstop,
        ));
        if hitstun != -1 {
            out.push_str(&format!(", hitstun: {}", hitstun));
        }
        out.push_str(&format!(", limb: {} }},\n", limb));
    }
    out.push_str("\t},\n");
    out
}

fn format_attack_todo(name: &str) -> String {
    let limb = guess_limb(name);
    format!(
        "\t{}: {{\n\t\thitbox0: {{ damage: 0 /*TODO*/, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0 /*TODO*/, hitstop: -1, selfHitstop: -1, limb: {} }}\n\t}},\n",
        name, limb
    )
}

// ─── CharacterStats.hx ───────────────────────────────────────────────────────

fn generate_character_stats(data: &CharacterData, char_id: &str) -> String {
    let s = &data.stats;
    let todo = |v: f64| if v == 0.0 { " /*TODO*/" } else { "" };

    // Convert SSF2 values to Fraymakers equivalents
    let gravity       = if s.gravity > 0.0      { ssf2_gravity_to_fm(s.gravity) }      else { 0.0 };
    let terminal_vel  = if s.fall_speed > 0.0   { ssf2_speed_to_fm(s.fall_speed) }     else { 0.0 };
    let fast_fall     = if s.fast_fall_speed > 0.0 { ssf2_speed_to_fm(s.fast_fall_speed) } else { 0.0 };
    let jump_speed    = if s.jump_height > 0.0  { ssf2_jump_to_fm(s.jump_height) }    else { 0.0 };
    let dj_speed      = if s.double_jump_height > 0.0 { ssf2_jump_to_fm(s.double_jump_height) } else { 0.0 };
    let walk_cap      = if s.walk_speed > 0.0   { ssf2_walk_to_fm(s.walk_speed) }     else { 0.0 };
    let dash_speed    = if s.dash_speed > 0.0   { ssf2_dash_to_fm(s.dash_speed) }     else { 0.0 };
    let aerial_fric   = if s.air_friction != 0.0 { ssf2_air_to_fm(s.air_friction) }   else { 0.0 };
    let weight        = if s.weight > 0.0 { s.weight } else { 0.0 };

    // Build double jump speeds array
    let dj_array = if dj_speed > 0.0 {
        format!("[{}]", fmt(dj_speed))
    } else {
        "[15.5] /*TODO*/".to_string()
    };

    format!(
        "// Character stats for {} — converted from SSF2\n\
        // SSF2 physics values are scaled to Fraymakers equivalents.\n\
        // Review all values before use — units differ between engines.\n\
        {{\n\
        \tspriteContent: self.getResource().getContent(\"{}\"),\n\n\
        \t//GENERIC STATS\n\
        \tbaseScaleX: {},\n\
        \tbaseScaleY: {},\n\
        \tweight: {}{},\n\
        \tgravity: {}{},\n\
        \tshortHopSpeed: {} /*TODO: set manually*/,\n\
        \tjumpSpeed: {}{},\n\
        \tdoubleJumpSpeeds: {},\n\
        \tterminalVelocity: {}{},\n\
        \tfastFallSpeed: {}{},\n\
        \tfriction: 0.57 /*TODO*/,\n\
        \twalkSpeedInitial: 1.0,\n\
        \twalkSpeedAcceleration: 0.3,\n\
        \twalkSpeedCap: {}{},\n\
        \tdashSpeed: {}{},\n\
        \trunSpeedInitial: 4.75,\n\
        \trunSpeedAcceleration: 0.55,\n\
        \trunSpeedCap: 7.5,\n\
        \tgroundSpeedAcceleration: 0.3,\n\
        \tgroundSpeedCap: 11,\n\
        \taerialSpeedAcceleration: 0.45,\n\
        \taerialSpeedCap: {}{},\n\
        \taerialFriction: {}{},\n\n\
        \t//ENVIRONMENTAL COLLISION BODY (ECB) STATS\n\
        \tfloorHeadPosition: 86 /*TODO*/,\n\
        \tfloorHipWidth: 29 /*TODO*/,\n\
        \tfloorHipXOffset: 0,\n\
        \tfloorHipYOffset: 0,\n\
        \tfloorFootPosition: 0,\n\
        \taerialHeadPosition: 86 /*TODO*/,\n\
        \taerialHipWidth: 29 /*TODO*/,\n\
        \taerialHipXOffset: 0,\n\
        \taerialHipYOffset: 0,\n\
        \taerialFootPosition: 25 /*TODO*/,\n\n\
        \t//CAMERA BOX STATS\n\
        \tcameraBoxOffsetX: 25,\n\
        \tcameraBoxOffsetY: 75,\n\
        \tcameraBoxWidth: 200,\n\
        \tcameraBoxHeight: 250,\n\n\
        \t//ROLL AND LEDGE JUMP STATS\n\
        \ttechRollSpeed: 18,\n\
        \ttechRollSpeedStartFrame: 7,\n\
        \ttechRollSpeedLength: 1,\n\
        \tdodgeRollSpeed: 13,\n\
        \tdodgeRollSpeedStartFrame: 3,\n\
        \tdodgeRollSpeedLength: 1,\n\
        \tgetupRollSpeed: 15.5,\n\
        \tgetupRollSpeedStartFrame: 2,\n\
        \tgetupRollSpeedLength: 1,\n\
        \tledgeRollSpeed: 14,\n\
        \tledgeRollSpeedStartFrame: 1,\n\
        \tledgeRollSpeedLength: 1,\n\
        \tledgeJumpXSpeed: 2.5,\n\
        \tledgeJumpYSpeed: -10,\n\n\
        \t//AIRDASH STATS\n\
        \tairdashInitialSpeed: 11,\n\
        \tairdashSpeedCap: 12.5,\n\
        \tairdashAccelMultiplier: 0.4,\n\
        \tairdashCancelSpeedConservation: 0.9,\n\n\
        \t//SHIELD STATS\n\
        \tshieldCrossupThreshold: 16,\n\
        \tshieldFrontNineSliceContent: \"global::vfx.vfx_shield_front\",\n\
        \tshieldFrontXOffset: 10.5,\n\
        \tshieldFrontYOffset: 4,\n\
        \tshieldFrontWidth: 53,\n\
        \tshieldFrontHeight: 93,\n\
        \tshieldBackNineSliceContent: \"global::vfx.vfx_shield_back\",\n\
        \tshieldBackXOffset: 12.5,\n\
        \tshieldBackYOffset: 4,\n\
        \tshieldBackWidth: 49,\n\
        \tshieldBackHeight: 93,\n\n\
        \t//VOICE STATS\n\
        \tattackVoiceIds: [],\n\
        \thurtLightVoiceIds: [],\n\
        \thurtMediumVoiceIds: [],\n\
        \thurtHeavyVoiceIds: [],\n\
        \tkoVoiceIds: [],\n\
        \tattackVoiceSilenceRate: 0.5,\n\
        \thurtLightSilenceRate: 1,\n\
        \thurtMediumSilenceRate: 0.5,\n\
        \thurtHeavySilenceRate: 0,\n\
        \tkoVoiceSilenceRate: 0,\n\
        }}\n",
        data.name, char_id,
        fmt(s.base_scale_x), fmt(s.base_scale_y),
        fmt(weight), todo(weight),
        fmt(gravity), todo(gravity),
        fmt(jump_speed * 0.55), // short hop ~55% of full jump
        fmt(jump_speed), todo(jump_speed),
        dj_array,
        fmt(terminal_vel), todo(terminal_vel),
        fmt(fast_fall), todo(fast_fall),
        fmt(walk_cap), todo(walk_cap),
        fmt(dash_speed), todo(dash_speed),
        fmt(s.air_mobility.max(aerial_fric) * 5.0), todo(s.air_mobility),
        fmt(aerial_fric), todo(aerial_fric),
    )
}

// ─── AnimationStats.hx ───────────────────────────────────────────────────────

fn generate_animation_stats(data: &CharacterData) -> String {
    // Use the full template list so all animations have entries.
    // SSF2 has matching animations for most of these.
    format!(
        "// Animation stats for {} — converted from SSF2\n\
        // Many values are automatically set by the Common class.\n\
        // Entries here override those defaults.\n\
        {{\n\
        \t//MOTIONS\n\
        \tstand: {{}},\n\
        \tstand_turn: {{}},\n\
        \twalk_in: {{}},\n\
        \twalk_loop: {{}},\n\
        \twalk_out: {{}},\n\
        \tdash: {{}},\n\
        \trun: {{}},\n\
        \trun_turn: {{}},\n\
        \tskid: {{}},\n\
        \tjump_squat: {{}},\n\
        \tjump_in: {{}},\n\
        \tjump_midair: {{}},\n\
        \tjump_out: {{}},\n\
        \tfall_loop: {{}},\n\
        \tfall_special: {{}},\n\
        \tland_light: {{}},\n\
        \tland_heavy: {{}},\n\
        \tcrouch_in: {{}},\n\
        \tcrouch_loop: {{}},\n\
        \tcrouch_out: {{}},\n\n\
        \t//AIRDASHES\n\
        \tairdash_up: {{}},\n\
        \tairdash_down: {{}},\n\
        \tairdash_forward: {{}},\n\
        \tairdash_back: {{}},\n\
        \tairdash_forward_up: {{}},\n\
        \tairdash_forward_down: {{}},\n\
        \tairdash_back_up: {{}},\n\
        \tairdash_back_down: {{}},\n\
        \tairdash_freefall: {{}},\n\
        \tairdash_freefall_whiff: {{}},\n\n\
        \t//DEFENSE\n\
        \tshield_in: {{}},\n\
        \tshield_loop: {{}},\n\
        \tshield_hurt: {{}},\n\
        \tshield_out: {{}},\n\
        \tparry_in: {{}},\n\
        \tparry_success: {{}},\n\
        \tparry_fail: {{}},\n\
        \troll: {{}},\n\
        \tspot_dodge: {{}},\n\n\
        \t//ASSIST CALL\n\
        \tassist_call: {{}},\n\
        \tassist_call_air: {{}},\n\n\
        \t//LIGHT ATTACKS\n\
        \tjab1: {{}},\n\
        \tjab2: {{}},\n\
        \tjab3: {{}},\n\
        \tdash_attack: {{xSpeedConservation: 1}},\n\
        \ttilt_forward: {{}},\n\
        \ttilt_up: {{}},\n\
        \ttilt_down: {{}},\n\n\
        \t//STRONG ATTACKS\n\
        \tstrong_forward_in: {{}},\n\
        \tstrong_forward_charge: {{}},\n\
        \tstrong_forward_attack: {{}},\n\
        \tstrong_up_in: {{}},\n\
        \tstrong_up_charge: {{}},\n\
        \tstrong_up_attack: {{}},\n\
        \tstrong_down_in: {{}},\n\
        \tstrong_down_charge: {{}},\n\
        \tstrong_down_attack: {{}},\n\n\
        \t//AERIAL ATTACKS\n\
        \taerial_neutral: {{landAnimation:\"aerial_neutral_land\"}},\n\
        \taerial_forward: {{landAnimation:\"aerial_forward_land\"}},\n\
        \taerial_back: {{landAnimation:\"aerial_back_land\"}},\n\
        \taerial_up: {{landAnimation:\"aerial_up_land\"}},\n\
        \taerial_down: {{landAnimation:\"aerial_down_land\", xSpeedConservation: 0.5, ySpeedConservation: 0.5, gravityMultiplier:0, allowMovement: false}},\n\n\
        \t//AERIAL ATTACK LANDING\n\
        \taerial_neutral_land: {{}},\n\
        \taerial_forward_land: {{}},\n\
        \taerial_back_land: {{}},\n\
        \taerial_up_land: {{}},\n\
        \taerial_down_land: {{xSpeedConservation: 0}},\n\n\
        \t//SPECIAL ATTACKS\n\
        \tspecial_neutral: {{}},\n\
        \tspecial_neutral_air: {{}},\n\
        \tspecial_up: {{leaveGroundCancel:false, xSpeedConservation:0.5, ySpeedConservation:0.5, allowMovement: true, nextState:CState.FALL_SPECIAL}},\n\
        \tspecial_up_air: {{leaveGroundCancel:false, xSpeedConservation:0.5, ySpeedConservation:0.5, nextState:CState.FALL_SPECIAL, landType:LandType.TOUCH}},\n\
        \tspecial_down: {{allowFastFall:false, allowTurnOnFirstFrame: true, leaveGroundCancel:false, xSpeedConservation:0, ySpeedConservation:0}},\n\
        \tspecial_down_loop: {{endType:AnimationEndType.LOOP}},\n\
        \tspecial_down_endlag: {{}},\n\
        \tspecial_down_air: {{allowFastFall:false, allowTurnOnFirstFrame: true, leaveGroundCancel:false, xSpeedConservation:0, ySpeedConservation:0, landType:LandType.LINK_FRAMES, landAnimation:\"special_down\"}},\n\
        \tspecial_down_air_loop: {{endType:AnimationEndType.LOOP, landType:LandType.LINK_FRAMES, landAnimation:\"special_down_loop\"}},\n\
        \tspecial_down_air_endlag: {{landType:LandType.LINK_FRAMES, landAnimation:\"special_down\"}},\n\
        \tspecial_side: {{allowFastFall: false, allowTurnOnFirstFrame: true, leaveGroundCancel:false, landType:LandType.TOUCH, landAnimation: \"land_heavy\", singleUse:true}},\n\
        \tspecial_side_air: {{allowFastFall: false, allowTurnOnFirstFrame: true, leaveGroundCancel:false, landType:LandType.TOUCH, landAnimation: \"land_heavy\", singleUse:true}},\n\n\
        \t//THROWS\n\
        \tgrab: {{}},\n\
        \tgrab_hold: {{}},\n\
        \tthrow_forward: {{}},\n\
        \tthrow_back: {{}},\n\
        \tthrow_up: {{}},\n\
        \tthrow_down: {{}},\n\n\
        \t//HURT ANIMATIONS\n\
        \thurt_light_low: {{}},\n\
        \thurt_light_middle: {{}},\n\
        \thurt_light_high: {{}},\n\
        \thurt_medium: {{}},\n\
        \thurt_heavy: {{}},\n\
        \thurt_thrown: {{}},\n\
        \ttumble: {{}},\n\n\
        \t//CRASH\n\
        \tcrash_bounce: {{}},\n\
        \tcrash_loop: {{}},\n\
        \tcrash_get_up: {{}},\n\
        \tcrash_attack: {{}},\n\
        \tcrash_roll: {{}},\n\n\
        \t//LEDGE\n\
        \tledge_in: {{}},\n\
        \tledge_loop: {{}},\n\
        \tledge_roll_in: {{}},\n\
        \tledge_roll: {{}},\n\
        \tledge_climb_in: {{}},\n\
        \tledge_climb: {{}},\n\
        \tledge_attack_in: {{}},\n\
        \tledge_attack: {{}},\n\
        \tledge_jump_in: {{}},\n\
        \tledge_jump: {{}},\n\n\
        \t//MISC\n\
        \trevival: {{}},\n\
        \temote: {{}}\n\
        }}\n",
        data.name
    )
}

// ─── Script.hx ───────────────────────────────────────────────────────────────

fn generate_script(data: &CharacterData, _char_id: &str) -> String {
    let mut out = format!(
        "// API Script for {} — converted from SSF2\n\
        // Frame scripts are embedded in the entity file (FRAME_SCRIPT layers).\n\
        // SSF2 API calls are mapped to Fraymakers equivalents where possible.\n\
        // Lines marked TODO need manual review.\n\n\
        // start general functions ---\n\n\
        //Runs on object init\n\
        function initialize(){{\n\
        \tself.addEventListener(GameObjectEvent.LINK_FRAMES, handleLinkFrames, {{persistent:true}});\n\
        }}\n\n\
        function update(){{\n\
        }}\n\n\
        // Runs when reading inputs (before determining character state, update, framescript, etc.)\n\
        function inputUpdateHook(pressedControls:ControlsObject, heldControls:ControlsObject) {{\n\
        }}\n\n\
        // CState-based handling for LINK_FRAMES\n\
        function handleLinkFrames(e){{\n\
        }}\n\n\
        function onTeardown() {{\n\
        }}\n\n\
        // --- end general functions\n\n",
        data.name
    );

    // Emit decompiled Ext class methods (these belong in Script.hx)
    // Filter out trivial slot initializers (tiny methods that just set SSF2API)
    let ext_methods: Vec<_> = data.scripts.iter()
        .filter(|s| s.is_ext_method)
        .filter(|s| {
            // Filter out trivial slot initializer stubs
            !s.code.contains("Object.SSF2API")
        })
        .collect();
    if !ext_methods.is_empty() {
        out.push_str("// ── Decompiled from SSF2 XxxExt.as ─────────────────────────────────────────\n\n");
        // Built-in functions that are already in the template header
        let template_fns = ["initialize", "update", "inputUpdateHook", "handleLinkFrames", "onTeardown"];
        for script in &ext_methods {
            // Rename colliding functions so they don't shadow the template
            let code = if template_fns.iter().any(|f| script.name == *f) {
                script.code.replacen(
                    &format!("function {}(", script.name),
                    &format!("function ssf2_{}(", script.name),
                    1
                )
            } else {
                script.code.clone()
            };
            let translated = crate::api_mappings::translate_ssf2_to_fm(&code);
            out.push_str(&translated);
            out.push('\n');
        }
    }

    // Frame scripts are embedded directly in the entity file via FRAME_SCRIPT layers.
    // They are no longer duplicated here.

    // Jab chain transition logic
    out.push_str(&generate_jab_scripts());

    // Full-script post-pass: fix paired setIntangibility calls
    out = crate::api_mappings::fix_intangibility_pairs(&out);

    out
}

// ─── Jab chain scripts ─────────────────────────────────────────────────────

/// Generate jab1/jab2/jab3 chain transition frame scripts.
///
/// In SSF2, the single 'Jab_21' sprite has three sub-animations separated by
/// internal frame labels (begin → hit2 → hit3). SSF2 code calls `gotoAndPlay("hit2")`
/// to chain into the next hit on button press, and `gotoAndPlay("begin")` to loop jab1.
///
/// In Fraymakers, each is a separate animation. The chain logic lives in framescripts:
///   - jab1: on last frame, if attack pressed → enter jab2; else idle
///   - jab2: on last frame, if attack pressed → enter jab3; else idle
///   - jab3: on last frame → idle
fn generate_jab_scripts() -> String {
    r#"
// ── Jab chain — SSF2 Jab_21 sub-animations (begin / hit2 / hit3) ─────────────────
// SSF2 uses gotoAndPlay("hit2") / gotoAndPlay("hit3") to chain jabs on button press.
// In Fraymakers, jab1/jab2/jab3 are separate animations chained via CState transitions.

// Called from AnimationStats.jab1 last-frame handler (link in FrayTools):
function jab1_end() {
	if (entity.checkInput(ControlsObject.ATTACK)) {
		// Player pressed attack again — chain to jab2
		entity.setAnimation("jab2");
		entity.playCState(CState.JAB2);
	} else {
		// No input — return to idle
		entity.playCState(CState.IDLE);
	}
}

// Called from AnimationStats.jab2 last-frame handler:
function jab2_end() {
	if (entity.checkInput(ControlsObject.ATTACK)) {
		entity.setAnimation("jab3");
		entity.playCState(CState.JAB3);
	} else {
		entity.playCState(CState.IDLE);
	}
}

// Called from AnimationStats.jab3 last-frame handler:
function jab3_end() {
	entity.playCState(CState.IDLE);
}
"#.to_string()
}

// ─── manifest.json ───────────────────────────────────────────────────────────

fn generate_manifest(char_id: &str, display_name: &str) -> String {
    let ai_id   = format!("{}Ai", char_id);
    let ai_script_id = format!("{}AiScript", char_id);
    serde_json::json!({
        "resourceId": char_id,
        "content": [
          {
            "id": char_id,
            "name": display_name,
            "description": format!("{} — converted from Super Smash Flash 2", display_name),
            "type": "character",
            "objectStatsId":    format!("{}CharacterStats", char_id),
            "animationStatsId": format!("{}AnimationStats", char_id),
            "hitboxStatsId":    format!("{}HitboxStats", char_id),
            "scriptId":         format!("{}Script", char_id),
            "costumesId":       format!("{}Costumes", char_id),
            "aiId":             ai_id,
            "metadata": {
                "ui": {
                    "entityId": "menu",
                    "render": {
                        "animation":               "full",
                        "animation_icon":          "icon",
                        "animation_icon_no_palette": "icon_no_palette",
                        "x_offset":       0,
                        "y_offset":       38,
                        "x_offset_door":  0,
                        "y_offset_door":  0,
                        "x_offset_door_ffa": 0,
                        "y_offset_door_ffa": 0
                    },
                    "hud": {
                        "animation":              "hud",
                        "animation_front":        "hud_front",
                        "animation_happy":        "hud_happy",
                        "animation_happy_front":  "hud_happy_front",
                        "animation_sad":          "hud_sad",
                        "animation_sad_front":    "hud_sad_front",
                        "animation_angry":        "hud_angry",
                        "animation_angry_front":  "hud_angry_front",
                        "animation_hurt":         "hud_hurt",
                        "animation_hurt_front":   "hud_hurt_front",
                        "animation_stock_icon":   "stock"
                    },
                    "css": {
                        "animation": "css",
                        "info": {
                            "game": "Super Smash Flash 2",
                            "description": format!("{} — ported from SSF2", display_name)
                        }
                    }
                }
            }
          },
          {
            "id":       ai_id,
            "type":     "characterAi",
            "scriptId": ai_script_id
          }
        ]
    }).to_string()
}

// ─── Sound content entries ────────────────────────────────────────────────────

/// Generate manifest content entries + .meta sidecar files for extracted sounds.
/// Sounds live in library/sounds/*.ogg and are referenced by content id
/// "{char_name}::{sound_name}" so Script.hx can call AudioClip.play("mario::mario_jumpsfx").
fn generate_sound_entries(
    char_dir: &Path,
    char_name: &str,
    sounds: &[crate::sound_extractor::SoundEntry],
) -> Result<()> {
    let sounds_dir = char_dir.join("library/sounds");
    fs::create_dir_all(&sounds_dir)?;

    // Build a sounds manifest listing all audio content ids
    let sound_entries: Vec<serde_json::Value> = sounds.iter().map(|s| {
        let safe_name: String = s.name.chars()
            .map(|c| if c.is_alphanumeric() || c == '_' || c == '-' { c } else { '_' })
            .collect();
        let content_id = format!("{}::{}", char_name, safe_name);
        let ogg_path   = format!("sounds/{}.ogg", safe_name);
        serde_json::json!({
            "id":      content_id,
            "type":    "audio",
            "path":    ogg_path,
            "metadata": {
                "originalName": s.name,
                "sampleRate":   s.sample_rate,
                "sampleCount":  s.sample_count,
                "durationSecs": s.duration_secs(),
            }
        })
    }).collect();

    // Write sounds_manifest.json alongside the main manifest
    let sounds_manifest = serde_json::json!({
        "sounds": sound_entries,
        "_note": "Content ids for use in Script.hx: AudioClip.play(\"<id>\")"
    });
    fs::write(
        char_dir.join("library/sounds_manifest.json"),
        serde_json::to_string_pretty(&sounds_manifest)?,
    )?;

    // Write a .meta sidecar for each OGG file that exists
    for s in sounds {
        let safe_name: String = s.name.chars()
            .map(|c| if c.is_alphanumeric() || c == '_' || c == '-' { c } else { '_' })
            .collect();
        let ogg_path = sounds_dir.join(format!("{}.ogg", safe_name));
        if !ogg_path.exists() { continue; }

        let content_id = format!("{}::{}", char_name, safe_name);
        let guid = det_uuid(&format!("{}::sound_meta_{}", char_name, safe_name));
        let meta = serde_json::json!({
            "guid": guid,
            "id":   content_id,
            "type": "audio"
        });
        fs::write(
            sounds_dir.join(format!("{}.ogg.meta", safe_name)),
            serde_json::to_string_pretty(&meta)?,
        )?;
    }

    Ok(())
}
