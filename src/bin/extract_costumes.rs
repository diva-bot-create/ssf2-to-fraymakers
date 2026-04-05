/// Extract SSF2 costume palette data from a decompiled Misc.as file (JPEXS export).
///
/// Usage:
///   extract_costumes <Misc.as> [output.json] [character_name]
///
/// Data structure in Misc.as (getCostumeData method):
///   _loc1_["mario"] = new Array();
///   _loc1_["mario"].push({
///       "team": "red",           // or "base":true, or neither (alt costume)
///       "paletteSwap": {
///           "colors":       [...],  // source ARGB uints — base sprite palette
///           "replacements": [...],  // what those colors become for this costume
///       },
///       "paletteSwapPA": { ... }    // pixel-art mode variant (ignored)
///   });

use std::collections::BTreeMap;
use std::path::PathBuf;

fn main() -> anyhow::Result<()> {
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: extract_costumes <Misc.as> [output.json] [character_name]");
        std::process::exit(1);
    }

    let input_path  = PathBuf::from(&args[1]);
    let output_path = args.get(2)
        .filter(|s| !s.is_empty())
        .map(PathBuf::from)
        .unwrap_or_else(|| input_path.parent()
            .unwrap_or(std::path::Path::new("."))
            .join("ssf2_costumes.json"));
    let only_char: Option<&str> = args.get(3).map(|s| s.as_str());

    let src = std::fs::read_to_string(&input_path)
        .map_err(|e| anyhow::anyhow!("Failed to read {}: {}", input_path.display(), e))?;

    let result = parse_misc_as(&src, only_char);

    if result.is_empty() {
        eprintln!("No costume data found — is this a valid Misc.as file?");
        std::process::exit(1);
    }

    for (char_name, costumes) in &result {
        let labels: Vec<&str> = costumes.iter().map(|c| c.name.as_str()).collect();
        println!("  {:<20} {} costumes: {}", char_name, costumes.len(), labels.join(", "));
    }
    println!("\nExtracted {} characters", result.len());

    let json_val: serde_json::Value = result.iter().map(|(char_name, costumes)| {
        let arr: serde_json::Value = costumes.iter().map(|c| serde_json::json!({
            "name":         c.name,
            "colors":       c.colors,
            "replacements": c.replacements,
        })).collect::<Vec<_>>().into();
        (char_name.clone(), arr)
    }).collect::<serde_json::Map<_, _>>().into();

    std::fs::write(&output_path, serde_json::to_string_pretty(&json_val)?)?;
    println!("Saved to {}", output_path.display());
    Ok(())
}

// ─── Types ────────────────────────────────────────────────────────────────────

struct Costume {
    name:         String,
    colors:       Vec<u32>,
    replacements: Vec<u32>,
}

// ─── Parser ───────────────────────────────────────────────────────────────────

fn parse_misc_as(src: &str, only_char: Option<&str>) -> BTreeMap<String, Vec<Costume>> {
    // Collect positions of array init lines only: _loc1_["name"] = new Array();
    // This deliberately excludes _loc1_["name"].push({...}) lines.
    let mut char_inits: Vec<(String, usize)> = Vec::new();
    let mut pos = 0;
    while pos < src.len() {
        let needle = "_loc1_[\"";
        match src[pos..].find(needle) {
            None => break,
            Some(rel) => {
                let abs = pos + rel;
                let after_quote = abs + needle.len();
                if let Some(close) = src[after_quote..].find("\"]") {
                    let name = src[after_quote..after_quote + close].to_string();
                    let rest = src[after_quote + close + 2..].trim_start_matches([' ', '\t']);
                    if rest.starts_with("= new Array()") {
                        char_inits.push((name, abs));
                    }
                }
                pos = after_quote;
            }
        }
    }

    let mut result: BTreeMap<String, Vec<Costume>> = BTreeMap::new();

    for (ci, (char_name, char_start)) in char_inits.iter().enumerate() {
        if let Some(only) = only_char {
            if char_name.as_str() != only { continue; }
        }

        // Section spans from this char's init to the next char's init
        let section_end = char_inits.get(ci + 1).map(|(_, p)| *p).unwrap_or(src.len());
        let section = &src[*char_start..section_end];

        let costumes = parse_costume_blocks(section);
        if !costumes.is_empty() {
            result.insert(char_name.clone(), costumes);
        }
    }

    result
}

fn parse_costume_blocks(section: &str) -> Vec<Costume> {
    let mut costumes = Vec::new();
    let mut alt_index = 1usize;

    // Split on ".push({" to get individual blocks, then bound each block
    // at the closing "});" to avoid reading into the next block.
    let push_marker = ".push({";
    let mut search = section;

    while let Some(push_pos) = search.find(push_marker) {
        let after_brace = push_pos + push_marker.len();
        // Find matching close: "});" — crude but sufficient for this format
        let block = &search[after_brace..];
        let block_end = block.find("});").unwrap_or(block.len());
        let block = &block[..block_end];

        // Determine name from THIS block only (bounded)
        let name = if block.contains("\"base\":true") || block.contains("\"base\": true") {
            "Default".to_string()
        } else if let Some(team) = extract_str_field(block, "team") {
            capitalize(&team)
        } else if let Some(n) = extract_str_field(block, "name") {
            n
        } else {
            let n = format!("Alt {}", alt_index);
            alt_index += 1;
            n
        };

        if let Some(ps_body) = find_palette_swap_body(block) {
            let colors       = extract_uint_array(ps_body, "colors");
            let replacements = extract_uint_array(ps_body, "replacements");
            if !colors.is_empty() && colors.len() == replacements.len() {
                costumes.push(Costume { name, colors, replacements });
            }
        }

        // Advance past this push call
        search = &search[after_brace..];
    }

    costumes
}

/// Returns the content inside `"paletteSwap":{...}` (not paletteSwapPA).
fn find_palette_swap_body(s: &str) -> Option<&str> {
    let mut search = s;
    loop {
        let pos = search.find("\"paletteSwap\"")?;
        let after = &search[pos + "\"paletteSwap\"".len()..];
        // Must NOT be followed by "PA"
        let trimmed = after.trim_start_matches([' ', '\t', '\r', '\n', ':']);
        if !trimmed.starts_with("PA") && !trimmed.starts_with('"') {
            // Find the opening brace
            let brace = after.find('{')?;
            return Some(&after[brace + 1..]);
        }
        // Was paletteSwapPA — skip past it
        search = &search[pos + 1..];
    }
}

fn extract_str_field(s: &str, key: &str) -> Option<String> {
    let needle = format!("\"{}\"", key);
    let pos    = s.find(&needle)?;
    let after  = s[pos + needle.len()..].trim_start_matches([' ', '\t', '\r', '\n', ':']);
    if after.starts_with('"') {
        let inner = &after[1..];
        let end   = inner.find('"')?;
        Some(inner[..end].to_string())
    } else {
        None
    }
}

fn extract_uint_array(s: &str, key: &str) -> Vec<u32> {
    let needle = format!("\"{}\"", key);
    let pos = match s.find(&needle) { Some(p) => p, None => return vec![] };
    let after = &s[pos + needle.len()..];
    let bracket = match after.find('[') { Some(b) => b, None => return vec![] };
    let inner = &after[bracket + 1..];
    let end = match inner.find(']') { Some(e) => e, None => return vec![] };
    inner[..end].split(',')
        .filter_map(|tok| tok.trim().parse::<u64>().ok().map(|n| n as u32))
        .collect()
}

fn capitalize(s: &str) -> String {
    let mut c = s.chars();
    match c.next() {
        None    => String::new(),
        Some(f) => f.to_uppercase().collect::<String>() + c.as_str(),
    }
}


