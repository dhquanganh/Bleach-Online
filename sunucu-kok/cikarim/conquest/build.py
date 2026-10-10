from pathlib import Path
import subprocess,sys,shutil
from datetime import datetime
BASE=Path(__file__).resolve().parent
sys.path.insert(0,str(BASE.parent/'flash-cross-server'))
import build
JAR='C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar'
live=build.CLIENT.read_bytes();original=build.swap(live);source=BASE/'live.swf';source.write_bytes(original)
order=['Logics/Streamization/NightmareTrial/TUnstreamizerNightmareTrial.as','Processors/Game/Lobby/NightmareTrial/Windows/TProcessorNightmareMapAward.as','Processors/Game/Lobby/NightmareTrial/Windows/TViewCampReadyInfo.as','Processors/Game/Lobby/NightmareTrial/TProcessorNightmareTrialMap.as']
for i,name in enumerate(order):
 phase=BASE/('phase-'+datetime.now().strftime('%Y%m%d-%H%M%S-%f'));target=phase/name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(BASE/'patched'/name,target)
 out=BASE/('phase-'+str(i)+'.swf');print('Compiling',name,flush=True)
 subprocess.run(['java','-Xmx2g','-jar',JAR,'-onerror','abort','-importScript',str(source),str(out),str(phase)],check=True)
 source=out
rebuilt=source.read_bytes();assert [t for t in build.tags(original) if t[0]!=82]==[t for t in build.tags(rebuilt) if t[0]!=82]
classes=','.join(n[:-3].replace('/','.') for n in order)
subprocess.run(['java','-Xmx2g','-jar',JAR,'-selectclass',classes,'-export','script',str(BASE/'verify'),str(source)],check=True)
assert 'param1.readUTF()' in (BASE/'verify/scripts'/order[0]).read_text()
assert 'SweepRemaining' in (BASE/'verify/scripts'/order[1]).read_text()
assert 'TBattleHandle.IsInBattle = false' in (BASE/'verify/scripts'/order[3]).read_text()
subprocess.run(['java','-Xmx2g','-jar',JAR,'-selectclass','Processors.Game.Lobby.NightmareTrial.TProcessorNightmareTrialMap','-format','script:pcode','-export','script',str(BASE/'pcode-verify'),str(source)],check=True)
assembly=(BASE/'pcode-verify/scripts/Processors/Game/Lobby/NightmareTrial/TProcessorNightmareTrialMap.pcode').read_text()
assert 'QName(PackageNamespace("Processors.Game.Battle"),"TBattleHandle")' in assembly
assert 'QName(PackageNamespace(""),"TBattleHandle")' not in assembly
backup=BASE/('backup-'+datetime.now().strftime('%Y%m%d-%H%M%S')+'.swf.bak');shutil.copy2(build.CLIENT,backup);assert build.CLIENT.read_bytes()==live
build.CLIENT.write_bytes(build.swap(rebuilt))
# The loader manifest uses a new URL to invalidate Flash's cached application.
alias=build.CLIENT.parent.parent/'2026101001/TApplication.swf'
if alias.parent.exists(): shutil.copy2(build.CLIENT,alias)
print('Installed verified Conquest client. Non-code assets unchanged. Backup:',backup)
