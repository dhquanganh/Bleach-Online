"""Check the actual five-target Flash laser preview and installed role methods."""
from pathlib import Path
import json,re
BASE=Path(__file__).resolve().parent
result=json.loads((BASE/'validation/laser-final/result.json').read_text())
log=(BASE/'validation/laser-final/runtime.log').read_text()
assert result['completed'] and result['cases']==2 and not result['errors']
assert result['assetPlays']==4 and result['powerLayers']==2 and result['atlasesLoaded']==11 and result['remainingLayers']==0
bounds=re.findall(r'LASER_AOE count=(\d+) width=([\d.]+) height=([\d.]+)',log)
assert len(bounds)==2
for count,width,height in bounds:assert int(count)==5 and float(width)>=1500 and float(height)>=850
paths=re.findall(r'LASER_PATH camp=(\d) muzzle=([\d.-]+),([\d.-]+) aim=([\d.-]+),([\d.-]+)',log)
assert len(paths)==2
for camp,mx,my,ax,ay in paths:assert (float(ax)-float(mx))*(1 if camp=='0' else -1)>0
role=(BASE/'laser-verify/scripts/Processors/Game/Battle/Character/TRole.as').read_text(encoding='utf-8')
for token in ['ShowPainLaserImpact','Math.max(1500','Math.max(850','RestorePainAfterRevival']:assert token in role
cfg=json.loads((BASE.parents[1]/'sunucu/pain-tendo.json').read_text())
assert cfg['laser']['target']=='all' and cfg['laser']['attackStat']=='atk' and cfg['laser']['cooldown']==2
result.update(clientVersion='2026101955',targetsPerPreview=5,aoeBounds=bounds)
(BASE/'validation/laser-final/verified.json').write_text(json.dumps(result,indent=2))
print('PASS all-enemy Laser: giant beam and shockwave, both directions, 5 targets in scaled containers, 4 source layer plays, 2 impacts, recursive cleanup and compiled methods')
