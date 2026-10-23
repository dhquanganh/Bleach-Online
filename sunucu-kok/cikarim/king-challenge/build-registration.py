"""Apply the Tens? reward item presentation to the installed Tensō client."""
from pathlib import Path
import importlib.util,subprocess,struct,zlib,shutil
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('helpers',BASE.parent/'flash-refinery/build.py')
h=importlib.util.module_from_spec(spec);spec.loader.exec_module(h)
original=h.CLIENT.read_bytes();source=BASE/'registration-source.swf';source.write_bytes(h.swap(original))
jar=BASE.parents[2]/'.tools/ffdec/ffdec-cli.jar'
def ff(*args):
 r=subprocess.run(['java','-Xmx2g','-jar',str(jar),*map(str,args)],capture_output=True,text=True,errors='replace')
 if r.returncode:raise RuntimeError(r.stdout+r.stderr)
output=BASE/'registration-compiled.swf'
ff('-onerror','abort','-importScript',source,output,BASE/'registration-patched')
new=output.read_bytes()
assert [t for t in h.tags(source.read_bytes()) if t[0]!=82]==[t for t in h.tags(new) if t[0]!=82]
classes=','.join(str(p.relative_to(BASE/'registration-patched').with_suffix('')).replace('\\','.') for p in (BASE/'registration-patched').rglob('*.as'))
ff('-selectclass',classes,'-export','script',BASE/'registration-verify',output)
window=(BASE/'registration-verify/scripts/Processors/Game/Lobby/KingChallenge/TProcessorWindowKingChallenge.as').read_text(encoding='utf-8')
assert 'this.FMC_ButtonBar.gotoAndStop(this.FMC_ButtonBar.totalFrames)' in window
assert 'FRegistrationInfo' in window and '/8 |' in window
assert 'this.FBtn_UpLoad.Caption' in window
assert h.CLIENT.read_bytes()==original
manifest=h.CLIENT.parent/'version.swf';raw=zlib.decompress(manifest.read_bytes());pos=2;parts=[raw[:2]];version=b'2026102320';found=0
for _ in range(struct.unpack_from('<H',raw)[0]):
 n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n
 n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
 if k==b'TApplication.swf':v=version;found+=1
 parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
assert found==1 and pos==len(raw)
target=h.CLIENT.parent.parent/version.decode()/'TApplication.swf';assert not target.exists()
backup=BASE/'registration-backups';backup.mkdir(exist_ok=True)
for p in [h.CLIENT,manifest]:shutil.copy2(p,backup/p.name)
target.parent.mkdir(exist_ok=True);protected=h.swap(new);target.write_bytes(protected);h.CLIENT.write_bytes(protected);manifest.write_bytes(zlib.compress(b''.join(parts)))
shutil.copy2(h.CLIENT.parent/'index.swf',target.parent/'index.swf')
shutil.copy2(manifest,target.parent/'version.swf')
import json
pointer=h.CLIENT.parent.parent/'client-release.json';shutil.copy2(pointer,backup/'client-release.json');pending=pointer.with_suffix('.tmp');pending.write_text(json.dumps({'version':version.decode()})+'\n');pending.replace(pointer)
print('PASS: registered-player tournament client compiled, assets unchanged, release',version.decode())
