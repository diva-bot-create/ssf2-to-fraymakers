/// AVM2 bytecode decompiler — structured CFG reconstruction.
///
/// Algorithm:
///   Pass 1: scan bytecode → collect branch targets → split into BasicBlocks
///   Pass 2: reconstruct structured control flow (if/else/while)
///   Pass 3: emit Fraymakers Haxe with SSF2→FM API translation

use std::collections::{BTreeMap, BTreeSet};
use crate::abc_parser::AbcFile;

// ─── SSF2 → Fraymakers API map ────────────────────────────────────────────────

struct ApiEntry { fm: &'static str, comment: &'static str }

macro_rules! api {
    ($fm:expr) => { ApiEntry { fm: $fm, comment: "" } };
    ($fm:expr, $c:expr) => { ApiEntry { fm: $fm, comment: $c } };
}

fn lookup_api(name: &str) -> Option<ApiEntry> {
    Some(match name {
        // physics / movement
        "getX"              => api!("self.getX()"),
        "getY"              => api!("self.getY()"),
        "setX"              => api!("self.setX"),
        "setY"              => api!("self.setY"),
        "getXSpeed"         => api!("self.getXVelocity()"),
        "getYSpeed"         => api!("self.getYVelocity()"),
        "setXSpeed"         => api!("self.setXVelocity"),
        "setYSpeed"         => api!("self.setYVelocity"),
        "getNetXSpeed"      => api!("self.getNetXVelocity()"),
        "getNetYSpeed"      => api!("self.getNetYVelocity()"),
        "setXSpeedScaled"   => api!("self.setXVelocityScaled"),
        "setYSpeedScaled"   => api!("self.setYVelocityScaled"),
        "faceLeft"          => api!("self.faceLeft()"),
        "faceRight"         => api!("self.faceRight()"),
        "flip"              => api!("self.flip()"),
        "flipX"             => api!("self.flipX"),
        "isFacingLeft"      => api!("self.isFacingLeft()"),
        "isFacingRight"     => api!("self.isFacingRight()"),
        "isOnGround" | "isOnFloor" => api!("self.isOnFloor()"),
        "resetMomentum"     => api!("self.resetMomentum()"),
        "toggleGravity"     => api!("self.toggleGravity"),
        "getKnockback"      => api!("self.getKnockback()"),
        "setKnockback"      => api!("self.setKnockback"),
        "move"              => api!("self.move"),
        "moveAbsolute"      => api!("self.moveAbsolute"),
        // state
        "getState"          => api!("self.getState()"),
        "setState"          => api!("self.setState", "// prefer self.toState(CState.X)"),
        "toState"           => api!("self.toState"),
        "inState"           => api!("self.inState"),
        "inStateGroup"      => api!("self.inStateGroup"),
        "getPreviousState"  => api!("self.getPreviousState()"),
        // animation
        "playAnimation"     => api!("self.playAnimation"),
        "playFrame"         => api!("self.playFrame"),
        "playFrameLabel"    => api!("self.playFrameLabel"),
        "getCurrentFrame"   => api!("self.getCurrentFrame()"),
        "getTotalFrames"    => api!("self.getTotalFrames()"),
        "finalFramePlayed"  => api!("self.finalFramePlayed()"),
        "getAnimation"      => api!("self.getAnimation()"),
        "hasAnimation"      => api!("self.hasAnimation"),
        "updateAnimationStats" => api!("self.updateAnimationStats"),
        "updateHitboxStats" => api!("self.updateHitboxStats"),
        // timers / events
        "addTimer"          => api!("self.addTimer"),
        "removeTimer"       => api!("self.removeTimer"),
        "addEventListener"  => api!("self.addEventListener"),
        "removeEventListener" => api!("self.removeEventListener"),
        // combat
        "getDamage"         => api!("self.getDamage()"),
        "setDamage"         => api!("self.setDamage"),
        "addDamage"         => api!("self.addDamage"),
        "getHitstop"        => api!("self.getHitstop()"),
        "getHitstun"        => api!("self.getHitstun()"),
        "startHitstop"      => api!("self.startHitstop"),
        "startHitstun"      => api!("self.startHitstun"),
        "refreshAttackID" | "reactivateHitboxes" => api!("self.reactivateHitboxes()"),
        "attemptHit"        => api!("self.attemptHit"),
        "attemptGrab"       => api!("self.attemptGrab"),
        "releaseCharacter"  => api!("self.releaseCharacter"),
        "releaseAllCharacters" => api!("self.releaseAllCharacters"),
        "getGrabbedFoe"     => api!("self.getGrabbedFoe()"),
        "getAllGrabbedFoes"  => api!("self.getAllGrabbedFoes()"),
        "getOwner"          => api!("self.getOwner()"),
        "setOwner"          => api!("self.setOwner"),
        // match objects
        "getPlayer"         => api!("match.getCharacter", "// TODO: adjust index"),
        "getPlayers"        => api!("match.getCharacters()"),
        "getProjectile"     => api!("match.getProjectile"),
        "getItem"           => api!("match.getItem"),
        "getStage"          => api!("match.getStage()"),
        "createProjectile"  => api!("match.createProjectile"),
        // audio
        "playSound"         => api!("AudioClip.play"),
        "stopSound"         => api!("AudioClip.stop"),
        // display
        "getTopLayer"       => api!("self.getTopLayer()"),
        "getBottomLayer"    => api!("self.getBottomLayer()"),
        "getViewRootContainer" => api!("self.getViewRootContainer()"),
        "getDamageCounterContainer" => api!("self.getDamageCounterContainer()"),
        // scale / rotation
        "getScaleX"         => api!("self.getScaleX()"),
        "getScaleY"         => api!("self.getScaleY()"),
        "setScaleX"         => api!("self.setScaleX"),
        "setScaleY"         => api!("self.setScaleY"),
        "getRotation"       => api!("self.getRotation()"),
        "setRotation"       => api!("self.setRotation"),
        "kill"              => api!("self.kill()"),
        "getResource"       => api!("self.getResource()"),
        "getFoes"           => api!("self.getFoes()"),
        // SSF2-specific with no direct FM equivalent
        "toFlying"          => api!("/* TODO: self.toState(CState.FALL_SPECIAL) */", "// SSF2: toFlying()"),
        "getClosestLedge"   => api!("/* TODO: no FM equivalent */", "// SSF2: getClosestLedge()"),
        "replaceAttackStats" => api!("self.updateAnimationStats", "// SSF2: replaceAttackStats"),
        "replaceAttackBoxStats" => api!("self.updateHitboxStats", "// TODO: replaceAttackBoxStats"),
        "resetRotation"     => api!("/* deactivate hitbox */", "// SSF2: resetRotation()"),
        "bringInFront"      => api!("/* TODO: self.getTopLayer().addChild(...) */", "// SSF2: bringInFront"),
        "bringBehind"       => api!("/* TODO: self.getBottomLayer().addChild(...) */", "// SSF2: bringBehind"),
        _ => return None,
    })
}

// ─── Expression AST ───────────────────────────────────────────────────────────

#[derive(Debug, Clone)]
pub enum Expr {
    Num(f64),
    Str(String),
    Bool(bool),
    Null,
    This,
    Local(u32),
    GetProperty(Box<Expr>, String),
    Call(Box<Expr>, String, Vec<Expr>),
    New(String, Vec<Expr>),
    Array(Vec<Expr>),
    Object(Vec<(String, Expr)>),
    BinOp(&'static str, Box<Expr>, Box<Expr>),
    UnOp(&'static str, Box<Expr>),
    GetLex(String),
    Unknown,
}

impl Expr {
    fn render(&self) -> String {
        match self {
            Expr::Num(v) => {
                if *v == v.round() && v.abs() < 1_000_000.0 { format!("{}", *v as i64) }
                else { format!("{:.4}", v).trim_end_matches('0').trim_end_matches('.').to_string() }
            }
            Expr::Str(s)    => format!("\"{}\"", s.replace('\\', "\\\\").replace('"', "\\\"")),
            Expr::Bool(b)   => b.to_string(),
            Expr::Null      => "null".to_string(),
            Expr::This      => "self".to_string(),
            Expr::Local(n)  => format!("_v{}", n),
            Expr::GetLex(n) => n.clone(),
            Expr::Unknown   => "/* ? */".to_string(),
            Expr::GetProperty(obj, name) => {
                format!("{}.{}", obj.render(), name)
            }
            Expr::Call(obj, method, args) => {
                let arg_str = args.iter().map(|a| a.render()).collect::<Vec<_>>().join(", ");
                // Array index access
                if method == "[" {
                    return format!("{}[{}]", obj.render(), arg_str);
                }
                // Check if obj is self and method is an API call
                let obj_str = obj.render();
                if obj_str == "self" || obj_str == "this" {
                    if let Some(entry) = lookup_api(method) {
                        let fm = entry.fm;
                        let comment = entry.comment;
                        let suffix = if !comment.is_empty() { format!(" {}", comment) } else { String::new() };
                        // No-arg methods stored as "self.xxx()"
                        if fm.ends_with("()") {
                            return format!("{}{}", fm, suffix);
                        }
                        return format!("{}({}){}", fm, arg_str, suffix);
                    }
                }
                format!("{}.{}({})", obj_str, method, arg_str)
            }
            Expr::New(cls, args) => {
                let arg_str = args.iter().map(|a| a.render()).collect::<Vec<_>>().join(", ");
                format!("new {}({})", cls, arg_str)
            }
            Expr::Array(items) => {
                format!("[{}]", items.iter().map(|i| i.render()).collect::<Vec<_>>().join(", "))
            }
            Expr::Object(pairs) => {
                if pairs.is_empty() { return "{}".to_string(); }
                let items = pairs.iter()
                    .map(|(k, v)| format!("{}: {}", k, v.render()))
                    .collect::<Vec<_>>().join(", ");
                format!("{{ {} }}", items)
            }
            Expr::BinOp(op, l, r) => format!("{} {} {}", l.render(), op, r.render()),
            Expr::UnOp("!", e) => match e.as_ref() {
                // Simplify !(a == b) → a != b, !(a != b) → a == b
                Expr::BinOp("==", l, r) => format!("{} != {}", l.render(), r.render()),
                Expr::BinOp("!=", l, r) => format!("{} == {}", l.render(), r.render()),
                Expr::BinOp("<",  l, r) => format!("{} >= {}", l.render(), r.render()),
                Expr::BinOp(">",  l, r) => format!("{} <= {}", l.render(), r.render()),
                Expr::BinOp(">=", l, r) => format!("{} < {}",  l.render(), r.render()),
                Expr::BinOp("<=", l, r) => format!("{} > {}",  l.render(), r.render()),
                _ => format!("!{}", e.render()),
            },
            Expr::UnOp(op, e)     => format!("{}{}", op, e.render()),
        }
    }

    fn is_self(&self) -> bool {
        matches!(self, Expr::This)
            || matches!(self, Expr::GetLex(n) if n == "this")
    }
}

// ─── Statement AST ────────────────────────────────────────────────────────────

#[derive(Debug, Clone)]
pub enum Stmt {
    VarDecl(u32, Expr),
    NamedAssign(String, Expr), // named variable assignment (for activation slots)
    SetProp(Expr, String, Expr),
    Expr(Expr),
    Return(Option<Expr>),
    If(Expr, Vec<Stmt>, Vec<Stmt>),
    While(Expr, Vec<Stmt>),
    Comment(String),
}

fn render_stmts(stmts: &[Stmt], depth: usize) -> String {
    let mut out = String::new();
    let tab = "\t".repeat(depth);
    for s in stmts {
        match s {
            Stmt::NamedAssign(name, v) => out.push_str(&format!("{}var {} = {};\n", tab, name, v.render())),
            Stmt::Comment(c)   => out.push_str(&format!("{}// {}\n", tab, c)),
            Stmt::Return(None) => out.push_str(&format!("{}return;\n", tab)),
            Stmt::Return(Some(e)) => out.push_str(&format!("{}return {};\n", tab, e.render())),
            Stmt::VarDecl(n, v) => {
                let var_name = if *n == 0 {
                    "self".to_string()
                } else {
                    format!("_v{}", n)
                };
                // Skip trivial self = self assignments
                if var_name == "self" && matches!(v, Expr::This) { continue; }
                out.push_str(&format!("{}{} = {};\n", tab, var_name, v.render()));
            }
            Stmt::SetProp(obj, name, val) => {
                out.push_str(&format!("{}{}.{} = {};\n", tab, obj.render(), name, val.render()));
            }
            Stmt::Expr(e) => out.push_str(&format!("{}{};\n", tab, e.render())),
            Stmt::If(cond, then_b, else_b) => {
                out.push_str(&format!("{}if ({}) {{\n", tab, cond.render()));
                out.push_str(&render_stmts(then_b, depth + 1));
                if !else_b.is_empty() {
                    out.push_str(&format!("{}}} else {{\n", tab));
                    out.push_str(&render_stmts(else_b, depth + 1));
                }
                out.push_str(&format!("{}}}\n", tab));
            }
            Stmt::While(cond, body) => {
                out.push_str(&format!("{}while ({}) {{\n", tab, cond.render()));
                out.push_str(&render_stmts(body, depth + 1));
                out.push_str(&format!("{}}}\n", tab));
            }
        }
    }
    out
}

// ─── Opcode constants ─────────────────────────────────────────────────────────

const OP_NOP: u8         = 0x02;
const OP_THROW: u8       = 0x03;
const OP_KILL: u8        = 0x08;
const OP_LABEL: u8       = 0x09;
const OP_JUMP: u8        = 0x10;
const OP_IFTRUE: u8      = 0x11;
const OP_IFFALSE: u8     = 0x12;
const OP_IFEQ: u8        = 0x13;
const OP_IFNE: u8        = 0x14;
const OP_IFLT: u8        = 0x15;
const OP_IFLE: u8        = 0x16;
const OP_IFGT: u8        = 0x17;
const OP_IFGE: u8        = 0x18;
const OP_IFSTRICTEQ: u8  = 0x19;
const OP_IFSTRICTNE: u8  = 0x1A;
const OP_PUSHNULL: u8    = 0x20;
const OP_PUSHBYTE: u8    = 0x24;
const OP_PUSHSHORT: u8   = 0x25;
const OP_PUSHTRUE: u8    = 0x26;
const OP_PUSHFALSE: u8   = 0x27;
const OP_PUSHNAN: u8     = 0x28;
const OP_POP: u8         = 0x29;
const OP_DUP: u8         = 0x2A;
const OP_SWAP: u8        = 0x2B;
const OP_PUSHSTRING: u8  = 0x2C;
const OP_PUSHINT: u8     = 0x2D;
const OP_PUSHUINT: u8    = 0x2E;
const OP_PUSHDOUBLE: u8  = 0x2F;
const OP_PUSHSCOPE: u8   = 0x30;
const OP_NEWFUNCTION: u8 = 0x40;
const OP_CALL: u8        = 0x41;
const OP_CONSTRUCT: u8   = 0x42;
const OP_CALLMETHOD: u8  = 0x43;
const OP_CALLSTATIC: u8  = 0x44;
const OP_CALLSUPER: u8   = 0x45;
const OP_CALLPROPERTY: u8 = 0x46;
const OP_RETURNVOID: u8  = 0x47;
const OP_RETURNVALUE: u8 = 0x48;
const OP_CONSTRUCTSUPER: u8 = 0x49;
const OP_CONSTRUCTPROP: u8 = 0x4A;
const OP_CALLPROPLEX: u8 = 0x4C;
const OP_CALLPROPVOID: u8 = 0x4F;
const OP_NEWOBJECT: u8   = 0x55;
const OP_NEWARRAY: u8    = 0x56;
const OP_NEWACTIVATION: u8 = 0x57;
const OP_NEWCLASS: u8    = 0x58;
const OP_GETDESCENDANTS: u8 = 0x59;
const OP_NEWCATCH: u8    = 0x5A;
const OP_FINDPROP: u8    = 0x5C;
const OP_FINDPROPSTRICT: u8 = 0x5D;
const OP_FINDDEF: u8     = 0x5E;
const OP_GETLEX: u8      = 0x60;
const OP_SETPROPERTY: u8 = 0x61;
const OP_GETLOCAL: u8    = 0x62;
const OP_SETLOCAL: u8    = 0x63;
const OP_GETGLOBALSCOPE: u8 = 0x64;
const OP_GETSCOPEOBJECT: u8 = 0x65;
const OP_GETPROPERTY: u8 = 0x66;
const OP_GETOUTERSCOPE: u8 = 0x67;
const OP_INITPROPERTY: u8 = 0x68;
const OP_DELETEPROPERTY: u8 = 0x6A;
const OP_GETSLOT: u8     = 0x6C;
const OP_SETSLOT: u8     = 0x6D;
const OP_GETGLOBALSLOT: u8 = 0x6E;
const OP_SETGLOBALSLOT: u8 = 0x6F;
const OP_CONVERT_S: u8   = 0x70;
const OP_ESC_XELEM: u8   = 0x71;
const OP_ESC_XATTR: u8   = 0x72;
const OP_CONVERT_I: u8   = 0x73; // yes, 0x73 not 0x83 — check spec
const OP_CONVERT_U: u8   = 0x74;
const OP_CONVERT_D: u8   = 0x75;
const OP_CONVERT_B: u8   = 0x76;
const OP_CONVERT_O: u8   = 0x77;
const OP_CHECKFILTER: u8 = 0x78;
const OP_COERCE: u8      = 0x80;
const OP_COERCE_B: u8    = 0x81;
const OP_COERCE_A: u8    = 0x82;
const OP_COERCE_I: u8    = 0x83;
const OP_COERCE_D: u8    = 0x84;
const OP_COERCE_S: u8    = 0x85;
const OP_ASTYPE: u8      = 0x86;
const OP_ASTYPELATE: u8  = 0x87;
const OP_COERCE_U: u8    = 0x88;
const OP_COERCE_O: u8    = 0x89;
const OP_NEGATE: u8      = 0x90;
const OP_INCREMENT: u8   = 0x91;
const OP_INCLOCAL: u8    = 0x92;
const OP_DECREMENT: u8   = 0x93;
const OP_DECLOCAL: u8    = 0x94;
const OP_TYPEOF: u8      = 0x95;
const OP_NOT: u8         = 0x96;
const OP_BITNOT: u8      = 0x97;
const OP_ADD: u8         = 0xA0;
const OP_SUBTRACT: u8    = 0xA1;
const OP_MULTIPLY: u8    = 0xA2;
const OP_DIVIDE: u8      = 0xA3;
const OP_MODULO: u8      = 0xA4;
const OP_LSHIFT: u8      = 0xA5;
const OP_RSHIFT: u8      = 0xA6;
const OP_URSHIFT: u8     = 0xA7;
const OP_BITAND: u8      = 0xA8;
const OP_BITOR: u8       = 0xA9;
const OP_BITXOR: u8      = 0xAA;
const OP_EQUALS: u8      = 0xAB;
const OP_STRICTEQUALS: u8 = 0xAC;
const OP_LESSTHAN: u8    = 0xAD;
const OP_LESSEQUALS: u8  = 0xAE;
const OP_GREATERTHAN: u8 = 0xAF;
const OP_GREATEREQUALS: u8 = 0xB0;
const OP_INSTANCEOF: u8  = 0xB1;
const OP_ISTYPE: u8      = 0xB2;
const OP_ISTYPELATE: u8  = 0xB3;
const OP_IN: u8          = 0xB4;
const OP_INCREMENT_I: u8 = 0xC0;
const OP_DECREMENT_I: u8 = 0xC1;
const OP_INCLOCAL_I: u8  = 0xC2;
const OP_DECLOCAL_I: u8  = 0xC3;
const OP_NEGATE_I: u8    = 0xC4;
const OP_ADD_I: u8       = 0xC5;
const OP_SUBTRACT_I: u8  = 0xC6;
const OP_MULTIPLY_I: u8  = 0xC7;
const OP_GETLOCAL0: u8   = 0xD0;
const OP_GETLOCAL1: u8   = 0xD1;
const OP_GETLOCAL2: u8   = 0xD2;
const OP_GETLOCAL3: u8   = 0xD3;
const OP_SETLOCAL0: u8   = 0xD4;
const OP_SETLOCAL1: u8   = 0xD5;
const OP_SETLOCAL2: u8   = 0xD6;
const OP_SETLOCAL3: u8   = 0xD7;
const OP_DEBUG: u8       = 0xEF;
const OP_DEBUGLINE: u8   = 0xF0;
const OP_DEBUGFILE: u8   = 0xF1;
const OP_BKPTLINE: u8    = 0xF2;

// ─── Pass 1: measure instruction sizes to find branch targets ─────────────────

fn instr_size(bc: &[u8], pos: usize) -> usize {
    if pos >= bc.len() { return 1; }
    let op = bc[pos];
    match op {
        // no operands
        OP_NOP | OP_THROW | OP_LABEL | OP_PUSHNULL | OP_PUSHTRUE | OP_PUSHFALSE | OP_PUSHNAN
        | OP_POP | OP_DUP | OP_SWAP | OP_PUSHSCOPE | OP_NEWACTIVATION | OP_GETGLOBALSCOPE
        | OP_RETURNVOID | OP_RETURNVALUE | OP_NEGATE | OP_INCREMENT | OP_DECREMENT | OP_TYPEOF
        | OP_NOT | OP_BITNOT | OP_ADD | OP_SUBTRACT | OP_MULTIPLY | OP_DIVIDE | OP_MODULO
        | OP_LSHIFT | OP_RSHIFT | OP_URSHIFT | OP_BITAND | OP_BITOR | OP_BITXOR
        | OP_EQUALS | OP_STRICTEQUALS | OP_LESSTHAN | OP_LESSEQUALS | OP_GREATERTHAN | OP_GREATEREQUALS
        | OP_INSTANCEOF | OP_ISTYPELATE | OP_IN | OP_COERCE_A | OP_COERCE_B | OP_COERCE_D
        | OP_COERCE_I | OP_COERCE_S | OP_COERCE_U | OP_COERCE_O | OP_ASTYPELATE
        | OP_INCREMENT_I | OP_DECREMENT_I | OP_NEGATE_I | OP_ADD_I | OP_SUBTRACT_I | OP_MULTIPLY_I
        | OP_CONVERT_S | OP_CONVERT_I | OP_CONVERT_U | OP_CONVERT_D | OP_CONVERT_B | OP_CONVERT_O
        | OP_CHECKFILTER | OP_ESC_XELEM | OP_ESC_XATTR
        | 0xD0 | 0xD1 | 0xD2 | 0xD3 | 0xD4 | 0xD5 | 0xD6 | 0xD7  // getlocal_0..3, setlocal_0..3
            => 1,
        // 1-byte operand
        OP_PUSHBYTE | OP_KILL | OP_GETSCOPEOBJECT | OP_GETOUTERSCOPE | OP_NEWCATCH
            => 2,
        // 3-byte signed offset (branch instructions)
        OP_JUMP | OP_IFTRUE | OP_IFFALSE | OP_IFEQ | OP_IFNE | OP_IFLT | OP_IFLE | OP_IFGT | OP_IFGE | OP_IFSTRICTEQ | OP_IFSTRICTNE
            => 4,
        // variable-length u30 operand(s)
        OP_PUSHSTRING | OP_PUSHINT | OP_PUSHUINT | OP_PUSHDOUBLE | OP_PUSHSHORT
        | OP_GETLEX | OP_FINDPROP | OP_FINDPROPSTRICT | OP_FINDDEF
        | OP_GETPROPERTY | OP_SETPROPERTY | OP_INITPROPERTY | OP_DELETEPROPERTY
        | OP_GETLOCAL | OP_SETLOCAL | OP_GETGLOBALSLOT | OP_SETGLOBALSLOT
        | OP_GETSLOT | OP_SETSLOT | OP_GETDESCENDANTS
        | OP_COERCE | OP_ASTYPE | OP_ISTYPE
        | OP_NEWFUNCTION | OP_NEWCLASS
        | OP_INCLOCAL | OP_DECLOCAL | OP_INCLOCAL_I | OP_DECLOCAL_I
        | OP_DEBUGLINE | OP_DEBUGFILE | OP_BKPTLINE
            => 1 + u30_len(bc, pos + 1),
        // one u30 operand (not in the multi-u30 group)
        OP_NEWOBJECT | OP_NEWARRAY
            => 1 + u30_len(bc, pos + 1),
        // single u30 (argc only)
        OP_CONSTRUCT | OP_CONSTRUCTSUPER
            => 1 + u30_len(bc, pos + 1),
        // two u30 operands (multiname idx + argc)
        OP_CALLPROPERTY | OP_CALLPROPVOID | OP_CALLPROPLEX | OP_CONSTRUCTPROP
        | OP_CALLMETHOD | OP_CALLSTATIC | OP_CALLSUPER | OP_CALL
            => 1 + u30_len(bc, pos + 1) + u30_len(bc, pos + 1 + u30_len(bc, pos + 1)),
        // Debug: 1 byte + u30 + u30 + u30
        OP_DEBUG => {
            let a = u30_len(bc, pos + 2);
            let b = u30_len(bc, pos + 2 + a);
            let c = u30_len(bc, pos + 2 + a + b);
            2 + a + b + c
        }
        _ => 1, // conservative fallback
    }
}

fn u30_len(bc: &[u8], mut pos: usize) -> usize {
    let start = pos;
    while pos < bc.len() {
        let b = bc[pos]; pos += 1;
        if b & 0x80 == 0 { break; }
        if pos - start >= 5 { break; }
    }
    pos - start
}

fn read_u30_at(bc: &[u8], pos: &mut usize) -> u32 {
    let mut r = 0u32; let mut shift = 0;
    while *pos < bc.len() {
        let b = bc[*pos] as u32; *pos += 1;
        r |= (b & 0x7F) << shift; shift += 7;
        if b & 0x80 == 0 { break; }
    }
    r
}

fn read_s24_at(bc: &[u8], pos: &mut usize) -> i32 {
    if *pos + 3 > bc.len() { *pos = bc.len(); return 0; }
    let v = (bc[*pos] as i32) | ((bc[*pos+1] as i32) << 8) | ((bc[*pos+2] as i32) << 16);
    *pos += 3;
    if v & 0x800000 != 0 { v | -0x1000000 } else { v }
}

// ─── Pass 1: build basic blocks ───────────────────────────────────────────────

#[derive(Debug, Clone)]
struct Block {
    start: usize,
    end: usize,       // exclusive byte offset
    term: Terminator,
}

#[derive(Debug, Clone)]
enum Terminator {
    Return,
    Jump(usize),      // absolute target offset
    Branch { cond_inv: bool, target: usize, fallthrough: usize },
    // branch with two-value compare (pops 2 from stack)
    BranchCmp { op: &'static str, target: usize, fallthrough: usize },
    Throw,
    Fall(usize),      // just falls to next instruction
}

fn build_blocks(bc: &[u8]) -> Vec<Block> {
    // Collect all block-start offsets
    let mut starts: BTreeSet<usize> = BTreeSet::new();
    starts.insert(0);

    let mut pos = 0;
    while pos < bc.len() {
        let op = bc[pos];
        let sz = instr_size(bc, pos);
        match op {
            OP_JUMP | OP_IFTRUE | OP_IFFALSE | OP_IFEQ | OP_IFNE | OP_IFLT | OP_IFLE | OP_IFGT | OP_IFGE | OP_IFSTRICTEQ | OP_IFSTRICTNE => {
                let mut p = pos + 1;
                let offset = read_s24_at(bc, &mut p);
                let after_branch = pos + sz;
                let target = (after_branch as i64 + offset as i64) as usize;
                starts.insert(after_branch);
                if target < bc.len() { starts.insert(target); }
            }
            OP_RETURNVOID | OP_RETURNVALUE | OP_THROW => {
                starts.insert(pos + sz);
            }
            _ => {}
        }
        pos += sz;
    }

    // Build blocks
    let starts_vec: Vec<usize> = starts.into_iter().collect();
    let mut blocks = Vec::new();

    for (idx, &bstart) in starts_vec.iter().enumerate() {
        if bstart >= bc.len() { break; }
        let bend = starts_vec.get(idx + 1).copied().unwrap_or(bc.len()).min(bc.len());

        // Find terminator of this block (last instruction)
        let mut term = Terminator::Fall(bend);
        let mut p = bstart;
        while p < bend {
            let op = bc[p];
            let sz = instr_size(bc, p);
            let next = p + sz;
            match op {
                OP_RETURNVOID | OP_RETURNVALUE => { term = Terminator::Return; }
                OP_THROW => { term = Terminator::Throw; }
                OP_JUMP => {
                    let mut q = p + 1;
                    let off = read_s24_at(bc, &mut q);
                    let target = (next as i64 + off as i64) as usize;
                    term = Terminator::Jump(target);
                }
                OP_IFTRUE => {
                    let mut q = p + 1;
                    let off = read_s24_at(bc, &mut q);
                    let target = (next as i64 + off as i64) as usize;
                    term = Terminator::Branch { cond_inv: false, target, fallthrough: next };
                }
                OP_IFFALSE => {
                    let mut q = p + 1;
                    let off = read_s24_at(bc, &mut q);
                    let target = (next as i64 + off as i64) as usize;
                    term = Terminator::Branch { cond_inv: true, target, fallthrough: next };
                }
                OP_IFEQ | OP_IFSTRICTEQ => {
                    let mut q = p + 1; let off = read_s24_at(bc, &mut q);
                    let target = (next as i64 + off as i64) as usize;
                    term = Terminator::BranchCmp { op: "==", target, fallthrough: next };
                }
                OP_IFNE | OP_IFSTRICTNE => {
                    let mut q = p + 1; let off = read_s24_at(bc, &mut q);
                    let target = (next as i64 + off as i64) as usize;
                    term = Terminator::BranchCmp { op: "!=", target, fallthrough: next };
                }
                OP_IFLT => {
                    let mut q = p + 1; let off = read_s24_at(bc, &mut q);
                    let target = (next as i64 + off as i64) as usize;
                    term = Terminator::BranchCmp { op: "<", target, fallthrough: next };
                }
                OP_IFLE => {
                    let mut q = p + 1; let off = read_s24_at(bc, &mut q);
                    let target = (next as i64 + off as i64) as usize;
                    term = Terminator::BranchCmp { op: "<=", target, fallthrough: next };
                }
                OP_IFGT => {
                    let mut q = p + 1; let off = read_s24_at(bc, &mut q);
                    let target = (next as i64 + off as i64) as usize;
                    term = Terminator::BranchCmp { op: ">", target, fallthrough: next };
                }
                OP_IFGE => {
                    let mut q = p + 1; let off = read_s24_at(bc, &mut q);
                    let target = (next as i64 + off as i64) as usize;
                    term = Terminator::BranchCmp { op: ">=", target, fallthrough: next };
                }
                _ => {}
            }
            p = next;
        }

        blocks.push(Block { start: bstart, end: bend, term });
    }

    blocks
}

// ─── Pass 2: decode each block to a list of Stmts + a final Expr for branches ─

struct BlockDecoder<'a> {
    bc: &'a [u8],
    abc: &'a AbcFile,
    stack: Vec<Expr>,
    stmts: Vec<Stmt>,
    locals: BTreeMap<u32, Option<Expr>>,
    activation_slots: BTreeMap<u32, String>,
    param_locals: BTreeMap<u32, String>,
    has_activation: bool,
}

impl<'a> BlockDecoder<'a> {
    fn new(bc: &'a [u8], abc: &'a AbcFile) -> Self {
        let mut locals = BTreeMap::new();
        locals.insert(0, Some(Expr::This));
        Self { bc, abc, stack: Vec::new(), stmts: Vec::new(), locals,
               activation_slots: BTreeMap::new(), param_locals: BTreeMap::new(),
               has_activation: false }
    }

    fn pop(&mut self) -> Expr {
        self.stack.pop().unwrap_or(Expr::Unknown)
    }

    /// After a unary branch (iftrue/iffalse), if the previous instruction was dup,
    /// there may be an identical residue on the stack — pop it.
    fn clear_dup_residue(&mut self) {
        // If top of stack is the same expression as the one we just branched on,
        // it's a dup artifact. Pop it silently.
        // We detect by checking if top == second-from-top before we popped.
        // Simpler heuristic: if next instr is pop, let pop handle it.
        // For now, just flush obviously duplicated expressions.
    }

    fn string(&self, idx: u32) -> String {
        self.abc.strings.get(idx as usize).cloned().unwrap_or_default()
    }

    fn multiname(&self, idx: u32) -> String {
        self.abc.multinames.get(idx as usize).map(|m| m.name.clone()).unwrap_or_default()
    }

    fn get_local(&self, n: u32) -> Expr {
        if n == 0 { return Expr::This; }
        // Check if it's a named param
        if let Some(name) = self.param_locals.get(&n) {
            return Expr::GetLex(name.clone());
        }
        self.locals.get(&n).and_then(|v| v.clone()).unwrap_or(Expr::Local(n))
    }

    fn set_local(&mut self, n: u32, v: Expr) {
        // Skip activation object assignments (newactivation, dup, setlocal N pattern)
        if matches!(&v, Expr::GetLex(s) if s == "_act") { return; }
        self.locals.insert(n, Some(v.clone()));
        self.stmts.push(Stmt::VarDecl(n, v));
    }

    fn decode_range(&mut self, start: usize, end: usize) -> Option<Expr> {
        let mut pos = start;
        while pos < end && pos < self.bc.len() {
            let op = self.bc[pos];
            pos += 1;
            match op {
                OP_NOP | OP_LABEL | OP_GETGLOBALSCOPE => {}
                OP_PUSHSCOPE => { self.stack.pop(); }
                OP_NEWACTIVATION => {
                    // Creates a closure activation object for capturing variables.
                    // We push a sentinel so subsequent dup/pushscope work correctly.
                    self.has_activation = true;
                    self.stack.push(Expr::GetLex("_act".into()));
                }
                OP_DEBUGLINE | OP_DEBUGFILE | OP_BKPTLINE => { read_u30_at(self.bc, &mut pos); }
                OP_DEBUG => {
                    pos += 1; // first byte
                    read_u30_at(self.bc, &mut pos);
                    read_u30_at(self.bc, &mut pos);
                    read_u30_at(self.bc, &mut pos);
                }
                OP_GETSCOPEOBJECT => {
                    let n = self.bc[pos]; pos += 1;
                    // When we have an activation, getscopeobject 1 = the activation record
                    // We don't push it explicitly — setslot/getslot will be resolved by name
                    // Push _act as a transparent marker that setslot/getslot will consume
                    if self.has_activation && n >= 1 {
                        self.stack.push(Expr::GetLex("_act".into()));
                    } else {
                        self.stack.push(Expr::This); // scope 0 = global/this
                    }
                }
                OP_GETOUTERSCOPE | OP_NEWCATCH => { pos += 1; self.stack.push(Expr::Unknown); }
                OP_KILL => { let _n = pos; pos += 1; }

                OP_PUSHSTRING => { let idx = read_u30_at(self.bc, &mut pos); self.stack.push(Expr::Str(self.string(idx))); }
                OP_PUSHDOUBLE => { let idx = read_u30_at(self.bc, &mut pos); let v = self.abc.doubles.get(idx as usize).copied().unwrap_or(0.0); self.stack.push(Expr::Num(v)); }
                OP_PUSHBYTE   => { let v = self.bc[pos] as i8 as f64; pos += 1; self.stack.push(Expr::Num(v)); }
                OP_PUSHSHORT  => { let v = read_u30_at(self.bc, &mut pos) as i16 as f64; self.stack.push(Expr::Num(v)); }
                OP_PUSHINT    => { let idx = read_u30_at(self.bc, &mut pos); let v = self.abc.ints.get(idx as usize).copied().unwrap_or(0) as f64; self.stack.push(Expr::Num(v)); }
                OP_PUSHUINT   => { let idx = read_u30_at(self.bc, &mut pos); let v = self.abc.uints.get(idx as usize).copied().unwrap_or(0) as f64; self.stack.push(Expr::Num(v)); }
                OP_PUSHTRUE   => self.stack.push(Expr::Bool(true)),
                OP_PUSHFALSE  => self.stack.push(Expr::Bool(false)),
                OP_PUSHNULL | OP_PUSHNAN => self.stack.push(Expr::Null),
                0x21 => self.stack.push(Expr::Null), // OP_PUSHUNDEFINED (haXe/tamarin extension)

                OP_GETLEX => { let idx = read_u30_at(self.bc, &mut pos); self.stack.push(Expr::GetLex(self.multiname(idx))); }
                OP_FINDPROPSTRICT | OP_FINDPROP | OP_FINDDEF => {
                    let idx = read_u30_at(self.bc, &mut pos);
                    let name = self.multiname(idx);
                    // findpropstrict pushes the scope object that owns `name`.
                    // For self-methods, that scope object IS self — mark with a special sentinel
                    // so callproperty on it renders as self.name().
                    self.stack.push(Expr::GetProperty(Box::new(Expr::This), name));
                }

                OP_GETLOCAL0 => self.stack.push(self.get_local(0)),
                OP_GETLOCAL1 => self.stack.push(self.get_local(1)),
                OP_GETLOCAL2 => self.stack.push(self.get_local(2)),
                OP_GETLOCAL3 => self.stack.push(self.get_local(3)),
                OP_GETLOCAL  => { let n = read_u30_at(self.bc, &mut pos); self.stack.push(self.get_local(n)); }

                OP_SETLOCAL0 => { let v = self.pop(); self.set_local(0, v); }
                OP_SETLOCAL1 => { let v = self.pop(); self.set_local(1, v); }
                OP_SETLOCAL2 => { let v = self.pop(); self.set_local(2, v); }
                OP_SETLOCAL3 => { let v = self.pop(); self.set_local(3, v); }
                OP_SETLOCAL  => { let n = read_u30_at(self.bc, &mut pos); let v = self.pop(); self.set_local(n, v); }

                OP_INCLOCAL | OP_INCLOCAL_I => { let n = read_u30_at(self.bc, &mut pos); let cur = self.get_local(n); self.stmts.push(Stmt::VarDecl(n, Expr::BinOp("+", Box::new(cur), Box::new(Expr::Num(1.0))))); }
                OP_DECLOCAL | OP_DECLOCAL_I => { let n = read_u30_at(self.bc, &mut pos); let cur = self.get_local(n); self.stmts.push(Stmt::VarDecl(n, Expr::BinOp("-", Box::new(cur), Box::new(Expr::Num(1.0))))); }

                OP_GETPROPERTY => {
                    let idx = read_u30_at(self.bc, &mut pos);
                    let name = self.multiname(idx);
                    let obj = self.pop();
                    if name.is_empty() {
                        // MultinameL (runtime name): stack before = [..., receiver, name]
                        // We popped name first (obj=name above), now pop receiver.
                        let receiver = self.pop();
                        // Emit as receiver[name]
                        self.stack.push(Expr::Call(
                            Box::new(receiver),
                            "[".into(),
                            vec![obj]  // obj is actually the index/name here
                        ));
                    } else {
                        self.stack.push(Expr::GetProperty(Box::new(obj), name));
                    }
                }
                OP_SETPROPERTY | OP_INITPROPERTY => {
                    let idx = read_u30_at(self.bc, &mut pos);
                    let name = self.multiname(idx);
                    let val = self.pop(); let obj = self.pop();
                    self.stmts.push(Stmt::SetProp(obj, name, val));
                }
                OP_DELETEPROPERTY => { read_u30_at(self.bc, &mut pos); self.pop(); self.stack.push(Expr::Bool(true)); }
                OP_GETSLOT => {
                    let slot = read_u30_at(self.bc, &mut pos);
                    let obj = self.pop();
                    // If reading from activation object, map to named variable
                    let slot_name = self.activation_slots.get(&slot)
                        .cloned()
                        .unwrap_or_else(|| format!("_s{}", slot));
                    let is_act = matches!(&obj, Expr::GetLex(n) if n == "_act");
                    if is_act {
                        self.stack.push(Expr::GetLex(slot_name));
                    } else {
                        self.stack.push(Expr::GetProperty(Box::new(obj), slot_name));
                    }
                }
                OP_SETSLOT => {
                    let slot = read_u30_at(self.bc, &mut pos);
                    let val = self.pop();
                    let obj = self.pop();
                    let slot_name = self.activation_slots.get(&slot)
                        .cloned()
                        .unwrap_or_else(|| format!("_s{}", slot));
                    let is_act = matches!(&obj, Expr::GetLex(n) if n == "_act")
                        || matches!(&obj, Expr::This);
                    if is_act {
                        let is_trivial = matches!(&val, Expr::Null)
                            || matches!(&val, Expr::GetLex(n) if n == "_act" || n.starts_with("_scope"))
                            // skip "var x = x" (param captured into same-named slot)
                            || matches!(&val, Expr::GetLex(vn) if *vn == slot_name);
                        if !is_trivial {
                            self.stmts.push(Stmt::NamedAssign(slot_name.clone(), val));
                        }
                        self.activation_slots.insert(slot, slot_name);
                    } else {
                        self.stmts.push(Stmt::SetProp(obj, slot_name, val));
                    }
                }

                OP_CALLPROPERTY | OP_CALLPROPLEX => {
                    let mn_idx = read_u30_at(self.bc, &mut pos);
                    let argc = read_u30_at(self.bc, &mut pos) as usize;
                    let name = self.multiname(mn_idx);
                    let mut args: Vec<Expr> = (0..argc).map(|_| self.pop()).collect();
                    args.reverse();
                    let obj = self.pop();
                    // Collapse findpropstrict + callproperty with same name → self.name()
                    let obj = collapse_findprop(obj, &name);
                    self.stack.push(Expr::Call(Box::new(obj), name, args));
                }
                OP_CALLPROPVOID => {
                    let mn_idx = read_u30_at(self.bc, &mut pos);
                    let argc = read_u30_at(self.bc, &mut pos) as usize;
                    let name = self.multiname(mn_idx);
                    let mut args: Vec<Expr> = (0..argc).map(|_| self.pop()).collect();
                    args.reverse();
                    let obj = self.pop();
                    let obj = collapse_findprop(obj, &name);
                    let call = Expr::Call(Box::new(obj), name, args);
                    self.stmts.push(Stmt::Expr(call));
                }
                OP_CALL => {
                    let _mn_idx = read_u30_at(self.bc, &mut pos); // always 0 for generic call
                    let argc = read_u30_at(self.bc, &mut pos) as usize;
                    let mut args: Vec<Expr> = (0..argc).map(|_| self.pop()).collect();
                    args.reverse();
                    let _recv = self.pop();
                    let func = self.pop();
                    self.stack.push(Expr::Call(Box::new(func), "".into(), args));
                }
                OP_CALLMETHOD | OP_CALLSTATIC => {
                    let _idx = read_u30_at(self.bc, &mut pos);
                    let argc = read_u30_at(self.bc, &mut pos) as usize;
                    let mut args: Vec<Expr> = (0..argc).map(|_| self.pop()).collect();
                    args.reverse();
                    let obj = self.pop();
                    self.stack.push(Expr::Call(Box::new(obj), "/* method */".into(), args));
                }
                OP_CALLSUPER => {
                    let mn_idx = read_u30_at(self.bc, &mut pos);
                    let argc = read_u30_at(self.bc, &mut pos) as usize;
                    let name = self.multiname(mn_idx);
                    let mut args: Vec<Expr> = (0..argc).map(|_| self.pop()).collect();
                    args.reverse();
                    self.pop(); // receiver
                    self.stmts.push(Stmt::Expr(Expr::Call(Box::new(Expr::GetLex("super".into())), name, args)));
                }
                OP_CONSTRUCTPROP => {
                    let mn_idx = read_u30_at(self.bc, &mut pos);
                    let argc = read_u30_at(self.bc, &mut pos) as usize;
                    let name = self.multiname(mn_idx);
                    let mut args: Vec<Expr> = (0..argc).map(|_| self.pop()).collect();
                    args.reverse();
                    self.pop();
                    self.stack.push(Expr::New(name, args));
                }
                OP_CONSTRUCT => {
                    let argc = read_u30_at(self.bc, &mut pos) as usize;
                    let mut args: Vec<Expr> = (0..argc).map(|_| self.pop()).collect();
                    args.reverse();
                    let cls = self.pop();
                    self.stack.push(Expr::Call(Box::new(cls), "new".into(), args));
                }
                OP_CONSTRUCTSUPER => {
                    let argc = read_u30_at(self.bc, &mut pos) as usize;
                    let mut args: Vec<Expr> = (0..argc).map(|_| self.pop()).collect();
                    args.reverse();
                    self.pop();
                    self.stmts.push(Stmt::Comment(format!("super({})", args.iter().map(|a| a.render()).collect::<Vec<_>>().join(", "))));
                }

                OP_NEWOBJECT => {
                    let count = read_u30_at(self.bc, &mut pos) as usize;
                    let mut pairs = Vec::new();
                    let mut items: Vec<Expr> = (0..count*2).map(|_| self.pop()).collect();
                    items.reverse();
                    for chunk in items.chunks(2) {
                        if let (Expr::Str(k), v) = (&chunk[0], chunk[1].clone()) {
                            pairs.push((k.clone(), v));
                        }
                    }
                    self.stack.push(Expr::Object(pairs));
                }
                OP_NEWARRAY => {
                    let count = read_u30_at(self.bc, &mut pos) as usize;
                    let mut items: Vec<Expr> = (0..count).map(|_| self.pop()).collect();
                    items.reverse();
                    self.stack.push(Expr::Array(items));
                }
                OP_NEWFUNCTION => {
                    let fn_idx = read_u30_at(self.bc, &mut pos);
                    // newfunction creates a closure. Emit as a comment reference.
                    self.stack.push(Expr::GetLex(format!("/* closure method_{} */", fn_idx)));
                }
                OP_NEWCLASS    => { read_u30_at(self.bc, &mut pos); self.stack.push(Expr::GetLex("/* class */".into())); }

                OP_COERCE | OP_ASTYPE | OP_ISTYPE => { read_u30_at(self.bc, &mut pos); }
                OP_COERCE_A | OP_COERCE_B | OP_COERCE_I | OP_COERCE_D | OP_COERCE_S | OP_COERCE_U | OP_COERCE_O => {}
                OP_ASTYPELATE  => { self.pop(); self.pop(); self.stack.push(Expr::Unknown); }
                // convert_b is a boolean cast — keep value on stack unchanged
                OP_CONVERT_B => {}
                OP_CONVERT_S | OP_CONVERT_I | OP_CONVERT_U | OP_CONVERT_D | OP_CONVERT_O | OP_CHECKFILTER => {}
                OP_ESC_XELEM | OP_ESC_XATTR => {}
                OP_TYPEOF => { let e = self.pop(); self.stack.push(Expr::Call(Box::new(Expr::GetLex("typeof".into())), "".into(), vec![e])); }

                OP_POP  => {
                    let e = self.pop();
                    // Skip bare variable refs (dup residues) and unknown
                    let skip = matches!(&e, Expr::Unknown | Expr::This | Expr::Null | Expr::Bool(_))
                        || matches!(&e, Expr::GetLex(_) | Expr::GetProperty(_, _) | Expr::Local(_));
                    if !skip { self.stmts.push(Stmt::Expr(e)); }
                }
                OP_DUP  => {
                    let top = self.stack.last().cloned().unwrap_or(Expr::Unknown);
                    // Peek ahead: if next op is a branch (iftrue/iffalse),
                    // the dup is for the "pop the remaining copy in the other branch" pattern.
                    // We'll push normally; the branch handler pops one copy.
                    // The other copy stays and will be drained or picked up by next block.
                    self.stack.push(top);
                }
                OP_SWAP => { let len = self.stack.len(); if len >= 2 { self.stack.swap(len-1, len-2); } }

                OP_NEGATE | OP_NEGATE_I => { let e = self.pop(); self.stack.push(Expr::UnOp("-", Box::new(e))); }
                OP_NOT => { let e = self.pop(); self.stack.push(Expr::UnOp("!", Box::new(e))); }
                OP_BITNOT => { let e = self.pop(); self.stack.push(Expr::UnOp("~", Box::new(e))); }
                OP_INCREMENT | OP_INCREMENT_I => { let e = self.pop(); self.stack.push(Expr::BinOp("+", Box::new(e), Box::new(Expr::Num(1.0)))); }
                OP_DECREMENT | OP_DECREMENT_I => { let e = self.pop(); self.stack.push(Expr::BinOp("-", Box::new(e), Box::new(Expr::Num(1.0)))); }

                OP_ADD | OP_ADD_I => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp("+", Box::new(l), Box::new(r))); }
                OP_SUBTRACT | OP_SUBTRACT_I => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp("-", Box::new(l), Box::new(r))); }
                OP_MULTIPLY | OP_MULTIPLY_I => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp("*", Box::new(l), Box::new(r))); }
                OP_DIVIDE  => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp("/", Box::new(l), Box::new(r))); }
                OP_MODULO  => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp("%", Box::new(l), Box::new(r))); }
                OP_LSHIFT  => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp("<<", Box::new(l), Box::new(r))); }
                OP_RSHIFT  => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp(">>", Box::new(l), Box::new(r))); }
                OP_URSHIFT => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp(">>>", Box::new(l), Box::new(r))); }
                OP_BITAND  => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp("&", Box::new(l), Box::new(r))); }
                OP_BITOR   => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp("|", Box::new(l), Box::new(r))); }
                OP_BITXOR  => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp("^", Box::new(l), Box::new(r))); }
                OP_EQUALS | OP_STRICTEQUALS => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp("==", Box::new(l), Box::new(r))); }
                OP_LESSTHAN    => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp("<",  Box::new(l), Box::new(r))); }
                OP_LESSEQUALS  => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp("<=", Box::new(l), Box::new(r))); }
                OP_GREATERTHAN => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp(">",  Box::new(l), Box::new(r))); }
                OP_GREATEREQUALS => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp(">=", Box::new(l), Box::new(r))); }
                OP_INSTANCEOF  => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp("instanceof", Box::new(l), Box::new(r))); }
                OP_ISTYPELATE  => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp("is", Box::new(l), Box::new(r))); }
                OP_IN          => { let r = self.pop(); let l = self.pop(); self.stack.push(Expr::BinOp("in", Box::new(l), Box::new(r))); }
                OP_GETDESCENDANTS => { read_u30_at(self.bc, &mut pos); self.pop(); self.stack.push(Expr::Unknown); }
                OP_THROW => { let e = self.pop(); self.stmts.push(Stmt::Comment(format!("throw {}", e.render()))); }
                OP_RETURNVOID  => { self.stmts.push(Stmt::Return(None)); return None; }
                OP_RETURNVALUE => { let v = self.pop(); self.stmts.push(Stmt::Return(Some(v))); return None; }

                // Branch instructions — consume s24 offset and return condition expr
                OP_IFTRUE | OP_IFFALSE | OP_IFEQ | OP_IFNE | OP_IFSTRICTEQ | OP_IFSTRICTNE
                | OP_IFLT | OP_IFLE | OP_IFGT | OP_IFGE => {
                    if pos + 3 <= self.bc.len() { pos += 3; }
                    // Return the RAW condition (not inverted).
                    // The Branch { cond_inv } flag controls the then/else swap in StructuredDecoder.
                    // For iffalse: cond_inv=true means the condition is inverted — we DON'T negate here.
                    let cond = match op {
                        OP_IFTRUE | OP_IFFALSE => { let v = self.pop(); self.clear_dup_residue(); v }
                        OP_IFEQ | OP_IFSTRICTEQ => { let r = self.pop(); let l = self.pop(); Expr::BinOp("==", Box::new(l), Box::new(r)) }
                        OP_IFNE | OP_IFSTRICTNE  => { let r = self.pop(); let l = self.pop(); Expr::BinOp("!=", Box::new(l), Box::new(r)) }
                        OP_IFLT => { let r = self.pop(); let l = self.pop(); Expr::BinOp("<",  Box::new(l), Box::new(r)) }
                        OP_IFLE => { let r = self.pop(); let l = self.pop(); Expr::BinOp("<=", Box::new(l), Box::new(r)) }
                        OP_IFGT => { let r = self.pop(); let l = self.pop(); Expr::BinOp(">",  Box::new(l), Box::new(r)) }
                        OP_IFGE => { let r = self.pop(); let l = self.pop(); Expr::BinOp(">=", Box::new(l), Box::new(r)) }
                        _ => Expr::Unknown,
                    };
                    return Some(cond);
                }
                OP_JUMP => { if pos + 3 <= self.bc.len() { pos += 3; } return None; }

                _ => {
                    // unknown — try to skip operands using instr_size
                    // (pos already advanced by 1 above)
                }
            }
            if self.stack.len() > 64 { self.stack.drain(0..32); }
        }
        // Don't drain — carry propagates via out_carry in decode_from_with_stack_out
        None
    }
}

// ─── Pass 3: structured CFG reconstruction ────────────────────────────────────

struct StructuredDecoder<'a> {
    blocks: Vec<Block>,
    bc: &'a [u8],
    abc: &'a AbcFile,
    visited: BTreeSet<usize>,
    activation_slots: BTreeMap<u32, String>,
    param_locals: BTreeMap<u32, String>, // local_idx -> param name
}

impl<'a> StructuredDecoder<'a> {
    fn new(bc: &'a [u8], abc: &'a AbcFile) -> Self {
        let blocks = build_blocks(bc);
        Self { blocks, bc, abc, visited: BTreeSet::new(),
               activation_slots: BTreeMap::new(), param_locals: BTreeMap::new() }
    }
    fn new_with_slots(bc: &'a [u8], abc: &'a AbcFile, slots: BTreeMap<u32, String>) -> Self {
        let blocks = build_blocks(bc);
        Self { blocks, bc, abc, visited: BTreeSet::new(),
               activation_slots: slots, param_locals: BTreeMap::new() }
    }

    fn block_at(&self, offset: usize) -> Option<&Block> {
        self.blocks.iter().find(|b| b.start == offset)
    }

    fn decode_from(&mut self, start: usize, stop_at: Option<usize>) -> Vec<Stmt> {
        self.decode_from_with_stack(start, stop_at, Vec::new())
    }

    fn decode_from_with_stack(&mut self, start: usize, stop_at: Option<usize>, initial_stack: Vec<Expr>) -> Vec<Stmt> {
        self.decode_from_with_stack_out(start, stop_at, initial_stack, &mut vec![])
    }

    fn decode_from_with_stack_out(
        &mut self, start: usize, stop_at: Option<usize>,
        initial_stack: Vec<Expr>, out_carry: &mut Vec<Expr>
    ) -> Vec<Stmt> {
        let mut result = Vec::new();
        let mut cur = start;
        let mut carry_stack: Vec<Expr> = initial_stack;

        loop {
            if Some(cur) == stop_at { break; }
            if self.visited.contains(&cur) { break; }
            if cur >= self.bc.len() { break; }

            let block = match self.block_at(cur) {
                Some(b) => b.clone(),
                None => break,
            };

            self.visited.insert(cur);

            // Decode the block body
            let mut dec = BlockDecoder::new(self.bc, self.abc);
            dec.activation_slots = self.activation_slots.clone();
            dec.param_locals = self.param_locals.clone();
            dec.has_activation = !dec.activation_slots.is_empty();
            // Pre-seed stack from previous block (for dup-across-blocks patterns)
            dec.stack = carry_stack.drain(..).collect();
            let cond_expr = dec.decode_range(block.start, block.end);
            let mut stmts = dec.stmts;
            // Save leftover stack for next block (Fall/Jump only)
            carry_stack = dec.stack.clone();
            for (k, v) in dec.activation_slots { self.activation_slots.insert(k, v); }

            match &block.term {
                Terminator::Return | Terminator::Throw => {
                    result.extend(stmts);
                    break;
                }
                Terminator::Fall(next) | Terminator::Jump(next) => {
                    let next = *next;
                    result.extend(stmts);
                    // carry_stack propagates naturally for fall-through/jump
                    cur = next;
                }
                Terminator::Branch { cond_inv, target, fallthrough } => {
                    let target = *target;
                    let fallthrough = *fallthrough;
                    let inv = *cond_inv;

                    let raw_cond = cond_expr.unwrap_or_else(|| dec.stack.pop().unwrap_or(Expr::Unknown));
                    // If cond_inv, the branch fires when condition is FALSE
                    // Standard AVM2: iftrue → branch if true; iffalse → branch if false
                    // Our Block stores: iftrue → Branch { cond_inv: false, target }
                    //                   iffalse → Branch { cond_inv: true, target }
                    // "target" fires when condition holds (after possibly inverting)
                    // fallthrough = else branch

                    // Detect backward jump (while loop): target < block.start
                    if target < block.start {
                        // Back-edge: the condition block (this block) is at the BOTTOM of the loop.
                        // target = loop body start; fallthrough = after-loop
                        result.extend(stmts);
                        let body = self.decode_from(target, Some(block.start));
                        let cond = if inv { Expr::UnOp("!", Box::new(raw_cond)) } else { raw_cond };
                        result.push(Stmt::While(cond, body));
                        cur = fallthrough;
                    } else {
                        // Forward branch: if/else
                        // iftrue X: if cond, jump to X (then-block = X, else = fallthrough)
                        // iffalse X: if !cond, jump to X (then-block = fallthrough, else = X)
                        result.extend(stmts);

                        // Find the merge point (where both branches rejoin)
                        // Simple heuristic: the merge point is the minimum of:
                        //   - the next block after the target (if target ends with Jump)
                        //   - the next block after the fallthrough
                        let (then_start, else_start) = if inv {
                            // iffalse: cond false → jump to target (else); true → fallthrough (then)
                            (fallthrough, target)
                        } else {
                            // iftrue: cond true → target (then); false → fallthrough (else)
                            (target, fallthrough)
                        };

                        let merge = self.find_merge(then_start, else_start);

                        let saved_carry = carry_stack.clone();
                        carry_stack.clear();

                        // Capture carry from then_b to propagate to merge block
                        let mut then_leftover = vec![];
                        let then_b = self.decode_from_with_stack_out(then_start, merge, saved_carry, &mut then_leftover);
                        let else_b = if else_start != merge.unwrap_or(usize::MAX) {
                            self.decode_from_with_stack(else_start, merge, vec![])
                        } else {
                            vec![]
                        };
                        result.push(Stmt::If(raw_cond, then_b, else_b));
                        // Propagate carry from then_b to merge block
                        carry_stack = then_leftover;
                        cur = merge.unwrap_or(usize::MAX);
                    }
                }
                Terminator::BranchCmp { op, target, fallthrough } => {
                    let target = *target;
                    let fallthrough = *fallthrough;
                    let cond = cond_expr.unwrap_or_else(|| {
                        let r = dec.stack.pop().unwrap_or(Expr::Unknown);
                        let l = dec.stack.pop().unwrap_or(Expr::Unknown);
                        Expr::BinOp(op, Box::new(l), Box::new(r))
                    });

                    result.extend(stmts);

                    if target < block.start {
                        // Back edge: while loop. Body = from target to this block.
                        let body = self.decode_from(target, Some(block.start));
                        result.push(Stmt::While(cond, body));
                        cur = fallthrough;
                    } else {
                        let merge = self.find_merge(target, fallthrough);
                        let then_b = self.decode_from(target, merge);
                        let else_b = if fallthrough != merge.unwrap_or(usize::MAX) {
                            self.decode_from(fallthrough, merge)
                        } else { vec![] };
                        result.push(Stmt::If(cond, then_b, else_b));
                        cur = merge.unwrap_or(usize::MAX);
                    }
                }
            }
        }
        *out_carry = carry_stack;
        result
    }

    /// Find the merge point after an if/else.
    /// Detect short-circuit && pattern:
    ///   then_block = a Fall-only block that ends by falling into else_start
    ///   else_start  = a Branch block (the second condition check)
    /// If detected, returns (combined_and_cond, inner_then_start, inner_merge)
    fn try_collapse_and(
        &mut self,
        then_start: usize,
        else_start: usize,
        first_cond: Expr,
        initial_stack: &[Expr],
    ) -> Option<(Expr, usize, Option<usize>)> {
        // then_start block must be a Fall that exits to else_start
        let then_block = self.block_at(then_start)?.clone();
        if !matches!(then_block.term, Terminator::Fall(n) if n == else_start) {
            return None;
        }
        // else_start must be a Branch or BranchCmp
        let else_block = self.block_at(else_start)?.clone();
        // For && collapse: the "inner_then" is the continuation AFTER the second check.
        // We process from fallthrough of the else_block so the condition block is included.
        // inner_start = fallthrough of else_block (where condition was not taken)
        // which falls into the merge where the final condition is consumed.
        let inner_start = match &else_block.term {
            Terminator::Branch { fallthrough, .. } => *fallthrough,
            Terminator::BranchCmp { fallthrough, .. } => *fallthrough,
            _ => return None,
        };
        // inner_then: start of the body to decode (the fallthrough of else_block,
        // which computes the final condition and falls into the merge point)
        // inner_else: the skip target (where we jump if condition is false)
        let (inner_then, inner_else) = match &else_block.term {
            Terminator::Branch { cond_inv, target, fallthrough } => {
                // Use fallthrough as start so blocks between else_block and merge are processed
                (*fallthrough, *target)
            }
            Terminator::BranchCmp { target, fallthrough, .. } => (*fallthrough, *target),
            _ => return None,
        };

        // The glue block must start with OP_POP (consuming the dup residue).
        // This is the hallmark of the AS3 short-circuit && pattern.
        // Without it, we could spuriously collapse unrelated if-chains.
        if then_block.start < self.bc.len() && self.bc[then_block.start] != OP_POP {
            return None;
        }

        // Decode the glue block (then_start..else_start) to extract the second condition
        let mut dec = BlockDecoder::new(self.bc, self.abc);
        dec.activation_slots = self.activation_slots.clone();
        dec.param_locals = self.param_locals.clone();
        dec.has_activation = !dec.activation_slots.is_empty();
        dec.stack = initial_stack.to_vec();
        let _cond2_opt = dec.decode_range(then_start, else_start);
        // After glue block, dec.stack has the value that the else_block will branch on
        // (e.g., hasEventListener result)

        // Also decode the else_start block to get its condition expression
        let mut dec2 = BlockDecoder::new(self.bc, self.abc);
        dec2.activation_slots = self.activation_slots.clone();
        dec2.param_locals = self.param_locals.clone();
        dec2.has_activation = !dec2.activation_slots.is_empty();
        dec2.stack = dec.stack.clone();
        let cond3_opt = dec2.decode_range(else_start, else_block.end);

        let second_cond = cond3_opt
            .or_else(|| dec2.stack.last().cloned())
            .unwrap_or(Expr::Unknown);

        if matches!(second_cond, Expr::Unknown) {
            return None;
        }

        // Decode the fallthrough-of-else_block (inner_then) to get the OR alternative condition
        // inner_then is the path taken when second_cond is false
        // inner_then computes the fallback condition (e.g., arg0 != null)
        let alt_cond = if inner_then != inner_else {
            let mut dec3 = BlockDecoder::new(self.bc, self.abc);
            dec3.activation_slots = self.activation_slots.clone();
            dec3.param_locals = self.param_locals.clone();
            dec3.has_activation = !dec3.activation_slots.is_empty();
            // inner_then block has a residue pop of the dup from else_block;
            // seed the stack with a dummy so pop consumes it cleanly
            dec3.stack = vec![Expr::Null]; // dup residue placeholder
            let _r = dec3.decode_range(inner_then, inner_then + 16.min(self.bc.len() - inner_then));
            // Find the last expression computed
            dec3.stack.last().cloned()
        } else { None };

        // Build the combined condition:
        // (first_cond && second_cond) || alt_cond
        let first_and_second = Expr::BinOp("&&", Box::new(first_cond), Box::new(second_cond));
        let combined = if let Some(alt) = alt_cond {
            if !matches!(alt, Expr::Unknown | Expr::Null) {
                Expr::BinOp("||", Box::new(first_and_second), Box::new(alt))
            } else {
                Expr::BinOp("&&", Box::new(Expr::BinOp("&&".into(), Box::new(Expr::Null), Box::new(Expr::Null))), Box::new(Expr::Null)) // fallback
            }
        } else {
            first_and_second
        };

        // The body is at the merge of inner_then and inner_else
        // Find where both paths converge (the final branch block's merge)
        // Use inner_else's successor as the body start (where the final condition is checked)
        let body_merge = self.find_merge_inner(inner_then, inner_else);

        // Mark all consumed blocks as visited
        self.visited.insert(then_start);
        self.visited.insert(else_start);
        self.visited.insert(inner_then); // fallthrough of else_block

        Some((combined, inner_else, body_merge))
    }

    fn find_merge(&self, then_start: usize, else_start: usize) -> Option<usize> {
        self.find_merge_inner(then_start, else_start)
    }
    fn find_merge_inner(&self, then_start: usize, else_start: usize) -> Option<usize> {
        // Walk the then-branch chain to find where it exits
        let then_final_exit = self.chain_exit(then_start, else_start);
        let else_final_exit = self.chain_exit(else_start, then_start);

        match (then_final_exit, else_final_exit) {
            (Some(a), Some(b)) if a == b => Some(a),
            (Some(a), None) => Some(a),
            (None, Some(b)) => Some(b),
            // then-chain exits to else_start means else block is the continuation (not a branch)
            _ => {
                if else_start > then_start { Some(else_start) } else { None }
            }
        }
    }

    /// Walk a straight Fall/Jump chain and return the first offset that exits the chain.
    /// Stops (returning None) at backward branches (loops) or Return.
    /// For forward branches, returns the fallthrough (merge approximation without recursion).
    fn chain_exit(&self, start: usize, exclude: usize) -> Option<usize> {
        let mut cur = start;
        for _ in 0..16 {
            if cur == exclude { return Some(cur); }
            let block = match self.block_at(cur) { Some(b) => b, None => return None };
            match &block.term {
                Terminator::Fall(next) | Terminator::Jump(next) => {
                    let next = *next;
                    if next == exclude { return Some(next); }
                    cur = next;
                }
                Terminator::Return | Terminator::Throw => return None,
                // For branches, return the fallthrough as a conservative merge approximation
                // (avoids infinite recursion through loops)
                Terminator::Branch { fallthrough, .. } |
                Terminator::BranchCmp { fallthrough, .. } => return Some(*fallthrough),
            }
        }
        None
    }

    /// Get the first unconditional jump target of a block (its exit).
    fn block_exit_target(&self, start: usize) -> Option<usize> {
        let block = self.block_at(start)?;
        match &block.term {
            Terminator::Jump(t) => Some(*t),
            Terminator::Fall(t) => Some(*t),
            Terminator::Return | Terminator::Throw => None,
            Terminator::Branch { fallthrough, .. } => Some(*fallthrough),
            Terminator::BranchCmp { fallthrough, .. } => Some(*fallthrough),
        }
    }
}

// ─── Public API ───────────────────────────────────────────────────────────────

/// Collapse `findpropstrict 'X' + callproperty 'X'` pattern.
/// findpropstrict pushes `This.X` (a GetProperty sentinel);
/// if callproperty name matches that property, collapse to just `This`.
fn collapse_findprop(obj: Expr, call_name: &str) -> Expr {
    match &obj {
        Expr::GetProperty(inner, prop_name) if prop_name == call_name => {
            // The object was pushed by findpropstrict — the real receiver is the inner object
            *inner.clone()
        }
        _ => obj,
    }
}

/// Pre-scan bytecode to map activation slot indices to parameter names.
/// Pattern: getscopeobject 1 → getlocal_N → setslot M  means slot M = param N.
fn infer_activation_slots(bc: &[u8], params: &[String]) -> BTreeMap<u32, String> {
    let mut slots: BTreeMap<u32, String> = BTreeMap::new();
    let mut i = 0;
    while i < bc.len() {
        let op = bc[i]; i += 1;
        match op {
            // getscopeobject 1, getlocal_N, setslot M → slot M = param N-1
            0x65 if i < bc.len() && bc[i] == 1 => {
                i += 1; // consume the operand
                if i < bc.len() {
                    let next_op = bc[i]; i += 1;
                    let local_n = match next_op {
                        0xD0 => Some(0u32),
                        0xD1 => Some(1),
                        0xD2 => Some(2),
                        0xD3 => Some(3),
                        0x62 => {
                            let n = read_u30_at(bc, &mut i);
                            Some(n)
                        }
                        _ => { i -= 1; None }
                    };
                    if let Some(n) = local_n {
                        if i < bc.len() {
                            let set_op = bc[i]; i += 1;
                            if set_op == 0x6D { // setslot
                                let slot = read_u30_at(bc, &mut i);
                                let name = if n == 0 {
                                    "self".to_string()
                                } else if (n as usize) <= params.len() {
                                    params[n as usize - 1].clone()
                                } else {
                                    format!("_v{}", n)
                                };
                                slots.insert(slot, name);
                            } else {
                                i -= 1;
                            }
                        }
                    }
                }
            }
            _ => { i += instr_size(bc, i - 1) - 1; }
        }
    }
    slots
}

/// Decompile an ABC method body to a Fraymakers Haxe function string.
pub fn decompile_method(
    body: &crate::abc_parser::MethodBody,
    abc: &AbcFile,
    name: &str,
    params: &[String],
) -> String {
    if body.bytecode.is_empty() {
        return format!("function {}({}) {{\n}}\n\n", name, params.join(", "));
    }

    // Pre-scan for activation slot naming
    let activation_slots = infer_activation_slots(&body.bytecode, params);

    let mut decoder = StructuredDecoder::new_with_slots(&body.bytecode, abc, activation_slots);
    // Map param locals: local_0 = this, local_1 = param0, local_2 = param1, etc.
    for (i, param) in params.iter().enumerate() {
        let local_idx = (i + 1) as u32;
        decoder.param_locals.insert(local_idx, param.clone());
    }
    let stmts = decoder.decode_from(0, None);

    // Remove redundant local0 (= this) assignments
    let stmts: Vec<Stmt> = stmts.into_iter().filter(|s| {
        !matches!(s, Stmt::VarDecl(0, Expr::This))
    }).collect();

    let param_str = params.join(", ");
    let mut out = format!("function {}({}) {{\n", name, param_str);
    out.push_str(&render_stmts(&stmts, 1));
    out.push_str("}\n\n");
    out
}
