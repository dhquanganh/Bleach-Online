from pathlib import Path
import importlib.util,json,math,shutil,struct,zlib
from PIL import Image
B=Path(__file__).resolve().parent;SOURCE=B.parents[2]/'asset/Tobi_Great_Ninja_War_Full'
s=importlib.util.spec_from_file_location('mme',B.parent/'pain-tendo/prepare-assets.py');p=importlib.util.module_from_spec(s);s.loader.exec_module(p)
def main():
 data={'clips':{},'moves':{13121801:'mystery',13121802:'standard',13121803:'line',13121804:'chase',13121805:'summit',13121806:'summon',13121807:'revive',13121808:'zetsu-attack',13121809:'zetsu-heal'},'framePivots':{},'models':{}};dest=B/'frames';dest.mkdir(exist_ok=True);ident=0
 for hero,path,mapping in [(11120995,SOURCE/'assets/battle/role/left/11015511.swf',{'idle':'C_idle','run':'C_run1_2','hit':'D_stand_behit1','dead':'C_dead','standard':'A_1iht','line':'A_3hit','mystery':'SP_skill1','chase':'SP_skill2','summit':'SP_skill3','summon':'SP_skill4','revive':'C_entry'}),(11120996,SOURCE/'White_Zetsu_Tobi_Summon/assets/battle/role/left/19019401.swf',{'zetsu-idle':'C_idle','zetsu-run':'C_run1_2','zetsu-hit':'D_stand_behit1','zetsu-dead':'C_dead','zetsu-entry':'C_entry','zetsu-attack':'SP_skill2','zetsu-heal':'SP_skill3'})]:
  c,images=p.decode(path)
  for name,action in mapping.items():
   frames,a=p.mme.render(c,images,action,scale=1);ids=[]
   for tick in range(math.ceil(len(frames)*25/24)):
    im=frames[min(len(frames)-1,round(tick*24/25))];im.save(dest/f'{ident:03}.png');data['framePivots'][str(ident)]=[round(x) for x in im.info['pivot']];ids.append(ident);ident+=1
   hits=sorted(set(round(int(f.get('index'))*25/24) for f in a.iter('frame') if any(e.startswith('hit') for e in f.get('event','').split(','))))
   clip={'assets':ids,'loop':name.endswith('idle') or name.endswith('run'),'duration':40,'sourceAction':action,'hitFrames':hits or [max(1,len(ids)//2)]}
   if not clip['loop']:
    idle=data['clips']['zetsu-idle' if hero==11120996 else 'idle']['assets'][0];ids.append(ids[-1] if name.endswith('dead') else idle);clip['returnFrame']=len(ids)-1
   data['clips'][name]=clip
  data['models'][str(hero)]={'':'idle','0a':'idle','0b':['standard','line'],'0c':['mystery','chase','summit','summon','revive'],'0d':'hit','0e':'idle','0f':'run'} if hero==11120995 else {'':'zetsu-idle','0a':'zetsu-idle','0b':'zetsu-attack','0c':['zetsu-entry','zetsu-dead','zetsu-heal'],'0d':'zetsu-hit','0e':'zetsu-idle','0f':'zetsu-run'}
 (B/'animation.json').write_text(json.dumps(data,indent=2)+'\n')
 # Keep original Flash layers: lossless source bitmaps, blending and nested timelines.
 public=B.parents[1]/'kaynak/login.gogames.me/public/tobi-war-vfx/native';public.mkdir(parents=True,exist_ok=True);symbols={}
 for src in (SOURCE/'assets/battle/effect').glob('Yuanquan*.swf'):
  raw=src.read_bytes();raw=raw[:8]+zlib.decompress(raw[8:]) if raw[:3]==b'CWS' else raw;pos=8+(5+4*(raw[8]>>3)+7)//8+4;names=[]
  while pos<len(raw):
   header=struct.unpack_from('<H',raw,pos)[0];pos+=2;kind,size=header>>6,header&63
   if size==63:size=struct.unpack_from('<I',raw,pos)[0];pos+=4
   body=raw[pos:pos+size];pos+=size
   if kind==76:
    q=2
    for _ in range(struct.unpack_from('<H',body)[0]):
     i=struct.unpack_from('<H',body,q)[0];q+=2;e=body.index(0,q);name=body[q:e].decode();q=e+1
     if i:names.append(name)
  symbols[src.stem]=names;shutil.copy2(src,public/src.name)
 (B/'symbols.json').write_text(json.dumps(symbols,indent=2));print('PASS',ident,'original Tobi/Zetsu frames;',symbols)
if __name__=='__main__':main()
