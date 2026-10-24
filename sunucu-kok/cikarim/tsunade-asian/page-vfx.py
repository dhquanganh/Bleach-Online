"""Keep HD pages small enough to decode ahead of the next Flash impact tick."""
from pathlib import Path
from PIL import Image
import json,math
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1];m=json.loads((BASE/'vfx.json').read_text());public=ROOT/'kaynak/login.gogames.me/public/tsunade-vfx/extracted';old=m['atlases'];new={}
for key,c in m['clips'].items():
 w,h=c['width'],c['height'];cols=max(1,2048//w);capacity=cols*max(1,2048//h);lookup={};frames=[];timeline=[];pageName=None;sheet=None
 for name,index in zip(c['frameAtlases'],c['timeline']):
  pair=(name,index)
  if pair not in lookup:
   if name!=pageName:
    if sheet:sheet.close()
    sheet=Image.open(ROOT/'kaynak/login.gogames.me'/old[name]['url'].lstrip('/'));pageName=name
   meta=old[name];frame=sheet.crop((index%meta['columns']*w,index//meta['columns']*h,index%meta['columns']*w+w,index//meta['columns']*h+h));lookup[pair]=len(frames);frames.append(frame)
  timeline.append(lookup[pair])
 if sheet:sheet.close()
 pages=[]
 for start in range(0,len(frames),capacity):
  batch=frames[start:start+capacity];rows=math.ceil(len(batch)/cols);name=key+'-pages-v3-'+str(start//capacity);atlas=Image.new('RGBA',(cols*w,rows*h))
  for i,frame in enumerate(batch):atlas.alpha_composite(frame,((i%cols)*w,(i//cols)*h))
  atlas.save(public/(name+'.png'),compress_level=1);pages.append(name);new[name]={'url':'/public/tsunade-vfx/extracted/'+name+'.png','columns':cols,'rows':rows,'frameCount':len(batch)}
 c.update(atlas=pages[0],frameAtlases=[pages[i//capacity] for i in timeline],timeline=[i%capacity for i in timeline])
 print('small HD pages',key,len(pages),flush=True)
m['atlases']=new;(BASE/'vfx.json').write_text(json.dumps(m,indent=2));print('PASS <=2048px HD pages with preserved lossless cells')
