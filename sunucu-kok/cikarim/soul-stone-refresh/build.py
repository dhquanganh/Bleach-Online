"""Rebind Soul Stone selection after equipment updates and redraw all slots."""
from pathlib import Path
import sys
BASE = Path(__file__).resolve().parent
name = 'Processors/Game/Lobby/Jade/TJadeMosaic.as'
text = (BASE/'original/scripts'/name).read_text(encoding='utf-8')
anchor = 'public function Update() : void\n      {\n         switch(this.FCurrentState)'
assert anchor in text
text = text.replace(anchor, '''public function Update() : void
      {
         var selectedEquipmentId:uint = 0;
         var equipmentIndex:int = 0;
         var currentEquipment:TEquipment = null;
         selectedEquipmentId = this.FCurrentShowEquipment != null ? this.FCurrentShowEquipment.Identifier : 0;
         if(this.FCurrentShowTagIndex >= 0)
         {
            this.SelectEquipmentsByTabIndex(this.FCurrentShowTagIndex,this.FCurrentShowEquipmentBag);
            this.FCurrentShowEquipment = null;
            equipmentIndex = 0;
            while(equipmentIndex < this.FCurrentShowEquipmentBag.Count)
            {
               currentEquipment = this.FCurrentShowEquipmentBag.GetInventoryByIndex(equipmentIndex) as TEquipment;
               if(currentEquipment != null && currentEquipment.Identifier == selectedEquipmentId)
               {
                  this.FCurrentShowEquipment = currentEquipment;
                  break;
               }
               equipmentIndex++;
            }
         }
         switch(this.FCurrentState)''',1)
# Context assignment can retain a slot's existing texture; explicitly render the new state.
anchor = 'this.UpdateEquipmentJadeSlot();\n         this.UpdateJadeRecommend();\n         this.UpdateBackpackJade();'
assert anchor in text
text = text.replace(anchor, '''this.UpdateEquipmentJadeSlot();
         this.UpdateJadeRecommend();
         this.UpdateBackpackJade();
         TJadeCommon.ProcessorUpdateSlotsRenderingState(this.FEquipmentJadeSlots);
         TJadeCommon.ProcessorUpdateSlotsRenderingState(this.FBackpackSlots);''',1)
target = BASE/'patched'/name
target.parent.mkdir(parents=True,exist_ok=True)
target.write_text(text,encoding='utf-8')
# Reuse the verified compiler/asset-preservation/loader installer from the sweep patch.
# Only its build/install tail runs, with this patch's own class and verification checks.
installer = (BASE.parent/'world-map-sweep/build.py').read_text(encoding='utf-8')
tail = installer[installer.index('live = CLIENT.read_bytes()'):]
tail = tail.replace("verified = (BASE/'verify/scripts'/barrier).read_text(encoding='utf-8')", "verified = (BASE/'verify/scripts'/name).read_text(encoding='utf-8')")
tail = tail.replace("assert 'Math.min(50' in verified and 'while(this.FNodalAutoBattleInfo.BattleResult.length > 0)' in verified", "assert 'selectedEquipmentId' in verified and 'this.SelectEquipmentsByTabIndex(this.FCurrentShowTagIndex,this.FCurrentShowEquipmentBag)' in verified")
tail = tail.replace("assert 'this.FStatus = AutoStatus_Open;' in verified", "assert 'TJadeCommon.ProcessorUpdateSlotsRenderingState(this.FEquipmentJadeSlots)' in verified and 'TJadeCommon.ProcessorUpdateSlotsRenderingState(this.FBackpackSlots)' in verified")
tail = tail.replace("b'2026101101'", "b'2026101102'")
tail = tail.replace('Installed sweep client', 'Installed Soul Stone refresh client')
sys.path.insert(0,str(BASE.parent/'flash-hueco'))
from build import swap,tags,CLIENT
import subprocess,shutil,struct,zlib
from datetime import datetime
JAR = 'C:/Users/quang/AppData/Local/Temp/ffdec-void/regular/ffdec.jar'
names = [name]
patched = BASE/'patched'
exec(compile(tail,str(BASE/'build.py'),'exec'))
