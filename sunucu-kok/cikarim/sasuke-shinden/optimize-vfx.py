"""Losslessly pack only visible frame rectangles; preserve source coordinates/time."""
from pathlib import Path
from PIL import Image
import json

BASE=Path(__file__).resolve().parent
PUBLIC=BASE.parents[1]/'kaynak/login.gogames.me'

def main():
 source=BASE/'vfx-untrimmed.json'
 current=json.loads((BASE/'vfx.json').read_text())
 if not source.exists() or not current.get('trimmedFrames'):
  source.write_text(json.dumps(current,indent=2)+'\n')
 manifest=json.loads(source.read_text())
 target=PUBLIC/'public/sasuke-vfx/compact-v6';target.mkdir(parents=True,exist_ok=True)
 atlases={};old_pixels=0;new_pixels=0;verified=0
 for meta in manifest['atlases'].values():
  with Image.open(PUBLIC/meta['url'].lstrip('/')) as im:old_pixels+=im.width*im.height
 for name,clip in manifest['clips'].items():
  images={};unique={};items=[];timeline=[]
  for page,cell in zip(clip['frameAtlases'],clip['timeline']):
   key=(page,cell)
   if key not in unique:
    meta=manifest['atlases'][page]
    if page not in images:images[page]=Image.open(PUBLIC/meta['url'].lstrip('/')).convert('RGBA')
    sheet=images[page];w=sheet.width//meta['columns'];h=sheet.height//meta['rows']
    x=(cell%meta['columns'])*w;y=(cell//meta['columns'])*h
    original=sheet.crop((x,y,x+w,y+h))
    box=original.getbbox() or (0,0,1,1)
    cropped=original.crop(box)
    restored=Image.new('RGBA',original.size);restored.paste(cropped,box[:2])
    # Compare all RGBA bytes, including alpha: no visible pixel is resampled.
    assert original.tobytes()==restored.tobytes(),(name,key)
    verified+=1;unique[key]=len(items)
    items.append({'image':cropped,'offset':list(box[:2])})
   timeline.append(unique[key])
  pages=[];sheet=None;x=y=row=0;used_w=used_h=0
  def flush():
   nonlocal sheet,new_pixels
   if sheet is None:return
   page=sheet.crop((0,0,max(1,used_w),max(1,used_h)))
   page.save(target/(pages[-1]+'.png'),compress_level=1)
   new_pixels+=page.width*page.height
   atlases[pages[-1]]={'url':'/public/sasuke-vfx/compact-v6/'+pages[-1]+'.png','columns':1,'rows':1,'frameCount':0}
  # Keep playback order. Sorting by rectangle height saves a few more pixels
  # but makes successive frames bounce between pages and churn the live cache.
  for index in range(len(items)):
   item=items[index];image=item['image'];w,h=image.size
   assert w<=2048 and h<=2048
   if sheet is not None and x+w>2048:x=0;y+=row;row=0
   if sheet is None or y+h>2048:
    flush();pages.append(name+'-trim-'+str(len(pages)))
    sheet=Image.new('RGBA',(2048,2048));x=y=row=used_w=used_h=0
   sheet.paste(image,(x,y));item['page']=pages[-1];item['rect']=[x,y,w,h]
   x+=w;row=max(row,h);used_w=max(used_w,x);used_h=max(used_h,y+h)
  flush()
  clip['atlas']=items[timeline[0]]['page']
  clip['frameAtlases']=[items[i]['page'] for i in timeline]
  clip['frameRects']=[items[i]['rect']+items[i]['offset'] for i in timeline]
  clip['timeline']=timeline
  clip['bufferWidth']=max(i['image'].width for i in items)
  clip['bufferHeight']=max(i['image'].height for i in items)
  for image in images.values():image.close()
 manifest['atlases']=atlases;manifest['trimmedFrames']=True;manifest['version']=7
 (BASE/'vfx.json').write_text(json.dumps(manifest,indent=2)+'\n')
 report={'verifiedFrames':verified,'beforePixels':old_pixels,'afterPixels':new_pixels,'beforePages':len(current['atlases']) if not current.get('trimmedFrames') else len(json.loads(source.read_text())['atlases']),'afterPages':len(atlases),'pixelReductionPercent':round((1-new_pixels/old_pixels)*100,2)}
 (BASE/'optimization.json').write_text(json.dumps(report,indent=2)+'\n')
 print('PASS lossless frame trimming',json.dumps(report))

if __name__=='__main__':main()
