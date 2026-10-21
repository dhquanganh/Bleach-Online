package {
import flash.display.Sprite;
import flash.external.ExternalInterface;
import Logics.Inventories.*;
import Resources.Constants.CONST_INVENTORY;
public class TApplication extends Sprite {
 public function TApplication(){super();try{run();}catch(e:Error){ExternalInterface.call("stoneProbe","ERROR "+e.toString()+" "+e.getStackTrace());}}
 private function check(actual:int,expected:int,label:String):void {if(actual!=expected)throw new Error(label);ExternalInterface.call("stoneProbe","PASS "+label);}
 private function run():void {
  this.InitProbe();
  
  this.receive(0,stone(100,3,1),false);
  this.check(this.FCharacter.Gems.Count,0,"reproduced old client dropping a new Spirit Stone");
  this.receive(0,stone(100,3,1),true);
  this.check(this.FCharacter.Gems.Count,1,"first Spirit Stone appears immediately");
  this.check(this.FCharacter.Gems.GetInventoryByIdentifier(100).Quantity,1,"first stone quantity");
  this.receive(0,stone(100,3,4),true);
  this.check(this.FCharacter.Gems.Count,1,"existing stone does not duplicate");
  this.check(this.FCharacter.Gems.GetInventoryByIdentifier(100).Quantity,4,"existing stone updates total");
  this.receive(0,stone(101,3,2),true);
  this.check(this.FCharacter.Gems.Count,2,"second stone type appears independently");
  this.receive(0,stone(102,3,0),true);
  this.check(this.FCharacter.Gems.Count,2,"zero quantity does not create ghost stone");
  this.receive(0,stone(200,1,1),true);this.receive(0,stone(201,5,3),true);
  this.check(this.FCharacter.Appliances.Count,1,"new normal items appear");
  this.check(this.FCharacter.Materials.Count,1,"new materials appear");
  this.receive(1,stone(300,3,1),true);
  this.check(this.FCharacter.TemporaryInventories.Count,1,"temporary bag receives item");
  this.check(this.FCharacter.Gems.Count,2,"temporary bag stays separate");
  this.receive(0,stone(400,21,1),true);
  this.check(this.FCharacter.Appliances.Count,2,"new Modify Fragment appears immediately");
  this.receive(0,stone(400,21,5),true);
  this.check(this.FCharacter.Appliances.GetInventoryByIdentifier(400).Quantity,5,"Modify Fragment total updates without duplication");
  ExternalInterface.call("stoneProbe","DONE");
 }
 private function stone(id:uint,cat:uint,n:uint):TAppliance{var a:TAppliance=new TAppliance(id);a.Category=cat;a.Quantity=n;a.IDTemplate=14500001;return a;}

 public var FCharacter:Object;
 public var FUtilityInventory:Object;
 public function InitProbe(){FCharacter={};FCharacter.Appliances=new TInventories();FCharacter.Equipments=new TInventories();FCharacter.Ornaments=new TInventories();FCharacter.Gems=new TInventories();FCharacter.Treasures=new TInventories();FCharacter.Materials=new TInventories();FCharacter.WakeEquip=new TInventories();FCharacter.TemporaryInventories=new TInventories();FUtilityInventory={};FUtilityInventory.ApplianceAssign=function(a:TAppliance,c:TAppliance):void{c.Quantity=a.Quantity;};FUtilityInventory.EquipmentAssign=function(a:TEquipment,c:TEquipment):void{c.Quantity=a.Quantity;};}
 public static const TYPE_TEMP_BACKPACK:uint=1;
 public static const CATEGORY_Normal:uint=1;
 public static const CATEGORY_Equipment:uint=2;
 public static const CATEGORY_Gem:uint=3;
 public static const CATEGORY_Treasure:uint=4;
 public static const CATEGORY_Material:uint=5;
 public static const CATEGORY_Ornament:uint=6;
 public static const CATEGORY_WakeEquip:uint=13;
 public function receive(bag:uint,item:TInventory,fixed:Boolean):void{var scratch:TInventories=new TInventories();scratch.Add(item);if(!ProcessorInventoryUpdateByBackpack(bag,item)&&fixed)InsertNewlyReceivedInventory(bag,item);scratch.Clear();}
      public function ProcessorInventoryUpdateByBackpack(param1:uint, param2:TInventory) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:TInventory = null;
         var _loc5_:TInventories = null;
         var _loc6_:TEquipment = null;
         var _loc7_:TEquipment = null;
         var _loc8_:TAppliance = null;
         var _loc9_:TAppliance = null;
         _loc3_ = false;
         if(param1 == TYPE_TEMP_BACKPACK)
         {
            _loc5_ = this.FCharacter.TemporaryInventories;
         }
         else
         {
            switch(param2.Category)
            {
               case 21:
               case CATEGORY_Normal:
                  _loc5_ = this.FCharacter.Appliances;
                  break;
               case CATEGORY_Equipment:
                  _loc5_ = this.FCharacter.Equipments;
                  break;
               case CATEGORY_Ornament:
                  _loc5_ = this.FCharacter.Ornaments;
                  break;
               case CATEGORY_Gem:
                  _loc5_ = this.FCharacter.Gems;
                  break;
               case CATEGORY_Treasure:
                  _loc5_ = this.FCharacter.Treasures;
                  break;
               case CATEGORY_Material:
                  _loc5_ = this.FCharacter.Materials;
                  break;
               case CATEGORY_WakeEquip:
                  _loc5_ = this.FCharacter.WakeEquip;
            }
         }
         if(param2.Quantity != 0)
         {
            _loc4_ = _loc5_.GetInventoryByIdentifier(param2.Identifier);
         }
         if(param1 == TYPE_TEMP_BACKPACK)
         {
            _loc5_.SortTime();
         }
         else
         {
            _loc5_.Sort();
         }
         if(_loc4_ != null)
         {
            switch(param2.Category)
            {
               case CATEGORY_Ornament:
               case CATEGORY_Equipment:
               case CATEGORY_Treasure:
                  _loc6_ = param2 as TEquipment;
                  _loc7_ = _loc4_ as TEquipment;
                  this.FUtilityInventory.EquipmentAssign(_loc6_,_loc7_);
                  break;
               case 21:
               case CATEGORY_Normal:
               case CATEGORY_Material:
               case CATEGORY_Gem:
               case CATEGORY_WakeEquip:
                  _loc8_ = param2 as TAppliance;
                  _loc9_ = _loc4_ as TAppliance;
                  this.FUtilityInventory.ApplianceAssign(_loc8_,_loc9_);
            }
            _loc3_ = true;
         }
         return _loc3_;
      }
      public function InsertNewlyReceivedInventory(bag:uint, item:TInventory) : Boolean
      {
         if(item == null || item.Quantity == 0)
         {
            return false;
         }
         var target:TInventories = null;
         if(bag == TYPE_TEMP_BACKPACK)
         {
            target = this.FCharacter.TemporaryInventories;
         }
         else
         {
            switch(item.Category)
            {
               case 21:
               case CATEGORY_Normal:
                  target = this.FCharacter.Appliances;
                  break;
               case CATEGORY_Equipment:
                  target = this.FCharacter.Equipments;
                  break;
               case CATEGORY_Ornament:
                  target = this.FCharacter.Ornaments;
                  break;
               case CATEGORY_Gem:
                  target = this.FCharacter.Gems;
                  break;
               case CATEGORY_Treasure:
                  target = this.FCharacter.Treasures;
                  break;
               case CATEGORY_Material:
                  target = this.FCharacter.Materials;
                  break;
               case CATEGORY_WakeEquip:
                  target = this.FCharacter.WakeEquip;
            }
         }
         if(target == null || target.GetInventoryByIdentifier(item.Identifier) != null)
         {
            return false;
         }
         target.Add(item);
         target.Sort();
         return true;
      }

}
}
