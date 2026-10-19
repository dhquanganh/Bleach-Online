"""Resample supplied Hashirama MME poses without empty cinematic frames."""
from pathlib import Path
from PIL import Image,ImageDraw
import importlib.util,json,math,hashlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('pain',BASE.parent/'pain-tendo/prepare-assets.py');p=importlib.util.module_from_spec(spec);spec.loader.exec_module(p)
SOURCE=BASE.parents[2]/'asset/Hashirama_Senju_Final_Battle'
MAPPING={'idle':'C_idle','run':'C_run1_2','hit':'D_stand_behit1','dead':'C_dead','taijutsu':'A_1hit','sword':'A_4hit','deity':'SP_skill6','rumbling':'SP_skill5','adamantine':'SP_skill_2','severe':'SP_skill_22','burst-severe':'SP_skill_22','golem':'SP_skill_44','forest':'SP_skill8','burst':'C_skillIdle_1'}
MOVES={13121001:'deity',13121002:'rumbling',13121003:'adamantine',13121004:'severe',13121005:'burst-severe',13121006:'taijutsu',13121007:'sword',13121008:'golem',13121009:'forest',13121010:'burst'}
EFFECTS={'deity':['Zhujianzhongyanmingshenfenglong','Zhujianzhongyanmingshenfenglong_texie'],'rumbling':['Hashirama-thousand-hands-cinematic'],'severe':['Zhujianzhongyanbangpaizhishu'],'burst-severe':['Zhujianzhongyanbangpaizhishu'],'forest':['Zhujianzhongyanhuashujiejianglin']}
def main():
 c,images=p.decode(SOURCE/'assets/battle/role/left/11003341.swf');vfx=json.loads((BASE/'vfx.json').read_text())
 dest=BASE/'frames';dest.mkdir(exist_ok=True);preview=BASE/'validation';preview.mkdir(exist_ok=True)
 idle,_=p.mme.render(c,images,'C_idle',scale=.85)
 data={'clips':{},'framePivots':{},'moves':MOVES,'effects':EFFECTS,'sourceFrameRate':24,'models':{'11120940':{'':'idle','0a':'idle','0b':['taijutsu','sword'],'0c':['deity','rumbling','adamantine','severe','burst-severe','golem','forest','burst'],'0d':'hit','0e':'idle','0f':'run'}}}
 ident=0
 for name,action in MAPPING.items():
  # The summoned statue is a separate native layer, not the forest-root FX.
  # Fit it to the combat viewport while retaining Hashirama's normal body size.
  config=c
  if name=='golem':
   import copy
   config=copy.deepcopy(c)
   summon=next(a for a in config.findall('action') if a.get('name')==action)
   layer=next(l for l in summon.findall('layer') if l.get('id')=='2')
   for element in layer.iter('element'):
    for attr in ['scaleX','scaleY']:element.set(attr,str(float(element.get(attr,1))*.60))
    element.set('x',str(float(element.get('x',0))*.60))
    element.set('y',str((float(element.get('y',0))-50)*.60))
  frames,a=p.mme.render(config,images,action,scale=.85);indices=[min(len(frames)-1,round(t*24/25)) for t in range(math.ceil(len(frames)*25/24))];ids=[];recovered=0
  for tick,i in enumerate(indices):
   im=frames[i]
   if not im.getbbox():im=idle[tick%len(idle)];recovered+=1
   if name in ['taijutsu','sword','adamantine','severe','burst-severe']:
    # Remove source locomotion from the actor root; runtime owns the approach.
    # Keep the source vertical jump and every original pose/weapon pixel.
    body=next(layer for layer in a.findall('layer') if layer.get('id')=='1')
    frame=next((f for f in body.findall('frame') if int(f.get('index'))<=i<int(f.get('index'))+int(f.get('length'))),None)
    element=frame.find('element') if frame is not None else None
    if element is not None:
     im=im.copy();px,py=im.info['pivot'];im.info['pivot']=[px+round(float(element.get('x',0))*.85),py]
   # Cinematic source pivots can move actors far outside the battle viewport.
   if name in ['deity','rumbling','forest','burst']:
    im=im.copy();px,py=im.info['pivot'];im.info['pivot']=[px, min(py,im.height+25)]
   im.save(dest/f'{ident:03}.png');data['framePivots'][str(ident)]=im.info['pivot'];ids.append(ident);ident+=1
  clip={'assets':ids,'duration':40,'loop':name in ['idle','run'],'sourceAction':action,'sourceFrames':len(frames),'recoveredFrames':recovered}
  hits=sorted(set(round(int(f.get('index'))*25/24) for f in a.iter('frame') if 'hit' in f.get('event','').split(',')))
  if name not in ['idle','run','dead','hit','forest','burst']:clip['hitFrames']=[hits[0] if hits else len(ids)//2]
  if not clip['loop']:
   length=max([len(vfx['clips'][k]['timeline']) for effect in EFFECTS.get(name,[]) for k in vfx['effects'][effect]]+[len(ids)])
   while len(ids)<length:ids.append(data['clips']['idle']['assets'][len(ids)%len(data['clips']['idle']['assets'])])
   ids.append(ids[-1] if name=='dead' else data['clips']['idle']['assets'][0]);clip['returnFrame']=len(ids)-1
  data['clips'][name]=clip
  print(name,len(ids),'frames; recovered',recovered)
 # Decode both supplied map/showcase variants for validation and native UI.
 for variant in ['11003341','11003351']:
  for source,label in [(f'assets/user/ninja/ninjaImg/{variant}.swf','showcase'),(f'assets/role/npc/scene/npcres/{variant}_outdoor.swf','outdoor')]:
   conf,ims=p.decode(SOURCE/source);action=next(a.get('name') for a in conf.findall('action') if a.get('name') in ['C_idle','idle','idle_0']);im=p.mme.render(conf,ims,action,scale=1)[0][0];im.save(preview/(label+'-'+variant+'.png'))
 (BASE/'animation.json').write_text(json.dumps(data,indent=2))
 for item in json.loads((SOURCE/'manifest.json').read_text()):assert hashlib.sha256((SOURCE/item['file']).read_bytes()).hexdigest()==item['sha256']
 print('PASS Hashirama source frames and all supplied file checksums')
if __name__=='__main__':main()
