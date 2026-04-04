#!/usr/bin/env python3
"""Parse attack stats from mario.ssf ABC bytecode."""
import struct, sys, json

def read_u30(buf, off):
    result = 0; shift = 0
    while True:
        b = buf[off]; off += 1
        result |= (b & 0x7F) << shift; shift += 7
        if not (b & 0x80): break
    return result, off

def read_s32(buf, off):
    v, off = read_u30(buf, off)
    if v >= 0x10000000: v -= 0x20000000
    return v, off

def skip_trait(data, pos):
    _, pos = read_u30(data, pos)  # name
    kind_byte = data[pos]; pos += 1
    kind = kind_byte & 0x0F
    extra = bool(kind_byte & 0x40)
    if kind in (0, 6):
        _, pos = read_u30(data, pos)
        _, pos = read_u30(data, pos)
        vi, pos = read_u30(data, pos)
        if vi != 0: pos += 1  # vkind
    elif kind in (1, 2, 3):
        _, pos = read_u30(data, pos)
        _, pos = read_u30(data, pos)
    elif kind in (4, 5):
        _, pos = read_u30(data, pos)
        _, pos = read_u30(data, pos)
    if extra:
        mc, pos = read_u30(data, pos)
        for _ in range(mc): _, pos = read_u30(data, pos)
    return pos

fname = sys.argv[1] if len(sys.argv) > 1 else '/Users/jimmy/.openclaw/workspace-main/mario.ssf'
data = open(fname, 'rb').read()

abc_start = data.find(b'\x10\x00\x2e\x00')
if abc_start == -1:
    print("No ABC found"); sys.exit(1)
print(f"ABC at offset {abc_start}")
pos = abc_start + 4

# Int pool
int_count, pos = read_u30(data, pos)
ints_pool = [0]
for _ in range(int_count - 1):
    v, pos = read_s32(data, pos); ints_pool.append(v)

# Uint pool
uint_count, pos = read_u30(data, pos)
uints_pool = [0]
for _ in range(uint_count - 1):
    v, pos = read_u30(data, pos); uints_pool.append(v)

# Double pool
double_count, pos = read_u30(data, pos)
doubles_pool = [float('nan')]
for _ in range(double_count - 1):
    doubles_pool.append(struct.unpack_from('<d', data, pos)[0]); pos += 8

# String pool
str_count, pos = read_u30(data, pos)
strings = ['']
for _ in range(str_count - 1):
    slen, pos = read_u30(data, pos)
    strings.append(data[pos:pos+slen].decode('utf-8', errors='replace'))
    pos += slen

print(f"Strings: {len(strings)}, looking for 'damage' at index {next((i for i,s in enumerate(strings) if s=='damage'), None)}")

# Namespace pool
ns_count, pos = read_u30(data, pos)
for _ in range(ns_count - 1):
    pos += 1; _, pos = read_u30(data, pos)

# Namespace set pool
ns_set_count, pos = read_u30(data, pos)
for _ in range(ns_set_count - 1):
    s, pos = read_u30(data, pos)
    for _ in range(s): _, pos = read_u30(data, pos)

# Multiname pool
mn_count, pos = read_u30(data, pos)
multinames = [None]
for _ in range(mn_count - 1):
    kind = data[pos]; pos += 1
    if kind in (0x07, 0x0D):
        _, pos = read_u30(data, pos); ni, pos = read_u30(data, pos)
        multinames.append(strings[ni] if ni < len(strings) else '')
    elif kind in (0x0F, 0x10, 0x11, 0x12): multinames.append(None)
    elif kind in (0x09, 0x0E):
        ni, pos = read_u30(data, pos); _, pos = read_u30(data, pos)
        multinames.append(strings[ni] if ni < len(strings) else '')
    elif kind in (0x1B, 0x1C):
        _, pos = read_u30(data, pos); multinames.append(None)
    else: multinames.append(None)

# Methods
method_count, pos = read_u30(data, pos)
for _ in range(method_count):
    _, pos = read_u30(data, pos)
    param_count, pos = read_u30(data, pos)
    _, pos = read_u30(data, pos)
    flags = data[pos]; pos += 1
    for _ in range(param_count): _, pos = read_u30(data, pos)
    if flags & 0x08:
        oc, pos = read_u30(data, pos)
        for _ in range(oc): _, pos = read_u30(data, pos); pos += 1
    if flags & 0x80:
        for _ in range(param_count): _, pos = read_u30(data, pos)

# Metadata
meta_count, pos = read_u30(data, pos)
for _ in range(meta_count):
    _, pos = read_u30(data, pos)
    ic, pos = read_u30(data, pos)
    for _ in range(ic): _, pos = read_u30(data, pos); _, pos = read_u30(data, pos)

# Classes
class_count, pos = read_u30(data, pos)
for _ in range(class_count):
    _, pos = read_u30(data, pos); _, pos = read_u30(data, pos)
    flags = data[pos]; pos += 1
    if flags & 0x08: _, pos = read_u30(data, pos)
    ifc, pos = read_u30(data, pos)
    for _ in range(ifc): _, pos = read_u30(data, pos)
    _, pos = read_u30(data, pos)
    tc, pos = read_u30(data, pos)
    for _ in range(tc): pos = skip_trait(data, pos)
for _ in range(class_count):
    _, pos = read_u30(data, pos)
    tc, pos = read_u30(data, pos)
    for _ in range(tc): pos = skip_trait(data, pos)

# Scripts
sc, pos = read_u30(data, pos)
for _ in range(sc):
    _, pos = read_u30(data, pos)
    tc, pos = read_u30(data, pos)
    for _ in range(tc): pos = skip_trait(data, pos)

# Method bodies
body_count, pos = read_u30(data, pos)
print(f"Method bodies: {body_count}")

DAMAGE_IDX = next((i for i,s in enumerate(strings) if s=='damage'), -1)
push_damage_bytes = b'\x2c' + DAMAGE_IDX.to_bytes((DAMAGE_IDX.bit_length()+6)//7 or 1, 'little')
# Re-encode as LEB128
def leb128(n):
    r = []
    while True:
        b = n & 0x7F; n >>= 7
        if n: b |= 0x80
        r.append(b)
        if not n: break
    return bytes(r)
push_damage_bytes = b'\x2c' + leb128(DAMAGE_IDX)

def parse_body_for_attacks(code):
    """Parse AVM2 bytecode, return list of hitbox objects found via NewObject."""
    ci = 0
    stack = []
    hitboxes = []

    while ci < len(code):
        op = code[ci]; ci += 1
        if op == 0x2C:  # PushString
            idx, ci = read_u30(code, ci)
            stack.append(('s', strings[idx] if idx < len(strings) else ''))
        elif op == 0x24:  # PushByte
            v = code[ci]; ci += 1
            if v >= 128: v -= 256
            stack.append(('n', v))
        elif op == 0x25:  # PushShort
            v, ci = read_u30(code, ci)
            if v >= 32768: v -= 65536
            stack.append(('n', v))
        elif op == 0x2D:  # PushInt
            idx, ci = read_u30(code, ci)
            stack.append(('n', ints_pool[idx] if idx < len(ints_pool) else 0))
        elif op == 0x2E:  # PushUint
            idx, ci = read_u30(code, ci)
            stack.append(('n', uints_pool[idx] if idx < len(uints_pool) else 0))
        elif op == 0x2F:  # PushDouble
            idx, ci = read_u30(code, ci)
            stack.append(('n', doubles_pool[idx] if idx < len(doubles_pool) else 0.0))
        elif op == 0x26: stack.append(('b', True))   # PushTrue
        elif op == 0x27: stack.append(('b', False))  # PushFalse
        elif op == 0x20: stack.append(('n', None))   # PushNaN
        elif op == 0x55:  # NewObject
            count, ci = read_u30(code, ci)
            props = {}
            items = []
            for _ in range(count * 2):
                items.append(stack.pop() if stack else ('x', None))
            # items: [val_n, key_n, val_{n-1}, key_{n-1}, ...]  (stack order reversed)
            # Actually: pushed as key_1, val_1, key_2, val_2... top of stack = last val
            # NewObject pops: (key_n, val_n), (key_{n-1}, val_{n-1}), ...
            # So items[0]=last_val, items[1]=last_key, etc.
            for j in range(count):
                val_item = items[j*2]
                key_item = items[j*2+1]
                if key_item[0] == 's':
                    props[key_item[1]] = val_item[1] if val_item[0] != 'o' else val_item[1]
                    if val_item[0] == 'o':
                        props[key_item[1]] = val_item[1]
            obj = ('o', props)
            if 'damage' in props:
                hitboxes.append(props)
            # Also check nested objects
            for v in props.values():
                if isinstance(v, dict) and 'damage' in v:
                    hitboxes.append(v)
            stack.append(obj)
        elif op == 0x56:  # NewArray
            count, ci = read_u30(code, ci)
            items = [stack.pop() if stack else ('x', None) for _ in range(count)]
            stack.append(('a', [i[1] for i in reversed(items)]))
        elif op in (0xD0,0xD1,0xD2,0xD3): stack.append(('l', op-0xD0))
        elif op == 0x62: idx, ci = read_u30(code, ci); stack.append(('l', idx))
        elif op in (0xD4,0xD5,0xD6,0xD7):
            if stack: stack.pop()
        elif op == 0x63: _, ci = read_u30(code, ci); (stack.pop() if stack else None)
        elif op == 0x30: (stack.pop() if stack else None)  # PushScope
        elif op == 0x29: (stack.pop() if stack else None)  # Pop
        elif op == 0x2A:  # Dup
            if stack: stack.append(stack[-1])
        elif op in (0x60, 0x5D, 0x5E): _, ci = read_u30(code, ci); stack.append(('r', None))
        elif op in (0x61, 0x68): _, ci = read_u30(code, ci); (stack.pop() if stack else None); (stack.pop() if stack else None)
        elif op in (0x46, 0x4F, 0x45, 0x41):
            _, ci = read_u30(code, ci)
            nargs, ci = read_u30(code, ci)
            for _ in range(nargs+1): (stack.pop() if stack else None)
            if op != 0x4F: stack.append(('r', None))
        elif op in (0x80, 0x85, 0x86, 0x87, 0x88, 0x89, 0x8A, 0x8B, 0x8C, 0x8D, 0x8E, 0x8F,
                    0x90, 0x91, 0x92, 0x93, 0x95, 0x96): _, ci = read_u30(code, ci)
        elif op in (0x47, 0x48): break
        # skip most others
    return hitboxes

all_attacks = []
for bi in range(body_count):
    method_idx, pos = read_u30(data, pos)
    _, pos = read_u30(data, pos)
    _, pos = read_u30(data, pos)
    _, pos = read_u30(data, pos)
    _, pos = read_u30(data, pos)
    code_len, pos = read_u30(data, pos)
    code = data[pos:pos+code_len]
    pos += code_len
    exc_count, pos = read_u30(data, pos)
    for _ in range(exc_count):
        _, pos = read_u30(data, pos); _, pos = read_u30(data, pos)
        _, pos = read_u30(data, pos); _, pos = read_u30(data, pos); _, pos = read_u30(data, pos)
    tc, pos = read_u30(data, pos)
    for _ in range(tc): pos = skip_trait(data, pos)

    if push_damage_bytes not in code: continue
    hitboxes = parse_body_for_attacks(code)
    if hitboxes:
        all_attacks.extend(hitboxes)
        print(f"Method {bi} (idx {method_idx}): {len(hitboxes)} hitboxes")
        for h in hitboxes[:2]:
            print(f"  {json.dumps({k:v for k,v in h.items() if k in ('damage','kbConstant','direction','power','hitStun','hitLag','weightKB','priority','effect_id')})}")

print(f"\nTotal hitboxes found: {len(all_attacks)}")
if all_attacks:
    with open('/tmp/mario_attacks.json', 'w') as f:
        json.dump(all_attacks, f, indent=2, default=str)
    print("Saved to /tmp/mario_attacks.json")
