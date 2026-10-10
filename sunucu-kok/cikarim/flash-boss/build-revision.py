"""Compile event methods in isolation, preserving all unrelated lobby bytecode."""
from pathlib import Path
from datetime import datetime
import subprocess,sys,shutil,re
BASE=Path(__file__).resolve().parent
sys.path.insert(0,str(BASE.parent/'flash-cross-server'))
from build import swap,tags,CLIENT
JAR='C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar'
JAVA=Path('C:/Program Files/Java/jdk-23/bin')
work=BASE/'revision-v2';work.mkdir(exist_ok=True)
def ffdec(*args):
 p=subprocess.run(['java','-Xmx2g','-jar',JAR,*map(str,args)],capture_output=True,text=True,errors='replace')
 if p.returncode:raise RuntimeError(p.stdout+p.stderr)
 print(p.stdout[-500:],flush=True)
live=CLIENT.read_bytes()
baseline=Path(sys.argv[sys.argv.index('--baseline')+1]).read_bytes() if '--baseline' in sys.argv else live
decoded=swap(baseline);source=work/'live.swf'
if '--resume' in sys.argv:
 assert source.exists() and source.read_bytes()==decoded,'Resume source differs from the installed client'
else:source.write_bytes(decoded)
ffdec('-selectclass','Processors.Game.TProcessorGameRoot','-export','script',work/'original',source)
root=(work/'original/scripts/Processors/Game/TProcessorGameRoot.as').read_text(encoding='utf-8')
needle='      override protected function PacketRegisterRoutines() : void\n      {'
assert needle in root
if 'RegisterRange(18382336,18382337,this.PacketPerform_ProcessorLobby)' not in root:
 root=root.replace(needle,needle+'\n         FPacketRoutines.RegisterRange(0x01187E00,0x01187E01,this.PacketPerform_ProcessorLobby);',1)
root_path=work/'root/Processors/Game/TProcessorGameRoot.as';root_path.parent.mkdir(parents=True,exist_ok=True);root_path.write_text(root,encoding='utf-8')
root_swf=work/'root.swf'
if '--resume' not in sys.argv:
 print('Compiling main packet route...',flush=True);ffdec('-onerror','abort','-importScript',source,root_swf,work/'root')
ui=(BASE/'ui-methods.as.txt').read_text(encoding='utf-8')
a=ui.index('      protected function IllusionConstruct()');b=ui.index('      protected function IllusionOpen(',a)
ui=ui[:a]+(BASE/'layout-v2.as.txt').read_text(encoding='utf-8')+'\n\n'+ui[b:]
(BASE/'ui-methods.as.txt').write_text(ui,encoding='utf-8')
imports='''package Processors.Game.Lobby {
import flash.display.Sprite;
import flash.display.Loader;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.geom.Point;
import flash.filters.DropShadowFilter;
import flash.net.URLRequest;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.IOErrorEvent;
import flash.utils.getTimer;
import Foundation.UI.TUIComponent;
import Foundation.Network.TPacket;
import Foundation.Network.SNetworkCore;
import Processors.Game.TProcessorGame;
import Processors.Game.Battle.TBattleHandle;
import Processors.Game.Lobby.Shortcuts.TProcessorShortcuts;
import Resources.Constants.CONST_BATTLE;
public class TProcessorLobby extends TProcessorGame {
protected var FMountPointIcons:TUIComponent;
protected var FMountPointWindow:TUIComponent;
protected var FProcessorShortcuts:TProcessorShortcuts;
public function TProcessorLobby(parent:TUIComponent){super(parent);}
protected function ProcessorOnSetBattleStatus(sender:Object,type:uint,id:uint):void{}
protected function ProcessorLobbyOnInitBattle(sender:Object):void{}
protected function BattleQueryActive():Boolean{return false;}
'''
stub_path=work/'stub/Processors/Game/Lobby/TProcessorLobby.as';stub_path.parent.mkdir(parents=True,exist_ok=True);stub_path.write_text(imports+ui+'\n}}',encoding='utf-8')
stub_swf=work/'stub.swf'
if '--resume' not in sys.argv:
 print('Compiling event UI only...',flush=True);ffdec('-onerror','abort','-importScript',root_swf,stub_swf,work/'stub')
subprocess.run([str(JAVA/'javac.exe'),'-cp',JAR,str(BASE/'PatchUiBodies.java')],check=True)
compiled=work/'compiled.swf'
subprocess.run([str(JAVA/'java.exe'),'-cp',str(BASE)+';'+JAR,'PatchUiBodies',str(root_swf),str(stub_swf),str(compiled)],check=True)
rebuilt=compiled.read_bytes()
assert [t for t in tags(decoded) if t[0]!=82]==[t for t in tags(rebuilt) if t[0]!=82]
ffdec('-selectclass','Processors.Game.Lobby.TProcessorLobby,Processors.Game.TProcessorGameRoot','-export','script',work/'verify',compiled)
check=(work/'verify/scripts/Processors/Game/Lobby/TProcessorLobby.as').read_text(encoding='utf-8')
assert 'Tahoma' in check and 'ẢO CẢNH VÔ HẠN' in check and '.rotation = 12' not in check
assert 'MUKEN AIZEN' in check and 'IllusionInfoRet' in check
assert 'function IllusionText(parent:Sprite,' in check and 'function IllusionBox(parent:Sprite,' in check
assert 'function IllusionButton(parent:Sprite,' in check and 'function IllusionRow(parent:Sprite,' in check
route=(work/'verify/scripts/Processors/Game/TProcessorGameRoot.as').read_text(encoding='utf-8')
assert '18382336,18382337,this.PacketPerform_ProcessorLobby' in route
assert CLIENT.read_bytes()==live,'Client changed while compiling'
backup=BASE/'backups'/(datetime.now().strftime('%Y%m%d-%H%M%S')+'-before-native-ui.swf.bak');backup.parent.mkdir(exist_ok=True);shutil.copy2(CLIENT,backup)
CLIENT.write_bytes(swap(rebuilt))
for version in ['2026101001','2026101002']:
 alias=CLIENT.parent.parent/version/'TApplication.swf'
 if alias.exists():shutil.copy2(CLIENT,alias)
print('Installed verified native boss UI; backup:',backup)
subprocess.run([sys.executable,str(BASE/'refresh-loader.py')],check=True)
