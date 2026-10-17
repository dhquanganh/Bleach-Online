"""Verify native DB associations and exact icon pixels, not just JSON presence."""
from pathlib import Path
from PIL import Image,ImageOps
import io,json,struct,zlib
import build
def decode(path):
    b=path.read_bytes();pos=8+struct.unpack_from('<I',b,4)[0]
    assert struct.unpack_from('<H',b,pos)[0]==1
    length=struct.unpack_from('<I',b,pos+2)[0];pak=zlib.decompress(b[pos+6:pos+6+length])
    _,w,h,_,_,_,count=struct.unpack_from('>BHHBBBH',pak);assert count==1
    offset=10+count*8;n=struct.unpack_from('>I',pak,offset)[0]
    rgb=Image.open(io.BytesIO(pak[offset+4:offset+4+n])).convert('RGB')
    im=rgb.crop((0,0,w,h)).convert('RGBA');im.putalpha(rgb.crop((0,h,w,h*2)).getchannel('R'))
    return im
def main():
    tables={kind:{int(r['id'],16):r for r in json.loads((build.native.DATA/(name+'.json')).read_text(encoding='utf-8'))} for kind,name in [(2,'Article'),(0xCC,'HeroChangeAttr'),(0xCB,'BlackMarket')]}
    ids={2:[f[1] for f in build.FEATURES],0xCC:[f[0] for f in build.FEATURES],0xCB:[f[2] for f in build.FEATURES]}
    checked=0
    for f in build.native.PUBLIC.glob('*/Resources/Bin/**/*.binPackage'):
        b=f.read_bytes();p=6
        for _ in range(struct.unpack_from('<H',b,4)[0]):
            n=struct.unpack_from('<I',b,p)[0];p+=4;raw=zlib.decompress(b[p:p+n]);p+=n
            kind=struct.unpack_from('<I',raw)[0]-0x1000000
            if kind not in ids:continue
            records=dict(build.records(raw,kind))
            for ident in ids[kind]:assert records[ident]==build.serialize(kind,tables[kind][ident]);checked+=1
    assert checked>0
    for hero,item,offer,name,icon,quality in build.FEATURES:
        assert tables[0xCC][hero]['chipValue']==item
        assert tables[2][item]['picture']==item
        assert tables[0xCB][offer]['itemID']==item
        source=Image.open(build.ROOT/'gorsel'/icon).convert('RGBA')
        for version in ['2017112917','2026090619']:
            root=build.native.PUBLIC/version/'Resources/Textures'
            for category in ['HeadIcon','SmallIcon']:
                im=decode(root/category/f'{hero:08X}.TexClient')
                assert im.size==(48,48) and im.tobytes()==ImageOps.fit(source,(48,48),Image.Resampling.LANCZOS).tobytes()
            im=decode(root/'Inventory'/f'{item:08X}.TexClient')
            assert im.size==(40,40) and im.tobytes()==ImageOps.fit(source,(40,40),Image.Resampling.LANCZOS).tobytes()
    print(f'PASS {checked} native DB records across packages, unique fragment mappings, exact supplied Jiraiya portrait, 48px hero icons and 40px fragment icons.')
if __name__=='__main__':main()
