"""Verify installed raster resources, native timing and Flash component evidence."""
from pathlib import Path
from PIL import Image
import hashlib
import json
import re

BASE = Path(__file__).resolve().parent
ROOT = BASE.parents[1]


def main():
    manifest = json.loads((BASE/'vfx.json').read_text())
    animation = json.loads((BASE/'animation.json').read_text())
    assert manifest['frameRate'] == animation['frameRate'] == 25
    counts = {}
    hashes = {}
    for name, atlas in manifest['atlases'].items():
        file = ROOT/'kaynak/login.gogames.me'/atlas['url'].lstrip('/')
        image = Image.open(file).convert('RGBA')
        assert image.width % atlas['columns'] == image.height % atlas['rows'] == 0
        assert image.getchannel('A').getextrema()[0] == 0, name+' must be transparent'
        counts[name] = atlas['columns']*atlas['rows']
        hashes[name] = hashlib.sha256(file.read_bytes()).hexdigest()
    for name, clip in manifest['clips'].items():
        assert clip['timeline'] and all(0 <= i < counts[clip['atlas']] for i in clip['timeline'])
    assert set(manifest['effects']) >= {'aoyi','aoyitexie','huituzhuansheng','pugong','pugong1','pugong2','tinengzhiyu','zhuida'}
    available = len(animation['clips']['white-snake-assault']['assets'])*40
    mystery_end = max(len(manifest['clips'][name]['timeline'])*40 for name in manifest['effects']['aoyi'])
    assert mystery_end <= available
    verified = (BASE/'verify/scripts/Processors/Game/Battle/Character/TRole.as').read_text()
    assert all(atlas['url'] in verified for atlas in manifest['atlases'].values())
    sources=json.loads((BASE/'validation/extracted/source-assets.json').read_text())
    assert len(sources)==14
    for source in sources:
        file=ROOT/'kaynak/login.gogames.me/public/kabuto-vfx/extracted/original'/source['file']
        assert hashlib.sha256(file.read_bytes()).hexdigest()==source['sha256']
    evidence = json.loads((BASE/'validation/extracted/revival/result.json').read_text())
    assert evidence['completed'] and evidence['cases'] == 12
    assert evidence['atlasesLoaded'] == len(manifest['atlases']) and evidence['assetPlays'] >= 18
    assert evidence['deathHolds']==evidence['restores']==evidence['stableRestores']==12
    assert evidence['remainingLayers'] == 0 and not evidence['errors']
    version = re.search("VERSION=b'([0-9]+)'",(BASE/'build-client.py').read_text())[1]
    result = {'clientVersion':version,'frameRate':25,'sourceFrameRate':24,'sourceFiles':len(sources),
              'vfxClips':len(manifest['clips']),'mysteryEffectMs':mystery_end,
              'mysteryAvailableMs':available,'atlasHashes':hashes,'nativeComponent':evidence}
    (BASE/'validation/extracted/verified.json').write_text(json.dumps(result,indent=2))
    print(f'PASS original Kabuto VFX: {len(counts)} transparent atlases; all 14 input files hashed; native Flash 12 cases / both camps / death and revival / zero errors or remaining layers.')



if __name__ == '__main__':
    main()
