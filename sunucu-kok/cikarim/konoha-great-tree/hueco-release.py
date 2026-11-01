"""Publish authoritative patched tables instead of older manifest table locations."""
from pathlib import Path
import importlib.util,json,shutil,struct,zlib
B=Path(__file__).resolve().parent
s=importlib.util.spec_from_file_location('m',B.parent/'kakuzu-edo/release.py');m=importlib.util.module_from_spec(s);s.loader.exec_module(m)
s=importlib.util.spec_from_file_location('f',B.parent/'ninja-fragments/build.py');f=importlib.util.module_from_spec(s);s.loader.exec_module(f)
P=f.native.PUBLIC;C=P/'2026090619';V='2026103106';assert json.loads((P/'client-release.json').read_text())['version']=='2026103105'
dest=P/V;assert not dest.exists();dest.mkdir();rows=m.rows((C/'version.swf').read_bytes());tables=0
for row in rows:
 key,ver=[x.decode() for x in row]
 if key.startswith('Resources/Bin/') and key.endswith(('.bin','.binPackage')):
  source=next((p for p in [C/key,P/ver/key,P/'2017112917'/key] if p.is_file()),None)
  if source:
   target=dest/key;target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(source,target);row[1]=V.encode();tables+=1
 if key=='TApplication.swf':row[1]=V.encode()
for source in (C/'Resources/Bin').rglob('*'):
 if source.is_file() and source.suffix in ('.bin','.binPackage'):
  target=dest/source.relative_to(C)
  if not target.exists():target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(source,target)
validated=[]
for path in (dest/'Resources/Bin').rglob('*.binPackage'):
 data=path.read_bytes();p=6
 for _ in range(struct.unpack_from('<H',data,4)[0]):
  n=struct.unpack_from('<I',data,p)[0];p+=4;raw=zlib.decompress(data[p:p+n]);p+=n
  if struct.unpack_from('<I',raw)[0]==0x10000cb:
   found=dict(f.records(raw,0xCB));row=f.serialize(0xCB,json.loads((B/'hueco-offer.json').read_text()));assert found[41900002]==row
   validated.append(str(path.relative_to(dest)))
assert validated
manifest=m.encode(rows);(dest/'version.swf').write_bytes(manifest);shutil.copy2(C/'TApplication.swf',dest/'TApplication.swf');shutil.copy2(C/'index.swf',dest/'index.swf')
(C/'version.swf').write_bytes(manifest);(P/'client-release.json').write_text(json.dumps({'version':V})+'\n')
(B/'hueco-client/release.json').write_text(json.dumps({'version':V,'tables':tables,'validatedOfferPackages':validated,'offerId':41900002,'price':10,'quantity':1},indent=2))
print('PASS Hueco resource release',V,'validated Fortune Coin offer in',len(validated),'native packages')
