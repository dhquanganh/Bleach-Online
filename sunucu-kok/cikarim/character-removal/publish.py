"""Publish the sanitized client and data, invalidate historical app routes."""
from pathlib import Path
import hashlib,json,shutil,struct,zlib
BASE=Path(__file__).resolve().parent;PUBLIC=BASE.parents[1]/'kaynak/login.gogames.me/public';CANON=PUBLIC/'2026090619';VERSION='2026102310'
def rows(data):
 raw=zlib.decompress(data);pos=2;out=[]
 for _ in range(struct.unpack_from('<H',raw)[0]):
  n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n;n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n;out.append((k,v))
 assert pos==len(raw);return out
def encode(items):return zlib.compress(struct.pack('<H',len(items))+b''.join(struct.pack('<H',len(k))+k+struct.pack('<H',len(v))+v for k,v in items))
def main():
 info=json.loads((BASE/'client-verification.json').read_text());app=(CANON/'TApplication.swf').read_bytes()
 assert hashlib.sha256(app).hexdigest()==info['sha256']
 dest=PUBLIC/VERSION;dest.mkdir(exist_ok=True);files={'TApplication.swf'}
 (dest/'TApplication.swf').write_bytes(app)
 for file in (CANON/'Resources/Bin').rglob('*'):
  if not file.is_file() or file.suffix not in ('.bin','.binPackage'):continue
  rel=file.relative_to(CANON);target=dest/rel;target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(file,target);files.add(rel.as_posix())
 for file in PUBLIC.glob('*/TApplication.swf'):file.write_bytes(app)
 for file in PUBLIC.glob('*/version.swf'):
  data=rows(file.read_bytes());new=[(k,VERSION.encode() if k.decode() in files else v) for k,v in data];file.write_bytes(encode(new))
 # Force every known data route in the new bootstrap to use sanitized bytes.
 data=rows((CANON/'version.swf').read_bytes());existing={k for k,v in data}
 data.extend((name.encode(),VERSION.encode()) for name in files if name.encode() not in existing)
 (CANON/'version.swf').write_bytes(encode(data))
 shutil.copy2(CANON/'version.swf',dest/'version.swf');shutil.copy2(CANON/'index.swf',dest/'index.swf');files.update({'index.swf','version.swf'})
 report={'version':VERSION,'files':[{'path':p,'sha256':hashlib.sha256((dest/p).read_bytes()).hexdigest()} for p in sorted(files)]}
 (BASE/'release.json').write_text(json.dumps(report,indent=2))
 pointer=PUBLIC/'client-release.json';temp=pointer.with_suffix('.tmp');temp.write_text(json.dumps({'version':VERSION})+'\n');temp.replace(pointer)
 print('PASS sanitized release',VERSION,'published;',len(files),'cache-busted app/data routes')
if __name__=='__main__':main()
