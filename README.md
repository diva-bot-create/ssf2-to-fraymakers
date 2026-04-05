# ssf2-to-fraymakers

Converts Super Smash Flash 2 character data to [Fraymakers](https://www.fraymakersthegame.com/) mod format.

## Requirements

- Rust (stable) — that's it

## Build

```bash
cargo build --release
```

Binaries in `target/release/`:
- `ssf2_converter` — main character converter
- `extract_costumes` — extracts palette data from misc.ssf via decompiled Misc.as

## Usage

### 1. Extract costume palettes from misc.ssf (one-time setup)

```bash
# Reads misc.ssf directly — no external tools needed
./target/release/extract_costumes misc.ssf ssf2_costumes.json
```

### 2. Convert a character

```bash
# With real SSF2 costume data (recommended)
./target/release/ssf2_converter mario.ssf --costumes ssf2_costumes.json

# Without (falls back to k-means palette from sprites)
./target/release/ssf2_converter mario.ssf
```

Output goes to `./characters/{name}/` — a complete Fraymakers character package.

## Output structure

```
characters/mario/
  library/
    scripts/Character/
      CharacterStats.hx     — movement physics
      HitboxStats.hx        — per-attack hitbox data
      AnimationStats.hx     — animation flags
      Script.hx             — character logic
    entities/
      Character.entity      — Fraymakers entity with palette map
    costumes.palettes        — 15 SSF2 costumes (Red/Green/Blue/Default + 11 alts)
    costumes.palettes.meta
    sprites/
      mario_*.png           — extracted sprite frames
      palette_preview.png   — palette color slots (76px wide)
  mario.fraytools           — FrayTools project file
```

## How costumes work

SSF2 stores costume data in `misc.ssf` → `Misc.as` → `getCostumeData()`.
Each character has 15 costumes:
- **Red / Green / Blue** — team color variants
- **Default** — the base costume (`"base": true`)
- **Alt 1–11** — additional unlockable costumes

Each costume contains 76 source colors (`colors`) and 76 replacement colors (`replacements`).
The converter maps these directly to Fraymakers palette color slots + maps.

## Notes

- Original SSF2 character data © McLeodGaming — this tool is for mod development only
- `JPEXS_WORKFLOW.md` documents internal SWF/ABC inspection done during development (not required for use)
