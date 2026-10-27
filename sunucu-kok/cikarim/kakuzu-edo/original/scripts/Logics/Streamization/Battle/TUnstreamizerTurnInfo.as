package Logics.Streamization.Battle
{
   import Foundation.Streamization.*;
   import Logics.Battle.model.*;
   import flash.utils.*;
   
   public class TUnstreamizerTurnInfo extends TUnstreamizer
   {
      
      private var FUnstreamizerActiveInfo:TUnstreamizerActiveInfo;
      
      public function TUnstreamizerTurnInfo()
      {
         super();
         this.FUnstreamizerActiveInfo = new TUnstreamizerActiveInfo();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TTurnInfo = null;
         var _loc6_:TActiveInfo = null;
         var _loc7_:uint = 0;
         _loc5_ = param2 as TTurnInfo;
         _loc5_.CurTurn = param1.readInt();
         _loc7_ = uint(param1.readShort());
         _loc5_.ActiveCount = _loc7_;
         _loc4_ = 0;
         while(_loc4_ < _loc7_)
         {
            _loc6_ = new TActiveInfo(_loc4_);
            this.FUnstreamizerActiveInfo.Unstreamize(param1,_loc6_,param3);
            _loc5_.ActiveInfos[_loc4_] = _loc6_;
            _loc4_++;
         }
      }
   }
}

