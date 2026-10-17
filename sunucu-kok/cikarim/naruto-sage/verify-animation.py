"""Check shipped frame pixels, pivots, timing and effect/animation synchronization."""
from pathlib import Path
from PIL import Image
import io,json,struct,zlib
BASE=Path(__file__).resolve().parent
ROOT=BASE.parents[1]
def main():
    cfg=json.loads((BASE/'animation.json').read_text())
    files={int(p.stem.rsplit('_',1)[1]):p for p in (ROOT.parent/'asset/Browser Games - Naruto Online - Recruitable Characters - Naruto Uzumaki (Sage Mode)').rglob('*.png')}
    checked=0
    for version in ['2017112917','2026090619']:
        for suffix,names in cfg['modelTextures'].items():
            names=[names] if isinstance(names,str) else names
            ident=int(f'{11120901:X}'+suffix,16)
            b=(ROOT/'kaynak/login.gogames.me/public'/version/'Resources/Textures/Model'/f'{ident:08X}.TexClient').read_bytes()
            assert struct.unpack_from('<I',b)[0]==ident
            size=struct.unpack_from('<I',b,4)[0];seq=b[8:8+size];p=0;metadata=[]
            for index,name in enumerate(names):
                clip=cfg['clips'][name];sid,timing,count=struct.unpack_from('<IBH',seq,p);p+=7
                assert sid==index and timing==(2 if clip['loop'] else 1) and count==len(clip['assets'])
                entries=[]
                for asset in clip['assets']:
                    x,y,w,h,px,py,duration=struct.unpack_from('<hhhhhhH',seq,p);p+=14
                    im=Image.open(files[asset]).convert('RGBA')
                    assert (w,h)==im.size and [px,py]==cfg['anchors'][str(asset)] and duration==clip['duration']
                    entries.append(im)
                metadata.append(entries)
                if not clip['loop']:assert clip['assets'][-1]==51,'One-shot must recover to the idle pose'
            assert p==len(seq)
            p=8+size;count=struct.unpack_from('<H',b,p)[0];p+=2;assert count==len(names)
            for expected in metadata:
                n=struct.unpack_from('<I',b,p)[0];p+=4;pak=zlib.decompress(b[p:p+n]);p+=n
                _,width,height,_,_,_,count=struct.unpack_from('>BHHBBBH',pak)
                assert count==len(expected)
                offset=10+count*8;n=struct.unpack_from('>I',pak,offset)[0]
                atlas=Image.open(io.BytesIO(pak[offset+4:offset+4+n])).convert('RGB');assert atlas.size==(width,height*2)
                x=0
                for original in expected:
                    w,h=original.size
                    im=atlas.crop((x,0,x+w,h)).convert('RGBA');im.putalpha(atlas.crop((x,height,x+w,height+h)).getchannel('R'))
                    assert im.tobytes()==original.tobytes(),'PAK pixels shifted/cropped or alpha lost'
                    checked+=1;x+=w
                assert x==width
            assert struct.unpack_from('<H',b,p)[0]==len(names) and p+2==len(b)
    heroes=json.loads((ROOT/'cikarim/veri-json/BaseHero.json').read_text(encoding='utf-8'))
    for hero in [h for h in heroes if int(h['id'],16) in [11120901,11120902]]:
        effects=json.loads(hero['attackEffect'])
        for sid,name in [(13120903,'barrage'),(13120901,'mystery'),(13120902,'summon'),(13120904,'chase')]:
            clip=cfg['clips'][name];effect=effects[str(sid)]
            assert list(effect['backPoint'])==[str(clip['returnFrame'])]
            assert clip['returnFrame']<len(clip['assets'])
            if name=='summon':assert 'appendEffect' not in effect and 'runPoint' not in effect
            else:
                hits={int(frame):e for frame,e in effect['appendEffect'].items() if 'anmyhp' in e}
                assert sorted(hits)==clip['hitFrames']
                assert sum(sum(value for key,value in e['anmyhp'].items() if key!='checkDie') for e in hits.values())==100
    hair=[]
    for asset in cfg['clips']['idle']['assets']:
        im=Image.open(files[asset]).convert('RGBA');px,py=cfg['anchors'][str(asset)]
        assert im.height-py==0,'Idle feet leave the baseline'
        xs=[x-px for y in range(35) for x in range(im.width) if (lambda r,g,b,a:a>180 and r>170 and g>160 and b<130)(*im.getpixel((x,y)))]
        hair.append(sum(xs)/len(xs))
    assert max(hair)-min(hair)<2,'Standing body jitters horizontally'
    print(f'PASS {checked} native frames: original pixels/alpha, independent pivots, idle stability, multi-sequence casts, hit timing and return to idle.')
if __name__=='__main__':main()
