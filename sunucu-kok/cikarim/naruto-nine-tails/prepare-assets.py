from pathlib import Path
import importlib.util,json,math
B=Path(__file__).resolve().parent;SOURCE=B.parents[2]/'asset/Naruto_Nine_Tails_Chakra_Full'
s=importlib.util.spec_from_file_location('mme',B.parent/'pain-tendo/prepare-assets.py');p=importlib.util.module_from_spec(s);s.loader.exec_module(p)
MAPPING={'idle':'C_idle','run':'C_run1_2','hit':'D_stand_behit1','dead':'C_dead','standard':'A_1hit','standard2':'A_2hit','combo':'A_3hit','mystery':'SP_skill1','healing':'SP_skill2'}
MOVES={13121701:'mystery',13121702:'standard',13121703:'standard2',13121704:'combo',13121706:'healing'}
EFFECTS={'standard':['1nrvDaji_lizi_quan'],'standard2':['1nrvDaji_lizi_quan'],'combo':['1nrvDaji_lizi_quan'],'mystery':['1nrv_luoxuanwan'],'healing':['MRzy']}
def main():
 dest=B/'frames';dest.mkdir(exist_ok=True);c,images=p.decode(SOURCE/'assets/battle/role/left/11000131.swf');vfx=json.loads((B/'vfx.json').read_text())
 data={'clips':{},'moves':MOVES,'effects':EFFECTS,'framePivots':{},'sourceFrameRate':24,'models':{'11120994':{'':'idle','0a':'idle','0b':['standard','standard2','combo'],'0c':['mystery','healing'],'0d':'hit','0e':'idle','0f':'run'}}};ident=0
 for name,action in MAPPING.items():
  frames,a=p.mme.render(c,images,action,scale=1.0);ids=[]
  root_frames=list(a.find('layer').findall('frame'))
  for t in range(math.ceil(len(frames)*25/24)):
   source_tick=min(len(frames)-1,round(t*24/25));frame=frames[source_tick];frame.save(dest/f'{ident:03}.png');pivot=list(frame.info['pivot'])
   if name in ['standard','standard2','combo','mystery']:
    root=next((f for f in root_frames if int(f.get('index'))<=source_tick<int(f.get('index'))+int(f.get('length','1'))),None)
    if root is not None and root.find('element') is not None:pivot[0]+=float(root.find('element').get('x','0'))
   data['framePivots'][str(ident)]=[round(v) for v in pivot];ids.append(ident);ident+=1
  hits=sorted(set(round(int(f.get('index'))*25/24) for f in a.iter('frame') if any(e.startswith('hit') for e in f.get('event','').split(','))))
  clip={'assets':ids,'loop':name in ['idle','run'],'duration':40,'sourceAction':action,'sourceFrames':len(frames),'hitFrames':hits or [len(ids)//2]}
  if not clip['loop']:
   # Retain complete original FX tails before returning to idle.
   length=max([len(vfx['clips'][key]['timeline']) for effect in EFFECTS.get(name,[]) for key in vfx['effects'].get(effect,[])]+[len(ids)])
   while len(ids)<length:ids.append(ids[-1])
   ids.append(ids[-1] if name=='dead' else data['clips']['idle']['assets'][0]);clip['returnFrame']=len(ids)-1
  data['clips'][name]=clip
 (B/'animation.json').write_text(json.dumps(data,indent=2)+'\n');print('PASS original Naruto poses',ident,'lossless frames')
if __name__=='__main__':main()
