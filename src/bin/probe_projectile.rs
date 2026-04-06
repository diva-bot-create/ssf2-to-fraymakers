use std::io::Cursor;
use std::collections::BTreeMap;

fn main() {
    let ssf_data = std::fs::read("/Users/jimmy/.openclaw/workspace-main/ssf2-ssfs/mario.ssf").unwrap();
    let swf_data = ssf2_converter::ssf::decompress(&ssf_data).unwrap();
    let swf_buf = swf::decompress_swf(Cursor::new(&swf_data)).unwrap();
    let swf = swf::parse_swf(&swf_buf).unwrap();

    let mut symbols: BTreeMap<u16, String> = BTreeMap::new();
    for tag in &swf.tags {
        if let swf::Tag::SymbolClass(links) = tag {
            for link in links {
                let name = link.class_name.to_str_lossy(encoding_rs::WINDOWS_1252).to_string();
                symbols.insert(link.id, name);
            }
        }
    }

    let mut shape_to_bitmap: BTreeMap<u16, u16> = BTreeMap::new();
    for tag in &swf.tags {
        if let swf::Tag::DefineShape(shape) = tag {
            for fill in &shape.styles.fill_styles {
                if let swf::FillStyle::Bitmap { id, .. } = fill {
                    if *id != 65535 {
                        shape_to_bitmap.insert(shape.id, *id);
                        break;
                    }
                }
            }
        }
    }

    // Check what id=192 is
    for tag in &swf.tags {
        match tag {
            swf::Tag::DefineShape(s) if s.id == 192 => {
                let bmp = shape_to_bitmap.get(&s.id);
                println!("id=192 is a DefineShape, bitmap={:?}", bmp);
                // Print all fill styles
                for fill in &s.styles.fill_styles {
                    println!("  fill: {:?}", fill);
                }
            }
            swf::Tag::DefineSprite(s) if s.id == 192 => {
                println!("id=192 is a DefineSprite frames={}", s.num_frames);
            }
            swf::Tag::DefineBitsLossless(b) if b.id == 192 => {
                println!("id=192 is a DefineBitsLossless {}x{}", b.width, b.height);
            }
            swf::Tag::DefineBitsJpeg3(b) if b.id == 192 => {
                println!("id=192 is a DefineBitsJpeg3");
            }
            _ => {}
        }
    }
}
