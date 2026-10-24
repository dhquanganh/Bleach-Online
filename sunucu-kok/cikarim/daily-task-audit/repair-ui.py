"""Compile Daily Tasks fixes against the current app and preserve other release routes."""
from pathlib import Path
import hashlib, importlib.util, json, shutil, struct, subprocess, zlib

B = Path(__file__).resolve().parent
P = B.parents[1] / 'kaynak/login.gogames.me/public'
C = P / '2026090619'
V = '2026102424'

def main():
    release = P / V
    if release.exists():
        raise RuntimeError('Release already exists: ' + V)
    spec = importlib.util.spec_from_file_location('helpers', B.parent / 'flash-refinery/build.py')
    h = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(h)
    current = json.loads((P / 'client-release.json').read_text())['version']
    app = C / 'TApplication.swf'
    assert app.read_bytes() == (P / current / 'TApplication.swf').read_bytes(), 'Canonical app is stale'
    source, compiled = B / 'repair-source.swf', B / 'repair-compiled.swf'
    source.write_bytes(h.swap(app.read_bytes()))
    jar = B.parents[2] / '.tools/ffdec/ffdec-cli.jar'
    def ffdec(*args):
        r = subprocess.run(['java', '-Xmx2g', '-jar', str(jar), *map(str, args)], capture_output=True, text=True, errors='replace')
        if r.returncode:
            raise RuntimeError(r.stdout + r.stderr)
    ffdec('-onerror', 'abort', '-importScript', source, compiled, B / 'patched')
    result = compiled.read_bytes()
    assert [t for t in h.tags(source.read_bytes()) if t[0] != 82] == [t for t in h.tags(result) if t[0] != 82]
    classes = ','.join('Processors.Game.Lobby.DailyQuest.' + name for name in ['TProcessorDailyQuest', 'TProcessorWindowTask', 'TProcessorWindowPoint'])
    ffdec('-selectclass', classes, '-export', 'script', B / 'repair-verify', compiled)
    scripts = B / 'repair-verify/scripts/Processors/Game/Lobby/DailyQuest'
    point = (scripts / 'TProcessorWindowPoint.as').read_text(encoding='utf-8')
    task = (scripts / 'TProcessorWindowTask.as').read_text(encoding='utf-8')
    assert 'Math.min(REWARD_LISTS - 1' in point
    assert 'TOTAL_POINT:uint = 150' in point
    assert 'if(_loc2_ == null)' in task
    backup = B / ('backups-' + V)
    backup.mkdir()
    for path in [app, C / 'version.swf', P / 'client-release.json']:
        shutil.copy2(path, backup / path.name)
    raw = zlib.decompress((C / 'version.swf').read_bytes())
    count = struct.unpack_from('<H', raw)[0]
    pos, rows = 2, []
    for _ in range(count):
        n = struct.unpack_from('<H', raw, pos)[0]; pos += 2
        key = raw[pos:pos+n]; pos += n
        n = struct.unpack_from('<H', raw, pos)[0]; pos += 2
        value = raw[pos:pos+n]; pos += n
        rows.append((key, V.encode() if key == b'TApplication.swf' else value))
    assert pos == len(raw) and any(k == b'TApplication.swf' for k, v in rows)
    version = zlib.compress(struct.pack('<H', len(rows)) + b''.join(struct.pack('<H', len(k)) + k + struct.pack('<H', len(v)) + v for k, v in rows))
    release.mkdir()
    encoded = h.swap(result)
    (release / 'TApplication.swf').write_bytes(encoded)
    (release / 'version.swf').write_bytes(version)
    shutil.copy2(C / 'index.swf', release / 'index.swf')
    app.write_bytes(encoded)
    (C / 'version.swf').write_bytes(version)
    manifest = {'version': V, 'previous': current, 'sha256': hashlib.sha256(encoded).hexdigest(), 'nonCodeAssetsPreserved': True}
    (B / 'repair-release.json').write_text(json.dumps(manifest, indent=2) + '\n')
    pointer = P / 'client-release.json'
    tmp = pointer.with_suffix('.tmp')
    tmp.write_text(json.dumps({'version': V}) + '\n')
    tmp.replace(pointer)
    print('PASS Daily Tasks client release', V, ': compiled classes verified; non-code assets and existing routes preserved')

if __name__ == '__main__':
    main()
