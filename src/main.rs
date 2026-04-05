mod ssf;
mod swf_parser;
mod abc_parser;
mod extractor;
mod haxe_gen;

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

    // Extract character data
    let char_data = extractor::extract(&swf, &char_name)?;
    log::info!("Extracted: {} attacks, stats, animation data", char_data.attacks.len());

    // Generate Fraymakers files
    haxe_gen::generate(&args.output, &char_name, &char_data)?;
    log::info!("Generated Fraymakers files in {}", args.output.display());

    Ok(())
}
