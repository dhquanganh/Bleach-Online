"""Patch the current client without replacing unrelated battle/Obito changes."""
from pathlib import Path
import importlib.util,subprocess,zlib,struct,shutil,sys
BASE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('helper',BASE.parent/'naruto-sage/verify-client.py');h=importlib.util.module_from_spec(spec);spec.loader.exec_module(h)
FF='E:/Vua Hai Tac Vibe/tools/ffdec/ffdec.jar'
def ff(*args):subprocess.run(['java','-Xmx2g','-jar',FF,*map(str,args)],check=True)
canonical=h.PUBLIC/'2026090619/TApplication.swf';old=canonical.read_bytes();source=BASE/'source.swf'
if '--install-compiled' not in sys.argv:
 source.write_bytes(h.swap(old))
 ff('-selectclass','Processors.Game.Lobby.Protagonist.TProcessorProtagonist,Processors.Game.Lobby.Protagonist.TMilitaryView','-export','script',BASE/'original',source)
 for cls in ['TProcessorProtagonist','TMilitaryView']:
  rel=Path('Processors/Game/Lobby/Protagonist')/(cls+'.as');s=(BASE/'original/scripts'/rel).read_text(encoding='utf-8')
  def rep(a,b):
   global s
   assert a in s,a;s=s.replace(a,b)
  if cls=='TProcessorProtagonist':
   rep('this.FMilitaryData.CurrentCredit == SLogicsCore.Character.Prestige;','this.FMilitaryData.CurrentCredit = SLogicsCore.Character.Prestige;')
   rep('this.FMilitaryData.InitComplete = true;','''this.FMilitaryData.InitComplete = true;
          SLogicsCore.Character.MilitaryRank = this.FMilitaryData.MilitaryRank;
          SLogicsCore.Character.Prestige = this.FMilitaryData.CurrentCredit;
          this.CheckIfCanUpgrade();''')
   rep('if(_loc3_ != 0)\n         {\n            return;\n         }','if(_loc3_ != 0)\n         {\n            this.PerformPacket_CS_MilitaryRankInfoReq();\n            return;\n         }')
   rep('this.FMilitaryData.CurrentSpirit = param1.Data.readUnsignedInt();','this.FMilitaryData.CurrentSpirit = param1.Data.readUnsignedInt();\n            this.FMilitaryData.SalaryState = false;')
   # Re-query after salary: prestige upkeep and daily claim state are server-owned.
   rep('this.FlyTextRecevieSalary();','this.FlyTextRecevieSalary();\n            this.PerformPacket_CS_MilitaryRankInfoReq();')
   rep('this.FlyTextUpgradeMilitary();','this.CheckIfCanUpgrade();\n         this.FlyTextUpgradeMilitary();')
  else:
   rep('if(_loc2_ < this.FMilitaryData.InforCount)','if(_loc2_ >= 0 && _loc2_ < this.FMilitaryData.InforCount)')
   rep('this.FMCArray_MilitaryCard[_loc1_]["MC_PreMilitary"].visible = true;','this.FMCArray_MilitaryCard[_loc1_]["MC_PreMilitary"].visible = this.FStartMilitaryIDInMilitaryCards + _loc1_ < this.FMilitaryData.MilitaryRank;')
   rep('this.FSelectMilitaryCardId = this.FMilitaryData.MilitaryRank;','this.FSelectMilitaryCardId = this.FMilitaryData.MilitaryRank;\n            this.UpdatePointMilitaryInfor(this.FSelectMilitaryCardId);')
  out=BASE/'patched'/rel;out.parent.mkdir(parents=True,exist_ok=True);out.write_text(s,encoding='utf-8')
 output=BASE/'compiled.swf';ff('-onerror','abort','-importScript',source,output,BASE/'patched')
 rebuilt=output.read_bytes();assert [t for t in h.tags(h.swap(old)) if t[0]!=82]==[t for t in h.tags(rebuilt) if t[0]!=82]
 ff('-selectclass','Processors.Game.Lobby.Protagonist.TProcessorProtagonist,Processors.Game.Lobby.Protagonist.TMilitaryView','-export','script',BASE/'verify',output)
 v=(BASE/'verify/scripts/Processors/Game/Lobby/Protagonist/TMilitaryView.as').read_text(encoding='utf-8');assert '>= 0' in v
else:
 assert source.read_bytes()==h.swap(old),'Compiled client snapshot is stale'
 rebuilt=(BASE/'compiled.swf').read_bytes()
 assert [t for t in h.tags(h.swap(old)) if t[0]!=82]==[t for t in h.tags(rebuilt) if t[0]!=82]
assert canonical.read_bytes()==old,'Client changed while compiling'
manifest=h.PUBLIC/'2026090619/version.swf';raw=zlib.decompress(manifest.read_bytes());p=2;parts=[raw[:2]];version=b'2026101940'
for _ in range(struct.unpack_from('<H',raw)[0]):
 n=struct.unpack_from('<H',raw,p)[0];p+=2;k=raw[p:p+n];p+=n;n=struct.unpack_from('<H',raw,p)[0];p+=2;value=raw[p:p+n];p+=n
 if k==b'TApplication.swf':value=version
 parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(value)),value])
(BASE/'backups').mkdir(exist_ok=True)
for f in [canonical,manifest]:
 dest=BASE/'backups'/f.name
 if not dest.exists():shutil.copy2(f,dest)
dest=h.PUBLIC/version.decode()/'TApplication.swf';dest.parent.mkdir(exist_ok=True);dest.write_bytes(h.swap(rebuilt));canonical.write_bytes(h.swap(rebuilt));manifest.write_bytes(zlib.compress(b''.join(parts)))
print('PASS native rank UI compiled, verified and installed; unrelated SWF assets preserved.')
