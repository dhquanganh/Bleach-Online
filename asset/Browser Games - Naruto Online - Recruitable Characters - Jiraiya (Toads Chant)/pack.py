"""Package generated RGBA sheets into frames and animation previews; never repaint originals."""
from pathlib import Path
import hashlib, json
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parent
OUT = ROOT/'characters/Jiraiya - Toads Chant (Battle)'
PREVIEW = ROOT/'previews'
CLIPS = [
    ('idle',0,0,8,100,True),
    ('run',0,8,13,75,True),
    ('hit',0,13,16,100,False),
    ('giant-gallant-rasengan',1,0,16,80,False),
    ('toad-mouth-barrier',2,0,16,100,False),
    ('toad-confrontation-chant',3,0,16,100,False),
    ('raging-lions-mane',4,0,16,80,False),
    ('senjutsu-power',5,0,8,120,False),
    ('tale-of-jiraiya-revival',5,8,16,150,False),
]

def main():
    OUT.mkdir(parents=True,exist_ok=True)
    PREVIEW.mkdir(exist_ok=True)
    sources=json.loads((ROOT/'prompts.json').read_text())
    frames=[]; manifest={'character':'Jiraiya [Toads Chant]','grid':[4,4],
        'frameSize':[256,224],'facing':'right','generationMode':'built-in imagegen',
        'note':'Generated keyframes, not a pixel-exact replacement for Naruto. Pivots are nominal; tune on engine integration.',
        'frames':[],'clips':{}}
    for sheet,source in enumerate(sources):
        path=ROOT/source['atlas']; atlas=Image.open(path).convert('RGBA')
        # Generated rows have uneven spacing. Locate transparent gutters rather
        # than cutting a neighbour's feet into the next animation frame.
        alpha=list(atlas.getchannel('A').getdata())
        occupancy=[sum(v>128 for v in alpha[y*atlas.width:(y+1)*atlas.width]) for y in range(atlas.height)]
        rows=[0]+[min(range(round(atlas.height*k/4)-65,round(atlas.height*k/4)+66),
            key=lambda y:sum(occupancy[max(0,y-1):y+2])+abs(y-atlas.height*k/4)*.1) for k in (1,2,3)]+[atlas.height]
        for index in range(16):
            col,row=index%4,index//4
            bounds=[round(col*atlas.width/4),rows[row],round((col+1)*atlas.width/4),rows[row+1]]
            crop=atlas.crop(bounds)
            assert crop.width<=384 and crop.height<=336
            canvas=Image.new('RGBA',(384,336))
            canvas.alpha_composite(crop,((384-crop.width)//2,336-crop.height))
            # One uniform scale for ALL sheets/frames, no per-frame stretching.
            frame=canvas.resize((256,224),Image.Resampling.LANCZOS)
            ident=len(frames);name=f'{ident+1}_Asset_{ident}.png'
            frame.save(OUT/name);frames.append(frame)
            manifest['frames'].append({'id':ident,'file':(OUT/name).relative_to(ROOT).as_posix(),
                'source':source['atlas'],'cell':index,'sourceBounds':bounds,'pivot':[128,222]})
        source['sha256']=hashlib.sha256(path.read_bytes()).hexdigest()
    tiles=[]
    for name,sheet,start,end,duration,loop in CLIPS:
        indices=list(range(sheet*16+start,sheet*16+end))
        manifest['clips'][name]={'frames':indices,'durationMs':duration,'loop':loop}
        animation=[]
        for index in indices:
            # Opaque preview background only; shipped PNG frames retain original transparency.
            canvas=Image.new('RGBA',(320,272),'#253441')
            canvas.alpha_composite(frames[index],(32,24))
            ImageDraw.Draw(canvas).text((10,254),name,fill='white')
            animation.append(canvas.convert('RGB'))
        # All preview GIFs repeat for inspection; loop semantics above are for game playback.
        animation[0].save(PREVIEW/f'{name}.gif',save_all=True,append_images=animation[1:],duration=duration,loop=0)
        tiles.append((name,frames[indices[len(indices)//2]]))
    board=Image.new('RGBA',(3*320,3*272),'#253441')
    draw=ImageDraw.Draw(board)
    for i,(name,im) in enumerate(tiles):
        x,y=(i%3)*320,(i//3)*272
        board.alpha_composite(im,(x+32,y+24));draw.text((x+10,y+254),name,fill='white')
    board.convert('RGB').save(PREVIEW/'overview.png')
    (ROOT/'animations.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2),encoding='utf-8')
    (ROOT/'prompts.json').write_text(json.dumps(sources,ensure_ascii=False,indent=2),encoding='utf-8')
    for metadata,expected in zip(manifest['frames'],frames):
        decoded=Image.open(ROOT/metadata['file']).convert('RGBA')
        assert decoded.tobytes()==expected.tobytes()
        low,high=decoded.getchannel('A').getextrema()
        assert low==0 and high>=240
        assert decoded.getchannel('A').getbbox() is not None
    assert len(frames)==96 and len(manifest['clips'])==9
    print('PASS: 6 RGBA atlases, 96 transparent PNG frames, 9 animation clips/previews; original atlases preserved.')

if __name__=='__main__':main()
