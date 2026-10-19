"""Reuse the Skip button's native skin; preserve all installed playback logic."""
from pathlib import Path
import argparse,importlib.util,re,shutil,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('speed',BASE/'build.py');b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
VERSION=b'2026101963'
def method(s,name):
    start=re.search(r'      private (?:static )?function '+name+r'\(',s).start()
    return s[start:b.h.method_end(s,start)]
def main():
    p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);p.add_argument('--install',action='store_true');args=p.parse_args()
    canonical=b.h.h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes()
    source=BASE/'style-source.swf';assert source.read_bytes()==b.h.h.swap(old),'Live client changed'
    def ff(*a):subprocess.run(['java','-Xmx2g','-jar',args.ffdec,*map(str,a)],check=True)
    ff('-selectclass','Processors.Game.Battle.TBattleHandle','-export','script',BASE/'style-original',source)
    before=(BASE/'style-original/scripts'/b.HANDLE).read_text();s=before
    assert 'FPlaybackNativeControl' not in s,'Native style already installed'
    s=s.replace('      private var FPlaybackLabel:TextField;','      private var FPlaybackLabel:TextField;\n      private var FPlaybackNativeControl:TUIButton;')
    assert 'FPlaybackNativeControl:TUIButton' in s
    runtime=(BASE/'runtime.as.txt').read_text()
    for name in ['CreatePlaybackButton','UpdatePlaybackButton']:
        s=s.replace(method(s,name),method(runtime,name),1)
    pos=s.index('      private function CreatePlaybackButton(')
    s=s[:pos]+'\n\n'.join(method(runtime,name) for name in ['FindPlaybackCaption','RefreshPlaybackCaption','PlaybackNativeClick'])+'\n\n'+s[pos:]
    dest=BASE/'style-patched'/b.HANDLE;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(s)
    output=BASE/'style-compiled.swf';ff('-onerror','abort','-importScript',source,output,BASE/'style-patched')
    rebuilt=output.read_bytes()
    assert [t for t in b.h.h.tags(source.read_bytes()) if t[0]!=82]==[t for t in b.h.h.tags(rebuilt) if t[0]!=82]
    ff('-selectclass','Processors.Game.Battle.TBattleHandle','-export','script',BASE/'style-verify',output)
    after=(BASE/'style-verify/scripts'/b.HANDLE).read_text()
    for name in ['StartPlaybackSpeed','StopPlaybackSpeed','TogglePlaybackSpeed','PulsePlaybackTimers','PlaybackRemoved']:
        assert method(before,name)==method(after,name),('Playback logic changed',name)
    if args.install:
        assert canonical.read_bytes()==old
        version=canonical.parent/'version.swf';raw=zlib.decompress(version.read_bytes());pos=2;parts=[raw[:2]];found=0
        for _ in range(struct.unpack_from('<H',raw)[0]):
            n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n
            n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
            if k==b'TApplication.swf':v=VERSION;found+=1
            parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
        assert found==1 and pos==len(raw)
        for original in [canonical,version]:
            backup=BASE/'backups'/('style-'+original.name)
            if not backup.exists():shutil.copy2(original,backup)
        protected=b.h.h.swap(rebuilt);dest=b.h.h.PUBLIC/VERSION.decode()/'TApplication.swf'
        dest.parent.mkdir(exist_ok=True);dest.write_bytes(protected);canonical.write_bytes(protected)
        version.write_bytes(zlib.compress(b''.join(parts)))
    print('PASS native Skip battle skin',VERSION.decode(),'installed',args.install)
if __name__=='__main__':main()
