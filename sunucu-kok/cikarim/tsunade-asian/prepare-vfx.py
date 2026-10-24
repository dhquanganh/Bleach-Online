"""Recover Mecha's original effect layers at native detail with lossless paged atlases."""
from pathlib import Path
from PIL import Image
import argparse,hashlib,json,math,subprocess,xml.etree.ElementTree as ET
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
SOURCE=ROOT.parent/'asset/Tsunade_Asian_Style_Full'
EFFECTS=['gangshou_aoyi1_niansuan','gangshou_aoyi1_niansuantexie','gangshou_aoyi2_dazhiliao','gangshou_chufa2_texie','gangshou_pugong','qusanqidong']

def main():
 p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);a=p.parse_args()
 public=ROOT/'kaynak/login.gogames.me/public/tsunade-vfx/extracted';public.mkdir(parents=True,exist_ok=True)
 m={'version':6,'frameMs':40,'frameRate':25,'atlases':{},'clips':{},'effects':{}}
 for effect in EFFECTS:
  src=SOURCE/'assets/battle/effect'/(effect+'.swf');src.parent.mkdir(exist_ok=True)
  if not src.exists():src.write_bytes((Path('E:/Naruto_Online_Full_Resources/resources/assets/battle/effect')/src.name).read_bytes())
  out=BASE/'native-export'/effect;out.mkdir(parents=True,exist_ok=True)
  def ff(*args):subprocess.run(['java','-Xmx1500m','-jar',a.ffdec,*map(str,args)],check=True,stdout=subprocess.DEVNULL)
  if not (out/'source.xml').exists():ff('-swf2xml',src,out/'source.xml')
  root=ET.parse(out/'source.xml').getroot();symbols=next(e for e in root.find('tags') if e.get('type')=='SymbolClassTag');ids=[int(e.text) for e in symbols.find('tags') if e.text!='0']
  if not (out/'bounds.json').exists():
   result=subprocess.check_output(['java','-cp',a.ffdec,str(BASE.parent/'obito-rage/SwfBounds.java'),str(src),*map(str,ids)],text=True)
   (out/'bounds.json').write_text(json.dumps({s.split(',')[0]:list(map(int,s.split(',')[1:])) for s in result.splitlines()}))
  zoom=.85 if (out/'complete.json').exists() else min(.85,1700/max(max(r[2]-r[0],r[3]-r[1])/20 for r in json.loads((out/'bounds.json').read_text()).values()))
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
   bw,bh=bounds[2]-bounds[0],bounds[3]-bounds[1];ratio=min(1,1280/bw,900/bh);w,h=max(1,round(bw*ratio)),max(1,round(bh*ratio));cols=max(1,4096//w);capacity=cols*max(1,4096//h)
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
    sheet.save(public/(name+'.png'),compress_level=1);pages.append(name);m['atlases'][name]={'url':'/public/tsunade-vfx/extracted/'+name+'.png','columns':cols,'rows':rows,'frameCount':len(batch)}
   rect=json.loads((out/'bounds.json').read_text())[folder.name.split('_')[1]]
   m['clips'][key]={'atlas':pages[0],'frameAtlases':[pages[i//capacity] for i in timeline],'timeline':[i%capacity for i in timeline],'width':w,'height':h,'pivot':[(-rect[0]/20*zoom-bounds[0])/bw,(-rect[1]/20*zoom-bounds[1])/bh],'renderScale':zoom*w/bw,'sourceFrames':len(paths),'sourceCrop':list(bounds),'sourceZoom':zoom}
   layers.append(key);print(key,w,h,len(paths),'frames',len(pages),'pages',flush=True)
  m['effects'][effect]=layers
 for key,clip in m['clips'].items():
  if key.startswith('Yzwoailuo_aoyi'):clip['softEdges']=True
 (BASE/'vfx.json').write_text(json.dumps(m,indent=2))
 print('PASS native Tsunade effects',len(m['clips']),'layers')
if __name__=='__main__':main()
