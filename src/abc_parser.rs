/// ABC (ActionScript Bytecode) parser for SSF2 character files.
///
/// SSF2 characters store all gameplay data in AS3 classes compiled to ABC bytecode:
///   - Attack data: object literals with damage, angle, knockback, etc.
///   - Character stats: getOwnStats() method returning physics values
///   - Frame scripts: per-frame logic in timeline classes
///
/// ABC format reference: https://web.archive.org/web/2024/https://adobe.com/content/dam/amd/en/devnet/actionscript/articles/avm2overview.pdf

use anyhow::{anyhow, Result};
use serde::{Deserialize, Serialize};
use std::collections::BTreeMap;
use crate::decompiler;

// ─── AVM2 opcodes we care about ──────────────────────────────────────────────
const OP_PUSHBYTE:      u8 = 0x24;
const OP_PUSHSHORT:     u8 = 0x25;
const OP_PUSHINT:       u8 = 0x2D;
const OP_PUSHUINT:      u8 = 0x2E;
const OP_PUSHDOUBLE:    u8 = 0x2F;
const OP_PUSHSTRING:    u8 = 0x2C;
const OP_PUSHTRUE:      u8 = 0x26;
const OP_PUSHFALSE:     u8 = 0x27;
const OP_PUSHNULL:      u8 = 0x20;
const OP_PUSHNAN:       u8 = 0x28;
const OP_NEWOBJECT:     u8 = 0x55;
const OP_NEWARRAY:      u8 = 0x56;
const OP_CALLPROPERTY:  u8 = 0x46;
const OP_CALLPROPVOID:  u8 = 0x4F;
const OP_SETPROPERTY:   u8 = 0x61;
const OP_GETPROPERTY:   u8 = 0x66;
const OP_FINDPROP:      u8 = 0x5C;
const OP_FINDPROPSTRICT:u8 = 0x5D;
const OP_GETLEX:        u8 = 0x60;
const OP_COERCE:        u8 = 0x80;
const OP_COERCE_A:      u8 = 0x82;
const OP_RETURNVALUE:   u8 = 0x48;
const OP_RETURNVOID:    u8 = 0x47;
const OP_GETLOCAL0:     u8 = 0xD0;
const OP_GETLOCAL1:     u8 = 0xD1;
const OP_GETLOCAL2:     u8 = 0xD2;
const OP_GETLOCAL3:     u8 = 0xD3;
const OP_GETLOCAL:      u8 = 0x62;
const OP_SETLOCAL:      u8 = 0x63;
const OP_SETLOCAL0:     u8 = 0xD4;
const OP_SETLOCAL1:     u8 = 0xD5;
const OP_SETLOCAL2:     u8 = 0xD6;
const OP_SETLOCAL3:     u8 = 0xD7;
const OP_INITPROPERTY:  u8 = 0x68;
const OP_CONSTRUCTPROP: u8 = 0x4A;
const OP_CONSTRUCT:     u8 = 0x42;
const OP_NOP:           u8 = 0x02;
const OP_POP:           u8 = 0x29;
const OP_DUP:           u8 = 0x2A;
const OP_SWAP:          u8 = 0x2B;
const OP_ADD:           u8 = 0xA0;
const OP_SUBTRACT:      u8 = 0xA1;
const OP_MULTIPLY:      u8 = 0xA2;
const OP_DIVIDE:        u8 = 0xA3;
const OP_NEGATE:        u8 = 0x90;
const OP_CONVERT_D:     u8 = 0x84;
const OP_CONVERT_I:     u8 = 0x83;
const OP_LABEL:         u8 = 0x09;
const OP_JUMP:          u8 = 0x10;
const OP_IFTRUE:        u8 = 0x11;
const OP_IFFALSE:       u8 = 0x12;
const OP_IFEQ:          u8 = 0x13;
const OP_IFNE:          u8 = 0x14;
const OP_IFLT:          u8 = 0x15;
const OP_IFLE:          u8 = 0x16;
const OP_IFGT:          u8 = 0x17;
const OP_IFGE:          u8 = 0x18;
const OP_IFSTRICTEQ:    u8 = 0x19;
const OP_IFSTRICTNE:    u8 = 0x1A;

// ─── Parsed ABC structures ────────────────────────────────────────────────────

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AbcFile {
    pub strings: Vec<String>,
    pub ints: Vec<i32>,
    pub uints: Vec<u32>,
    pub doubles: Vec<f64>,
    pub multinames: Vec<Multiname>,
    pub methods: Vec<Method>,
    pub classes: Vec<Class>,
    pub scripts: Vec<Script>,
    pub method_bodies: Vec<MethodBody>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Multiname {
    pub kind: u8,
    pub name_idx: u32,
    pub name: String, // resolved from string pool
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Method {
    pub name_idx: u32,
    pub name: String,
    pub param_count: u32,
    pub return_type_idx: u32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Class {
    pub name: String,
    pub super_name: String,
    pub instance_methods: Vec<Trait>,
    pub class_methods: Vec<Trait>,
    pub constructor_idx: u32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Trait {
    pub name: String,
    pub kind: u8,
    pub method_idx: u32,
    pub slot_idx: u32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Script {
    pub init_method_idx: u32,
    pub traits: Vec<Trait>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MethodBody {
    pub method_idx: u32,
    pub max_stack: u32,
    pub local_count: u32,
    pub bytecode: Vec<u8>,
    pub activation_traits: Vec<Trait>,  // named slots from newactivation
}

// ─── Extracted character data ─────────────────────────────────────────────────

/// Maps SSF2 frame method name → SSF2 animation name (from self.xframe = "...").
/// e.g. "frame14" → "a", "frame29" → "a_air"
pub type XframeMap = BTreeMap<String, String>;

pub struct ExtractedCharacter {
    pub name: String,
    pub attacks: BTreeMap<String, AttackData>,
    pub stats: Option<CharStats>,
    pub frame_scripts: BTreeMap<String, Vec<FrameAction>>,
    /// Decompiled Ext class methods translated to Fraymakers Haxe
    pub ext_methods: BTreeMap<String, String>,
    /// frame method name → SSF2 animation name (from self.xframe = "...")
    pub xframe_map: XframeMap,
    /// Costumes from SSF2API::getCostumeData — name → list of ARGB color values
    pub costumes: Vec<CostumeData>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CostumeData {
    pub name: String,
    /// ARGB color values (0xAARRGGBB) — the raw palette for this costume
    pub colors: Vec<u32>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct AttackData {
    pub hitboxes: Vec<BTreeMap<String, f64>>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CharStats {
    pub values: BTreeMap<String, f64>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct FrameAction {
    pub frame: u32,
    pub action: String,
    pub args: Vec<String>,
}

// ─── Reader helpers ───────────────────────────────────────────────────────────

struct Reader<'a> {
    data: &'a [u8],
    pos: usize,
}

impl<'a> Reader<'a> {
    fn new(data: &'a [u8]) -> Self {
        Self { data, pos: 0 }
    }

    fn remaining(&self) -> usize {
        self.data.len().saturating_sub(self.pos)
    }

    fn read_u8(&mut self) -> Result<u8> {
        if self.pos >= self.data.len() {
            return Err(anyhow!("read_u8: out of bounds at {}", self.pos));
        }
        let b = self.data[self.pos];
        self.pos += 1;
        Ok(b)
    }

    fn read_u16(&mut self) -> Result<u16> {
        let lo = self.read_u8()? as u16;
        let hi = self.read_u8()? as u16;
        Ok(lo | (hi << 8))
    }

    fn read_u32(&mut self) -> Result<u32> {
        let lo = self.read_u16()? as u32;
        let hi = self.read_u16()? as u32;
        Ok(lo | (hi << 16))
    }

    fn read_f64(&mut self) -> Result<f64> {
        if self.pos + 8 > self.data.len() {
            return Err(anyhow!("read_f64: out of bounds"));
        }
        let mut bytes = [0u8; 8];
        bytes.copy_from_slice(&self.data[self.pos..self.pos + 8]);
        self.pos += 8;
        Ok(f64::from_le_bytes(bytes))
    }

    /// Variable-length encoded u30/u32
    fn read_u30(&mut self) -> Result<u32> {
        let mut result = 0u32;
        let mut shift = 0;
        loop {
            let b = self.read_u8()? as u32;
            result |= (b & 0x7F) << shift;
            shift += 7;
            if b & 0x80 == 0 || shift >= 35 {
                break;
            }
        }
        Ok(result)
    }

    /// Variable-length encoded s32
    fn read_s32(&mut self) -> Result<i32> {
        let v = self.read_u30()?;
        // sign-extend from 29 bits
        if v & 0x10000000 != 0 {
            Ok((v | 0xE0000000) as i32)
        } else {
            Ok(v as i32)
        }
    }

    fn read_string(&mut self) -> Result<String> {
        let len = self.read_u30()? as usize;
        if self.pos + len > self.data.len() {
            return Err(anyhow!("read_string: length {} out of bounds at pos {}", len, self.pos));
        }
        let s = String::from_utf8_lossy(&self.data[self.pos..self.pos + len]).to_string();
        self.pos += len;
        Ok(s)
    }

    fn skip(&mut self, n: usize) -> Result<()> {
        if self.pos + n > self.data.len() {
            return Err(anyhow!("skip: {} out of bounds at {}", n, self.pos));
        }
        self.pos += n;
        Ok(())
    }
}

// ─── ABC parsing ─────────────────────────────────────────────────────────────

pub fn parse(data: &[u8]) -> Result<AbcFile> {
    let mut r = Reader::new(data);

    // Header: minor version, major version
    let _minor = r.read_u16()?;
    let _major = r.read_u16()?;

    // ── Constant pool ──────────────────────────────────────────────────────────

    // Integers
    let int_count = r.read_u30()? as usize;
    let mut ints = vec![0i32];
    for _ in 1..int_count {
        ints.push(r.read_s32()?);
    }

    // Unsigned integers
    let uint_count = r.read_u30()? as usize;
    let mut uints = vec![0u32];
    for _ in 1..uint_count {
        uints.push(r.read_u30()?);
    }

    // Doubles
    let double_count = r.read_u30()? as usize;
    let mut doubles = vec![f64::NAN];
    for _ in 1..double_count {
        doubles.push(r.read_f64()?);
    }

    // Strings
    let string_count = r.read_u30()? as usize;
    let mut strings = vec![String::new()];
    for _ in 1..string_count {
        strings.push(r.read_string()?);
    }

    log::debug!("ABC constants: {} ints, {} uints, {} doubles, {} strings",
        ints.len(), uints.len(), doubles.len(), strings.len());

    // Namespaces
    let ns_count = r.read_u30()? as usize;
    let mut _namespaces = vec![(0u8, 0u32)];
    for _ in 1..ns_count {
        let kind = r.read_u8()?;
        let name_idx = r.read_u30()?;
        _namespaces.push((kind, name_idx));
    }

    // Namespace sets
    let nsset_count = r.read_u30()? as usize;
    for _ in 1..nsset_count {
        let ns_count = r.read_u30()? as usize;
        for _ in 0..ns_count {
            r.read_u30()?;
        }
    }

    // Multinames
    let mn_count = r.read_u30()? as usize;
    let mut multinames = vec![Multiname { kind: 0, name_idx: 0, name: String::new() }];
    for _ in 1..mn_count {
        let kind = r.read_u8()?;
        let mn = match kind {
            0x07 | 0x0D => { // QName, QNameA
                let _ns = r.read_u30()?;
                let name_idx = r.read_u30()?;
                let name = strings.get(name_idx as usize).cloned().unwrap_or_default();
                Multiname { kind, name_idx, name }
            }
            0x0F | 0x10 => { // RTQName, RTQNameA
                Multiname { kind, name_idx: 0, name: String::new() }
            }
            0x11 | 0x12 => { // RTQNameL, RTQNameLA
                Multiname { kind, name_idx: 0, name: String::new() }
            }
            0x09 | 0x0E => { // Multiname, MultinameA
                let name_idx = r.read_u30()?;
                let _ns_set = r.read_u30()?;
                let name = strings.get(name_idx as usize).cloned().unwrap_or_default();
                Multiname { kind, name_idx, name }
            }
            0x1B | 0x1C => { // MultinameL, MultinameLA
                let _ns_set = r.read_u30()?;
                Multiname { kind, name_idx: 0, name: String::new() }
            }
            0x1D => { // TypeName (generic)
                let _qname = r.read_u30()?;
                let param_count = r.read_u30()? as usize;
                for _ in 0..param_count { r.read_u30()?; }
                Multiname { kind, name_idx: 0, name: String::new() }
            }
            _ => {
                log::warn!("Unknown multiname kind: 0x{:02X}", kind);
                Multiname { kind, name_idx: 0, name: String::new() }
            }
        };
        multinames.push(mn);
    }

    // ── Methods ───────────────────────────────────────────────────────────────

    let method_count = r.read_u30()? as usize;
    let mut methods = Vec::with_capacity(method_count);
    for _ in 0..method_count {
        let param_count = r.read_u30()?;
        let return_type_idx = r.read_u30()?;
        for _ in 0..param_count { r.read_u30()?; } // param types
        let name_idx = r.read_u30()?;
        let flags = r.read_u8()?;
        if flags & 0x08 != 0 { // HAS_OPTIONAL
            let opt_count = r.read_u30()? as usize;
            for _ in 0..opt_count {
                r.read_u30()?; // value index
                r.read_u8()?;  // value kind
            }
        }
        if flags & 0x80 != 0 { // HAS_PARAM_NAMES
            for _ in 0..param_count { r.read_u30()?; }
        }
        let name = strings.get(name_idx as usize).cloned().unwrap_or_default();
        methods.push(Method { name_idx, name, param_count, return_type_idx });
    }

    // ── Metadata ──────────────────────────────────────────────────────────────
    let metadata_count = r.read_u30()? as usize;
    for _ in 0..metadata_count {
        r.read_u30()?; // name
        let item_count = r.read_u30()? as usize;
        for _ in 0..item_count {
            r.read_u30()?; // key
            r.read_u30()?; // value
        }
    }

    // ── Classes ───────────────────────────────────────────────────────────────
    let class_count = r.read_u30()? as usize;
    let mut classes = Vec::with_capacity(class_count);

    // Instance infos
    for _ in 0..class_count {
        let name_idx = r.read_u30()?;
        let super_name_idx = r.read_u30()?;
        let flags = r.read_u8()?;
        if flags & 0x08 != 0 { r.read_u30()?; } // protected ns
        let iface_count = r.read_u30()? as usize;
        for _ in 0..iface_count { r.read_u30()?; }
        let constructor_idx = r.read_u30()?;
        let trait_count = r.read_u30()? as usize;
        let mut instance_methods = Vec::new();
        for _ in 0..trait_count {
            if let Ok(t) = parse_trait(&mut r, &strings, &multinames) {
                instance_methods.push(t);
            }
        }
        let name = multinames.get(name_idx as usize).map(|m| m.name.clone()).unwrap_or_default();
        let super_name = multinames.get(super_name_idx as usize).map(|m| m.name.clone()).unwrap_or_default();
        classes.push(Class { name, super_name, instance_methods, class_methods: vec![], constructor_idx });
    }

    // Class infos (static traits)
    for i in 0..class_count {
        let _static_init = r.read_u30()?;
        let trait_count = r.read_u30()? as usize;
        for _ in 0..trait_count {
            if let Ok(t) = parse_trait(&mut r, &strings, &multinames) {
                classes[i].class_methods.push(t);
            }
        }
    }

    // ── Scripts ───────────────────────────────────────────────────────────────
    let script_count = r.read_u30()? as usize;
    let mut scripts = Vec::with_capacity(script_count);
    for _ in 0..script_count {
        let init_method_idx = r.read_u30()?;
        let trait_count = r.read_u30()? as usize;
        let mut traits = Vec::new();
        for _ in 0..trait_count {
            if let Ok(t) = parse_trait(&mut r, &strings, &multinames) {
                traits.push(t);
            }
        }
        scripts.push(Script { init_method_idx, traits });
    }

    // ── Method bodies ─────────────────────────────────────────────────────────
    let body_count = r.read_u30()? as usize;
    let mut method_bodies = Vec::with_capacity(body_count);
    for _ in 0..body_count {
        let method_idx = r.read_u30()?;
        let max_stack = r.read_u30()?;
        let local_count = r.read_u30()?;
        let _init_scope_depth = r.read_u30()?;
        let _max_scope_depth = r.read_u30()?;
        let code_len = r.read_u30()? as usize;
        let start = r.pos;
        let bytecode = if r.pos + code_len <= r.data.len() {
            let bc = r.data[start..start + code_len].to_vec();
            r.pos += code_len;
            bc
        } else {
            r.pos = r.data.len();
            vec![]
        };

        // Skip exception handlers
        let ex_count = r.read_u30().unwrap_or(0) as usize;
        for _ in 0..ex_count {
            r.read_u30().ok(); // from
            r.read_u30().ok(); // to
            r.read_u30().ok(); // target
            r.read_u30().ok(); // exc_type
            r.read_u30().ok(); // var_name
        }

        // Parse method body traits (activation slot names)
        let trait_count = r.read_u30().unwrap_or(0) as usize;
        let mut activation_traits = Vec::new();
        for _ in 0..trait_count {
            match parse_trait(&mut r, &strings, &multinames) {
                Ok(t) => activation_traits.push(t),
                Err(_) => break,
            }
        }

        method_bodies.push(MethodBody { method_idx, max_stack, local_count, bytecode, activation_traits });
    }

    log::info!("ABC: {} methods, {} classes, {} method bodies", methods.len(), classes.len(), method_bodies.len());

    Ok(AbcFile { strings, ints, uints, doubles, multinames, methods, classes, scripts, method_bodies })
}

fn parse_trait(r: &mut Reader, strings: &[String], multinames: &[Multiname]) -> Result<Trait> {
    let name_idx = r.read_u30()?;
    let kind_byte = r.read_u8()?;
    let kind = kind_byte & 0x0F;
    let has_metadata = kind_byte & 0x40 != 0;
    let name = multinames.get(name_idx as usize).map(|m| m.name.clone()).unwrap_or_default();

    let (method_idx, slot_idx) = match kind {
        0 | 6 => { // Slot, Const
            let slot_id = r.read_u30()?;
            let _type_name = r.read_u30()?;
            let vindex = r.read_u30()?;
            if vindex != 0 { r.read_u8()?; } // vkind
            (0, slot_id)
        }
        1 | 2 | 3 => { // Method, Getter, Setter
            let _disp_id = r.read_u30()?;
            let method_idx = r.read_u30()?;
            (method_idx, 0)
        }
        4 | 5 => { // Class, Function
            let slot_id = r.read_u30()?;
            let idx = r.read_u30()?;
            (idx, slot_id)
        }
        _ => {
            return Err(anyhow!("Unknown trait kind: {}", kind));
        }
    };

    if has_metadata {
        let mc = r.read_u30()? as usize;
        for _ in 0..mc { r.read_u30()?; }
    }

    Ok(Trait { name, kind, method_idx, slot_idx })
}

// ─── Character data extraction ────────────────────────────────────────────────

/// Extract the SSF2 animation name set by self.xframe from a frame* method's bytecode.
/// Scans for the first PUSHSTRING instruction whose value looks like an animation name.
fn extract_xframe_name(bytecode: &[u8], abc: &AbcFile) -> Option<String> {
    let mut i = 0;
    while i < bytecode.len() {
        let op = bytecode[i];
        i += 1;
        match op {
            OP_PUSHSTRING => {
                if let Some(idx) = read_u30_at(bytecode, &mut i) {
                    if let Some(s) = abc.strings.get(idx as usize) {
                        // xframe values are short snake_case strings, not bytecode artifacts
                        if !s.is_empty() && s.len() < 40 && s.chars().all(|c| c.is_alphanumeric() || c == '_') {
                            return Some(s.clone());
                        }
                    }
                }
            }
            OP_PUSHBYTE => { i += 1; }
            OP_PUSHSHORT | OP_PUSHINT | OP_PUSHUINT | OP_PUSHDOUBLE => { read_u30_at(bytecode, &mut i); }
            OP_GETLEX | OP_FINDPROPSTRICT | OP_FINDPROP | OP_GETPROPERTY |
            OP_SETPROPERTY | OP_INITPROPERTY | OP_COERCE | OP_CALLPROPVOID |
            OP_CALLPROPERTY | OP_GETLOCAL | OP_SETLOCAL | OP_NEWARRAY | OP_NEWOBJECT => {
                read_u30_at(bytecode, &mut i);
            }
            OP_CONSTRUCTPROP => { read_u30_at(bytecode, &mut i); read_u30_at(bytecode, &mut i); }
            OP_JUMP | OP_IFTRUE | OP_IFFALSE | OP_IFEQ | OP_IFNE | OP_IFLT |
            OP_IFLE | OP_IFGT | OP_IFGE | OP_IFSTRICTEQ | OP_IFSTRICTNE => {
                if i + 3 <= bytecode.len() { i += 3; }
            }
            _ => {}
        }
    }
    None
}

/// Extract character data by analyzing ABC bytecode
pub fn extract_character(abc: &AbcFile, char_name: &str) -> Result<ExtractedCharacter> {
    let mut attacks: BTreeMap<String, AttackData> = BTreeMap::new();
    let mut stats: Option<CharStats> = None;
    let mut frame_scripts: BTreeMap<String, Vec<FrameAction>> = BTreeMap::new();
    let mut ext_methods: BTreeMap<String, String> = BTreeMap::new();
    let mut xframe_map: XframeMap = BTreeMap::new();

    // Build method name lookup: method_idx → name
    let mut method_names: BTreeMap<u32, String> = BTreeMap::new();
    for (body_idx, body) in abc.method_bodies.iter().enumerate() {
        if let Some(method) = abc.methods.get(body.method_idx as usize) {
            if !method.name.is_empty() {
                method_names.insert(body.method_idx, method.name.clone());
            }
        }
    }

    // Find the XxxExt class (e.g. MarioExt) — holds getOwnStats + getAttackStats
    let ext_class_name = format!("{}Ext", 
        char_name.chars().next().map(|c| c.to_uppercase().to_string()).unwrap_or_default()
        + &char_name[1..]);
    let char_class = abc.classes.iter()
        .find(|c| c.name == ext_class_name)
        .or_else(|| abc.classes.iter().find(|c| c.name.ends_with("Ext") && c.name.to_lowercase().contains(&char_name.to_lowercase())));

    log::info!("Character Ext class: {:?}", char_class.map(|c| &c.name));

    // Build a map from method_idx → trait name (e.g. getOwnStats, getAttackStats, frame1)
    let mut trait_name_for_method: BTreeMap<u32, String> = BTreeMap::new();
    for class in &abc.classes {
        for t in class.instance_methods.iter().chain(class.class_methods.iter()) {
            if !t.name.is_empty() {
                trait_name_for_method.insert(t.method_idx, t.name.clone());
            }
        }
    }

    // Build body lookup: method_idx → body
    let body_by_method: BTreeMap<u32, &MethodBody> = abc.method_bodies.iter()
        .map(|b| (b.method_idx, b))
        .collect();

    // --- Process MarioExt methods specifically ---
    if let Some(ext) = char_class {
        for t in &ext.instance_methods {
            let Some(body) = body_by_method.get(&t.method_idx) else { continue };
            match t.name.as_str() {
                "getOwnStats" => {
                    // getOwnStats contains the big character stats newobject.
                    // We scan the bytecode for specific SSF2 stat key pushes
                    // followed by numeric values.
                    if let Some(s) = extract_ssf2_stats(&body.bytecode, abc) {
                        log::info!("getOwnStats: extracted {} stat values", s.values.len());
                        stats = Some(s);
                    }
                }
                "getAttackStats" => {
                    let extracted = extract_attack_objects(&body.bytecode, abc);
                    log::info!("getAttackStats: extracted {} attacks", extracted.len());
                    attacks.extend(extracted);
                }
                name if name.starts_with("frame") => {
                    // Extract xframe animation name first
                    if let Some(anim_name) = extract_xframe_name(&body.bytecode, abc) {
                        xframe_map.insert(name.to_string(), anim_name);
                    }
                    // Use decompiler for full Haxe output
                    let params: Vec<String> = if let Some(method) = abc.methods.get(body.method_idx as usize) {
                        (0..method.param_count).map(|i| format!("arg{}", i)).collect()
                    } else { vec![] };
                    let code = decompiler::decompile_method(body, abc, name, &params);
                    frame_scripts.insert(name.to_string(), vec![FrameAction {
                        frame: 0,
                        action: code,
                        args: vec![],
                    }]);
                }
                // Decompile all other Ext methods for Script.hx
                // Skip slot/const traits (kind 0/6) — those are variable declarations, not methods
                name if !matches!(name, "getOwnStats" | "getAttackStats" | "getItemStats" | "getProjectileStats") => {
                    // Only decompile actual method traits (kind 1/2/3), not slots (kind 0/6)
                    // The trait.kind is stored in the Trait struct; method_idx > 0 means it's a real method
                    if t.kind & 0x0F != 0 || t.slot_idx == 0 {
                        // Get param count from method signature
                        let params: Vec<String> = if let Some(method) = abc.methods.get(body.method_idx as usize) {
                            (0..method.param_count).map(|i| format!("arg{}", i)).collect()
                        } else {
                            vec![]
                        };
                        let code = decompiler::decompile_method(body, abc, name, &params);
                        ext_methods.insert(name.to_string(), code);
                    }
                }
                _ => {}
            }
        }
    }

    // --- Also scan the main `mario` class for frame scripts ---
    let main_class = abc.classes.iter().find(|c| c.name.to_lowercase() == char_name.to_lowercase());
    if let Some(mc) = main_class {
        log::info!("Main class '{}': {} frame methods", mc.name, mc.instance_methods.len());
        for t in &mc.instance_methods {
            if !t.name.starts_with("frame") { continue; }
            let Some(body) = body_by_method.get(&t.method_idx) else { continue };
            // Extract xframe name
            if let Some(anim_name) = extract_xframe_name(&body.bytecode, abc) {
                xframe_map.insert(t.name.clone(), anim_name);
            }
            let params: Vec<String> = if let Some(method) = abc.methods.get(body.method_idx as usize) {
                (0..method.param_count).map(|i| format!("arg{}", i)).collect()
            } else { vec![] };
            let code = decompiler::decompile_method(body, abc, &t.name, &params);
            frame_scripts.insert(t.name.clone(), vec![FrameAction {
                frame: 0,
                action: code,
                args: vec![],
            }]);
        }
    }

    // --- Fallback: scan all bodies if we got nothing ---
    if attacks.is_empty() {
        log::warn!("getAttackStats extraction yielded nothing, falling back to full scan");
        for body in &abc.method_bodies {
            let extracted = extract_attack_objects(&body.bytecode, abc);
            for (name, data) in extracted {
                attacks.entry(name).or_insert(data);
            }
        }
    }
    if stats.is_none() {
        for body in &abc.method_bodies {
            if let Some(s) = extract_stats_from_body(&body.bytecode, abc) {
                stats = Some(s);
                break;
            }
        }
    }

    // SSF2 costume/palette data lives in the engine SWF, not the character SWF.
    // Both getCostumeData and applyPalette are thin wrappers that call m_api at runtime.
    // We cannot extract the actual costume color data from here.
    // palette_gen.rs builds costumes from sprite imagery instead.
    let costumes: Vec<CostumeData> = vec![];
    log::info!("Extracted {} attacks, {} frame scripts, {} ext methods, {} xframe mappings, {} costumes, stats={}",
        attacks.len(), frame_scripts.len(), ext_methods.len(), xframe_map.len(), costumes.len(), stats.is_some());

    Ok(ExtractedCharacter {
        name: char_name.to_string(),
        attacks,
        stats,
        frame_scripts,
        ext_methods,
        xframe_map,
        costumes,
    })
}

/// Simulate the AVM2 stack to extract object literals from bytecode.
/// SSF2 attack data structure:
///   newobject(N) where one key is 'attackBoxes' → value is newobject(M hitboxes)
///   each hitbox is newobject(10) with keys: damage, priority, hitStun, hitLag,
///     effect_id, direction, weightKB, power, kbConstant, effectSound
/// The top-level getAttackStats builds: newobject(attack_count) where keys are move names
#[derive(Debug, Clone)]
enum StackVal {
    Str(String),
    Num(f64),
    Bool(bool),
    Null,
    /// A parsed object literal from newobject
    Obj(BTreeMap<String, StackVal>),
    /// A parsed array from newarray
    Arr(Vec<StackVal>),
    Unknown,
}

fn extract_attack_objects(bytecode: &[u8], abc: &AbcFile) -> BTreeMap<String, AttackData> {
    let mut result: BTreeMap<String, AttackData> = BTreeMap::new();
    let mut stack: Vec<StackVal> = Vec::new();
    let mut i = 0;

    while i < bytecode.len() {
        let op = bytecode[i];
        i += 1;

        match op {
            OP_PUSHSTRING => {
                if let Some(idx) = read_u30_at(bytecode, &mut i) {
                    let s = abc.strings.get(idx as usize).cloned().unwrap_or_default();
                    stack.push(StackVal::Str(s));
                }
            }
            OP_PUSHDOUBLE => {
                if let Some(idx) = read_u30_at(bytecode, &mut i) {
                    let v = abc.doubles.get(idx as usize).copied().unwrap_or(0.0);
                    stack.push(StackVal::Num(v));
                }
            }
            OP_PUSHBYTE => {
                if i < bytecode.len() {
                    let v = bytecode[i] as i8 as f64;
                    i += 1;
                    stack.push(StackVal::Num(v));
                }
            }
            OP_PUSHSHORT => {
                if let Some(v) = read_u30_at(bytecode, &mut i) {
                    stack.push(StackVal::Num(v as i16 as f64));
                }
            }
            OP_PUSHINT => {
                if let Some(idx) = read_u30_at(bytecode, &mut i) {
                    let v = abc.ints.get(idx as usize).copied().unwrap_or(0) as f64;
                    stack.push(StackVal::Num(v));
                }
            }
            OP_PUSHUINT => {
                if let Some(idx) = read_u30_at(bytecode, &mut i) {
                    let v = abc.uints.get(idx as usize).copied().unwrap_or(0) as f64;
                    stack.push(StackVal::Num(v));
                }
            }
            OP_PUSHTRUE  => stack.push(StackVal::Bool(true)),
            OP_PUSHFALSE => stack.push(StackVal::Bool(false)),
            OP_PUSHNULL | OP_PUSHNAN => stack.push(StackVal::Null),

            OP_NEWOBJECT => {
                if let Some(count) = read_u30_at(bytecode, &mut i) {
                    let count = count as usize;
                    let needed = count * 2;
                    let mut obj: BTreeMap<String, StackVal> = BTreeMap::new();
                    if stack.len() >= needed {
                        let pairs: Vec<_> = stack.drain(stack.len() - needed..).collect();
                        for chunk in pairs.chunks(2) {
                            if let StackVal::Str(k) = &chunk[0] {
                                obj.insert(k.clone(), chunk[1].clone());
                            }
                        }
                    }

                    // Check if this is a top-level attacks object:
                    // keys are move names ("a", "b", "a_air", etc.)
                    let attack_keys_found: Vec<_> = obj.keys()
                        .filter(|k| is_attack_name(k))
                        .cloned().collect();

                    if !attack_keys_found.is_empty() {
                        // This is the top-level move map
                        for move_name in &attack_keys_found {
                            let fm_name = normalize_attack_name(move_name);
                            if let Some(val) = obj.get(move_name) {
                                let hitboxes = extract_hitboxes_from_val(val);
                                if !hitboxes.is_empty() {
                                    result.insert(fm_name, AttackData { hitboxes });
                                }
                            }
                        }
                        // Also check non-attack-name keys that might contain moves (e.g. grouped)
                        stack.push(StackVal::Obj(obj));
                    } else {
                        stack.push(StackVal::Obj(obj));
                    }
                }
            }

            OP_NEWARRAY => {
                if let Some(count) = read_u30_at(bytecode, &mut i) {
                    let drain = stack.len().min(count as usize);
                    let items: Vec<_> = if stack.len() >= drain {
                        stack.drain(stack.len() - drain..).collect()
                    } else { vec![] };
                    stack.push(StackVal::Unknown);
                }
            }

            OP_CALLPROPERTY | OP_CALLPROPVOID => {
                let mn_idx = read_u30_at(bytecode, &mut i).unwrap_or(0);
                let arg_count = read_u30_at(bytecode, &mut i).unwrap_or(0) as usize;
                let drain = stack.len().min(arg_count + 1);
                stack.drain(stack.len() - drain..);
                if op == OP_CALLPROPERTY { stack.push(StackVal::Unknown); }
            }

            OP_SETPROPERTY | OP_INITPROPERTY => {
                let _mn_idx = read_u30_at(bytecode, &mut i).unwrap_or(0);
                if stack.len() >= 2 { stack.truncate(stack.len() - 2); }
            }

            OP_GETPROPERTY => {
                let mn_idx = read_u30_at(bytecode, &mut i).unwrap_or(0);
                let name = abc.multinames.get(mn_idx as usize).map(|m| m.name.clone()).unwrap_or_default();
                // Pop object, push value (unknown unless we track obj)
                if !stack.is_empty() { stack.pop(); }
                stack.push(StackVal::Str(name));
            }

            OP_FINDPROPSTRICT | OP_FINDPROP | OP_GETLEX => {
                read_u30_at(bytecode, &mut i);
                stack.push(StackVal::Unknown);
            }
            OP_COERCE | OP_COERCE_A | OP_CONVERT_D | OP_CONVERT_I => {
                if op == OP_COERCE { read_u30_at(bytecode, &mut i); }
            }
            OP_NOP | OP_LABEL => {}
            OP_POP => { stack.pop(); }
            OP_DUP => { if let Some(top) = stack.last().cloned() { stack.push(top); } }
            OP_SWAP => { let len = stack.len(); if len >= 2 { stack.swap(len-1, len-2); } }
            OP_NEGATE => {
                match stack.pop() {
                    Some(StackVal::Num(v)) => stack.push(StackVal::Num(-v)),
                    _ => stack.push(StackVal::Unknown),
                }
            }
            OP_ADD | OP_SUBTRACT | OP_MULTIPLY | OP_DIVIDE => {
                let b = stack.pop(); let a = stack.pop();
                match (a, b) {
                    (Some(StackVal::Num(a)), Some(StackVal::Num(b))) => {
                        let r = match op {
                            OP_ADD => a+b, OP_SUBTRACT => a-b,
                            OP_MULTIPLY => a*b, OP_DIVIDE => a/b, _ => 0.0
                        };
                        stack.push(StackVal::Num(r));
                    }
                    _ => stack.push(StackVal::Unknown),
                }
            }
            OP_CONSTRUCTPROP => {
                read_u30_at(bytecode, &mut i);
                let argc = read_u30_at(bytecode, &mut i).unwrap_or(0) as usize;
                let drain = stack.len().min(argc + 1);
                stack.drain(stack.len() - drain..);
                stack.push(StackVal::Unknown);
            }
            OP_CONSTRUCT => {
                let argc = read_u30_at(bytecode, &mut i).unwrap_or(0) as usize;
                let drain = stack.len().min(argc + 1);
                stack.drain(stack.len() - drain..);
                stack.push(StackVal::Unknown);
            }
            OP_GETLOCAL0 | OP_GETLOCAL1 | OP_GETLOCAL2 | OP_GETLOCAL3 => stack.push(StackVal::Unknown),
            OP_GETLOCAL => { read_u30_at(bytecode, &mut i); stack.push(StackVal::Unknown); }
            OP_SETLOCAL0 | OP_SETLOCAL1 | OP_SETLOCAL2 | OP_SETLOCAL3 => { stack.pop(); }
            OP_SETLOCAL => { read_u30_at(bytecode, &mut i); stack.pop(); }
            OP_RETURNVALUE => { stack.pop(); }
            OP_RETURNVOID => {}
            OP_JUMP | OP_IFTRUE | OP_IFFALSE | OP_IFEQ | OP_IFNE | OP_IFLT |
            OP_IFLE | OP_IFGT | OP_IFGE | OP_IFSTRICTEQ | OP_IFSTRICTNE => {
                if i + 3 <= bytecode.len() { i += 3; }
                if op != OP_JUMP { stack.pop(); }
            }
            _ => {}
        }

        if stack.len() > 512 { stack.drain(0..256); }
    }

    result
}

/// Recursively extract hitboxes from a StackVal.
/// SSF2 attack objects have key 'attackBoxes' → object with 'attackBox', 'attackBox2', etc.
fn extract_hitboxes_from_val(val: &StackVal) -> Vec<BTreeMap<String, f64>> {
    match val {
        StackVal::Obj(obj) => {
            // Look for 'attackBoxes' key
            if let Some(boxes_val) = obj.get("attackBoxes") {
                return extract_hitboxes_from_val(boxes_val);
            }
            // Is this object itself a hitbox? (has damage/direction/power)
            let hitbox_keys = ["damage", "direction", "power", "kbConstant", "hitStun", "hitLag", "weightKB"];
            if obj.keys().any(|k| hitbox_keys.contains(&k.as_str())) {
                let mut hb = BTreeMap::new();
                for k in &hitbox_keys {
                    if let Some(StackVal::Num(v)) = obj.get(*k) {
                        hb.insert(k.to_string(), *v);
                    }
                }
                return vec![hb];
            }
            // Might be a container of hitboxes: {attackBox: {...}, attackBox2: {...}, ...}
            let mut hitboxes = Vec::new();
            for (k, v) in obj {
                if k.starts_with("attackBox") {
                    hitboxes.extend(extract_hitboxes_from_val(v));
                }
            }
            hitboxes
        }
        _ => vec![]
    }
}

fn extract_stats_from_body(bytecode: &[u8], abc: &AbcFile) -> Option<CharStats> {
    // Simulate stack; look for newobject whose keys include stat names
    let mut stack: Vec<StackVal> = Vec::new();
    let mut i = 0;

    while i < bytecode.len() {
        let op = bytecode[i];
        i += 1;
        match op {
            OP_PUSHSTRING => {
                if let Some(idx) = read_u30_at(bytecode, &mut i) {
                    stack.push(StackVal::Str(abc.strings.get(idx as usize).cloned().unwrap_or_default()));
                }
            }
            OP_PUSHDOUBLE => {
                if let Some(idx) = read_u30_at(bytecode, &mut i) {
                    stack.push(StackVal::Num(abc.doubles.get(idx as usize).copied().unwrap_or(0.0)));
                }
            }
            OP_PUSHBYTE => {
                if i < bytecode.len() { let v = bytecode[i] as i8 as f64; i += 1; stack.push(StackVal::Num(v)); }
            }
            OP_PUSHSHORT => {
                if let Some(v) = read_u30_at(bytecode, &mut i) { stack.push(StackVal::Num(v as i16 as f64)); }
            }
            OP_PUSHINT => {
                if let Some(idx) = read_u30_at(bytecode, &mut i) {
                    stack.push(StackVal::Num(abc.ints.get(idx as usize).copied().unwrap_or(0) as f64));
                }
            }
            OP_PUSHUINT => {
                if let Some(idx) = read_u30_at(bytecode, &mut i) {
                    stack.push(StackVal::Num(abc.uints.get(idx as usize).copied().unwrap_or(0) as f64));
                }
            }
            OP_PUSHTRUE  => stack.push(StackVal::Bool(true)),
            OP_PUSHFALSE => stack.push(StackVal::Bool(false)),
            OP_PUSHNULL | OP_PUSHNAN => stack.push(StackVal::Null),
            OP_NEWOBJECT => {
                if let Some(count) = read_u30_at(bytecode, &mut i) {
                    let count = count as usize;
                    let needed = count * 2;
                    let mut obj: BTreeMap<String, StackVal> = BTreeMap::new();
                    if stack.len() >= needed {
                        let pairs: Vec<_> = stack.drain(stack.len() - needed..).collect();
                        for chunk in pairs.chunks(2) {
                            if let StackVal::Str(k) = &chunk[0] {
                                obj.insert(k.clone(), chunk[1].clone());
                            }
                        }
                    }
                    // Check if this looks like character stats:
                    // SSF2 uses: gravity, weight1, norm_xSpeed, max_xSpeed, max_ySpeed,
                    //   fastFallSpeed, jumpSpeed, jumpSpeedMidair, accel_rate_air, decel_rate_air
                    let stat_keys = ["gravity", "weight1", "norm_xSpeed", "max_xSpeed",
                                     "fastFallSpeed", "jumpSpeed", "jumpSpeedMidair",
                                     "accel_rate_air", "decel_rate_air", "max_ySpeed",
                                     "accel_rate", "walkSpeed", "dashSpeed", "airMobility"];
                    let numeric_stats: BTreeMap<String, f64> = obj.iter()
                        .filter_map(|(k, v)| {
                            if let StackVal::Num(n) = v { Some((k.clone(), *n)) } else { None }
                        }).collect();
                    // Require at least 3 stat keys to be confident
                    let match_count = numeric_stats.keys().filter(|k| stat_keys.contains(&k.as_str())).count();
                    if match_count >= 3 {
                        return Some(CharStats { values: numeric_stats });
                    }
                    stack.push(StackVal::Obj(obj));
                }
            }
            OP_COERCE | OP_GETLEX | OP_FINDPROPSTRICT | OP_FINDPROP | OP_GETPROPERTY |
            OP_INITPROPERTY | OP_SETPROPERTY => { read_u30_at(bytecode, &mut i); }
            OP_CALLPROPERTY | OP_CALLPROPVOID | OP_CONSTRUCTPROP => {
                read_u30_at(bytecode, &mut i); read_u30_at(bytecode, &mut i);
            }
            OP_GETLOCAL | OP_SETLOCAL | OP_CONSTRUCT | OP_NEWARRAY => { read_u30_at(bytecode, &mut i); }
            OP_JUMP | OP_IFTRUE | OP_IFFALSE | OP_IFEQ | OP_IFNE | OP_IFLT |
            OP_IFLE | OP_IFGT | OP_IFGE | OP_IFSTRICTEQ | OP_IFSTRICTNE => {
                if i + 3 <= bytecode.len() { i += 3; }
            }
            _ => {}
        }
        if stack.len() > 256 { stack.drain(0..128); }
    }
    None
}

/// Extract the largest object in the body that has the most numeric key-value pairs.
/// Used as fallback for getOwnStats when the stat key heuristic doesn't match.
/// Targeted extractor: scan bytecode for SSF2 stat key-value pairs.
/// Looks for consecutive (pushstring key, push_num value) pairs where key is a known stat name.
fn extract_ssf2_stats(bytecode: &[u8], abc: &AbcFile) -> Option<CharStats> {
    const STAT_KEYS: &[&str] = &[
        "gravity", "weight1", "norm_xSpeed", "max_xSpeed", "max_ySpeed",
        "fastFallSpeed", "jumpSpeed", "jumpSpeedMidair", "shortHopSpeed",
        "accel_rate", "accel_rate_air", "decel_rate", "decel_rate_air",
        "accel_start", "accel_start_dash", "max_jump", "dodgeSpeed", "dodgeDecel",
        "roll_speed", "roll_decay", "max_projectile", "width", "height",
        "jumpStartup", "max_jumpSpeed", "groundToAirMultiplier",
    ];

    let mut values: BTreeMap<String, f64> = BTreeMap::new();
    let mut i = 0;

    while i < bytecode.len() {
        let op = bytecode[i]; i += 1;
        // Look for pushstring followed immediately by a numeric push
        if op == OP_PUSHSTRING {
            if let Some(str_idx) = read_u30_at(bytecode, &mut i) {
                let key = abc.strings.get(str_idx as usize).cloned().unwrap_or_default();
                if STAT_KEYS.contains(&key.as_str()) && i < bytecode.len() {
                    // Next op should be a numeric push
                    let next_op = bytecode[i]; i += 1;
                    let val = match next_op {
                        OP_PUSHBYTE => {
                            if i < bytecode.len() { let v = bytecode[i] as i8 as f64; i += 1; Some(v) } else { None }
                        }
                        OP_PUSHSHORT => {
                            read_u30_at(bytecode, &mut i).map(|v| v as i16 as f64)
                        }
                        OP_PUSHINT => {
                            read_u30_at(bytecode, &mut i)
                                .and_then(|idx| abc.ints.get(idx as usize).copied())
                                .map(|v| v as f64)
                        }
                        OP_PUSHUINT => {
                            read_u30_at(bytecode, &mut i)
                                .and_then(|idx| abc.uints.get(idx as usize).copied())
                                .map(|v| v as f64)
                        }
                        OP_PUSHDOUBLE => {
                            read_u30_at(bytecode, &mut i)
                                .and_then(|idx| abc.doubles.get(idx as usize).copied())
                        }
                        _ => {
                            // Back up one byte since it wasn't a numeric push
                            i -= 1;
                            None
                        }
                    };
                    if let Some(v) = val {
                        values.insert(key, v);
                    }
                }
                // Continue; don't double-consume
                continue;
            }
        }
        // Skip operand bytes for other instructions to keep position correct
        match op {
            OP_PUSHDOUBLE | OP_PUSHSTRING | OP_PUSHINT | OP_PUSHUINT |
            OP_COERCE | OP_GETLEX | OP_FINDPROPSTRICT | OP_FINDPROP |
            OP_GETPROPERTY | OP_INITPROPERTY | OP_SETPROPERTY | OP_GETLOCAL | OP_SETLOCAL => {
                read_u30_at(bytecode, &mut i);
            }
            OP_PUSHBYTE => { if i < bytecode.len() { i += 1; } }
            OP_PUSHSHORT => { read_u30_at(bytecode, &mut i); }
            OP_CALLPROPERTY | OP_CALLPROPVOID | OP_CONSTRUCTPROP => {
                read_u30_at(bytecode, &mut i); read_u30_at(bytecode, &mut i);
            }
            OP_CONSTRUCT | OP_NEWARRAY | OP_NEWOBJECT => { read_u30_at(bytecode, &mut i); }
            OP_JUMP | OP_IFTRUE | OP_IFFALSE | OP_IFEQ | OP_IFNE | OP_IFLT |
            OP_IFLE | OP_IFGT | OP_IFGE | OP_IFSTRICTEQ | OP_IFSTRICTNE => {
                if i + 3 <= bytecode.len() { i += 3; }
            }
            _ => {}
        }
    }

    if values.len() >= 3 {
        Some(CharStats { values })
    } else {
        None
    }
}

fn extract_largest_numeric_object(bytecode: &[u8], abc: &AbcFile) -> Option<CharStats> {
    let mut stack: Vec<StackVal> = Vec::new();
    let mut best: Option<BTreeMap<String, f64>> = None;
    let mut i = 0;

    while i < bytecode.len() {
        let op = bytecode[i]; i += 1;
        match op {
            OP_PUSHSTRING => { if let Some(idx) = read_u30_at(bytecode, &mut i) { stack.push(StackVal::Str(abc.strings.get(idx as usize).cloned().unwrap_or_default())); } }
            OP_PUSHDOUBLE => { if let Some(idx) = read_u30_at(bytecode, &mut i) { stack.push(StackVal::Num(abc.doubles.get(idx as usize).copied().unwrap_or(0.0))); } }
            OP_PUSHBYTE   => { if i < bytecode.len() { let v = bytecode[i] as i8 as f64; i += 1; stack.push(StackVal::Num(v)); } }
            OP_PUSHSHORT  => { if let Some(v) = read_u30_at(bytecode, &mut i) { stack.push(StackVal::Num(v as i16 as f64)); } }
            OP_PUSHINT    => { if let Some(idx) = read_u30_at(bytecode, &mut i) { stack.push(StackVal::Num(abc.ints.get(idx as usize).copied().unwrap_or(0) as f64)); } }
            OP_PUSHUINT   => { if let Some(idx) = read_u30_at(bytecode, &mut i) { stack.push(StackVal::Num(abc.uints.get(idx as usize).copied().unwrap_or(0) as f64)); } }
            OP_PUSHTRUE   => stack.push(StackVal::Bool(true)),
            OP_PUSHFALSE  => stack.push(StackVal::Bool(false)),
            OP_PUSHNULL | OP_PUSHNAN => stack.push(StackVal::Null),
            OP_NEWOBJECT => {
                if let Some(count) = read_u30_at(bytecode, &mut i) {
                    let count = count as usize;
                    let needed = count * 2;
                    let mut numeric: BTreeMap<String, f64> = BTreeMap::new();
                    if stack.len() >= needed {
                        let pairs: Vec<_> = stack.drain(stack.len() - needed..).collect();
                        for chunk in pairs.chunks(2) {
                            if let (StackVal::Str(k), StackVal::Num(v)) = (&chunk[0], &chunk[1]) {
                                numeric.insert(k.clone(), *v);
                            }
                        }
                    }
                    // Keep the largest purely numeric object
                    if numeric.len() >= 5 {
                        if best.as_ref().map_or(true, |b: &BTreeMap<String, f64>| numeric.len() > b.len()) {
                            best = Some(numeric.clone());
                        }
                    }
                    stack.push(StackVal::Unknown);
                }
            }
            OP_COERCE | OP_GETLEX | OP_FINDPROPSTRICT | OP_FINDPROP | OP_GETPROPERTY |
            OP_INITPROPERTY | OP_SETPROPERTY => { read_u30_at(bytecode, &mut i); }
            OP_CALLPROPERTY | OP_CALLPROPVOID | OP_CONSTRUCTPROP => {
                read_u30_at(bytecode, &mut i); read_u30_at(bytecode, &mut i);
            }
            OP_GETLOCAL | OP_SETLOCAL | OP_CONSTRUCT | OP_NEWARRAY => { read_u30_at(bytecode, &mut i); }
            OP_JUMP | OP_IFTRUE | OP_IFFALSE | OP_IFEQ | OP_IFNE | OP_IFLT |
            OP_IFLE | OP_IFGT | OP_IFGE | OP_IFSTRICTEQ | OP_IFSTRICTNE => {
                if i + 3 <= bytecode.len() { i += 3; }
            }
            _ => {}
        }
        if stack.len() > 256 { stack.drain(0..128); }
    }
    best.map(|values| CharStats { values })
}

fn extract_frame_actions(bytecode: &[u8], abc: &AbcFile) -> Vec<FrameAction> {
    let mut actions = Vec::new();
    let mut i = 0;
    let mut last_frame_num: u32 = 0;

    while i < bytecode.len() {
        let op = bytecode[i];
        i += 1;
        match op {
            OP_PUSHBYTE => {
                if i < bytecode.len() {
                    last_frame_num = bytecode[i] as u32;
                    i += 1;
                }
            }
            OP_PUSHSHORT => {
                if let Some(v) = read_u30_at(bytecode, &mut i) {
                    last_frame_num = v;
                }
            }
            OP_CALLPROPVOID | OP_CALLPROPERTY => {
                if let Some(mn_idx) = read_u30_at(bytecode, &mut i) {
                    let arg_count = read_u30_at(bytecode, &mut i).unwrap_or(0);
                    let name = abc.multinames.get(mn_idx as usize).map(|m| m.name.clone()).unwrap_or_default();
                    if !name.is_empty() {
                        actions.push(FrameAction {
                            frame: last_frame_num,
                            action: name,
                            args: vec![],
                        });
                    }
                }
            }
            OP_COERCE | OP_GETLEX | OP_FINDPROPSTRICT | OP_FINDPROP | OP_GETPROPERTY |
            OP_INITPROPERTY | OP_SETPROPERTY => { read_u30_at(bytecode, &mut i); }
            OP_CONSTRUCTPROP => { read_u30_at(bytecode, &mut i); read_u30_at(bytecode, &mut i); }
            OP_GETLOCAL | OP_SETLOCAL | OP_NEWARRAY | OP_NEWOBJECT | OP_CONSTRUCT => {
                read_u30_at(bytecode, &mut i);
            }
            OP_JUMP | OP_IFTRUE | OP_IFFALSE | OP_IFEQ | OP_IFNE | OP_IFLT |
            OP_IFLE | OP_IFGT | OP_IFGE | OP_IFSTRICTEQ | OP_IFSTRICTNE => {
                if i + 3 <= bytecode.len() { i += 3; }
            }
            _ => {}
        }
    }
    actions
}

// ─── Helpers ─────────────────────────────────────────────────────────────────

fn read_u30_at(data: &[u8], i: &mut usize) -> Option<u32> {
    let mut result = 0u32;
    let mut shift = 0;
    loop {
        if *i >= data.len() { return None; }
        let b = data[*i] as u32;
        *i += 1;
        result |= (b & 0x7F) << shift;
        shift += 7;
        if b & 0x80 == 0 || shift >= 35 { break; }
    }
    Some(result)
}

/// Is this string an SSF2 attack/move name?
fn is_attack_name(s: &str) -> bool {
    matches!(s, 
        "a" | "a_tilt" | "a_forward" | "a_forward_tilt" | "a_up_tilt" | "a_down_tilt" |
        "crouch_attack" | "a_forwardsmash" | "a_up" | "a_down" |
        "a_air" | "a_air_forward" | "a_air_backward" | "a_air_up" | "a_air_down" |
        "b" | "b_air" | "b_forward" | "b_forward_air" | "b_up" | "b_up_air" |
        "b_down" | "b_down_air" |
        "throw_up" | "throw_forward" | "throw_back" | "throw_down" |
        "ledge_attack" | "getup_attack" | "special" |
        "jab" | "jab1" | "jab2" | "jab3" | "dash" |
        "ftilt" | "utilt" | "dtilt" | "fsmash" | "usmash" | "dsmash" |
        "nair" | "fair" | "bair" | "uair" | "dair" |
        "nspecial" | "sspecial" | "uspecial" | "dspecial"
    )
}

fn normalize_attack_name(s: &str) -> String {
    let map: &[(&str, &str)] = &[
        ("a",              "jab1"),
        ("a_tilt",         "jab1"),
        ("a_forward",      "dash_attack"),
        ("a_forward_tilt", "tilt_forward"),
        ("a_up_tilt",      "tilt_up"),
        ("a_down_tilt",    "tilt_down"),
        ("crouch_attack",  "tilt_down"),
        ("a_forwardsmash", "strong_forward_attack"),
        ("a_up",           "strong_up_attack"),
        ("a_down",         "strong_down_attack"),
        ("a_air",          "aerial_neutral"),
        ("a_air_forward",  "aerial_forward"),
        ("a_air_backward", "aerial_back"),
        ("a_air_up",       "aerial_up"),
        ("a_air_down",     "aerial_down"),
        ("b",              "special_neutral"),
        ("b_air",          "special_neutral_air"),
        ("b_forward",      "special_side"),
        ("b_forward_air",  "special_side_air"),
        ("b_up",           "special_up"),
        ("b_up_air",       "special_up_air"),
        ("b_down",         "special_down"),
        ("b_down_air",     "special_down_air"),
        ("throw_up",       "throw_up"),
        ("throw_forward",  "throw_forward"),
        ("throw_back",     "throw_back"),
        ("throw_down",     "throw_down"),
        ("ledge_attack",   "ledge_attack"),
        ("getup_attack",   "crash_attack"),
    ];
    for (from, to) in map {
        if s == *from { return to.to_string(); }
    }
    s.to_string()
}

/// Does this object look like SSF2 attack hitbox data?
fn is_attack_object(obj: &BTreeMap<String, f64>) -> bool {
    if obj.is_empty() { return false; }
    let attack_keys = ["damage", "direction", "power", "kbConstant", "weightKB",
                       "hitStun", "selfHitStun", "hitLag", "angle"];
    obj.keys().any(|k| attack_keys.contains(&k.as_str()))
}

/// Does this object look like character physics stats?
fn is_stats_object(obj: &BTreeMap<String, f64>) -> bool {
    if obj.is_empty() { return false; }
    let stat_keys = ["weight", "gravity", "fallSpeed", "fastFallSpeed",
                     "walkSpeed", "dashSpeed", "airMobility", "maxJumps",
                     "jumpHeight", "doubleJumpHeight", "airFriction"];
    obj.keys().any(|k| stat_keys.contains(&k.as_str()))
}


/// Extract costume data from SSF2API::getCostumeData (static method).
///
/// getCostumeData returns an Array of objects: [{name:"Default", colors:[0xFFRRGGBB,...]}, ...]
/// We simulate the AVM2 stack to reconstruct these objects.
pub fn extract_costume_data(abc: &AbcFile) -> Vec<CostumeData> {
    let api_class = abc.classes.iter().find(|c| c.name == "SSF2API");
    let Some(api) = api_class else {
        log::debug!("extract_costume_data: no SSF2API class");
        return vec![];
    };
    let mi = match api.class_methods.iter().find(|t| t.name == "getCostumeData") {
        Some(t) => t.method_idx,
        None => { log::debug!("extract_costume_data: no getCostumeData trait"); return vec![]; }
    };
    let body = match abc.method_bodies.iter().find(|b| b.method_idx == mi) {
        Some(b) => b,
        None => { log::debug!("extract_costume_data: no body for mi={}", mi); return vec![]; }
    };
    log::info!("extract_costume_data: decoding getCostumeData ({} bytes)", body.bytecode.len());
    // Decode the 13-byte wrapper: getlex CLASS → callproperty METHOD → returnvalue
    // The real costume data is in CLASS::METHOD. Decode the wrapper to find which method.
    {
        let code = &body.bytecode;
        let mut pos = 0usize;
        // skip getlocal_0 + pushscope
        while pos < code.len() && code[pos] != 0x60 { pos += 1; }
        if code[pos] == 0x60 {
            pos += 1;
            let class_mn = read_u30_at(code, &mut pos).unwrap_or(0) as usize;
            log::info!("getCostumeData wrapper: getlex multiname[{}] = {:?}",
                class_mn, abc.multinames.get(class_mn));
            // find callproperty
            while pos < code.len() && code[pos] != 0x46 { pos += 1; }
            if code[pos] == 0x46 {
                pos += 1;
                let method_mn = read_u30_at(code, &mut pos).unwrap_or(0) as usize;
                let argc = read_u30_at(code, &mut pos).unwrap_or(0);
                log::info!("getCostumeData wrapper: callproperty multiname[{}] = {:?} argc={}",
                    method_mn, abc.multinames.get(method_mn), argc);

                // Now find the class with that name and the method with that name
                let class_name = abc.multinames.get(class_mn).map(|m| m.name.as_str()).unwrap_or("");
                let method_name = abc.multinames.get(method_mn).map(|m| m.name.as_str()).unwrap_or("");
                log::info!("getCostumeData delegates to {}::{}", class_name, method_name);

                // Scan ALL method bodies with many pushuint (0x2E) calls — color palette data
                let mut best: Vec<(u32, usize, u32)> = vec![]; // (method_idx, bytes, pushuint_count)
                for body2 in &abc.method_bodies {
                    let pu_count = body2.bytecode.iter().filter(|&&b| b == 0x2E).count() as u32;
                    if pu_count >= 8 {
                        best.push((body2.method_idx, body2.bytecode.len(), pu_count));
                    }
                }
                best.sort_by_key(|&(_, _, pu)| std::cmp::Reverse(pu));
                let trait_for: BTreeMap<u32, (&str, &str)> = abc.classes.iter()
                    .flat_map(|cls| cls.instance_methods.iter().chain(cls.class_methods.iter())
                        .map(move |t| (t.method_idx, (cls.name.as_str(), t.name.as_str()))))
                    .collect();
                for (mi2, bytes, pu) in best.iter().take(10) {
                    let (cn, mn) = trait_for.get(mi2).copied().unwrap_or(("?", "?"));
                    log::info!("  pushuint-heavy: mi={} {}::{} bytes={} pushuints={}", mi2, cn, mn, bytes, pu);
                }
            }
        }
    }

    let code = &body.bytecode;
    let mut pos = 0usize;
    let mut stack: Vec<StackVal> = Vec::new();
    let mut costumes: Vec<CostumeData> = Vec::new();

    macro_rules! ru30 {
        () => { read_u30_at(code, &mut pos).unwrap_or(0) }
    }

    while pos < code.len() {
        let op = code[pos]; pos += 1;
        match op {
            0x24 => { // pushbyte
                let v = if pos < code.len() { let b = code[pos] as i8; pos += 1; b as f64 } else { 0.0 };
                stack.push(StackVal::Num(v));
            }
            0x25 => { let v = ru30!() as i16; stack.push(StackVal::Num(v as f64)); }
            0x2C => { // pushstring
                let i = ru30!() as usize;
                stack.push(StackVal::Str(abc.strings.get(i).cloned().unwrap_or_default()));
            }
            0x2D => { // pushint
                let i = ru30!() as usize;
                stack.push(StackVal::Num(abc.ints.get(i).copied().unwrap_or(0) as f64));
            }
            0x2E => { // pushuint
                let i = ru30!() as usize;
                stack.push(StackVal::Num(abc.uints.get(i).copied().unwrap_or(0) as f64));
            }
            0x2F => { // pushdouble
                let i = ru30!() as usize;
                stack.push(StackVal::Num(abc.doubles.get(i).copied().unwrap_or(0.0)));
            }
            0x26 => stack.push(StackVal::Bool(true)),
            0x27 => stack.push(StackVal::Bool(false)),
            0x20 | 0x28 => stack.push(StackVal::Null),
            0x56 => { // newarray(n)
                let n = ru30!() as usize;
                let start = stack.len().saturating_sub(n);
                let items = stack.drain(start..).collect();
                stack.push(StackVal::Arr(items));
            }
            0x55 => { // newobject(n) — 2n items on stack: key0,val0,key1,val1,...
                let n = ru30!() as usize;
                let start = stack.len().saturating_sub(n * 2);
                let items: Vec<StackVal> = stack.drain(start..).collect();
                let mut obj: BTreeMap<String, StackVal> = BTreeMap::new();
                let mut i = 0;
                while i + 1 < items.len() {
                    if let StackVal::Str(k) = &items[i] {
                        obj.insert(k.clone(), items[i+1].clone());
                    }
                    i += 2;
                }
                // Is this a costume entry? { name: "...", colors: [...] }
                if let (Some(StackVal::Str(name)), Some(StackVal::Arr(colors))) =
                    (obj.get("name"), obj.get("colors"))
                {
                    let color_vals: Vec<u32> = colors.iter().filter_map(|c| {
                        if let StackVal::Num(v) = c { Some(*v as u32) } else { None }
                    }).collect();
                    if !color_vals.is_empty() {
                        log::debug!("  costume {:?}: {} colors", name, color_vals.len());
                        costumes.push(CostumeData { name: name.clone(), colors: color_vals });
                    }
                }
                stack.push(StackVal::Obj(obj));
            }
            // ops with 2 u30 args
            0x46 | 0x4F | 0x6E | 0x4B | 0x45 | 0x4A => { ru30!(); ru30!(); stack.push(StackVal::Null); }
            // ops with 1 u30 arg (read-side)
            0x60 | 0x5C | 0x5D | 0x80 | 0x65 => { ru30!(); stack.push(StackVal::Null); }
            // ops with 1 u30 arg (write-side — no push)
            0x61 | 0x66 | 0x68 | 0x62 | 0x63 | 0x08 => { ru30!(); }
            // branches (s24)
            0x10 | 0x0C | 0x0D | 0x0E | 0x0F |
            0x13 | 0x14 | 0x15 | 0x16 | 0x17 | 0x18 | 0x19 | 0x1A => { pos += 3; }
            // locals → push placeholder
            0xD0 | 0xD1 | 0xD2 | 0xD3 => stack.push(StackVal::Null),
            // stack ops
            0x29 => { stack.pop(); }
            0x2A => { if let Some(t) = stack.last().cloned() { stack.push(t); } }
            0x2B => { let n = stack.len(); if n >= 2 { stack.swap(n-1, n-2); } }
            // scope
            0x30 | 0x1D => {}
            // return
            0x47 | 0x48 => break,
            // nop / coerce_a / convert_*
            0x02 | 0x82 | 0x73 | 0x74 | 0x75 | 0x76 | 0x70 => {}
            // arithmetic (binary) — pop 2, push 1
            0xA0 | 0xA1 | 0xA2 | 0xA3 | 0xA8 | 0xA9 | 0xAA | 0xA5 | 0xA6 | 0xA7 => {
                stack.pop(); if stack.is_empty() { stack.push(StackVal::Null); }
            }
            // arithmetic (unary) — pop 1, push 1
            0x90 | 0x96 | 0xAB | 0xB1 => {
                if !stack.is_empty() { *stack.last_mut().unwrap() = StackVal::Null; }
            }
            _ => {}
        }
    }

    log::info!("extract_costume_data: {} costumes found", costumes.len());
    costumes
}

/// Extract costume palette data by decoding the applyPalette method.
///
/// SSF2 applies costumes via Flash ColorTransform: each costume index maps to
/// (redMultiplier, greenMultiplier, blueMultiplier, redOffset, greenOffset, blueOffset).
/// The applyPalette method body contains a switch-like structure that pushes these
/// values and calls setTransform on each sprite's ColorTransform.
///
/// We scan for ColorTransform constructor calls with numeric args to extract costume data.
pub fn extract_costume_data_from_apply_palette(abc: &AbcFile) -> Option<Vec<CostumeData>> {
    // Find the character class (e.g. "mario") — applyPalette is an instance method
    let apply_palette_body = abc.classes.iter()
        .flat_map(|cls| cls.instance_methods.iter())
        .find(|t| t.name == "applyPalette")
        .and_then(|t| abc.method_bodies.iter().find(|b| b.method_idx == t.method_idx));

    if apply_palette_body.is_none() {
        // Try class methods too
        log::debug!("extract_apply_palette: applyPalette not found as instance method, trying class methods");
    }

    let body = apply_palette_body?;
    log::info!("extract_apply_palette: found applyPalette ({} bytes)", body.bytecode.len());

    // Simulate the stack looking for sequences of 8 numeric pushes followed by
    // constructprop ColorTransform or callproperty setTransform
    let code = &body.bytecode;
    let mut pos = 0usize;
    let mut stack: Vec<StackVal> = Vec::new();
    let mut costumes: Vec<CostumeData> = Vec::new();
    let mut current_nums: Vec<f64> = Vec::new();

    macro_rules! ru30 { () => { read_u30_at(code, &mut pos).unwrap_or(0) } }

    while pos < code.len() {
        let op = code[pos]; pos += 1;
        match op {
            0x24 => {
                let v = if pos < code.len() { let b = code[pos] as i8; pos += 1; b as f64 } else { 0.0 };
                stack.push(StackVal::Num(v));
                current_nums.push(v);
            }
            0x25 => { let v = ru30!() as i16 as f64; stack.push(StackVal::Num(v)); current_nums.push(v); }
            0x2D => { let i = ru30!() as usize; let v = abc.ints.get(i).copied().unwrap_or(0) as f64; stack.push(StackVal::Num(v)); current_nums.push(v); }
            0x2E => { let i = ru30!() as usize; let v = abc.uints.get(i).copied().unwrap_or(0) as f64; stack.push(StackVal::Num(v)); current_nums.push(v); }
            0x2F => { let i = ru30!() as usize; let v = abc.doubles.get(i).copied().unwrap_or(0.0); stack.push(StackVal::Num(v)); current_nums.push(v); }
            0x2C => { let i = ru30!() as usize; let s = abc.strings.get(i).cloned().unwrap_or_default(); stack.push(StackVal::Str(s)); current_nums.clear(); }
            0x4A => { // constructprop
                let mn = ru30!() as usize; let argc = ru30!();
                let name = abc.multinames.get(mn).map(|m| m.name.as_str()).unwrap_or("");
                if name == "ColorTransform" && argc >= 6 {
                    // last 6 nums on stack: rMult, gMult, bMult, aMult, rOff, gOff, bOff, aOff
                    // or just rMult, gMult, bMult, aMult, rOff, gOff, bOff
                    let nums: Vec<f64> = stack.iter().rev().take(argc as usize)
                        .filter_map(|v| if let StackVal::Num(n) = v { Some(*n) } else { None })
                        .collect::<Vec<_>>().into_iter().rev().collect();
                    if nums.len() >= 3 {
                        // Convert multipliers to 0-255 RGB
                        // Flash ColorTransform: 1.0 = no change, values 0-1 for multiply
                        let r = ((nums[0].abs()) * 255.0).min(255.0) as u8;
                        let g = ((nums[1].abs()) * 255.0).min(255.0) as u8;
                        let b = ((nums[2].abs()) * 255.0).min(255.0) as u8;
                        log::debug!("  ColorTransform({:?}) → rgb=({},{},{})", nums, r, g, b);
                        let idx = costumes.len();
                        costumes.push(CostumeData {
                            name: format!("Alt {}", idx + 1),
                            colors: vec![0xFF000000 | ((r as u32) << 16) | ((g as u32) << 8) | (b as u32)],
                        });
                    }
                    current_nums.clear();
                }
                for _ in 0..argc { stack.pop(); }
                stack.push(StackVal::Null);
            }
            // standard stack ops
            0x46 | 0x4F | 0x6E | 0x4B | 0x45 => { ru30!(); ru30!(); stack.push(StackVal::Null); current_nums.clear(); }
            0x60 | 0x5C | 0x5D | 0x80 | 0x65 => { ru30!(); stack.push(StackVal::Null); }
            0x61 | 0x66 | 0x68 | 0x62 | 0x63 | 0x08 => { ru30!(); }
            0x10 | 0x0C | 0x0D | 0x0E | 0x0F | 0x13 | 0x14 | 0x15 | 0x16 | 0x17 | 0x18 | 0x19 | 0x1A => { pos += 3; }
            0xD0 | 0xD1 | 0xD2 | 0xD3 => stack.push(StackVal::Null),
            0x56 => { let n = ru30!() as usize; let start = stack.len().saturating_sub(n); let items = stack.drain(start..).collect(); stack.push(StackVal::Arr(items)); }
            0x55 => { let n = ru30!() as usize; let start = stack.len().saturating_sub(n*2); stack.drain(start..); stack.push(StackVal::Obj(BTreeMap::new())); }
            0x29 => { stack.pop(); }
            0x2A => { if let Some(t) = stack.last().cloned() { stack.push(t); } }
            0x2B => { let n = stack.len(); if n >= 2 { stack.swap(n-1, n-2); } }
            0x30 | 0x1D => {}
            0x47 | 0x48 => break,
            0x02 | 0x82 | 0x73 | 0x74 | 0x75 | 0x76 | 0x70 => {}
            0xA0 | 0xA1 | 0xA2 | 0xA3 | 0xA8 | 0xA9 | 0xAA | 0xA5 | 0xA6 | 0xA7 => { stack.pop(); if stack.is_empty() { stack.push(StackVal::Null); } }
            0x90 | 0x96 | 0xAB | 0xB1 => { if !stack.is_empty() { *stack.last_mut().unwrap() = StackVal::Null; } }
            0x26 => stack.push(StackVal::Bool(true)),
            0x27 => stack.push(StackVal::Bool(false)),
            0x20 | 0x28 => stack.push(StackVal::Null),
            _ => {}
        }
    }

    if costumes.is_empty() {
        log::info!("extract_apply_palette: no ColorTransform constructors found in applyPalette");
        return None;
    }

    // Insert "Default" costume at index 0
    costumes.insert(0, CostumeData { name: "Default".to_string(), colors: vec![] });
    log::info!("extract_apply_palette: found {} costumes", costumes.len());
    Some(costumes)
}

/// Scan ALL method bodies for SSF2 costume data patterns.
///
/// SSF2 misc.ssf stores costume data per-character as methods that return arrays of
/// {name: String, colors: [uint, uint, ...]} objects. This function finds them all.
///
/// Returns a map of class_name → Vec<CostumeData>.
pub fn scan_all_costume_methods(abc: &AbcFile) -> BTreeMap<String, Vec<CostumeData>> {
    // Build method_idx → (class_name, method_name) map
    let trait_map: BTreeMap<u32, (String, String)> = abc.classes.iter()
        .flat_map(|cls| cls.instance_methods.iter().chain(cls.class_methods.iter())
            .map(move |t| (t.method_idx, (cls.name.clone(), t.name.clone()))))
        .collect();

    let mut results: BTreeMap<String, Vec<CostumeData>> = BTreeMap::new();

    for body in &abc.method_bodies {
        let costumes = decode_costume_objects(&body.bytecode, abc);
        if costumes.is_empty() { continue; }

        let (cls, _mname) = trait_map.get(&body.method_idx)
            .cloned().unwrap_or_else(|| (format!("method_{}", body.method_idx), String::new()));

        // Infer character name from class name (e.g. "MarioAPI" → "mario", "SSF2API" → "all")
        let char_key = infer_char_name(&cls);
        results.entry(char_key).or_default().extend(costumes);
    }

    results
}

fn infer_char_name(class_name: &str) -> String {
    let lower = class_name.to_lowercase();
    // Strip common suffixes
    for suffix in &["api", "data", "ext", "char", "character"] {
        if lower.ends_with(suffix) && lower.len() > suffix.len() {
            return lower[..lower.len()-suffix.len()].to_string();
        }
    }
    lower
}

/// Simulate AVM2 stack execution to find newobject calls that produce {name, colors:[...]} structures.
fn decode_costume_objects(code: &[u8], abc: &AbcFile) -> Vec<CostumeData> {
    #[derive(Clone, Debug)]
    enum V {
        Null,
        Num(f64),
        Str(String),
        Arr(Vec<V>),
        Obj(BTreeMap<String, V>),
    }

    let mut pos = 0usize;
    let mut stack: Vec<V> = Vec::new();
    let mut costumes: Vec<CostumeData> = Vec::new();

    macro_rules! r30 { () => { read_u30_at(code, &mut pos).unwrap_or(0) } }
    macro_rules! pop  { () => { stack.pop().unwrap_or(V::Null) } }

    while pos < code.len() {
        let op = code[pos]; pos += 1;
        match op {
            // Push literals
            0x24 => { let v = code.get(pos).copied().unwrap_or(0) as i8; pos += 1; stack.push(V::Num(v as f64)); }
            0x25 => { let v = r30!() as i16; stack.push(V::Num(v as f64)); }
            0x2C => { let i = r30!() as usize; stack.push(V::Str(abc.strings.get(i).cloned().unwrap_or_default())); }
            0x2D => { let i = r30!() as usize; stack.push(V::Num(*abc.ints.get(i).unwrap_or(&0) as f64)); }
            0x2E => { let i = r30!() as usize; stack.push(V::Num(*abc.uints.get(i).unwrap_or(&0) as f64)); }
            0x2F => { let i = r30!() as usize; stack.push(V::Num(*abc.doubles.get(i).unwrap_or(&0.0))); }
            0x26 | 0x27 | 0x20 | 0x28 => stack.push(V::Null),

            // newarray
            0x56 => {
                let n = r30!() as usize;
                let start = stack.len().saturating_sub(n);
                let items: Vec<V> = stack.drain(start..).collect();
                stack.push(V::Arr(items));
            }

            // newobject — the key opcode
            0x55 => {
                let n = r30!() as usize;
                let start = stack.len().saturating_sub(n * 2);
                let pairs: Vec<V> = stack.drain(start..).collect();
                let mut obj: BTreeMap<String, V> = BTreeMap::new();
                let mut i = 0;
                while i + 1 < pairs.len() {
                    if let V::Str(k) = &pairs[i] { obj.insert(k.clone(), pairs[i+1].clone()); }
                    i += 2;
                }
                // Check for {name: String, colors: [uint, ...]}
                if let (Some(V::Str(name)), Some(V::Arr(color_arr))) = (obj.get("name"), obj.get("colors")) {
                    let colors: Vec<u32> = color_arr.iter().filter_map(|v| {
                        if let V::Num(n) = v { Some(*n as u32) } else { None }
                    }).collect();
                    if colors.len() >= 4 {
                        costumes.push(CostumeData { name: name.clone(), colors });
                    }
                }
                stack.push(V::Obj(obj));
            }

            // Calls — pop args + receiver, push return
            0x46 | 0x4F | 0x4A | 0x6E | 0x4B | 0x45 => {
                r30!(); let argc = r30!() as usize;
                let drain = (argc + 1).min(stack.len());
                stack.drain(stack.len()-drain..);
                stack.push(V::Null);
            }

            0x60 | 0x5C | 0x5D | 0x65 | 0x80 => { r30!(); stack.push(V::Null); }
            0x61 | 0x66 | 0x68 | 0x62 | 0x63 | 0x08 => { r30!(); }
            0x29 => { pop!(); }
            0x2A => { if let Some(v) = stack.last().cloned() { stack.push(v); } }
            0x2B => { let n = stack.len(); if n >= 2 { stack.swap(n-1, n-2); } }
            0xD0 | 0xD1 | 0xD2 | 0xD3 => stack.push(V::Null),
            // Branch opcodes (3-byte offsets)
            0x10 | 0x0C | 0x0D | 0x0E | 0x0F | 0x13 | 0x14 | 0x15 | 0x16 | 0x17 | 0x18 | 0x19 | 0x1A => {
                if pos + 3 <= code.len() { pos += 3; }
            }
            0x47 | 0x48 => break,
            // Arithmetic — consume 1, push result
            0xA0 | 0xA1 | 0xA2 | 0xA3 | 0xA8 | 0xA9 | 0xAA | 0xA5 | 0xA6 | 0xA7 => {
                if !stack.is_empty() { stack.pop(); }
                if stack.is_empty() { stack.push(V::Null); } else { *stack.last_mut().unwrap() = V::Null; }
            }
            0x90 | 0x96 | 0xAB | 0xB1 => { if !stack.is_empty() { *stack.last_mut().unwrap() = V::Null; } }
            0x30 | 0x1D | 0x02 | 0x82 | 0x73 | 0x74 | 0x75 | 0x76 | 0x70 => {}
            _ => {}
        }
    }

    costumes
}
