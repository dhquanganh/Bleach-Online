from pathlib import Path
import zlib,struct,shutil,hashlib,sys
from datetime import datetime
BASE=Path(__file__).resolve().parent
PUBLIC=BASE.parents[1]/'kaynak/login.gogames.me/public'
manifest=PUBLIC/'2026090619/version.swf'
original=manifest.read_bytes();raw=zlib.decompress(original)
count=struct.unpack_from('<H',raw)[0];offset=2;entries=[]
for _ in range(count):
    n=struct.unpack_from('<H',raw,offset)[0];offset+=2
    key=raw[offset:offset+n];offset+=n
    n=struct.unpack_from('<H',raw,offset)[0];offset+=2
    value=raw[offset:offset+n];offset+=n
    entries.append((key,value))
assert offset==len(raw)
active=dict(entries)[b'TApplication.swf'].decode()
canonical=PUBLIC/'2026090619/TApplication.swf'
print('Active client:',active)
print('Canonical hash:',hashlib.sha256(canonical.read_bytes()).hexdigest()[:16])
print('Active hash:',hashlib.sha256((PUBLIC/active/'TApplication.swf').read_bytes()).hexdigest()[:16])
if '--install' in sys.argv:
    version=b'2026101112'
    updated=[(k,version if k==b'TApplication.swf' else v) for k,v in entries]
    assert sum(k==b'TApplication.swf' for k,v in entries)==1
    assert [e for e in entries if e[0]!=b'TApplication.swf']==[e for e in updated if e[0]!=b'TApplication.swf']
    parts=[struct.pack('<H',count)]
    for k,v in updated:parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
    target=PUBLIC/version.decode()/'TApplication.swf';target.parent.mkdir(exist_ok=True)
    backup=BASE/'backups'/(datetime.now().strftime('%Y%m%d-%H%M%S')+'-version.swf.bak')
    backup.parent.mkdir(exist_ok=True);shutil.copy2(manifest,backup)
    if target.exists():shutil.copy2(target,backup.with_name(backup.name+'-client'))
    shutil.copy2(canonical,target)
    manifest.write_bytes(zlib.compress(b''.join(parts)))
    print('Loader selects battlefield client:',target)
