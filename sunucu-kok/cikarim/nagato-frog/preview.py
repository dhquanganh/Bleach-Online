"""Export a contact sheet and animated previews from original actor/effect frames."""
from pathlib import Path
from PIL import Image,ImageDraw
import json,math
B=Path(__file__).resolve().parent;P=B.parents[1]/'kaynak/login.gogames.me';a=json.loads((B/'animation.json').read_text());v=json.loads((B/'vfx.json').read_text());out=B/'validation';out.mkdir(exist_ok=True)
cache={}
def effect(key,t):
 c=v['clips'][key]
 if t>=len(c['timeline']):return None
 name=c['frameAtlases'][t];m=v['atlases'][name]
 if name not in cache:cache[name]=Image.open(P/m['url'].lstrip('/')).convert('RGBA')
 i=c['timeline'][t];w=c['width'];h=c['height'];return cache[name].crop(((i%m['columns'])*w,(i//m['columns'])*h,(i%m['columns']+1)*w,(i//m['columns']+1)*h))
sheet=Image.new('RGB',(1200,1350),(28,34,44));draw=ImageDraw.Draw(sheet)
for index,name in enumerate(['idle','standard','standard2','combo','mystery','chase']):
 c=a['clips'][name];frames=[];layers=[k for e in a['effects'].get(name,[]) for k in v['effects'][e]]
 for t,ident in enumerate(c['assets']):
  im=Image.new('RGBA',(600,450),(28,34,44));d=ImageDraw.Draw(im);d.line((0,380,600,380),fill=(80,95,105));d.text((16,12),f'Nagato [Frog Squad] - {name}',fill='white')
  actor=Image.open(B/'frames'/f'{ident:03}.png').convert('RGBA');px,py=a['framePivots'][str(ident)];im.alpha_composite(actor,(round(140-px),round(380-py)))
  for key in layers:
   e=effect(key,t)
   if e is None:continue
   meta=v['clips'][key];scale=min(1.0,520/e.width,310/e.height);e=e.resize((max(1,round(e.width*scale)),max(1,round(e.height*scale))),Image.Resampling.LANCZOS)
   x=round(350-meta['pivot'][0]*e.width);y=round(330-meta['pivot'][1]*e.height);x=max(5,min(595-e.width,x));y=max(35,min(430-e.height,y));im.alpha_composite(e,(x,y))
  frames.append(im.convert('RGB'))
 poster=frames[len(frames)//2];sheet.paste(poster,((index%2)*600,(index//2)*450))
 if name!='idle':frames[0].save(out/f'{name}.gif',save_all=True,append_images=frames[1:],duration=40,loop=0,optimize=False)
sheet.save(out/'effects.jpg',quality=95)
print('PASS original-frame previews:',out)
