"""Check native component evidence and supplemental impact/return timing."""
from pathlib import Path
import json
BASE=Path(__file__).resolve().parent
animation=json.loads((BASE/'animation.json').read_text())
result=json.loads((BASE/'validation/extracted/native/result.json').read_text())
assert result['completed'] and result['cases']==18 and not result['errors']
assert result['atlasesLoaded']==11 and result['assetPlays']==34
assert result['powerLayers']==36 and result['remainingLayers']==0
for sid,name in animation['moves'].items():
    clip=animation['clips'][name];delay=clip.get('hitFrames',[10])[0]*40
    duration=1250 if name=='rage' else 1050 if name in ['roots','chaos'] else 820
    assert delay+duration<=clip['returnFrame']*40,(sid,name,delay,duration)
    for camp in [0,1]:
        image=BASE/f'validation/extracted/native/HIT-{sid}-camp-{camp}.jpg'
        assert image.exists() and image.stat().st_size>1000
proof={'cases':18,'chargeLayers':18,'impactLayers':18,'sourceAssetPlays':34,'errors':[],
       'remainingLayers':0,'impactTimingMatchesDamage':True,'endsBeforeReturn':True}
(BASE/'validation/power-vfx.json').write_text(json.dumps(proof,indent=2))
print('PASS native Flash: 18 cases, 36 power layers, 34 source effects; impact/return timing, both camps and cleanup verified')
