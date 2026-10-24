"""Render Gaara sand surfing again from the source movie, then patch only its presentation."""
from pathlib import Path
from PIL import Image
import importlib.util,json,math,re,shutil,struct,zlib,hashlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('builder',B/'build-client.py');builder=importlib.util.module_from_spec(s);s.loader.exec_module(builder)
h=builder.h;m=builder.m;ROLE=builder.b.ROLE
def assets():
 effect='Yzwoailuo_aoyi';work=B/'surf-hd';work.mkdir(exist_ok=True);src=B.parents[2]/'asset/Gaara_Swimsuit_Full/assets/battle/effect/Yzwoailuo_aoyi.swf'
 bounds=json.loads((B/'native-export/Yzwoailuo_aoyi/bounds.json').read_text());ids=list(bounds)
 if not (work/'export-complete').exists():
  builder.ff('-zoom','2','-ignorebackground','-selectid',','.join(ids),'-export','sprite',work,src)
  (work/'export-complete').write_text('zoom=2')
 v=json.loads((B/'vfx.json').read_text());public=h.PUBLIC/'gaara-vfx/extracted';layers=[]
 for key in v['effects'][effect]:
  for page in v['clips'][key]['frameAtlases']:v['atlases'].pop(page,None)
  del v['clips'][key]
 for folder in sorted(work.glob('DefineSprite_*')):
  paths=sorted(folder.glob('*.png'),key=lambda p:int(p.stem));box=None
  for path in paths:
   with Image.open(path) as im:r=im.getbbox()
   if r:box=r if box is None else (min(box[0],r[0]),min(box[1],r[1]),max(box[2],r[2]),max(box[3],r[3]))
  if box is None:continue
  bw,bh=box[2]-box[0],box[3]-box[1];ratio=min(1,2048/bw,2048/bh);w,hh=max(1,round(bw*ratio)),max(1,round(bh*ratio));cols=max(1,2048//w);capacity=cols*max(1,2048//hh)
  unique={};frames=[];timeline=[]
  for t in range(math.ceil(len(paths)*25/24)):
   with Image.open(paths[min(len(paths)-1,round(t*24/25))]) as im:f=im.convert('RGBA').crop(box).resize((w,hh),Image.Resampling.LANCZOS)
   digest=hashlib.sha256(f.tobytes()).digest()
   if digest not in unique:unique[digest]=len(frames);frames.append(f)
   timeline.append(unique[digest])
  key=effect+'-'+folder.name.split('_')[1];pages=[]
  for start in range(0,len(frames),capacity):
   batch=frames[start:start+capacity];name=key+'-large-v2-'+str(start//capacity);atlas=Image.new('RGBA',(cols*w,math.ceil(len(batch)/cols)*hh))
   for i,f in enumerate(batch):atlas.alpha_composite(f,((i%cols)*w,(i//cols)*hh))
   atlas.save(public/(name+'.png'),compress_level=1);pages.append(name);v['atlases'][name]={'url':'/public/gaara-vfx/extracted/'+name+'.png','columns':cols,'rows':math.ceil(len(batch)/cols),'frameCount':len(batch)}
  rect=bounds[folder.name.split('_')[1]]
  v['clips'][key]={'atlas':pages[0],'frameAtlases':[pages[i//capacity] for i in timeline],'timeline':[i%capacity for i in timeline],'width':w,'height':hh,'pivot':[(-rect[0]/20*2-box[0])/bw,(-rect[1]/20*2-box[1])/bh],'softEdges':True,'renderScale':2*w/bw,'sourceFrames':len(paths),'sourceCrop':list(box),'sourceZoom':2}
  layers.append(key)
 v['effects'][effect]=layers;(B/'vfx.json').write_text(json.dumps(v,indent=2));print('PASS Gaara source re-render at zoom 2, lossless <=2048px pages',flush=True)
def client():
 from presentation import METHODS
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();raw=h.swap(old);work=B/'surf-hd/client';work.mkdir(parents=True,exist_ok=True);source=work/'source.swf';source.write_bytes(raw)
 name=str(ROLE.with_suffix('')).replace('\\','.').replace('/','.')
 builder.ff('-selectclass',name,'-export','script',work/'original',source);before=(work/'original/scripts'/ROLE).read_text(encoding='utf8');role=before
 for method in ['ShowGaaraVfx','PlayGaaraEffect']:role=role.replace(m.extract(role,method),m.extract(METHODS,method))
 fn=m.extract(role,'GaaraVfxManifest');pattern=r'JSON.parse\(("(?:\\.|[^"\\])*")\)';match=re.search(pattern,fn);assert match
 olddata=json.loads(json.loads(match[1]));data=json.loads((B/'vfx.json').read_text());data.update({k:v for k,v in olddata.items() if k not in data})
 replacement=fn[:match.start()]+ 'JSON.parse('+json.dumps(json.dumps(data,separators=(',',':')))+')'+fn[match.end():];role=role.replace(fn,replacement)
 dest=work/'patched'/ROLE;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(role,encoding='utf8');output=work/'compiled.swf'
 builder.ff('-onerror','abort','-importScript',source,output,work/'patched');rebuilt=output.read_bytes();assert [t for t in h.tags(raw) if t[0]!=82]==[t for t in h.tags(rebuilt) if t[0]!=82]
 builder.ff('-selectclass',name,'-export','script',work/'verify',output);after=(work/'verify/scripts'/ROLE).read_text(encoding='utf8')
 for method in re.findall(r'      (?:override )?(?:public|private|protected) (?:static )?function (\w+)\(',before):
  if method not in {'GaaraVfxManifest','ShowGaaraVfx','PlayGaaraEffect'}:assert m.extract(before,method)==m.extract(after,method),method
 assert canonical.read_bytes()==old;(work/'before.swf').write_bytes(old);canonical.write_bytes(h.swap(rebuilt));shutil.copy2(work/'verify/scripts'/ROLE,B/'verify/scripts'/ROLE)
 print('PASS Gaara sand surfing 2x; only 3 Gaara methods updated')
if __name__=='__main__':
 import sys
 assets() if '--assets' in sys.argv else client()
