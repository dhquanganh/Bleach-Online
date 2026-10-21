"""Compare persisted compact PNG frames with the previous production images."""
from pathlib import Path
from PIL import Image
from functools import lru_cache
import json

BASE=Path(__file__).resolve().parent
PUBLIC=BASE.parents[1]/'kaynak/login.gogames.me'

def main():
 old=json.loads((BASE/'vfx-untrimmed.json').read_text())
 new=json.loads((BASE/'vfx.json').read_text())
 @lru_cache(maxsize=3)
 def page(url):
  with Image.open(PUBLIC/url.lstrip('/')) as im:return im.convert('RGBA')
 checked=set();before=after=0
 assert new['effects']==old['effects']
 for key,clip in new['clips'].items():
  previous=old['clips'][key]
  for field in ['width','height','pivot','renderScale','sourceFrames']:
   assert clip[field]==previous[field],(key,field)
  assert len(clip['timeline'])==len(previous['timeline'])
  for tick,rect in enumerate(clip['frameRects']):
   old_name=previous['frameAtlases'][tick];old_cell=previous['timeline'][tick]
   token=(key,old_name,old_cell)
   if token in checked:continue
   checked.add(token)
   meta=old['atlases'][old_name];source=page(meta['url'])
   w=source.width//meta['columns'];h=source.height//meta['rows']
   x=old_cell%meta['columns']*w;y=old_cell//meta['columns']*h
   original=source.crop((x,y,x+w,y+h))
   atlas=page(new['atlases'][clip['frameAtlases'][tick]]['url'])
   x,y,rw,rh,dx,dy=rect
   frame=atlas.crop((x,y,x+rw,y+rh))
   restored=Image.new('RGBA',(w,h));restored.paste(frame,(dx,dy))
   assert restored.tobytes()==original.tobytes(),(key,tick)
   assert rw<=clip['bufferWidth'] and rh<=clip['bufferHeight']
   before+=w*h;after+=rw*rh
 print('PASS',len(checked),'persisted compact frames: exact RGBA, pivots, dimensions, duration; copy area reduced',round((1-after/before)*100,2),'percent')

if __name__=='__main__':main()
