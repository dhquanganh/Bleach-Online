"""Add a native model-2 Fortune Coin offer; preserve unrelated database rows."""
from pathlib import Path
import importlib.util,json,struct,zlib,shutil
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('f',B.parent/'ninja-fragments/build.py');f=importlib.util.module_from_spec(s);s.loader.exec_module(f)
ID=41900002;price=json.dumps({'type':24,'code':28,'amount':10},separators=(',',':'))
row={'id':f'{ID:08X}','model':2,'itemID':14900002,'oldPrice':price,'price':price,'number':1,'totalTimes':32767}
def patch(raw):
 kind=struct.unpack_from('<I',raw)[0]-0x1000000
 if kind!=0xCB:return raw
 old=f.records(raw,kind);rep=f.serialize(kind,row);existing=dict(old)
 out=raw[:4]+f.u32(len(old)+(ID not in existing))+b''.join(rep if i==ID else b for i,b in old)+(rep if ID not in existing else b'')
 assert dict(f.records(out,kind))[ID]==rep
 assert all(dict(f.records(out,kind))[i]==b for i,b in old if i!=ID)
 return out
active=json.loads((f.native.PUBLIC/'client-release.json').read_text())['version'];changes={}
for version in ['2017112917','2026090619',active]:
 for path in (f.native.PUBLIC/version/'Resources/Bin').rglob('*'):
  if not path.is_file() or path.suffix not in ('.bin','.binPackage'):continue
  data=path.read_bytes()
  if path.suffix=='.bin':
   raw=zlib.decompress(data);out=patch(raw)
   if raw!=out:changes[path]=zlib.compress(out)
  else:
   p=6;parts=[data[:6]];changed=False
   for _ in range(struct.unpack_from('<H',data,4)[0]):
    size=struct.unpack_from('<I',data,p)[0];p+=4;chunk=data[p:p+size];p+=size;raw=zlib.decompress(chunk);out=patch(raw)
    if raw!=out:chunk=zlib.compress(out);changed=True
    parts.extend([f.u32(len(chunk)),chunk])
   if changed:changes[path]=b''.join(parts)+data[p:]
table=f.native.DATA/'BlackMarket.json';rows=json.loads(table.read_text(encoding='utf-8'));rows=[r for r in rows if int(r['id'],16)!=ID]+[row]
changes[table]=(json.dumps(rows,ensure_ascii=False,indent=2)+'\n').encode()
for path,data in changes.items():
 backup=B/'hueco-offer-backup'/path.relative_to(f.ROOT)
 if path.exists() and not backup.exists():backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(path,backup)
 path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(data)
(B/'hueco-offer.json').write_text(json.dumps(row,indent=2)+'\n');print('PASS native Fortune Coin Hueco offer:',ID,len(changes),'files')
