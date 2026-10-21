"""Decode Sasuke's own actions, preserving root coordinates and separate forms."""
from pathlib import Path
from PIL import Image,ImageDraw
import hashlib,importlib.util,json,math
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1];SOURCE=ROOT.parent/'asset/Sasuke_Shinden_Full'
s=importlib.util.spec_from_file_location('p',BASE.parent/'pain-tendo/prepare-assets.py');p=importlib.util.module_from_spec(s);s.loader.exec_module(p)
MAPPING={'idle':'C_idle','run':'C_run1_2','hit':'D_stand_behit1','dead':'C_dead','mystery':'SP_skill1','blazeMystery':'SP_skill1_yan','standard':'A_3hit','blazeStandard':'A_3hit_yan','dragon':'SP_skill2','blazeDragon':'SP_skill2_yan','mangekyo':'SP_skill3','rinnegan':'SP_skill4','susanoo':'SP_skill5'}
FX={'mystery':['ZuozhuZZZZ_qilin','ZuozhuZZZZ_qilin_texie'],'blazeMystery':['ZuozhuZZZZ_qilin_yan','ZuozhuZZZZ_qilin_yantexie'],'standard':['ZuozhuZZZZ_qianniaodao3'],'blazeStandard':['ZuozhuZZZZ_qianniaodao3'],'dragon':['ZuozhuZZZZ_haolonghuo'],'blazeDragon':['ZuozhuZZZZ_haolonghuoyan'],'susanoo':['ZuozhuZZZZ_xuzuobati'],'mangekyo':[],'rinnegan':[]}
def main():
 for item in json.loads((SOURCE/'manifest.json').read_text())['files']:assert hashlib.sha256((SOURCE/item['file']).read_bytes()).hexdigest()==item['sha256']
 config,images=p.decode(SOURCE/'assets/battle/role/left/11014821.swf');dest=BASE/'frames';dest.mkdir(exist_ok=True);preview=BASE/'validation';preview.mkdir(exist_ok=True)
 cfg=json.loads((ROOT/'sunucu/sasuke-shinden.json').read_text());vfx=json.loads((BASE/'vfx.json').read_text()) if (BASE/'vfx.json').exists() else {'clips':{},'effects':{}}
 d={'clips':{},'framePivots':{},'moves':{str(v['id']):k for k,v in cfg.items() if isinstance(v,dict) and 'id' in v},'effects':FX,'models':{'11120970':{'':'idle','0a':'idle','0b':['standard','blazeStandard'],'0c':['mystery','blazeMystery','dragon','blazeDragon','mangekyo','rinnegan','susanoo'],'0d':'hit','0e':'idle','0f':'run'}}};ident=0
 for name,action in MAPPING.items():
  rendered,a=p.mme.render(config,images,action,scale=.9);ids=[];last=None
  for t in range(math.ceil(len(rendered)*25/24)):
   image=rendered[min(len(rendered)-1,round(t*24/25))]
   if image.getbbox():last=image
   elif last is not None:image=last.copy();image.info['pivot']=last.info['pivot']
   else:
    image=Image.open(dest/'0000.png').convert('RGBA');image.info['pivot']=d['framePivots']['0']
   image.save(dest/f'{ident:04}.png');ids.append(ident);d['framePivots'][str(ident)]=image.info['pivot'];ident+=1
  clip={'assets':ids,'duration':40,'loop':name in ('idle','run'),'sourceAction':action,'sourceFrames':len(rendered)}
  if not clip['loop']:
   length=max([len(vfx['clips'][key]['timeline']) for effect in FX.get(name,[]) for key in vfx['effects'].get(effect,[])]+[len(ids)])
   ids.extend([ids[-1]]*max(0,length-len(ids)));ids.append(d['clips']['idle']['assets'][0]);clip['returnFrame']=len(ids)-1
  if name in cfg and isinstance(cfg[name],dict) and cfg[name].get('multiplier',0)>0:
   hits=sorted(set(round(int(f.get('index'))*25/24) for f in a.iter('frame') if any(e.startswith('hit') for e in f.get('event','').split(','))))
   count=cfg[name]['hitCount'];first=hits[0] if hits else max(1,round(len(rendered)*.40));lastHit=hits[-1] if len(hits)>1 else max(first+count,round(len(rendered)*.74))
   clip['hitFrames']=[round(first+(lastHit-first)*i/max(1,count-1)) for i in range(count)]
  d['clips'][name]=clip
  sheet=Image.new('RGBA',(1200,230),'#263746');dr=ImageDraw.Draw(sheet)
  for n in range(6):
   idx=ids[min(len(ids)-1,round(n*(len(ids)-1)/5))];im=Image.open(dest/f'{idx:04}.png');im.thumbnail((190,200));sheet.alpha_composite(im,(n*200,25))
  dr.text((4,4),name+' / '+action,fill='white');sheet.convert('RGB').save(preview/(name+'.jpg'))
 (BASE/'animation.json').write_text(json.dumps(d,indent=2)+'\n');print('PASS Sasuke isolated actions',ident,'frames')
if __name__=='__main__':main()
