"""Install integer damage partitioning in the current client, retaining all VFX/UI."""
from pathlib import Path
import argparse,importlib.util,struct,subprocess,zlib,shutil
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('h',BASE/'naruto-sage/verify-client.py');h=importlib.util.module_from_spec(spec);spec.loader.exec_module(h)
CLASS='Processors.Game.Battle.Effect.TEffectControl'
REL=Path(CLASS.replace('.','/')+'.as');VERSION=b'2026101971'

def main():
 p=argparse.ArgumentParser();p.add_argument('--ffdec',required=True);a=p.parse_args()
 work=BASE/'hashirama-final/multihit-build';work.mkdir(exist_ok=True)
 canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();decoded=h.swap(old)
 source=work/'source.swf';source.write_bytes(decoded)
 def ff(*args):subprocess.run(['java','-Xmx2g','-jar',a.ffdec,*map(str,args)],check=True)
 ff('-selectclass',CLASS,'-export','script',work/'original',source)
 before=(work/'original/scripts'/REL).read_text()
 formula='_loc13_[_loc2_].ResultInfo.HurtHp * _loc9_.anmyhp[_loc27_] / 100'
 replacement='ConsecutiveHitDamage(_loc13_[_loc2_].ResultInfo.HurtHp,_loc9_,_loc27_)'
 if 'public static function ConsecutiveHitDamage' in before:
  print('PASS multi-hit client already installed');return
 assert before.count(formula)==2
 method='''
      // Reports contain the total damage for one cast. Partition the integer
      // total so HP and floating numbers agree even for totals below five.
      public static function ConsecutiveHitDamage(total:Number,config:Object,frame:int) : Number
      {
         if(config.hitCount == null || config.hitIndex == null)
            return total * config.anmyhp[frame] / 100;
         var count:int=int(config.hitCount);
         var index:int=int(config.hitIndex);
         if((count != 4 && count != 5) || index < 0 || index >= count)
            return total * config.anmyhp[frame] / 100;
         return Math.floor(total*(index+1)/count)-Math.floor(total*index/count);
      }
'''
 patched=before.replace(formula,replacement)
 pos=patched.rfind('   }');patched=patched[:pos]+method+patched[pos:]
 target=work/'patched'/REL;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(patched)
 output=work/'compiled.swf';ff('-onerror','abort','-importScript',source,output,work/'patched')
 rebuilt=output.read_bytes()
 assert [t for t in h.tags(decoded) if t[0]!=82]==[t for t in h.tags(rebuilt) if t[0]!=82]
 # Verify the emitted ActionScript, including the numeric partition helper.
 ff('-selectclass',CLASS,'-export','script',work/'verify',output)
 verified=(work/'verify/scripts'/REL).read_text()
 assert verified.count('= ConsecutiveHitDamage(')==2 and 'Math.floor(total * (index + 1) / count)' in verified
 version=canonical.parent/'version.swf';b=zlib.decompress(version.read_bytes());pos=2;parts=[b[:2]];found=0
 for _ in range(struct.unpack_from('<H',b)[0]):
  n=struct.unpack_from('<H',b,pos)[0];pos+=2;k=b[pos:pos+n];pos+=n
  n=struct.unpack_from('<H',b,pos)[0];pos+=2;v=b[pos:pos+n];pos+=n
  if k==b'TApplication.swf':v=VERSION;found+=1
  parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
 assert found==1 and pos==len(b) and canonical.read_bytes()==old
 backup=work/'backups';backup.mkdir(exist_ok=True)
 for original in [canonical,version]:
  if not (backup/original.name).exists():shutil.copy2(original,backup/original.name)
 protected=h.swap(rebuilt);dest=h.PUBLIC/VERSION.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True)
 dest.write_bytes(protected);canonical.write_bytes(protected);version.write_bytes(zlib.compress(b''.join(parts)))
 print('PASS client',VERSION.decode(),': exact integer multi-hit HP/text; native UI and textures unchanged')

if __name__=='__main__':main()
