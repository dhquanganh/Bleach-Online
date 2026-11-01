from pathlib import Path
import importlib.util,json,copy,struct,zlib,shutil
from PIL import Image,ImageOps
B=Path('sunucu-kok/cikarim/konoha-great-tree').resolve();s=importlib.util.spec_from_file_location('f',B.parent/'ninja-fragments/build.py');f=importlib.util.module_from_spec(s);s.loader.exec_module(f)
ID=14900002;articles=json.loads((f.native.DATA/'Article.json').read_text(encoding='utf-8'));row=copy.deepcopy(next(a for a in articles if int(a['id'],16)==14900001));row.update(id=f'{ID:08X}',name='Fortune Coins',sort=ID,quality=5,picture=ID,minorType=96,costPrice='0_1_0_1',itemFunction=10,functionValue=0,f16=0,functionDesc='<p>Fortune Coins</p><p>Used to redeem rewards in Konoha\'s Great Tree - Fortune Store during the event. Expires at the event deadline.</p><p>Selling Price: 10 Silver</p>')
rep={ID:f.serialize(2,row)}
def patch(raw):
 kind=struct.unpack_from('<I',raw)[0]-0x1000000
 if kind!=2:return raw
 old=f.records(raw,kind);existing=dict(old);out=raw[:4]+f.u32(len(old)+(ID not in existing))+b''.join(rep.get(i,b) for i,b in old)+(rep[ID] if ID not in existing else b'');return out
changes={}
active=json.loads((f.native.PUBLIC/'client-release.json').read_text())['version']
for version in ['2017112917','2026090619',active]:
 for path in (f.native.PUBLIC/version/'Resources/Bin').rglob('*'):
  if not path.is_file() or path.suffix not in ('.bin','.binPackage'):continue
  raw=path.read_bytes()
  if path.suffix=='.bin':
   data=zlib.decompress(raw);out=patch(data)
   if out!=data:changes[path]=zlib.compress(out)
  else:
   p=6;parts=[raw[:6]];changed=False
   for _ in range(struct.unpack_from('<H',raw,4)[0]):
    size=struct.unpack_from('<I',raw,p)[0];p+=4;chunk=raw[p:p+size];p+=size;decoded=zlib.decompress(chunk);out=patch(decoded)
    if out!=decoded:chunk=zlib.compress(out);changed=True
    parts.extend([f.u32(len(chunk)),chunk])
   if changed:changes[path]=b''.join(parts)+raw[p:]
icon=ImageOps.contain(Image.open(B.parents[2]/'asset/Konoha_Great_Tree_Fortune_Store/Fortune_Coins_10189026.png').convert('RGBA'),(40,40),Image.Resampling.LANCZOS)
for version in ['2017112917','2026090619']:changes[f.native.PUBLIC/version/'Resources/Textures/Inventory'/f'{ID:08X}.TexClient']=f.inventory_texture(ID,icon)
changes[f.native.DATA/'Article.json']=(json.dumps([a for a in articles if a['id']!=row['id']]+[row],ensure_ascii=False,indent=2)+'\n').encode()
for path,data in changes.items():
 backup=B/'item-backup'/path.relative_to(f.ROOT)
 if path.exists() and not backup.exists():backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(path,backup)
 path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data)
(B/'coin.json').write_text(json.dumps(row,indent=2)+'\n');print('PASS Fortune Coin Article/native inventory icon',len(changes))
