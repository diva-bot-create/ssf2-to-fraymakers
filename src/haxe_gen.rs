use anyhow::Result;
use std::fs;
use std::path::Path;
use crate::extractor::{CharacterData, Attack, Hitbox, CharacterStats};

pub fn generate(output_dir: &Path, char_name: &str, data: &CharacterData) -> Result<()> {
    let char_dir = output_dir.join(char_name.to_lowercase());
    fs::create_dir_all(&char_dir)?;
    log::info!("Generating Fraymakers files in {}", char_dir.display());

    fs::write(char_dir.join("HitboxStats.hx"),     generate_hitbox_stats(data))?;
    fs::write(char_dir.join("CharacterStats.hx"),   generate_character_stats(data))?;
    fs::write(char_dir.join("AnimationStats.hx"),   generate_animation_stats(data))?;
    fs::write(char_dir.join("Script.hx"),           generate_script(data))?;

    let stats_json = serde_json::json!({
        "name": data.name,
        "attacks_extracted": data.attacks.len(),
        "stats_extracted": data.stats.weight != 0.0,
        "animations": data.animations.len(),
        "scripts": data.scripts.len(),
    });
    fs::write(char_dir.join("stats.json"), serde_json::to_string_pretty(&stats_json)?)?;

    log::info!("Generated {} attacks, {} animations, {} scripts",
        data.attacks.len(), data.animations.len(), data.scripts.len());
    Ok(())
}

fn generate_hitbox_stats(data: &CharacterData) -> String {
    let mut out = format!(
        "// HitboxStats.hx for {} — converted from SSF2\n\
        // SSF2 → Fraymakers mapping:\n\
        //   damage        → damage\n\
        //   direction     → angle\n\
        //   power/weightKB → baseKnockback\n\
        //   kbConstant    → knockbackGrowth\n\
        //   hitStun       → hitstop\n\
        //   selfHitStun   → selfHitstop\n\
        //   hitLag        → hitstun\n\
        {{\n", data.name);

    let move_sections = [
        ("LIGHT ATTACKS",  &["jab1","jab2","jab3","dash_attack","tilt_forward","tilt_up","tilt_down"] as &[&str]),
        ("STRONG ATTACKS", &["strong_forward_attack","strong_up_attack","strong_down_attack"]),
        ("AERIAL ATTACKS", &["aerial_neutral","aerial_forward","aerial_back","aerial_up","aerial_down"]),
        ("SPECIALS",       &["special_neutral","special_neutral_air","special_side","special_side_air","special_up","special_up_air","special_down","special_down_air"]),
        ("THROWS",         &["throw_up","throw_down","throw_forward","throw_back"]),
        ("MISC",           &["ledge_attack","crash_attack"]),
    ];

    // Build a lookup from attack name
    let attack_lookup: std::collections::BTreeMap<_, _> = data.attacks.iter()
        .map(|a| (a.name.as_str(), a))
        .collect();

    for (section_name, moves) in &move_sections {
        out.push_str(&format!("\n\t// ── {} ─────────────────────────────────────\n", section_name));
        for &move_name in *moves {
            if let Some(attack) = attack_lookup.get(move_name) {
                out.push_str(&format!("\t{}: {{\n", move_name));
                for (i, hb) in attack.hitboxes.iter().enumerate() {
                    out.push_str(&format!(
                        "\t\thitbox{}: {{ damage: {}, angle: {}, baseKnockback: {}, knockbackGrowth: {}, hitstop: {}, selfHitstop: {}, hitstun: {} }},\n",
                        i,
                        hb.damage as i32,
                        hb.angle as i32,
                        hb.base_knockback as i32,
                        hb.knockback_growth as i32,
                        hb.hitstop,
                        hb.self_hitstop,
                        hb.hitstun,
                    ));
                }
                out.push_str("\t},\n");
            } else {
                out.push_str(&format!(
                    "\t{}: {{ hitbox0: {{ damage: 0 /*TODO*/, angle: 0 /*TODO*/, baseKnockback: 0 /*TODO*/, knockbackGrowth: 0 /*TODO*/, hitstop: -1, selfHitstop: -1 }} }},\n",
                    move_name
                ));
            }
        }
    }

    // Any extra attacks not in the standard list
    let standard: std::collections::HashSet<&str> = move_sections.iter()
        .flat_map(|(_, moves)| moves.iter().copied()).collect();
    let extras: Vec<_> = data.attacks.iter()
        .filter(|a| !standard.contains(a.name.as_str())).collect();
    if !extras.is_empty() {
        out.push_str("\n\t// ── EXTRA (SSF2-specific) ─────────────────────────────────────\n");
        for attack in extras {
            out.push_str(&format!("\t{}: {{\n", attack.name));
            for (i, hb) in attack.hitboxes.iter().enumerate() {
                out.push_str(&format!(
                    "\t\thitbox{}: {{ damage: {}, angle: {}, baseKnockback: {}, knockbackGrowth: {}, hitstop: {}, selfHitstop: {}, hitstun: {} }},\n",
                    i,
                    hb.damage as i32, hb.angle as i32,
                    hb.base_knockback as i32, hb.knockback_growth as i32,
                    hb.hitstop, hb.self_hitstop, hb.hitstun,
                ));
            }
            out.push_str("\t},\n");
        }
    }

    out.push_str("}\n");
    out
}

fn generate_character_stats(data: &CharacterData) -> String {
    let s = &data.stats;
    let todo = |v: f64| if v == 0.0 { " /*TODO*/".to_string() } else { String::new() };
    format!(
        "// CharacterStats.hx for {} — converted from SSF2 getOwnStats()\n\
        {{\n\
        \tweight:            {}{},\n\
        \tgravity:           {}{},\n\
        \tfallSpeed:         {}{},\n\
        \tfastFallSpeed:     {}{},\n\
        \twalkSpeed:         {}{},\n\
        \tdashSpeed:         {}{},\n\
        \tairMobility:       {}{},\n\
        \tmaxJumps:          {},\n\
        \tjumpHeight:        {}{},\n\
        \tdoubleJumpHeight:  {}{},\n\
        \tairFriction:       {}{},\n\
        }}\n",
        data.name,
        s.weight,          todo(s.weight),
        s.gravity,         todo(s.gravity),
        s.fall_speed,      todo(s.fall_speed),
        s.fast_fall_speed, todo(s.fast_fall_speed),
        s.walk_speed,      todo(s.walk_speed),
        s.dash_speed,      todo(s.dash_speed),
        s.air_mobility,    todo(s.air_mobility),
        s.max_jumps,
        s.jump_height,        todo(s.jump_height),
        s.double_jump_height, todo(s.double_jump_height),
        s.air_friction,       todo(s.air_friction),
    )
}

fn generate_animation_stats(data: &CharacterData) -> String {
    let mut out = format!("// AnimationStats.hx for {} — derived from SSF2 symbol table\n{{\n", data.name);
    for (name, anim) in &data.animations {
        out.push_str(&format!("\t{}: {{ looping: false }},\n", name));
    }
    out.push_str("}\n");
    out
}

fn generate_script(data: &CharacterData) -> String {
    let mut out = format!(
        "// Script.hx for {} — converted from SSF2 timeline code\n\
        // Review all TODO items before using in production.\n\n",
        data.name
    );

    out.push_str("function initialize() {\n\t// Called once on character creation\n}\n\n");
    out.push_str("function update() {\n\t// Called every frame\n}\n\n");
    out.push_str("function inputUpdateHook(pressedControls:ControlsObject, heldControls:ControlsObject) {\n}\n\n");
    out.push_str("// ── Attack-specific frame scripts ────────────────────────────────────────\n\n");

    for script in &data.scripts {
        out.push_str("// SSF2 source → Fraymakers '");
        out.push_str(&script.name);
        out.push_str("'\n");
        out.push_str(&script.code);
        out.push('\n');
    }

    out
}
