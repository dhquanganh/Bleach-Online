package Logics.Streamization.Inventories
{
   import Debugging.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Streamization.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TUnstreamizerInventoryReference extends TUnstreamizerInventoryUnknown
   {
      
      protected var FUnstreamizerEquipment:TUnstreamizerEquipment;
      
      protected var FUnstreamizerAppliance:TUnstreamizerAppliance;
      
      protected var FUnstreamizerCrashJade:TUnstreamizerCrashJade;
      
      protected var FUnstreamizerWakeEquip:TUnstreamizerWakeEquip;
      
      public function TUnstreamizerInventoryReference()
      {
         super();
         this.FUnstreamizerEquipment = new TUnstreamizerEquipment();
         this.FUnstreamizerAppliance = new TUnstreamizerAppliance();
         this.FUnstreamizerCrashJade = new TUnstreamizerCrashJade();
         this.FUnstreamizerWakeEquip = new TUnstreamizerWakeEquip();
      }
      
      protected function AcquireInventory(param1:uint) : TInventory
      {
         var _loc2_:uint = 0;
         var _loc3_:TInventory = null;
         _loc2_ = this.InventoryClassByCategory(param1);
         switch(_loc2_)
         {
            case CLASS_Equipment:
               _loc3_ = FPoolInventory.AcquireEquipment();
               break;
            case CLASS_Appliance:
               _loc3_ = FPoolInventory.AcquireAppliance();
               break;
            case CLASS_CrashJade:
               _loc3_ = FPoolInventory.AcquireCrashJade();
               break;
            case CLASS_WakeEquip:
               _loc3_ = FPoolInventory.AcquireWakeUp();
               break;
            default:
               return null;
         }
         _loc3_.Category = param1;
         return _loc3_;
      }
      
      protected function InventoryClassByCategory(param1:uint) : uint
      {
         var _loc2_:int = 0;
         _loc2_ = CATEGORY_Equipments.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return CLASS_Equipment;
         }
         _loc2_ = CATEGORY_CrashJades.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return CLASS_CrashJade;
         }
         _loc2_ = CATEGORY_WakeEquips.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return CLASS_WakeEquip;
         }
         return CLASS_Appliance;
      }
      
      protected function InventoryUnstreamizerByCategory(param1:uint) : TUnstreamizerInventory
      {
         var _loc2_:uint = 0;
         _loc2_ = this.InventoryClassByCategory(param1);
         switch(_loc2_)
         {
            case CLASS_Equipment:
               return this.FUnstreamizerEquipment;
            case CLASS_Appliance:
               return this.FUnstreamizerAppliance;
            case CLASS_CrashJade:
               return this.FUnstreamizerCrashJade;
            case CLASS_WakeEquip:
               return this.FUnstreamizerWakeEquip;
            default:
               return null;
         }
      }
      
      protected function InventoryUnstreamizerSpecialProcessing(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         _loc4_ = param3 as int;
         _loc5_ = this.InventoryClassByCategory(_loc4_);
         if(_loc5_ == CLASS_Appliance || _loc5_ == CLASS_WakeEquip)
         {
            param1.readUnsignedByte();
            param1.readUnsignedByte();
            param1.readUnsignedShort();
            param1.readUnsignedInt();
            param1.readUnsignedInt();
            param1.readUnsignedShort();
         }
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Inventory(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Inventory(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:TInventory = null;
         var _loc6_:TUnstreamizerInventory = null;
         var _loc7_:TInventoryReference = null;
         _loc7_ = param2 as TInventoryReference;
         _loc4_ = param1.readUnsignedByte();
         _loc5_ = this.AcquireInventory(_loc4_);
         _loc6_ = this.InventoryUnstreamizerByCategory(_loc4_);
         _loc6_.Unstreamize(param1,_loc5_,param3);
         this.InventoryUnstreamizerSpecialProcessing(param1,param2,_loc4_);
         _loc7_.Inventory = _loc5_;
      }
      
      protected function UnstreamizationPerform_GenerateInventoriesByIdentifiers(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:Vector.<uint> = null;
         var _loc9_:TUnstreamizerInventory = null;
         var _loc10_:TCollectionInventory = null;
         var _loc11_:TInventories = null;
         var _loc12_:TInventory = null;
         var _loc13_:TBins = null;
         var _loc14_:TArticle = null;
         var _loc15_:uint = 0;
         _loc15_ = 0;
         if(param2 is TCollectionInventory)
         {
            _loc10_ = param2 as TCollectionInventory;
         }
         else if(param2 is TInventories)
         {
            _loc11_ = param2 as TInventories;
         }
         _loc8_ = param3 as Vector.<uint>;
         _loc13_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         _loc5_ = int(_loc8_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = _loc8_[_loc4_];
            _loc14_ = _loc13_.GetDatebaseByIdentifier(_loc6_) as TArticle;
            _loc7_ = uint(_loc14_.MajorType);
            _loc12_ = this.AcquireInventory(_loc7_);
            _loc9_ = this.InventoryUnstreamizerByCategory(_loc7_);
            _loc12_.IDTemplate = _loc6_;
            _loc9_.UnstreamizeGenerateInventory(param1,_loc12_,_loc15_);
            if(param2 is TCollectionInventory)
            {
               _loc10_.SetInventoryByIndex(_loc12_.CategorySecond,_loc12_);
            }
            else if(param2 is TInventories)
            {
               _loc11_.Add(_loc12_);
            }
            _loc4_++;
         }
      }
      
      protected function UnstreamizationPerform_GenerateInventoryByIdentified(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TArticle = null;
         var _loc8_:TInventory = null;
         var _loc9_:TUnstreamizerInventory = null;
         var _loc10_:TInventoryReference = null;
         _loc4_ = 0;
         _loc10_ = param2 as TInventoryReference;
         _loc5_ = param3 as uint;
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc5_) as TArticle;
         _loc6_ = uint(_loc7_.MajorType);
         _loc8_ = this.AcquireInventory(_loc6_);
         _loc9_ = this.InventoryUnstreamizerByCategory(_loc6_);
         _loc8_.IDTemplate = _loc5_;
         _loc9_.UnstreamizeGenerateInventory(param1,_loc8_,_loc4_);
         _loc10_.Inventory = _loc8_;
      }
      
      protected function UnstreamizationPerform_QuestReward(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_QRInventory(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_QRInventory(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TInventoryReference = null;
         var _loc5_:TInventory = null;
         _loc4_ = param2 as TInventoryReference;
         _loc4_.Inventory = _loc5_;
      }
      
      public function UnstreamizeGenerateInventoriesByIdentifiers(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_GenerateInventoriesByIdentifiers(param1,param2,param3);
      }
      
      public function UnstreamizeGenerateInventoryByIdentified(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_GenerateInventoryByIdentified(param1,param2,param3);
      }
      
      public function UnstreamizeQuestReward(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_QuestReward(param1,param2,param3);
      }
      
      public function UnstreamizeWakeAttributes(param1:Object, param2:Object) : void
      {
         this.FUnstreamizerWakeEquip.UnstreamizationWakeAttribute(param1,param2);
      }
   }
}

