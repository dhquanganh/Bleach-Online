"""Losslessly trim transparent margins per frame; preserve timing and source coordinates."""
from pathlib import Path
from PIL import Image,ImageChops
import json,hashlib
import numpy as np
B=Path(__file__).resolve().parent;P=B.parents[1]/'kaynak/login.gogames.me'
def main():
 v=json.loads((B/'compact-before.json').read_text());new={};oldPixels=0;newPixels=0
 for key,c in v['clips'].items():
  if c.get('frameRects'):raise RuntimeError('Already compacted')
  cache={};frames={};unique=[];sequence=[]
  for page,cell in zip(c['frameAtlases'],c['timeline']):
   ident=(page,cell)
   if ident not in frames:
    if page not in cache:
     with Image.open(P/v['atlases'][page]['url'].lstrip('/')) as im:cache[page]=im.convert('RGBA')
    sheet=cache[page];cols=v['atlases'][page]['columns'];x=(cell%cols)*c['width'];y=(cell//cols)*c['height'];im=sheet.crop((x,y,x+c['width'],y+c['height']))
    if c.get('softEdges'):
     yy,xx=np.ogrid[-1:1:c['height']*1j,-1:1:c['width']*1j];mask=np.clip((1-np.sqrt(xx*xx+yy*yy))/(1-175/255),0,1);alpha=np.array(im.getchannel('A'));im.putalpha(Image.fromarray(np.rint(alpha*mask).astype('uint8')))
    box=im.getbbox() or (0,0,1,1);crop=im.crop(box)
    # Prove every visible pixel and its position are unchanged by trimming.
    restored=Image.new('RGBA',im.size);restored.paste(crop,box[:2]);assert im.getchannel('A').tobytes()==restored.getchannel('A').tobytes();visible=np.array(im.getchannel('A'))>0;assert np.array_equal(np.array(im)[visible],np.array(restored)[visible])
    frames[ident]=len(unique);unique.append((crop,box))
   sequence.append(frames[ident])
  pageIndex=0;sheet=Image.new('RGBA',(2048,2048));x=y=row=usedW=usedH=0;placements=[];pending=[]
  def flush():
   nonlocal pageIndex,sheet,x,y,row,usedW,usedH,newPixels,pending
   if not pending:return
   name=key+'-masked-v2-'+str(pageIndex);out=sheet.crop((0,0,max(1,usedW),max(1,usedH)));url='/public/gaara-vfx/extracted/'+name+'.png';out.save(P/url.lstrip('/'),compress_level=1);newPixels+=out.width*out.height
   new[name]={'url':url,'columns':1,'rows':1,'frameCount':1}
   for index,rect in pending:placements[index]=(name,rect)
   pageIndex+=1;sheet=Image.new('RGBA',(2048,2048));x=y=row=usedW=usedH=0;pending=[]
  for i,(im,box) in enumerate(unique):
   w,h=im.size
   if x+w>2048:x=0;y+=row;row=0
   if y+h>2048:flush()
   sheet.paste(im,(x,y));placements.append(None);pending.append((i,[x,y,w,h,box[0],box[1]]));usedW=max(usedW,x+w);usedH=max(usedH,y+h);x+=w;row=max(row,h)
  flush()
  c['frameAtlases']=[placements[i][0] for i in sequence];c['frameRects']=[placements[i][1] for i in sequence];c['timeline']=[0]*len(sequence);c['atlas']=c['frameAtlases'][0]
  if c.get('softEdges'):c['softEdges']=False;c['bakedSoftEdges']=True
  print('compacted',key,len(unique),'frames',pageIndex,'pages',flush=True)
 for meta in v['atlases'].values():
  with Image.open(P/meta['url'].lstrip('/')) as im:oldPixels+=im.width*im.height
 v['atlases']=new;(B/'vfx.json').write_text(json.dumps(v,indent=2));result={'oldAtlasPixels':oldPixels,'newAtlasPixels':newPixels,'reductionPercent':round(100*(1-newPixels/oldPixels),2),'bakedRadialEdges':True};(B/'masked-result.json').write_text(json.dumps(result,indent=2));print(result)
if __name__=='__main__':main()
