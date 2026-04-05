/// AVM2 bytecode decompiler for SSF2 character scripts.
///
/// Converts ABC method bodies into readable AS3-like code,
/// then maps SSF2 API calls to Fraymakers equivalents.
///
/// We use a simplified approach: structured expression reconstruction
/// rather than full control flow analysis. Covers the common patterns
/// found in SSF2 character Ext classes.

use anyhow::Result;
use std::collections::BTreeMap;
use crate::abc_parser::{AbcFile, MethodBody};

// ─── SSF2 API → Fraymakers translation table ──────────────────────────────────
//
// Based on SSF2_TO_FRAYMAKERS_API.md in the project.

const API_MAP: &[(&str, &str, &str)] = &[
    // entity movement / physics
    ("getX",              "self.getX()",              ""),
    ("getY",              "self.getY()",              ""),
    ("setX",              "self.setX",                ""),
    ("setY",              "self.setY",                ""),
    ("getXSpeed",         "self.getXVelocity()",      ""),
    ("getYSpeed",         "self.getYVelocity()",      ""),
    ("setXSpeed",         "self.setXVelocity",        ""),
    ("setYSpeed",         "self.setYVelocity",        ""),
    ("getNetXSpeed",      "self.getNetXVelocity()",   ""),
    ("getNetYSpeed",      "self.getNetYVelocity()",   ""),
    ("setXSpeedScaled",   "self.setXVelocityScaled",  ""),
    ("setYSpeedScaled",   "self.setYVelocityScaled",  ""),
    ("faceLeft",          "self.faceLeft()",          ""),
    ("faceRight",         "self.faceRight()",         ""),
    ("flip",              "self.flip()",              ""),
    ("flipX",             "self.flipX",               ""),
    ("isFacingLeft",      "self.isFacingLeft()",      ""),
    ("isFacingRight",     "self.isFacingRight()",     ""),
    ("isOnGround",        "self.isOnFloor()",         ""),
    ("isOnFloor",         "self.isOnFloor()",         ""),
    ("resetMomentum",     "self.resetMomentum()",     ""),
    ("toggleGravity",     "self.toggleGravity",       ""),
    ("getKnockback",      "self.getKnockback()",      ""),
    ("setKnockback",      "self.setKnockback",        ""),
    ("move",              "self.move",                ""),
    ("moveAbsolute",      "self.moveAbsolute",        ""),
    // state
    ("getState",          "self.getState()",          ""),
    ("setState",          "self.setState",            "// use self.toState(CState.X) for full transition"),
    ("toState",           "self.toState",             ""),
    ("inState",           "self.inState",             ""),
    ("inStateGroup",      "self.inStateGroup",        ""),
    ("getPreviousState",  "self.getPreviousState()",  ""),
    // animation
    ("playAnimation",     "self.playAnimation",       ""),
    ("playFrame",         "self.playFrame",           ""),
    ("playFrameLabel",    "self.playFrameLabel",      ""),
    ("getCurrentFrame",   "self.getCurrentFrame()",   ""),
    ("getTotalFrames",    "self.getTotalFrames()",     ""),
    ("finalFramePlayed",  "self.finalFramePlayed()",  ""),
    ("getAnimation",      "self.getAnimation()",      ""),
    ("hasAnimation",      "self.hasAnimation",        ""),
    // timers / events
    ("addTimer",          "self.addTimer",            ""),
    ("removeTimer",       "self.removeTimer",         ""),
    ("addEventListener",  "self.addEventListener",    ""),
    ("removeEventListener","self.removeEventListener",""),
    // combat
    ("getDamage",         "self.getDamage()",         ""),
    ("setDamage",         "self.setDamage",           ""),
    ("addDamage",         "self.addDamage",           ""),
    ("getHitstop",        "self.getHitstop()",        ""),
    ("getHitstun",        "self.getHitstun()",        ""),
    ("startHitstop",      "self.startHitstop",        ""),
    ("startHitstun",      "self.startHitstun",        ""),
    ("refreshAttackID",   "self.reactivateHitboxes()",""),
    ("reactivateHitboxes","self.reactivateHitboxes()",""),
    ("updateAnimationStats","self.updateAnimationStats",""),
    ("updateHitboxStats", "self.updateHitboxStats",   ""),
    ("attemptHit",        "self.attemptHit",          ""),
    ("attemptGrab",       "self.attemptGrab",         ""),
    ("releaseCharacter",  "self.releaseCharacter",    ""),
    ("releaseAllCharacters","self.releaseAllCharacters",""),
    ("getGrabbedFoe",     "self.getGrabbedFoe()",     ""),
    ("getAllGrabbedFoes",  "self.getAllGrabbedFoes()", ""),
    ("getOwner",          "self.getOwner()",          ""),
    // match / game objects
    ("getPlayer",         "match.getCharacter",       "// TODO: adjust player index"),
    ("getPlayers",        "match.getCharacters()",    ""),
    ("getProjectile",     "match.getProjectile",      ""),
    ("getItem",           "match.getItem",            ""),
    ("getStage",          "match.getStage()",         ""),
    ("createProjectile",  "match.createProjectile",   ""),
    // audio
    ("playSound",         "AudioClip.play",           ""),
    ("stopSound",         "AudioClip.stop",           ""),
    // display / layers
    ("getTopLayer",       "self.getTopLayer()",       ""),
    ("getBottomLayer",    "self.getBottomLayer()",    ""),
    ("getViewRootContainer","self.getViewRootContainer()",""),
    ("bringInFront",      "// TODO: self.getTopLayer().addChild", "// SSF2: bringInFront()"),
    ("bringBehind",       "// TODO: self.getBottomLayer().addChild","// SSF2: bringBehind()"),
    // misc
    ("kill",              "self.kill()",              ""),
    ("getScaleX",         "self.getScaleX()",         ""),
    ("getScaleY",         "self.getScaleY()",         ""),
    ("setScaleX",         "self.setScaleX",           ""),
    ("setScaleY",         "self.setScaleY",           ""),
    ("getRotation",       "self.getRotation()",       ""),
    ("setRotation",       "self.setRotation",         ""),
    ("getResource",       "self.getResource()",       ""),
    ("getClosestLedge",   "// TODO: no direct FM equivalent", "// SSF2: getClosestLedge()"),
    ("toFlying",          "// TODO: self.toState(CState.FALL_SPECIAL)", "// SSF2: toFlying()"),
    ("replaceAttackStats","self.updateAnimationStats","// SSF2: replaceAttackStats — apply hitbox changes"),
    ("replaceAttackBoxStats","self.updateHitboxStats","// TODO: replaceAttackBoxStats"),
    ("resetRotation",     "// hitbox deactivated",   "// SSF2: resetRotation()"),
    ("setRotation",       "// SSF2 hitbox frame",    "// setRotation = activate hitbox shape"),
];

fn lookup_api(ssf2_name: &str) -> Option<(&'static str, &'static str)> {
    API_MAP.iter()
        .find(|(name, _, _)| *name == ssf2_name)
        .map(|(_, fm, comment)| (*fm, *comment))
}

// ─── AVM2 opcodes ─────────────────────────────────────────────────────────────

#[derive(Debug, Clone)]
enum Expr {
    Num(f64),
    Str(String),
    Bool(bool),
    Null,
    This,
    Local(u32),
    GetProperty { obj: Box<Expr>, name: String },
    Call { obj: Box<Expr>, method: String, args: Vec<Expr> },
    NewObject(Vec<(String, Expr)>),
    NewArray(Vec<Expr>),
    BinOp { op: &'static str, left: Box<Expr>, right: Box<Expr> },
    UnOp { op: &'static str, expr: Box<Expr> },
    GetLex(String),
    Unknown(String),
}

#[derive(Debug, Clone)]
enum Stmt {
    Assign { local: u32, value: Expr },
    SetProperty { obj: Expr, name: String, value: Expr },
    CallVoid { expr: Expr },
    Return(Option<Expr>),
    If { cond: Expr, then_stmts: Vec<Stmt>, else_stmts: Vec<Stmt> },
    Comment(String),
    Raw(String),
}

/// Decompile a method body to readable Fraymakers Haxe code.
pub fn decompile_method(
    body: &MethodBody,
    abc: &AbcFile,
    method_name: &str,
    params: &[String],
) -> String {
    let stmts = decompile_bytecode(&body.bytecode, abc);
    let translated = translate_stmts(&stmts, abc);
    render_function(method_name, params, &translated)
}

fn render_function(name: &str, params: &[String], stmts: &[Stmt]) -> String {
    let param_str = params.join(", ");
    let mut out = format!("function {}({}) {{\n", name, param_str);
    for stmt in stmts {
        render_stmt(stmt, &mut out, 1);
    }
    out.push_str("}\n");
    out
}

fn indent(level: usize) -> String {
    "\t".repeat(level)
}

fn render_stmt(stmt: &Stmt, out: &mut String, level: usize) {
    let ind = indent(level);
    match stmt {
        Stmt::Comment(c) => out.push_str(&format!("{}// {}\n", ind, c)),
        Stmt::Raw(s)     => out.push_str(&format!("{}{}\n", ind, s)),
        Stmt::Return(None) => out.push_str(&format!("{}return;\n", ind)),
        Stmt::Return(Some(e)) => out.push_str(&format!("{}return {};\n", ind, render_expr(e))),
        Stmt::Assign { local, value } => {
            out.push_str(&format!("{}var local{} = {};\n", ind, local, render_expr(value)));
        }
        Stmt::SetProperty { obj, name, value } => {
            out.push_str(&format!("{}{}.{} = {};\n", ind, render_expr(obj), name, render_expr(value)));
        }
        Stmt::CallVoid { expr } => {
            out.push_str(&format!("{}{};\n", ind, render_expr(expr)));
        }
        Stmt::If { cond, then_stmts, else_stmts } => {
            out.push_str(&format!("{}if ({}) {{\n", ind, render_expr(cond)));
            for s in then_stmts { render_stmt(s, out, level + 1); }
            if !else_stmts.is_empty() {
                out.push_str(&format!("{}}} else {{\n", ind));
                for s in else_stmts { render_stmt(s, out, level + 1); }
            }
            out.push_str(&format!("{}}}\n", ind));
        }
    }
}

fn render_expr(expr: &Expr) -> String {
    match expr {
        Expr::Num(v) => {
            if *v == v.round() && v.abs() < 1_000_000.0 { format!("{}", *v as i64) }
            else { format!("{}", v) }
        }
        Expr::Str(s)    => format!("\"{}\"", s),
        Expr::Bool(b)   => b.to_string(),
        Expr::Null      => "null".to_string(),
        Expr::This      => "self".to_string(),
        Expr::Local(n)  => format!("local{}", n),
        Expr::GetLex(n) => n.clone(),
        Expr::Unknown(s)=> format!("/* {} */", s),
        Expr::GetProperty { obj, name } => format!("{}.{}", render_expr(obj), name),
        Expr::Call { obj, method, args } => {
            let arg_str = args.iter().map(render_expr).collect::<Vec<_>>().join(", ");
            format!("{}.{}({})", render_expr(obj), method, arg_str)
        }
        Expr::BinOp { op, left, right } => {
            format!("{} {} {}", render_expr(left), op, render_expr(right))
        }
        Expr::UnOp { op, expr } => format!("{}{}", op, render_expr(expr)),
        Expr::NewObject(pairs) => {
            if pairs.is_empty() { return "{}".to_string(); }
            let items = pairs.iter()
                .map(|(k, v)| format!("{}: {}", k, render_expr(v)))
                .collect::<Vec<_>>().join(", ");
            format!("{{ {} }}", items)
        }
        Expr::NewArray(items) => {
            let s = items.iter().map(render_expr).collect::<Vec<_>>().join(", ");
            format!("[{}]", s)
        }
    }
}

// ─── Stack-based decompiler ───────────────────────────────────────────────────

const OP_PUSHSTRING:     u8 = 0x2C;
const OP_PUSHINT:        u8 = 0x2D;
const OP_PUSHUINT:       u8 = 0x2E;
const OP_PUSHDOUBLE:     u8 = 0x2F;
const OP_PUSHBYTE:       u8 = 0x24;
const OP_PUSHSHORT:      u8 = 0x25;
const OP_PUSHTRUE:       u8 = 0x26;
const OP_PUSHFALSE:      u8 = 0x27;
const OP_PUSHNULL:       u8 = 0x20;
const OP_PUSHNAN:        u8 = 0x28;
const OP_PUSHSCOPE:      u8 = 0x30;
const OP_NEWOBJECT:      u8 = 0x55;
const OP_NEWARRAY:       u8 = 0x56;
const OP_CALLPROPERTY:   u8 = 0x46;
const OP_CALLPROPVOID:   u8 = 0x4F;
const OP_SETPROPERTY:    u8 = 0x61;
const OP_INITPROPERTY:   u8 = 0x68;
const OP_GETPROPERTY:    u8 = 0x66;
const OP_FINDPROPSTRICT: u8 = 0x5D;
const OP_FINDPROP:       u8 = 0x5C;
const OP_GETLEX:         u8 = 0x60;
const OP_COERCE:         u8 = 0x80;
const OP_COERCE_A:       u8 = 0x82;
const OP_CONVERT_D:      u8 = 0x84;
const OP_CONVERT_I:      u8 = 0x83;
const OP_RETURNVALUE:    u8 = 0x48;
const OP_RETURNVOID:     u8 = 0x47;
const OP_GETLOCAL0:      u8 = 0xD0;
const OP_GETLOCAL1:      u8 = 0xD1;
const OP_GETLOCAL2:      u8 = 0xD2;
const OP_GETLOCAL3:      u8 = 0xD3;
const OP_GETLOCAL:       u8 = 0x62;
const OP_SETLOCAL:       u8 = 0x63;
const OP_SETLOCAL0:      u8 = 0xD4;
const OP_SETLOCAL1:      u8 = 0xD5;
const OP_SETLOCAL2:      u8 = 0xD6;
const OP_SETLOCAL3:      u8 = 0xD7;
const OP_NOP:            u8 = 0x02;
const OP_POP:            u8 = 0x29;
const OP_DUP:            u8 = 0x2A;
const OP_SWAP:           u8 = 0x2B;
const OP_ADD:            u8 = 0xA0;
const OP_SUBTRACT:       u8 = 0xA1;
const OP_MULTIPLY:       u8 = 0xA2;
const OP_DIVIDE:         u8 = 0xA3;
const OP_NEGATE:         u8 = 0x90;
const OP_NOT:            u8 = 0x96;
const OP_EQUALS:         u8 = 0xAB;
const OP_STRICTEQUALS:   u8 = 0xAC;
const OP_LESSTHAN:       u8 = 0xAD;
const OP_GREATERTHAN:    u8 = 0xAF;
const OP_JUMP:           u8 = 0x10;
const OP_IFTRUE:         u8 = 0x11;
const OP_IFFALSE:        u8 = 0x12;
const OP_IFEQ:           u8 = 0x13;
const OP_IFNE:           u8 = 0x14;
const OP_IFLT:           u8 = 0x15;
const OP_IFLE:           u8 = 0x16;
const OP_IFGT:           u8 = 0x17;
const OP_IFGE:           u8 = 0x18;
const OP_IFSTRICTEQ:     u8 = 0x19;
const OP_IFSTRICTNE:     u8 = 0x1A;
const OP_LABEL:          u8 = 0x09;
const OP_CONSTRUCTPROP:  u8 = 0x4A;
const OP_CONSTRUCT:      u8 = 0x42;
const OP_CONSTRUCTSUPER: u8 = 0x49;
const OP_CALLSUPER:      u8 = 0x45;
const OP_GETSCOPEOBJECT: u8 = 0x65;
const OP_KILL:           u8 = 0x08;
const OP_THROW:          u8 = 0x03;
const OP_ISTYPELATE:     u8 = 0xB3;
const OP_INSTANCEOF:     u8 = 0xB1;
const OP_IN:             u8 = 0xB4;

fn read_u30(data: &[u8], i: &mut usize) -> u32 {
    let mut result = 0u32;
    let mut shift = 0;
    loop {
        if *i >= data.len() { break; }
        let b = data[*i] as u32; *i += 1;
        result |= (b & 0x7F) << shift; shift += 7;
        if b & 0x80 == 0 { break; }
    }
    result
}

fn read_s24(data: &[u8], i: &mut usize) -> i32 {
    if *i + 3 > data.len() { *i = data.len(); return 0; }
    let b0 = data[*i] as i32;
    let b1 = data[*i+1] as i32;
    let b2 = data[*i+2] as i32;
    *i += 3;
    let v = b0 | (b1 << 8) | (b2 << 16);
    if v & 0x800000 != 0 { v | (!0xFFFFFF) } else { v }
}

fn decompile_bytecode(bytecode: &[u8], abc: &AbcFile) -> Vec<Stmt> {
    let mut stmts: Vec<Stmt> = Vec::new();
    let mut stack: Vec<Expr> = Vec::new();
    let mut locals: BTreeMap<u32, Expr> = BTreeMap::new();
    let mut i = 0;

    // local 0 = this
    locals.insert(0, Expr::This);

    while i < bytecode.len() {
        let op = bytecode[i]; i += 1;

        match op {
            OP_NOP | OP_LABEL => {}
            OP_PUSHSCOPE => { stack.pop(); }

            OP_GETLOCAL0 => stack.push(locals.get(&0).cloned().unwrap_or(Expr::This)),
            OP_GETLOCAL1 => stack.push(locals.get(&1).cloned().unwrap_or(Expr::Local(1))),
            OP_GETLOCAL2 => stack.push(locals.get(&2).cloned().unwrap_or(Expr::Local(2))),
            OP_GETLOCAL3 => stack.push(locals.get(&3).cloned().unwrap_or(Expr::Local(3))),
            OP_GETLOCAL  => { let n = read_u30(bytecode, &mut i); stack.push(locals.get(&n).cloned().unwrap_or(Expr::Local(n))); }

            OP_SETLOCAL0 => { if let Some(v) = stack.pop() { locals.insert(0, v.clone()); stmts.push(Stmt::Assign { local: 0, value: v }); } }
            OP_SETLOCAL1 => { if let Some(v) = stack.pop() { locals.insert(1, v.clone()); stmts.push(Stmt::Assign { local: 1, value: v }); } }
            OP_SETLOCAL2 => { if let Some(v) = stack.pop() { locals.insert(2, v.clone()); stmts.push(Stmt::Assign { local: 2, value: v }); } }
            OP_SETLOCAL3 => { if let Some(v) = stack.pop() { locals.insert(3, v.clone()); stmts.push(Stmt::Assign { local: 3, value: v }); } }
            OP_SETLOCAL  => {
                let n = read_u30(bytecode, &mut i);
                if let Some(v) = stack.pop() { locals.insert(n, v.clone()); stmts.push(Stmt::Assign { local: n, value: v }); }
            }

            OP_PUSHSTRING => {
                let idx = read_u30(bytecode, &mut i);
                let s = abc.strings.get(idx as usize).cloned().unwrap_or_default();
                stack.push(Expr::Str(s));
            }
            OP_PUSHDOUBLE => {
                let idx = read_u30(bytecode, &mut i);
                let v = abc.doubles.get(idx as usize).copied().unwrap_or(0.0);
                stack.push(Expr::Num(v));
            }
            OP_PUSHBYTE  => {
                if i < bytecode.len() { let v = bytecode[i] as i8 as f64; i += 1; stack.push(Expr::Num(v)); }
            }
            OP_PUSHSHORT => {
                let v = read_u30(bytecode, &mut i) as i16 as f64;
                stack.push(Expr::Num(v));
            }
            OP_PUSHINT   => {
                let idx = read_u30(bytecode, &mut i);
                let v = abc.ints.get(idx as usize).copied().unwrap_or(0) as f64;
                stack.push(Expr::Num(v));
            }
            OP_PUSHUINT  => {
                let idx = read_u30(bytecode, &mut i);
                let v = abc.uints.get(idx as usize).copied().unwrap_or(0) as f64;
                stack.push(Expr::Num(v));
            }
            OP_PUSHTRUE  => stack.push(Expr::Bool(true)),
            OP_PUSHFALSE => stack.push(Expr::Bool(false)),
            OP_PUSHNULL | OP_PUSHNAN => stack.push(Expr::Null),

            OP_GETLEX => {
                let idx = read_u30(bytecode, &mut i);
                let name = abc.multinames.get(idx as usize).map(|m| m.name.clone()).unwrap_or_default();
                stack.push(Expr::GetLex(name));
            }
            OP_FINDPROPSTRICT | OP_FINDPROP => {
                let idx = read_u30(bytecode, &mut i);
                let name = abc.multinames.get(idx as usize).map(|m| m.name.clone()).unwrap_or_default();
                stack.push(Expr::GetLex(name));
            }

            OP_GETPROPERTY => {
                let idx = read_u30(bytecode, &mut i);
                let name = abc.multinames.get(idx as usize).map(|m| m.name.clone()).unwrap_or_default();
                let obj = stack.pop().unwrap_or(Expr::Unknown("?".into()));
                stack.push(Expr::GetProperty { obj: Box::new(obj), name });
            }

            OP_SETPROPERTY | OP_INITPROPERTY => {
                let idx = read_u30(bytecode, &mut i);
                let name = abc.multinames.get(idx as usize).map(|m| m.name.clone()).unwrap_or_default();
                let value = stack.pop().unwrap_or(Expr::Null);
                let obj   = stack.pop().unwrap_or(Expr::This);
                stmts.push(Stmt::SetProperty { obj, name, value });
            }

            OP_CALLPROPERTY | OP_CALLPROPVOID => {
                let idx = read_u30(bytecode, &mut i);
                let argc = read_u30(bytecode, &mut i) as usize;
                let name = abc.multinames.get(idx as usize).map(|m| m.name.clone()).unwrap_or_default();
                let mut args: Vec<Expr> = (0..argc).filter_map(|_| stack.pop()).collect();
                args.reverse();
                let obj = stack.pop().unwrap_or(Expr::This);
                let call = Expr::Call { obj: Box::new(obj), method: name.clone(), args };
                if op == OP_CALLPROPVOID {
                    stmts.push(Stmt::CallVoid { expr: call });
                } else {
                    stack.push(call);
                }
            }

            OP_CONSTRUCTPROP => {
                let idx = read_u30(bytecode, &mut i);
                let argc = read_u30(bytecode, &mut i) as usize;
                let name = abc.multinames.get(idx as usize).map(|m| m.name.clone()).unwrap_or_default();
                let mut args: Vec<Expr> = (0..argc).filter_map(|_| stack.pop()).collect();
                args.reverse();
                let _receiver = stack.pop();
                stack.push(Expr::Call { obj: Box::new(Expr::GetLex(name.clone())), method: format!("new {}", name), args });
            }

            OP_CONSTRUCT => {
                let argc = read_u30(bytecode, &mut i) as usize;
                let mut args: Vec<Expr> = (0..argc).filter_map(|_| stack.pop()).collect();
                args.reverse();
                let ctor = stack.pop().unwrap_or(Expr::Unknown("?".into()));
                stack.push(Expr::Call { obj: Box::new(ctor), method: "new".into(), args });
            }

            OP_CONSTRUCTSUPER => {
                let argc = read_u30(bytecode, &mut i) as usize;
                let mut args: Vec<Expr> = (0..argc).filter_map(|_| stack.pop()).collect();
                args.reverse();
                stack.pop(); // receiver
                stmts.push(Stmt::Raw(format!("super({});", args.iter().map(render_expr).collect::<Vec<_>>().join(", "))));
            }

            OP_CALLSUPER => {
                let idx = read_u30(bytecode, &mut i);
                let argc = read_u30(bytecode, &mut i) as usize;
                let name = abc.multinames.get(idx as usize).map(|m| m.name.clone()).unwrap_or_default();
                let mut args: Vec<Expr> = (0..argc).filter_map(|_| stack.pop()).collect();
                args.reverse();
                stack.pop(); // receiver
                stmts.push(Stmt::Raw(format!("super.{}({});", name, args.iter().map(render_expr).collect::<Vec<_>>().join(", "))));
            }

            OP_NEWOBJECT => {
                let count = read_u30(bytecode, &mut i) as usize;
                let needed = count * 2;
                let mut pairs: Vec<(String, Expr)> = Vec::new();
                let mut items: Vec<Expr> = (0..needed).filter_map(|_| stack.pop()).collect();
                items.reverse();
                for chunk in items.chunks(2) {
                    if let (Expr::Str(k), v) = (&chunk[0], chunk[1].clone()) {
                        pairs.push((k.clone(), v));
                    }
                }
                stack.push(Expr::NewObject(pairs));
            }

            OP_NEWARRAY => {
                let count = read_u30(bytecode, &mut i) as usize;
                let mut items: Vec<Expr> = (0..count).filter_map(|_| stack.pop()).collect();
                items.reverse();
                stack.push(Expr::NewArray(items));
            }

            OP_COERCE | OP_COERCE_A | OP_CONVERT_D | OP_CONVERT_I => {
                if op == OP_COERCE { read_u30(bytecode, &mut i); }
                // coerce is a no-op for our purposes
            }

            OP_POP => { stack.pop(); }
            OP_DUP => { if let Some(top) = stack.last().cloned() { stack.push(top); } }
            OP_SWAP => { let len = stack.len(); if len >= 2 { stack.swap(len-1, len-2); } }

            OP_NEGATE => {
                match stack.pop() {
                    Some(Expr::Num(v)) => stack.push(Expr::Num(-v)),
                    Some(e) => stack.push(Expr::UnOp { op: "-", expr: Box::new(e) }),
                    None => stack.push(Expr::Unknown("-?".into())),
                }
            }
            OP_NOT => {
                match stack.pop() {
                    Some(e) => stack.push(Expr::UnOp { op: "!", expr: Box::new(e) }),
                    None => stack.push(Expr::Unknown("!?".into())),
                }
            }

            OP_ADD | OP_SUBTRACT | OP_MULTIPLY | OP_DIVIDE |
            OP_EQUALS | OP_STRICTEQUALS | OP_LESSTHAN | OP_GREATERTHAN => {
                let op_str = match op {
                    OP_ADD => "+", OP_SUBTRACT => "-", OP_MULTIPLY => "*", OP_DIVIDE => "/",
                    OP_EQUALS => "==", OP_STRICTEQUALS => "===",
                    OP_LESSTHAN => "<", OP_GREATERTHAN => ">",
                    _ => "?",
                };
                let right = stack.pop().unwrap_or(Expr::Unknown("?".into()));
                let left  = stack.pop().unwrap_or(Expr::Unknown("?".into()));
                stack.push(Expr::BinOp { op: op_str, left: Box::new(left), right: Box::new(right) });
            }

            OP_RETURNVOID  => { stmts.push(Stmt::Return(None)); break; }
            OP_RETURNVALUE => {
                let v = stack.pop();
                stmts.push(Stmt::Return(v));
                break;
            }

            // Branch instructions — simplified: we emit a comment
            OP_JUMP => {
                let off = read_s24(bytecode, &mut i);
                // forward jump = skip block, backward = loop
                if off > 0 {
                    // might be end of if-else; just continue
                } else if off < 0 {
                    stmts.push(Stmt::Comment("// loop back".into()));
                }
            }
            OP_IFTRUE | OP_IFFALSE | OP_IFEQ | OP_IFNE |
            OP_IFLT | OP_IFLE | OP_IFGT | OP_IFGE |
            OP_IFSTRICTEQ | OP_IFSTRICTNE => {
                let off = read_s24(bytecode, &mut i);
                let cond = match op {
                    OP_IFTRUE    => stack.pop().unwrap_or(Expr::Null),
                    OP_IFFALSE   => Expr::UnOp { op: "!", expr: Box::new(stack.pop().unwrap_or(Expr::Null)) },
                    OP_IFEQ     | OP_IFSTRICTEQ => {
                        let r = stack.pop().unwrap_or(Expr::Null);
                        let l = stack.pop().unwrap_or(Expr::Null);
                        Expr::BinOp { op: "==", left: Box::new(l), right: Box::new(r) }
                    }
                    OP_IFNE     | OP_IFSTRICTNE => {
                        let r = stack.pop().unwrap_or(Expr::Null);
                        let l = stack.pop().unwrap_or(Expr::Null);
                        Expr::BinOp { op: "!=", left: Box::new(l), right: Box::new(r) }
                    }
                    OP_IFLT => {
                        let r = stack.pop().unwrap_or(Expr::Null);
                        let l = stack.pop().unwrap_or(Expr::Null);
                        Expr::BinOp { op: "<", left: Box::new(l), right: Box::new(r) }
                    }
                    OP_IFLE => {
                        let r = stack.pop().unwrap_or(Expr::Null);
                        let l = stack.pop().unwrap_or(Expr::Null);
                        Expr::BinOp { op: "<=", left: Box::new(l), right: Box::new(r) }
                    }
                    OP_IFGT => {
                        let r = stack.pop().unwrap_or(Expr::Null);
                        let l = stack.pop().unwrap_or(Expr::Null);
                        Expr::BinOp { op: ">", left: Box::new(l), right: Box::new(r) }
                    }
                    OP_IFGE => {
                        let r = stack.pop().unwrap_or(Expr::Null);
                        let l = stack.pop().unwrap_or(Expr::Null);
                        Expr::BinOp { op: ">=", left: Box::new(l), right: Box::new(r) }
                    }
                    _ => stack.pop().unwrap_or(Expr::Null),
                };
                // Simple if: emit the condition; we can't reconstruct the block without CFG
                // so emit a raw comment showing what was being tested
                stmts.push(Stmt::Comment(format!("if ({}) {{ /* jump {} */ }}", render_expr(&cond), off)));
            }

            OP_GETSCOPEOBJECT => { read_u30(bytecode, &mut i); }
            OP_KILL => { read_u30(bytecode, &mut i); }
            OP_THROW => { stack.pop(); stmts.push(Stmt::Raw("throw /* value */;".into())); }
            OP_ISTYPELATE | OP_INSTANCEOF => {
                stack.pop(); stack.pop();
                stack.push(Expr::Unknown("instanceof".into()));
            }
            OP_IN => {
                stack.pop(); stack.pop();
                stack.push(Expr::Unknown("in".into()));
            }

            _ => {
                // unknown op, skip
            }
        }

        if stack.len() > 64 { stack.drain(0..32); }
    }

    stmts
}

/// Apply SSF2 → Fraymakers API translation to the statement tree.
fn translate_stmts(stmts: &[Stmt], abc: &AbcFile) -> Vec<Stmt> {
    stmts.iter().map(|s| translate_stmt(s)).collect()
}

fn translate_stmt(stmt: &Stmt) -> Stmt {
    match stmt {
        Stmt::CallVoid { expr } => {
            let translated = translate_expr(expr);
            // If translation added a comment prefix, wrap it
            Stmt::CallVoid { expr: translated }
        }
        Stmt::SetProperty { obj, name, value } => {
            Stmt::SetProperty {
                obj: translate_expr(obj),
                name: name.clone(),
                value: translate_expr(value),
            }
        }
        Stmt::Assign { local, value } => Stmt::Assign { local: *local, value: translate_expr(value) },
        Stmt::Return(v) => Stmt::Return(v.as_ref().map(translate_expr)),
        Stmt::If { cond, then_stmts, else_stmts } => Stmt::If {
            cond: translate_expr(cond),
            then_stmts: translate_stmts(then_stmts, &AbcFile::empty()),
            else_stmts: translate_stmts(else_stmts, &AbcFile::empty()),
        },
        other => other.clone(),
    }
}

fn translate_expr(expr: &Expr) -> Expr {
    match expr {
        Expr::Call { obj, method, args } => {
            // Check if obj is `this` / `self` and method is a known SSF2 API
            let is_self = matches!(obj.as_ref(), Expr::This)
                || matches!(obj.as_ref(), Expr::GetLex(n) if n == "this");
            if is_self {
                if let Some((fm, comment)) = lookup_api(method) {
                    let fm_args = args.iter().map(translate_expr).collect::<Vec<_>>();
                    // Build the translated call
                    if fm.starts_with("//") {
                        return Expr::Unknown(format!("{} // TODO: {}", fm, method));
                    }
                    // Strip trailing () if it has them (no-arg methods)
                    if fm.ends_with("()") {
                        return Expr::GetLex(fm.to_string());
                    }
                    return Expr::Call {
                        obj: Box::new(Expr::GetLex("self".into())),
                        method: fm.trim_start_matches("self.").to_string(),
                        args: fm_args,
                    };
                }
            }
            // Recursively translate
            Expr::Call {
                obj: Box::new(translate_expr(obj)),
                method: method.clone(),
                args: args.iter().map(translate_expr).collect(),
            }
        }
        Expr::GetProperty { obj, name } => {
            Expr::GetProperty { obj: Box::new(translate_expr(obj)), name: name.clone() }
        }
        Expr::BinOp { op, left, right } => Expr::BinOp {
            op,
            left: Box::new(translate_expr(left)),
            right: Box::new(translate_expr(right)),
        },
        Expr::UnOp { op, expr } => Expr::UnOp { op, expr: Box::new(translate_expr(expr)) },
        Expr::NewObject(pairs) => Expr::NewObject(
            pairs.iter().map(|(k, v)| (k.clone(), translate_expr(v))).collect()
        ),
        Expr::NewArray(items) => Expr::NewArray(items.iter().map(translate_expr).collect()),
        other => other.clone(),
    }
}

// Minimal empty AbcFile for translate_stmts recursion
impl AbcFile {
    fn empty() -> AbcFile {
        AbcFile {
            strings: vec![],
            ints: vec![],
            uints: vec![],
            doubles: vec![],
            multinames: vec![],
            methods: vec![],
            classes: vec![],
            scripts: vec![],
            method_bodies: vec![],
        }
    }
}
