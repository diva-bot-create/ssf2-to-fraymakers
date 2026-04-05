#!/usr/bin/env python3
"""
Extract SSF2 costume palette data from a decompiled Misc.as file.

Usage:
    python3 extract_costumes.py <Misc.as> [character_name]

Output:
    costumes.json — map of character → list of costume palettes

Data structure in Misc.as:
    _loc1_["mario"] = new Array();
    _loc1_["mario"].push({
        "team": "red",           // or "base":true, or neither (alt costume)
        "paletteSwap": {
            "colors":       [...],  // source colors from base sprite
            "replacements": [...],  // what those colors become for this costume
        },
        "paletteSwapPA": { ... }    // same but for pixel-art mode (ignored)
    });
"""

import re, json, sys

def parse_int_array(s):
    return [int(x.strip()) for x in s.split(',') if x.strip()]

def argb_to_hex(v):
    """Convert SSF2 ARGB uint to #AARRGGBB hex string."""
    return f"#{v & 0xFFFFFFFF:08X}"

def parse_misc_as(path, only_char=None):
    txt = open(path, encoding='utf-8', errors='replace').read()

    # Find all character array inits: _loc1_["mario"] = new Array();
    char_positions = [(m.group(1), m.start()) for m in
                      re.finditer(r'_loc1_\["(\w+)"\]\s*=\s*new Array\(\)', txt)]

    result = {}

    for ci, (char_name, char_start) in enumerate(char_positions):
        if only_char and char_name != only_char:
            continue

        # Get text up to next character init
        end = char_positions[ci+1][1] if ci+1 < len(char_positions) else len(txt)
        section = txt[char_start:end]

        # Split on .push({ to get each costume block
        blocks = section.split('.push({')[1:]

        costumes = []
        alt_index = 1

        for block in blocks:
            # Determine costume label
            team_m = re.search(r'"team"\s*:\s*"(\w+)"', block)
            base_m = re.search(r'"base"\s*:\s*true', block)
            name_m = re.search(r'"name"\s*:\s*"([^"]+)"', block)

            if base_m:
                label = "Default"
            elif team_m:
                label = team_m.group(1).capitalize()  # Red, Green, Blue
            elif name_m:
                label = name_m.group(1)
            else:
                label = f"Alt {alt_index}"
                alt_index += 1

            # Extract paletteSwap (not paletteSwapPA)
            # Find the first "paletteSwap":{ block (not paletteSwapPA)
            ps_m = re.search(r'"paletteSwap"\s*:\s*\{', block)
            if not ps_m:
                continue

            ps_block = block[ps_m.end():]

            colors_m = re.search(r'"colors"\s*:\s*\[([^\]]+)\]', ps_block)
            reps_m   = re.search(r'"replacements"\s*:\s*\[([^\]]+)\]', ps_block)

            if not colors_m or not reps_m:
                continue

            colors       = parse_int_array(colors_m.group(1))
            replacements = parse_int_array(reps_m.group(1))

            costumes.append({
                "name":         label,
                "colors":       colors,
                "replacements": replacements,
                # Hex versions for human readability
                "colors_hex":       [argb_to_hex(c) for c in colors],
                "replacements_hex": [argb_to_hex(c) for c in replacements],
            })

        if costumes:
            result[char_name] = costumes

    return result

def main():
    path = sys.argv[1] if len(sys.argv) > 1 else "/tmp/misc_scripts/scripts/Misc.as"
    only_char = sys.argv[2] if len(sys.argv) > 2 else None

    data = parse_misc_as(path, only_char)

    out_path = "/tmp/ssf2_costumes.json"
    with open(out_path, 'w') as f:
        json.dump(data, f, indent=2)

    print(f"Extracted {len(data)} characters:")
    for char, costumes in sorted(data.items()):
        labels = [c['name'] for c in costumes]
        print(f"  {char:20} {len(costumes)} costumes: {', '.join(labels)}")
    print(f"\nSaved to {out_path}")

if __name__ == '__main__':
    main()
