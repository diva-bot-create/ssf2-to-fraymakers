use ssf2_converter::*;
use ssf2_converter::sound_extractor;

use clap::Parser;
use anyhow::Result;
use std::path::PathBuf;

#[derive(Parser, Debug)]
#[command(name = "SSF2 to Fraymakers Converter")]
#[command(about = "Converts Super Smash Flash 2 character data to Fraymakers format", long_about = None)]
struct Args {
    /// Path to the .ssf file
    #[arg(value_name = "FILE")]
    input: PathBuf,

    /// Output directory for generated Fraymakers files
    #[arg(short, long, value_name = "DIR", default_value = "./characters")]
    output: PathBuf,

    /// Character name override (auto-detected from SWF if not provided).
    /// For multi-character SSFs, this selects only that character.
    #[arg(short, long)]
    name: Option<String>,

    /// Path to ssf2_costumes.json (from the extract_costumes binary run on misc.ssf).
    /// If provided, uses real SSF2 palette data instead of k-means approximation.
    #[arg(long, value_name = "JSON")]
    costumes: Option<PathBuf>,

    /// Verbose output
    #[arg(short, long)]
    verbose: bool,
}

fn main() -> Result<()> {
    let args = Args::parse();

    if args.verbose {
        env_logger::Builder::from_default_env()
            .filter_level(log::LevelFilter::Debug)
            .init();
    } else {
        env_logger::Builder::from_default_env()
            .filter_level(log::LevelFilter::Info)
            .init();
    }

    log::info!("SSF2 → Fraymakers Converter");
    log::info!("Input: {}", args.input.display());

    // Read + decompress SSF
    let ssf_data = std::fs::read(&args.input)?;
    log::info!("Loaded {} bytes", ssf_data.len());
    let swf_data = ssf::decompress(&ssf_data)?;
    log::info!("Decompressed SWF: {} bytes", swf_data.len());

    let swf = swf_parser::parse(&swf_data)?;
    log::info!("Parsed SWF: v{}, {} ABC blocks", swf.version, swf.abc_blocks.len());

    // Determine which character names to process
    let char_names: Vec<String> = if let Some(name) = args.name {
        vec![name]
    } else {
        // Auto-detect all root character MCs in the SWF
        let detected = detect_char_names(&swf, &args.input);
        if detected.is_empty() {
            // Fallback: use filename
            let fallback = args.input
                .file_stem()
                .and_then(|s| s.to_str())
                .unwrap_or("character")
                .to_string();
            vec![fallback]
        } else {
            detected
        }
    };

    log::info!("Characters to process: {:?}", char_names);

    for char_name in &char_names {
        log::info!("─── Processing: {} ───", char_name);
        if let Err(e) = process_character(
            &swf_data, &swf, char_name, &args.output, args.costumes.as_deref()
        ) {
            log::error!("Failed to process {}: {}", char_name, e);
        }
    }

    Ok(())
}

/// Detect all root character names in a SWF by looking for `{Name}Ext` ABC classes.
/// This is the authoritative signal — every SSF2 character has a corresponding
/// `MarioExt`, `ZeldaExt`, `SheikExt` etc. class in the ABC block.
fn detect_char_names(swf: &ssf2_converter::swf_parser::SwfFile, input_path: &PathBuf) -> Vec<String> {
    let mut names: Vec<String> = Vec::new();

    for abc_bytes in &swf.abc_blocks {
        let Ok(abc) = abc_parser::parse(abc_bytes) else { continue; };
        for class in &abc.classes {
            // Look for XxxExt pattern (e.g. MarioExt, ZeldaExt, SheikExt)
            if let Some(prefix) = class.name.strip_suffix("Ext") {
                if prefix.len() >= 2 && prefix.chars().all(|c| c.is_ascii_alphabetic()) {
                    names.push(prefix.to_lowercase());
                }
            }
        }
    }

    // Deduplicate, preserve order
    let mut seen = std::collections::HashSet::new();
    names.retain(|n| seen.insert(n.clone()));

    if !names.is_empty() {
        // Resolve truncated names against the filename.
        // e.g. ABC has "CaptainExt" -> "captain", filename is "captainfalcon"
        // -> use "captainfalcon" as the canonical name.
        let stem = input_path
            .file_stem()
            .and_then(|s| s.to_str())
            .unwrap_or("")
            .to_lowercase();

        let resolved: Vec<String> = names.iter().map(|n| {
            // If the filename starts with this name (or vice versa), use the longer one
            if stem.starts_with(n.as_str()) { stem.clone() }
            else if n.starts_with(stem.as_str()) { n.clone() }
            else { n.clone() }
        }).collect();

        // Deduplicate again after resolution
        let mut seen2 = std::collections::HashSet::new();
        let mut out = Vec::new();
        for n in resolved {
            if seen2.insert(n.clone()) { out.push(n); }
        }
        return out;
    }

    // Fallback: use filename
    if let Some(stem) = input_path.file_stem().and_then(|s| s.to_str()) {
        return vec![stem.to_lowercase()];
    }

    vec![]
}

fn process_character(
    swf_data: &[u8],
    swf: &ssf2_converter::swf_parser::SwfFile,
    char_name: &str,
    output: &PathBuf,
    costumes: Option<&std::path::Path>,
) -> Result<()> {
    // Extract character data (ABC: attacks, stats, frame scripts, xframe map)
    let mut char_data = extractor::extract(swf, char_name)?;
    log::info!("Extracted: {} attacks, {} animations, {} ssf2→fm mappings",
        char_data.attacks.len(), char_data.animations.len(), char_data.ssf2_to_fm_anim.len());

    // Extract median xframe scale from root character MovieClip
    let (base_scale_x, base_scale_y) = sprite_parser::extract_xframe_scale(swf_data, char_name)
        .unwrap_or_else(|e| {
            log::warn!("extract_xframe_scale failed: {}, defaulting to 1.0", e);
            (1.0, 1.0)
        });
    char_data.stats.base_scale_x = base_scale_x;
    char_data.stats.base_scale_y = base_scale_y;
    log::info!("Character base scale: scaleX={:.4}, scaleY={:.4}", base_scale_x, base_scale_y);

    // Extract per-frame collision box geometry
    let sprite_boxes = sprite_parser::parse_sprite_boxes(swf_data, char_name, &char_data.ssf2_to_fm_anim)
        .unwrap_or_else(|e| {
            log::warn!("sprite_parser failed: {}", e);
            Default::default()
        });
    log::info!("Sprite boxes: {} animations with geometry", sprite_boxes.len());

    // Extract sprite images
    let char_output_dir = output.join(char_name);
    let img_result = image_extractor::extract_images(swf_data, &char_output_dir, char_name, &char_data.ssf2_to_fm_anim)
        .unwrap_or_else(|e| {
            log::warn!("image_extractor failed: {}", e);
            image_extractor::ImageExtractionResult {
                images: Default::default(),
                shape_to_bitmap: Default::default(),
                anim_images: Default::default(),
            }
        });
    log::info!("Extracted {} sprite images, {} anim image maps",
        img_result.images.len(), img_result.anim_images.len());

    // Extract sounds
    let sounds_dir = char_output_dir.join("library/sounds");
    let sounds = match sound_extractor::extract_all_sounds(swf_data, &sounds_dir, char_name) {
        Ok(s) => s,
        Err(e) => { log::warn!("sound_extractor failed: {}", e); vec![] }
    };

    // Discover projectiles and head sprite
    let (projectiles, head_sprite) = image_extractor::discover_projectiles_and_head(swf_data, char_name)
        .unwrap_or_else(|e| {
            log::warn!("discover_projectiles_and_head failed: {}", e);
            (vec![], None)
        });
    log::info!("Discovered {} projectiles, head={}",
        projectiles.len(),
        head_sprite.as_ref().map(|h| h.name.as_str()).unwrap_or("none"));

    // Generate Fraymakers files
    haxe_gen::generate(output, char_name, &char_data, &sprite_boxes, &img_result,
        costumes, &sounds, &projectiles, head_sprite.as_ref(), swf_data)?;
    log::info!("Generated Fraymakers files for {}", char_name);

    Ok(())
}
