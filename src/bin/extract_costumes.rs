/// Extract SSF2 costume palette data directly from misc.ssf.
///
/// Reads misc.ssf → parses SWF → parses ABC bytecode → simulates AVM2 stack
/// to find getCostumeData() and extract {name, paletteSwap:{colors,replacements}}.
///
/// No external tools required.
///
/// Usage:
///   extract_costumes <misc.ssf> [output.json] [character_name]
///
/// output.json defaults to ssf2_costumes.json in the current directory.
/// character_name filters to a single character (optional).

use std::path::PathBuf;

fn main() -> anyhow::Result<()> {
    env_logger::Builder::from_default_env()
        .filter_level(log::LevelFilter::Info)
        .init();

    let args: Vec<String> = std::env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: extract_costumes <misc.ssf> [output.json] [character_name]");
        std::process::exit(1);
    }

    let input_path  = PathBuf::from(&args[1]);
    let output_path = args.get(2)
        .filter(|s| !s.is_empty())
        .map(PathBuf::from)
        .unwrap_or_else(|| PathBuf::from("ssf2_costumes.json"));
    let only_char: Option<&str> = args.get(3).map(|s| s.as_str());

    log::info!("Reading {}", input_path.display());
    let raw = std::fs::read(&input_path)?;
    log::info!("Loaded {} bytes", raw.len());

    // SWF → ABC blocks
    let swf_data = ssf2_converter::ssf::decompress(&raw)?;
    let swf      = ssf2_converter::swf_parser::parse(&swf_data)?;
    log::info!("SWF v{}: {} ABC blocks", swf.version, swf.abc_blocks.len());

    if swf.abc_blocks.is_empty() {
        anyhow::bail!("No ABC blocks found in {}", input_path.display());
    }

    // Parse all ABC blocks and collect costume data
    let mut all_costumes: std::collections::BTreeMap<String, Vec<ssf2_converter::abc_parser::CostumeData>> =
        std::collections::BTreeMap::new();

    for (i, abc_bytes) in swf.abc_blocks.iter().enumerate() {
        log::info!("Parsing ABC block {} ({} bytes)…", i, abc_bytes.len());
        let abc = ssf2_converter::abc_parser::parse(abc_bytes)?;
        log::info!("  {} methods, {} classes, {} method bodies", abc.methods.len(), abc.classes.len(), abc.method_bodies.len());

        let found = ssf2_converter::abc_parser::scan_all_costume_methods(&abc);
        for (char_name, costumes) in found {
            all_costumes.entry(char_name).or_default().extend(costumes);
        }
    }

    if all_costumes.is_empty() {
        anyhow::bail!("No costume data found — is this misc.ssf?");
    }

    // Drop noise entries: "unknown" key or suspiciously few costumes (< 10)
    all_costumes.retain(|k, v| k != "unknown" && v.len() >= 10);

    // Apply optional character filter
    if let Some(only) = only_char {
        all_costumes.retain(|k, _| k == only);
        if all_costumes.is_empty() {
            anyhow::bail!("Character '{}' not found in costume data", only);
        }
    }

    // Print summary
    for (char_name, costumes) in &all_costumes {
        let labels: Vec<&str> = costumes.iter().map(|c| c.name.as_str()).collect();
        println!("  {:<20} {} costumes: {}", char_name, costumes.len(), labels.join(", "));
    }
    println!("\nExtracted {} characters", all_costumes.len());

    // Serialize — CostumeData already has colors + name; we need replacements too.
    // scan_all_costume_methods fills CostumeData.colors as the replacements array
    // (the source colors are the same per character). We emit both for palette_gen.
    let json_val: serde_json::Value = all_costumes.iter().map(|(char_name, costumes)| {
        let arr: serde_json::Value = costumes.iter().map(|c| serde_json::json!({
            "name":         c.name,
            "colors":       c.colors,       // source palette (same across costumes)
            "replacements": c.replacements, // per-costume target colors
        })).collect::<Vec<_>>().into();
        (char_name.clone(), arr)
    }).collect::<serde_json::Map<_, _>>().into();

    std::fs::write(&output_path, serde_json::to_string_pretty(&json_val)?)?;
    println!("Saved to {}", output_path.display());
    Ok(())
}
