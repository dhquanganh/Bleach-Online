"""Decode installed native assets, including alpha/pivots, and verify actual combat markers."""
from pathlib import Path
from PIL import Image
import io,json,struct,zlib,re
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
def main():
    cfg=json.loads((BASE/'animation.json').read_text());checked=0
    for hero,models in cfg['models'].items():
        assert models['0e']==models['0a']==models[''],f'Lobby showcase must use standing idle: {hero}'
    for version in ['2017112917','2026090619']:
        dest=ROOT/'kaynak/login.gogames.me/public'/version/'Resources/Textures'
        for hero,textures in cfg['models'].items():
            for suffix,names in textures.items():
                names=[names] if isinstance(names,str) else names;ident=int(f'{int(hero):X}'+suffix,16)
                b=(dest/'Model'/f'{ident:08X}.TexClient').read_bytes();rid,size=struct.unpack_from('<II',b);assert rid==ident;p=8;expected=[]
                for index,name in enumerate(names):
                    c=cfg['clips'][name];sid,timing,count=struct.unpack_from('<IBH',b,p);p+=7
                    assert (sid,timing,count)==(index,2 if c['loop'] else 1,len(c['assets']))
                    ims=[]
                    for asset in c['assets']:
                        x,y,w,h,px,py,ms=struct.unpack_from('<hhhhhhH',b,p);p+=14
                        im=Image.open(BASE/'frames'/f'{asset:03}.png').convert('RGBA')
                        assert (w,h)==im.size and [px,py]==cfg['framePivots'][str(asset)] and ms==40
                        assert im.getchannel('A').getextrema()[0]==0;ims.append(im)
                    if not c['loop']:
                        assert c['returnFrame']==count-1
                        assert c['assets'][-1]==cfg['clips']['idle']['assets'][0]
                    expected.append(ims)
                assert p==8+size
                count=struct.unpack_from('<H',b,p)[0];p+=2;assert count==len(expected)
                for ims in expected:
                    n=struct.unpack_from('<I',b,p)[0];p+=4;pak=zlib.decompress(b[p:p+n]);p+=n
                    kind,width,height,_,_,_,count=struct.unpack_from('>BHHBBBH',pak);assert kind==127 and count==len(ims) and width<32768
                    offset=10+count*8;n=struct.unpack_from('>I',pak,offset)[0]
                    atlas=Image.open(io.BytesIO(pak[offset+4:offset+4+n])).convert('RGB');assert atlas.size==(width,height*2)
                    for index,original in enumerate(ims):
                        left,top,w,h=struct.unpack_from('>hhhh',pak,10+index*8)
                        assert original.size==(w,h)
                        im=atlas.crop((left,top,left+w,top+h)).convert('RGBA')
                        im.putalpha(atlas.crop((left,top+height,left+w,top+height+h)).getchannel('R'))
                        assert im.tobytes()==original.tobytes(),'Native frame/alpha shifted during packing'
                        checked+=1
                    assert width<=4096 and height*2<=4096
                assert struct.unpack_from('<H',b,p)[0]==len(names) and p+2==len(b)
    heroes=json.loads((ROOT/'cikarim/veri-json/BaseHero.json').read_text(encoding='utf-8'))
    hero=next(h for h in heroes if int(h['id'],16)==11120920)
    assert hero['profession']==2 and hero['quality']==7 and hero['assess']=='SSS'
    effects=json.loads(hero['attackEffect'])
    for sid,name in cfg['moves'].items():
        clip=cfg['clips'][name];effect=effects[sid]
        assert list(effect['backPoint'])==[str(clip['returnFrame'])]
        if 'hitFrames' in clip:
            assert list(effect['appendEffect'])==list(map(str,clip['hitFrames']))
            assert sum(e['anmyhp']['0'] for e in effect['appendEffect'].values())==100
    (BASE/'validation/assets.json').write_text(json.dumps({'nativeFramesVerified':checked,'exactRGBA':True,'frameMs':40,'clips':len(cfg['clips']),'vanguard':True,'SSS':True},indent=2))
    print('PASS',checked,'native frames: exact RGBA, pivots, atlas limits, timing and hit markers; SSS Vanguard')
if __name__=='__main__':main()
