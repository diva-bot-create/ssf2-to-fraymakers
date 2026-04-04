# ssf2-to-fraymakers

Converts Super Smash Flash 2 character data to [Fraymakers](https://www.fraymakersthegame.com/) mod format.

## What this does

- Extracts attack hitbox data, movement stats, and script logic from SSF2 `.swf` files via JPEXS decompiler
- Generates Fraymakers-compatible `HitboxStats.hx`, `CharacterStats.hx`, `AnimationStats.hx`, and `Script.hx` files
- Covers all 47 SSF2 characters

## Structure

```
characters/
  {name}/
    HitboxStats.hx      — hitbox data (damage, angle, knockback, etc.)
    CharacterStats.hx   — movement physics (weight, gravity, speed, etc.)
    AnimationStats.hx   — per-animation flags and properties
    Script.hx           — character-specific logic (ported from SSF2 Ext.as)
scripts/
  parse_attacks.py      — extract attack/hitbox data from SSF2 ABC bytecode
  gen_script_hx.py      — generate Script.hx from decompiled AS3
```

## Requirements

- Python 3.8+
- [JPEXS Free Flash Decompiler](https://github.com/jindrapetrik/jpexs-decompiler) for initial `.swf` decompilation
- Fraymakers character template: https://github.com/Fraymakers/character-template

## Usage

1. Decompile SSF2 `.swf` files with JPEXS → output AS3 to `/tmp/ssf2_as3/{charname}/`
2. Run `python3 scripts/parse_attacks.py` to extract hitbox/stats data
3. Run `python3 scripts/gen_script_hx.py /tmp/ssf2_as3/ ./characters/` to generate Script.hx files

## Status

| File | Status |
|---|---|
| HitboxStats.hx | ✅ 47/47 characters |
| CharacterStats.hx | ✅ 47/47 characters |
| AnimationStats.hx | ✅ 47/47 characters |
| Script.hx | ✅ 47/47 characters |

## Notes

- SSF2 API calls are translated to Fraymakers equivalents where possible
- Lines marked `// TODO:` need manual review (no direct Fraymakers equivalent)
- Original SSF2 character data © McLeodGaming — this tool is for mod development only
