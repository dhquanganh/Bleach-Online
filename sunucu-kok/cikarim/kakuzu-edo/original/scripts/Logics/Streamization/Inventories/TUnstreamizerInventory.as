package Logics.Streamization.Inventories
{
   import Foundation.Resources.SResourcesCore;
   import Foundation.Timing.STimingCore;
   import Foundation.Utilities.TUtilityMath;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.Inventories.TInventory;
   import Logics.Spaces.LogicsSpace;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_INVENTORY;
   import flash.utils.ByteArray;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerInventory extends TUnstreamizerInventoryUnknown
   {
      
      protected static const TIMINGCATEGORY_Permant:uint = CONST_INVENTORY.TIMINGCATEGORY_Permant;
      
      protected static const TIMINGCATEGORY_Pick:uint = CONST_INVENTORY.TIMINGCATEGORY_Pick;
      
      public function TUnstreamizerInventory()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_CommonProperties(param1,param2,param3);
         this.UnstreamizationPerform_InventoryByDatabase(param2);
      }
      
      protected function UnstreamizationPerform_CommonProperties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TInventory = null;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         _loc4_ = param2 as TInventory;
         _loc4_.IDTemplate = param1.readUnsignedInt();
         _loc5_ = param1.readUnsignedInt();
         _loc4_.Coerce(_loc5_);
         _loc4_.Quantity = param1.readUnsignedShort();
         _loc4_.TimingCategory = param1.readUnsignedByte();
         _loc6_ = param1.readUnsignedInt() - STimingCore.ServerTick;
         if(_loc6_ < 0)
         {
            _loc6_ = 0;
         }
         switch(_loc4_.TimingCategory)
         {
            case TIMINGCATEGORY_Permant:
               _loc4_.TimingState = CONST_INVENTORY.TIMINGSTATE_Permant;
               break;
            case TIMINGCATEGORY_Pick:
               if(_loc6_ > 0)
               {
                  _loc4_.TimingState = CONST_INVENTORY.TIMINGSTATE_Started;
               }
               else
               {
                  _loc4_.TimingState = CONST_INVENTORY.TIMINGSTATE_Expired;
               }
         }
         _loc4_.TimingTime = _loc6_;
      }
      
      protected function UnstreamizationPerform_InventoryByDatabase(param1:Object) : void
      {
         var _loc2_:TArticle = null;
         var _loc3_:TInventory = null;
         _loc3_ = param1 as TInventory;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc3_.IDTemplate) as TArticle;
         _loc3_.Category = _loc2_.MajorType;
         _loc3_.CategorySecond = _loc2_.MinorType;
         _loc3_.Name = _loc2_.Name;
         _loc3_.Description = _loc2_.FunctionDesc;
         _loc3_.IDTexture = _loc2_.Picture;
         _loc3_.Quality = _loc2_.Quality;
         _loc3_.IsCanSell = _loc2_.ExpandIsCanSell;
         _loc3_.SellValue = _loc2_.SellPrice;
         _loc3_.IsCanDiscard = _loc2_.ExpandIsCanDiscard;
         _loc3_.IsCanReveal = _loc2_.ExpandIsCanReveal;
         _loc3_.SortIndex = _loc2_.Sort;
         _loc3_.RequirementLevel = _loc2_.Level;
      }
      
      protected function UnstreamizationPerform_GenerateInventory(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TInventory = null;
         var _loc5_:uint = 0;
         var _loc6_:TArticle = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         _loc4_ = param2 as TInventory;
         _loc7_ = param3 as uint;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc4_.IDTemplate) as TArticle;
         if(_loc7_ == 1)
         {
            _loc5_ = 0;
         }
         _loc4_.Coerce(_loc5_);
         if(_loc7_ == 1)
         {
            switch(_loc4_.Category)
            {
               case 6:
                  _loc8_ = TUtilityMath.RandomRange(0,100) as uint;
                  _loc4_.Quantity = 1;
                  break;
               case 2:
                  _loc8_ = TUtilityMath.RandomRange(0,150) as uint;
                  _loc4_.Quantity = 1;
                  break;
               case 4:
                  _loc8_ = TUtilityMath.RandomRange(0,10) as uint;
                  _loc4_.Quantity = 1;
                  break;
               case 1:
               case 3:
               case 5:
                  _loc4_.Quantity = TUtilityMath.RandomRange(1,99) as uint;
            }
         }
         _loc4_.TimingCategory = 0;
         _loc4_.TimingState = 0;
         _loc4_.TimingTime = 0;
      }
      
      protected function UnstreamizationPerform_QuestReward(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_QRCommonProperties(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_QRCommonProperties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TInventory = null;
         _loc4_ = param2 as TInventory;
      }
      
      public function UnstreamizeGenerateInventory(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_GenerateInventory(param1,param2,param3);
         this.UnstreamizationPerform_InventoryByDatabase(param2);
      }
      
      public function UnstreamizeQuestReward(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_QuestReward(param1,param2,param3);
      }
   }
}

