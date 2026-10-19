"""Preserve the live client; display the settled chest quality, not the live rank."""
from pathlib import Path
import importlib.util,subprocess,zlib,struct,shutil
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('h',BASE.parent/'naruto-sage/verify-client.py');h=importlib.util.module_from_spec(spec);spec.loader.exec_module(h)
def ff(*args):subprocess.run(['java','-Xmx2g','-jar','E:/Vua Hai Tac Vibe/tools/ffdec/ffdec.jar',*map(str,args)],check=True)
canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=h.swap(old);source=BASE/'source.swf';source.write_bytes(decoded)
cls='Processors.Game.Lobby.Arena.TProcessorWindowArena';rel=Path('Processors/Game/Lobby/Arena/TProcessorWindowArena.as')
ff('-selectclass',cls,'-export','script',BASE/'native',source)
s=(BASE/'native/scripts'/rel).read_text(encoding='utf-8')
oldtoken='_loc11_ = uint(this.GetQualityByRanking(this.FArenaData.BoxRanking));'
assert s.count(oldtoken)==2
s=s.replace(oldtoken,oldtoken+'\n            this.FResource.mc_title.btn_getReward.mc_box.gotoAndStop(_loc11_);')
token='this.FResource.mc_title.btn_getReward.mc_box.gotoAndStop(this.FMyBoxQuality);'
start=s.index('else if(this.FArenaData.BoxType == 1)');end=s.index('else if(this.FArenaData.BoxType == 2)',start)
s=s[:start]+s[start:end].replace(token,'')+s[end:]
out=BASE/'patched'/rel;out.parent.mkdir(parents=True,exist_ok=True);out.write_text(s,encoding='utf-8')
compiled=BASE/'compiled.swf';ff('-onerror','abort','-importScript',source,compiled,BASE/'patched');rebuilt=compiled.read_bytes()
assert [t for t in h.tags(decoded) if t[0]!=82]==[t for t in h.tags(rebuilt) if t[0]!=82]
ff('-selectclass',cls,'-export','script',BASE/'verify',compiled)
v=(BASE/'verify/scripts'/rel).read_text(encoding='utf-8');assert v.count('gotoAndStop(_loc11_)')==2
assert canonical.read_bytes()==old,'Client changed during build'
manifest=h.PUBLIC/'2026090619/version.swf';raw=zlib.decompress(manifest.read_bytes());p=2;parts=[raw[:2]];version=b'2026101941'
for _ in range(struct.unpack_from('<H',raw)[0]):
 n=struct.unpack_from('<H',raw,p)[0];p+=2;k=raw[p:p+n];p+=n;n=struct.unpack_from('<H',raw,p)[0];p+=2;value=raw[p:p+n];p+=n
 if k==b'TApplication.swf':value=version
 parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(value)),value])
(BASE/'backups').mkdir(exist_ok=True)
for f in [canonical,manifest]:
 dest=BASE/'backups'/f.name
 if not dest.exists():shutil.copy2(f,dest)
dest=h.PUBLIC/version.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True);dest.write_bytes(h.swap(rebuilt));canonical.write_bytes(h.swap(rebuilt));manifest.write_bytes(zlib.compress(b''.join(parts)))
print('PASS settled chest quality compiled, verified and installed; other assets preserved.')
