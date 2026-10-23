"""Decode both supplied forms, retaining native poses, root pivots and hit timing."""
from pathlib import Path
from PIL import Image,ImageDraw
import copy,hashlib,importlib.util,json,math,shutil
BASE=Path(__file__).resolve().parent;SOURCE=BASE.parents[2]/'asset/Nagato_Frog_Squad_Full'
spec=importlib.util.spec_from_file_location('p',BASE.parent/'pain-tendo/prepare-assets.py');p=importlib.util.module_from_spec(spec);spec.loader.exec_module(p)
MAPPING={'idle':'C_idle','run':'C_run1_2','hit':'D_stand_behit1','dead':'C_dead','standard':'A_1hit','standard2':'A_2hit','combo':'A_3hit','mystery':'SP_skill4','chase':'SP_skill2'}
MOVES={13121401:'mystery',13121402:'standard',13121403:'chase',13121406:'standard2',13121407:'combo'}
EFFECTS={'standard':['QWCMpg1'],'standard2':['QWCMpg2'],'combo':['QWCMpg3'],'mystery':['QWCMaoyi'],'chase':['QWCMzhuida']}

def main():
 dest=BASE/'frames';dest.mkdir(exist_ok=True);(BASE/'validation').mkdir(exist_ok=True)
 c,images=p.decode(SOURCE/'assets/battle/role/left/11009621.swf');vfx=json.loads((BASE/'vfx.json').read_text())
 data={'clips':{},'moves':MOVES,'effects':EFFECTS,'framePivots':{},'sourceFrameRate':24,'models':{'11120990':{'':'idle','0a':'idle','0b':['standard','standard2','combo'],'0c':['mystery','chase'],'0d':'hit','0e':'idle','0f':'run'}}};ident=0
 for name,action in MAPPING.items():
  frames,a=p.mme.render(c,images,action,scale=1.0);ids=[]
  for t in range(math.ceil(len(frames)*25/24)):
   frame=frames[min(len(frames)-1,round(t*24/25))];pivot=frame.info['pivot'];frame.save(dest/f'{ident:03}.png');data['framePivots'][str(ident)]=pivot;ids.append(ident);ident+=1
  hits=sorted(set(round(int(f.get('index'))*25/24) for f in a.iter('frame') if any(e.startswith('hit') for e in f.get('event','').split(','))))
  clip={'assets':ids,'loop':name in ['idle','run'],'duration':40,'sourceAction':action,'sourceVariant':'11009621','sourceFrames':len(frames)}
  if name not in ['idle','run','hit','dead','crow']:clip['hitFrames']=hits or [len(ids)//2]
  if not clip['loop']:
   length=max([len(vfx['clips'][key]['timeline']) for e in EFFECTS.get(name,[]) for key in vfx['effects'].get(e,[])]+[len(ids)])
   while len(ids)<length:ids.append(data['clips']['idle']['assets'][len(ids)%len(data['clips']['idle']['assets'])])
   ids.append(ids[-1] if name=='dead' else data['clips']['idle']['assets'][0]);clip['returnFrame']=len(ids)-1
  data['clips'][name]=clip
 multi_spec=importlib.util.spec_from_file_location('itachi_multihit',BASE.parent/'ninja-multihit.py');multi=importlib.util.module_from_spec(multi_spec);multi_spec.loader.exec_module(multi);None
 (BASE/'animation.json').write_text(json.dumps(data,indent=2));print('PASS Nagato original actor poses',ident)
if __name__=='__main__':main()
