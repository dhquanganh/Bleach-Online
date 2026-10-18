"""Decode installed native assets, including alpha/pivots, and verify actual combat markers."""
from pathlib import Path
from PIL import Image
import io,json,struct,zlib,re
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
def main():
    cfg=json.loads((BASE/'animation.json').read_text());checked=0
    jiraiya=json.loads((BASE.parent/'jiraiya-toads/animation.json').read_text())
    assert cfg['frameRate']==jiraiya['frameRate']==25 and cfg['pivot']==[128,210]
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
                        assert (w,h)==im.size and [px,py]==cfg['pivot'] and ms==40
                        assert im.getchannel('A').getextrema()[0]==0;ims.append(im)
                    if not c['loop']:
                        assert c['returnFrame']==count-1
                        if not name.endswith('-die'):assert c['assets'][-1]==c['idle']
                    expected.append(ims)
                assert p==8+size
                count=struct.unpack_from('<H',b,p)[0];p+=2;assert count==len(expected)
                for ims in expected:
                    n=struct.unpack_from('<I',b,p)[0];p+=4;pak=zlib.decompress(b[p:p+n]);p+=n
                    _,width,height,_,_,_,count=struct.unpack_from('>BHHBBBH',pak);assert count==len(ims) and width<32768
                    offset=10+count*8;n=struct.unpack_from('>I',pak,offset)[0]
                    atlas=Image.open(io.BytesIO(pak[offset+4:offset+4+n])).convert('RGB');assert atlas.size==(width,height*2)
                    left=0
                    for original in ims:
                        w,h=original.size;im=atlas.crop((left,0,left+w,h)).convert('RGBA')
                        im.putalpha(atlas.crop((left,height,left+w,height+h)).getchannel('R'))
                        assert im.tobytes()==original.tobytes(),'Native frame/alpha shifted during packing'
                        left+=w;checked+=1
                    assert left==width
                assert struct.unpack_from('<H',b,p)[0]==len(names) and p+2==len(b)
    heroes=json.loads((ROOT/'cikarim/veri-json/BaseHero.json').read_text(encoding='utf-8'))
    hero=next(h for h in heroes if int(h['id'],16)==11120910)
    assert hero['profession']==3 and hero['quality']==7 and hero['assess']=='SSS' and not hero['isSummon']
    assert all(next(h for h in heroes if int(h['id'],16)==sid)['isSummon'] for sid in [11120911,11120912,11120913,11120914])
    effects=json.loads(hero['attackEffect'])
    for sid,name in {13120931:'white-snake-assault',13120932:'bracken-dance',13120933:'white-extreme-attack',13120937:'mu-strike',13120939:'deidara-attack',13120940:'dan-attack',13120941:'pakura-attack'}.items():
        c=cfg['clips'][name];effect=effects[str(sid)]
        assert list(effect['backPoint'])==[str(c['returnFrame'])]
        assert list(effect['appendEffect'])==list(map(str,c['hitFrames']))
        assert sum(e['anmyhp']['0'] for e in effect['appendEffect'].values())==100
    assert effects['13120932']['runPoint']=={'0':{'target':2}},'Support must move into melee range'
    assert 'runPoint' not in effects['13120931'] and 'runPoint' not in effects['13120940']
    version=re.search("VERSION=b'([0-9]+)'",(BASE/'build-client.py').read_text())[1]
    (BASE/'validation/rebuild-v3.json').write_text(json.dumps({
        'clientVersion':version,'generatedFrames':cfg['frameCount'],
        'nativeFramesVerified':checked,'clips':len(cfg['clips']),
        'frameRate':cfg['frameRate'],'matchesJiraiya':True,
        'exactRGBA':True,'hitMarkersVerified':True,
        'runtimePlayback':'See vfx-v3/native/result.json for isolated Flash component playback.'},indent=2))
    print(f'PASS {checked} native frames across 5 characters and 2 resource sets: exact RGBA, safe atlas sizes, ground registration, 25 FPS, idle return, hit markers; SSS Support melee and summon-only recruitment flags.')
if __name__=='__main__':main()
