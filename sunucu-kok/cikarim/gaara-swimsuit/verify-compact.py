"""Compare every compact frame with its unmodified source, including offsets."""
from pathlib import Path
from PIL import Image
from functools import lru_cache
import json,numpy as np
B=Path(__file__).resolve().parent;P=B.parents[1]/'kaynak/login.gogames.me';old=json.loads((B/'compact-before.json').read_text());new=json.loads((B/'vfx.json').read_text());count=0
@lru_cache(maxsize=4)
def sheet(url):
 with Image.open(P/url.lstrip('/')) as im:return im.convert('RGBA')
for key,c in new['clips'].items():
 prev=old['clips'][key];assert len(c['timeline'])==len(prev['timeline'])
 for field in ['width','height','pivot','renderScale','softEdges']:
  assert c.get(field)==prev.get(field),(key,field)
 seen=set()
 for tick,(page,cell) in enumerate(zip(prev['frameAtlases'],prev['timeline'])):
  if (page,cell) in seen:continue
  seen.add((page,cell));meta=old['atlases'][page];x=cell%meta['columns']*c['width'];y=cell//meta['columns']*c['height'];source=sheet(meta['url']).crop((x,y,x+c['width'],y+c['height']))
  r=c['frameRects'][tick];packed=sheet(new['atlases'][c['frameAtlases'][tick]]['url']);crop=packed.crop((r[0],r[1],r[0]+r[2],r[1]+r[3]));out=Image.new('RGBA',source.size);out.paste(crop,(r[4],r[5]));a=np.array(source);b=np.array(out);assert np.array_equal(a[:,:,3],b[:,:,3]),(key,tick,'alpha');visible=a[:,:,3]>0;assert np.array_equal(a[visible],b[visible]),(key,tick,'visible pixels');count+=1
print('PASS',count,'unique frames: exact alpha, visible RGBA, source dimensions, pivots, soft edges and timeline')
