"""Install only Jiraiya's aerial Rasengan actor sequence; preserve timing and other assets."""
from pathlib import Path
from PIL import Image,ImageDraw
import argparse,hashlib,importlib.util,io,json,shutil,struct,sys,zlib
import cv2,numpy as np
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
ASSET=BASE/'assets/rasengan-slam'
FRAME_MS=36  # Slightly faster than 40 ms; stays above the native 30 ms tick.
sys.path.insert(0,str(BASE.parent/'naruto-sage'))
spec=importlib.util.spec_from_file_location('native_slam',BASE.parent/'naruto-sage/build.py');native=importlib.util.module_from_spec(spec);spec.loader.exec_module(native)

def decode(path):
 b=path.read_bytes();size=struct.unpack_from('<I',b,4)[0];sid,timing,count=struct.unpack_from('<IBH',b,8)
 meta=[struct.unpack_from('<hhhhhhH',b,15+i*14) for i in range(count)]
 pos=8+size;assert struct.unpack_from('<H',b,pos)[0]==1;pos+=2
 size=struct.unpack_from('<I',b,pos)[0];pak=zlib.decompress(b[pos+4:pos+4+size]);width,height=struct.unpack_from('>HH',pak,1)
 pos=10+count*8;size=struct.unpack_from('>I',pak,pos)[0]
 atlas=Image.open(io.BytesIO(pak[pos+4:pos+4+size])).convert('RGB');result=[]
 for i in range(count):
  x,y,w,h=struct.unpack_from('>hhhh',pak,10+i*8)
  im=atlas.crop((x,y,x+w,y+h)).convert('RGBA');im.putalpha(atlas.crop((x,y+height,x+w,y+height+h)).getchannel('R'));result.append(im)
 return result,meta

def between(first,second,t):
 a=np.array(first,dtype=np.float32)/255;b=np.array(second,dtype=np.float32)/255
 a[:,:,:3]*=a[:,:,3:4];b[:,:,:3]*=b[:,:,3:4]
 def gray(im):return np.uint8(np.clip((cv2.cvtColor(im[:,:,:3],cv2.COLOR_RGB2GRAY)*.7+im[:,:,3]*.3)*255,0,255))
 flow=cv2.DISOpticalFlow_create(cv2.DISOPTICAL_FLOW_PRESET_MEDIUM);ga,gb=gray(a),gray(b)
 f=flow.calc(ga,gb,None);r=flow.calc(gb,ga,None);y,x=np.mgrid[:a.shape[0],:a.shape[1]].astype(np.float32)
 left=cv2.remap(a,x-t*f[:,:,0],y-t*f[:,:,1],cv2.INTER_LINEAR,borderMode=cv2.BORDER_CONSTANT)
 right=cv2.remap(b,x-(1-t)*r[:,:,0],y-(1-t)*r[:,:,1],cv2.INTER_LINEAR,borderMode=cv2.BORDER_CONSTANT)
 out=left*(1-t)+right*t;out[:,:,:3]/=np.maximum(out[:,:,3:4],1/255)
 return Image.fromarray(np.uint8(np.clip(out*255,0,255)))

def prepare():
 cfg=json.loads((BASE/'animation.json').read_text());clip=cfg['clips']['giant-gallant-rasengan'];assert len(clip['assets'])==49 and clip['hitFrames']==[30]
 idle,meta=decode(native.PUBLIC/'2026090619/Resources/Textures/Model/00A9B107.TexClient');original=idle[0]
 # Idle has an untouched shared frame ID. Place it at the same world pivot on a taller canvas.
 idle_canvas=Image.new('RGBA',(256,256));idle_canvas.alpha_composite(original,(0,30))
 sheet=Image.open(ASSET/'keyposes.png').convert('RGBA')
 regions=[(0,211,384,552),(402,0,756,550),(752,0,1154,518),(1108,140,1536,551),(0,552,408,1024),(408,604,783,1008),(780,607,1150,1008)]
 anchors=[(205,540),(600,535),(983,484),(1320,529),(230,984),(590,980),(970,980)]
 palms=[(230,359),(581,36),(955,44),(1491,473),(231,982),(603,956),(994,847)]
 keys=[];hands=[];scale=.40
 for index,(bounds,anchor,palm) in enumerate(zip(regions,anchors,palms)):
  im=sheet.crop(bounds);array=np.array(im);mask=np.uint8(array[:,:,3]>24)
  count,labels,stats,centers=cv2.connectedComponentsWithStats(mask,8)
  component=1+int(np.argmax(stats[1:,cv2.CC_STAT_AREA]));array[:,:,3][labels!=component]=0
  im=Image.fromarray(array);im=im.resize((round(im.width*scale),round(im.height*scale)),Image.Resampling.LANCZOS)
  canvas=Image.new('RGBA',(256,256));canvas.alpha_composite(im,(128-round((anchor[0]-bounds[0])*scale),240-round((anchor[1]-bounds[1])*scale)))
  keys.append(canvas);hands.append([round((palm[0]-anchor[0])*scale,2),round((palm[1]-anchor[1])*scale,2)])
  canvas.save(ASSET/f'pose-{index}.png')
 timeline=[(0,idle_canvas,[40,-65]),(4,keys[0],hands[0]),(9,keys[1],hands[1]),(16,keys[2],hands[2]),(22,keys[2],hands[2]),(27,keys[3],hands[3]),(30,keys[4],hands[4]),(35,keys[5],hands[5]),(42,keys[6],hands[6]),(48,idle_canvas,[40,-65])]
 frames=[];motion=[];folder=BASE/'frames';folder.mkdir(exist_ok=True)
 for frame in range(49):
  pair=next(((a,b) for a,b in zip(timeline,timeline[1:]) if a[0]<=frame<=b[0]),None);a,b=pair;t=(frame-a[0])/(b[0]-a[0])
  image=a[1].copy() if t==0 else b[1].copy() if t==1 else between(a[1],b[1],t)
  motion.append([round(a[2][i]*(1-t)+b[2][i]*t,3) for i in range(2)])
  ident=clip['assets'][frame]
  if frame==48:image=original.copy()
  else:image.save(folder/f'{ident:03}.png');cfg['anchors'][str(ident)]=[128,240]
  frames.append(image)
 clip['assetVariant']='aerial-rasengan-slam-v1';clip['source']='assets/rasengan-slam/keyposes.png';clip['duration']=FRAME_MS
 (BASE/'animation.json').write_text(json.dumps(cfg,indent=2)+'\n')
 (ASSET/'motion.json').write_text(json.dumps({'hitFrame':30,'frameCount':49,'frameMs':FRAME_MS,'hands':motion,'keyFrames':[x[0] for x in timeline],'maxLift':145},indent=2)+'\n')
 return cfg,frames

def main():
 args=argparse.ArgumentParser();args.add_argument('--apply',action='store_true');opts=args.parse_args();cfg,frames=prepare()
 clip=cfg['clips']['giant-gallant-rasengan'];ident=int(f'{cfg["heroId"]:X}0B',16)
 data=native.texture_sequences(ident,[dict(frames=frames,loop=False,duration=FRAME_MS,pivots=[cfg['anchors'][str(i)] for i in clip['assets']])])
 decoded_count=0
 for version in ['2017112917','2026090619']:
  dest=native.PUBLIC/version/'Resources/Textures/Model'/f'{ident:08X}.TexClient'
  if opts.apply:
   backup=BASE/'backups/rasengan-slam'/dest.relative_to(ROOT);backup.parent.mkdir(parents=True,exist_ok=True)
   if not backup.exists():shutil.copy2(dest,backup)
   dest.write_bytes(data)
   installed,metadata=decode(dest);assert len(installed)==49
   for original,actual,pivot in zip(frames,installed,clip['assets']):assert original.tobytes()==actual.tobytes()
   assert [list(m[4:6]) for m in metadata]==[cfg['anchors'][str(i)] for i in clip['assets']]
   assert all(m[6]==FRAME_MS for m in metadata)
   decoded_count+=len(installed)
 (ASSET/'build-result.json').write_text(json.dumps({'applied':opts.apply,'verifiedNativeFrames':decoded_count,'frameMs':FRAME_MS,'totalMs':49*FRAME_MS,'hitFrame':30,'returnFrame':48,'sha256':hashlib.sha256(data).hexdigest()},indent=2)+'\n')
 print('PASS aerial Rasengan assets: 49 frames, hit 30, return 48, native RGBA/pivots verified:',decoded_count,'installed:',opts.apply)
if __name__=='__main__':main()
