# JPEXS Workflow — Know Before You Code

Before touching any ABC parsing or extraction logic, **inspect the SWF first with JPEXS**. It shows you exactly what the bytecode contains so you know what you're targeting.

## Install JPEXS (ffdec)

```bash
brew install --cask jpexs-decompiler
# opens as JPEXS Free Flash Decompiler (ffdec)
```

Or download from: https://github.com/jindrapetrik/jpexs-decompiler/releases

Download `ffdec.jar` from the releases page above — it's the standalone CLI/GUI app.

---

## GUI Workflow (recommended first step)

1. **Open the SWF**: `File → Open` → select `mario.ssf` or `misc.ssf`
2. **Navigate to scripts**: expand `scripts/` in the left panel
3. **Find the class**: e.g. `Mario`, `MarioExt`, `Misc`, `MarioAPI`
4. **Click a method**: JPEXS decompiles it to readable ActionScript 3

Key things to look for:

| What you want | Where to look |
|---|---|
| Costume color data | `getCostumeData()` in the character's class or `Misc`/`MarioAPI` |
| Attack definitions | `getAttackStats()`, `initAttacks()` |
| Animation frame lists | `getFrameScript()`, `initFrames()` |
| Palette swap logic | `applyPalette()`, `getPaletteSwapData()` |

5. **Copy the ActionScript** — paste it into a comment or reference file so you know the exact structure before writing the parser

---

## CLI / Headless Extraction

```bash
# Export all ActionScript source from a SWF
java -jar /tmp/ffdec/ffdec.jar -export script /tmp/mario_scripts/ mario.ssf

# Export specific class
java -jar /tmp/ffdec/ffdec.jar -export script /tmp/misc_scripts/ misc.ssf

# Then grep for what you need
grep -r "getCostumeData\|colors\|costume" /tmp/misc_scripts/ -l
```

This dumps readable `.as` files — way easier to read than reverse-engineering the bytecode.

---

## Costume Extraction — Methodology

### Step 1: Dump the AS3 source first

```bash
java -jar /path/to/ffdec.jar -export script /tmp/misc_scripts/ misc.ssf
grep -r "getCostumeData\|costume_data\|colors" /tmp/misc_scripts/ -l
```

### Step 2: Read the decompiled method

Look for something like:
```actionscript
public function getCostumeData() : Array {
    return [
        {name: "Default", colors: [0xFF0000, 0xFFFFFF, ...]},
        {name: "Fire",    colors: [0xFFAA00, 0xFF5500, ...]},
        ...
    ];
}
```

This tells you:
- The exact method name and which class it lives in
- The data structure (array of objects vs flat array vs something else)
- The color format (ARGB uint, separate RGB, etc.)
- How many colors per costume and what they map to

### Step 3: Write the parser to match exactly

Only after you know the exact structure from JPEXS should you write/modify ABC parsing code. You're matching a known pattern, not guessing.

---

## misc.ssf Structure (confirmed via JPEXS)

misc.ssf contains a `Misc` class with a `getCostumeData()` method that holds **all 45 characters' costume palettes**.

### Actual data structure

```actionscript
// In Misc.as, getCostumeData():
_loc1_["mario"] = new Array();
_loc1_["mario"].push({
    "team": "red",          // OR "base":true OR neither (alt costume)
    "paletteSwap": {
        "colors":       [4285913463, ...],  // 76 source ARGB uints — base sprite palette
        "replacements": [4294932346, ...],  // 76 ARGB uints — what those colors become
    },
    "paletteSwapPA": { ... }  // pixel-art mode variant, ignored
});
```

- 45 characters, 15 costumes each (Red, Green, Blue, Default, Alt 1–11)
- `colors` is identical across all costumes — it's the source palette
- `replacements` is the per-costume color swap
- Colors are ARGB uints (e.g. `4285913463` = `0xFF7F777A`)

### Extraction

```bash
# 1. Dump Misc.as from misc.ssf
java -jar /tmp/ffdec/ffdec.jar -export script /tmp/misc_scripts/ misc.ssf

# 2. Parse to JSON (Rust binary)
./target/release/extract_costumes /tmp/misc_scripts/scripts/Misc.as ssf2_costumes.json

# 3. Convert with real costumes
./target/release/ssf2_converter mario.ssf \
    --costumes ssf2_costumes.json \
    --output ./characters
```

---

## Rule

**No ABC parser changes without first reading the decompiled AS3.**

If JPEXS can't decompile something, check raw bytecode with `dump_costumes` or `dump_sprites` binaries — but treat JPEXS output as ground truth when available.
