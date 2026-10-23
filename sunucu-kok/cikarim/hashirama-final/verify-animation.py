"""Independent source-frame and native overlap checks for the animation repair."""
from pathlib import Path
from PIL import Image
import importlib.util,json,re
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('m',BASE.parent/'shared-animation/mme.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
source=BASE.parents[2]/'asset/Hashirama_Senju_Final_Battle/assets/battle/role/left/11003341.swf'
conf,images=m.decode(source);removed=0
for frame in conf.iter('frame'):
 for e in list(frame.findall('element')):
  if e.get('extname'):frame.remove(e);removed+=1
assert removed==85,'Test fixture must exercise all external shadow references'
animation=json.loads((BASE/'animation.json').read_text());checked=0
for name in ['taijutsu','sword','adamantine','severe','burst-severe','burst']:
 clip=animation['clips'][name];frames,action=m.render(conf,images,clip['sourceAction'],scale=.85)
 for out in [0,5,14,19,23,30,42]:
  i=round(out*24/25)
  if i>=len(frames):continue
  expected=frames[i];ident=clip['assets'][out];actual=Image.open(BASE/'frames'/f'{ident:03}.png').convert('RGBA')
  assert actual.size==expected.size and actual.tobytes()==expected.tobytes(),(name,out,'external shadow became a second actor')
  px,py=expected.info['pivot']
  if name!='burst':
   layer=next(l for l in action.findall('layer') if l.get('id')=='1')
   frame=next(f for f in layer.findall('frame') if int(f.get('index'))<=i<int(f.get('index'))+int(f.get('length')))
   body=frame.find('element')
   if body is not None:px+=round(float(body.get('x',0))*.85)
  assert animation['framePivots'][str(ident)]==[px,py],(name,out,'actor root drift')
  checked+=1
# Independently reconstruct the native summon layer; roots must never replace it.
import copy,math
summon=copy.deepcopy(conf)
a=next(a for a in summon.findall('action') if a.get('name')=='SP_skill_44')
l=next(l for l in a.findall('layer') if l.get('id')=='2')
for e in l.iter('element'):
 for attr in ['scaleX','scaleY']:e.set(attr,str(float(e.get(attr,1))*.47))
 e.set('x',str(float(e.get('x',0))*.47));e.set('y',str((float(e.get('y',0))-50)*.47))
source_frames,_=m.render(summon,images,'SP_skill_44',scale=.85)
for tick in [0,6,16,19,30,42,51]:
 expected=source_frames[min(len(source_frames)-1,round(tick*24/25))]
 ident=animation['clips']['golem']['assets'][tick]
 actual=Image.open(BASE/'frames'/f'{ident:03}.png').convert('RGBA')
 assert actual.size==expected.size and actual.tobytes()==expected.tobytes(),('summon pixels',tick)
 assert animation['framePivots'][str(ident)]==expected.info['pivot']
 if tick in [16,19,30]:assert 200<actual.height<340 and actual.width<500,('summon cropped/oversized',tick)
assert 'golem' not in animation['effects'],'Forest roots must not obscure Wood Fist'
spec=importlib.util.spec_from_file_location('builder',BASE/'build-client.py');builder=importlib.util.module_from_spec(spec);spec.loader.exec_module(builder)
manifest=builder.effect_manifest();ground=manifest['clips']['Zhujianzhongyanbangpaizhishu-54'];anchor=manifest['effectAnchors']['Zhujianzhongyanbangpaizhishu']
# Both mirrored orientations and scaled containers map the same crater contact to the target feet.
for facing in [-1,1]:
 for fit in [.45,.8,1.2]:
  tx,ty=820,395
  x=tx-anchor[0]*fit*facing+(.53-ground['pivot'][0])*ground['width']/ground['renderScale']*fit*facing
  y=ty-anchor[1]*fit+(.68-ground['pivot'][1])*ground['height']/ground['renderScale']*fit
  assert abs(x-tx)<1e-6 and abs(y-ty)<1e-6
assert animation['clips']['burst']['sourceAction']=='C_skillIdle_1'
role=(BASE/'verify/scripts/Processors/Game/Battle/Character/TRole.as').read_text()
for token in ['castSerial','rodSerial','caster.FFrameIndex','FCombatVfxSerial','Math.max(0,caster.FFrameIndex)']:assert token in role,token
gate=role.index('if(FBitmap.bitmapData != _loc5_');end=role.index('{',gate)+1;depth=1
while depth:depth+=(role[end]=='{')-(role[end]=='}');end+=1
for name in ['PainStrikePose','HashiramaStrikePose']:assert role.index('this.'+name+'(_loc4_)')>end,name
assert 'skill == 13120975 ? 1000' in role
start=role.index('private function ShowHashiramaVfx(');end=role.index('private function HashiramaStrikePose(',start)
assert 'Zhujianzhongyanshujiejiangdan' not in role[start:end]
assert 'FSkillId == 13121008 ? 190' in role[end:]
assert animation['clips']['golem']['hitFrames']==[19] and animation['clips']['golem']['returnFrame']==53
motion=json.loads((BASE.parent/'pain-tendo/validation/motion-final/result.json').read_text())
assert motion['completed'] and motion['cases']==6 and not motion['errors'] and motion['remainingLayers']==0
stress=json.loads((BASE/'validation/stress/result.json').read_text())
assert stress['completed'] and stress['cases']==4 and not stress['errors'] and stress['remainingLayers']==0
log=(BASE/'validation/stress/runtime.log').read_text()
checks=re.findall(r'LAYERS_OK slot=(\d+) skill=(\d+) count=(\d+) bound=(\d+)',log)
assert len(checks)==4 and all(int(count)<=int(bound)==3 for _,_,count,bound in checks)
result={'client':'2026101960','summonFrames':7,'groundContacts':6,'sourceShadowReferencesRemoved':removed,'independentSourceFrames':checked,'PainMotionCases':6,'sameSkillInterruptedCasts':4,'overlapChecks':checks}
(BASE/'validation/animation-repair.json').write_text(json.dumps(result,indent=2))
print('PASS seven native summon frames and six mirrored/scaled ground contacts; independent source pixels/root pivots:',checked,'frames;',removed,'external shadows excluded; Pain geometry and per-tick hooks; four interrupted/repeated same-skill casts have <=3 layers and zero leftovers')
