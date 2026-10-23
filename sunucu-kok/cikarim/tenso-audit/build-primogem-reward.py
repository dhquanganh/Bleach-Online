"""Apply the Primogem reward label to the installed Tensō client."""
from pathlib import Path
import importlib.util,subprocess,struct,zlib,shutil
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('helpers',BASE.parent/'flash-refinery/build.py')
h=importlib.util.module_from_spec(spec);spec.loader.exec_module(h)
original=h.CLIENT.read_bytes();source=BASE/'reward-source.swf';source.write_bytes(h.swap(original))
jar=BASE.parents[2]/'.tools/ffdec/ffdec-cli.jar'
def ff(*args):
 r=subprocess.run(['java','-Xmx2g','-jar',str(jar),*map(str,args)],capture_output=True,text=True,errors='replace')
 if r.returncode:raise RuntimeError(r.stdout+r.stderr)
output=BASE/'reward-compiled.swf'
ff('-onerror','abort','-importScript',source,output,BASE/'reward-patched')
new=output.read_bytes()
assert [t for t in h.tags(source.read_bytes()) if t[0]!=82]==[t for t in h.tags(new) if t[0]!=82]
ff('-selectclass','Processors.Game.Lobby.ExpDuplicate.TProcessorExpDupItemCom','-export','script',BASE/'reward-verify',output)
label=(BASE/'reward-verify/scripts/Processors/Game/Lobby/ExpDuplicate/TProcessorExpDupItemCom.as').read_text(encoding='utf-8')
assert 'Possible Primogems: 0-' in label and 'Possible Coupons:' not in label
assert h.CLIENT.read_bytes()==original
manifest=h.CLIENT.parent/'version.swf';raw=zlib.decompress(manifest.read_bytes());pos=2;parts=[raw[:2]];version=b'2026102312';found=0
for _ in range(struct.unpack_from('<H',raw)[0]):
 n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n
 n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
 if k==b'TApplication.swf':v=version;found+=1
 parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
assert found==1 and pos==len(raw)
target=h.CLIENT.parent.parent/version.decode()/'TApplication.swf';assert not target.exists()
backup=BASE/'reward-backups';backup.mkdir(exist_ok=True)
for p in [h.CLIENT,manifest]:shutil.copy2(p,backup/p.name)
target.parent.mkdir(exist_ok=True);protected=h.swap(new);target.write_bytes(protected);h.CLIENT.write_bytes(protected);manifest.write_bytes(zlib.compress(b''.join(parts)))
print('PASS: Primogem client label verified, non-code assets unchanged, installed',version.decode())
