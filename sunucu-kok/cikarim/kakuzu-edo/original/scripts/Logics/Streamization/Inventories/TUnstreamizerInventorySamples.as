package Logics.Streamization.Inventories
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TMall;
   import Logics.Inventories.TInventorySample;
   import Logics.Inventories.TInventorySamples;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_MALL;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerInventorySamples extends TUnstreamizerInventories
   {
      
      protected var FUnstreamizerInventorySample:TUnstreamizerInventorySample;
      
      public function TUnstreamizerInventorySamples()
      {
         super();
         this.FUnstreamizerInventorySample = new TUnstreamizerInventorySample();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Inventories(param1,param2,param3);
      }
      
      override protected function UnstreamizationPerform_Inventories(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBins = null;
         var _loc7_:TMall = null;
         var _loc8_:TInventorySamples = null;
         var _loc9_:TInventorySample = null;
         _loc8_ = param2 as TInventorySamples;
         _loc8_.Clear();
         _loc6_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Mall);
         _loc4_ = _loc6_.Count;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = _loc6_.GetDatebaseByIndex(_loc5_) as TMall;
            if(_loc7_.Model == CONST_MALL.TYPE_MODEL_SIGN || _loc7_.Model == CONST_MALL.TYPE_MODEL_MALL || _loc7_.Model == CONST_MALL.TYPE_MODEL_TOKENSHOP || _loc7_.Model == CONST_MALL.TYPE_MODEL_STONESHOP || _loc7_.Model == CONST_MALL.TYPE_MODEL_VIPSHOP)
            {
               _loc9_ = FPoolInventory.AcquireInventorySample();
               this.FUnstreamizerInventorySample.UnstreamizeInventorySampleByDatabase(null,_loc9_,_loc7_);
               _loc8_.Add(_loc9_);
            }
            _loc5_++;
         }
      }
   }
}

