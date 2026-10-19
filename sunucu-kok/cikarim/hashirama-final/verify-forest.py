"""Check actual Flash entrance geometry with empty targets and different caster rows."""
from pathlib import Path
import importlib.util,json,re

BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('builder',BASE/'build-client.py')
builder=importlib.util.module_from_spec(spec);spec.loader.exec_module(builder)
manifest=builder.effect_manifest()
result=json.loads((BASE/'validation/forest/result.json').read_text())
assert result['completed'] and result['cases']==4 and result['assetPlays']==8
assert not result['errors'] and result['remainingLayers']==0
log=(BASE/'validation/forest/runtime.log').read_text()
pattern=r'ANCHOR skill=13121009 layer=(\S+) camp=(\d) x=([^ ]+) y=([^ ]+) width=([^ ]+) height=([^\r\n]+)'
rows=re.findall(pattern,log);assert len(rows)==8
geometry={}
for name,camp,x,y,w,h in rows:
    x,y,w,h=map(float,[x,y,w,h]);px,py=manifest['clips'][name]['pivot']
    left=x-w*(px if camp=='0' else 1-px)
    right=x+w*(1-px if camp=='0' else px)
    top=y-h*py;bottom=y+h*(1-py)
    assert 24-1e-5<=left<=right<=1226+1e-5,(name,camp,'horizontal clipping')
    assert 143-1e-5<=top<=bottom<=585+1e-5,(name,camp,'vertical clipping')
    key=(name,camp);value=(x,y,w,h)
    if key in geometry:assert geometry[key]==value,'Caster row changed the forest position'
    geometry[key]=value
assert len(geometry)==4
role_path=Path('Processors/Game/Battle/Character/TRole.as')
before=(BASE/'animation-original/scripts'/role_path).read_text()
after=(BASE/'verify/scripts'/role_path).read_text()
def method(source,name):
    start=re.search(r'      private (?:static )?function '+name+r'\(',source).start()
    return source[start:builder.method_end(source,start)]
for name in ['PainStrikePose','ShowPainVfx','PlayPainVfxAsset','RestorePainAfterRevival','HashiramaStrikePose','ShowHashiramaImpact']:
    assert method(before,name)==method(after,name),('Unrelated animation changed',name)
loader=method(after,'PlayHashiramaVfxAsset')
assert 'if(FSkillId == 13121009)' in loader and 'host.addChildAt(layer,0)' in loader
assert 'caster.FResults=[]' in (BASE/'probe-source/TApplication.as').read_text()
print('PASS four empty-target entrance cases: both camps/rows, eight unclipped layers, stable ground placement, zero leftovers; Pain and other Hashirama poses unchanged')
