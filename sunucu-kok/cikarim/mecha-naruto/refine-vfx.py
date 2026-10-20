"""Use a fixed contact camera instead of fitting distant blur/particle outliers."""
from pathlib import Path
from PIL import Image,ImageChops
import argparse,hashlib,json,math,subprocess
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
def main():
 p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);a=p.parse_args()
 m=json.loads((BASE/'vfx.json').read_text());public=ROOT/'kaynak/login.gogames.me/public/mecha-vfx/extracted'
 # Rasengan's distant motion streak previously forced its contact sphere to 150px.
 source=ROOT.parent/'asset/Mecha_Naruto/effects/Jijiamingren_luoxuanwan_zhuida.swf';hq=BASE/'native-export/contact-hq';hq.mkdir(exist_ok=True)
 if not (hq/'complete.json').exists():
  subprocess.run(['java','-Xmx1500m','-jar',a.ffdec,'-zoom','.85','-ignorebackground','-selectid','626','-export','sprite',str(hq),str(source)],check=True,stdout=subprocess.DEVNULL)
  (hq/'complete.json').write_text('{}')
 for key,c in m['clips'].items():
  effect,ident=key.rsplit('-',1);out=BASE/'native-export'/effect
  folder=next(out.glob('DefineSprite_'+ident+'_*'));zoom=c['sourceZoom']
  if key=='Jijiamingren_luoxuanwan_zhuida-626':folder=next(hq.glob('DefineSprite_626_*'));zoom=.85
  rect=json.loads((out/'bounds.json').read_text())[ident];origin=(-rect[0]/20*zoom,-rect[1]/20*zoom)
  focus=effect in ['Jijiamingren_aoyi','Jijiamingren_luoxuanwan_zhuida','Jijiamingren_jiuweilama_weisouyu']
  if not focus:continue
  fw,fh=(1000,800) if 'luoxuanwan' in effect else (1800,1200)
  camera=origin
  if 'luoxuanwan' in effect:
   paths=sorted(folder.glob('*.png'),key=lambda p:int(p.stem))
   with Image.open(paths[41]) as raw:
    r,g,b,alpha=raw.convert('RGBA').split();mask=ImageChops.multiply(ImageChops.lighter(ImageChops.lighter(r,g),b).point(lambda v:255 if v>180 else 0),alpha.point(lambda v:255 if v>90 else 0));xs=[v**3 for v in mask.resize((raw.width,1),Image.Resampling.BOX).getdata()];ys=[v**3 for v in mask.resize((1,raw.height),Image.Resampling.BOX).getdata()]
    camera=(sum(i*v for i,v in enumerate(xs))/max(1,sum(xs)),sum(i*v for i,v in enumerate(ys))/max(1,sum(ys)))
  bounds=(round(camera[0]-fw*.5*zoom),round(camera[1]-fh*.5*zoom),round(camera[0]+fw*.5*zoom),round(camera[1]+fh*.5*zoom))
  bw,bh=bounds[2]-bounds[0],bounds[3]-bounds[1];ratio=min(1,1280/bw,900/bh);w,h=round(bw*ratio),round(bh*ratio);cols=max(1,4096//w);capacity=cols*max(1,4096//h)
  paths=sorted(folder.glob('*.png'),key=lambda p:int(p.stem));frames=[];unique={};timeline=[]
  for t in range(math.ceil(len(paths)*25/24)):
   with Image.open(paths[min(len(paths)-1,round(t*24/25))]) as im:frame=im.convert('RGBA').crop(bounds).resize((w,h),Image.Resampling.LANCZOS)
   digest=hashlib.sha256(frame.tobytes()).digest()
   if digest not in unique:unique[digest]=len(frames);frames.append(frame)
   timeline.append(unique[digest])
  pages=[]
  for start in range(0,len(frames),capacity):
   batch=frames[start:start+capacity];rows=math.ceil(len(batch)/cols);name=key+'-contact-v2-'+str(start//capacity);sheet=Image.new('RGBA',(cols*w,rows*h))
   for i,frame in enumerate(batch):sheet.alpha_composite(frame,((i%cols)*w,(i//cols)*h))
   sheet.save(public/(name+'.png'),compress_level=1);pages.append(name);m['atlases'][name]={'url':'/public/mecha-vfx/extracted/'+name+'.png','columns':cols,'rows':rows,'frameCount':len(batch)}
  c.update(atlas=pages[0],frameAtlases=[pages[i//capacity] for i in timeline],timeline=[i%capacity for i in timeline],width=w,height=h,pivot=[(origin[0]-bounds[0])/bw,(origin[1]-bounds[1])/bh],renderScale=zoom*w/bw,sourceZoom=zoom,sourceCrop=list(bounds),contactCamera=True,softEdges=True)
  if folder.name.endswith('_xia'):c['additive']=True
  print('contact camera',key,w,h,flush=True)
 # Anchor each source effect to the bright contact core, retaining layer registration.
 m['effectAnchors']={}
 ticks={'Jijiamingren_qianghua_pugong':28,'Jijiamingren_luoxuanwan_zhuida':43,'Jijiamingren_aoyi':126,'Jijiamingren_jiuweilama_weisouyu':53,'Jijiamingren_liandan_pugong3':34,'Jijiamingren_shanbi':16}
 for effect,layers in m['effects'].items():
  if effect not in ticks:continue
  key=layers[0];c=m['clips'][key];t=min(ticks[effect],len(c['timeline'])-1);page=m['atlases'][c['frameAtlases'][t]];n=c['timeline'][t];w,h=c['width'],c['height']
  with Image.open(ROOT/'kaynak/login.gogames.me'/page['url'].lstrip('/')) as im:frame=im.crop((n%page['columns']*w,n//page['columns']*h,n%page['columns']*w+w,n//page['columns']*h+h))
  r,g,b,alpha=frame.split();mask=ImageChops.multiply(ImageChops.lighter(ImageChops.lighter(r,g),b).point(lambda v:255 if v>180 else 0),alpha.point(lambda v:255 if v>90 else 0))
  xs=[v**3 for v in mask.resize((w,1),Image.Resampling.BOX).getdata()];ys=[v**3 for v in mask.resize((1,h),Image.Resampling.BOX).getdata()]
  x=sum(i*v for i,v in enumerate(xs))/max(1,sum(xs));y=sum(i*v for i,v in enumerate(ys))/max(1,sum(ys))
  m['effectAnchors'][effect]=[(x-c['pivot'][0]*w)/c['renderScale'],(y-c['pivot'][1]*h)/c['renderScale']]
 used=set(p for c in m['clips'].values() for p in c['frameAtlases']);m['atlases']={k:v for k,v in m['atlases'].items() if k in used}
 (BASE/'vfx.json').write_text(json.dumps(m,indent=2));print('PASS stable contact cameras and bright-core anchors')
if __name__=='__main__':main()
