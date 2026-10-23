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
subprocess.run(['java','-Xmx2g','-jar',jar,'-selectclass','Processors.Game.Lobby.VoidSoulWorld.TProcessorVoidSoulWorld,Processors.Game.Lobby.VoidSoulWorld.TProcessorVoidSoulWorldMainWin','-export','script',str(BASE/'verify'),str(out)],check=True)
v=BASE/'verify/scripts/Processors/Game/Lobby/VoidSoulWorld'
assert 'high != SLogicsCore.Character.Identifier0 || low != SLogicsCore.Character.Identifier1' in (v/'TProcessorVoidSoulWorld.as').read_text()
assert 'GetPlayerByOnlyID(SLogicsCore.Character.Identifier0,SLogicsCore.Character.Identifier1)' in (v/'TProcessorVoidSoulWorldMainWin.as').read_text()
assert CLIENT.read_bytes()==live
(BASE/'TApplication.before.swf').write_bytes(live);CLIENT.write_bytes(swap(rebuilt))
print('PASS Void admission identity matches native Character.Coerce; assets preserved')
