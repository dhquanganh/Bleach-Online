"""Give the installed event client a fresh URL while preserving all other mappings."""
from pathlib import Path
import zlib,struct,shutil
from datetime import datetime
BASE=Path(__file__).resolve().parent
PUBLIC=BASE.parents[1]/'kaynak/login.gogames.me/public'
manifest=PUBLIC/'2026090619/version.swf'
original=manifest.read_bytes();raw=zlib.decompress(original)
count=struct.unpack_from('<H',raw)[0];pos=2;entries=[]
for _ in range(count):
 n=struct.unpack_from('<H',raw,pos)[0];pos+=2;key=raw[pos:pos+n];pos+=n
 n=struct.unpack_from('<H',raw,pos)[0];pos+=2;value=raw[pos:pos+n];pos+=n
 entries.append((key,value))
assert pos==len(raw)
version=b'2026101005'
updated=[(k,version if k==b'TApplication.swf' else v) for k,v in entries]
assert sum(k==b'TApplication.swf' for k,v in entries)==1
assert [e for e in entries if e[0]!=b'TApplication.swf']==[e for e in updated if e[0]!=b'TApplication.swf']
parts=[struct.pack('<H',count)]
for k,v in updated:parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
target=PUBLIC/version.decode()/'TApplication.swf';target.parent.mkdir(exist_ok=True)
shutil.copy2(PUBLIC/'2026090619/TApplication.swf',target)
backup=BASE/'backups'/(datetime.now().strftime('%Y%m%d-%H%M%S')+'-version.swf.bak')
backup.parent.mkdir(exist_ok=True);shutil.copy2(manifest,backup)
manifest.write_bytes(zlib.compress(b''.join(parts)))
assert target.read_bytes()==(PUBLIC/'2026090619/TApplication.swf').read_bytes()
print('Loader now selects Infinite Illusion client:',target)
