"""Animate Chase state labels while preserving the existing client patches."""
from pathlib import Path
import argparse,hashlib,importlib.util,shutil,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('client_helpers',BASE/'verify-client.py')
helper=importlib.util.module_from_spec(spec);spec.loader.exec_module(helper)
NAME=Path('Processors/Game/Battle/Character/TRole.as')
def main():
    parser=argparse.ArgumentParser();parser.add_argument('--ffdec',required=True);parser.add_argument('--install',action='store_true');opts=parser.parse_args()
    canonical=helper.PUBLIC/'2026090619/TApplication.swf';original=canonical.read_bytes();decoded=helper.swap(original)
    source=BASE/'chase-source.swf';source.write_bytes(decoded)
    def ffdec(*args):subprocess.run(['java','-Xmx2g','-jar',opts.ffdec,*map(str,args)],check=True)
    ffdec('-selectclass','Processors.Game.Battle.Character.TRole','-export','script',BASE/'chase-original',source)
    text=(BASE/'chase-original/scripts'/NAME).read_text(encoding='utf-8')
    start=text.index('      public function AddTextEffectByCMD(param1:TTargetInfo) : void')
    body=text.index('      {',start)+len('      {')
    end=text.index('         _loc2_ = 0;',body)
    patch=(BASE/'chase-label.as.txt').read_text(encoding='utf-8')
    text=text[:body]+'\n         var _loc2_:int;\n'+patch+text[end:]
    target=BASE/'chase-fixed'/NAME;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(text,encoding='utf-8')
    output=BASE/'chase-fixed.swf';ffdec('-onerror','abort','-importScript',source,output,BASE/'chase-fixed')
    rebuilt=output.read_bytes()
    assert [t for t in helper.tags(decoded) if t[0]!=82]==[t for t in helper.tags(rebuilt) if t[0]!=82]
    ffdec('-selectclass','Processors.Game.Battle.Character.TActive,Processors.Game.Battle.Character.TRole,Logics.HeroNew.TWakeHeroAttributes','-export','script',BASE/'chase-verify',output)
    exported=BASE/'chase-verify/scripts'
    role=(exported/NAME).read_text(encoding='utf-8')
    assert all(token in role for token in ['19000200','ENTER_FRAME','REMOVED_FROM_STAGE','Low Float','High Float','Knockdown','Repulse','Immobile','CHASE','11120902'])
    active=(exported/'Processors/Game/Battle/Character/TActive.as').read_text(encoding='utf-8')
    assert '13120902' in active and '13120904' in active
    wake=(exported/'Logics/HeroNew/TWakeHeroAttributes.as').read_text(encoding='utf-8')
    assert all(f'if({v} == null)' in wake for v in ['_loc12_','_loc11_','_loc8_'])
    if opts.install:
        assert canonical.read_bytes()==original
        manifest=helper.PUBLIC/'2026090619/version.swf';raw=zlib.decompress(manifest.read_bytes());pos=2;entries=[]
        for _ in range(struct.unpack_from('<H',raw)[0]):
            n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n
            n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n;entries.append((k,v))
        assert pos==len(raw) and sum(k==b'TApplication.swf' for k,v in entries)==1
        parts=[raw[:2]];version=b'2026101704'
        for k,v in entries:
            if k==b'TApplication.swf':v=version
            parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
        for f in [canonical,manifest]:
            backup=BASE/'backups/chase-fix'/f.relative_to(helper.ROOT);backup.parent.mkdir(parents=True,exist_ok=True)
            if not backup.exists():shutil.copy2(f,backup)
        dest=helper.PUBLIC/version.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True)
        dest.write_bytes(helper.swap(rebuilt));canonical.write_bytes(helper.swap(rebuilt));manifest.write_bytes(zlib.compress(b''.join(parts)))
    print('PASS animated Chase/state labels, prior animation/Partner/clone patches and existing SWF art preserved. Installed:',opts.install,'SHA256:',hashlib.sha256(helper.swap(rebuilt)).hexdigest())
if __name__=='__main__':main()
