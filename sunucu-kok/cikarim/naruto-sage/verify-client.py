"""Verify compiled TRole and install it under a fresh manifest URL."""
from pathlib import Path
import argparse, hashlib, importlib.util, shutil, struct, subprocess, zlib
BASE=Path(__file__).resolve().parent
ROOT=BASE.parents[1]
PUBLIC=ROOT/'kaynak/login.gogames.me/public'
spec=importlib.util.spec_from_file_location('swf_helpers',BASE.parent/'flash-cross-server/build.py')
helpers=importlib.util.module_from_spec(spec);spec.loader.exec_module(helpers)
swap,tags=helpers.swap,helpers.tags
def main():
    args=argparse.ArgumentParser();args.add_argument('--ffdec',required=True);args.add_argument('--install',action='store_true');opts=args.parse_args()
    source=(BASE/'client-decoded.swf').read_bytes();rebuilt=(BASE/'client-compiled.swf').read_bytes()
    assert [t for t in tags(source) if t[0]!=82]==[t for t in tags(rebuilt) if t[0]!=82]
    subprocess.run(['java','-Xmx2g','-jar',opts.ffdec,'-selectclass','Processors.Game.Battle.Character.TRole','-export','script',str(BASE/'verify'),str(BASE/'client-compiled.swf')],check=True)
    text=(BASE/'verify/scripts/Processors/Game/Battle/Character/TRole.as').read_text(encoding='utf-8')
    assert '11120902' in text and 'removeTween(this,false)' in text and '19000100' in text and 'COMBO' in text
    assert 'PlayFightIdle()' in text and 'FIsDie = false' in text
    if opts.install:
        canonical=PUBLIC/'2026090619/TApplication.swf'
        assert canonical.read_bytes()==swap(source),'Live client changed during compilation'
        for f in [canonical,PUBLIC/'2026090619/version.swf']:
            backup=BASE/'backups'/f.relative_to(ROOT);backup.parent.mkdir(parents=True,exist_ok=True)
            if not backup.exists():shutil.copy2(f,backup)
        manifest=PUBLIC/'2026090619/version.swf';old=zlib.decompress(manifest.read_bytes());p=2;entries=[]
        for _ in range(struct.unpack_from('<H',old)[0]):
            n=struct.unpack_from('<H',old,p)[0];p+=2;key=old[p:p+n];p+=n
            n=struct.unpack_from('<H',old,p)[0];p+=2;value=old[p:p+n];p+=n;entries.append((key,value))
        assert p==len(old)
        assert sum(k==b'TApplication.swf' for k,v in entries)==1
        version=b'2026101701';parts=[old[:2]]
        for key,value in entries:
            if key==b'TApplication.swf':value=version
            parts.extend([struct.pack('<H',len(key)),key,struct.pack('<H',len(value)),value])
        target=PUBLIC/version.decode()/'TApplication.swf';target.parent.mkdir(exist_ok=True)
        target.write_bytes(swap(rebuilt));canonical.write_bytes(swap(rebuilt));manifest.write_bytes(zlib.compress(b''.join(parts)))
    print('PASS native client: existing SWF assets preserved, clone revival and combo labels compiled. Installed:',opts.install,'SHA256:',hashlib.sha256(swap(rebuilt)).hexdigest())
if __name__=='__main__':main()
