"""Decode shipped native resources and verify actual pixels, alpha and timing."""
from pathlib import Path
from PIL import Image
import io,json,struct,zlib
BASE=Path(__file__).resolve().parent
ROOT=BASE.parents[1]
def main():
    cfg=json.loads((BASE/'animation.json').read_text());checked=0
    assert cfg['battleScale']==0.70 and cfg['frameRate']==25
    for name,clip in cfg['clips'].items():
        expected_duration=36 if clip.get('assetVariant')=='aerial-rasengan-slam-v1' else 40
        assert clip['duration']==expected_duration and clip['duration']>30, 'Frame duration must stay above the native 30ms tick'
        assert len(clip['assets'])*clip['duration']>clip['previousLengthMs']
        assert len(clip['assets'])>len(clip['sourceAssets'])
        for ident in clip['assets']:
            pivot=[128,240] if clip.get('assetVariant')=='aerial-rasengan-slam-v1' and ident!=0 else [128,210]
            assert cfg['anchors'][str(ident)]==pivot, 'Interpolation must preserve ground registration'
    # Measure the shipped idle silhouette against the original UI source, not just metadata.
    original=Image.open(BASE/'portrait.png').convert('RGBA').getchannel('A').getbbox()
    scaled=Image.open(BASE/'frames/000.png').convert('RGBA').getchannel('A').getbbox()
    assert 0.66 < (scaled[3]-scaled[1])/(original[3]-original[1]) < 0.75
    tween=Image.open(BASE/'frames'/f'{cfg["clips"]["idle"]["assets"][1]:03}.png').convert('RGBA')
    assert tween.tobytes()!=Image.open(BASE/'frames/000.png').convert('RGBA').tobytes(), 'In-betweens must contain motion, not repeated frames'
    for version in ['2017112917','2026090619']:
        for suffix,names in cfg['modelTextures'].items():
            names=[names] if isinstance(names,str) else names
            ident=int(f'{cfg["heroId"]:X}'+suffix,16)
            b=(ROOT/'kaynak/login.gogames.me/public'/version/'Resources/Textures/Model'/f'{ident:08X}.TexClient').read_bytes()
            rid,size=struct.unpack_from('<II',b);assert rid==ident
            p=8;expected=[]
            for index,name in enumerate(names):
                clip=cfg['clips'][name];sid,timing,count=struct.unpack_from('<IBH',b,p);p+=7
                assert (sid,timing,count)==(index,2 if clip['loop'] else 1,len(clip['assets']))
                ims=[]
                for asset in clip['assets']:
                    x,y,w,h,px,py,duration=struct.unpack_from('<hhhhhhH',b,p);p+=14
                    im=Image.open(BASE/'frames'/f'{asset:03}.png').convert('RGBA')
                    assert (w,h)==im.size and [px,py]==cfg['anchors'][str(asset)] and duration==clip['duration']
                    assert im.getchannel('A').getextrema()[0]==0
                    ims.append(im)
                if not clip['loop']:assert clip['assets'][-1]==0 and clip['returnFrame']==count-1
                expected.append(ims)
            assert p==8+size
            count=struct.unpack_from('<H',b,p)[0];p+=2;assert count==len(names)
            for ims in expected:
                n=struct.unpack_from('<I',b,p)[0];p+=4;pak=zlib.decompress(b[p:p+n]);p+=n
                _,width,height,_,_,_,count=struct.unpack_from('>BHHBBBH',pak)
                assert count==len(ims)
                offset=10+count*8;n=struct.unpack_from('>I',pak,offset)[0]
                atlas=Image.open(io.BytesIO(pak[offset+4:offset+4+n])).convert('RGB');assert atlas.size==(width,height*2)
                left=0
                for original in ims:
                    w,h=original.size
                    im=atlas.crop((left,0,left+w,h)).convert('RGBA')
                    im.putalpha(atlas.crop((left,height,left+w,height+h)).getchannel('R'))
                    assert im.tobytes()==original.tobytes(),'Native atlas pixels or alpha were shifted'
                    left+=w;checked+=1
                assert left==width
            assert struct.unpack_from('<H',b,p)[0]==len(names) and p+2==len(b)
    hero=next(h for h in json.loads((ROOT/'cikarim/veri-json/BaseHero.json').read_text(encoding='utf-8')) if int(h['id'],16)==cfg['heroId'])
    assert hero['assess']=='SSS' and hero['profession']==4 and hero['quality']==7
    effects=json.loads(hero['attackEffect'])
    for sid,name in [(13120911,'toad-mouth-barrier'),(13120912,'toad-confrontation-chant'),(13120913,'giant-gallant-rasengan'),(13120914,'raging-lions-mane'),(13120915,'senjutsu-power'),(13120916,'tale-of-jiraiya-revival')]:
        clip=cfg['clips'][name];effect=effects[str(sid)]
        assert list(effect['backPoint'])==[str(clip['returnFrame'])]
        if 'hitFrames' in clip:
            assert list(effect['appendEffect'])==list(map(str,clip['hitFrames']))
            assert sum(e['anmyhp']['0'] for e in effect['appendEffect'].values())==100
        else:assert 'appendEffect' not in effect and 'runPoint' not in effect
    print(f'PASS {checked} native frames: exact RGBA, per-frame pivots, 5 deterministic skill sequences, idle recovery, hit timing and SSS Assaulter metadata.')
if __name__=='__main__':main()
