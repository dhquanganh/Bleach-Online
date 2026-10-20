from pathlib import Path
import importlib.util,subprocess
B=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('b',B/'build-client.py');b=importlib.util.module_from_spec(spec);spec.loader.exec_module(b)
source=(B/'verify/scripts'/b.REL).read_text(encoding='utf-8')
methods='\n'.join(b.m.extract(source,n) for n in ['ProcessorInventoryUpdateByBackpack','InsertNewlyReceivedInventory'])
code='''package {
import flash.display.Sprite;
import flash.external.ExternalInterface;
import Logics.Inventories.*;
import Resources.Constants.CONST_INVENTORY;
public class TApplication extends Sprite {
 public function TApplication(){super();try{run();}catch(e:Error){ExternalInterface.call("stoneProbe","ERROR "+e.toString()+" "+e.getStackTrace());}}
 private function check(actual:int,expected:int,label:String):void {if(actual!=expected)throw new Error(label);ExternalInterface.call("stoneProbe","PASS "+label);}
 private function run():void {
  var w:StoneProbeWorker=new StoneProbeWorker();
  var old:StoneProbeWorker=new StoneProbeWorker();
  old.receive(0,stone(100,3,1),false);
  this.check(old.FCharacter.Gems.Count,0,"reproduced old client dropping a new Spirit Stone");
  w.receive(0,stone(100,3,1),true);
  this.check(w.FCharacter.Gems.Count,1,"first Spirit Stone appears immediately");
  this.check(w.FCharacter.Gems.GetInventoryByIdentifier(100).Quantity,1,"first stone quantity");
  w.receive(0,stone(100,3,4),true);
  this.check(w.FCharacter.Gems.Count,1,"existing stone does not duplicate");
  this.check(w.FCharacter.Gems.GetInventoryByIdentifier(100).Quantity,4,"existing stone updates total");
  w.receive(0,stone(101,3,2),true);
  this.check(w.FCharacter.Gems.Count,2,"second stone type appears independently");
  w.receive(0,stone(102,3,0),true);
  this.check(w.FCharacter.Gems.Count,2,"zero quantity does not create ghost stone");
  w.receive(0,stone(200,1,1),true);w.receive(0,stone(201,5,3),true);
  this.check(w.FCharacter.Appliances.Count,1,"new normal items appear");
  this.check(w.FCharacter.Materials.Count,1,"new materials appear");
  w.receive(1,stone(300,3,1),true);
  this.check(w.FCharacter.TemporaryInventories.Count,1,"temporary bag receives item");
  this.check(w.FCharacter.Gems.Count,2,"temporary bag stays separate");
  ExternalInterface.call("stoneProbe","DONE");
 }
 private function stone(id:uint,cat:uint,n:uint):TAppliance{var a:TAppliance=new TAppliance(id);a.Category=cat;a.Quantity=n;a.IDTemplate=14500001;return a;}
}
internal class StoneProbeWorker {
 public var FCharacter:Object;
 public var FUtilityInventory:Object;
 public function StoneProbeWorker(){FCharacter={};FCharacter.Appliances=new TInventories();FCharacter.Equipments=new TInventories();FCharacter.Ornaments=new TInventories();FCharacter.Gems=new TInventories();FCharacter.Treasures=new TInventories();FCharacter.Materials=new TInventories();FCharacter.WakeEquip=new TInventories();FCharacter.TemporaryInventories=new TInventories();FUtilityInventory={};FUtilityInventory.ApplianceAssign=function(a:TAppliance,c:TAppliance):void{c.Quantity=a.Quantity;};FUtilityInventory.EquipmentAssign=function(a:TEquipment,c:TEquipment):void{c.Quantity=a.Quantity;};}
 protected static const TYPE_TEMP_BACKPACK:uint=1;
 protected static const CATEGORY_Normal:uint=1;
 protected static const CATEGORY_Equipment:uint=2;
 protected static const CATEGORY_Gem:uint=3;
 protected static const CATEGORY_Treasure:uint=4;
 protected static const CATEGORY_Material:uint=5;
 protected static const CATEGORY_Ornament:uint=6;
 protected static const CATEGORY_WakeEquip:uint=13;
 public function receive(bag:uint,item:TInventory,fixed:Boolean):void{var scratch:TInventories=new TInventories();scratch.Add(item);if(!ProcessorInventoryUpdateByBackpack(bag,item)&&fixed)InsertNewlyReceivedInventory(bag,item);scratch.Clear();}
__METHODS__
}
}
'''.replace('__METHODS__',methods).replace('protected ','public ')
# Keep the harness in the document class: FFDec's internal-class constructor
# generation can produce invalid AVM2 when compiling cross-class typed calls.
main,worker=code.split('internal class StoneProbeWorker {',1)
main=main[:main.rfind('}')]
worker=worker.rsplit('}',2)[0].replace('public function StoneProbeWorker()','public function InitProbe()')
code=main+worker+'\n}\n}\n'
code=code.replace('var w:StoneProbeWorker=new StoneProbeWorker();','this.InitProbe();').replace('var old:StoneProbeWorker=new StoneProbeWorker();','')
code=code.replace('old.receive','this.receive').replace('old.FCharacter','this.FCharacter').replace('w.receive','this.receive').replace('w.FCharacter','this.FCharacter')
dest=B/'probe-source/TApplication.as';dest.parent.mkdir(exist_ok=True);dest.write_text(code,encoding='utf-8')
b.ff('-onerror','abort','-importScript',B/'compiled.swf',B/'probe.swf',dest.parent)
raw=bytearray((B/'probe.swf').read_bytes());raw[3]=21;(B/'probe.swf').write_bytes(raw)
print('PASS native inventory probe built from production methods')
