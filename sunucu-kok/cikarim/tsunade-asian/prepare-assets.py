"""Decode the supplied Tsunade source poses, retaining root pivots and hit timing."""
from pathlib import Path
from PIL import Image,ImageDraw
import copy,hashlib,importlib.util,json,math,shutil
BASE=Path(__file__).resolve().parent;SOURCE=BASE.parents[2]/'asset/Tsunade_Asian_Style_Full'
spec=importlib.util.spec_from_file_location('p',BASE.parent/'pain-tendo/prepare-assets.py');p=importlib.util.module_from_spec(spec);spec.loader.exec_module(p)
MAPPING={'idle':'C_idle','run':'C_run1_2','hit':'D_stand_behit1','dead':'C_dead','standard':'A_3hit','mystery':'SP_skill1','healing':'SP_skill1_1','revival':'SP_skill3','summoning':'SP_skill2','healingMystery':'SP_skill1_1'}
MOVES={13121601:'mystery',13121602:'standard',13121603:'healing',13121604:'revival',13121605:'summoning',13121606:'healingMystery'}
EFFECTS={'standard':['gangshou_pugong'],'mystery':['gangshou_aoyi1_niansuan','gangshou_aoyi1_niansuantexie'],'healing':['gangshou_aoyi2_dazhiliao'],'revival':['gangshou_chufa2_texie'],'summoning':['qusanqidong'],'healingMystery':['gangshou_aoyi2_dazhiliao']}

def main():
 dest=BASE/'frames';dest.mkdir(exist_ok=True);(BASE/'validation').mkdir(exist_ok=True)
 c,images=p.decode(SOURCE/'assets/battle/role/left/11002371.swf');vfx=json.loads((BASE/'vfx.json').read_text())
 data={'clips':{},'moves':MOVES,'effects':EFFECTS,'framePivots':{},'sourceFrameRate':24,'models':{'11120992':{'':'idle','0a':'idle','0b':'standard','0c':['mystery','healing','revival','summoning','healingMystery'],'0d':'hit','0e':'idle','0f':'run'}}};ident=0
 for name,action in MAPPING.items():
  frames,a=p.mme.render(c,images,action,scale=1.0);ids=[]
  for t in range(math.ceil(len(frames)*25/24)):
   frame=frames[min(len(frames)-1,round(t*24/25))];pivot=frame.info['pivot'];frame.save(dest/f'{ident:03}.png');data['framePivots'][str(ident)]=pivot;ids.append(ident);ident+=1
  hits=sorted(set(round(int(f.get('index'))*25/24) for f in a.iter('frame') if any(e.startswith('hit') for e in f.get('event','').split(','))))
  clip={'assets':ids,'loop':name in ['idle','run'],'duration':40,'sourceAction':action,'sourceVariant':'11002371','sourceFrames':len(frames)}
  if name not in ['idle','run','hit','dead','standard']:clip['hitFrames']=hits or [len(ids)//2]
  if not clip['loop']:
   length=max([len(vfx['clips'][key]['timeline']) for e in EFFECTS.get(name,[]) for key in vfx['effects'].get(e,[])]+[len(ids)])
   while len(ids)<length:ids.append(ids[-1])
   ids.append(ids[-1] if name=='dead' else data['clips']['idle']['assets'][0]);clip['returnFrame']=len(ids)-1
  data['clips'][name]=clip
 multi_spec=importlib.util.spec_from_file_location('itachi_multihit',BASE.parent/'ninja-multihit.py');multi=importlib.util.module_from_spec(multi_spec);multi_spec.loader.exec_module(multi);None
 (BASE/'animation.json').write_text(json.dumps(data,indent=2));print('PASS Tsunade original actor poses',ident)
if __name__=='__main__':main()
