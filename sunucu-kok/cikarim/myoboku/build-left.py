"""Verify the compiled native icon patch and publish a new local client release.

Source SWF is decoded from release 2026102501. Myoboku occupies the first
custom event slot; Boss occupies the next slot to its right. Only TProcessorLobby is imported.
Run with --compile to recompile the reviewed patched AS3 before publishing.
"""
from pathlib import Path
import argparse, importlib.util, json, shutil, struct, subprocess, zlib

BASE = Path(__file__).resolve().parent
ROOT = BASE.parents[2]
PUBLIC = ROOT / 'sunucu-kok/kaynak/login.gogames.me/public'
VERSION = '2026102502'
spec = importlib.util.spec_from_file_location('helpers', BASE.parent / 'flash-refinery/build.py')
h = importlib.util.module_from_spec(spec)
spec.loader.exec_module(h)

def ff(*args):
    subprocess.run(['java', '-Xmx2g', '-jar', str(ROOT / '.tools/ffdec/ffdec-cli.jar'), *map(str,args)], check=True)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--compile', action='store_true')
    args = parser.parse_args()
    source = BASE / 'left-source.swf'
    compiled = BASE / 'left-compiled.swf'
    if args.compile:
        ff('-onerror', 'abort', '-importScript', source, compiled, BASE / 'left-patched')
    assert [t for t in h.tags(source.read_bytes()) if t[0] != 82] == [t for t in h.tags(compiled.read_bytes()) if t[0] != 82], 'Unexpected change to client assets'
    ff('-selectclass', 'Processors.Game.Lobby.TProcessorLobby', '-export', 'script', BASE / 'left-verify', compiled)
    lobby = (BASE / 'left-verify/scripts/Processors/Game/Lobby/TProcessorLobby.as').read_text(encoding='utf-8')
    assert 'ExternalInterface.call("openMyoboku")' in lobby
    assert 'this.FMyobokuIcon.x = anchor.x;' in lobby
    assert 'this.FIllusionIcon.x = anchor.x + 68' in lobby
    assert 'this.FMyobokuIcon.visible = this.FIllusionIcon.visible' in lobby
    pointer = PUBLIC / 'client-release.json'
    current = json.loads(pointer.read_text())['version']
    assert current == '2026102501', 'Release changed since this patch was prepared'
    active = PUBLIC / current
    assert h.swap((active / 'TApplication.swf').read_bytes()) == source.read_bytes()
    target = PUBLIC / VERSION
    assert not target.exists(), 'Target release already exists'
    raw = zlib.decompress((active / 'version.swf').read_bytes())
    pos = 2
    parts = [raw[:2]]
    found = 0
    for _ in range(struct.unpack_from('<H', raw)[0]):
        n = struct.unpack_from('<H', raw, pos)[0]; pos += 2
        key = raw[pos:pos+n]; pos += n
        n = struct.unpack_from('<H', raw, pos)[0]; pos += 2
        value = raw[pos:pos+n]; pos += n
        if key == b'TApplication.swf':
            value = VERSION.encode(); found += 1
        parts.extend([struct.pack('<H', len(key)), key, struct.pack('<H', len(value)), value])
    assert found == 1 and pos == len(raw)
    backup = BASE / 'left-backups'
    backup.mkdir(exist_ok=True)
    shutil.copy2(pointer, backup / 'client-release.json')
    target.mkdir()
    (target / 'TApplication.swf').write_bytes(h.swap(compiled.read_bytes()))
    shutil.copy2(active / 'index.swf', target / 'index.swf')
    (target / 'version.swf').write_bytes(zlib.compress(b''.join(parts)))
    tmp = pointer.with_suffix('.tmp')
    tmp.write_text(json.dumps({'version': VERSION}) + '\n')
    tmp.replace(pointer)
    print('PASS: native icon, unchanged client assets, release', VERSION)
