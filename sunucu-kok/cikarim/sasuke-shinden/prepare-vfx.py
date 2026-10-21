"""Recover Sasuke's original effect layers at native detail with lossless paged atlases."""
from pathlib import Path
from PIL import Image
import argparse,hashlib,json,math,subprocess,xml.etree.ElementTree as ET
from clean_kirin import prepare as clean_kirin
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
SOURCE=ROOT.parent/'asset/Sasuke_Shinden_Full'
EFFECTS=[f.stem for f in sorted((SOURCE/'assets/battle/effect').glob('Zuozhu*.swf'))]
def main():
 p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);a=p.parse_args()
 public=ROOT/'kaynak/login.gogames.me/public/sasuke-vfx/detail-v6';public.mkdir(parents=True,exist_ok=True)
 m={'version':8,'frameMs':40,'frameRate':25,'atlases':{},'clips':{},'effects':{},'screenFlashes':{}}
 for effect in EFFECTS:
  src=SOURCE/'assets/battle/effect'/(effect+'.swf');src.parent.mkdir(exist_ok=True)
  if not src.exists():src.write_bytes((Path('E:/Naruto_Online_Full_Resources/resources/assets/battle/effect')/src.name).read_bytes())
  detailed=effect in ('ZuozhuZZZZ_qianniaodao3','ZuozhuZZZZ_xuzuobati')
  fire='haolonghuo' in effect;kirin=effect in ('ZuozhuZZZZ_qilin','ZuozhuZZZZ_qilin_yan')
  suffix='-fire-v6' if fire else '-clean-v6' if kirin else '-detail-v4' if detailed else ''
  out=BASE/'native-export'/(effect+suffix);out.mkdir(parents=True,exist_ok=True)
  def ff(*args):subprocess.run(['java','-Xmx1500m','-jar',a.ffdec,*map(str,args)],check=True,stdout=subprocess.DEVNULL)
  if not (out/'source.xml').exists():ff('-swf2xml',src,out/'source.xml')
  root=ET.parse(out/'source.xml').getroot();symbols=next(e for e in root.find('tags') if e.get('type')=='SymbolClassTag');ids=[int(e.text) for e in symbols.find('tags') if e.text!='0']
  if kirin:
   cleaned=out/'clean.swf';flashes,removed=clean_kirin(out/'source.xml',cleaned,ff,{str(i) for i in ids})
   m['screenFlashes'][effect]=flashes;src=cleaned
   print('Kirin screen flash separated:',effect,removed,flush=True)
  if not (out/'bounds.json').exists():
   result=subprocess.check_output(['java','-cp',a.ffdec,str(BASE.parent/'obito-rage/SwfBounds.java'),str(src),*map(str,ids)],text=True)
   (out/'bounds.json').write_text(json.dumps({s.split(',')[0]:list(map(int,s.split(',')[1:])) for s in result.splitlines()}))
  zoom=.65 if fire else .3562069053252932 if kirin else 1.7 if detailed else (.85 if (out/'complete.json').exists() else min(.85,1400/max(max(r[2]-r[0],r[3]-r[1])/20 for r in json.loads((out/'bounds.json').read_text()).values())))
  if not (out/'complete.json').exists():
   ff('-zoom',str(zoom),'-ignorebackground','-selectid',','.join(map(str,ids)),'-export','sprite',out,src)
   (out/'complete.json').write_text(json.dumps({'ids':ids,'zoom':zoom}))
  done=json.loads((out/'complete.json').read_text());zoom=done.get('zoom',.85) if isinstance(done,dict) else .85
  layers=[]
  for folder in sorted(out.glob('DefineSprite_*')):
   paths=sorted(folder.glob('*.png'),key=lambda p:int(p.stem));bounds=None
   for f in paths:
    with Image.open(f) as im:box=im.getbbox()
    if box:bounds=box if bounds is None else (min(bounds[0],box[0]),min(bounds[1],box[1]),max(bounds[2],box[2]),max(bounds[3],box[3]))
   if not bounds:continue
   bw,bh=bounds[2]-bounds[0],bounds[3]-bounds[1];cap_w,cap_h=(1000,940) if fire and folder.name.split('_')[1]!='31' else (1150,850) if effect=='ZuozhuZZZZ_qianniaodao3' else (1400,1050);ratio=min(1,cap_w/bw,cap_h/bh);w,h=max(1,round(bw*ratio)),max(1,round(bh*ratio));cols=max(1,2048//w);capacity=cols*max(1,2048//h)
   unique={};frames=[];timeline=[]
   for t in range(math.ceil(len(paths)*25/24)):
    with Image.open(paths[min(len(paths)-1,round(t*24/25))]) as im:frame=im.convert('RGBA').crop(bounds).resize((w,h),Image.Resampling.LANCZOS)
    digest=hashlib.sha256(frame.tobytes()).digest()
    if digest not in unique:unique[digest]=len(frames);frames.append(frame)
    timeline.append(unique[digest])
   key=effect+'-'+folder.name.split('_')[1];pages=[]
   for start in range(0,len(frames),capacity):
    batch=frames[start:start+capacity];rows=math.ceil(len(batch)/cols);name=key+'-hd-'+str(start//capacity);sheet=Image.new('RGBA',(cols*w,rows*h))
    for i,frame in enumerate(batch):sheet.alpha_composite(frame,((i%cols)*w,(i//cols)*h))
    sheet.save(public/(name+'.png'),compress_level=1);pages.append(name);m['atlases'][name]={'url':'/public/sasuke-vfx/detail-v6/'+name+'.png','columns':cols,'rows':rows,'frameCount':len(batch)}
   rect=json.loads((out/'bounds.json').read_text())[folder.name.split('_')[1]]
   m['clips'][key]={'atlas':pages[0],'frameAtlases':[pages[i//capacity] for i in timeline],'timeline':[i%capacity for i in timeline],'width':w,'height':h,'pivot':[(-rect[0]/20*zoom-bounds[0])/bw,(-rect[1]/20*zoom-bounds[1])/bh],'renderScale':zoom*w/bw,'sourceFrames':len(paths),'sourceCrop':list(bounds),'sourceZoom':zoom}
   layers.append(key);print(key,w,h,len(paths),'frames',len(pages),'pages',flush=True)
  symbol_names=dict(zip([e.text for e in symbols.find('tags')],[e.text for e in symbols.find('names')]))
  layers.sort(key=lambda key:0 if symbol_names[key.rsplit('-',1)[1]]=='xia' else 1)
  m['effects'][effect]=layers
 (BASE/'vfx.json').write_text(json.dumps(m,indent=2))
 print('PASS native Sasuke effects',len(m['clips']),'layers')
if __name__=='__main__':main()
