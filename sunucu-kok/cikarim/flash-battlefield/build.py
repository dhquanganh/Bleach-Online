import sys, shutil, subprocess, hashlib
from pathlib import Path
from datetime import datetime
BASE=Path(__file__).resolve().parent
sys.path.insert(0,str(BASE.parent/'flash-cross-server'))
from build import swap, tags
CLIENT=BASE.parents[1]/'kaynak/login.gogames.me/public/2026090619/TApplication.swf'
JAR=Path('C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar')
names=['Processors/Game/Lobby/DailyActivity/TProcessorDailyActivity.as','Processors/Game/Lobby/TProcessorLobby.as']
all_names=names[:]
names=names[:1]
original=CLIENT.read_bytes(); decoded=swap(original)
baseline=BASE/'.compile-baseline'
if '--resume' in sys.argv:
    assert baseline.exists() and baseline.read_text()==hashlib.sha256(original).hexdigest(),'Resume baseline differs from the installed client'
else:baseline.write_text(hashlib.sha256(original).hexdigest())
source=BASE/'live.swf';source.write_bytes(decoded)
for i,name in enumerate(names):
    folder=BASE/('phase-'+str(i));target=folder/name
    target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(BASE/'patched'/name,target)
    output=BASE/('compiled-'+str(i)+'.swf')
    if '--resume' in sys.argv:
        assert output.exists(),'Missing compiled daily class'
        source=output
        continue
    result=subprocess.run(['java','-Xmx2g','-jar',str(JAR),'-onerror','abort','-importScript',str(source),str(output),str(folder)],capture_output=True,text=True,errors='replace')
    print(result.stdout,flush=True)
    if result.returncode:raise RuntimeError(result.stderr)
    source=output
if '--daily-only' not in sys.argv:
    java=Path('C:/Program Files/Java/jdk-23/bin')
    subprocess.run([str(java/'javac.exe'),'-cp',str(JAR),str(BASE/'PatchRoutes.java')],check=True)
    routed=BASE/'routed.swf'
    subprocess.run([str(java/'java.exe'),'-cp',str(BASE)+';'+str(JAR),'PatchRoutes',str(source),str(routed)],check=True)
    source=routed
rebuilt=source.read_bytes()
assert [t for t in tags(decoded) if t[0]!=82]==[t for t in tags(rebuilt) if t[0]!=82], 'Non-code assets changed'
classes=','.join(n[:-3].replace('/','.') for n in all_names)+',Processors.Game.TProcessorGameRoot,Processors.Game.Lobby.MainScene.Role.TUI'
subprocess.run(['java','-Xmx2g','-jar',str(JAR),'-selectclass',classes,'-export','script',str(BASE/'verify'),str(source)],check=True)
daily=(BASE/'verify/scripts'/names[0]).read_text(encoding='utf-8')
lobby=(BASE/'verify/scripts'/all_names[1]).read_text(encoding='utf-8')
assert 'FieldFightReply' in daily and 'FieldBuy' in daily and ('Chien truong' in daily or 'Chiến trường' in daily)
assert 'FieldBattleReturn' in lobby and 'OnFieldInitBattle' in lobby
if '--daily-only' not in sys.argv:
    assert 'FieldBattleActive' in lobby
    sprite=(BASE/'verify/scripts/Processors/Game/Lobby/MainScene/Role/TUI.as').read_text(encoding='utf-8')
    assert 'this.FTexture.Count' in sprite
root=(BASE/'verify/scripts/Processors/Game/TProcessorGameRoot.as').read_text(encoding='utf-8')
assert '18410752,18410756,this.PacketPerform_ProcessorLobby' in root
protected=swap(rebuilt);(BASE/'TApplication-protected.swf').write_bytes(protected)
if '--install' in sys.argv:
    assert CLIENT.read_bytes()==original,'Client changed while compiling'
    backup=BASE/'backups'/(datetime.now().strftime('%Y%m%d-%H%M%S')+'.swf.bak')
    backup.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(CLIENT,backup)
    CLIENT.write_bytes(protected);print('Installed with backup:',backup)
print('Verified bytecode-only changes:',hashlib.sha256(protected).hexdigest())
