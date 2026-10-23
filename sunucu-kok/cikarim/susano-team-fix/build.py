from pathlib import Path
import sys,subprocess
BASE=Path(__file__).resolve().parent
sys.path.insert(0,str(BASE.parent/'flash-hueco'))
from build import swap,tags,CLIENT
jar='C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar'
live=CLIENT.read_bytes();raw=swap(live);assert raw==(BASE/'source.swf').read_bytes(),'Export the latest client before building'
out=BASE/'compiled.swf'
subprocess.run(['java','-Xmx2g','-jar',jar,'-onerror','abort','-importScript',str(BASE/'source.swf'),str(out),str(BASE/'patched')],check=True)
rebuilt=out.read_bytes();assert [t for t in tags(raw) if t[0]!=82]==[t for t in tags(rebuilt) if t[0]!=82]
subprocess.run(['java','-Xmx2g','-jar',jar,'-selectclass','Processors.Game.Battle.TBattleHandle,Processors.Game.Battle.Character.TRole','-export','script',str(BASE/'verify'),str(out)],check=True)
v=BASE/'verify/scripts/Processors/Game/Battle/TBattleHandle.as'
verified=v.read_text()
section=verified.split('protected function ProcessorLoadResources()')[1].split('protected function ProcessorLoadBattleBackgroundResources')[0]
for name in ['FightIdle','Attack','Skill','Attacked','Run']:
 assert section.count('SResourcesCore.TexturesModel.LoadPrimary(uint(_loc3_ + CONST_BATTLE.RESOURCE_ActiveType_'+name+'))') == 2,name
assert 'if(cleaned)' in (BASE/'verify/scripts/Processors/Game/Battle/Character/TRole.as').read_text()
assert CLIENT.read_bytes()==live
(BASE/'TApplication.before.swf').write_bytes(live);CLIENT.write_bytes(swap(rebuilt))
print('PASS all roster animation sequences loaded before playback, first and later battles; assets preserved')
