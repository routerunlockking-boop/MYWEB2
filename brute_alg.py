import itertools

def get_char(m, mapping):
    # mapping 0: 0-9, A-Z, a-z
    # mapping 1: 0-9, a-z, A-Z
    if m < 10:
        return chr(48 + m)
    if mapping == 0:
        if m < 36: return chr(55 + m) # A-Z (65)
        return chr(61 + m) # a-z (97)
    else:
        if m < 36: return chr(87 + m) # a-z (97)
        return chr(29 + m) # A-Z (65)

def generate(data, mod, seed_start, mapping):
    data_bytes = [ord(c) for c in data]
    length = len(data_bytes)
    out = []
    for i in range(8):
        seed = seed_start
        for j in range(length):
            while seed > 0xffffff:
                seed = (~seed) & 0xffffff
            idx = (i + j) % length
            product = ((i + 1) * (j + 1)) & 0xff
            seed = (seed + data_bytes[idx] * product)
        while seed > 0xffffff:
            seed = (~seed) & 0xffffff
        out.append(get_char(seed % mod, mapping))
    return "".join(out)

imei = "862624055623767"
mac = "D8:42:F7:B2:3A:8C"
target = "dA5nzSYa"

inputs = [
    imei,
    mac,
    mac.lower(),
    mac.replace(":", ""),
    mac.replace(":", "").lower()
]

mods = [52, 62]
seeds = range(10)
mappings = [0, 1]

found = False
for inp, mod, seed, mapping in itertools.product(inputs, mods, seeds, mappings):
    res = generate(inp, mod, seed, mapping)
    if res == target:
        print(f"FOUND! Input: {inp}, Mod: {mod}, Seed: {seed}, Mapping: {mapping}")
        found = True
        break

if not found:
    # Try different bitwise logic (no inversion)
    for inp, mod, seed, mapping in itertools.product(inputs, mods, seeds, mappings):
        data_bytes = [ord(c) for c in inp]
        length = len(data_bytes)
        out = []
        for i in range(8):
            seed_val = seed
            for j in range(length):
                seed_val = (seed_val + data_bytes[(i+j)%length] * (((i+1)*(j+1))&0xff)) & 0xffffff
            out.append(get_char(seed_val % mod, mapping))
        res = "".join(out)
        if res == target:
            print(f"FOUND (Simple Mask)! Input: {inp}, Mod: {mod}, Seed: {seed}, Mapping: {mapping}")
            found = True
            break

if not found:
    print("Not found in standard variants.")
