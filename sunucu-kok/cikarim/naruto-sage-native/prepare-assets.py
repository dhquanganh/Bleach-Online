"""Decode the supplied native Naruto Sage actor without resizing frames independently."""
from pathlib import Path
from PIL import Image, ImageDraw
import importlib.util, json, math

BASE=Path(__file__).resolve().parent
SOURCE=BASE.parents[2]/'asset/Naruto_Sage_Mode'
spec=importlib.util.spec_from_file_location('pain_assets',BASE.parent/'pain-tendo/prepare-assets.py')
p=importlib.util.module_from_spec(spec);spec.loader.exec_module(p)

MAPPING={
 'idle':'C_idle','run':'C_run1_2','hit':'D_stand_behit1','dead':'C_dead',
 'barrage':'A_1hit','mystery':'SP_skill2','summon':'SP_skill4','chase':'SP_skill3'
}
MOVES={13120901:'mystery',13120902:'summon',13120903:'barrage',13120904:'chase'}

def native_rasenshuriken():
 # Use complete early spinning poses from XRMRzfdlxw.swf, before its impact.
 paths=sorted((BASE/'skill-effect-export/mystery').rglob('*.png'),key=lambda f:int(f.stem))
 assert len(paths)>36,'Run prepare-skill-effects.py to export the original sxsj timeline'
 images=[Image.open(paths[i]).convert('RGBA') for i in range(12,36,3)]
 boxes=[im.getbbox() for im in images];assert all(boxes)
 bounds=(min(b[0] for b in boxes),min(b[1] for b in boxes),max(b[2] for b in boxes),max(b[3] for b in boxes))
 width,height=bounds[2]-bounds[0],bounds[3]-bounds[1]
 size=max(width,height)+24
 frames=[]
 for im in images:
  canvas=Image.new('RGBA',(size,size))
  canvas.alpha_composite(im.crop(bounds),((size-width)//2,(size-height)//2))
  frames.append(canvas)
 return frames

def main():
 dest=BASE/'frames';dest.mkdir(parents=True,exist_ok=True)
 balls=native_rasenshuriken()
 balls[0].save(BASE/'validation/giant-native-rasenshuriken.png')
 config,images=p.decode(SOURCE/'assets/battle/role/left/11000171.swf')
 data={'clips':{},'moves':MOVES,'framePivots':{},'sourceFrameRate':24,
       'models':{'11120901':{'':'idle','0a':'idle','0b':'barrage','0c':['mystery','summon','chase'],'0d':'hit','0e':'idle','0f':'run'},
                 '11120902':{'':'idle','0a':'idle','0b':'barrage','0c':['mystery','summon','chase'],'0d':'hit','0e':'idle','0f':'run'}}}
 ident=0
 for name,action_name in MAPPING.items():
  frames,action=p.mme.render(config,images,action_name,scale=.9)
  if name=='chase':
   # Keep landing explosion on the same animation clock and texture load as
   # Naruto, rather than relying on a separately loaded target effect.
   paths=sorted((BASE/'skill-effect-export/mystery').rglob('*.png'),key=lambda f:int(f.stem))
   landing=[Image.open(paths[66+(i//3)*3]).convert('RGBA') for i in range(len(paths)-66)]
   while len(frames)<44+len(landing):
    hold=frames[-1].copy();hold.info['pivot']=frames[-1].info['pivot'];frames.append(hold)
   for offset,blast in enumerate(landing):
    index=44+offset;actor=frames[index];pivot=actor.info['pivot'];bounds=blast.getbbox()
    if not bounds:continue
    blast=blast.crop(bounds);blast.thumbnail((520,490),Image.Resampling.LANCZOS)
    # Native Shootdown lands forward of its origin. Ground registration keeps
    # the blast under the diving palm and mirrors naturally for the other camp.
    bx=pivot[0]+235-blast.width//2;by=pivot[1]-blast.height+12
    left=min(0,bx);top=min(0,by);right=max(actor.width,bx+blast.width);bottom=max(actor.height,by+blast.height)
    canvas=Image.new('RGBA',(right-left,bottom-top));canvas.alpha_composite(actor,(-left,-top));canvas.alpha_composite(blast,(bx-left,by-top))
    canvas.info['pivot']=[pivot[0]-left,pivot[1]-top];frames[index]=canvas
  indices=[min(len(frames)-1,round(t*24/25)) for t in range(math.ceil(len(frames)*25/24))]
  ids=[]
  for source_index in indices:
   frame=frames[source_index]
   if name=='chase' and 4<=source_index<=43 and frame.getbbox():
    pivot=frame.info['pivot'];box=frame.getbbox()
    # Follow the rear hand during ascent, the raised arm at the apex, then
    # the extended palm during the inverted plunge (reference Shootdown pose).
    if source_index<9:point=(.20,.45)
    elif source_index<19:point=(.12,.10)
    elif source_index<23:point=(.30,.06)
    elif source_index<44:point=(.88,.96)
    else:point=(.48,.78)
    hand=(round(box[0]+(box[2]-box[0])*point[0]),round(box[1]+(box[3]-box[1])*point[1]))
    # Charge up to a sphere over twice the actor's height, hold during plunge,
    # then collapse and fade after the impact. Quantized poses share atlas cells.
    if source_index<9:diameter=140
    elif source_index<13:diameter=260
    elif source_index<17:diameter=360
    elif source_index<44:diameter=440
    elif source_index<47:diameter=360
    else:diameter=260
    orb=balls[(source_index//2)%len(balls)].resize((diameter,diameter),Image.Resampling.LANCZOS)
    if source_index>=44:orb.putalpha(orb.getchannel('A').point(lambda a:round(a*max(0,(51-source_index)/7))))
    margin=diameter+8;canvas=Image.new('RGBA',(frame.width+margin*2,frame.height+margin*2))
    canvas.alpha_composite(frame,(margin,margin))
    # Rest the sphere against the palm rather than burying Naruto in its core.
    dx=-diameter//4 if source_index<23 else diameter//8
    dy=-diameter//4 if source_index<23 else diameter//4
    canvas.alpha_composite(orb,(hand[0]+margin-diameter//2+dx,hand[1]+margin-diameter//2+dy))
    bounds=canvas.getbbox();frame=canvas.crop(bounds)
    frame.info['pivot']=[pivot[0]+margin-bounds[0],pivot[1]+margin-bounds[1]]
   if frame.getbbox() is None and name not in ('dead',):
    # Native skill timelines intentionally hide the actor while external effects play.
    # Hold the last visible pose so the port never flashes or disappears.
    visible=next((frames[i] for i in range(source_index,-1,-1) if frames[i].getbbox()),frames[0])
    frame=visible.copy();frame.info['pivot']=visible.info['pivot']
   frame.save(dest/f'{ident:04}.png')
   data['framePivots'][str(ident)]=list(frame.info['pivot']);ids.append(ident);ident+=1
  clip={'assets':ids,'duration':40,'loop':name in ('idle','run'),'sourceAction':action_name,'sourceFrames':len(frames)}
  hits=sorted(set(round(int(f.get('index'))*25/24) for f in action.iter('frame') if 'hit' in (f.get('event') or '').split(',')))
  if name in ('barrage','mystery','chase'):
   clip['hitFrames']=hits or [len(ids)//2]
  if not clip['loop']:
   ids.append(data['clips']['idle']['assets'][0]);clip['returnFrame']=len(ids)-1
  data['clips'][name]=clip
 (BASE/'animation.json').write_text(json.dumps(data,indent=2)+'\n',encoding='utf-8')
 print('PASS',ident,'native Naruto Sage frames;',len(images),'lossless source images;',len(data['clips']),'clips')

if __name__=='__main__':main()
