"""Targeted Mecha giant-pose/Pain Six-in-one size repair on the live Itachi client."""
from pathlib import Path
import hashlib, importlib.util, io, json, math, re, shutil, struct, subprocess, zlib
from PIL import Image

B = Path(__file__).resolve().parent
C = B.parent
ROOT = C.parent
VERSION = '2026102105'
ROLE = Path('Processors/Game/Battle/Character/TRole.as')

def module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result

client = module('itachi_client', C/'itachi-rtn/build-client.py')
native = module('mecha_data', C/'mecha-naruto/build.py').native

def sha(data): return hashlib.sha256(data).hexdigest()

packed_sequence = module('mecha_model_packing', C/'mecha-naruto/model-packing.py').packed_sequence

def main():
    B.mkdir(exist_ok=True)
    public = native.PUBLIC
    canonical = public/'2026090619/TApplication.swf'
    original = canonical.read_bytes()
    decoded = client.h.swap(original)
    reuse = (B/'source.swf').exists() and (B/'source.swf').read_bytes() == decoded and (B/'compiled.swf').exists() and (B/'verify/scripts'/ROLE).exists()
    (B/'source.swf').write_bytes(decoded)
    client.ff('-selectclass', 'Processors.Game.Battle.Character.TRole', '-export', 'script', B/'original', B/'source.swf')
    before = (B/'original/scripts'/ROLE).read_text(encoding='utf-8')
    assert 'function UpdateItachiVfx(' in before
    method = client.m.extract(before, 'ShowPainVfx')
    token = 'skill == 13120974 ? 900 :'
    assert method.count(token) == 1, 'Expected pre-repair Six-in-one footprint'
    after = before.replace(method, method.replace(token, 'skill == 13120974 ? 1250 :'))
    dest = B/'patched'/ROLE
    dest.parent.mkdir(parents=True, exist_ok=True)
    dest.write_text(after, encoding='utf-8')
    if not reuse: client.ff('-onerror', 'abort', '-importScript', B/'source.swf', B/'compiled.swf', B/'patched')
    rebuilt = (B/'compiled.swf').read_bytes()
    assert [t for t in client.h.tags(decoded) if t[0] != 82] == [t for t in client.h.tags(rebuilt) if t[0] != 82]
    if not reuse: client.ff('-selectclass', 'Processors.Game.Battle.Character.TRole', '-export', 'script', B/'verify', B/'compiled.swf')
    verified = (B/'verify/scripts'/ROLE).read_text(encoding='utf-8')
    names = re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(', before)
    for name in names:
        if name != 'ShowPainVfx':
            assert client.m.extract(before, name) == client.m.extract(verified, name), name
    assert 'skill == 13120974 ? 1250 :' in client.m.extract(verified, 'ShowPainVfx')

    # Regenerate only the three shrunken giant attacks from their native source.
    # Existing idle/recovery art, clip indices, hit timing and all other frames stay intact.
    p = module('mecha_assets', C/'mecha-naruto/prepare-assets.py')
    old_animation = json.loads((p.BASE/'animation.json').read_text())
    animation = json.loads(json.dumps(old_animation))
    config, images = p.p.decode(p.SOURCE/'assets/battle/role/left/11015003.swf')
    changed_frames = {}
    for name in ['beast-bomb', 'claw', 'sweep']:
        frames, _ = p.p.mme.render(config, images, p.MAPPING[name][1], scale=1)
        indices = [min(len(frames)-1, round(t*24/25)) for t in range(math.ceil(len(frames)*25/24))]
        ids = animation['clips'][name]['assets']
        for tick, index in enumerate(indices):
            im = frames[index]
            if not im.getbbox(): continue
            px, py = im.info['pivot']
            image = im.resize((max(1, round(im.width*.75)), max(1, round(im.height*.75))), Image.Resampling.LANCZOS)
            box = image.getbbox()
            image = image.crop(box)
            ident = ids[tick]
            changed_frames[ident] = image
            animation['framePivots'][str(ident)] = [round(px*.75)-box[0], round(py*.75)-box[1]]
    assert animation['clips'] == old_animation['clips']
    model_files = {}
    native.texture_sequence = packed_sequence
    for version in ['2017112917', '2026090619']:
        ident = int(f'{11120950:X}0C', 16)
        sequences = []
        for name in animation['models']['11120950']['0c']:
            clip = animation['clips'][name]
            frames = []
            for ident_frame in clip['assets']:
                frames.append(changed_frames[ident_frame] if ident_frame in changed_frames else Image.open(p.BASE/'frames'/f'{ident_frame:03}.png').convert('RGBA'))
            sequences.append(dict(frames=frames, loop=clip['loop'], duration=40, pivots=[tuple(animation['framePivots'][str(i)]) for i in clip['assets']]))
        model_files[public/version/'Resources/Textures/Model'/f'{ident:08X}.TexClient'] = native.texture_sequences(ident, sequences)

    manifest = canonical.parent/'version.swf'
    raw = zlib.decompress(manifest.read_bytes()); pos = 2; rows = []
    for _ in range(struct.unpack_from('<H', raw)[0]):
        n = struct.unpack_from('<H', raw, pos)[0]; pos += 2; key = raw[pos:pos+n]; pos += n
        n = struct.unpack_from('<H', raw, pos)[0]; pos += 2; value = raw[pos:pos+n]; pos += n
        rows.append((key, value))
    assert pos == len(raw)
    # Fresh model URLs also invalidate any older persistent-form texture cache.
    aliases = {}
    for hero in [11120950, 11120930]:
        for suffix in ['', '0A', '0B', '0C', '0D', '0E', '0F']:
            ident = int(f'{hero:X}'+suffix, 16)
            key = f'Resources/Textures/Model/{ident:08X}.TexClient'
            src = public/'2026090619'/key
            aliases[key.encode()] = model_files.get(src, src.read_bytes())
    replacements = {key:VERSION.encode() for key in aliases}
    replacements[b'TApplication.swf'] = VERSION.encode()
    keys = {key for key, _ in rows}
    rows = [(key, replacements.get(key, value)) for key, value in rows]
    rows += [(key, value) for key, value in replacements.items() if key not in keys]
    manifest_data = struct.pack('<H', len(rows)) + b''.join(struct.pack('<H', len(k))+k+struct.pack('<H', len(v))+v for k,v in rows)
    assert canonical.read_bytes() == original
    backups = B/'backups'; backups.mkdir(exist_ok=True)
    for f in [canonical, manifest, p.BASE/'animation.json', *model_files]:
        target = backups/f.relative_to(ROOT)
        target.parent.mkdir(parents=True, exist_ok=True)
        if not target.exists(): shutil.copy2(f, target)
    for ident, im in changed_frames.items():
        f = p.BASE/'frames'/f'{ident:03}.png'
        target = backups/f.relative_to(ROOT); target.parent.mkdir(parents=True, exist_ok=True)
        if not target.exists(): shutil.copy2(f, target)
        im.save(f)
    (p.BASE/'animation.json').write_text(json.dumps(animation, indent=2))
    for f,data in model_files.items(): f.write_bytes(data)
    for key,data in aliases.items():
        f = public/VERSION/key.decode(); f.parent.mkdir(parents=True, exist_ok=True); f.write_bytes(data)
    protected = client.h.swap(rebuilt)
    (public/VERSION/'TApplication.swf').write_bytes(protected)
    canonical.write_bytes(protected)
    manifest.write_bytes(zlib.compress(manifest_data))
    (B/'result.json').write_text(json.dumps({'version':VERSION,'clientSha256':sha(protected),'changedActorFrames':len(changed_frames),'unchangedMethodsChecked':len(names)-1,'itachiMethodsUnchanged':True,'mechaPersistentPoseScale':1,'mechaGiantAttackScale':.75,'painSixInOneFootprint':1250,'modelCacheVersions':14,'fullGameplayTest':False},indent=2))
    print('PASS targeted size repair; unchanged Itachi/all unrelated TRole methods; client', VERSION)

if __name__ == '__main__': main()
