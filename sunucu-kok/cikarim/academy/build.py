from pathlib import Path
import sys,subprocess,shutil
from datetime import datetime
BASE=Path(__file__).resolve().parent
sys.path.insert(0,str(BASE.parent/'flash-cross-server'));import build
jar='C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar';live=build.CLIENT.read_bytes();old=build.swap(live);source=BASE/'live.swf';source.write_bytes(old)
order=['Processors/Game/Lobby/KnifeSoul/TProcessorWindowKnifeSoul.as','Processors/Game/Lobby/KnifeSoul/TProcessorKnifeSoul.as']
for i,name in enumerate(order):
 phase=BASE/('phase-'+datetime.now().strftime('%Y%m%d-%H%M%S-%f'));target=phase/name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(BASE/'patched'/name,target)
 out=BASE/('phase-'+str(i)+'.swf');print('Compiling',name,flush=True);subprocess.run(['java','-Xmx2g','-jar',jar,'-onerror','abort','-importScript',str(source),str(out),str(phase)],check=True);source=out
new=source.read_bytes();assert [t for t in build.tags(old) if t[0]!=82]==[t for t in build.tags(new) if t[0]!=82]
subprocess.run(['java','-Xmx2g','-jar',jar,'-selectclass',','.join(n[:-3].replace('/','.') for n in order),'-export','script',str(BASE/'verify'),str(source)],check=True)
assert 'AcademyPending = true' in (BASE/'verify/scripts'/order[0]).read_text();assert 'AcademyPending = false' in (BASE/'verify/scripts'/order[1]).read_text()
assert build.CLIENT.read_bytes()==live;shutil.copy2(build.CLIENT,BASE/('backup-'+datetime.now().strftime('%Y%m%d-%H%M%S')+'.swf.bak'));build.CLIENT.write_bytes(build.swap(new));alias=build.CLIENT.parent.parent/'2026101001/TApplication.swf'
if alias.parent.exists():shutil.copy2(build.CLIENT,alias)
print('Installed verified Academy client; assets unchanged and both loader paths updated.')
