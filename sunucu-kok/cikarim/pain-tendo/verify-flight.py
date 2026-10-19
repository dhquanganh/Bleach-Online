"""Verify real Flash flight coordinates and the compiled per-tick motion hook."""
from pathlib import Path
import json,re

BASE=Path(__file__).resolve().parent
result=json.loads((BASE/'validation/flight-final/result.json').read_text())
assert result['completed'] and result['cases']==6 and not result['errors'],result
assert result['remainingLayers']==0 and result['atlasesLoaded']==11,result
log=(BASE/'validation/flight-final/runtime.log').read_text()
groups={}
for skill,camp,frame,feet in re.findall(r'FLIGHT skill=(\d+) camp=(\d) frame=(\d+) feet=([-\d.eE+]+)',log):
    groups.setdefault((int(skill),int(camp)),{})[int(frame)]=float(feet)
assert len(groups)==6
for key,frames in groups.items():
    rise=[(f,y) for f,y in sorted(frames.items()) if 5<=f<=50]
    hover=[y for f,y in frames.items() if 50<=f<=110]
    landing=[y for f,y in frames.items() if 138<=f<145]
    assert len(rise)>=25 and len(hover)>=35 and landing,key
    assert rise[0][1]-rise[-1][1]>120,key
    assert max(hover)-min(hover)>5,key
    assert all(abs(y-5)<0.01 for y in landing),key
    moving=sorted((f,y) for f,y in frames.items() if 5<=f<=138)
    for (a,y),(b,z) in zip(moving,moving[1:]):
        assert abs(z-y)/(b-a)<7.1,(key,a,b,y,z)
    assert abs(frames[170]-5)<2.1,key # Super returns to Final idle (ground offset 3).
role=(BASE/'flight-verify/scripts/Processors/Game/Battle/Character/TRole.as').read_text(encoding='utf-8')
hook=role.index('this.PainFlightPose(_loc4_)')
gate=role.index('if(FBitmap.bitmapData != _loc5_')
end=role.index('{',gate)+1
depth=1
while depth:
    depth+=(role[end]=='{')-(role[end]=='}');end+=1
assert end<hook
assert hook<role.index('if(FCurrentRebirthSequence != null)')
assert '130 *' in role or '130*' in role
for token in ['RestorePainAfterRevival','ShowPainLaserImpact','UpdateObitoVfx','FPainFinal']:
    assert token in role,token
result.update(clientVersion='2026101956',flightCases=6)
(BASE/'validation/flight-final/verified.json').write_text(json.dumps(result,indent=2))
print('PASS six native Flash flight cases: continuous ascent/hover/descent, bounded speed, grounded return, per-tick hook outside bitmap-change gate, cleanup and preserved Final form')
