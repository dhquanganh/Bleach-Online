"""Decode both supplied forms, retaining native poses, root pivots and hit timing."""
from pathlib import Path
from PIL import Image,ImageDraw
import copy,hashlib,importlib.util,json,math,shutil
BASE=Path(__file__).resolve().parent;SOURCE=BASE.parents[2]/'asset/Itachi_Road_to_Ninja'
spec=importlib.util.spec_from_file_location('p',BASE.parent/'pain-tendo/prepare-assets.py');p=importlib.util.module_from_spec(spec);spec.loader.exec_module(p)
MAPPING={'idle':'C_idle','run':'C_run1_2','hit':'D_stand_behit1','dead':'C_dead','standard':'A_1hit','mystery':'SP_skill1','modified':'SP_skill1','deidara':'SP_skill2','pain':'SP_skill4','hidan':'SP_skill5','crow':'SP_skill6'}
MOVES={13121201:'mystery',13121202:'modified',13121203:'standard',13121204:'deidara',13121205:'pain',13121206:'hidan',13121207:'crow'}
EFFECTS={'standard':['YuzhiboyoRZZL_Huanshuxielunyan'],'mystery':['YuzhiboyoRZZL_Yongbingjituan_NZ'],'modified':['YuzhiboyoRZZL_Yongbingjituan_NZ'],'deidara':['YuzhiboyoRZZL_Yongbingjituan_QY'],'pain':['YuzhiboyoRZZL_Yongbingjituan_LB'],'hidan':['YuzhiboyoRZZL_Yongbingjituan_SB'],'crow':['YuzhiboyoRZZL_Yafenshenzhishu']}
def main():
 dest=BASE/'frames';dest.mkdir(exist_ok=True);(BASE/'validation').mkdir(exist_ok=True)
 c,images=p.decode(SOURCE/'assets/battle/role/left/11008581.swf');vfx=json.loads((BASE/'vfx.json').read_text())
 data={'clips':{},'moves':MOVES,'effects':EFFECTS,'framePivots':{},'sourceFrameRate':24,'models':{'11120960':{'':'idle','0a':'idle','0b':'standard','0c':['mystery','modified','deidara','pain','hidan','crow'],'0d':'hit','0e':'idle','0f':'run'}}};ident=0
 for name,action in MAPPING.items():
  frames,a=p.mme.render(c,images,action,scale=1.0);ids=[]
  for t in range(math.ceil(len(frames)*25/24)):
   frame=frames[min(len(frames)-1,round(t*24/25))];pivot=frame.info['pivot'];frame.save(dest/f'{ident:03}.png');data['framePivots'][str(ident)]=pivot;ids.append(ident);ident+=1
  hits=sorted(set(round(int(f.get('index'))*25/24) for f in a.iter('frame') if 'hit' in f.get('event','').split(',')))
  clip={'assets':ids,'loop':name in ['idle','run'],'duration':40,'sourceAction':action,'sourceVariant':'11008581','sourceFrames':len(frames)}
  if name not in ['idle','run','hit','dead','crow']:clip['hitFrames']=hits or [len(ids)//2]
  if not clip['loop']:
   length=max([72 if name=='standard' else 0]+[len(vfx['clips'][key]['timeline']) for e in EFFECTS.get(name,[]) for key in vfx['effects'].get(e,[])]+[len(ids)])
   while len(ids)<length:ids.append(data['clips']['idle']['assets'][len(ids)%len(data['clips']['idle']['assets'])])
   ids.append(ids[-1] if name=='dead' else data['clips']['idle']['assets'][0]);clip['returnFrame']=len(ids)-1
  data['clips'][name]=clip
 multi_spec=importlib.util.spec_from_file_location('itachi_multihit',BASE.parent/'ninja-multihit.py');multi=importlib.util.module_from_spec(multi_spec);multi_spec.loader.exec_module(multi);multi.configure(BASE.name,data)
 (BASE/'animation.json').write_text(json.dumps(data,indent=2));print('PASS Itachi original actor poses',ident)
if __name__=='__main__':main()
