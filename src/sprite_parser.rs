/// sprite_parser — extracts per-animation, per-frame collision box geometry from SWF DefineSprite tags.
///
/// SSF2 encodes hitbox data entirely in the SWF timeline, not in AS3 code:
///   - Each animation lives in a named DefineSprite (e.g. `mario_fla.Jab_21`)
///   - Each frame of that sprite has PlaceObject tags for collision MovieClips (CollisonBox_6)
///   - The PlaceObject matrix encodes the box's position (tx/ty in twips) and size (a/d = scale)
///   - The PlaceObject instance name tells us the box type:
///       attackBox / attackBox2 / attackBox3 → Hitbox (active attack)
///       hitBox / hitBox2 / hitBox3 / hitBox4 / hitBox5 → Hurtbox (can be hit)
///       hurtBox → Hurtbox
///       grabBox / grabbox → GrabBox
///       itemBox → ItemBox (item pickup range)
///       shieldBox / shieldbox → ShieldBox
///       reflectBox → ReflectBox
///       absorbBox → AbsorbBox
///       ledgeBox / ledgegrabbox → LedgeBox
///       (anything else with "Box" suffix) → Hurtbox (fallback)
///
/// The base CollisonBox_6 shape is typically a 100×100 unit square centered at 0,0.
/// scale_x * BASE_SIZE = box width, scale_y * BASE_SIZE = box height.
/// tx/ty give the top-left (or center, depending on registration point) in pixels.

use std::collections::BTreeMap;
use std::io::Cursor;
use serde::{Deserialize, Serialize};

/// Base size of the CollisonBox shape in SSF2 (pixels after /20 twip conversion).
/// Measured from the actual shape bounds of the CollisonBox_6 DefineShape.
/// Fallback to 100.0 if shape not found.
const DEFAULT_BASE_SIZE: f64 = 100.0;

// ─── Output types ────────────────────────────────────────────────────────────

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum BoxType {
    /// Active attack hitbox (dealg damage)
    Hitbox,
    /// Hurtbox (can receive damage)
    Hurtbox,
    /// Grab range
    GrabBox,
    /// Item pickup range
    ItemBox,
    /// Shield/parry box
    ShieldBox,
    /// Reflector hitbox
    ReflectBox,
    /// Absorb hitbox
    AbsorbBox,
    /// Ledge grab box
    LedgeBox,
}

impl BoxType {
    /// Map SSF2 instance name → BoxType
    pub fn from_instance_name(name: &str) -> Option<BoxType> {
        let lower = name.to_lowercase();
        if lower.starts_with("attackbox") {
            Some(BoxType::Hitbox)
        } else if lower.starts_with("hitbox") || lower.starts_with("hurtbox") {
            Some(BoxType::Hurtbox)
        } else if lower.starts_with("grabbox") || lower.starts_with("grab") && lower.ends_with("box") {
            Some(BoxType::GrabBox)
        } else if lower.starts_with("itembox") || lower == "itembox" {
            Some(BoxType::ItemBox)
        } else if lower.starts_with("shieldbox") {
            Some(BoxType::ShieldBox)
        } else if lower.starts_with("reflectbox") {
            Some(BoxType::ReflectBox)
        } else if lower.starts_with("absorbbox") {
            Some(BoxType::AbsorbBox)
        } else if lower.starts_with("ledgebox") || lower.starts_with("ledgegrab") {
            Some(BoxType::LedgeBox)
        } else if lower.ends_with("box") {
            // generic fallback — treat unknown *box as hurtbox
            Some(BoxType::Hurtbox)
        } else {
            None
        }
    }

    pub fn as_str(&self) -> &'static str {
        match self {
            BoxType::Hitbox    => "HITBOX",
            BoxType::Hurtbox   => "HURTBOX",
            BoxType::GrabBox   => "GRAB_BOX",
            BoxType::ItemBox   => "ITEM_BOX",
            BoxType::ShieldBox => "SHIELD_BOX",
            BoxType::ReflectBox => "REFLECT_BOX",
            BoxType::AbsorbBox => "ABSORB_BOX",
            BoxType::LedgeBox  => "LEDGE_BOX",
        }
    }
}

/// A single collision box placed on one frame of one animation.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FrameBox {
    /// Box type derived from instance name
    pub box_type: BoxType,
    /// Original SSF2 instance name (e.g. "attackBox", "hitBox3")
    pub instance_name: String,
    /// X position in pixels (top-left, relative to character origin)
    pub x: f64,
    /// Y position in pixels (top-left, relative to character origin)
    /// Note: SWF Y axis points DOWN; Fraymakers Y axis points UP — caller must negate
    pub y: f64,
    /// Box width in pixels
    pub width: f64,
    /// Box height in pixels
    pub height: f64,
}

/// All collision boxes for one animation, indexed by frame number (0-based).
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AnimationBoxData {
    /// SSF2 animation name (e.g. "a_air", "stand")
    pub ssf2_name: String,
    /// Fraymakers animation name (e.g. "aerial_neutral", "idle")
    pub fm_name: String,
    /// Total frames in this animation (after sub-anim slicing if applicable)
    pub total_frames: u16,
    /// per-frame boxes: frame_index (0-based within this sub-anim) → list of boxes active on that frame
    pub frames: BTreeMap<u16, Vec<FrameBox>>,
    /// Frame offset into the original SSF2 sprite where this sub-anim starts
    pub sprite_frame_offset: u16,
}

// ─── Main entry point ────────────────────────────────────────────────────────

/// Parse the SWF file and extract per-animation per-frame collision box data.
/// `ssf2_to_fm` maps SSF2 animation names to Fraymakers animation names.
pub fn parse_sprite_boxes(
    swf_data: &[u8],
    char_name: &str,
    ssf2_to_fm: &BTreeMap<String, String>,
) -> anyhow::Result<BTreeMap<String, AnimationBoxData>> {
    let swf_buf = swf::decompress_swf(Cursor::new(swf_data))?;
    let swf = swf::parse_swf(&swf_buf)?;

    // Build id → symbol name map
    let mut sym_names: BTreeMap<u16, String> = BTreeMap::new();
    for tag in &swf.tags {
        if let swf::Tag::SymbolClass(links) = tag {
            for link in links {
                let name = link.class_name.to_str_lossy(encoding_rs::WINDOWS_1252).to_string();
                sym_names.insert(link.id, name);
            }
        }
    }

    // Find the base size of the collision box shape
    // Look for the DefineShape that the CollisonBox sprite (id=112 for mario) references
    let box_base_size = find_collision_box_base_size(&swf, &sym_names);
    log::info!("CollisonBox base size: {:.1}px", box_base_size);

    // Build reverse map: FM anim name → SSF2 anim name (for lookup)
    // and a set of all SSF2 anim names we care about
    let known_ssf2_names: std::collections::HashSet<&str> = ssf2_to_fm.keys().map(|s| s.as_str()).collect();

    // Find all character animation sprites
    // Pattern: "{char}_fla.{AnimName}_{index}" or just "{char}_{animtype}"
    let char_lower = char_name.to_lowercase();
    let mut result: BTreeMap<String, AnimationBoxData> = BTreeMap::new();

    for tag in &swf.tags {
        if let swf::Tag::DefineSprite(sprite) = tag {
            let sym = sym_names.get(&sprite.id).cloned().unwrap_or_default();

            // Only process sprites that belong to this character
            if !sym.to_lowercase().contains(&char_lower) {
                continue;
            }

            // Try to extract SSF2 animation name from the symbol name
            let ssf2_name = match extract_ssf2_anim_name(&sym, &char_lower, ssf2_to_fm) {
                Some(n) => n,
                None => continue,
            };

            let fm_name = ssf2_to_fm.get(&ssf2_name).cloned().unwrap_or_else(|| ssf2_name.clone());

            // Collect internal frame labels (for sub-animation splitting)
            let frame_labels = extract_frame_labels(sprite);

            let frames = extract_frame_boxes(sprite, &sym_names, box_base_size);

            log::debug!("Sprite '{}' → ssf2='{}' fm='{}': {} frames with boxes, {} labels",
                sym, ssf2_name, fm_name, frames.len(), frame_labels.len());

            // Check if this animation should be split into sub-animations
            let sub_splits = sub_anim_splits(&fm_name, &frame_labels, sprite.num_frames);

            if sub_splits.is_empty() {
                // Single animation — insert as-is
                if frames.is_empty() { continue; }
                result.insert(fm_name.clone(), AnimationBoxData {
                    ssf2_name,
                    fm_name,
                    total_frames: sprite.num_frames,
                    frames,
                    sprite_frame_offset: 0,
                });
            } else {
                // Split into multiple FM animations
                for (sub_fm_name, start_frame, end_frame) in sub_splits {
                    let slice_len = end_frame.saturating_sub(start_frame);
                    // Remap frame indices: subtract start_frame so they are 0-based within sub-anim
                    let sliced_frames: BTreeMap<u16, Vec<FrameBox>> = frames.iter()
                        .filter(|(&f, _)| f >= start_frame && f < end_frame)
                        .map(|(&f, boxes)| (f - start_frame, boxes.clone()))
                        .collect();

                    log::debug!("  sub-anim '{}': frames {}..{} ({} frames with boxes)",
                        sub_fm_name, start_frame, end_frame, sliced_frames.len());

                    result.insert(sub_fm_name.clone(), AnimationBoxData {
                        ssf2_name: ssf2_name.clone(),
                        fm_name: sub_fm_name,
                        total_frames: slice_len,
                        frames: sliced_frames,
                        sprite_frame_offset: start_frame,
                    });
                }
            }
        }
    }

    log::info!("sprite_parser: extracted box data for {}/{} animations before fallbacks",
        result.len(), ssf2_to_fm.len());

    // Apply fallbacks: for animations with no sprite data, clone from the closest related state.
    // These are procedural states in SSF2 that reuse another animation's pose.
    apply_fallbacks(&mut result);

    log::info!("sprite_parser: {}/{} animations have box data after fallbacks",
        result.len(), ssf2_to_fm.len());

    Ok(result)
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

// ─── Sub-animation splitting ─────────────────────────────────────────────────

/// Extract all FrameLabel tags from a DefineSprite, returning (label, frame_number) pairs
/// sorted by frame number.
fn extract_frame_labels(sprite: &swf::Sprite) -> Vec<(String, u16)> {
    let mut frame_num: u16 = 0;
    let mut labels: Vec<(String, u16)> = Vec::new();
    for tag in &sprite.tags {
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

/// Public alias for sub_anim_splits — used by image_extractor to apply the same split.
pub fn sub_anim_image_splits(
    fm_name: &str,
    frame_labels: &[(String, u16)],
    total_frames: u16,
) -> Vec<(String, u16, u16)> {
    sub_anim_splits(fm_name, frame_labels, total_frames)
}

/// Given an FM animation name and the internal frame labels of its SSF2 sprite,
/// return a list of (fm_sub_anim_name, start_frame_inclusive, end_frame_exclusive).
/// Returns empty vec if no splitting is needed (animation maps 1:1).
fn sub_anim_splits(
    fm_name: &str,
    frame_labels: &[(String, u16)],
    total_frames: u16,
) -> Vec<(String, u16, u16)> {
    // Table: fm_anim → (required labels in order, fm sub-anim names in order)
    // The SSF2 label marks the START of that sub-animation's first active frame.
    let split_table: &[(&str, &[&str], &[&str])] = &[
        // Jab: begin=1, hit2=8, hit3=18  (frame 0 is pre-roll, ignore it)
        ("jab",  &["begin", "hit2", "hit3"],  &["jab1", "jab2", "jab3"]),

        // Taunts: taunt_side=0, taunt_neutral=42, taunt_updown=115
        // Map to FM: taunt (side), taunt_up, taunt_down  (FM has 3 taunt slots)
        ("taunt", &["taunt_side", "taunt_neutral", "taunt_updown"], &["taunt", "taunt_up", "taunt_down"]),
    ];

    for &(anim, required_labels, sub_names) in split_table {
        if fm_name != anim { continue; }

        // Check that all required labels are present
        let label_map: std::collections::HashMap<&str, u16> = frame_labels.iter()
            .map(|(l, f)| (l.as_str(), *f))
            .collect();

        if required_labels.iter().any(|l| !label_map.contains_key(l)) {
            // Labels not found — don't split this character's version
            log::debug!("sub_anim_splits: '{}' missing some labels {:?}, skipping split", fm_name, required_labels);
            return vec![];
        }

        // Build (start, end) ranges from the label positions
        let starts: Vec<u16> = required_labels.iter().map(|l| *label_map.get(l).unwrap()).collect();
        let mut splits = Vec::new();
        for (i, (&start, &sub_name)) in starts.iter().zip(sub_names.iter()).enumerate() {
            let end = if i + 1 < starts.len() { starts[i + 1] } else { total_frames };
            splits.push((sub_name.to_string(), start, end));
        }
        return splits;
    }

    vec![]
}

// ─── Fallbacks ────────────────────────────────────────────────────────────────

/// For animations with no extracted sprite data, clone box data from the most
/// appropriate related animation. The cloned data keeps the same box shapes but
/// marks the animation name correctly so it lands in the right entity layer.
fn apply_fallbacks(result: &mut BTreeMap<String, AnimationBoxData>) {
    // Table: missing FM anim name → best donor FM anim name
    let fallbacks: &[(&str, &str)] = &[
        // Damage / launched states
        ("stunned",           "hurt"),
        ("star_ko",           "hurt"),
        ("starko",            "hurt"),
        ("screenko",          "hurt"),
        ("buried",            "crouch"),
        // Airborne/misc states
        ("fly",               "jump_aerial"),
        ("swim",              "fall"),
        ("ladder",            "idle"),
        ("wall_stick",        "fall"),
        ("special",           "idle"),
        ("carry",             "grab"),
        // Landing variants
        ("land_heavy",        "land"),
        ("ledge_lean",        "ledge_hang"),
        // Win/lose/respawn
        ("victory",           "taunt"),
        ("defeat",            "hurt"),
        ("respawn",           "idle"),
        // Special air variants
        ("special_down_air",  "special_down"),
        ("special_neutral_air", "special_neutral"),
        ("special_side_air",  "special_side"),
        ("special_up_air",    "special_up"),
        // Item variants
        ("item_float",        "idle"),
        ("item_screw",        "special_up"),
    ];

    let mut to_insert: Vec<AnimationBoxData> = Vec::new();

    for (missing, donor) in fallbacks {
        if result.contains_key(*missing) { continue; }
        if let Some(donor_data) = result.get(*donor) {
            log::debug!("Fallback: '{}' ← '{}' ({} frames)", missing, donor, donor_data.total_frames);
            let mut cloned = donor_data.clone();
            cloned.fm_name = missing.to_string();
            to_insert.push(cloned);
        } else {
            log::debug!("Fallback: '{}' ← '{}' (donor also missing)", missing, donor);
        }
    }

    for data in to_insert {
        result.insert(data.fm_name.clone(), data);
    }
}

/// Find the pixel size of one side of the CollisionBox base shape.
/// SSF2 uses a square shape; we want the width (= height for square).
fn find_collision_box_base_size(swf: &swf::Swf, sym_names: &BTreeMap<u16, String>) -> f64 {
    // Find the CollisonBox sprite id
    let collison_sprite_id = sym_names.iter()
        .find(|(_, name)| name.to_lowercase().contains("collisonbox") || name.to_lowercase().contains("collisionbox"))
        .map(|(id, _)| *id);

    let Some(sprite_id) = collison_sprite_id else { return DEFAULT_BASE_SIZE; };

    // Find the sprite and its first child (should be a shape)
    for tag in &swf.tags {
        if let swf::Tag::DefineSprite(sprite) = tag {
            if sprite.id != sprite_id { continue; }
            // Get the first PlaceObject to find the shape id
            for stag in &sprite.tags {
                if let swf::Tag::PlaceObject(po) = stag {
                    let shape_id = match &po.action {
                        swf::PlaceObjectAction::Place(id) => *id,
                        swf::PlaceObjectAction::Replace(id) => *id,
                        _ => continue,
                    };
                    // Now find the DefineShape with that id
                    for tag2 in &swf.tags {
                        if let swf::Tag::DefineShape(shape) = tag2 {
                            if shape.id != shape_id { continue; }
                            let bounds = &shape.shape_bounds;
                            let w = (bounds.x_max.get() - bounds.x_min.get()) as f64 / 20.0;
                            let h = (bounds.y_max.get() - bounds.y_min.get()) as f64 / 20.0;
                            log::debug!("CollisonBox shape id={} bounds: {}x{} px", shape_id, w, h);
                            // Use average of w/h in case it's not exactly square
                            return (w + h) / 2.0;
                        }
                    }
                }
            }
        }
    }
    DEFAULT_BASE_SIZE
}

/// Extract SSF2 animation name from a symbol name like "mario_fla.NAir_40".
/// Uses the ssf2_to_fm map to validate/match against known animation names.
pub fn extract_ssf2_anim_name(
    sym: &str,
    char_lower: &str,
    ssf2_to_fm: &BTreeMap<String, String>,
) -> Option<String> {
    // Symbol format: "{char}_fla.{AnimLabel}_{index}"
    // e.g. "mario_fla.NAir_40" → local = "NAir_40" → strip suffix → "NAir" → normalize → "a_air"
    let local = if sym.contains('.') {
        sym.split('.').last()?
    } else {
        sym
    };

    // Strip trailing _NNN
    let stripped = strip_numeric_suffix(local);

    // Try direct match against SSF2 anim names (case-insensitive)
    // Build a normalized version: "NAir" → "nair", then match against known patterns
    let normalized = normalize_anim_label(stripped);

    // First try exact match
    if ssf2_to_fm.contains_key(&normalized) {
        return Some(normalized);
    }

    // Try known label → SSF2 name mappings
    // These map the AnimLabel in the symbol to the SSF2 xframe name
    let label_to_ssf2: &[(&str, &str)] = &[
        ("idle", "stand"),
        ("stand", "stand"),
        ("entrance", "entrance"),
        ("revival", "revival"),
        ("win", "win"),
        ("lose", "lose"),
        ("walk", "walk"),
        ("run", "run"),
        ("jump", "jump"),
        ("doublejump", "jump_midair"),
        ("djump", "jump_midair"),
        ("fall", "fall"),
        ("land", "land"),
        ("heavyland", "heavyland"),
        ("skid", "skid"),
        ("crouch", "crouch"),
        // Attacks - jab / normals
        ("jab", "a"),
        ("jab1", "a"),
        ("jab2", "a"),
        ("dashattack", "a_forward"),
        ("forwardtilt", "a_forward_tilt"),
        ("ftilt", "a_forward_tilt"),
        ("uptilt", "a_up_tilt"),
        ("utilt", "a_up_tilt"),
        ("downtilt", "a_down"),
        ("dtilt", "a_down"),
        ("crouchattack", "crouch_attack"),
        ("forwardsmash", "a_forwardsmash"),
        ("fsmash", "a_forwardsmash"),
        ("upsmash", "a_up"),
        ("usmash", "a_up"),
        // Aerials
        ("nair", "a_air"),
        ("neutralair", "a_air"),
        ("fair", "a_air_forward"),
        ("forwardair", "a_air_forward"),
        ("bair", "a_air_backward"),
        ("backair", "a_air_backward"),
        ("uair", "a_air_up"),
        ("upair", "a_air_up"),
        ("dair", "a_air_down"),
        ("downair", "a_air_down"),
        // Specials
        ("neutralb", "b"),
        ("neutralspecial", "b"),
        ("neutralbair", "b_air"),
        ("sidespecial", "b_forward"),
        ("sideb", "b_forward"),
        ("sidebair", "b_forward_air"),
        ("upspecial", "b_up"),
        ("upb", "b_up"),
        ("upbair", "b_up_air"),
        ("downspecial", "b_down"),
        ("downb", "b_down"),
        ("downbair", "b_down_air"),
        // Throws
        ("throwforward", "throw_forward"),
        ("throwback", "throw_back"),
        ("throwup", "throw_up"),
        ("throwdown", "throw_down"),
        ("grab", "grab"),
        // Defense
        ("shield", "defend"),
        ("roll", "dodgeroll"),
        ("airdodge", "airdodge"),
        ("sidestep", "sidestep"),
        // Damage
        ("hurt", "hurt"),
        ("hurts", "hurt"),       // SSF2 uses plural: Hurts_67
        ("stun", "stunned"),
        ("stunned", "stunned"),
        ("dizzy", "dizzy"),
        ("sleep", "sleep"),
        ("tumble", "falling"),
        ("tumblefall", "falling"), // TumbleFall_81
        ("sentflying", "crash"),   // SentFlying_72 = knockdown/star-KO trajectory
        ("knockdown", "crash"),
        ("frozen", "frozen"),
        ("egg", "egg"),
        ("star", "star_ko"),
        ("starko", "starko"),
        ("pitfall", "pitfall"),
        // Edge
        ("hang", "hang"),
        ("climbup", "climbup"),
        ("hangclimb", "climbup"),   // HangClimb_74
        ("edgelean", "edgelean"),
        ("rollup", "rollup"),
        ("hangroll", "rollup"),     // HangRoll_75
        ("ledgeattack", "ledge_attack"),
        ("hangattack", "ledge_attack"), // HangAttack_76
        // Defense
        ("guard", "defend"),        // Guard_78
        ("spotdodge", "sidestep"),  // SpotDodge_71
        // Misc
        ("taunts", "taunt"),        // Taunts_86
        ("taunt", "taunt"),
        ("getupattack", "getup_attack"),
        ("getup", "tech_ground"),   // GetUp_82
        ("carry", "carry"),
        ("tech", "tech_ground"),
        ("techground", "tech_ground"), // TechGround_203
        ("techroll", "tech_roll"),
        ("getuproll", "tech_roll"),  // GetUpRoll_77
        // Run
        ("run", "run"),
        ("dash", "run"),
        ("turn", "run"),      // Turn_14 = dash turn, part of run state
        ("revival", "revival"),
        ("win", "win"),
        // Specials (SSF2-specific label names)
        ("nspecial", "b"),
        ("nspecialair", "b_air"),
        ("sspecial", "b_forward"),
        ("sspecialair", "b_forward_air"),
        ("uspecial", "b_up"),
        ("uspecialair", "b_up_air"),
        ("dspecial", "b_down"),
        ("dspecialair", "b_down_air"),
        ("screwattack", "b_up"),    // Mario's up-b is screwattack
        ("specialland", "land"),    // SpecialLand_19
        // Smash attacks (alternate label forms)
        ("dsmash", "a_down"),       // DSmash_29 = down smash, not in xframe table? map to strong_down
        // Throws
        ("fthrow", "throw_forward"),
        ("bthrow", "throw_back"),
        ("uthrow", "throw_up"),
        ("dthrow", "throw_down"),
        ("grabpummel", "grab"),      // Grab_Pummel_66
        // Items
        ("itemswing", "item_jab"),
        ("itemdashattack", "item_dash"),
        ("itemthrows", "toss"),
        ("itemthrowsair", "toss_air"),
        ("itempickup", "item_pickup"),
        ("itemraise", "item_raise"),
        ("itemshoot", "item_shoot"),
        ("itemsmash", "item_smash"),
        ("itemtilt", "item_tilt"),
        ("itemfan", "item_fan"),
        ("itemhomerun", "item_homerun"),
        ("itemhomrun", "item_homerun"), // alternate spelling
    ];

    for (label, ssf2) in label_to_ssf2 {
        if normalized == *label {
            return Some(ssf2.to_string());
        }
    }

    None
}

fn strip_numeric_suffix(s: &str) -> &str {
    let bytes = s.as_bytes();
    let mut end = bytes.len();
    // Strip trailing _NNN
    if let Some(pos) = s.rfind('_') {
        let suffix = &s[pos + 1..];
        if suffix.chars().all(|c| c.is_ascii_digit()) {
            end = pos;
        }
    }
    &s[..end]
}

fn normalize_anim_label(s: &str) -> String {
    // CamelCase → lowercase, remove underscores for matching
    s.to_lowercase().replace('_', "")
}

/// Extract per-frame collision box data from a single DefineSprite.
/// Returns a map of frame_index → list of boxes.
///
/// Strategy: simulate the Flash display list.
/// PlaceObject::Place(id) with name = new object at depth
/// PlaceObject::Modify = move/transform existing object at depth (no character change)
/// PlaceObject::Replace(id) = replace object at depth
/// RemoveObject = remove from display list
///
/// We track the display list across frames and snapshot the current boxes each frame.
fn extract_frame_boxes(
    sprite: &swf::Sprite,
    sym_names: &BTreeMap<u16, String>,
    base_size: f64,
) -> BTreeMap<u16, Vec<FrameBox>> {
    // Display list: depth → (char_id, instance_name, matrix)
    let mut display_list: BTreeMap<u16, DisplayItem> = BTreeMap::new();
    let mut current_frame: u16 = 0;
    let mut result: BTreeMap<u16, Vec<FrameBox>> = BTreeMap::new();

    // Pre-identify the collision box char id from symbol names
    // Any symbol whose name contains "collisonbox" or "collisionbox"
    let is_collision_char: std::collections::HashSet<u16> = sym_names.iter()
        .filter(|(_, n)| {
            let l = n.to_lowercase();
            l.contains("collisonbox") || l.contains("collisionbox")
        })
        .map(|(id, _)| *id)
        .collect();

    for tag in &sprite.tags {
        match tag {
            swf::Tag::ShowFrame => {
                // Snapshot collision boxes active this frame
                let boxes: Vec<FrameBox> = display_list.values()
                    .filter(|item| {
                        // Include if it's a known collision char id
                        // OR if the instance name looks like a box
                        is_collision_char.contains(&item.char_id)
                            || BoxType::from_instance_name(&item.instance_name).is_some()
                    })
                    .filter_map(|item| {
                        let box_type = BoxType::from_instance_name(&item.instance_name)?;
                        // Skip ItemBox in most contexts (it's just item grab range, not a real box)
                        // Keep for completeness — caller can filter
                        let (x, y, w, h) = matrix_to_box(&item.matrix, base_size);
                        Some(FrameBox {
                            box_type,
                            instance_name: item.instance_name.clone(),
                            x, y, width: w.abs(), height: h.abs(),
                        })
                    })
                    .collect();

                if !boxes.is_empty() {
                    result.insert(current_frame, boxes);
                }
                current_frame += 1;
            }

            swf::Tag::PlaceObject(po) => {
                let inst_name = po.name
                    .map(|s| s.to_str_lossy(encoding_rs::WINDOWS_1252).to_string())
                    .unwrap_or_default();

                match &po.action {
                    swf::PlaceObjectAction::Place(char_id) => {
                        // Only track if it's a collision box char OR has a box-like name
                        let is_box = is_collision_char.contains(char_id)
                            || BoxType::from_instance_name(&inst_name).is_some();
                        if is_box || !inst_name.is_empty() {
                            display_list.insert(po.depth, DisplayItem {
                                char_id: *char_id,
                                instance_name: inst_name,
                                matrix: po.matrix.unwrap_or(swf::Matrix::IDENTITY),
                            });
                        }
                    }
                    swf::PlaceObjectAction::Replace(char_id) => {
                        let is_box = is_collision_char.contains(char_id)
                            || BoxType::from_instance_name(&inst_name).is_some();
                        if is_box || !inst_name.is_empty() {
                            let entry = display_list.entry(po.depth).or_insert(DisplayItem {
                                char_id: *char_id,
                                instance_name: inst_name.clone(),
                                matrix: swf::Matrix::IDENTITY,
                            });
                            entry.char_id = *char_id;
                            if !inst_name.is_empty() { entry.instance_name = inst_name; }
                            if let Some(m) = po.matrix { entry.matrix = m; }
                        }
                    }
                    swf::PlaceObjectAction::Modify => {
                        // Update position of existing object
                        if let Some(entry) = display_list.get_mut(&po.depth) {
                            if let Some(m) = po.matrix { entry.matrix = m; }
                            if !inst_name.is_empty() { entry.instance_name = inst_name; }
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

    result
}

struct DisplayItem {
    char_id: u16,
    instance_name: String,
    matrix: swf::Matrix,
}

/// Convert a SWF matrix to (x, y, width, height) in pixels.
/// The CollisonBox shape is base_size × base_size pixels, centered at (0,0).
/// Matrix scale (a,d) gives the actual dimensions; tx/ty give the center position.
fn matrix_to_box(m: &swf::Matrix, base_size: f64) -> (f64, f64, f64, f64) {
    // tx/ty are in twips (1/20 pixel)
    let cx = m.tx.get() as f64 / 20.0;
    let cy = m.ty.get() as f64 / 20.0;

    // a = scale_x, d = scale_y (Fixed16 → f64)
    let scale_x = m.a.to_f64();
    let scale_y = m.d.to_f64();

    let w = scale_x * base_size;
    let h = scale_y * base_size;

    // tx/ty appear to be the top-left corner position based on dump_sprites output
    // (the CollisonBox registration point is at 0,0 top-left in SSF2)
    let x = cx;
    let y = cy;

    (x, y, w, h)
}
