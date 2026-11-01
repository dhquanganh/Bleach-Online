from pathlib import Path
import importlib.util,json,math,struct,zlib,shutil
from PIL import Image,ImageDraw
B=Path(__file__).resolve().parent;SOURCE=B.parents[2]/'asset/Hoichi_Full'
s=importlib.util.spec_from_file_location('mme',B.parent/'pain-tendo/prepare-assets.py');p=importlib.util.module_from_spec(s);s.loader.exec_module(p)
EFFECTS={'mystery':('fayi_faliaoyi','shang',0),'standard':('fayi_faliliansuopugong','shang',0),'pillars':('fayi_jiejieyu','shang',0),'barrage':('fayi_jiejiezhi','shang',0)}
def symbols(path):
 data=path.read_bytes();data=data[:8]+zlib.decompress(data[8:]) if data[:3]==b'CWS' else data
 pos=8+(5+4*(data[8]>>3)+7)//8+4;names={};lengths={}
 while pos<len(data):
  h=struct.unpack_from('<H',data,pos)[0];pos+=2;kind,size=h>>6,h&63
  if size==63:size=struct.unpack_from('<I',data,pos)[0];pos+=4
  body=data[pos:pos+size];pos+=size
  if kind==39:lengths[struct.unpack_from('<H',body)[0]]=struct.unpack_from('<H',body,2)[0]
  if kind in (56,76):
   q=2
   for _ in range(struct.unpack_from('<H',body)[0]):
    ident=struct.unpack_from('<H',body,q)[0];q+=2;end=body.index(0,q);name=body[q:end].decode();q=end+1
    if ident:names[name]=ident
 return {name:lengths.get(i,1) for name,i in names.items()}
def main():
 root,images=p.decode(SOURCE/'assets/battle/role/left/11015611.swf');mapping={'idle':'C_idle','run':'C_run1_2','hit':'D_stand_behit1','dead':'C_dead','pillars':'SP_skill3','standard':'A_1hit','mystery':'SP_skill1','barrage':'SP_skill2'}
 dest=B/'frames';dest.mkdir(exist_ok=True);public=B.parents[1]/'kaynak/login.gogames.me/public/hoichi-vfx/native';public.mkdir(parents=True,exist_ok=True)
 effects={}
 for move,(name,symbol,start) in EFFECTS.items():
  src=SOURCE/'assets/battle/effect'/f'{name}.swf';frames=symbols(src);assert symbol in frames
  effects[move]={'asset':name,'symbol':symbol,'startFrame':round(start*25/24),'sourceFrames':max(frames.get('shang',1),frames.get('xia',1)), 'symbols':frames};shutil.copy2(src,public/src.name)
 config=json.loads((B.parents[1]/'sunucu/hoichi.json').read_text());data={'clips':{},'moves':{config[k]['id']:config[k]['hoichiMove'] for k in ['mystery','standard','pillars','barrage']},'framePivots':{},'models':{'11121012':{'':'idle','0a':'idle','0b':'standard','0c':['mystery','pillars','barrage'],'0d':'hit','0e':'idle','0f':'run'}},'effects':effects,'scale':.84};index=0
 for name,action in mapping.items():
  frames,node=p.mme.render(root,images,action,scale=.84);ids=[];last=None
  for tick in range(math.ceil(len(frames)*25/24)):
   image=frames[min(len(frames)-1,round(tick*24/25))]
   if image.getbbox() is None:image=last or frames[0]
   else:last=image
   image.save(dest/f'{index:04}.png');data['framePivots'][str(index)]=[round(v) for v in image.info['pivot']];ids.append(index);index+=1
  hits=sorted(set(round(int(f.get('index'))*25/24) for f in node.iter('frame') if any(e.startswith('hit') for e in f.get('event','').split(','))))
  clip={'assets':ids,'loop':name in ['idle','run'],'duration':40,'sourceAction':action,'hitFrames':hits or [max(1,len(ids)//2)]}
  if not clip['loop']:
   if name in effects:
    effect=effects[name];end=effect['startFrame']+math.ceil(effect['sourceFrames']*25/24);ids.extend([ids[-1]]*max(0,end-len(ids)))
   ids.append(ids[-1] if name=='dead' else data['clips']['idle']['assets'][0]);clip['returnFrame']=len(ids)-1
  data['clips'][name]=clip
 (B/'animation.json').write_text(json.dumps(data,indent=2)+'\n')
 sheet=Image.new('RGB',(1000,600),'#253440');draw=ImageDraw.Draw(sheet)
 for n,name in enumerate(mapping):
  clip=data['clips'][name];asset=clip['assets'][min(len(clip['assets'])-1,len(clip['assets'])//2)];im=Image.open(dest/f'{asset:04}.png').convert('RGBA');px,py=data['framePivots'][str(asset)];x=(n%4)*250+120;y=(n//4)*300+255;sheet.paste(im,(x-px,y-py),im);draw.text(((n%4)*250+10,(n//4)*300+10),name,fill='white')
 sheet.save(B/'contact.jpg');print('PASS Hoichi original actor',index,'frames; native effects',effects)
if __name__=='__main__':main()
