package Logics.Streamization.Unlock
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TFunctionSwitch;
   import Logics.Spaces.LogicsSpace;
   import Logics.Unlocks.TUnlock;
   import Logics.Unlocks.TUnlocks;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerUnlocks extends TUnstreamizerUnlockUnknown
   {
      
      protected var FUnstreamizerUnlock:TUnstreamizerUnlock;
      
      public function TUnstreamizerUnlocks()
      {
         super();
         this.FUnstreamizerUnlock = new TUnstreamizerUnlock();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Unlocks(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Unlocks(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:TUnlock = null;
         var _loc8_:TUnlocks = null;
         var _loc9_:TBins = null;
         var _loc10_:TFunctionSwitch = null;
         _loc8_ = param2 as TUnlocks;
         _loc8_.Clear();
         _loc9_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_FunctionSwitch);
         _loc5_ = _loc9_.Count;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc10_ = _loc9_.GetDatebaseByIndex(_loc4_) as TFunctionSwitch;
            _loc7_ = new TUnlock(_loc10_.Identifier);
            this.FUnstreamizerUnlock.Unstreamize(param1,_loc7_,_loc10_);
            _loc8_.Add(_loc7_);
            _loc4_++;
         }
      }
   }
}

