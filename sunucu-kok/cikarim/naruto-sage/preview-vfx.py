"""Moving preview of the shipped Naruto pose timelines plus generated VFX."""
from pathlib import Path
from PIL import Image,ImageDraw,ImageOps
import json
import vfx
BASE=Path(__file__).resolve().parent
ANIM=json.loads((BASE/'animation.json').read_text())
files={int(p.stem.rsplit('_',1)[1]):p for p in (BASE.parents[2]/'asset/Browser Games - Naruto Online - Recruitable Characters - Naruto Uzumaki (Sage Mode)').rglob('*.png')}
actors={n:Image.open(p).convert('RGBA') for n,p in files.items()}
visuals={name:vfx.frames(effect) for name,effect in vfx.CONFIG['effects'].items()}
def draw_actor(canvas,asset,root,mirror=False):
    im=actors[asset];px,py=ANIM['anchors'][str(asset)]
    if mirror:im=ImageOps.mirror(im);px=im.width-px
    canvas.alpha_composite(im,(root[0]-px,root[1]-py))
def draw_vfx(canvas,name,clock,root,mirror=False):
    spec=vfx.CONFIG['effects'][name];index=clock//spec['duration']
    if clock<0 or index>=len(visuals[name]):return
    im=visuals[name][index];px,py=vfx.pivots(spec)[index]
    if mirror:im=ImageOps.mirror(im);px=im.width-px
    canvas.alpha_composite(im,(root[0]-px,root[1]-py))
def main():
    frames=[]
    for tick in range(0,1680,40):
        out=Image.new('RGBA',(1200,270),'#263544');draw=ImageDraw.Draw(out)
        for panel,(sid,name,title) in enumerate([(13120903,'barrage','RASENGAN BARRAGE'),(13120901,'mystery','RASEN SHURIKEN'),(13120904,'chase','RASENGAN - SHOOT DOWN')]):
            x=panel*400;clip=ANIM['clips'][name];spec=vfx.CONFIG['skills'][str(sid)]
            actor=(x+90,240);target=(x+290,240)
            draw.text((x+12,12),title,fill='white');draw.line((x+8,240,x+392,240),fill='#6b8198')
            index=min(tick//clip['duration'],len(clip['assets'])-1)
            draw_actor(out,clip['assets'][index],actor)
            draw_actor(out,ANIM['clips']['idle']['assets'][(tick//100)%9],target,True)
            draw_vfx(out,spec['charge'],tick-spec['chargeFrame']*clip['duration'],actor)
            for impact in clip['hitFrames']:draw_vfx(out,spec['impact'],tick-impact*clip['duration'],target,True)
        frames.append(out.convert('RGB'))
    dest=BASE/'validation/naruto-vfx-preview.gif'
    frames[0].save(dest,save_all=True,append_images=frames[1:],duration=40,loop=0)
    frames[18].save(BASE/'validation/naruto-vfx-preview.png')
    print('Saved Naruto VFX preview:',dest)
if __name__=='__main__':main()
