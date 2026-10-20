package
{
   import Logics.Inventories.*;
   
   internal class StoneProbeWorker
   {
      
      public static const TYPE_TEMP_BACKPACK:uint = 1;
      
      public static const CATEGORY_Normal:uint = 1;
      
      public static const CATEGORY_Equipment:uint = 2;
      
      public static const CATEGORY_Gem:uint = 3;
      
      public static const CATEGORY_Treasure:uint = 4;
      
      public static const CATEGORY_Material:uint = 5;
      
      public static const CATEGORY_Ornament:uint = 6;
      
      public static const CATEGORY_WakeEquip:uint = 13;
      
      public var FCharacter:Object = null;
      
      public var FUtilityInventory:Object = {
         "ApplianceAssign":function(a:TAppliance, c:TAppliance):void
         {
            c.Quantity = a.Quantity;
         },
         "EquipmentAssign":function(a:TEquipment, c:TEquipment):void
         {
            c.Quantity = a.Quantity;
         }
      };
      
      public function StoneProbeWorker()
      {
         super();
      }
      
      public function receive(bag:uint, item:TInventory, fixed:Boolean) : void
      {
         var scratch:TInventories = new TInventories();
         scratch.Add(item);
         if(!ProcessorInventoryUpdateByBackpack(bag,item) && fixed)
         {
            InsertNewlyReceivedInventory(bag,item);
         }
         scratch.Clear();
      }
      
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

