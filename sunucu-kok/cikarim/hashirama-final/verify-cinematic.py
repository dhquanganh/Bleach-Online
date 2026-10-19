"""Check all paged cinematic frames, native close-up detail and cache identities."""
from pathlib import Path
import json,math
from PIL import Image
BASE=Path(__file__).resolve().parent
ROOT=BASE.parents[1]
m=json.loads((BASE/'vfx.json').read_text());name='Hashirama-thousand-hands-cinematic';clip=m['clips'][name]
assert m['effects'][name]==[name]
assert clip['width']==1024 and clip['height']==576
assert len(clip['timeline'])==math.ceil(216*25/24)==225
assert len(clip['frameAtlases'])==225
assert clip['portraitSourceResolution']==[1920,1080]
assert len(set(clip['frameAtlases']))==7
atlases={}
for key in set(clip['frameAtlases']):
    a=m['atlases'][key];im=Image.open(ROOT/'kaynak/login.gogames.me'/a['url'].lstrip('/'))
    assert im.width<=4096 and im.height<=4096
    assert im.width//a['columns']==1024 and im.height//a['rows']==576
    assert a['frameCount']<=a['columns']*a['rows']
    atlases[key]=im
for i,(key,frame) in enumerate(zip(clip['frameAtlases'],clip['timeline'])):
    a=m['atlases'][key];assert 0<=frame<a['frameCount']
    if i in [12,30,50,70,93,110,140,165,190]:
        box=(frame%a['columns']*1024,frame//a['columns']*576)
        sample=atlases[key].crop((*box,box[0]+1024,box[1]+576))
        assert sample.tobytes()==Image.open(BASE/'validation/cinematic'/f'{i}.png').tobytes()
        if i>=93:
            visible=sample.getchannel('A').point(lambda a:255 if a>64 else 0).getbbox()
            assert visible and visible[2]-visible[0]>=400,'Barrage unexpectedly small'
assert clip['portraitFrames']['12']=='3' and clip['portraitFrames']['16']=='100'
assert 'Zhujianzhongyandingshanghuafo_texie' not in m['effects'],'Avoid duplicate old cutaways'
print('PASS cinematic: 225 frames, 7 exact paged atlases, native 1920x1080 portraits, sharp 1024x576 output, large barrage and no old duplicate layers')
