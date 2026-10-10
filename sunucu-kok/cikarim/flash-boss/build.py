"""Patch the live native Flash client, verify bytecode and preserve all existing assets."""
from pathlib import Path
import subprocess,sys,shutil
from datetime import datetime
BASE=Path(__file__).resolve().parent
sys.path.insert(0,str(BASE.parent/'flash-cross-server'))
from build import swap,tags,CLIENT
JAR='C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar'
names=['Processors/Game/Lobby/Shortcuts/Window/TWindowActiveListTwo.as','Processors/Game/Lobby/Shortcuts/TProcessorShortcuts.as','Processors/Game/Lobby/TProcessorLobby.as']
classes=','.join(n[:-3].replace('/','.') for n in names)
live=CLIENT.read_bytes();decoded=swap(live);source=BASE/'live.swf';source.write_bytes(decoded)
def ffdec(*args):
 p=subprocess.run(['java','-Xmx2g','-jar',JAR,*map(str,args)],capture_output=True,text=True,errors='replace')
 if p.returncode:raise RuntimeError(p.stdout+p.stderr)
 print(p.stdout[-700:],flush=True)
ffdec('-selectclass',classes,'-export','script',BASE/'original',source)
original=BASE/'original/scripts';patched=BASE/'patched'
for name in names:
 s=(original/name).read_text(encoding='utf-8')
 if 'function IllusionAnchor' in s or 'function IllusionConstruct' in s:raise RuntimeError('Client already patched; restore backup before rebuilding')
 if name.endswith('TWindowActiveListTwo.as'):
  s=s.replace('   import flash.events.MouseEvent;','   import flash.events.MouseEvent;\n   import flash.geom.Point;\n   import flash.display.SimpleButton;')
  method='''
      public function IllusionAnchor() : Point
      {
         if(!this.Visible || !FUIShortcut.IsInitialization)return null;
         var gift:SimpleButton=FUIShortcut.GetButtonByIndex(FShortcutsTypes.indexOf(TYPE_ActiveList_ReceivePacks));
         if(gift==null||!gift.visible)return null;
         return gift.localToGlobal(new Point(-72,0));
      }
'''
  idx=s.rfind('   }');s=s[:idx]+method+s[idx:]
 elif name.endswith('TProcessorShortcuts.as'):
  s=s.replace('   import flash.utils.*;','   import flash.utils.*;\n   import flash.geom.Point;')
  idx=s.rfind('   }');s=s[:idx]+'''      public function IllusionAnchor() : Point
      {
         if(!this.Visible||this.FWindowActiveListTwo==null)return null;
         return this.FWindowActiveListTwo.IllusionAnchor();
      }
'''+s[idx:]
 else:
  s=s.replace('   import flash.events.*;','   import flash.events.*;\n   import flash.display.*;\n   import flash.text.*;\n   import flash.geom.Point;\n   import flash.filters.DropShadowFilter;\n   import flash.net.URLRequest;')
  s=s.replace('         this.ConstructProcessorShortcuts();','         this.ConstructProcessorShortcuts();\n         this.IllusionConstruct();')
  s=s.replace('      override protected function PacketRegisterRoutines() : void\n      {','      override protected function PacketRegisterRoutines() : void\n      {\n         FPacketRoutines.Register(0x01187E00,this.IllusionInfoRet);\n         FPacketRoutines.Register(0x01187E01,this.IllusionFightRet);')
  s=s.replace('         this.LogicsPerform_MountPoints();','         this.LogicsPerform_MountPoints();\n         this.IllusionUpdate();')
  idx=s.rfind('   }');s=s[:idx]+(BASE/'ui-methods.as.txt').read_text(encoding='utf-8')+'\n'+s[idx:]
 target=patched/name;target.parent.mkdir(parents=True,exist_ok=True);target.write_text(s,encoding='utf-8')
for i,name in enumerate(names):
 phase=BASE/('phase-'+str(i));target=phase/name;target.parent.mkdir(parents=True,exist_ok=True);shutil.copy2(patched/name,target)
 out=BASE/('phase-'+str(i)+'.swf');print('Compiling',name,flush=True)
 ffdec('-onerror','abort','-importScript',source,out,phase);source=out
rebuilt=source.read_bytes()
assert [t for t in tags(decoded) if t[0]!=82]==[t for t in tags(rebuilt) if t[0]!=82], 'Existing SWF assets changed'
ffdec('-selectclass',classes,'-export','script',BASE/'verify',source)
check=(BASE/'verify/scripts'/names[-1]).read_text(encoding='utf-8')
assert 'IllusionFightRet' in check and 'IllusionInfoRet' in check and 'IllusionUpdate' in check
assert 'readUTF()' in check and '1000000000' in check
assert CLIENT.read_bytes()==live,'Client changed during compile'
backup=BASE/'backups'/ (datetime.now().strftime('%Y%m%d-%H%M%S')+'-TApplication.swf.bak')
backup.parent.mkdir(exist_ok=True);shutil.copy2(CLIENT,backup);CLIENT.write_bytes(swap(rebuilt))
for version in ['2026101001']:
 alias=CLIENT.parent.parent/version/'TApplication.swf'
 if alias.exists():shutil.copy2(CLIENT,alias)
print('Installed Infinite Illusion native client. Backup:',backup)
subprocess.run([sys.executable,str(BASE/'refresh-loader.py')],check=True)
ffdec('-selectclass','Processors.Game.Lobby.TProcessorLobby','-format','script:pcode','-export','script',BASE/'pcode-verify',source)
subprocess.run([sys.executable,str(BASE/'verify-bytecode.py')],check=True)
