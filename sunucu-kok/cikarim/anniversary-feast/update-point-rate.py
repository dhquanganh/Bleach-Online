"""Synchronize the native Feast description with the server's 10-gold point rate."""
from pathlib import Path
import importlib.util,json,struct,zlib,shutil
B=Path(__file__).resolve().parent;R=B.parents[1];P=R/'kaynak/login.gogames.me/public';C=P/'2026090619';V='2026102343'
f=R/'cikarim/veri-json/CoolSummer.json';rows=json.loads(f.read_text(encoding='utf8'));pairs=[]
for row in rows:
 old=row['desc'].replace('10 Gold = 1 Point','1 Gold = 1 Point');new=old.replace('1 Gold = 1 Point','10 Gold = 1 Point');row['desc']=new
 if old!=new:pairs.append((struct.pack('<H',len(old.encode()))+old.encode(),struct.pack('<H',len(new.encode()))+new.encode()))
def patch(raw):
 for old,new in pairs:raw=raw.replace(old,new)
 return raw
changes={}
for path in (C/'Resources/Bin').rglob('*'):
 if not path.is_file():continue
 data=path.read_bytes()
 if path.suffix=='.bin':
  raw=zlib.decompress(data);new=patch(raw)
  if raw!=new:changes[path]=zlib.compress(new)
 elif path.suffix=='.binPackage':
  pos=6;parts=[data[:6]];changed=False
  for _ in range(struct.unpack_from('<H',data,4)[0]):
   n=struct.unpack_from('<I',data,pos)[0];pos+=4;block=data[pos:pos+n];pos+=n;raw=zlib.decompress(block);new=patch(raw)
   if raw!=new:block=zlib.compress(new);changed=True
   parts.extend([struct.pack('<I',len(block)),block])
  if changed:changes[path]=b''.join(parts)+data[pos:]
assert changes,'No native Feast descriptions found'
backup=B/'point-rate-backups';backup.mkdir(exist_ok=True)
for path in [f,*changes,C/'version.swf',P/'client-release.json']:
 dest=backup/path.relative_to(R);dest.parent.mkdir(parents=True,exist_ok=True)
 if not dest.exists():shutil.copy2(path,dest)
f.write_text(json.dumps(rows,ensure_ascii=False,indent=2)+'\n',encoding='utf8')
release=P/V;release.mkdir(exist_ok=True)
for path,data in changes.items():
 path.write_bytes(data);dest=release/path.relative_to(C);dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(data)
s=importlib.util.spec_from_file_location('codec',B.parent/'naruto-sage-native/release.py');codec=importlib.util.module_from_spec(s);s.loader.exec_module(codec)
version=C/'version.swf';updates={p.relative_to(C).as_posix().encode():V.encode() for p in changes};entries=codec.decode(version.read_bytes());version.write_bytes(codec.encode([(k,updates.get(k,v)) for k,v in entries]))
for name in ['TApplication.swf','index.swf','version.swf']:shutil.copy2(C/name,release/name)
pointer=P/'client-release.json';temp=pointer.with_suffix('.tmp');temp.write_text(json.dumps({'version':V})+'\n');temp.replace(pointer)
print('PASS native Feast: 10 Gold = 1 Point;',len(changes),'packages; local release',V)
