#!/usr/bin/env python3
"""
SSF2 → Fraymakers converter
Generates HitboxStats.hx, CharacterStats.hx, AnimationStats.hx, Script.hx
from JPEXS-decompiled AS3 source.

Usage:
    python3 scripts/convert.py <as3_dir> <output_dir>

    as3_dir:    directory containing one subdir per character (e.g. /tmp/ssf2_as3/)
    output_dir: where to write characters/{name}/*.hx (e.g. ./characters/)
"""

import sys, os, re, glob

# ─────────────────────────────────────────────────────────────────────────────
# SSF2 → Fraymakers move name mapping
# ─────────────────────────────────────────────────────────────────────────────

MOVE_MAP = {
    # SSF2 name          : Fraymakers name
    "a":                   "jab1",
    "a_tilt":              "jab1",
    "a_forward":           "dash_attack",
    "a_forward_tilt":      "tilt_forward",
    "a_up_tilt":           "tilt_up",
    "a_down_tilt":         "tilt_down",
    "crouch_attack":       "tilt_down",
    "a_forwardsmash":      "strong_forward_attack",
    "a_up":                "strong_up_attack",
    "a_down":              "strong_down_attack",
    "a_air":               "aerial_neutral",
    "a_air_forward":       "aerial_forward",
    "a_air_backward":      "aerial_back",
    "a_air_up":            "aerial_up",
    "a_air_down":          "aerial_down",
    "b":                   "special_neutral",
    "b_air":               "special_neutral_air",
    "b_forward":           "special_side",
    "b_forward_air":       "special_side_air",
    "b_up":                "special_up",
    "b_up_air":            "special_up_air",
    "b_down":              "special_down",
    "b_down_air":          "special_down_air",
    "throw_up":            "throw_up",
    "throw_forward":       "throw_forward",
    "throw_back":          "throw_back",
    "throw_down":          "throw_down",
    "ledge_attack":        "ledge_attack",
    "getup_attack":        "crash_attack",
    "special":             "emote",  # final smash → emote slot (placeholder)
}

# Stats to skip when outputting hitboxes (SSF2-only, no Fraymakers equivalent)
SKIP_HITBOX_KEYS = {
    "effect_id", "effectSound", "shock", "burn", "darkness", "paralysis",
    "burn", "cpuAttackQueue", "attackVoice1_id", "attackVoice2_id",
    "attackVoice3_id", "attackVoice4_id", "attackVoice5_id",
    "attackSound1_id", "attackSound2_id", "attackSound3_id",
    "attackSound4_id", "attackSound5_id", "attackSound6_id",
    "hasEffect", "bypassShield", "bypassHeavyArmor", "bypassSuperArmor",
    "bypassGrabbed", "bypassNonGrabbed", "stackKnockback",
    "onlyAffectsAir", "onlyAffectsGround", "meteorBounce", "meteorSFX",
    "forceTumbleFall", "priority", "camShake",
}

# SSF2 hitbox key → Fraymakers hitbox key
HITBOX_KEY_MAP = {
    "damage":         "damage",
    "direction":      "angle",
    "power":          "baseKnockback",
    "kbConstant":     "knockbackGrowth",
    "hitStun":        "hitstop",
    "selfHitStun":    "selfHitstop",
    "hitLag":         "hitstun",
    "reversableAngle":"reversibleAngle",
    "weightKB":       "baseKnockback",  # fallback if power missing
}

# ─────────────────────────────────────────────────────────────────────────────
# Determine attack limb from move name / hitbox context
# ─────────────────────────────────────────────────────────────────────────────

def guess_limb(move_name):
    m = move_name.lower()
    if "throw" in m:         return "AttackLimb.BODY"
    if "aerial_down" in m:   return "AttackLimb.FOOT"
    if "aerial_up" in m:     return "AttackLimb.FOOT"
    if "aerial_forward" in m:return "AttackLimb.FIST"
    if "aerial_back" in m:   return "AttackLimb.FIST"
    if "aerial_neutral" in m:return "AttackLimb.FIST"
    if "special_neutral" in m:return "AttackLimb.FIST"
    if "special_side" in m:  return "AttackLimb.FIST"
    if "special_up" in m:    return "AttackLimb.FIST"
    if "special_down" in m:  return "AttackLimb.FOOT"
    if "tilt_down" in m:     return "AttackLimb.FOOT"
    if "tilt_up" in m:       return "AttackLimb.FIST"
    if "tilt_forward" in m:  return "AttackLimb.FIST"
    if "strong_down" in m:   return "AttackLimb.FOOT"
    if "strong_up" in m:     return "AttackLimb.FIST"
    if "strong_forward" in m:return "AttackLimb.FOOT"
    if "dash_attack" in m:   return "AttackLimb.FOOT"
    if "jab" in m:           return "AttackLimb.FIST"
    if "ledge" in m or "crash" in m: return "AttackLimb.FOOT"
    return "AttackLimb.FIST"

# ─────────────────────────────────────────────────────────────────────────────
# Parse AS3 object literals from {CharacterName}Ext.as
# ─────────────────────────────────────────────────────────────────────────────

def extract_balanced(text, start):
    """Return (content_including_braces, end_pos) for balanced {} starting at start."""
    depth = 0
    i = start
    in_string = False
    escape = False
    in_line_comment = False
    in_block_comment = False
    while i < len(text):
        c = text[i]
        if in_line_comment:
            if c == '\n': in_line_comment = False
        elif in_block_comment:
            if c == '*' and i+1 < len(text) and text[i+1] == '/':
                in_block_comment = False; i += 1
        elif in_string:
            if escape: escape = False
            elif c == '\\': escape = True
            elif c == '"': in_string = False
        else:
            if c == '/' and i+1 < len(text):
                if text[i+1] == '/': in_line_comment = True
                elif text[i+1] == '*': in_block_comment = True
            elif c == '"': in_string = True
            elif c == '{': depth += 1
            elif c == '}':
                depth -= 1
                if depth == 0:
                    return text[start:i+1], i+1
        i += 1
    return None, -1


def parse_as3_value(s):
    """Parse a simple AS3 value string into a Python value."""
    s = s.strip()
    if s in ('true', 'True'):   return True
    if s in ('false', 'False'): return False
    if s in ('null', 'None'):   return None
    if s.startswith('"') and s.endswith('"'): return s[1:-1]
    try: return int(s)
    except ValueError: pass
    try: return float(s)
    except ValueError: pass
    return s  # return as-is (identifier, etc.)


def parse_flat_object(text):
    """
    Parse a flat { key: value, ... } AS3 object literal.
    Handles nested objects (returns them as dicts).
    Does NOT handle arrays.
    """
    # Strip outer braces
    text = text.strip()
    if text.startswith('{') and text.endswith('}'):
        text = text[1:-1]

    result = {}
    i = 0
    text = text.strip()
    n = len(text)

    while i < n:
        # Skip whitespace and commas
        while i < n and text[i] in ' \t\n\r,': i += 1
        if i >= n: break

        # Skip comments
        if text[i:i+2] == '//':
            while i < n and text[i] != '\n': i += 1
            continue
        if text[i:i+2] == '/*':
            end = text.find('*/', i+2)
            i = end + 2 if end != -1 else n
            continue

        # Read key (may be quoted or unquoted)
        if text[i] == '"':
            end = text.index('"', i+1)
            key = text[i+1:end]
            i = end + 1
        else:
            end = i
            while end < n and text[end] not in ' \t\n\r:,{}': end += 1
            key = text[i:end].strip()
            i = end
        if not key: break

        # Skip whitespace then colon
        while i < n and text[i] in ' \t\n\r': i += 1
        if i >= n or text[i] != ':': break
        i += 1
        while i < n and text[i] in ' \t\n\r': i += 1

        # Read value
        if i < n and text[i] == '{':
            # Nested object
            nested_text, end_pos = extract_balanced(text, i)
            if nested_text:
                result[key] = parse_flat_object(nested_text)
                i = end_pos
            else:
                break
        elif i < n and text[i] == '[':
            # Array — find closing bracket
            depth = 0
            j = i
            while j < n:
                if text[j] == '[': depth += 1
                elif text[j] == ']':
                    depth -= 1
                    if depth == 0: break
                j += 1
            result[key] = text[i:j+1]  # keep as string
            i = j + 1
        else:
            # Scalar value — read until comma or closing brace
            j = i
            while j < n and text[j] not in ',}':
                if text[j] == '"':
                    j += 1
                    while j < n and text[j] != '"': j += 1
                j += 1
            result[key] = parse_as3_value(text[i:j])
            i = j

    return result


def extract_function_body(as3_text, fn_name):
    """Extract the body dict of a named function returning an object literal."""
    # Find the function
    pat = re.compile(
        r'(?:override\s+)?public\s+function\s+' + re.escape(fn_name) + r'\s*\([^)]*\)[^{]*\{',
        re.DOTALL
    )
    m = pat.search(as3_text)
    if not m: return None

    # Extract function body
    body, _ = extract_balanced(as3_text, m.end() - 1)
    return body


def extract_named_loc(fn_body, var_name):
    """
    Extract a specific _locN_ object assignment from a function body.
    Returns parsed dict or None.
    """
    pat = re.compile(re.escape(var_name) + r'\s*=\s*\{', re.DOTALL)
    m = pat.search(fn_body)
    if not m:
        return None
    start = m.end() - 1
    block, _ = extract_balanced(fn_body, start)
    if block:
        return parse_flat_object(block)
    return None


def extract_loc2_object(fn_body):
    """
    Extract the _loc2_ object (attackData) from getAttackStats body.
    Falls back to _loc1_ if _loc2_ not found.
    """
    for var in ['_loc2_', '_loc1_']:
        result = extract_named_loc(fn_body, var)
        if result:
            return result
    return None


# ─────────────────────────────────────────────────────────────────────────────
# Generate HitboxStats.hx
# ─────────────────────────────────────────────────────────────────────────────

def hitbox_props_to_hx(props, fm_move_name):
    """Convert a single SSF2 attackBox dict to Fraymakers hitbox properties string."""
    parts = []
    for ssf2_key, fm_key in HITBOX_KEY_MAP.items():
        if ssf2_key in props:
            val = props[ssf2_key]
            if val is None: continue
            # hitLag in SSF2 is a multiplier; -1 means default → map to hitstun: -1
            if ssf2_key == "hitLag":
                if isinstance(val, float) and val < 0:
                    parts.append(f"hitstun: -1")
                elif isinstance(val, (int, float)) and val > 0:
                    parts.append(f"hitstun: {int(val)}")
                continue
            if ssf2_key == "reversableAngle":
                parts.append(f"reversibleAngle: {str(val).lower()}")
                continue
            if isinstance(val, bool):
                parts.append(f"{fm_key}: {str(val).lower()}")
            elif isinstance(val, float):
                parts.append(f"{fm_key}: {val}")
            else:
                parts.append(f"{fm_key}: {val}")

    # Add limb
    parts.append(f"limb: {guess_limb(fm_move_name)}")

    return ", ".join(parts)


def gen_hitbox_stats(char_name, attack_data):
    """Generate HitboxStats.hx content from parsed SSF2 attack data dict."""
    lines = [
        f"// HitboxStats for {char_name.title()}",
        f"// Source: {char_name.title()}Ext.as → getAttackStats()",
        "//",
        "// SSF2 → Fraymakers field mapping:",
        "//   damage      → damage",
        "//   power       → baseKnockback",
        "//   kbConstant  → knockbackGrowth",
        "//   direction   → angle",
        "//   hitStun     → hitstop",
        "//   selfHitStun → selfHitstop",
        "//   hitLag      → hitstun (-1 = default multiplier)",
        "{",
    ]

    # Group by Fraymakers move category
    categories = [
        ("//LIGHT ATTACKS",   ["jab1", "jab2", "jab3", "dash_attack"]),
        ("//TILT ATTACKS",    ["tilt_forward", "tilt_up", "tilt_down"]),
        ("//STRONG ATTACKS",  ["strong_forward_attack", "strong_up_attack", "strong_down_attack"]),
        ("//AERIAL ATTACKS",  ["aerial_neutral", "aerial_forward", "aerial_back", "aerial_up", "aerial_down"]),
        ("//SPECIAL ATTACKS", ["special_neutral", "special_neutral_air",
                                "special_side", "special_side_air",
                                "special_up", "special_up_air",
                                "special_down", "special_down_air"]),
        ("//THROWS",          ["throw_up", "throw_forward", "throw_back", "throw_down"]),
        ("//MISC ATTACKS",    ["ledge_attack", "crash_attack", "emote"]),
    ]

    # Build reverse map: fraymakers_name → [(ssf2_name, attack_entry)]
    fm_to_ssf2 = {}
    for ssf2_name, move_data in attack_data.items():
        if not isinstance(move_data, dict): continue
        fm_name = MOVE_MAP.get(ssf2_name)
        if not fm_name: continue
        if fm_name not in fm_to_ssf2:
            fm_to_ssf2[fm_name] = []
        fm_to_ssf2[fm_name].append((ssf2_name, move_data))

    for cat_label, cat_moves in categories:
        cat_lines = []
        for fm_move in cat_moves:
            if fm_move not in fm_to_ssf2: continue
            entries = fm_to_ssf2[fm_move]
            # Use first matching entry
            ssf2_name, move_data = entries[0]

            # Find attackBoxes
            attack_boxes = move_data.get("attackBoxes", {})
            if not isinstance(attack_boxes, dict) or not attack_boxes:
                cat_lines.append(f"\t{fm_move}: {{ // SSF2: {ssf2_name}")
                cat_lines.append(f"\t\thitbox0: {{}}")
                cat_lines.append(f"\t}},")
                continue

            box_list = list(attack_boxes.values())
            cat_lines.append(f"\t{fm_move}: {{ // SSF2: {ssf2_name}")
            for i, box in enumerate(box_list):
                if not isinstance(box, dict): continue
                props_str = hitbox_props_to_hx(box, fm_move)
                cat_lines.append(f"\t\thitbox{i}: {{ {props_str} }},")
            cat_lines.append(f"\t}},")

        if cat_lines:
            lines.append("")
            lines.append(f"\t{cat_label}")
            lines.extend(cat_lines)

    lines.append("}")
    return "\n".join(lines)


# ─────────────────────────────────────────────────────────────────────────────
# Generate CharacterStats.hx
# ─────────────────────────────────────────────────────────────────────────────

# SSF2 stat → (Fraymakers stat, scale_factor, comment)
OWN_STATS_MAP = [
    ("weight1",               "weight",                    1.0,   "SSF2: weight1"),
    ("gravity",               "gravity",                   1.0,   "SSF2: gravity"),
    ("shortHopSpeed",         "shortHopSpeed",             1.0,   "SSF2: shortHopSpeed"),
    ("jumpSpeed",             "jumpSpeed",                 1.0,   "SSF2: jumpSpeed"),
    ("jumpSpeedMidair",       "doubleJumpSpeeds",          None,  "SSF2: jumpSpeedMidair → array"),
    ("max_ySpeed",            "terminalVelocity",          1.0,   "SSF2: max_ySpeed"),
    ("fastFallSpeed",         "fastFallSpeed",             1.0,   "SSF2: fastFallSpeed"),
    ("decel_rate",            "friction",                  -1.0,  "SSF2: abs(decel_rate)"),
    ("accel_start",           "walkSpeedInitial",          1.0,   "SSF2: accel_start"),
    ("accel_start",           "walkSpeedAcceleration",     1.0,   "SSF2: accel_start"),
    ("norm_xSpeed",           "walkSpeedCap",              1.0,   "SSF2: norm_xSpeed"),
    ("accel_start_dash",      "dashSpeed",                 None,  "SSF2: accel_start_dash (approx)"),
    ("norm_xSpeed",           "runSpeedInitial",           1.0,   "SSF2: norm_xSpeed"),
    ("accel_rate",            "runSpeedAcceleration",      1.0,   "SSF2: accel_rate"),
    ("max_xSpeed",            "runSpeedCap",               1.0,   "SSF2: max_xSpeed"),
    ("accel_rate",            "groundSpeedAcceleration",   1.0,   "SSF2: accel_rate"),
    ("max_xSpeed",            "groundSpeedCap",            1.0,   "SSF2: max_xSpeed"),
    ("accel_rate_air",        "aerialSpeedAcceleration",   1.0,   "SSF2: accel_rate_air"),
    ("max_xSpeed",            "aerialSpeedCap",            1.0,   "SSF2: max_xSpeed"),
    ("decel_rate_air",        "aerialFriction",            -1.0,  "SSF2: abs(decel_rate_air)"),
    ("width",                 "floorHipWidth",             1.0,   "SSF2: width"),
    ("height",                "floorHeadPosition",         1.0,   "SSF2: height"),
    ("width",                 "aerialHipWidth",            1.0,   "SSF2: width"),
    ("height",                "aerialHeadPosition",        1.0,   "SSF2: height"),
    ("dodgeSpeed",            "dodgeRollSpeed",            1.0,   "SSF2: dodgeSpeed"),
    ("getup_roll_delay",      "dodgeRollSpeedStartFrame",  1.0,   "SSF2: getup_roll_delay"),
    ("tech_roll_delay",       "techRollSpeedStartFrame",   1.0,   "SSF2: tech_roll_delay"),
    ("climb_roll_delay",      "ledgeRollSpeedStartFrame",  1.0,   "SSF2: climb_roll_delay"),
]

CHAR_STATS_DEFAULTS = {
    "jumpSpeedForwardInitialXSpeed":  3,
    "jumpSpeedBackwardInitialXSpeed": -3,
    "floorHipXOffset":   0,
    "floorHipYOffset":   0,
    "floorFootPosition": 0,
    "aerialHipXOffset":  0,
    "aerialHipYOffset":  0,
    "aerialFootPosition": 16,
    "cameraBoxOffsetX": 25,
    "cameraBoxOffsetY": 75,
    "cameraBoxWidth":  200,
    "cameraBoxHeight": 250,
    "techRollSpeed":    18,
    "techRollSpeedLength": 1,
    "dodgeRollSpeedLength": 1,
    "getupRollSpeed":   15.5,
    "getupRollSpeedStartFrame": 2,
    "getupRollSpeedLength": 1,
    "ledgeRollSpeed":   14,
    "ledgeRollSpeedLength": 1,
    "ledgeJumpXSpeed":  2.5,
    "ledgeJumpYSpeed": -10,
    "airdashInitialSpeed": 11,
    "airdashSpeedCap":  12.5,
    "airdashAccelMultiplier": 0.4,
    "airdashCancelSpeedConservation": 0.9,
    "wallJumpXSpeed":   8.5,
    "wallJumpYSpeed":   14,
    "wallJumpLimit":    1,
    "buryAnimation":    '"hurt_thrown"',
    "buryFrame":        13,
    "buryOffsetY":     -10,
    "shieldCrossupThreshold": 16,
    "shieldFrontNineSliceContent": '"global::vfx.vfx_shield_front"',
    "shieldFrontXOffset": 10.5,
    "shieldFrontYOffset": 4,
    "shieldFrontWidth":  53,
    "shieldFrontHeight": 93,
    "shieldBackNineSliceContent": '"global::vfx.vfx_shield_back"',
    "shieldBackXOffset": 12.5,
    "shieldBackYOffset": 4,
    "shieldBackWidth":   49,
    "shieldBackHeight":  93,
    "attackVoiceSilenceRate": 0.5,
    "hurtLightSilenceRate":   1,
    "hurtMediumSilenceRate":  0.5,
    "hurtHeavySilenceRate":   0,
    "koVoiceSilenceRate":     0,
}


def gen_char_stats(char_name, own_stats):
    """Generate CharacterStats.hx from parsed SSF2 getOwnStats() dict."""
    lines = [
        f"// CharacterStats for {char_name.title()}",
        f"// Source: {char_name.title()}Ext.as → getOwnStats()",
        "{",
        f'\tspriteContent: self.getResource().getContent("{char_name}"),',
        "",
        "\t//GENERIC STATS",
        "\tbaseScaleX: 1.0,",
        "\tbaseScaleY: 1.0,",
    ]

    seen_fm = set()
    assigned = {}

    for ssf2_key, fm_key, scale, comment in OWN_STATS_MAP:
        if fm_key in seen_fm: continue
        if ssf2_key not in own_stats: continue
        val = own_stats[ssf2_key]
        if val is None: continue

        if fm_key == "doubleJumpSpeeds":
            max_jump = own_stats.get("max_jump", 1)
            jumps = [val] * int(max_jump) if isinstance(max_jump, int) else [val]
            assigned[fm_key] = (f"[{', '.join(str(j) for j in jumps)}]", comment)
        elif fm_key == "dashSpeed" and scale is None:
            # accel_start_dash is acceleration, not a speed cap — approximate
            dash = own_stats.get("accel_start_dash", val)
            run_cap = own_stats.get("max_xSpeed", 9)
            assigned[fm_key] = (round(run_cap * 0.9, 2), comment + " (estimated as 90% of max_xSpeed)")
        elif scale == -1.0:
            assigned[fm_key] = (abs(float(val)), comment)
        elif scale is not None:
            assigned[fm_key] = (val, comment)
        seen_fm.add(fm_key)

    # Output in logical sections
    sections = [
        ("//GENERIC STATS", [
            "weight", "gravity", "shortHopSpeed", "jumpSpeed",
            "jumpSpeedForwardInitialXSpeed", "jumpSpeedBackwardInitialXSpeed",
            "doubleJumpSpeeds", "terminalVelocity", "fastFallSpeed",
            "friction", "walkSpeedInitial", "walkSpeedAcceleration", "walkSpeedCap",
            "dashSpeed", "runSpeedInitial", "runSpeedAcceleration", "runSpeedCap",
            "groundSpeedAcceleration", "groundSpeedCap",
            "aerialSpeedAcceleration", "aerialSpeedCap", "aerialFriction",
            "wallJumpXSpeed", "wallJumpYSpeed", "wallJumpLimit",
        ]),
        ("//ECB STATS", [
            "floorHeadPosition", "floorHipWidth", "floorHipXOffset",
            "floorHipYOffset", "floorFootPosition",
            "aerialHeadPosition", "aerialHipWidth", "aerialHipXOffset",
            "aerialHipYOffset", "aerialFootPosition",
        ]),
        ("//CAMERA BOX STATS", [
            "cameraBoxOffsetX", "cameraBoxOffsetY", "cameraBoxWidth", "cameraBoxHeight",
        ]),
        ("//ROLL AND LEDGE STATS", [
            "techRollSpeed", "techRollSpeedStartFrame", "techRollSpeedLength",
            "dodgeRollSpeed", "dodgeRollSpeedStartFrame", "dodgeRollSpeedLength",
            "getupRollSpeed", "getupRollSpeedStartFrame", "getupRollSpeedLength",
            "ledgeRollSpeed", "ledgeRollSpeedStartFrame", "ledgeRollSpeedLength",
            "ledgeJumpXSpeed", "ledgeJumpYSpeed",
        ]),
        ("//AIRDASH STATS", [
            "airdashInitialSpeed", "airdashSpeedCap",
            "airdashAccelMultiplier", "airdashCancelSpeedConservation",
        ]),
        ("//BURY VISUAL STATS", [
            "buryAnimation", "buryFrame", "buryOffsetY",
        ]),
        ("//SHIELD STATS", [
            "shieldCrossupThreshold",
            "shieldFrontNineSliceContent", "shieldFrontXOffset", "shieldFrontYOffset",
            "shieldFrontWidth", "shieldFrontHeight",
            "shieldBackNineSliceContent", "shieldBackXOffset", "shieldBackYOffset",
            "shieldBackWidth", "shieldBackHeight",
        ]),
    ]

    # Build voice IDs from sounds block
    sounds = own_stats.get("sounds", {})
    attack_voices = []
    hurt_medium = []
    hurt_heavy = []
    ko_voices = []
    if isinstance(sounds, dict):
        for k, v in sounds.items():
            if v is None: continue
            if "hurt" in k.lower() and "bad" not in k.lower():
                hurt_medium.append(f'"{v}"')
            elif "bad" in k.lower():
                hurt_heavy.append(f'"{v}"')
            elif "dead" in k.lower() or "ko" in k.lower():
                ko_voices.append(f'"{v}"')

    # Collect attack voice IDs from attackVoiceN_id fields (appear in attack entries)
    # We'll add character-level voice IDs from the own_stats or attack_data

    first_section = True
    for section_label, section_keys in sections:
        section_lines = []
        for fm_key in section_keys:
            if fm_key in assigned:
                val, comment = assigned[fm_key]
                section_lines.append(f"\t{fm_key}: {val}, // {comment}")
            elif fm_key in CHAR_STATS_DEFAULTS:
                val = CHAR_STATS_DEFAULTS[fm_key]
                section_lines.append(f"\t{fm_key}: {val},")

        if section_lines:
            if not first_section:
                lines.append("")
            lines.append(f"\t{section_label}")
            lines.extend(section_lines)
            first_section = False

    # Voice stats
    lines.append("")
    lines.append("\t//VOICE STATS")
    lines.append(f"\tattackVoiceIds: [],  // TODO: populate from per-move attackVoiceN_id fields")
    lines.append(f"\thurtLightVoiceIds: [],")
    lines.append(f"\thurtMediumVoiceIds: [{', '.join(hurt_medium)}],")
    lines.append(f"\thurtHeavyVoiceIds: [{', '.join(hurt_heavy)}],")
    lines.append(f"\tkoVoiceIds: [{', '.join(ko_voices)}],")
    lines.append(f"\tattackVoiceSilenceRate: 0.5,")
    lines.append(f"\thurtLightSilenceRate: 1,")
    lines.append(f"\thurtMediumSilenceRate: 0.5,")
    lines.append(f"\thurtHeavySilenceRate: 0,")
    lines.append(f"\tkoVoiceSilenceRate: 0,")

    lines.append("}")
    return "\n".join(lines)


# ─────────────────────────────────────────────────────────────────────────────
# Generate AnimationStats.hx  (copy template with SSF2 move name comments)
# ─────────────────────────────────────────────────────────────────────────────

ANIM_TEMPLATE_PATH = '/tmp/fraymakers-template/library/scripts/Character/AnimationStats.hx'

def gen_anim_stats(char_name, own_stats):
    try:
        with open(ANIM_TEMPLATE_PATH) as f:
            template = f.read()
        # Replace first-line comment
        template = re.sub(
            r'^// Animation stats for.*$',
            f'// Animation stats for {char_name.title()} (converted from SSF2)',
            template, flags=re.MULTILINE
        )
        return template
    except FileNotFoundError:
        return f"// AnimationStats for {char_name.title()} — template not found\n{{}}"


# ─────────────────────────────────────────────────────────────────────────────
# Generate Script.hx
# ─────────────────────────────────────────────────────────────────────────────

SCRIPT_TEMPLATE_PATH = '/tmp/fraymakers-template/library/scripts/Character/Script.hx'

TRANSLATIONS = [
    (r'SSF2API\.print\([^;]*\);', '// (removed SSF2 debug print)'),
    (r'(?:this\.)?setAttackEnabled\(false\s*,\s*"([^"]+)"\)', r'self.setActionEnabled(false, "\1")'),
    (r'(?:this\.)?setAttackEnabled\(true\s*,\s*"([^"]+)"\)', r'self.setActionEnabled(true, "\1")'),
    (r'(?:this\.)?isCPU\(\)', 'self.isBot()'),
    (r'\bthis\.getX\(\)', 'self.getX()'),
    (r'\bthis\.getY\(\)', 'self.getY()'),
    (r'\bthis\.getXSpeed\(\)', 'self.getXVelocity()'),
    (r'\bthis\.getYSpeed\(\)', 'self.getYVelocity()'),
    (r'\bthis\.setXSpeed\(([^)]+)\)', r'self.setXVelocity(\1)'),
    (r'\bthis\.setYSpeed\(([^)]+)\)', r'self.setYVelocity(\1)'),
    (r'(?:this\.)?isOnGround\(\)', 'self.isOnFloor()'),
    (r'(?:this\.)?getHeldControls\(\)', 'self.getHeldControls()'),
    (r'(?:this\.)?getPressedControls\(\)', 'self.getPressedControls()'),
    (r'(?:this\.)?getNearestLedge\(\)', '// TODO: getNearestLedge()'),
    (r'(?:this\.)?inUpperLeftWarningBounds\(\)', '// TODO: inUpperLeftWarningBounds()'),
    (r'(?:this\.)?inUpperRightWarningBounds\(\)', '// TODO: inUpperRightWarningBounds()'),
    (r'\bthis\.(get|set|is|in|has|check|reset|fire|kill|restore|update|play|apply|remove|add|create|disable|enable|start|stop|loop|follow|clear|push|run|force)(\w+)\(', r'self.\1\2('),
    (r'SSF2API\.(\w+)\(', r'// TODO: SSF2API.\1('),
    (r'\bvar _loc(\d+)_\s*:', r'var _local\1:'),
    (r'\b_loc(\d+)_\b', r'_local\1'),
    (r':\s*void\b', ''),
    (r':\s*Boolean\b', ':Bool'),
    (r':\s*Number\b', ':Float'),
    (r':\s*int\b', ':Int'),
    (r':\s*String\b', ':String'),
    (r':\s*Object\b', ':Dynamic'),
    (r':\s*Array\b', ':Array<Dynamic>'),
    (r':\s*\*\b', ':Dynamic'),
    (r'Boolean\(([^)]+)\)', r'(\1 != null)'),
]

SKIP_FUNCTIONS = {
    'getOwnStats', 'getAttackStats', 'getItemStats', 'getProjectileStats',
    'flipX', 'clearEffectsOnStateChange', 'pushEffectBehind', 'addEffectToList',
    'removeAllEffects', 'stopListening', 'setLandingLag', 'applyPaletteToEffect',
    'setupAutolinkAngle', 'stopAutolinkAngle', 'updateAutolinkFunction',
    'loopEffect', 'followUser',
}


def translate_code(code):
    for pattern, replacement in TRANSLATIONS:
        code = re.sub(pattern, replacement, code)
    return code


def extract_char_functions(as3_text):
    class_match = re.search(r'public class \w+[^{]*\{(.*)', as3_text, re.DOTALL)
    if not class_match: return []
    class_body = class_match.group(1)

    functions = []
    fn_pat = re.compile(r'(override\s+)?public\s+function\s+(\w+)\s*\(([^)]*)\)[^{]*\{', re.DOTALL)
    for m in fn_pat.finditer(class_body):
        fn_name = m.group(2)
        if fn_name in SKIP_FUNCTIONS: continue
        if fn_name[0].isupper(): continue  # skip constructor
        body, _ = extract_balanced(class_body, m.end() - 1)
        if body:
            raw_params = m.group(3)
            functions.append((fn_name, raw_params, body))
    return functions


def gen_script_hx(char_name, as3_text):
    try:
        with open(SCRIPT_TEMPLATE_PATH) as f:
            template = f.read()
    except FileNotFoundError:
        template = "// Script.hx template not found\nfunction initialize(){}\nfunction update(){}"

    functions = extract_char_functions(as3_text)

    lines = [
        f"// Script.hx for {char_name.title()}",
        f"// Ported from SSF2 {char_name.title()}Ext.as",
        "",
        "// ── Base template ────────────────────────────────────────────────────────────",
        template,
        "",
        f"// ── {char_name.title()}-specific overrides ──────────────────────────────────",
        "",
    ]

    if not functions:
        lines.append("// No character-specific logic beyond stats.")
        return "\n".join(lines)

    for fn_name, raw_params, raw_body in functions:
        # Translate body
        inner = raw_body.strip()
        if inner.startswith('{'): inner = inner[1:]
        if inner.endswith('}'): inner = inner[:-1]
        translated_body = translate_code(inner)
        translated_params = translate_code(raw_params)

        if fn_name == 'initialize':
            lines.append("// NOTE: merge with base template initialize() if needed")
        sig = f"function {fn_name}({translated_params})"
        lines.append(f"{sig} {{")
        lines.append(translated_body)
        lines.append("}")
        lines.append("")

    return "\n".join(lines)


# ─────────────────────────────────────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────────────────────────────────────

def convert_character(char_name, as3_dir, out_dir):
    # Find Ext.as
    ext_files = glob.glob(os.path.join(as3_dir, 'scripts', '*Ext.as'))
    ext_files = [f for f in ext_files if 'SSF2CharacterExt' not in f]
    ext_files.sort(key=lambda p: (
        0 if char_name.replace('_','').lower() in os.path.basename(p).lower() else 1,
        p
    ))
    if not ext_files:
        return False, "no Ext.as found"

    ext_file = ext_files[0]
    with open(ext_file) as f:
        as3_text = f.read()

    # Extract getOwnStats and getAttackStats
    own_body   = extract_function_body(as3_text, 'getOwnStats')
    atk_body   = extract_function_body(as3_text, 'getAttackStats')

    own_stats  = {}
    attack_data = {}

    if own_body:
        # _loc1_ in getOwnStats is the character stats object (NOT _loc2_ which is attack data)
        own_stats = extract_named_loc(own_body, '_loc1_') or {}

    if atk_body:
        # _loc2_ in getAttackStats is the attack data object
        # Re-use extract_loc2_object but look for _loc2_ specifically
        pat = re.compile(r'_loc2_\s*=\s*\{', re.DOTALL)
        m = pat.search(atk_body)
        if m:
            block, _ = extract_balanced(atk_body, m.end() - 1)
            if block:
                attack_data = parse_flat_object(block)

    os.makedirs(out_dir, exist_ok=True)

    # HitboxStats.hx
    hitbox_hx = gen_hitbox_stats(char_name, attack_data)
    with open(os.path.join(out_dir, 'HitboxStats.hx'), 'w') as f:
        f.write(hitbox_hx)

    # CharacterStats.hx
    char_hx = gen_char_stats(char_name, own_stats)
    with open(os.path.join(out_dir, 'CharacterStats.hx'), 'w') as f:
        f.write(char_hx)

    # AnimationStats.hx
    anim_hx = gen_anim_stats(char_name, own_stats)
    with open(os.path.join(out_dir, 'AnimationStats.hx'), 'w') as f:
        f.write(anim_hx)

    # Script.hx
    script_hx = gen_script_hx(char_name, as3_text)
    with open(os.path.join(out_dir, 'Script.hx'), 'w') as f:
        f.write(script_hx)

    return True, os.path.basename(ext_file)


def main():
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <as3_dir> <output_dir>")
        sys.exit(1)

    as3_dir = sys.argv[1]
    out_dir  = sys.argv[2]

    char_dirs = sorted(glob.glob(os.path.join(as3_dir, '*')))
    ok = fail = 0

    for char_dir in char_dirs:
        char_name = os.path.basename(char_dir)
        char_out  = os.path.join(out_dir, char_name)
        print(f"  {char_name}...", end='', flush=True)
        success, info = convert_character(char_name, char_dir, char_out)
        if success:
            print(f" ✓ ({info})")
            ok += 1
        else:
            print(f" ✗ ({info})")
            fail += 1

    print(f"\nDone: {ok} OK, {fail} failed")


if __name__ == '__main__':
    main()
