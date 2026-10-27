package Logics.Streamization.Inventories
{
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.Inventories.TAppliance;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerAppliance extends TUnstreamizerInventory
   {
      
      public function TUnstreamizerAppliance()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         super.UnstreamizationPerform(param1,param2,param3);
         this.UnstreamizationPerform_ApplianceProperties(param1,param2,param3);
         this.UnstreamizationPerform_ApplianceByDatabase(param2,param3);
      }
      
      protected function UnstreamizationPerform_ApplianceProperties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TAppliance = null;
         _loc4_ = param2 as TAppliance;
      }
      
      protected function UnstreamizationPerform_AdditionalData_Appliance(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TAppliance = null;
         _loc4_ = param2 as TAppliance;
         _loc4_.Quantity = 1;
         _loc4_.TimingCategory = 3;
         _loc4_.TimingState = 4;
         _loc4_.TimingTime = 0;
      }
      
      protected function UnstreamizationPerform_ApplianceByDatabase(param1:Object, param2:Object) : void
      {
         var _loc3_:TArticle = null;
         var _loc4_:TAppliance = null;
         var _loc5_:Boolean = false;
         _loc4_ = param1 as TAppliance;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc4_.IDTemplate) as TArticle;
         _loc4_.Usable = _loc3_.ExpandUsable;
         _loc4_.StackableQuantityMax = _loc3_.OverlayNumber;
         if(_loc4_.StackableQuantityMax <= 1)
         {
            _loc5_ = false;
         }
         else
         {
            _loc5_ = true;
         }
         _loc4_.Stackable = _loc5_;
      }
      
      protected function UnstreamizationPerform_GenerateApplianceProperties(param1:ByteArray, param2:Object, param3:Object) : void
      {
      }
      
      override protected function UnstreamizationPerform_QuestReward(param1:ByteArray, param2:Object, param3:Object) : void
      {
         super.UnstreamizationPerform_QuestReward(param1,param2,param3);
         this.UnstreamizationPerform_QRApplianceProperties(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_QRApplianceProperties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TAppliance = null;
         _loc4_ = param2 as TAppliance;
      }
      
      public function UnstreamizeAdditionalDataAppliance(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_AdditionalData_Appliance(param1,param2,param3);
         super.UnstreamizationPerform_InventoryByDatabase(param2);
         this.UnstreamizationPerform_ApplianceByDatabase(param2,param3);
      }
      
      override public function UnstreamizeGenerateInventory(param1:ByteArray, param2:Object, param3:Object) : void
      {
         super.UnstreamizeGenerateInventory(param1,param2,param3);
         this.UnstreamizationPerform_GenerateApplianceProperties(param1,param2,param3);
         this.UnstreamizationPerform_ApplianceByDatabase(param2,param3);
      }
   }
}

