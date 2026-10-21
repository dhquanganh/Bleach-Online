"""Render cinematic layers directly in the visible battle camera at native detail.
Off-screen particles must not shrink summoned partners or the genjutsu backdrop.
"""
from pathlib import Path
from PIL import Image
import concurrent.futures,json,subprocess,math,hashlib
B=Path(__file__).resolve().parent;ROOT=B.parents[1]
JAR='C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar'
m=json.loads((B/'vfx.json').read_text());public=ROOT/'kaynak/login.gogames.me/public/itachi-vfx/extracted'
keys=[k for k in m['clips'] if any('_Yongbingjituan_'+n+'-' in k for n in ['QY','NZ','LB','SB'])]
def render(key):
 effect,ident=key.rsplit('-',1);src=ROOT.parent/'asset/Itachi_Road_to_Ninja/effects'/(effect+'.swf');out=B/'camera-export'/key
 subprocess.run(['java','-Xmx1200m','-cp',JAR,str(B/'RenderCamera.java'),str(src),str(out),ident,'-1','300'],check=True,stdout=subprocess.DEVNULL)
 return key,out
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:results=list(pool.map(render,keys))
for key,out in results:
 paths=sorted(out.glob('*.png'),key=lambda p:int(p.stem));lookup={};frames=[];timeline=[]
 for t in range(math.ceil(len(paths)*25/24)):
  frame=Image.open(paths[min(len(paths)-1,round(t*24/25))]).convert('RGBA');digest=hashlib.sha256(frame.tobytes()).digest()
  if digest not in lookup:lookup[digest]=len(frames);frames.append(frame)
  timeline.append(lookup[digest])
 pages=[];capacity=3
 for start in range(0,len(frames),capacity):
  batch=frames[start:start+capacity];name=key+'-camera-v1-'+str(start//capacity);sheet=Image.new('RGBA',(1250,650*len(batch)))
  for j,im in enumerate(batch):sheet.alpha_composite(im,(0,650*j))
  sheet.save(public/(name+'.png'),compress_level=1);pages.append(name);m['atlases'][name]={'url':'/public/itachi-vfx/extracted/'+name+'.png','columns':1,'rows':len(batch),'frameCount':len(batch)}
 m['clips'][key]={'atlas':pages[0],'frameAtlases':[pages[i//capacity] for i in timeline],'timeline':[i%capacity for i in timeline],'width':1250,'height':650,'pivot':[325/1250,450/650],'renderScale':1,'sourceFrames':len(paths),'cameraClip':True,'camera':[-325,-450,925,200]}
 print('PASS native camera',key,len(frames),'unique frames',flush=True)
used={p for c in m['clips'].values() for p in c['frameAtlases']};m['atlases']={k:v for k,v in m['atlases'].items() if k in used};(B/'vfx.json').write_text(json.dumps(m,indent=2))
