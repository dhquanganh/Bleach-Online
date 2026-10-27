package Logics.Streamization.Battle
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.Battle.model.TResultInfo;
   import Logics.Battle.model.TTargetInfo;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerResultInfo extends TUnstreamizer
   {
      
      public function TUnstreamizerResultInfo()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TResultInfo = null;
         var _loc5_:int = 0;
         _loc4_ = param2 as TResultInfo;
         _loc5_ = param3 as int;
         _loc4_.CMD = _loc5_;
         if(_loc5_ == TTargetInfo.CMD_ATTACK || _loc5_ == TTargetInfo.CMD_ATTACKEX)
         {
            _loc4_.HurtHp = param1.readInt();
            _loc4_.HurtAnger = param1.readInt();
         }
         else if(_loc5_ == TTargetInfo.CMD_HURTBUFF)
         {
            _loc4_.HurtHp = param1.readInt();
            _loc4_.HurtAnger = param1.readInt();
            _loc4_.BuffId = param1.readUnsignedInt();
         }
         else if(_loc5_ == TTargetInfo.CMD_CONTROLBUFF || _loc5_ == TTargetInfo.CMD_ATTRBUFF || _loc5_ == TTargetInfo.CMD_SHIELD)
         {
            _loc4_.BuffId = param1.readUnsignedInt();
            _loc4_.BuffTurn = param1.readUnsignedInt();
         }
         else if(_loc5_ == TTargetInfo.CMD_POSITION)
         {
            _loc4_.BuffId = param1.readUnsignedInt();
            _loc4_.BuffTurn = param1.readUnsignedInt();
         }
         else if(_loc5_ == TTargetInfo.CMD_FLOAT)
         {
            _loc4_.BuffId = param1.readUnsignedInt();
            _loc4_.BuffTurn = param1.readUnsignedInt();
         }
         else if(_loc5_ != TTargetInfo.CMD_STATUS)
         {
            if(_loc5_ == TTargetInfo.CMD_NONE)
            {
            }
         }
      }
   }
}

