# Mappings

Reference JSON files for SSF2 → Fraymakers conversion. Used by the converter
at runtime and as authoritative documentation for the decompiler.

## Files

| File | What it maps |
|------|-------------|
| `api_methods.json`    | SSF2 API method calls → Fraymakers equivalents (used by `decompiler.rs`) |
| `character_stats.json`| SSF2 `getOwnStats()` fields → Fraymakers `CharacterStats` fields |
| `hitbox_stats.json`   | SSF2 `AttackData`/hitbox fields → Fraymakers `HitboxStats` fields |
| `animation_names.json`| SSF2 xframe labels → Fraymakers CState + animation name |
| `events.json`         | SSF2 event strings → Fraymakers `GameObjectEvent`/`CharacterEvent` constants |
| `manifest.json`       | Fraymakers `manifest.json` structure + what the converter generates |

## Status values

- `mapped` — direct 1:1 equivalent, auto-translated
- `partial` — equivalent exists but needs manual review (scale, semantics, or naming differ)
- `todo` — we know a mapping exists but haven't implemented it yet
- `no_equivalent` — SSF2 feature with no FM counterpart; emitted as a comment

## Updating

When you discover a new mapping or fix an existing one:
1. Update the relevant JSON file
2. Update `src/decompiler.rs` `lookup_api()` if it affects code generation
3. Update `src/abc_parser.rs` stat extraction if it's a physics value
4. The converter reads these files as documentation only — they don't load at
   runtime yet. Future work: make `decompiler.rs` load `api_methods.json`
   directly instead of the hardcoded Rust table.

## Sources

- SSF2 API: https://ssf2-modding.readthedocs.io/en/latest/reference/API.html
- Fraymakers API: https://ajewelofrarity.github.io/FraymakersDocs/docs/classes/
- Character template: https://github.com/Fraymakers/character-template
