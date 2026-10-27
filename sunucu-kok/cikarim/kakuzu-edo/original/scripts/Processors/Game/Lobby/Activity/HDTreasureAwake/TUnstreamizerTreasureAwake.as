package Processors.Game.Lobby.Activity.HDTreasureAwake
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityTreasureAwake.TActivityTreasureAwakeData;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerTreasureAwake extends TUnstreamizer
   {
      
      public function TUnstreamizerTreasureAwake()
      {
         super();
      }
      
      public function UnstreamizationPerform_InitData(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityTreasureAwakeData = null;
         var _loc5_:TActivityInitRetData = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc4_ = param2 as TActivityTreasureAwakeData;
         _loc5_ = param3 as TActivityInitRetData;
         _loc4_.BuyTimes.length = 0;
         _loc7_ = int(_loc5_.ParameterVec.length);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc4_.BuyTimes.push(_loc5_.ParameterVec[_loc6_]);
            _loc6_++;
         }
      }
   }
}

