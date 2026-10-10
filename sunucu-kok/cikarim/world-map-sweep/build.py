"""Patch world-map sweep selection, completion and rejection; retain existing SWF assets."""
from pathlib import Path
import sys, subprocess, shutil, struct, zlib
from datetime import datetime
BASE = Path(__file__).resolve().parent
sys.path.insert(0, str(BASE.parent / 'flash-hueco'))
from build import swap, tags, CLIENT
JAR = 'C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar'
barrier = 'Processors/Game/Lobby/WorldMapBleach/BarrierAutoBattle/TProcessorBarrierAutoBattle.as'
world = 'Processors/Game/Lobby/WorldMapBleach/LargeWorldMap/TProcessorLargeWorldMap.as'
names = [barrier, world]
patched = BASE / 'patched'
for name in names:
    text = (BASE / 'original/scripts' / name).read_text(encoding='utf-8')
    if name == barrier:
        text = text.replace('this.FMaxCount = Math.round(Math.floor(this.FCharacter.CreditMilitaryOrders / _loc1_.Spirit));', 'this.FMaxCount = Math.max(0,Math.min(50,Math.floor(this.FCharacter.CreditMilitaryOrders / Math.max(1,_loc1_.Spirit))));\n            this.FAutoInitTimer = 0;')
        text = text.replace('this.FMaxCount = Math.round(Math.floor(this.FCharacter.CreditMilitaryOrders / _loc8_.Spirit));', 'this.FMaxCount = Math.max(0,Math.min(50,Math.floor(this.FCharacter.CreditMilitaryOrders / Math.max(1,_loc8_.Spirit))));')
        text = text.replace('this.FAutoCount = param1;', 'this.FAutoCount = Math.max(0,Math.min(param1,this.FMaxCount,this.FNodalAutoInfo.BattleType == CONST_BATTLE.BattleType_OrgSingle ? 32767 : 50));')
        text = text.replace('this.FScene.tf_countInput.text = String(param1);', 'this.FScene.tf_countInput.text = String(this.FAutoCount);')
        text = text.replace('this.FAutoInitTimer = this.FNodalAutoInfo.CostTime;', 'this.FAutoInitTimer = this.FNodalAutoInfo.BattleType == CONST_BATTLE.BattleType_OrgSingle ? this.FNodalAutoInfo.CostTime : 0;')
        anchor = '_loc2_ = param1.Data;\n         this.FStatus = AutoStatus_Begin;'
        assert anchor in text
        text = text.replace(anchor, '''_loc2_ = param1.Data;
         if(_loc2_.position == 0 && _loc2_.readUnsignedInt() != 0)
         {
            clearInterval(this.FStartRunTimerID);
            clearTimeout(this.FAutoUpdataUITimerID);
            this.FAutoUpdataUIStatus = false;
            this.FNodalAutoBattleInfo.BattleResult.length = 0;
            this.FStatus = AutoStatus_Open;
            this.TotleTimer = 0;
            this.Updata();
            return;
         }
         this.FNodalAutoBattleInfo.BattleResult.length = 0;
         this.FStatus = AutoStatus_Begin;''')
        anchor = 'this.TotleTimer = this.FNodalAutoBattleInfo.CostTimer;\n         if(!this.FAutoUpdataUIStatus)'
        assert anchor in text
        text = text.replace(anchor, '''this.TotleTimer = Math.max(0,this.FNodalAutoBattleInfo.CostTimer);
         if(this.FNodalAutoInfo.BattleType != CONST_BATTLE.BattleType_OrgSingle && this.TotleTimer == 0)
         {
            clearInterval(this.FStartRunTimerID);
            this.FAutoCount = this.FNodalAutoBattleInfo.BattleResult.length;
            while(this.FNodalAutoBattleInfo.BattleResult.length > 0)
            {
               this.UpdataAutoUI();
            }
            this.FStatus = AutoStatus_End;
            this.Updata();
            return;
         }
         if(!this.FAutoUpdataUIStatus)''')
    else:
        anchor = '''EffectGenerateTextByErrorCode(_loc3_);
            return;'''
        replacement = '''EffectGenerateTextByErrorCode(_loc3_);
            if(this.FWindowInstanceAutoBattle.Visible != true && this.FOnBarrierAutoBattleInfo != null)
            {
               _loc2_.position = 0;
               this.FOnBarrierAutoBattleInfo(this,param1);
            }
            return;'''
        # Only change the AutoBattleInfo handler, preserving other error routines.
        begin = text.index('protected function PacketPerform_SC_AutoBattleInfo(')
        end = text.index('protected function PacketPerform_SC_AutoBattleFBInfo(', begin)
        section = text[begin:end]
        assert anchor in section
        text = text[:begin] + section.replace(anchor,replacement,1) + text[end:]
    target = patched / name
    target.parent.mkdir(parents=True,exist_ok=True)
    target.write_text(text,encoding='utf-8')
live = CLIENT.read_bytes()
decoded = swap(live)
source = BASE / 'source.swf'
source.write_bytes(decoded)
def ffdec(*args):
    subprocess.run(['java','-Xmx2g','-jar',JAR,*map(str,args)],check=True)
for i,name in enumerate(names):
    phase = BASE / ('phase-' + str(i))
    target = phase / name
    target.parent.mkdir(parents=True,exist_ok=True)
    shutil.copy2(patched/name,target)
    output = BASE / ('compiled-' + str(i) + '.swf')
    ffdec('-onerror','abort','-importScript',source,output,phase)
    source = output
rebuilt = source.read_bytes()
assert [t for t in tags(decoded) if t[0]!=82] == [t for t in tags(rebuilt) if t[0]!=82]
classes = ','.join(n[:-3].replace('/','.') for n in names)
ffdec('-selectclass',classes,'-export','script',BASE/'verify',source)
verified = (BASE/'verify/scripts'/barrier).read_text(encoding='utf-8')
assert 'Math.min(50' in verified and 'while(this.FNodalAutoBattleInfo.BattleResult.length > 0)' in verified
assert 'this.FStatus = AutoStatus_Open;' in verified
assert CLIENT.read_bytes() == live
backup = BASE/'backups'/datetime.now().strftime('%Y%m%d-%H%M%S')
backup.mkdir(parents=True,exist_ok=True)
shutil.copy2(CLIENT,backup/'TApplication.swf.bak')
CLIENT.write_bytes(swap(rebuilt))
public = CLIENT.parent.parent
manifest = public/'2026090619/version.swf'
original = manifest.read_bytes()
raw = zlib.decompress(original)
count = struct.unpack_from('<H',raw)[0]
pos = 2
entries = []
for _ in range(count):
    n = struct.unpack_from('<H',raw,pos)[0]; pos += 2
    key = raw[pos:pos+n]; pos += n
    n = struct.unpack_from('<H',raw,pos)[0]; pos += 2
    value = raw[pos:pos+n]; pos += n
    entries.append((key,value))
assert pos == len(raw)
version = b'2026101101'
updated = [(k,version if k==b'TApplication.swf' else v) for k,v in entries]
assert sum(k==b'TApplication.swf' for k,v in entries)==1
parts = [struct.pack('<H',count)]
for k,v in updated:
    parts.extend([struct.pack('<H',len(k)),k,struct.pack('<H',len(v)),v])
target = public/version.decode()/'TApplication.swf'
target.parent.mkdir(exist_ok=True)
shutil.copy2(CLIENT,target)
shutil.copy2(manifest,backup/'version.swf.bak')
manifest.write_bytes(zlib.compress(b''.join(parts)))
print('Installed sweep client with fresh loader URL; backups:',backup)
