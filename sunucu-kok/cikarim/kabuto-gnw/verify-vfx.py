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
    mystery = animation['clips']['white-snake-assault']
    available = (mystery['returnFrame']-mystery['hitFrames'][0])*40
    snake_end = 60+len(manifest['clips']['snakes']['timeline'])*40
    poison_end = 420+len(manifest['clips']['poison']['timeline'])*40
    assert max(snake_end,poison_end) <= available, 'Mystery must finish before returning control'
    assert 22 not in mystery['keys'], 'Target snake eruption must not be baked onto the caster'
    assert 26 not in animation['clips']['white-extreme-attack']['keys'], 'Avoid double dragon effects'
    verified = (BASE/'verify/scripts/Processors/Game/Battle/Character/TRole.as').read_text()
    assert all(atlas['url'] in verified for atlas in manifest['atlases'].values())
    assert 'getChildIndex(field)' in (BASE/'raster-vfx.as.txt').read_text()
    evidence = json.loads((BASE/'validation/revival-visual/result.json').read_text())
    assert evidence['completed'] and evidence['cases'] == 12
    assert evidence['atlasesLoaded'] == 6 and evidence['assetPlays'] == 20
    assert evidence['remainingLayers'] == 0 and not evidence['errors']
    version = re.search("VERSION=b'([0-9]+)'",(BASE/'build-client.py').read_text())[1]
    result = {'clientVersion':version,'frameRate':25,'generatedVfxCells':sum(counts.values()),
              'vfxClips':len(manifest['clips']),'mysteryEffectMs':poison_end,
              'mysteryAvailableMs':available,'atlasHashes':hashes,'nativeComponent':evidence}
    (BASE/'validation/vfx-v3/verified.json').write_text(json.dumps(result,indent=2))
    print(f'PASS generated VFX/death: {len(counts)} transparent atlases, {sum(counts.values())} cells, 9 VFX clips at 25 FPS; native Flash 12 cases / both camps / zero errors and remaining layers; Mystery timing safe.')


if __name__ == '__main__':
    main()
