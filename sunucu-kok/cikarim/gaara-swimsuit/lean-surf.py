"""Bound only the two surfing textures to 1280px; preserve world scale and all frames."""
from pathlib import Path
from PIL import Image
from functools import lru_cache
import json,hashlib,math
B=Path(__file__).resolve().parent;P=B.parents[1]/'kaynak/login.gogames.me'
@lru_cache(maxsize=3)
def sheet(url):
 with Image.open(P/url.lstrip('/')) as im:return im.convert('RGBA')
def main():
 v=json.loads((B/'vfx.json').read_text());assert not (B/'lean-before.json').exists(),'Already generated; keep original baseline';(B/'lean-before.json').write_text(json.dumps(v));before=0;after=0;oldPages=set();newPages=set()
 for key in v['effects']['Yzwoailuo_aoyi']:
  c=v['clips'][key];ow,oh=c['width'],c['height'];assert ow==2048
  width=1280;height=round(oh*width/ow);ratio=width/ow;frames=[];indices={};timeline=[]
  for page,r in zip(c['frameAtlases'],c['frameRects']):
   identity=(page,*r);oldPages.add(page)
   if identity not in indices:
    full=Image.new('RGBA',(ow,oh));source=sheet(v['atlases'][page]['url']);full.paste(source.crop((r[0],r[1],r[0]+r[2],r[1]+r[3])),(r[4],r[5]));full=full.resize((width,height),Image.Resampling.LANCZOS);box=full.getbbox() or (0,0,1,1);indices[identity]=len(frames);frames.append((full.crop(box),box))
   timeline.append(indices[identity])
  placements=[None]*len(frames);pageIndex=0;atlas=Image.new('RGBA',(2048,2048));x=y=row=usedW=usedH=0;pending=[]
  def flush():
   nonlocal atlas,x,y,row,usedW,usedH,pending,pageIndex,after
   if not pending:return
   name=key+'-lean1280-v1-'+str(pageIndex);url='/public/gaara-vfx/extracted/'+name+'.png';out=atlas.crop((0,0,usedW,usedH));out.save(P/url.lstrip('/'),compress_level=1);after+=out.width*out.height;newPages.add(name);v['atlases'][name]={'url':url,'columns':1,'rows':1,'frameCount':1}
   for i,r in pending:placements[i]=(name,r)
   pageIndex+=1;atlas=Image.new('RGBA',(2048,2048));x=y=row=usedW=usedH=0;pending=[]
  for i,(im,box) in enumerate(frames):
   w,h=im.size
   if x+w>2048:x=0;y+=row;row=0
   if y+h>2048:flush()
   atlas.paste(im,(x,y));pending.append((i,[x,y,w,h,box[0],box[1]]));usedW=max(usedW,x+w);usedH=max(usedH,y+h);x+=w;row=max(row,h)
  flush()
  c['frameAtlases']=[placements[i][0] for i in timeline];c['frameRects']=[placements[i][1] for i in timeline];c['timeline']=[0]*len(timeline);c['atlas']=c['frameAtlases'][0];c['width']=width;c['height']=height;c['worldWidth']=ow/c['renderScale'];c['worldHeight']=oh/c['renderScale'];c['renderScale']*=ratio;c['textureScaleXY']=[ratio,height/oh]
  print('PASS',key,len(timeline),'frames',pageIndex,'pages',flush=True)
 for name in oldPages:
  with Image.open(P/v['atlases'][name]['url'].lstrip('/')) as im:before+=im.width*im.height
  del v['atlases'][name]
 (B/'vfx.json').write_text(json.dumps(v,indent=2));r={'surfAtlasPixelsBefore':before,'surfAtlasPixelsAfter':after,'atlasPixelReductionPercent':round(100*(1-after/before),2),'sourceFramePixelReductionPercent':round(100*(1-(1280/2048)**2),2),'surfPagesBefore':len(oldPages),'surfPagesAfter':len(newPages),'allFramesRetained':True};(B/'lean-result.json').write_text(json.dumps(r,indent=2));print(r)
if __name__=='__main__':main()
