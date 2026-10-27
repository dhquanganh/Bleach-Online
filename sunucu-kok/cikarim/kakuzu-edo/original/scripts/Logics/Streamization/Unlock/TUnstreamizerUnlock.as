package Logics.Streamization.Unlock
{
   import Logics.DatebaseVO.VO.TFunctionSwitch;
   import Logics.Spaces.LogicsSpace;
   import Logics.Unlocks.TUnlock;
   import flash.utils.ByteArray;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerUnlock extends TUnstreamizerUnlockUnknown
   {
      
      public function TUnstreamizerUnlock()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerformUnlockByDatabase(param1,param2,param3);
      }
      
      protected function UnstreamizationPerformUnlockByDatabase(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TUnlock = null;
         var _loc5_:TFunctionSwitch = null;
         _loc4_ = param2 as TUnlock;
         _loc5_ = param3 as TFunctionSwitch;
         _loc4_.Name = _loc5_.Name;
         _loc4_.Position = _loc5_.Position;
         _loc4_.Index = _loc5_.Index;
         _loc4_.CombineType = _loc5_.CombineType;
         _loc4_.ConditiontType = _loc5_.ConditionType;
         _loc4_.ConditiontValue = _loc5_.ConditiontValue;
         _loc4_.Desc = _loc5_.Desc;
         if(!_loc5_.IsOpen)
         {
            _loc4_.UnlockState = TUnlock.UNLOCKSTATE_ForcedOff;
         }
      }
   }
}

