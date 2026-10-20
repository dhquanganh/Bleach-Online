"""Publish refreshed model textures without recompiling unchanged Flash code."""
from pathlib import Path
import importlib.util,json,struct,zlib
B=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('client',B/'build-client.py')
client=importlib.util.module_from_spec(spec);spec.loader.exec_module(client)
root=client.h.PUBLIC
canonical=root/'2026090619/TApplication.swf'
data=canonical.read_bytes()
assert data==client.h.swap((B/'compiled.swf').read_bytes()),'Unrecognized installed client'
check=json.loads((B/'validation/idle-native/result.json').read_text())
assert check['completed'] and check['cases']==5 and not check['errors'],check
version=canonical.parent/'version.swf';old=version.read_bytes();raw=zlib.decompress(old)
pos=2;parts=[raw[:2]];found=0
for _ in range(struct.unpack_from('<H',raw)[0]):
    n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n
    n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
    if k==b'TApplication.swf':v=client.VERSION;found+=1
    parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
assert found==1 and pos==len(raw)
backup=B/'backups/version-before-idle-size.swf'
if not backup.exists():backup.parent.mkdir(exist_ok=True);backup.write_bytes(old)
alias=root/client.VERSION.decode()/'TApplication.swf';alias.parent.mkdir(exist_ok=True);alias.write_bytes(data)
assert version.read_bytes()==old and canonical.read_bytes()==data
version.write_bytes(zlib.compress(b''.join(parts)))
print('PASS model asset release',client.VERSION.decode(),'; Flash code unchanged')
