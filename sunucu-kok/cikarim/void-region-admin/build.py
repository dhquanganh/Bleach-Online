from pathlib import Path
import sys,subprocess,shutil,tempfile
BASE=Path(__file__).resolve().parent
sys.path.insert(0,str(BASE.parent/'flash-hueco'))
from build import swap,tags,CLIENT
jar='C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar'
live=CLIENT.read_bytes();raw=swap(live);assert raw==(BASE/'source.swf').read_bytes(),'Export the latest client before building'
out=BASE/'compiled.swf'
patch_tmp=tempfile.TemporaryDirectory(prefix='void-reward-patch-')
patch_root=Path(patch_tmp.name)
relative=Path('Processors/Game/Lobby/VoidSoulWorld/TProcessorVoidSoulWorldMainWin.as')
(patch_root/relative).parent.mkdir(parents=True,exist_ok=True)
shutil.copy2(BASE/'patched'/relative,patch_root/relative)
relative_battle=Path('Processors/Game/Battle/TBattleHandle.as')
(patch_root/relative_battle).parent.mkdir(parents=True,exist_ok=True)
shutil.copy2(BASE/'patched/scripts'/relative_battle,patch_root/relative_battle)
subprocess.run(['java','-Xmx2g','-jar',jar,'-onerror','abort','-importScript',str(BASE/'source.swf'),str(out),str(patch_root)],check=True)
patch_tmp.cleanup()
rebuilt=out.read_bytes();assert [t for t in tags(raw) if t[0]!=82]==[t for t in tags(rebuilt) if t[0]!=82]
subprocess.run(['java','-Xmx2g','-jar',jar,'-selectclass','Processors.Game.Lobby.VoidSoulWorld.TProcessorVoidSoulWorldMainWin,Processors.Game.Battle.TBattleHandle','-export','script',str(BASE/'verify'),str(out)],check=True)
v=BASE/'verify/scripts/Processors/Game/Lobby/VoidSoulWorld'
assert 'FightEnterRet(param1.Data)' in (v/'TProcessorVoidSoulWorld.as').read_text()
assert 'FServerBoss' in (v/'TProcessorVoidSoulWorldMainWin.as').read_text()
window=(v/'TProcessorVoidSoulWorldMainWin.as').read_text()
assert 'OnBattlePointerClick' in window
assert 'AdjustVoidRewards' in window and 'item.IDTemplate = 14900001' in window
handle=(BASE/'verify/scripts/Processors/Game/Battle/TBattleHandle.as').read_text()
assert 'case ENTER_TYPE_VOIDSOULWORLD:' in handle
void_case=handle.split('case ENTER_TYPE_VOIDSOULWORLD:',2)[2].split('break;',1)[0]
assert 'this.Skip = true;' in void_case and 'FVipData.ArenaSkip' not in void_case
assert 'UpdateBoss' in (v/'TProcessorMonsterHead.as').read_text()
assert 'RequestFight' in (v/'TFrontController.as').read_text()
assert CLIENT.read_bytes()==live
(BASE/'TApplication.before.swf').write_bytes(live);CLIENT.write_bytes(swap(rebuilt))
print('PASS current-client Void reward UI compiled; native assets and all other classes preserved')
