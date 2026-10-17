"""Export a moving contact sheet using the same frames, pivots and timing as Flash."""
from pathlib import Path
from PIL import Image,ImageDraw
import json
BASE=Path(__file__).resolve().parent
cfg=json.loads((BASE/'animation.json').read_text())
files={int(p.stem.rsplit('_',1)[1]):p for p in (BASE.parents[2]/'asset/Browser Games - Naruto Online - Recruitable Characters - Naruto Uzumaki (Sage Mode)').rglob('*.png')}
images={n:Image.open(p).convert('RGBA') for n,p in files.items()}
names=['idle','barrage','mystery','summon','chase','run'];frames=[]
for tick in range(0,2400,50):
    out=Image.new('RGBA',(780,480),'#263544');draw=ImageDraw.Draw(out)
    for index,name in enumerate(names):
        clip=cfg['clips'][name];duration=clip['duration']*len(clip['assets'])
        clock=tick%(duration+(0 if clip['loop'] else 200))
        asset=clip['assets'][min(clock//clip['duration'],len(clip['assets'])-1)]
        x=index%3*260;y=index//3*240;px,py=cfg['anchors'][str(asset)]
        draw.text((x+12,y+12),name.upper(),fill='white');draw.line((x+10,y+220,x+250,y+220),fill='#64798d')
        out.alpha_composite(images[asset],(x+112-px,y+220-py))
    frames.append(out.convert('RGB'))
dest=BASE/'validation/animation-preview.gif'
frames[0].save(dest,save_all=True,append_images=frames[1:],duration=50,loop=0)
print('Saved animation preview:',dest)
