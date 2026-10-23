"""Enlarge only the native summoned Golem layer, without scaling Hashirama."""
from pathlib import Path
from PIL import Image
import copy,importlib.util,json,sys
BASE=Path(__file__).resolve().parent
sys.path.insert(0,str(BASE.parent/'naruto-sage'))
spec=importlib.util.spec_from_file_location('p',BASE.parent/'pain-tendo/prepare-assets.py');p=importlib.util.module_from_spec(spec);spec.loader.exec_module(p)
spec=importlib.util.spec_from_file_location('packed',BASE.parent/'shared-animation/packing.py');packed=importlib.util.module_from_spec(spec);spec.loader.exec_module(packed);n=packed.native
source=BASE.parents[2]/'asset/Hashirama_Senju_Final_Battle/assets/battle/role/left/11003341.swf'
conf,images=p.decode(source);conf=copy.deepcopy(conf)
action=next(a for a in conf.findall('action')if a.get('name')=='SP_skill_44');layer=next(l for l in action.findall('layer')if l.get('id')=='2')
for e in layer.iter('element'):
 for attr in ['scaleX','scaleY']:e.set(attr,str(float(e.get(attr,1))*.60))
 e.set('x',str(float(e.get('x',0))*.60));e.set('y',str((float(e.get('y',0))-50)*.60))
frames,_=p.mme.render(conf,images,'SP_skill_44',scale=.85)
data=json.loads((BASE/'animation.json').read_text());clip=data['clips']['golem'];changed=0
for tick,ident in enumerate(clip['assets'][:-1]):
 i=min(len(frames)-1,round(tick*24/25));im=frames[i]
 if not im.getbbox():continue
 im.save(BASE/'frames'/f'{ident:03}.png');data['framePivots'][str(ident)]=list(im.info['pivot']);changed+=1
assert clip['hitFrames'][0]==19 and clip['returnFrame']==53
(BASE/'animation.json').write_text(json.dumps(data,indent=2))
hero=11120940;suffix='0c';ident=int(f'{hero:X}'+suffix,16);sequences=[]
for name in data['models'][str(hero)][suffix]:
 c=data['clips'][name];ims=[Image.open(BASE/'frames'/f'{i:03}.png').convert('RGBA')for i in c['assets']]
 sequences.append(dict(frames=ims,loop=c['loop'],duration=40,pivots=[tuple(data['framePivots'][str(i)])for i in c['assets']]))
texture=n.texture_sequences(ident,sequences)
for version in ['2017112917','2026090619']:
 dest=n.PUBLIC/version/'Resources/Textures/Model'/f'{ident:08X}.TexClient';dest.write_bytes(texture)
print('PASS Golem source-detail summon .47 -> .60:',changed,'frames; body size/hit marker/return marker preserved, both native resource versions installed')
