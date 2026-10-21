"""Decode both supplied forms, retaining native poses, root pivots and hit timing."""
from pathlib import Path
from PIL import Image,ImageDraw
import copy,hashlib,importlib.util,json,math,shutil
BASE=Path(__file__).resolve().parent;SOURCE=BASE.parents[2]/'asset/Mecha_Naruto'
spec=importlib.util.spec_from_file_location('p',BASE.parent/'pain-tendo/prepare-assets.py');p=importlib.util.module_from_spec(spec);spec.loader.exec_module(p)
MAPPING={'idle':('11015001','C_idle'),'run':('11015001','C_run1_2'),'hit':('11015001','D_stand_behit1'),'dead':('11015001','C_dead'),'combo':('11015001','A_3hit'),'beam':('11015001','A_4hit'),'bomb':('11015001','SP_skill1'),'rasengan':('11015001','SP_skill2'),'modified':('11015001','SP_skill2'),'extreme':('11015001','A_4hit'),'high-bomb':('11015001','SP_skill1'),'jet':('11015001','SP_skill4'),'transform':('11015001','SP_skill3'),'beast-idle':('11015003','C_idle'),'beast-run':('11015003','C_run1_2'),'beast-hit':('11015003','D_stand_behit1'),'recovery':('11015003','SP_skill1'),'beast-bomb':('11015003','SP_skill3'),'claw':('11015003','SP_skill2'),'sweep':('11015003','SP_skill4')}
MOVES={13121101:'bomb',13121102:'combo',13121103:'beam',13121104:'rasengan',13121105:'modified',13121106:'extreme',13121107:'high-bomb',13121108:'jet',13121109:'transform',13121110:'recovery',13121111:'beast-bomb',13121112:'claw',13121113:'sweep'}
EFFECTS={'bomb':['Jijiamingren_aoyi'],'high-bomb':['Jijiamingren_aoyi'],'combo':['Jijiamingren_liandan_pugong3'],'beam':['Jijiamingren_qianghua_pugong'],'extreme':['Jijiamingren_qianghua_pugong'],'rasengan':['Jijiamingren_luoxuanwan_zhuida'],'modified':['Jijiamingren_luoxuanwan_zhuida'],'jet':['Jijiamingren_shanbi'],'transform':[],'recovery':['Jijiamingren_ji_aoyi'],'beast-bomb':['Jijiamingren_jiuweilama_weisouyu'],'claw':['Jijiamingren_jiuweilama_zhuaji'],'sweep':['Jijiamingren_jiuweilama_hengsao']}
def main():
 dest=BASE/'frames';dest.mkdir(exist_ok=True);preview=BASE/'validation';preview.mkdir(exist_ok=True)
 decoded={v:p.decode(SOURCE/'assets/battle/role/left'/(v+'.swf')) for v in ['11015001','11015003']}
 vfx=json.loads((BASE/'vfx.json').read_text()) if (BASE/'vfx.json').exists() else {'clips':{},'effects':{}}
 data={'clips':{},'moves':MOVES,'effects':EFFECTS,'framePivots':{},'sourceFrameRate':24,'models':{'11120950':{'':'idle','0a':['idle','beast-idle'],'0b':['combo','beam'],'0c':['bomb','rasengan','modified','extreme','high-bomb','jet','transform','recovery','beast-bomb','claw','sweep'],'0d':['hit','beast-hit'],'0e':['idle','beast-idle'],'0f':['run','beast-run']}}};ident=0
 for name,(variant,action) in MAPPING.items():
  c,images=decoded[variant];frames,a=p.mme.render(c,images,action,scale=1)
  indices=[min(len(frames)-1,round(t*24/25)) for t in range(math.ceil(len(frames)*25/24))];ids=[]
  for t,i in enumerate(indices):
   im=frames[i].copy();im.info['pivot']=frames[i].info['pivot']
   if not im.getbbox():
    idle=data['clips']['idle']['assets'][t%len(data['clips']['idle']['assets'])];im=Image.open(dest/f'{idle:03}.png').convert('RGBA');im.info['pivot']=data['framePivots'][str(idle)]
   if name in ['combo','rasengan','modified']:
    body=next(l for l in a.findall('layer') if l.get('id')=='2');f=next((f for f in body.findall('frame') if int(f.get('index'))<=i<int(f.get('index'))+int(f.get('length'))),None);e=f.find('element') if f is not None else None
    if e is not None:
     asset=next(v for v in c.findall('asset') if v.get('id')==e.get('assetId'));bodyImage=images[asset.get('className')]
     # Locomotion is baked into each body's registration as well as element.x.
     # Use the body layer, never the event-only layer or the composite FX bounds.
     root=float(e.get('x',0))+(float(asset.get('x',0))+bodyImage.width/2)*float(e.get('scaleX',1))
     im.info['pivot']=[im.info['pivot'][0]+round(root),im.info['pivot'][1]]
   if variant=='11015003':
    # Only giant Kurama attack poses need arena fitting. The Naruto-sized
    # persistent form keeps native resolution, including matching locomotion,
    # hit reaction and Energy Recovery; scale registration with the bitmap.
    scale=1.0 if name in ['beast-idle','beast-run','beast-hit','recovery'] else .75
    if scale!=1:
     pivot=im.info['pivot'];im=im.resize((max(1,round(im.width*scale)),max(1,round(im.height*scale))),Image.Resampling.LANCZOS);im.info['pivot']=[round(pivot[0]*scale),round(pivot[1]*scale)]
     box=im.getbbox()
     if box:
      pivot=im.info['pivot'];im=im.crop(box);im.info['pivot']=[pivot[0]-box[0],pivot[1]-box[1]]
   im.save(dest/f'{ident:03}.png');data['framePivots'][str(ident)]=im.info['pivot'];ids.append(ident);ident+=1
  clip={'assets':ids,'loop':name in ['idle','run','beast-idle','beast-run'],'duration':40,'sourceVariant':variant,'sourceAction':action,'sourceFrames':len(frames)}
  hits=sorted(set(round(int(f.get('index'))*25/24) for f in a.iter('frame') if 'hit' in f.get('event','').split(',')))
  if name not in ['idle','run','dead','hit','jet','transform','recovery','beast-idle','beast-run','beast-hit']:clip['hitFrames']=hits if hits else [len(ids)//2]
  recovery_idle=data['clips'].get('beast-idle',data['clips'].get('idle',{})).get('assets',[]) if variant=='11015003' else data['clips'].get('idle',{}).get('assets',[])
  if not clip['loop']:
   length=max([len(vfx['clips'][k]['timeline']) for effect in EFFECTS.get(name,[]) for k in vfx['effects'].get(effect,[])]+[len(ids)])
   while len(ids)<length:ids.append(recovery_idle[len(ids)%len(recovery_idle)])
   ids.append(ids[-1] if name=='dead' else recovery_idle[0]);clip['returnFrame']=len(ids)-1
  data['clips'][name]=clip;print(name,len(ids),'frames',flush=True)
  contact=Image.new('RGBA',(1200,220),'#263746');d=ImageDraw.Draw(contact)
  for j in range(6):
   asset=ids[min(len(ids)-1,int((j+.5)*len(ids)/6))];im=Image.open(dest/f'{asset:03}.png');im.thumbnail((195,190));contact.alpha_composite(im,(j*200,20))
  d.text((0,0),name,fill='white');contact.convert('RGB').save(preview/(name+'.jpg'))
 data['clips']['transform']['assets'][-1]=data['clips']['beast-idle']['assets'][0]
 for v in decoded:
  for source,label in [(f'assets/user/ninja/ninjaImg/{v}.swf','showcase'),(f'assets/role/npc/scene/npcres/{v}_outdoor.swf','outdoor')]:
   c,ims=p.decode(SOURCE/source);action=next(a.get('name') for a in c.findall('action') if 'idle' in a.get('name').lower());p.mme.render(c,ims,action,scale=1)[0][0].save(preview/(label+'-'+v+'.png'))
 # Preserve and audit all sixteen supplied files, including alternative portraits.
 audit=[];public=BASE.parents[1]/'kaynak/login.gogames.me/public/mecha-vfx/original'
 for item in json.loads((SOURCE/'manifest.json').read_text()):
  src=SOURCE/item['file'];assert hashlib.sha256(src.read_bytes()).hexdigest()==item['sha256'];target=public/item['file'];target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(src,target);audit.append(item)
 multi_spec=importlib.util.spec_from_file_location('mecha_multihit',BASE.parent/'ninja-multihit.py');multi=importlib.util.module_from_spec(multi_spec);multi_spec.loader.exec_module(multi);multi.configure(BASE.name,data)
 (preview/'source-assets.json').write_text(json.dumps(audit,indent=2));(BASE/'animation.json').write_text(json.dumps(data,indent=2));print('PASS all supplied Mecha assets',ident,'frames')
if __name__=='__main__':main()
