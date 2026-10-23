"""Decode every supplied Pain file and preserve the original MME choreography."""
from pathlib import Path
from PIL import Image
import importlib.util,json,math,hashlib,shutil
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('mme',BASE.parent/'shared-animation/mme.py');mme=importlib.util.module_from_spec(spec);spec.loader.exec_module(mme)
SOURCE=BASE.parents[2]/'asset/Pain_Tendo_Six_Paths_Rinnegan'
MAPPING={'idle':'C_idle','run':'C_run1_2','hit':'D_stand_behit1','dead':'C_dead','standard':'A_1hit','almighty':'SP_skill4','extreme':'SP_skill1','chase':'SP_skill2','laser':'SP_skill5','revive':'SP_skill7','final-revive':'SP_skill6','super':'SP_skill1'}
MOVES={13120971:'almighty',13120972:'extreme',13120973:'extreme',13120974:'standard',13120975:'chase',13120976:'laser',13120977:'revive',13120978:'final-revive',13120979:'super'}
EFFECTS={'almighty':['PEaoyi1'],'extreme':['Peienchaoshenshenluotianzheng_aoyi'],'standard':['PEpugong1'],'chase':['PEzhuida'],'laser':['PEaoyi2'],'revive':['DASHEWAN_tongyongfuhuo'],'final-revive':['DASHEWAN_tongyongfuhuo'],'super':['Peienchaoshenshenluotianzheng_aoyi']}
def decode(path):
 c,images=mme.decode(path)
 # Source XML contains repeated asset references without className after the real
 # bitmap definition. Keep the first complete definition instead of shadowing it.
 seen=set()
 for a in list(c.findall('asset')):
  if not a.get('className') or a.get('id') in seen:c.remove(a)
  else:seen.add(a.get('id'))
 # extname references an external sprite (usually the ground shadow). Its assetId
 # is a placeholder, NOT an index into this SWF's embedded character bitmaps.
 for frame in c.iter('frame'):
  for element in list(frame.findall('element')):
   if element.get('extname'):frame.remove(element)
 return c,images
def main():
 config,images=decode(SOURCE/'assets/battle/role/left/11006531.swf')
 dest=BASE/'frames';dest.mkdir(exist_ok=True);preview=BASE/'validation';preview.mkdir(exist_ok=True)
 vfx=json.loads((BASE/'vfx.json').read_text());ident=0
 data={'clips':{},'framePivots':{},'moves':MOVES,'effects':EFFECTS,'sourceFrameRate':24,'models':{'11120930':{'':'idle','0a':'idle','0b':'standard','0c':['almighty','extreme','chase','laser','revive','final-revive','super'],'0d':'hit','0e':'idle','0f':'run'}}}
 for name,action_name in MAPPING.items():
  frames,action=mme.render(config,images,action_name,scale=1.05 if name=='chase' else .85)
  indices=[min(len(frames)-1,round(t*24/25)) for t in range(math.ceil(len(frames)*25/24))];ids=[]
  last_visible=None;recovered=0
  for i in indices:
   image=frames[i]
   if name=='chase' and image.getbbox() is None:
    image=Image.open(dest/f'{data["clips"]["idle"]["assets"][i%len(data["clips"]["idle"]["assets"])]:03}.png').convert('RGBA')
    image.info['pivot']=data['framePivots'][str(data['clips']['idle']['assets'][i%len(data['clips']['idle']['assets'])])]
   if name in ['extreme','super']:
    # The source movie removes the actor during its full-screen cinematic. Our battle
    # keeps the actor on stage: hold its airborne pose instead of installing empty cells.
    if image.getbbox() is None:
     assert last_visible is not None
     image=last_visible;recovered+=1
    else:last_visible=image
    image=image.copy();px,py=image.info['pivot'];image.info['pivot']=[px,min(py,230)]
   image.save(dest/f'{ident:03}.png');data['framePivots'][str(ident)]=image.info['pivot'];ids.append(ident);ident+=1
  clip={'assets':ids,'duration':40,'loop':name in ['idle','run'],'sourceAction':action_name,'sourceFrames':len(frames)}
  if recovered:clip['visibleHoldFrames']=recovered
  hits=sorted(set(round(int(f.get('index'))*25/24) for f in action.iter('frame') if any(e.startswith('hit') for e in f.get('event','').split(','))))
  if name not in ['idle','run','dead','hit','revive','final-revive']:clip['hitFrames']=[hits[0]] if hits else [len(ids)//2]
  if not clip['loop']:
   length=max([len(vfx['clips'][k]['timeline']) for effect in EFFECTS.get(name,[]) for k in vfx['effects'][effect]]+[len(ids)])
   ids.extend([ids[-1]]*max(0,length-len(ids)));ids.append(data['clips']['idle']['assets'][0]);clip['returnFrame']=len(ids)-1
  data['clips'][name]=clip
  gif=[]
  for asset in ids[:len(indices)]:
   image=Image.open(dest/f'{asset:03}.png').convert('RGBA');px,py=data['framePivots'][str(asset)]
   bg=Image.new('RGBA',(1100,760),'#263746');bg.alpha_composite(image,(450-px,600-py));bg.thumbnail((660,456));gif.append(bg.convert('RGB'))
  gif[0].save(preview/(name+'.gif'),save_all=True,append_images=gif[1:],duration=40,loop=0)
 # The final standing pose of SP_skill7 is the open-coat form shown after revival.
 # Keep it as a separate looping battle idle; lobby/map/base form retain C_idle.
 final_frames,_=mme.render(config,images,'SP_skill7',scale=.85)
 final_frames=final_frames[23:]
 final_ids=[]
 for t in range(math.ceil(len(final_frames)*25/24)):
  image=final_frames[min(len(final_frames)-1,round(t*24/25))]
  assert image.getbbox() is not None
  image.save(dest/f'{ident:03}.png');data['framePivots'][str(ident)]=image.info['pivot'];final_ids.append(ident);ident+=1
 data['clips']['final-idle']={'assets':final_ids,'duration':40,'loop':True,'sourceAction':'SP_skill7','sourceStartFrame':23,'sourceFrames':len(final_frames)}
 data['models']['11120930']['0a']=['idle','final-idle']
 for name in ['revive','final-revive','super']:data['clips'][name]['assets'][-1]=final_ids[0]
 # Both other supplied MME assets are decoded for UI/map previews.
 for source,label in [('assets/user/ninja/ninjaImg/11006531.swf','showcase'),('assets/role/npc/scene/npcres/11006531_outdoor.swf','outdoor')]:
  c,ims=decode(SOURCE/source);action=next(a.get('name') for a in c.findall('action') if a.get('name') in ['C_idle','idle','idle_0']);im=mme.render(c,ims,action,scale=1)[0][0];im.save(preview/(label+'.png'))
 mspec=importlib.util.spec_from_file_location('multihit',BASE.parent/'ninja-multihit.py');multi=importlib.util.module_from_spec(mspec);mspec.loader.exec_module(multi)
 multi.configure(BASE.name,data)
 (BASE/'animation.json').write_text(json.dumps(data,indent=2))
 for item in json.loads((SOURCE/'manifest.json').read_text()):assert hashlib.sha256((SOURCE/item['file']).read_bytes()).hexdigest()==item['sha256']
 print('PASS',ident,'Pain playback frames;',len(data['clips']),'clips; eight supplied assets verified')
if __name__=='__main__':main()
