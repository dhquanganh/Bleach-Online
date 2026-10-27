package Logics.Streamization.HDLottery
{
   import Logics.DatebaseVO.VO.THDLottery;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.TActivityServerRank;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDLottery.TActivityLottery;
   
   public class TUnstreamizerLottery
   {
      
      public function TUnstreamizerLottery()
      {
         super();
      }
      
      protected function UnstreamizationPerform_UpdateLottery(param1:Object, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TActivityLottery = null;
         var _loc7_:TActivityInitRetData = null;
         var _loc8_:THDLottery = null;
         var _loc9_:Vector.<THDBoxStateData> = null;
         var _loc10_:Vector.<THDBoxStateData> = null;
         var _loc11_:Vector.<THDBoxStateData> = null;
         var _loc12_:Vector.<Object> = null;
         var _loc13_:TActivityServerRank = null;
         _loc7_ = param1 as TActivityInitRetData;
         _loc6_ = param2 as TActivityLottery;
         _loc8_ = param3 as THDLottery;
         _loc6_.ListCodes.length = 0;
         _loc6_.LastNames.length = 0;
         _loc6_.LastCodes.length = 0;
         _loc6_.LastGetMoneys.length = 0;
         if(_loc7_.ParameterVec.length != 0)
         {
            _loc6_.CurPrize = _loc7_.ParameterVec[0];
         }
         if(_loc7_.ShowOnlyStates.length != 0)
         {
            _loc6_.CurScore = _loc7_.ShowOnlyStates[_loc7_.ShowOnlyStates.length - 1].State;
            _loc5_ = _loc7_.ShowOnlyStates.length - 1;
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc6_.ListCodes[_loc4_] = _loc7_.ShowOnlyStates[_loc4_].State;
               _loc4_++;
            }
         }
         _loc5_ = _loc7_.AddAddtional.length;
         if(_loc5_ != 0)
         {
            _loc12_ = _loc7_.AddtionalVecs[0];
            _loc5_ = int(_loc12_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc13_ = _loc12_[_loc4_] as TActivityServerRank;
               _loc6_.LastNames.push(_loc13_.Name);
               _loc6_.LastGetMoneys.push(_loc13_.Value);
               _loc6_.LastCodes.push(_loc13_.ServerID);
               _loc4_++;
            }
         }
      }
      
      public function UnstreamizeUpdateLottery(param1:Object, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_UpdateLottery(param1,param2,param3);
      }
   }
}

