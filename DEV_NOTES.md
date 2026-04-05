# Dev Notes

## JPEXS / ffdec — NOT a project dependency

JPEXS Free Flash Decompiler (`ffdec`) was used **during development only** to inspect
SWF/ABC internals and understand the data formats. It is a Java app that decompiles
SWF to human-readable ActionScript.

**End users do not have JPEXS. Never require it.**

The extraction pipeline is now 100% Rust:
- `swf_parser.rs` — SWF decompression + tag parsing
- `abc_parser.rs` — AVM2 ABC bytecode parser + stack simulation
- `src/bin/extract_costumes.rs` — reads `misc.ssf` directly → `ssf2_costumes.json`

If you need to inspect SWF internals for future work, use JPEXS locally as a
reference tool, then implement the result in the Rust parsers. Document any findings
in `JPEXS_WORKFLOW.md` which is clearly marked as a developer-only reference.

## misc.ssf costume data structure (confirmed via JPEXS + Rust)

`getCostumeData()` in the `Misc` class returns an object where:
- key = character name string (e.g. `"mario"`)
- value = Array of 15 costume objects:
  ```
  {
    "team": "red" | "green" | "blue",   // OR
    "base": true,                        // OR neither (alt costume)
    "paletteSwap": {
      "colors":       [uint, ...],  // 76 source ARGB colors (same for all costumes)
      "replacements": [uint, ...],  // 76 target ARGB colors (per-costume)
    }
  }
  ```
- Order: Red, Green, Blue, Default, Alt 1–11 (varies slightly by character)
