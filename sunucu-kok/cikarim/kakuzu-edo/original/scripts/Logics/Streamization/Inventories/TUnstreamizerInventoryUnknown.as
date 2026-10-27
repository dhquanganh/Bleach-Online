package Logics.Streamization.Inventories
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.Inventories.TPoolInventory;
   import Logics.Spaces.LogicsSpace;
   import Resources.Constants.CONST_INVENTORY;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerInventoryUnknown extends TUnstreamizer
   {
      
      protected static var FPoolInventory:TPoolInventory;
      
      public static const CATEGORY_Equipments:Vector.<uint> = CONST_INVENTORY.CATEGORY_Equipments;
      
      public static const CATEGORY_Appliances:Vector.<uint> = CONST_INVENTORY.CATEGORY_Appliances;
      
      public static const CATEGORY_CrashJades:Vector.<uint> = CONST_INVENTORY.CATEGORY_CrashJades;
      
      public static const CATEGORY_WakeEquips:Vector.<uint> = CONST_INVENTORY.CATEGORY_WakeEquips;
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      public static const CATEGORY_Ornament:uint = CONST_INVENTORY.CATEGORY_Ornament;
      
      public static const CLASS_Equipment:uint = 0;
      
      public static const CLASS_Appliance:uint = 1;
      
      public static const CLASS_CrashJade:uint = 2;
      
      public static const CLASS_WakeEquip:uint = 3;
      
      public function TUnstreamizerInventoryUnknown()
      {
         super();
      }
      
      LogicsSpace static function PoolsSetup(param1:TPoolInventory) : void
      {
         FPoolInventory = param1;
      }
   }
}

