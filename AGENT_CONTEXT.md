# SSF2 → Fraymakers Converter: Agent Context

This document is the authoritative reference for AI agents working on this codebase.
Both SSF2's SWF format and Fraymakers' entity format are largely undocumented.
Everything here was reverse-engineered from first principles during development.

---

## What this tool does

Converts Super Smash Flash 2 (SSF2) character `.ssf` files into Fraymakers character packages
compatible with FrayTools. It extracts:
- Bitmap images (PNG sprites per frame)
- Collision box data (hitboxes, hurtboxes, etc.) per animation frame
- Frame scripts (AS3 decompiled from ABC bytecode)
- Sound references
- Palette data

Output is a FrayTools character package directory:
```
characters/{name}/
  library/
    entities/Character.entity      ← main entity JSON (animations, layers, keyframes, symbols)
    sprites/                       ← extracted PNGs + .meta sidecar files
    scripts/Character/             ← Script.hx, AnimationStats.hx, HitboxStats.hx, CharacterStats.hx
  sounds/                          ← extracted sound files
```

---

## SSF2 (.ssf) File Format

`.ssf` files are renamed SWF files (Flash). Open with `swf::decompress_swf` + `swf::parse_swf`.

### SWF Structure for SSF2 Characters

```
SymbolClass        → maps char_id (u16) → class name string
DefineBitsLossless → raw bitmap data (RGBA)
DefineShape        → shape with a bitmap fill (wraps a DefineBitsLossless)
DefineSprite       → animation timeline (contains PlaceObject/ShowFrame/RemoveObject tags)
```

### Animation Sprites

Each character animation lives in a named `DefineSprite`:
- Name format: `{char}_fla.{AnimLabel}_{index}` e.g. `mario_fla.FAir_42`
- The root MC (main timeline) places these sprites at specific frame labels (stance labels)
- Each sprite contains a sequence of PlaceObject/ShowFrame/RemoveObject tags

### Root MC Transform

Every animation sprite is placed by the root MC with a transform:
```
tx, ty  = world offset of the character origin (typically negative, e.g. -24.70, -55.30)
sx, sy  = character scale (typically 1.1 for Mario)
```
All child positions must be composed through this transform:
```
world_x = root_tx + local_tx * root_sx
world_y = root_ty + local_ty * root_sy
```

### SWF Matrix Decomposition

SWF PlaceObject matrices use `Fixed16` (fixed-point) values:
```
a, b, c, d = matrix components (b and c are shear/rotation)
tx, ty = translation in TWIPS (divide by 20 to get pixels)
```

Decompose into scale/rotation:
```rust
scale_x = sqrt(a² + b²)
scale_y = sqrt(c² + d²)
rotation_deg = atan2(b, a).to_degrees()
```

**CRITICAL: SWF rotation convention vs FrayTools:**
- SWF uses **CW-positive** rotation in y-down screen space
- FrayTools uses **CCW-positive** rotation (standard math convention)
- **Always negate rotation values when writing to entity files**
- `entity_rotation = -swf_rotation`

### Collision Boxes

SSF2 encodes ALL collision box data in the SWF timeline, not in AS3 code.

The character `mario_fla.CollisonBox_6` (note typo: "Collison") is a 100×100 unit square
centered at (0,0). The PlaceObject matrix scales/positions it:
```
width  = |scale_x| * BASE_SIZE  (BASE_SIZE typically 100.0)
height = |scale_y| * BASE_SIZE
center_x = tx_pixels  (tx/ty ARE the center, not top-left)
top_left_x = center_x - width/2
top_left_y = center_y - height/2
```

The BASE_SIZE is measured from the actual shape bounds using the `dump_shape_bounds` binary.

#### Box Instance Names → BoxType

| SSF2 instance name | Fraymakers type | Notes |
|---|---|---|
| `attackBox`, `attackBox2`... | `HIT_BOX` | Active hitbox |
| `hitBox`, `hitBox2`... | `HURT_BOX` | Hurtbox |
| `hurtBox` | `HURT_BOX` | Hurtbox (alternate name) |
| `grabBox` | `GRAB_BOX` | Grab range |
| `itemBox` | `HURT_BOX` | Item pickup — treated as hurtbox in FM |
| `touchBox` | `GRAB_HOLD_BOX`(?) | Grab hold point — **UNVERIFIED**, see below |
| `shieldBox` | `REFLECT_BOX` | |
| `reflectBox` | `REFLECT_BOX` | |
| `absorbBox` | `COUNTER_BOX` | |
| `ledgeBox` | `LEDGE_GRAB_BOX` | |

**⚠️ UNRESOLVED: `touchBox` / `grabHoldPoint`**
In SSF2, `touchBox` defines where a grabbed opponent is held (grab animations, throws).
The current code maps it to `GRAB_HOLD_BOX` as a `COLLISION_BOX` layer named `grabHoldPoint0`.
However, it's unclear whether Fraymakers uses a `COLLISION_BOX` layer or a distinct `POINT` layer type.
A reference FrayTools entity with a grab hold point is needed to verify this.
The Fraymakers API has `CollisionBoxType.GRABHOLD = 6` which suggests it IS a collision box type.

#### ItemBox Special Case

`itemBox` is placed relative to the **hand position** (where the character holds items).
The PlaceObject tx/ty is the hand attachment point (origin = bottom-center of the box).
The inner shape geometry is at an offset (-1.45, -20.95) relative to the itemBox origin.
```
inner_w = 3.7, inner_h = 21.9  (pixels)
```
Pivot point is at bottom-center (hand position): `pivotY = height`.

### Image Sprites

Each animation frame's visual is a named `DefineSprite` placed at depth 0:
- Pattern: `mario_af0`, `mario_af1`, etc. (sequential per animation)
- These contain `DefineShape` tags with bitmap fills pointing to `DefineBitsLossless2` bitmaps
- Named in `SymbolClass` (e.g. `mario_af0`, `mario_fs26`)

#### Effect Sprites

Some animations contain nested effect movieclips (e.g. `mario_fla.ChargeSpark_25`).
These are `_fla.` named sprites that are NOT top-level animation containers.
They need to be **flattened** — their per-frame content composed into the parent timeline.

Nesting structure:
```
FAir_42 (animation) → PlaceObject id=84 (ChargeSpark_25, named _fla.)
  ChargeSpark_25 → PlaceObject id=83 (unnamed DefineSprite)
    id=83 → PlaceObject id=80 (unnamed DefineShape3, solid-color vector)
```

**NOTE:** Pure vector shapes (solid color fills, no bitmap) CANNOT be rendered without
a full SWF rasterizer. They are silently skipped. Only bitmap-backed shapes are exported.

#### shape_to_bitmap Map

`DefineShape` tags often have TWO bitmap fills:
1. `id=65535` — the SWF null/clipping bitmap (SKIP this)
2. The real bitmap id

Always skip fill id=65535 and take the first non-null bitmap fill.

#### Unnamed Sprites

Some shapes/sprites have no `SymbolClass` entry (`id_XXXX` fallback).
These are typically clipping masks or one-off effects with no PNG.
**Skip them** — they produce blank IMAGE layers.

---

## Fraymakers Entity Format (.entity)

The `.entity` file is a JSON document consumed by FrayTools.
It's the core of a character package. All GUIDs should be deterministic (seeded by char_id + context).

### Top-Level Structure

```json
{
  "animations": [...],        // per-animation objects
  "export": true,
  "guid": "...",              // deterministic GUID for this entity
  "id": "mario",              // character id (lowercase)
  "keyframes": [...],         // ALL keyframes from all animations, flat array
  "layers": [...],            // ALL layers from all animations, flat array
  "paletteMap": null,         // or { "paletteCollection": "...", "paletteMap": "..." }
  "pluginMetadata": {
    "com.fraymakers.FraymakersMetadata": {
      "objectType": "CHARACTER",
      "version": "0.4.0"
    }
  },
  "plugins": ["com.fraymakers.FraymakersMetadata"],
  "symbols": [...],           // ALL symbols (IMAGE, COLLISION_BOX, COLLISION_BODY), flat array
  "tags": [],
  "terrains": [],
  "tilesets": [],
  "version": 14
}
```

### Animation Object

```json
{
  "$id": "...",         // deterministic GUID
  "name": "idle",       // Fraymakers animation name
  "layers": ["..."],    // ordered array of layer $ids
  "pluginMetadata": {}
}
```

### Layer Types

Every animation has this layer stack (in order):
1. `LABEL` — animation name label on frame 0
2. `FRAME_SCRIPT` — per-frame Haxe code
3. `COLLISION_BODY` — character ECB/body shape (constant across frames)
4. `COLLISION_BOX` — one layer per box instance (hitbox0, hurtbox0, etc.)
5. `IMAGE` — one layer per depth slot (Image 0, Image 1, ...)

#### LABEL Layer

```json
{
  "$id": "...",
  "name": "Labels",
  "type": "LABEL",
  "keyframes": ["kf_id"],
  "hidden": false,
  "locked": false,
  "pluginMetadata": {}
}
```

LABEL keyframe:
```json
{
  "$id": "...",
  "type": "LABEL",
  "length": 1,
  "name": "idle",       // animation name
  "pluginMetadata": {}
}
```

#### FRAME_SCRIPT Layer

```json
{
  "$id": "...",
  "name": "Scripts",
  "type": "FRAME_SCRIPT",
  "keyframes": [...],
  "hidden": false,
  "locked": false,
  "language": "",
  "pluginMetadata": {}
}
```

FRAME_SCRIPT keyframe — contains ONLY the function body (no `function name() {` wrapper):
```json
{
  "$id": "...",
  "type": "FRAME_SCRIPT",
  "length": 1,
  "code": "self.playSound(\"jump\");\nreturn;",   // body only, NOT wrapped in function
  "pluginMetadata": {}
}
```
Blank frames use `"code": ""`.

#### COLLISION_BODY Layer

```json
{
  "$id": "...",
  "name": "Body",
  "type": "COLLISION_BODY",
  "keyframes": ["kf_id"],
  "hidden": false,
  "locked": false,
  "defaultAlpha": 0.5,
  "defaultColor": "0xffa500",
  "defaultFoot": 0,
  "defaultHead": 86,
  "defaultHipWidth": 40,
  "defaultHipXOffset": 0,
  "defaultHipYOffset": 0,
  "pluginMetadata": {}
}
```

COLLISION_BODY symbol:
```json
{
  "$id": "...",
  "alpha": null,
  "color": null,
  "foot": 0,
  "head": 86,
  "hipWidth": 40,
  "hipXOffset": 0,
  "hipYOffset": 0,
  "pluginMetadata": {},
  "type": "COLLISION_BODY",
  "x": 0
}
```

#### COLLISION_BOX Layer

Layer:
```json
{
  "$id": "...",
  "name": "hitbox0",          // Fraymakers box name (see naming table)
  "type": "COLLISION_BOX",
  "keyframes": [...],
  "hidden": false,
  "locked": false,
  "defaultAlpha": 0.5,
  "defaultColor": "0xff0000",
  "pluginMetadata": {
    "com.fraymakers.FraymakersMetadata": {
      "collisionBoxType": "HIT_BOX",    // see type table below
      "index": 0                         // 0-based index (hitbox0=0, hitbox1=1)
    }
  }
}
```

COLLISION_BOX symbol:
```json
{
  "$id": "...",
  "alpha": 0.5,
  "color": "0xff0000",
  "pivotX": 24.0,             // rotation pivot (center for most; bottom-center for itemBox)
  "pivotY": 13.0,
  "pluginMetadata": {},
  "rotation": 12.5,           // CCW-positive degrees (negated from SWF atan2)
  "scaleX": 48.0,             // width in pixels
  "scaleY": 26.0,             // height in pixels
  "type": "COLLISION_BOX",
  "x": -54.0,                 // top-left x in world space
  "y": -35.0                  // top-left y in world space
}
```

COLLISION_BOX keyframe — blank frame uses `"symbol": null`:
```json
{
  "$id": "...",
  "type": "COLLISION_BOX",
  "length": 2,
  "symbol": "sym_$id_or_null",
  "tweened": false,
  "tweenType": "LINEAR",
  "pluginMetadata": {}
}
```

**Fraymakers collision box type strings** (used in `collisionBoxType`):

| String | Fraymakers API value | Description |
|---|---|---|
| `HIT_BOX` | 2 | Active hitbox |
| `HURT_BOX` | 1 | Hurtbox |
| `GRAB_BOX` | 5 | Grab range |
| `GRAB_HOLD_BOX` | 6 | Grab hold point (**unverified if correct layer type**) |
| `LEDGE_GRAB_BOX` | 9 | Ledge grab |
| `REFLECT_BOX` | 11 | Reflect |
| `COUNTER_BOX` | 8 | Counter/absorb |
| `SHIELD_BOX` | 7 | Shield |

#### IMAGE Layer

```json
{
  "$id": "...",
  "name": "Image 0",
  "type": "IMAGE",
  "keyframes": [...],
  "hidden": false,
  "locked": false,
  "pluginMetadata": {}
}
```

IMAGE symbol — one created PER PLACEMENT (not shared across frames):
```json
{
  "$id": "...",
  "alpha": 1,
  "imageAsset": "meta_guid",    // GUID from the .meta sidecar file (NOT file path)
  "pivotX": 30.0,               // image_width * scaleX / 2  (center)
  "pivotY": 30.0,               // image_height * scaleY / 2
  "pluginMetadata": {},
  "rotation": -12.5,            // CCW-positive (negated from SWF)
  "scaleX": 1.1,
  "scaleY": 1.1,
  "type": "IMAGE",
  "x": -54.0,                   // top-left x, world space, y-down
  "y": -35.0
}
```

IMAGE keyframe:
```json
{
  "$id": "...",
  "type": "IMAGE",
  "length": 3,
  "symbol": "sym_$id_or_null",
  "tweened": false,
  "tweenType": "LINEAR",
  "pluginMetadata": {}
}
```

### .meta Sidecar Files

Every PNG needs a `.meta` JSON file at the same path + `.meta` extension:
```json
{
  "export": false,
  "guid": "deterministic-guid",
  "id": "",
  "pluginMetadata": {},
  "plugins": [],
  "tags": [],
  "version": 2
}
```
The GUID in the `.meta` file is what `imageAsset` in IMAGE symbols references.

---

## Coordinate System

Both SSF2 and Fraymakers use **y-down** screen coordinates (positive y = down).
No y-flip is needed between the two systems.

```
Origin: character foot (ground contact point)
Positive x: right
Positive y: down (into ground)
Negative y: up (into air)
```

World space = root MC transform applied to local SWF coordinates.

---

## Animation Name Mapping (SSF2 → Fraymakers)

SSF2 uses internal names like `stand`, `a_air_forward`. Fraymakers uses `idle`, `aerial_forward`.

Key mappings defined in `sprite_parser.rs` `ANIM_FALLBACK_MAP` and `normalize_anim_label`:
```
stand        → idle
a_air_forward → aerial_forward
a_air_backward → aerial_back
a_air_neutral  → aerial_neutral
a_air_up       → aerial_up
a_air_down     → aerial_down
walk           → walk
run            → run
jump           → jump
jump_midair    → double_jump
fall           → fall
land           → land
...
```

Some animations are **split** from a single SSF2 sprite into multiple FM animations.
Example: `Jab_21` contains jab1, jab2, jab3 separated by internal frame labels.
The `sub_anim_image_splits` function handles this using known split tables.

---

## UUID Generation

All GUIDs in the entity are **deterministic**, seeded by `"{char_id}::{context}"`.
Using UUID v5 (SHA-1 namespace). This ensures regeneration produces the same entity.
See `src/uuid_gen.rs`.

---

## Diagnostic Binaries

Several `--bin` targets exist for debugging:
```
dump_image_placement  — shows per-frame PlaceObject data for any sprite
dump_collision_box    — dumps collision box geometry for an animation
dump_images           — lists all extracted bitmaps
dump_sprites          — lists all DefineSprite symbols
dump_shape_bounds     — measures actual bounds of CollisonBox_6 shape
dump_costumes         — lists costume variants
extract_costumes      — extracts palette swaps
```

Usage example:
```bash
./target/release/dump_image_placement mario.ssf "FAir_42"
./target/release/dump_collision_box mario.ssf "a_air_forward"
```

---

## Known Issues / Open Questions

### grabHoldPoint / touchBox
- SSF2 `touchBox` marks where a grabbed opponent is positioned during throws
- Currently emitted as `COLLISION_BOX` layer named `grabHoldPoint0` with type `GRAB_HOLD_BOX`
- **UNVERIFIED**: FrayTools may use a distinct `POINT` layer type for this, not `COLLISION_BOX`
- Need a reference FrayTools entity file containing a grab hold point to confirm correct format

### ChargeSpark / vector effect sprites
- `mario_fla.ChargeSpark_25` (the twinkle on F-air) is a vector star shape with solid color fill
- Cannot be exported as PNG without a full SWF vector rasterizer
- Silently skipped — effect is visually missing in the converted character

### Animation completeness
- Not all SSF2 animations have a direct Fraymakers equivalent
- Fallback system copies frames from a similar animation (e.g. `stunned` → `hurt`)
- See `apply_image_fallbacks` in `image_extractor.rs` and fallback table in `sprite_parser.rs`

### Frame script translation
- SSF2 AS3 API calls are translated to Fraymakers Haxe equivalents via `api_mappings.rs`
- Many calls marked `/* ? */` or `// TODO` where no equivalent exists
- Jab chain scripts (jab1→jab2→jab3) are synthesized by `generate_jab_scripts`

---

## Source File Summary

| File | Purpose |
|---|---|
| `main.rs` | Entry point, orchestrates extraction pipeline |
| `extractor.rs` | Parses AS3 bytecode for animation names, frame scripts |
| `abc_parser.rs` | Full AS3/ABC bytecode parser |
| `decompiler.rs` | Converts ABC bytecode to readable Haxe-like code |
| `sprite_parser.rs` | Extracts per-frame collision box geometry from SWF timelines |
| `image_extractor.rs` | Extracts PNG bitmaps, builds per-frame image placement data |
| `entity_gen.rs` | Generates the Fraymakers `.entity` JSON file |
| `haxe_gen.rs` | Generates `.hx` script files (AnimationStats, HitboxStats, etc.) |
| `api_mappings.rs` | SSF2 AS3 → Fraymakers Haxe API translation table |
| `sound_extractor.rs` | Extracts audio from SWF |
| `palette_gen.rs` | Generates palette/costume data |
| `swf_parser.rs` | Low-level SWF tag utilities |
| `ssf.rs` | SSF file header handling |
| `uuid_gen.rs` | Deterministic UUID v5 generation |
| `fraytools_project.rs` | FrayTools project.json generation |
