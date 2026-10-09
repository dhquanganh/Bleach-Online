from pathlib import Path
import zlib,struct,shutil,hashlib
from datetime import datetime
base=Path(__file__).resolve().parent
public=base.parents[1]/'kaynak/login.gogames.me/public'
p=public/'2026090619/version.swf'
original=p.read_bytes();raw=zlib.decompress(original);pos=2;count=struct.unpack_from('<H',raw)[0];entries=[]
for i in range(count):
 n=struct.unpack_from('<H',raw,pos)[0];pos+=2;key=raw[pos:pos+n];pos+=n
 n=struct.unpack_from('<H',raw,pos)[0];pos+=2;value=raw[pos:pos+n];pos+=n
 entries.append((key,value))
assert pos==len(raw)
updated=[(k,b'2026090619' if k==b'TApplication.swf' else v) for k,v in entries]
assert sum(k==b'TApplication.swf' for k,v in updated)==1
parts=[struct.pack('<H',count)]
for k,v in updated:parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
backup=base/'backups'/datetime.now().strftime('%Y%m%d-%H%M%S-version.swf.bak');backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(p,backup)
p.write_bytes(zlib.compress(b''.join(parts)))
assert [e for e in entries if e[0]!=b'TApplication.swf']==[e for e in updated if e[0]!=b'TApplication.swf']
actual=public/'2026090619/TApplication.swf'
assert actual.read_bytes()==(base/'TApplication-protected.swf').read_bytes()
print('PASS: loader manifest selects installed Tower of Gold client at /public/2026090619/TApplication.swf.')
print('SHA256:',hashlib.sha256(actual.read_bytes()).hexdigest())
print('All other resource mappings preserved. Manifest backup:',backup)
