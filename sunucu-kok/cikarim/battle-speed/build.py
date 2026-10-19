"""Add battle playback controls to the live client without replacing character patches."""
from pathlib import Path
import argparse,importlib.util,re,shutil,struct,subprocess,zlib

BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('hash_builder',BASE.parent/'hashirama-final/build-client.py')
h=importlib.util.module_from_spec(spec);spec.loader.exec_module(h)
VERSION=b'2026101962'
HANDLE=Path('Processors/Game/Battle/TBattleHandle.as')

def rep(s,a,b):
    assert s.count(a)==1,(a,s.count(a))
    return s.replace(a,b,1)

def entry(s,signature,body):
    start=s.index(signature);pos=s.index('{',start)+1
    return s[:pos]+'\n'+body+s[pos:]

def main():
    p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);p.add_argument('--install',action='store_true');args=p.parse_args()
    canonical=h.h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes()
    assert h.h.swap(old)==(BASE/'source.swf').read_bytes(),'Live client changed since export'
    original=BASE/'original/scripts';patched=BASE/'patched'
    role=Path('Processors/Game/Battle/Character/TRole.as')
    targets=[HANDLE,Path('Processors/Game/Battle/TBattleStage.as'),Path('Processors/Game/Battle/TChain.as'),
             Path('Processors/Game/Battle/Components/TBigSkill.as'),Path('Processors/Game/Battle/GoneWord/TGoneWord.as'),
             Path('Processors/Game/Battle/Character/TActive.as'),Path('Processors/Game/Battle/Character/TBaseRole.as'),
             role,Path('Processors/Game/Battle/Effect/TEffectControl.as')]
    for path in targets:
        s=(original/path).read_text()
        if path==HANDLE:
            assert 'FPlaybackRate' not in s,'Playback already installed'
            s=s.replace('   import flash.display.*;','   import flash.display.*;\n   import flash.text.*;')
            pos=s.index('      protected static var FAutoCloseBattle:')
            s=s[:pos]+(BASE/'runtime.as.txt').read_text()+'\n'+s[pos:]
            s=rep(s,'            this.FIsCanSkip = false;','            this.FIsCanSkip = false;\n            CreatePlaybackButton();')
            s=entry(s,'protected function ProcessorOnCloseLoad(', '         StartPlaybackSpeed();\n')
            s=entry(s,'override protected function LogicsPerform()', '         PulsePlaybackTimers();\n         UpdatePlaybackButton();\n')
            s=entry(s,'override public function ProcessorsResize()', '         UpdatePlaybackButton();\n')
            # Reposition after Skip itself is resized too (next logic frame also updates it).
            for signature in ['protected function ProcessorOnBattleEnd(', 'public function Reset()', 'protected function ButtonSkipOnClick(']:
                s=entry(s,signature,'         StopPlaybackSpeed();\n')
            s=entry(s,'override public function set Visible(', '         if(!param1)StopPlaybackSpeed();\n')
        else:
            s=s.replace('   public class ', '   import Processors.Game.Battle.TBattleHandle;\n\n   public class ',1)
            # Native frame advancement remains untouched: higher FPS visits every damage marker.
            s=re.sub(r'(?<![.\w])setTimeout\(', 'TBattleHandle.PlaybackTimeout(',s)
            s=re.sub(r'(?<![.\w])clearTimeout\(', 'TBattleHandle.ClearPlaybackTimeout(',s)
            s=re.sub(r'TweenUtil\.to\(([^,\n]+),([^,\n]+),',r'TweenUtil.to(\1,(\2)/TBattleHandle.PlaybackRate,',s)
            if path==role:
                # Status notices retain their requested 2-4 seconds of reading time.
                saved={}
                for match in re.finditer(r'      private function (\w*StatusText)\(',s):
                    start=match.start();end=h.method_end(s,start);saved[match.group(1)]=s[start:end]
                s=s.replace('getTimer()','TBattleHandle.PlaybackTime')
                for name,body in saved.items():
                    start=re.search(r'      private function '+name+r'\(',s).start();end=h.method_end(s,start)
                    s=s[:start]+body+s[end:]
        dest=patched/path;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(s)
    output=BASE/'compiled.swf'
    def ff(*a):subprocess.run(['java','-Xmx2g','-jar',args.ffdec,*map(str,a)],check=True)
    ff('-onerror','abort','-importScript',BASE/'source.swf',output,patched)
    rebuilt=output.read_bytes();decoded=h.h.swap(old)
    assert [t for t in h.h.tags(decoded) if t[0]!=82]==[t for t in h.h.tags(rebuilt) if t[0]!=82]
    classes=','.join(str(x.with_suffix('')).replace('\\','.').replace('/','.') for x in targets)
    ff('-selectclass',classes,'-export','script',BASE/'verify',output)
    if args.install:
        assert canonical.read_bytes()==old,'Live client changed during compilation'
        file=canonical.parent/'version.swf';raw=zlib.decompress(file.read_bytes());pos=2;parts=[raw[:2]];found=0
        for _ in range(struct.unpack_from('<H',raw)[0]):
            n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n
            n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
            if k==b'TApplication.swf':v=VERSION;found+=1
            parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
        assert found==1 and pos==len(raw)
        for source in [canonical,file]:
            backup=BASE/'backups'/source.name;backup.parent.mkdir(exist_ok=True)
            if not backup.exists():shutil.copy2(source,backup)
        protected=h.h.swap(rebuilt);dest=h.h.PUBLIC/VERSION.decode()/'TApplication.swf'
        dest.parent.mkdir(exist_ok=True);dest.write_bytes(protected);canonical.write_bytes(protected)
        file.write_bytes(zlib.compress(b''.join(parts)))
    print('PASS battle x1/x2 client',VERSION.decode(),'installed',args.install)

if __name__=='__main__':main()
