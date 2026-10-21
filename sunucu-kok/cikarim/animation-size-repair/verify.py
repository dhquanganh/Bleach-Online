"""Check native actor pixels/pivots, release routing and Itachi isolation."""
from pathlib import Path
from PIL import Image, ImageChops
import hashlib, io, json, struct, zlib

B=Path(__file__).resolve().parent
ROOT=B.parents[1]
PUBLIC=ROOT/'kaynak/login.gogames.me/public'
MECHA=B.parent/'mecha-naruto'

def sha(p): return hashlib.sha256(p.read_bytes()).hexdigest()

def main():
    unchanged=json.loads((B/'itachi-before.json').read_text())
    repo=ROOT.parent
    for path,digest in unchanged: assert sha(repo/path)==digest, path
    animation=json.loads((MECHA/'animation.json').read_text())
    old=json.loads((B/'backups/cikarim/mecha-naruto/animation.json').read_text())
    assert animation['clips']==old['clips'] and animation['moves']==old['moves'] and animation['models']==old['models']
    current=(PUBLIC/'2026090619/Resources/Textures/Model/A9B1360C.TexClient').read_bytes()
    pos=8+struct.unpack_from('<I',current,4)[0]
    count=struct.unpack_from('<H',current,pos)[0];pos+=2
    names=animation['models']['11120950']['0c'];assert count==len(names)
    seqpos=8;checked=0
    for name in names:
        _,_,n=struct.unpack_from('<IBH',current,seqpos);seqpos+=7
        metadata=[struct.unpack_from('<hhhhhhH',current,seqpos+i*14) for i in range(n)];seqpos+=n*14
        length=struct.unpack_from('<I',current,pos)[0];pos+=4
        pak=zlib.decompress(current[pos:pos+length]);pos+=length
        _,width,height,_,_,_,pn=struct.unpack_from('>BHHBBBH',pak);assert pn==n
        pngpos=10+n*8;pnglen=struct.unpack_from('>I',pak,pngpos)[0]
        sheet=Image.open(io.BytesIO(pak[pngpos+4:pngpos+4+pnglen])).convert('RGB')
        assert sheet.size==(width,height*2) and max(sheet.size)<=4096
        ids=animation['clips'][name]['assets'];assert len(ids)==n
        for i,ident in enumerate(ids):
            x,y,w,h=struct.unpack_from('>hhhh',pak,10+i*8)
            actual=sheet.crop((x,y,x+w,y+h)).convert('RGBA')
            actual.putalpha(sheet.crop((x,y+height,x+w,y+height+h)).getchannel('R'))
            expected=Image.open(MECHA/'frames'/f'{ident:03}.png').convert('RGBA')
            assert actual.size==expected.size,(name,i)
            assert actual.tobytes()==expected.tobytes(),(name,i)
            assert list(metadata[i][4:6])==animation['framePivots'][str(ident)]
            assert metadata[i][6]==40
            checked+=1
    for version in ['2017112917','2026102105']:
        assert (PUBLIC/version/'Resources/Textures/Model/A9B1360C.TexClient').read_bytes()==current
    assert (PUBLIC/'2026090619/TApplication.swf').read_bytes()==(PUBLIC/'2026102105/TApplication.swf').read_bytes()
    raw=zlib.decompress((PUBLIC/'2026090619/version.swf').read_bytes());p=2;rows={}
    for _ in range(struct.unpack_from('<H',raw)[0]):
        n=struct.unpack_from('<H',raw,p)[0];p+=2;k=raw[p:p+n].decode();p+=n
        n=struct.unpack_from('<H',raw,p)[0];p+=2;v=raw[p:p+n].decode();p+=n;rows[k]=v
    assert rows['TApplication.swf']=='2026102105'
    for hero in [11120950,11120930]:
        for suffix in ['', '0A','0B','0C','0D','0E','0F']:
            key=f'Resources/Textures/Model/{int(f"{hero:X}"+suffix,16):08X}.TexClient'
            assert rows[key]=='2026102105'
            assert (PUBLIC/'2026102105'/key).read_bytes()==(PUBLIC/'2026090619'/key).read_bytes()
    result=json.loads((B/'result.json').read_text());result.update(nativeActorFramesPixelChecked=checked,itachiFilesHashChecked=len(unchanged),clipTimingAndDispatchUnchanged=True,releaseRoutesChecked=True)
    (B/'result.json').write_text(json.dumps(result,indent=2))
    print('PASS',checked,'native actor frames/pivots; 11 Itachi hashes; timing/dispatch and 14 versioned model routes')

if __name__=='__main__': main()
