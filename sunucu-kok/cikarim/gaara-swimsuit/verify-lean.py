"""Check surfing quality conversion, exact world dimensions and isolation."""
from pathlib import Path
from PIL import Image
from functools import lru_cache
import json,numpy as np
B=Path(__file__).resolve().parent;P=B.parents[1]/'kaynak/login.gogames.me';old=json.loads((B/'lean-before.json').read_text());new=json.loads((B/'vfx.json').read_text());wave=set(old['effects']['Yzwoailuo_aoyi']);count=0
@lru_cache(maxsize=4)
def sheet(url):
 with Image.open(P/url.lstrip('/')) as im:return im.convert('RGBA')
def frame(v,c,t):
 r=c['frameRects'][t];atlas=sheet(v['atlases'][c['frameAtlases'][t]]['url']);full=Image.new('RGBA',(c['width'],c['height']));full.paste(atlas.crop((r[0],r[1],r[0]+r[2],r[1]+r[3])),(r[4],r[5]));return full
for key,c in new['clips'].items():
 prev=old['clips'][key]
 if key not in wave:
  assert c==prev,key
  for page in c['frameAtlases']:assert new['atlases'][page]==old['atlases'][page]
  continue
 assert len(c['timeline'])==len(prev['timeline'])==106
 assert c['width']==1280 and c['pivot']==prev['pivot'] and c['bakedSoftEdges'] and not c['softEdges']
 assert c['worldWidth']==prev['width']/prev['renderScale'] and c['worldHeight']==prev['height']/prev['renderScale']
 seen=set()
 for t,(page,r) in enumerate(zip(prev['frameAtlases'],prev['frameRects'])):
  identity=(page,*r)
  if identity in seen:continue
  seen.add(identity);expected=frame(old,prev,t).resize((c['width'],c['height']),Image.Resampling.LANCZOS);actual=frame(new,c,t);a=np.array(expected);b=np.array(actual);assert np.array_equal(a[:,:,3],b[:,:,3]);mask=a[:,:,3]>0;assert np.array_equal(a[mask],b[mask]);count+=1
print('PASS',count,'surfing frame images, all 106 ticks per layer, exact world dimensions/pivots, baked edges and every other Gaara clip unchanged')
