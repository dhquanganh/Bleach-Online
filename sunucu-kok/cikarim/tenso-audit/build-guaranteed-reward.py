"""Apply the Primogem reward label to the installed Tensō client."""
from pathlib import Path
import importlib.util,subprocess,struct,zlib,shutil,json
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('helpers',BASE.parent/'flash-refinery/build.py')
h=importlib.util.module_from_spec(spec);spec.loader.exec_module(h)
original=h.CLIENT.read_bytes();source=BASE/'guaranteed-source.swf';source.write_bytes(h.swap(original))
jar=BASE.parents[2]/'.tools/ffdec/ffdec-cli.jar'
def ff(*args):
 r=subprocess.run(['java','-Xmx2g','-jar',str(jar),*map(str,args)],capture_output=True,text=True,errors='replace')
 if r.returncode:raise RuntimeError(r.stdout+r.stderr)
rel=Path('Processors/Game/Lobby/ExpDuplicate/TProcessorExpDupItemCom.as')
ff('-selectclass','Processors.Game.Lobby.ExpDuplicate.TProcessorExpDupItemCom','-export','script',BASE/'guaranteed-original',source)
text=(BASE/'guaranteed-original/scripts'/rel).read_text(encoding='utf-8')
anchor='this.FMainUI.TF_RandomAward.text = "Nguy\u00ean th\u1ea1ch: 0-" + this.FData.Config.RewardTxt;'
assert anchor in text
text=text.replace(anchor,'this.FMainUI.TF_RandomAward.text = "Nguy\u00ean th\u1ea1ch: " + Math.max(1,this.FData.Config.RewardTxt - 10) + "-" + this.FData.Config.RewardTxt;')
patched=BASE/'guaranteed-patched'/rel;patched.parent.mkdir(parents=True,exist_ok=True);patched.write_text(text,encoding='utf-8')
output=BASE/'guaranteed-compiled.swf'
ff('-onerror','abort','-importScript',source,output,BASE/'guaranteed-patched')
new=output.read_bytes()
assert [t for t in h.tags(source.read_bytes()) if t[0]!=82]==[t for t in h.tags(new) if t[0]!=82]
ff('-selectclass','Processors.Game.Lobby.ExpDuplicate.TProcessorExpDupItemCom','-export','script',BASE/'guaranteed-verify',output)
label=(BASE/'guaranteed-verify/scripts/Processors/Game/Lobby/ExpDuplicate/TProcessorExpDupItemCom.as').read_text(encoding='utf-8')
assert 'Math.max(1,this.FData.Config.RewardTxt - 10)' in label and 'Possible Coupons:' not in label
assert h.CLIENT.read_bytes()==original
manifest=h.CLIENT.parent/'version.swf';raw=zlib.decompress(manifest.read_bytes());pos=2;parts=[raw[:2]];version=b'2026102316';found=0
for _ in range(struct.unpack_from('<H',raw)[0]):
 n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n
 n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
 if k==b'TApplication.swf':v=version;found+=1
 parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
assert found==1 and pos==len(raw)
target=h.CLIENT.parent.parent/version.decode()/'TApplication.swf';assert not target.exists()
backup=BASE/'guaranteed-backups';backup.mkdir(exist_ok=True)
for p in [h.CLIENT,manifest]:shutil.copy2(p,backup/p.name)
target.parent.mkdir(exist_ok=True);protected=h.swap(new);target.write_bytes(protected);h.CLIENT.write_bytes(protected);manifest.write_bytes(zlib.compress(b''.join(parts)))
# Publish the bootstrap used by launcher, after the app and manifest are ready.
shutil.copy2(h.CLIENT.parent/'index.swf',target.parent/'index.swf')
shutil.copy2(manifest,target.parent/'version.swf')
pointer=h.CLIENT.parent.parent/'client-release.json'
shutil.copy2(pointer,backup/'client-release.json')
for name in ['index.swf','version.swf','TApplication.swf']:assert (target.parent/name).is_file()
newrows=zlib.decompress((target.parent/'version.swf').read_bytes())
assert version in newrows
pending=pointer.with_suffix('.tmp');pending.write_text(json.dumps({'version':version.decode()})+'\n',encoding='utf-8');pending.replace(pointer)
print('PASS: Vietnamese Primogem card label verified; launcher now loads',version.decode())
