"""Guard optional Awakening data for custom partners; preserve existing SWF assets."""
from pathlib import Path
import argparse,importlib.util,shutil,struct,subprocess,zlib,hashlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('verify_client',BASE/'verify-client.py')
helper=importlib.util.module_from_spec(spec);spec.loader.exec_module(helper)
NAME=Path('Logics/HeroNew/TWakeHeroAttributes.as')
CLASS='Logics.HeroNew.TWakeHeroAttributes'
def main():
    parser=argparse.ArgumentParser();parser.add_argument('--ffdec',required=True);parser.add_argument('--install',action='store_true');opts=parser.parse_args()
    canonical=helper.PUBLIC/'2026090619/TApplication.swf'
    live=canonical.read_bytes();decoded=helper.swap(live);source=BASE/'partner-source.swf';source.write_bytes(decoded)
    def ffdec(*args):subprocess.run(['java','-Xmx2g','-jar',opts.ffdec,*map(str,args)],check=True)
    ffdec('-selectclass',CLASS,'-export','script',BASE/'partner-original',source)
    text=(BASE/'partner-original/scripts'/NAME).read_text(encoding='utf-8')
    # Each helper treats absent Awakening progression as zero Awakening bonuses.
    # SetProperties can then finish initializing all parallel vectors atomically.
    for var in ['_loc12_','_loc11_','_loc8_']:
        anchor=f'         {var} = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_WakeUp,param2) as TWakeUp;'
        assert text.count(anchor)==1
        guard=f'\n         if({var} == null)\n         {{\n            return;\n         }}'
        if anchor+guard not in text:text=text.replace(anchor,anchor+guard)
    patched=BASE/'partner-fixed'/NAME;patched.parent.mkdir(parents=True,exist_ok=True);patched.write_text(text,encoding='utf-8')
    output=BASE/'partner-fixed.swf'
    ffdec('-onerror','abort','-importScript',source,output,BASE/'partner-fixed')
    rebuilt=output.read_bytes()
    assert [t for t in helper.tags(decoded) if t[0]!=82]==[t for t in helper.tags(rebuilt) if t[0]!=82]
    ffdec('-selectclass',CLASS,'-export','script',BASE/'partner-verify',output)
    check=(BASE/'partner-verify/scripts'/NAME).read_text(encoding='utf-8')
    for var in ['_loc12_','_loc11_','_loc8_']:assert f'if({var} == null)' in check
    if opts.install:
        assert canonical.read_bytes()==live,'Live client changed during build'
        manifest=helper.PUBLIC/'2026090619/version.swf';raw=zlib.decompress(manifest.read_bytes());p=2;entries=[]
        for _ in range(struct.unpack_from('<H',raw)[0]):
            n=struct.unpack_from('<H',raw,p)[0];p+=2;k=raw[p:p+n];p+=n
            n=struct.unpack_from('<H',raw,p)[0];p+=2;v=raw[p:p+n];p+=n;entries.append((k,v))
        assert p==len(raw) and sum(k==b'TApplication.swf' for k,v in entries)==1
        parts=[raw[:2]];version=b'2026101702'
        for k,v in entries:
            if k==b'TApplication.swf':v=version
            parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
        for f in [canonical,manifest]:
            backup=BASE/'backups/partner-fix'/f.relative_to(helper.ROOT);backup.parent.mkdir(parents=True,exist_ok=True)
            if not backup.exists():shutil.copy2(f,backup)
        target=helper.PUBLIC/version.decode()/'TApplication.swf';target.parent.mkdir(exist_ok=True)
        target.write_bytes(helper.swap(rebuilt));canonical.write_bytes(helper.swap(rebuilt));manifest.write_bytes(zlib.compress(b''.join(parts)))
    print('PASS optional Awakening guards; original SWF art preserved. Installed:',opts.install,'SHA256:',hashlib.sha256(helper.swap(rebuilt)).hexdigest())
if __name__=='__main__':main()
