"""Recover source detail for every active Pain/Hashirama VFX using paged atlases."""
from pathlib import Path
from PIL import Image
import argparse,concurrent.futures,hashlib,json,math,subprocess,xml.etree.ElementTree as ET
BASE=Path(__file__).resolve().parent
ROOT=BASE.parent
ACTIVE={
 'pain-tendo':{'DASHEWAN_tongyongfuhuo':[213],'PEaoyi1':[195],'PEaoyi2':[414],'PEpugong1':[154,682],'PEzhuida':[308,81]},
 'hashirama-final':{'Zhujianzhongyanbangpaizhishu':[364,54],'Zhujianzhongyanmingshenfenglong':[170,688]}}
SOURCES={'pain-tendo':'Pain_Tendo_Six_Paths_Rinnegan','hashirama-final':'Hashirama_Senju_Final_Battle'}
def export(args):
 tasks=[]
 for char,effects in ACTIVE.items():
  for effect,ids in effects.items():
   source=ROOT.parent/'asset'/SOURCES[char]/'battle/effect'/(effect+'.swf')
   out=BASE/char/'native-export/quality-hq'/effect
   if (out/'complete.json').exists():continue
   out.mkdir(parents=True,exist_ok=True);tasks.append((source,out,ids))
 def run(t):
  source,out,ids=t
  subprocess.run(['java','-Xmx1500m','-jar',args.ffdec,'-zoom','.7','-ignorebackground','-selectid',','.join(map(str,ids)),'-export','sprite',str(out),str(source)],check=True,stdout=subprocess.DEVNULL)
  (out/'complete.json').write_text(json.dumps(ids));print('HQ exported',source.stem,flush=True)
 with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:list(pool.map(run,tasks))
def upgrade(char):
 b=BASE/char;m=json.loads((b/'vfx.json').read_text());public=ROOT/'kaynak/login.gogames.me/public'/('pain-vfx' if char=='pain-tendo' else 'hashirama-vfx')/'extracted'
 audit=[]
 # Remove only earlier output metadata; retain files for clients still on the old version.
 for c in m['clips'].values():
  if not c.get('cinematic'):
   for key in set(c.get('frameAtlases',[c['atlas']])):
    if key.startswith('quality-v1-'):m['atlases'].pop(key,None)
 active=set(k for layers in m['effects'].values() for k in layers)
 for key,c in list(m['clips'].items()):
  if key not in active or c.get('cinematic'):continue
  effect,ident=key.rsplit('-',1)
  original=b/'native-export'/effect;hq=b/'native-export/quality-hq'/effect
  folders=list(hq.glob('DefineSprite_'+ident+'_*'))
  zoom=.7 if folders else .35
  if not folders:folders=list(original.glob('DefineSprite_'+ident+'_*'))
  assert len(folders)==1,key
  paths=sorted(folders[0].glob('*.png'),key=lambda p:int(p.stem));bounds=None
  for p in paths:
   with Image.open(p) as im:box=im.getbbox()
   if box:bounds=box if bounds is None else (min(bounds[0],box[0]),min(bounds[1],box[1]),max(bounds[2],box[2]),max(bounds[3],box[3]))
  assert bounds,key
  bw,bh=bounds[2]-bounds[0],bounds[3]-bounds[1]
  # No synthetic enlargement: native source is always at least output resolution.
  ratio=min(1,1024/bw,768/bh);w,h=round(bw*ratio),round(bh*ratio)
  portraits=None
  if char=='hashirama-final' and key=='Zhujianzhongyanmingshenfenglong_texie-272':
   images=b/'native-export/deity-images';tags=list(ET.parse(original/'source.xml').getroot().find('tags'))
   large={p.stem for p in images.glob('*.png')if Image.open(p).size==(1920,1080)}
   shapes={e.get('shapeId'):e for e in tags if e.get('shapeId')};sprite=next(e for e in tags if e.get('spriteId')==ident)
   portraits={};index=1;portrait=None
   for tag in sprite.find('subTags'):
    if tag.get('depth')=='3':
     if tag.get('type')=='RemoveObject2Tag':portrait=None
     elif tag.get('characterId') in shapes:
      bits=[e.get('bitmapId')for e in shapes[tag.get('characterId')].iter()if e.get('bitmapId') in large]
      portrait=bits[0] if bits else None
    if tag.get('type')=='ShowFrameTag':portraits[index]=portrait;index+=1
   assert any(portraits.values());w,h=1024,576
  cols=max(1,2048//w);capacity=cols*max(1,2048//h)
  unique={};frames=[];timeline=[]
  for t in range(math.ceil(len(paths)*25/24)):
   i=min(len(paths)-1,round(t*24/25))
   if portraits is not None:
    portrait=portraits.get(i+1);frame=Image.new('RGBA',(w,h))
    if portrait:
     frame=Image.new('RGBA',(w,h),(24,56,43,230))
     with Image.open(images/(portrait+'.png')) as im:frame.alpha_composite(im.convert('RGBA').crop((240,40,1680,850)).resize((w,h),Image.Resampling.LANCZOS))
   else:
    with Image.open(paths[i]) as im:frame=im.convert('RGBA').crop(bounds).resize((w,h),Image.Resampling.LANCZOS)
   digest=hashlib.sha256(frame.tobytes()).digest()
   if digest not in unique:unique[digest]=len(frames);frames.append(frame)
   timeline.append(unique[digest])
  pages=[]
  for start in range(0,len(frames),capacity):
   batch=frames[start:start+capacity];rows=math.ceil(len(batch)/cols);name=f'quality-v1-{key}-{start//capacity:02}'
   sheet=Image.new('RGBA',(cols*w,rows*h))
   for i,frame in enumerate(batch):sheet.alpha_composite(frame,((i%cols)*w,(i//cols)*h))
   sheet.save(public/(name+'.png'));m['atlases'][name]={'url':'/public/'+public.parent.name+'/extracted/'+name+'.png','columns':cols,'rows':rows,'frameCount':len(batch)};pages.append(name)
  rect=json.loads((original/'bounds.json').read_text())[ident]
  pivot=[(-rect[0]/20*zoom-bounds[0])/bw,(-rect[1]/20*zoom-bounds[1])/bh]
  audit.append({'clip':key,'before':[c['width'],c['height']],'after':[w,h],'nativeZoom':zoom,'pages':len(pages),'sourceCrop':list(bounds),'sourceFrames':len(paths)})
  m['atlases'].pop(c['atlas'],None)
  c.update(atlas=pages[0],frameAtlases=[pages[i//capacity]for i in timeline],timeline=[i%capacity for i in timeline],width=w,height=h,pivot=pivot,renderScale=zoom*w/bw,uniqueFrames=len(frames),qualitySourceZoom=zoom)
  if portraits is not None:c.update(cinematic=True,pivot=[.5,.5],renderScale=1,portraitSourceResolution=[1920,1080])
  print(char,key,'=>',w,h,'pages',len(pages),flush=True)
 m['version']=6;(b/'vfx.json').write_text(json.dumps(m,indent=2))
 out=b/'validation/quality';out.mkdir(parents=True,exist_ok=True);(out/'audit.json').write_text(json.dumps(audit,indent=2))
def main():
 p=argparse.ArgumentParser();p.add_argument('--ffdec');p.add_argument('--export',action='store_true');a=p.parse_args()
 if a.export:export(a)
 else:
  for char in ACTIVE:upgrade(char)
if __name__=='__main__':main()
