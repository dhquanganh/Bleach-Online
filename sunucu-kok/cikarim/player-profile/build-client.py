"""Allow switching Inspector targets and discard previous inventory/hero UI state."""
from pathlib import Path
import argparse,importlib.util,re,shutil,struct,subprocess,zlib
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('hash',BASE.parent/'hashirama-final/build-client.py');h=importlib.util.module_from_spec(spec);spec.loader.exec_module(h)
CLASS='Processors.Game.Lobby.Inspector.TProcessorInspector'
FILE=Path(CLASS.replace('.','/')+'.as');VERSION=b'2026101965'
def main():
 p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);p.add_argument('--install',action='store_true');a=p.parse_args()
 canonical=h.h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=h.h.swap(old)
 source=BASE/'source.swf';source.write_bytes(decoded)
 def ff(*v):subprocess.run(['java','-Xmx2g','-jar',a.ffdec,*map(str,v)],check=True)
 ff('-selectclass',CLASS,'-export','script',BASE/'original',source)
 before=(BASE/'original/scripts'/FILE).read_text();s=before
 start=s.index('      public function RequestShowHero(');end=h.method_end(s,start)
 method=s[start:end]
 guard='''         if(this.FProcessorWindowPlayerAssets.Visible)
         {
            return;
         }'''
 if guard not in method:
  assert 'this.FProcessorWindowInventoryInfor.Inventory = null;' in method,'Inspector already repaired'
 method=method.replace(guard,'''         this.FProcessorWindowPlayerAssets.Hide();
         this.FProcessorWindowInventoryInfor.Hide();
         this.FHeros.Clear();''')
 method=method.replace('         this.FProcessorWindowInventoryInfor.Inventory = null;\n','')
 s=s[:start]+method+s[end:]
 # Qualify the original timing namespace explicitly for FFDec's AS3 compiler.
 for name in ['SetTimeZone','SetServerTime','SetServerStartTime','SetServerStartTimeZone']:
  s=s.replace('STimingCore.'+name+'(', 'STimingCore.TimingSpace::'+name+'(')
 dest=BASE/'patched'/FILE;dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(s)
 output=BASE/'compiled.swf';ff('-onerror','abort','-importScript',source,output,BASE/'patched');rebuilt=output.read_bytes()
 assert [t for t in h.h.tags(decoded) if t[0]!=82]==[t for t in h.h.tags(rebuilt) if t[0]!=82]
 ff('-selectclass',CLASS+',Processors.Game.Battle.TBattleHandle','-export','script',BASE/'verify',output)
 verified=(BASE/'verify/scripts'/FILE).read_text();handle=(BASE/'verify/scripts/Processors/Game/Battle/TBattleHandle.as').read_text()
 assert 'this.FProcessorWindowInventoryInfor.Inventory = null' not in verified
 assert 'FPlaybackNativeControl' in handle and 'PlaybackTimeout' in handle,'Preserve battle speed/native skin'
 if a.install:
  assert canonical.read_bytes()==old,'Live client changed during compile'
  file=canonical.parent/'version.swf';raw=zlib.decompress(file.read_bytes());pos=2;parts=[raw[:2]];found=0
  for _ in range(struct.unpack_from('<H',raw)[0]):
   n=struct.unpack_from('<H',raw,pos)[0];pos+=2;k=raw[pos:pos+n];pos+=n
   n=struct.unpack_from('<H',raw,pos)[0];pos+=2;v=raw[pos:pos+n];pos+=n
   if k==b'TApplication.swf':v=VERSION;found+=1
   parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
  assert found==1 and pos==len(raw)
  for original in [canonical,file]:
   backup=BASE/'backups'/original.name;backup.parent.mkdir(exist_ok=True)
   if not backup.exists():shutil.copy2(original,backup)
  protected=h.h.swap(rebuilt);dest=h.h.PUBLIC/VERSION.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True)
  dest.write_bytes(protected);canonical.write_bytes(protected);file.write_bytes(zlib.compress(b''.join(parts)))
 print('PASS target-switching Inspector client',VERSION.decode(),'installed',a.install)
if __name__=='__main__':main()
