"""Independently compare upgraded atlas cells against exported native source frames."""
from pathlib import Path
from PIL import Image,ImageChops
import json,math
BASE=Path(__file__).resolve().parent;ROOT=BASE.parent
checked=0;pages=0;layers=0
for char in ['pain-tendo','hashirama-final']:
 b=BASE/char;m=json.loads((b/'vfx.json').read_text());audit=json.loads((b/'validation/quality/audit.json').read_text())
 for key,meta in m['atlases'].items():
  path=ROOT/'kaynak/login.gogames.me'/meta['url'].lstrip('/')
  with Image.open(path) as im:
   assert im.width<=4096 and im.height<=4096
   if key.startswith('quality-v1-'):assert im.width<=2048 and im.height<=2048
  pages+=1
 for item in audit:
  key=item['clip'];c=m['clips'][key];assert len(c['timeline'])==len(c['frameAtlases'])==math.ceil(item['sourceFrames']*25/24)
  assert c['width']>=item['before'][0] and c['height']>=item['before'][1],key
  for name,index in zip(c['frameAtlases'],c['timeline']):assert 0<=index<m['atlases'][name]['frameCount']
  layers+=1
  if c.get('cinematic'):
   assert c['portraitSourceResolution']==[1920,1080];continue
  e,ident=key.rsplit('-',1);folder=b/'native-export'
  if item['nativeZoom']==.7:folder/='quality-hq'
  folder=next((folder/e).glob('DefineSprite_'+ident+'_*'))
  bounds=item['sourceCrop'];assert c['width']<=bounds[2]-bounds[0] and c['height']<=bounds[3]-bounds[1],'No fabricated source resolution'
  for tick in [12,len(c['timeline'])//2,len(c['timeline'])-8]:
   source=min(item['sourceFrames']-1,round(tick*24/25))+1
   with Image.open(folder/f'{source}.png') as im:expected=im.convert('RGBA').crop(bounds).resize((c['width'],c['height']),Image.Resampling.LANCZOS)
   name=c['frameAtlases'][tick];meta=m['atlases'][name];index=c['timeline'][tick];x=index%meta['columns']*c['width'];y=index//meta['columns']*c['height']
   with Image.open(ROOT/'kaynak/login.gogames.me'/meta['url'].lstrip('/')) as im:actual=im.crop((x,y,x+c['width'],y+c['height']))
   assert actual.getchannel('A').tobytes()==expected.getchannel('A').tobytes(),(char,key,tick,'alpha')
   mask=expected.getchannel('A').point(lambda a:255 if a else 0).convert('RGB')
   difference=ImageChops.multiply(ImageChops.difference(actual.convert('RGB'),expected.convert('RGB')),mask)
   assert difference.getbbox() is None,(char,key,tick,'visible source detail');checked+=1
 for key,c in m['clips'].items():
  for name,index in zip(c.get('frameAtlases',[c['atlas']]*len(c['timeline'])),c['timeline']):assert name in m['atlases'] and index<m['atlases'][name]['frameCount']
work=BASE/'hashirama-final/quality-build';role=(work/'verify/scripts/Processors/Game/Battle/Character/TRole.as').read_text()
for token in ['TrimPainVfxCache','TrimHashiramaVfxCache','pixels > 40000000','nextAtlas','viewportTL','viewportBR','caster.FCombatVfxSerial != rodSerial','Hashirama-thousand-hands-cinematic']:
 assert token in role,token
assert (ROOT/'kaynak/login.gogames.me/public/2026090619/TApplication.swf').read_bytes()==(ROOT/'kaynak/login.gogames.me/public/2026101970/TApplication.swf').read_bytes()
print('PASS source quality:',layers,'upgraded layers,',pages,'safe atlas pages,',checked,'independent exact RGBA samples; native portraits, streaming/cache budget and installed client verified')
