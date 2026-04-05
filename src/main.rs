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

    /// Character name (auto-detected from filename if not provided)
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
    
    // Read SSF file
    let ssf_data = std::fs::read(&args.input)?;
    log::info!("Loaded {} bytes", ssf_data.len());

    // Decompress SSF → SWF
    let swf_data = ssf::decompress(&ssf_data)?;
    log::info!("Decompressed SWF: {} bytes", swf_data.len());

    // Parse SWF
    let swf = swf_parser::parse(&swf_data)?;
    log::info!("Parsed SWF: v{}, {} ABC blocks", swf.version, swf.abc_blocks.len());

    // Extract character name from filename if not provided
    let char_name = args.name.unwrap_or_else(|| {
        args.input
            .file_stem()
            .and_then(|s| s.to_str())
            .unwrap_or("character")
            .to_string()
    });
    log::info!("Character: {}", char_name);

    // Extract character data (ABC: attacks, stats, frame scripts, xframe map)
    let char_data = extractor::extract(&swf, &char_name)?;
    log::info!("Extracted: {} attacks, {} animations, {} ssf2→fm mappings",
        char_data.attacks.len(), char_data.animations.len(), char_data.ssf2_to_fm_anim.len());

    // Extract per-frame collision box geometry from DefineSprite tags
    let sprite_boxes = sprite_parser::parse_sprite_boxes(&swf_data, &char_name, &char_data.ssf2_to_fm_anim)
        .unwrap_or_else(|e| {
            log::warn!("sprite_parser failed: {}", e);
            Default::default()
        });
    log::info!("Sprite boxes: {} animations with geometry", sprite_boxes.len());

    // Extract sprite images from SWF
    let char_output_dir = args.output.join(&char_name);
    let img_result = image_extractor::extract_images(&swf_data, &char_output_dir, &char_name, &char_data.ssf2_to_fm_anim)
        .unwrap_or_else(|e| {
            log::warn!("image_extractor failed: {}", e);
            image_extractor::ImageExtractionResult {
                images: Default::default(),
                shape_to_bitmap: Default::default(),
                anim_images: Default::default(),
            }
        });
    log::info!("Extracted {} sprite images, {} anim image maps", img_result.images.len(), img_result.anim_images.len());

    // Extract sounds
    let sounds_dir = char_output_dir.join("library/sounds");
    let sounds = match sound_extractor::extract_all_sounds(&swf_data, &sounds_dir, &char_name) {
        Ok(s) => s,
        Err(e) => { log::warn!("sound_extractor failed: {}", e); vec![] }
    };

    // Generate Fraymakers files
    haxe_gen::generate(&args.output, &char_name, &char_data, &sprite_boxes, &img_result, args.costumes.as_deref(), &sounds)?;
    log::info!("Generated Fraymakers files in {}", args.output.display());

    Ok(())
}
