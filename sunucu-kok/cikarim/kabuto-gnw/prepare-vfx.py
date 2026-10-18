"""Package generated transparent effect sheets for the native Flash raster player."""
from pathlib import Path
from PIL import Image, ImageDraw
import hashlib
import json

BASE = Path(__file__).resolve().parent
ROOT = BASE.parents[1]
SOURCE = ROOT.parent / 'asset/Browser Games - Naruto Online - Recruitable Characters - Kabuto (Great Ninja War)/vfx-v3'
PUBLIC = ROOT / 'kaynak/login.gogames.me/public/kabuto-vfx/v3'


def main():
    PUBLIC.mkdir(parents=True, exist_ok=True)
    animation=json.loads((BASE/'animation.json').read_text())
    death=animation['clips']['kabuto-die']
    sheet=Image.new('RGBA',(256*len(death['assets']),224))
    for i,frame in enumerate(death['assets']):
        sheet.alpha_composite(Image.open(BASE/'frames'/f'{frame:03}.png').convert('RGBA'),(i*256,0))
    sheet.save(PUBLIC/'death.png')
    preview = BASE / 'validation/vfx-v3'
    preview.mkdir(parents=True, exist_ok=True)
    atlases = {}
    cells = {}
    for name, filename, columns, rows in [
        ('snakes', 'white-snakes.png', 3, 3),
        ('poison', 'violet-burst.png', 3, 3),
        ('utility', 'utility.png', 4, 4),
        ('impact', 'impact.png', 2, 2),
        ('cutin', 'cutin.png', 1, 1),
    ]:
        image = Image.open(SOURCE / filename).convert('RGBA')
        assert image.getchannel('A').getextrema()[0] == 0, filename+' has no transparency'
        # Equal native cells despite generated dimensions not dividing by the grid.
        w, h = round(image.width / columns), round(image.height / rows)
        sheet = Image.new('RGBA', (w*columns, h*rows))
        frames = []
        for row in range(rows):
            for col in range(columns):
                bounds = (round(col*image.width/columns), round(row*image.height/rows),
                          round((col+1)*image.width/columns), round((row+1)*image.height/rows))
                cell = image.crop(bounds).resize((w, h), Image.Resampling.LANCZOS)
                sheet.alpha_composite(cell, (col*w, row*h))
                frames.append(cell)
        sheet.save(PUBLIC / filename)
        cells[name] = frames
        atlases[name] = {'url': '/public/kabuto-vfx/v3/'+filename, 'columns': columns, 'rows': rows}
    atlases['death']={'url':'/public/kabuto-vfx/v3/death.png','columns':len(death['assets']),'rows':1}
    def timeline(frames, holds):
        return [frame for frame, hold in zip(frames, holds) for _ in range(hold)][::2]
    def clip(atlas, frames, holds, pivot=(.5, .85), **extra):
        return {'atlas': atlas, 'timeline': timeline(frames, holds), 'pivot': list(pivot), **extra}
    clips = {
        'snakes': clip('snakes', range(9), [2,2,3,3,4,4,4,4,4], (.5,.92)),
        'poison': clip('poison', range(9), [2,3,3,4,5,5,4,4,3], (.5,.83), softEdges=True),
        'slash': clip('utility', range(4), [1,2,2,2], (.5,.5)),
        'mystery-flash': clip('impact', range(4), [1,2,2,2], (.5,.5)),
        'healing': clip('utility', range(4,8), [3,4,4,3], (.5,.94)),
        'dragon': clip('utility', [8,9], [6,6], (.5,.55)),
        'white-flash': clip('utility', [10,11], [5,5], (.5,.55)),
        'summon': clip('utility', range(12,16), [4,6,6,4], (.5,.94)),
        'cutin': clip('cutin', [0], [18], (.5,.5)),
    }
    manifest = {'version': 3, 'frameRate': 25, 'frameMs': 40, 'atlases': atlases, 'clips': clips}
    (BASE / 'vfx.json').write_text(json.dumps(manifest, indent=2))
    (SOURCE / 'animations.json').write_text(json.dumps(manifest, indent=2))
    samples = []
    for name, c in clips.items():
        frames = []
        for index in c['timeline']:
            frame = Image.new('RGBA', (520,400), '#344238')
            draw = ImageDraw.Draw(frame)
            draw.line((0,350,520,350), fill='#78907c')
            sprite = cells[c['atlas']][index].copy()
            sprite.thumbnail((480,330), Image.Resampling.LANCZOS)
            frame.alpha_composite(sprite, ((520-sprite.width)//2, 350-sprite.height))
            ImageDraw.Draw(frame).text((12,12), name+' | 25 FPS', fill='white')
            frames.append(frame.convert('RGB'))
        frames[0].save(preview/(name+'.gif'), save_all=True, append_images=frames[1:], duration=40, loop=0)
        samples.append(frames[len(frames)//2])
    board = Image.new('RGB', (1560,1200), '#344238')
    for i, sample in enumerate(samples):
        board.paste(sample, (i%3*520,i//3*400))
    board.save(preview/'overview.png')
    result = {'frameRate':25,'uniqueCells':sum(len(v) for v in cells.values()),
              'clips':len(clips),'files':[
                  {'path':str(f.relative_to(ROOT)), 'sha256':hashlib.sha256(f.read_bytes()).hexdigest()}
                  for f in PUBLIC.glob('*.png')]}
    (preview/'assets.json').write_text(json.dumps(result,indent=2))
    print('PASS transparent generated VFX:',result['uniqueCells'],'cells,',len(clips),'clips at 25 FPS')


if __name__ == '__main__':
    main()
