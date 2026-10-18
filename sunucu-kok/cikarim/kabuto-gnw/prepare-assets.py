"""Register generated Kabuto/Edo sprites and interpolate them at native-safe 25 FPS."""
from pathlib import Path
from PIL import Image,ImageDraw
from scipy import ndimage
import json,numpy as np
import motion as flow
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
SOURCE=ROOT.parent/'asset/Browser Games - Naruto Online - Recruitable Characters - Kabuto (Great Ninja War)'
CFG=json.loads((ROOT/'sunucu/kabuto-gnw.json').read_text())
REFERENCE=json.loads((BASE.parent/'jiraiya-toads/animation.json').read_text())
FRAME_RATE=REFERENCE['frameRate']
FRAME_MS=round(1000/FRAME_RATE)

def main():
    dest=BASE/'frames';dest.mkdir(exist_ok=True);preview=BASE/'validation';preview.mkdir(exist_ok=True)
    frames=[];sources=[]
    atlases=['01-kabuto-movement.png','02-kabuto-combat.png','03-mu.png','04-edo-summons.png']
    for name in atlases:
        atlas=Image.open(SOURCE/'atlases'/name).convert('RGBA');a=np.array(atlas)[:,:,3]
        rows=[0]
        for i in [1,2,3]:
            lo=int(atlas.height*(i/4-.045));hi=int(atlas.height*(i/4+.045))
            counts=(a[lo:hi]>25).sum(1)
            # Prefer the valley nearest the nominal row boundary among equally empty cuts.
            choices=np.flatnonzero(counts==counts.min())+lo
            rows.append(int(min(choices,key=lambda y:abs(y-atlas.height*i/4))))
        rows.append(atlas.height)
        for row in range(4):
            columns=[0]
            counts=(a[rows[row]:rows[row+1]]>35).sum(0)
            for i in [1,2,3]:
                lo=int(atlas.width*(i/4-.055));hi=int(atlas.width*(i/4+.055))
                choices=np.flatnonzero(counts[lo:hi]==counts[lo:hi].min())+lo
                columns.append(int(min(choices,key=lambda x:abs(x-atlas.width*i/4))))
            columns.append(atlas.width)
            for col in range(4):
                ident=len(frames);bounds=[columns[col],rows[row],columns[col+1],rows[row+1]]
                cell=atlas.crop(bounds);rgba=np.array(cell)
                labels,_=ndimage.label(rgba[:,:,3]>20);sizes=np.bincount(labels.ravel());sizes[0]=0
                keep=np.zeros(len(sizes),dtype=bool)
                for component in range(1,len(sizes)):
                    # Clay birds, spirit trails and scorch orbs are intentionally detached.
                    if sizes[component]>=12:keep[component]=True
                rgba[:,:,3][~keep[labels]]=0;cell=Image.fromarray(rgba)
                r,g,b,alpha=[rgba[:,:,n].astype(float) for n in range(4)]
                shoes=(alpha>200)&(r<95)&(g<100)&(b<110)
                shoes[:int(cell.height*.7)]=False
                ys,xs=np.where(shoes)
                baseline=int(ys.max()+1) if len(ys) else (cell.getchannel('A').getbbox() or (0,0,1,cell.height))[3]
                # Identical pixels-to-world scale for all poses; never resize to each alpha box.
                scale=.49 if name=='03-mu.png' else .5
                small=cell.resize((round(cell.width*scale),round(cell.height*scale)),Image.Resampling.LANCZOS)
                source_center=atlas.width*(col+.5)/4-bounds[0]
                im=Image.new('RGBA',(256,224));im.alpha_composite(small,(128-round(source_center*scale),210-round(baseline*scale)))
                im.save(dest/f'{ident:03}.png');frames.append(im)
                sources.append({'id':ident,'atlas':name,'bounds':bounds,'scale':scale,'sourceBaseline':baseline,'alphaBounds':im.getchannel('A').getbbox()})
    models={};clips={}
    def clip(name,keys,steps=8,loop=False,hit=None,idle=0):
        if not loop:steps=max(2,round(steps/2))
        assets=[];pairs=list(zip(keys,keys[1:]+keys[:1])) if loop else list(zip(keys,keys[1:]))
        for first,second in pairs:
            assets.append(first)
            for step in range(1,steps):
                ident=len(frames);im=flow.interpolate(frames[first],frames[second],step/steps)
                im.save(dest/f'{ident:03}.png');frames.append(im);assets.append(ident)
        if not loop:assets.append(keys[-1])
        data={'assets':assets,'duration':FRAME_MS,'loop':loop,'keys':keys,'steps':steps,'idle':idle}
        if not loop:data['returnFrame']=len(assets)-1
        if hit is not None:data['hitFrames']=[hit*steps]
        clips[name]=data;return name
    clip('kabuto-idle',[0,1,2,1],8,True)
    clip('kabuto-run',[4,5,6,7],4,True)
    clip('kabuto-hit',[8,9,10,0],3)
    clip('kabuto-die',[0,12,13],6)
    # Keep the caster at home; the generated eruption is played around the enemy camp.
    # Hold release pose until the snake -> violet detonation has completed.
    clip('white-snake-assault',[0,20,20,23,23,23,23,23,23,23,0],8,hit=3)
    clip('bracken-dance',[0,16,17,18,19,0],4,hit=3)
    clip('white-extreme-attack',[0,24,24,27,27,0],6,hit=3)
    clip('self-healing',[28,31,0],6)
    clip('white-snake-revival',[13,12,14,15,0],6)
    clip('impure-world-reincarnation',[29,30,0],10)
    clip('mu-idle',[32,33,34,33],8,True,idle=32)
    clip('mu-strike',[36,37,38,32],9,hit=2,idle=32)
    clip('mu-summon',[40,41,32],10,idle=32)
    clip('mu-barrier',[36,37,32],8,idle=32)
    clip('mu-hit',[44,45,46,32],3,idle=32)
    for key,start in [('deidara',48),('dan',52),('pakura',56)]:
        clip(key+'-idle',[start],8,True,idle=start)
        clip(key+'-attack',list(range(start,start+4))+[start],10,hit=2,idle=start)
    def model(hero,idle,standard,skill,hit,run=None):
        # 0E is the lobby/character showcase, not a death resource.
        # Battle death is rendered independently from the dedicated death PNG atlas.
        models[str(hero)]={'':idle,'0a':idle,'0b':standard,'0c':skill,'0d':hit,'0e':idle,'0f':run or idle}
    model(CFG['heroId'],'kabuto-idle','bracken-dance',['white-snake-assault','white-extreme-attack','self-healing','white-snake-revival','impure-world-reincarnation'],'kabuto-hit','kabuto-run')
    model(CFG['mu']['heroId'],'mu-idle','mu-strike',['mu-summon','mu-barrier'],'mu-hit')
    for key in ['deidara','dan','pakura']:model(CFG[key]['heroId'],key+'-idle',key+'-attack',[key+'-attack'],key+'-idle')
    data={'heroId':CFG['heroId'],'frameRate':FRAME_RATE,'timingReference':'jiraiya-toads/animation.json','pivot':[128,210],'models':models,'clips':clips,'sourceFrames':sources,'frameCount':len(frames)}
    (BASE/'animation.json').write_text(json.dumps(data,indent=2))
    (SOURCE/'animations.json').write_text(json.dumps(data,indent=2))
    samples=[]
    for name,c in clips.items():
        animation=[]
        for ident in c['assets']:
            canvas=Image.new('RGBA',(320,250),'#253441');canvas.alpha_composite(frames[ident],(32,20))
            draw=ImageDraw.Draw(canvas);draw.line((0,230,320,230),fill='#597080');draw.text((8,8),name,fill='white');animation.append(canvas.convert('RGB'))
        animation[0].save(preview/(name+'.gif'),save_all=True,append_images=animation[1:],duration=FRAME_MS,loop=0)
        samples.append(animation[len(animation)//2])
    board=Image.new('RGB',(1280,250*((len(samples)+3)//4)),'#253441')
    for i,im in enumerate(samples):board.paste(im,(i%4*320,i//4*250))
    board.save(preview/'registered-overview.png')
    print('PASS prepared',len(frames),'registered 25 FPS frames;',len(clips),'clips; 5 independently animated characters.')
if __name__=='__main__':main()
