"""Patch only Tensō's ConfigValue entry and publish cache-busted client data."""
from pathlib import Path
import struct,zlib,json,shutil
BASE=Path(__file__).resolve().parent
PUBLIC=BASE.parents[1]/'kaynak/login.gogames.me/public';CANON=PUBLIC/'2026090619';VERSION='2026102315'
old=struct.pack('<IH',61400004,1)+b'2'+b'\x03\x00int\x01\x00\x00\x00'
new=struct.pack('<IH',61400004,2)+b'10'+b'\x03\x00int\x01\x00\x00\x00'
def patch(data):
 pos=6;parts=[data[:6]];changed=0
 for _ in range(struct.unpack_from('<H',data,4)[0]):
  n=struct.unpack_from('<I',data,pos)[0];pos+=4;block=data[pos:pos+n];pos+=n
  try:raw=zlib.decompress(block)
  except zlib.error:raw=b''
  if raw[:4]==struct.pack('<I',0x01000010) and old in raw:
   assert raw.count(old)==1
   updated=raw.replace(old,new);assert updated.replace(new,old)==raw
   block=zlib.compress(updated);changed+=1
  parts.extend([struct.pack('<I',len(block)),block])
 parts.append(data[pos:]);return b''.join(parts),changed
def decode(data):
 raw=zlib.decompress(data);pos=2;rows=[]
 for _ in range(struct.unpack_from('<H',raw)[0]):
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n;rows.append((k,v))
 assert pos==len(raw);return rows
def encode(rows):return zlib.compress(struct.pack('<H',len(rows))+b''.join(struct.pack('<H',len(k))+k+struct.pack('<H',len(v))+v for k,v in rows))
release=PUBLIC/VERSION;assert not release.exists()
changes=[]
for file in (CANON/'Resources/Bin').rglob('*.binPackage'):
 data,count=patch(file.read_bytes())
 if count:assert count==1;changes.append((file,data))
assert len(changes)>=3
backup=BASE/'daily-limit-backups';backup.mkdir(exist_ok=True)
release.mkdir()
files={'TApplication.swf'}
for file,data in changes:
 rel=file.relative_to(CANON);saved=backup/rel;saved.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(file,saved)
 file.write_bytes(data);dest=release/rel;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(data);files.add(rel.as_posix())
manifest=CANON/'version.swf';pointer=PUBLIC/'client-release.json'
for file in [manifest,pointer]:shutil.copy2(file,backup/file.name)
rows=decode(manifest.read_bytes());keys={k for k,v in rows};overrides={name.encode():VERSION.encode() for name in files}
rows=[(k,overrides.get(k,v)) for k,v in rows]+[(k,v) for k,v in overrides.items() if k not in keys]
manifest.write_bytes(encode(rows))
for name in ['TApplication.swf','index.swf','version.swf']:shutil.copy2(CANON/name,release/name)
for file,_ in changes:
 data=(release/file.relative_to(CANON)).read_bytes();_,count=patch(data);assert count==0
assert dict(decode((release/'version.swf').read_bytes()))[b'Resources/Bin/normal/0F000000.binPackage']==VERSION.encode()
temp=pointer.with_suffix('.tmp');temp.write_text(json.dumps({'version':VERSION})+'\n');temp.replace(pointer)
print('PASS: daily limit 10; only target ConfigValue row changed in',len(changes),'data packages; published',VERSION)
