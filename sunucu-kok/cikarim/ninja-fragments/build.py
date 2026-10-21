"""Add ninja Modify Fragments, native inventory icons and owned-only Mystic offers."""
from pathlib import Path
from PIL import Image,ImageOps
import argparse,copy,importlib.util,json,shutil,struct,sys,zlib
BASE=Path(__file__).resolve().parent;ROOT=BASE.parents[1]
sys.path.insert(0,str(BASE.parent/'naruto-sage'))
spec=importlib.util.spec_from_file_location('native',BASE.parent/'naruto-sage/build.py');native=importlib.util.module_from_spec(spec);spec.loader.exec_module(native)
FEATURES=[(11120901,14130901,41120901,'Naruto [Sage Mode]','../../asset/Naruto_Sage_Mode/assets/battle/role/head_45_45/11000171.png',7),
          (11120920,14130920,41120920,'Uchiha Obito [Rage Mode]','../../asset/Extracted_Obito_Rage/battle/role/head_45_45/11006051.png',7)]

ICON_IDS={item:item+0x200000 for item in [14130920,14130930,14130940]}
def icon_id(item):return ICON_IDS.get(item,item)
def inventory_texture(ident,image):
    # Inventory widgets can sample arbitrary ticks; a static image must never expire.
    data=bytearray(native.texture(ident,[image],pivot=False));data[12]=0
    return bytes(data)
def utf(s):return native.utf(s)
def u32(v):return native.u32(v)
def serialize(kind,r):
    if kind==2:return u32(int(r['id'],16))+utf(r['name'])+b''.join(u32(r[k]) for k in ['majorType','minorType','level','quality','cardType','sort','overlayNumber','bindMode','obtain'])+utf(r['functionDesc'])+u32(r['picture'])+utf(r['costPrice'])+b''.join(u32(r[k]) for k in ['sellPrice','itemFunction','functionValue','f16'])
    if kind==0xCC:return u32(int(r['id'],16))+u32(r['tabIndex'])+utf(r['chipID'])+u32(r['chipValue'])+u32(r['isOpen'])+b''.join(utf(r[k]) for k in ['cityID','f5','f6','f7'])+u32(r['f8'])+u32(r['f9'])
    return u32(int(r['id'],16))+u32(r['model'])+u32(r['itemID'])+utf(r['oldPrice'])+utf(r['price'])+u32(r['number'])+u32(r['totalTimes'])
def records(raw,kind):
    p=8;rows=[]
    def skip(p):return p+2+struct.unpack_from('<H',raw,p)[0]
    for _ in range(struct.unpack_from('<I',raw,4)[0]):
        start=p;ident=struct.unpack_from('<I',raw,p)[0]
        if kind==2:p=skip(p+4)+36;p=skip(p)+4;p=skip(p)+16
        elif kind==0xCC:
            p=skip(p+8)+8
            for _ in range(4):p=skip(p)
            p+=8
        else:p=skip(skip(p+12))+8
        rows.append((ident,raw[start:p]))
    assert p==len(raw),(hex(kind),p,len(raw))
    return rows
def main():
    parser=argparse.ArgumentParser();parser.add_argument('--apply',action='store_true');args=parser.parse_args()
    tables={k:json.loads((native.DATA/(name+'.json')).read_text(encoding='utf-8')) for k,name in [(2,'Article'),(0xCC,'HeroChangeAttr'),(0xCB,'BlackMarket')]}
    article=next(r for r in tables[2] if int(r['id'],16)==14130055)
    attr=next(r for r in tables[0xCC] if int(r['id'],16)==11150057)
    extras={2:[],0xCC:[],0xCB:[]};configfile=ROOT/'sunucu/mystic-shop-config.json';config=json.loads(configfile.read_text(encoding='utf-8'))
    changes={}
    for hero,item,offer,name,icon,quality in FEATURES:
        a=copy.deepcopy(article);a.update(id=f'{item:08X}',name=name+' Modify Fragment',level=1,quality=quality,sort=item,picture=icon_id(item),
            functionDesc=f'<p>{name} Modify Fragment. Used for this partner\'s star upgrades and reincarnation.</p>')
        extras[2].append(a)
        r=copy.deepcopy(attr);r.update(id=f'{hero:08X}',chipValue=item,f8=0,f9=0)
        # Fragment association only: do not borrow another hero's Modify challenge/city.
        extras[0xCC].append(r)
        price={'type':1,'code':config['currencyID'],'amount':100}
        extras[0xCB].append({'id':f'{offer:08X}','model':1,'itemID':item,'oldPrice':json.dumps(price,separators=(',',':')),'price':json.dumps(price,separators=(',',':')),'number':1,'totalTimes':2147483647})
        new={'id':offer,'model':1,'heroID':hero,'itemID':item,'number':1,'price':price,'totalTimes':2147483647}
        config['offers']=[o for o in config['offers'] if o['id']!=offer]+[new]
        im=ImageOps.fit(Image.open(ROOT/'gorsel'/icon).convert('RGBA'),(40,40),Image.Resampling.LANCZOS)
        for version in ['2017112917','2026090619']:
            changes[native.PUBLIC/version/'Resources/Textures/Inventory'/f'{icon_id(item):08X}.TexClient']=inventory_texture(icon_id(item),im)
    def patch(raw):
        kind=struct.unpack_from('<I',raw)[0]-0x1000000
        if kind not in extras:return raw
        old=records(raw,kind);replacement={int(r['id'],16):serialize(kind,r) for r in extras[kind]}
        result=[(i,replacement.get(i,b)) for i,b in old]+[(i,b) for i,b in replacement.items() if i not in dict(old)]
        new=raw[:4]+u32(len(result))+b''.join(b for i,b in result)
        check=dict(records(new,kind));assert all(check[i]==b for i,b in old if i not in replacement)
        assert all(check[i]==b for i,b in replacement.items())
        return new
    for f in native.PUBLIC.glob('*/Resources/Bin/**/*'):
        if not f.is_file():continue
        b=f.read_bytes()
        if f.suffix=='.bin':
            raw=zlib.decompress(b);new=patch(raw)
            if raw!=new:changes[f]=zlib.compress(new)
        elif f.suffix=='.binPackage':
            p=6;parts=[b[:6]];changed=False
            for _ in range(struct.unpack_from('<H',b,4)[0]):
                n=struct.unpack_from('<I',b,p)[0];p+=4;c=b[p:p+n];p+=n;raw=zlib.decompress(c);new=patch(raw)
                if raw!=new:c=zlib.compress(new);changed=True
                parts.extend([u32(len(c)),c])
            if changed:changes[f]=b''.join(parts)+b[p:]
    for kind,name in [(2,'Article'),(0xCC,'HeroChangeAttr'),(0xCB,'BlackMarket')]:
        own={r['id']:r for r in extras[kind]};old=tables[kind]
        new=[own.get(r['id'],r) for r in old]+[r for r in own.values() if r['id'] not in {o['id'] for o in old}]
        if old!=new:changes[native.DATA/(name+'.json')]=(json.dumps(new,ensure_ascii=False,indent=2)+'\n').encode()
    changes[configfile]=(json.dumps(config,ensure_ascii=False,indent=2)+'\n').encode()
    if args.apply:
        for f,b in changes.items():
            if f.exists() and f.read_bytes()==b:continue
            backup=BASE/'backups'/f.relative_to(ROOT)
            if f.exists() and not backup.exists():backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(f,backup)
            f.parent.mkdir(parents=True,exist_ok=True);f.write_bytes(b)
    print('PASS',len(FEATURES),'Modify Fragments, inventory icons, HeroChangeAttr associations and 100-gem owned-only offers;',len(changes),'files. Applied:',args.apply)
if __name__=='__main__':main()
