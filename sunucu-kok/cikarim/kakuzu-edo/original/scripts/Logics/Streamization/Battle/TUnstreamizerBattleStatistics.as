package Logics.Streamization.Battle
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.Battle.model.TStatisticsInfo;
   import Logics.Battle.model.TStatisticsVO;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerBattleStatistics extends TUnstreamizer
   {
      
      public function TUnstreamizerBattleStatistics()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TStatisticsInfo = null;
         var _loc7_:TStatisticsVO = null;
         _loc6_ = param2 as TStatisticsInfo;
         _loc5_ = param1.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = new TStatisticsVO();
            _loc7_.HeroId = param1.readUnsignedInt();
            _loc7_.Hurt = param1.readUnsignedInt();
            _loc7_.RemainHp = param1.readFloat();
            _loc6_.MyInfoVec.push(_loc7_);
            _loc4_++;
         }
         _loc5_ = param1.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = new TStatisticsVO();
            _loc7_.HeroId = param1.readUnsignedInt();
            _loc7_.Hurt = param1.readUnsignedInt();
            _loc7_.RemainHp = param1.readFloat();
            _loc6_.EnemyInfoVec.push(_loc7_);
            _loc4_++;
         }
      }
   }
}

