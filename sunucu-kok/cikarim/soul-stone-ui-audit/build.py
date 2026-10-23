from pathlib import Path
import importlib.util,subprocess,sys,shutil
BASE=Path(__file__).resolve().parent
sys.path.insert(0,str(BASE.parent/'flash-hueco'))
from build import swap,tags,CLIENT
JAR='C:/Users/quang/.copilot/session-state/b6dea4ff-70b7-44ac-b9f5-1136aca3d0d5/files/ffdec/app/ffdec.jar'
live=CLIENT.read_bytes();decoded=swap(live)
assert decoded==(BASE/'source.swf').read_bytes(),'Live client changed; export current classes again'
out=BASE/'compiled.swf'
subprocess.run(['java','-Xmx2g','-jar',JAR,'-onerror','abort','-importScript',str(BASE/'source.swf'),str(out),str(BASE/'patched')],check=True)
rebuilt=out.read_bytes()
assert [t for t in tags(decoded) if t[0]!=82]==[t for t in tags(rebuilt) if t[0]!=82]
subprocess.run(['java','-Xmx2g','-jar',JAR,'-selectclass','Processors.Game.Lobby.Jade.*','-export','script',str(BASE/'verify'),str(out)],check=True)
root=BASE/'verify/scripts/Processors/Game/Lobby/Jade'
assert 'ApplyCombineResult' in (root/'TProcessorJade.as').read_text()
assert 'this.FWaiting = false;' in (root/'TJadeCombin.as').read_text()
assert 'param2 == null' in (root/'TJadeMosaic.as').read_text()
assert CLIENT.read_bytes()==live
(BASE/'TApplication.before.swf').write_bytes(live)
CLIENT.write_bytes(swap(rebuilt))
print('PASS compiled four Soul Stone classes; non-code assets preserved; canonical updated, release pointer unchanged')
