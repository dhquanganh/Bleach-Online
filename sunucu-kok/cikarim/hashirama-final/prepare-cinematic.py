"""Render the original Thousand Hands cutaway and barrage into paged HD atlases.

Uses the original SWF timelines, not upscaled low-resolution game atlases.
Export its original lossless images into native-export/cinematic-images first.
"""
from pathlib import Path
import hashlib,json,math
import xml.etree.ElementTree as ET
from PIL import Image

BASE=Path(__file__).resolve().parent
PUBLIC=BASE.parents[1]/'kaynak/login.gogames.me/public/hashirama-vfx/extracted'
NAME='Hashirama-thousand-hands-cinematic'
W,H=1024,576

def sample(path,box):
    with Image.open(path) as source:
        # Native camera coordinates stay fixed within a shot. No per-frame bbox
        # centering/scaling, which would make moving fists and particles jitter.
        return source.convert('RGBA').transform((W,H),Image.Transform.EXTENT,box,Image.Resampling.BICUBIC)

def main():
    manifest=json.loads((BASE/'vfx.json').read_text())
    texie=BASE/'native-export/Zhujianzhongyandingshanghuafo_texie/DefineSprite_368_texie'
    images=BASE/'native-export/cinematic-images'
    assert (images/'100.png').exists(),'Export original lossless images first'
    tags=list(ET.parse(texie.parent/'source.xml').getroot().find('tags'))
    shapes={e.get('shapeId'):e for e in tags if e.get('shapeId')}
    sprite=next(e for e in tags if e.get('spriteId')=='368')
    portrait_frames={};index=1;portrait=None
    for tag in sprite.find('subTags'):
        if tag.get('depth')=='3':
            if tag.get('type')=='RemoveObject2Tag':portrait=None
            elif tag.get('characterId') in shapes:
                ids=[e.get('bitmapId')for e in shapes[tag.get('characterId')].iter()if e.get('bitmapId')not in [None,'65535']]
                portrait=ids[0] if ids else None
        if tag.get('type')=='ShowFrameTag':portrait_frames[index]=portrait;index+=1
    # Warm, translucent cinematic light. The character remains the unmodified
    # 1920x1080 source bitmap, with original eye/hand changes from the SWF timeline.
    backdrop=Image.new('RGBA',(W,H))
    pixels=backdrop.load()
    for y in range(H):
        for x in range(W):
            light=max(0,1-math.hypot((x-W*.5)/(W*.8),(y-H*.65)/(H*1.2)))
            pixels[x,y]=(int(120+135*light),int(58+175*light),int(18+110*light),int(160+70*light))
    native=BASE/'native-export/Zhujianzhongyandingshanghuafo'
    rects=json.loads((native/'bounds.json').read_text())
    layers=[(native/'DefineSprite_111_xia',rects['111']),(native/'DefineSprite_963_shang',rects['963'])]
    camera=(-170,-245,350,47.5)
    unique={};frames=[];timeline=[]
    for tick in range(math.ceil(216*25/24)):
        index=min(215,round(tick*24/25))+1
        frame=Image.new('RGBA',(W,H))
        for folder,rect in layers:
            dx,dy=rect[0]/20*.35,rect[1]/20*.35
            box=(camera[0]-dx,camera[1]-dy,camera[2]-dx,camera[3]-dy)
            frame.alpha_composite(sample(folder/(str(index)+'.png'),box))
        if index<=100:
            # The original close-up sits inside an enormous blue aura. Zoom the
            # actual face/hands panel; then switch once to the wide Buddha shot.
            if portrait_frames.get(index):
                frame.alpha_composite(backdrop)
                frame.alpha_composite(sample(images/(portrait_frames[index]+'.png'),(240,40,1680,850)))
            else:
                crop=(735,695,1430,1110) if index<=40 else (0,80,2164,1460)
                frame.alpha_composite(sample(texie/(str(index)+'.png'),crop))
        key=hashlib.sha256(frame.tobytes()).digest()
        if key not in unique:unique[key]=len(frames);frames.append(frame)
        timeline.append(unique[key])
    for key in list(manifest['atlases']):
        if key.startswith('thousand-hands-hq-'):manifest['atlases'].pop(key)
    columns=4096//W;per_page=columns*(4096//H)
    pages=[]
    for start in range(0,len(frames),per_page):
        batch=frames[start:start+per_page];rows=math.ceil(len(batch)/columns)
        name=f'thousand-hands-hq-v2-{start//per_page:02}'
        atlas=Image.new('RGBA',(columns*W,rows*H))
        for i,frame in enumerate(batch):atlas.alpha_composite(frame,((i%columns)*W,(i//columns)*H))
        atlas.save(PUBLIC/(name+'.png'))
        manifest['atlases'][name]={'url':'/public/hashirama-vfx/extracted/'+name+'.png','columns':columns,'rows':rows,'frameCount':len(batch)}
        pages.append(name)
    # Preserve the original files, while avoiding preloading their low-resolution
    # copies alongside the HD cinematic. Other skill atlases remain untouched.
    for effect in ['Zhujianzhongyandingshanghuafo','Zhujianzhongyandingshanghuafo_texie']:
        for key in manifest['effects'].pop(effect,[]):
            clip=manifest['clips'].pop(key);manifest['atlases'].pop(clip['atlas'],None)
    clip={'atlas':pages[0],'frameAtlases':[pages[i//per_page]for i in timeline],
          'timeline':[i%per_page for i in timeline],'pivot':[.5,.5],
          'width':W,'height':H,'renderScale':1,'sourceFrames':216,'uniqueFrames':len(frames),
          'cinematic':True,'source':'Original dingshanghuafo + texie SWF timelines',
          'camera':list(camera),'closeupCamera':[240,40,1680,850],
          'portraitSourceResolution':[1920,1080],'portraitFrames':portrait_frames}
    manifest['clips'][NAME]=clip;manifest['effects'][NAME]=[NAME]
    manifest['version']=5
    (BASE/'vfx.json').write_text(json.dumps(manifest,indent=2))
    preview=BASE/'validation/cinematic';preview.mkdir(parents=True,exist_ok=True)
    for tick in [12,30,50,70,93,110,140,165,190]:frames[timeline[tick]].save(preview/(str(tick)+'.png'))
    print('PASS HD cinematic:',len(frames),'unique frames,',len(pages),'pages,',W,H,'pixels; native timing retained')

if __name__=='__main__':main()
