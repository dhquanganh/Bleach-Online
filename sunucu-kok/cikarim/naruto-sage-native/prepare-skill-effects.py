"""Install the supplied original Naruto Sage SWF effects as native Skill textures."""
from pathlib import Path
from PIL import Image,ImageDraw
import hashlib,importlib.util,io,json,math,shutil,subprocess

BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
SOURCE=ROOT.parent/'asset/Naruto_Sage_Mode_Skill_Effects'
JAR='C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar'
spec=importlib.util.spec_from_file_location('native_sage',BASE/'build.py');native=importlib.util.module_from_spec(spec);spec.loader.exec_module(native)
pain_spec=importlib.util.spec_from_file_location('pain_assets',BASE.parent/'pain-tendo/prepare-assets.py');pain=importlib.util.module_from_spec(pain_spec);pain_spec.loader.exec_module(pain)

COMPLEX={
 'barrage':('XRMRwzspj.swf',177,13621903),
 'mystery':('XRMRzfdlxw.swf',466,13621904),
 'chase':('fengnv-lxwzj.swf',382,13621905),
}
ZOOM=.80

def ff(*args):subprocess.run(['java','-Xmx2g','-jar',JAR,*map(str,args)],check=True,stdout=subprocess.DEVNULL)
def crop(im,pivot):
 box=im.getbbox()
 if not box:return Image.new('RGBA',(1,1)),(0,0)
 out=im.crop(box);return out,(round(pivot[0]-box[0]),round(pivot[1]-box[1]))
def overlay(a,ap,b,bp):
 left=min(-ap[0],-bp[0]);top=min(-ap[1],-bp[1]);right=max(a.width-ap[0],b.width-bp[0]);bottom=max(a.height-ap[1],b.height-bp[1])
 out=Image.new('RGBA',(right-left,bottom-top));out.alpha_composite(a,(-ap[0]-left,-ap[1]-top));out.alpha_composite(b,(-bp[0]-left,-bp[1]-top))
 return out,(-left,-top)
def mme(action,file):
 config,images=pain.decode(SOURCE/'assets/battle/effect'/file);frames,_=pain.mme.render(config,images,action,scale=.85)
 result=[]
 for im in frames:
  result.append(crop(im.convert('RGBA'),tuple(im.info['pivot'])))
 return result
def exported(name,file,ident):
 src=SOURCE/'assets/battle/effect'/file;out=BASE/'skill-effect-export'/name
 if out.exists():shutil.rmtree(out)
 out.mkdir(parents=True)
 ff('-zoom',str(ZOOM),'-ignorebackground','-selectid',str(ident),'-export','sprite',out,src)
 paths=sorted(out.rglob('*.png'),key=lambda p:int(p.stem));assert paths
 bounds=subprocess.check_output(['java','-cp',JAR,str(BASE.parent/'obito-rage/SwfBounds.java'),str(src),str(ident)],text=True).strip().split(',')
 rect=list(map(int,bounds[1:]));origin=(-rect[0]/20*ZOOM,-rect[1]/20*ZOOM)
 result=[]
 for path in paths:
  im=Image.open(path).convert('RGBA');result.append(crop(im,origin))
 return result
def fit(frames,max_area=7_200_000):
 unique={hashlib.sha256(im.tobytes()).digest():im for im,p in frames};area=sum(im.width*im.height for im in unique.values())
 scale=min(1,math.sqrt(max_area/max(1,area)))
 if scale>=.999:return frames
 out=[]
 for im,p in frames:
  size=(max(1,round(im.width*scale)),max(1,round(im.height*scale)))
  out.append((im.resize(size,Image.Resampling.LANCZOS),(round(p[0]*scale),round(p[1]*scale))))
 return out
def held_half_rate(frames):
 # Keep the original duration and 40 ms engine clock while storing every other
 # source pose once. Duplicate cells share atlas pixels, avoiding a huge upload.
 return [frames[min(len(frames)-1,(i//2)*2)] for i in range(len(frames))]
def registration(frames,forward=0,down=0,opening_scale=1,opening_frames=0):
 result=[]
 for index,(im,pivot) in enumerate(frames):
  scale=opening_scale if index<opening_frames else 1
  if scale!=1:
   im=im.resize((max(1,round(im.width*scale)),max(1,round(im.height*scale))),Image.Resampling.LANCZOS)
   pivot=(round(pivot[0]*scale),round(pivot[1]*scale))
  # Effect.xml pos="70,0": decreasing pivot moves the texture forward from
  # the actor; the native camp mirror reverses it for the opposing side.
  result.append((im,(pivot[0]-forward,pivot[1]-down)))
 return result
def contact(name,frames):
 chosen=[frames[min(len(frames)-1,round(i*(len(frames)-1)/5))] for i in range(6)];sheet=Image.new('RGBA',(1200,260),'#263746');d=ImageDraw.Draw(sheet);d.text((4,4),name,fill='white')
 for i,(im,p) in enumerate(chosen):
  scale=min(1,190/max(im.width,im.height));show=im.resize((max(1,round(im.width*scale)),max(1,round(im.height*scale))),Image.Resampling.LANCZOS);sheet.alpha_composite(show,(i*200+(200-show.width)//2,35+(210-show.height)//2))
 folder=BASE/'validation/effects';folder.mkdir(parents=True,exist_ok=True);sheet.convert('RGB').save(folder/(name+'.jpg'),quality=92)
def main():
 supplied=json.loads((SOURCE/'manifest.json').read_text());assert len(supplied)==6
 for item in supplied:assert hashlib.sha256((SOURCE/item['file']).read_bytes()).hexdigest()==item['sha256']
 hit=mme('d1','DaJiTeXiao.swf');upper=mme('shang','skillActionEffect.swf');lower=mme('xia','skillActionEffect.swf')
 charge=[]
 for i in range(max(len(upper),len(lower))):charge.append(overlay(upper[min(i,len(upper)-1)][0],upper[min(i,len(upper)-1)][1],lower[min(i,len(lower)-1)][0],lower[min(i,len(lower)-1)][1]))
 # Full source effects are actor-anchored and already contain charge, travel and
 # explosion choreography. Damage sparks stay target-anchored at native hit time.
 sequences={13621901:hit,13621902:hit,13621906:hit}
 for name,(file,symbol,ident) in COMPLEX.items():
  frames=exported(name,file,symbol)
  if name=='mystery':
   # Ground impact only: omit the flying shuriken and register each explosion
   # frame around its ground contact instead of the original caster origin.
   explosion=[]
   for im,pivot in held_half_rate(frames[66:]):
    explosion.append((im,(im.width//2,max(0,im.height-12))))
   sequences[13621907]=explosion
  if name in ('mystery','chase'):frames=held_half_rate(frames)
  if name=='barrage':frames=registration(frames,forward=70)
  elif name=='chase':frames=registration(frames,forward=70,down=130,opening_scale=1.25,opening_frames=24)
  sequences[ident]=frames
 installed=[]
 for ident,frames in sequences.items():
  frames=fit(frames);contact(str(ident),frames)
  data=native.native.texture_sequences(ident,[dict(frames=[im for im,p in frames],loop=False,duration=40,pivots=[p for im,p in frames])])
  for version in ['2017112917','2026090619']:
   dest=native.native.PUBLIC/version/'Resources/Textures/Skill'/f'{ident:08X}.TexClient';dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(data);installed.append(str(dest.relative_to(ROOT)))
 audit={'source':'asset/Naruto_Sage_Mode_Skill_Effects','zoom':ZOOM,'ids':{str(i):{'frames':len(f),'maxFrame':[max(x.width for x,p in f),max(x.height for x,p in f)]} for i,f in sequences.items()},'files':supplied,'installed':installed}
 (BASE/'skill-effects.json').write_text(json.dumps(audit,indent=2)+'\n')
 print('PASS supplied Naruto Sage effects installed:',', '.join(map(str,sorted(sequences))))

if __name__=='__main__':main()
