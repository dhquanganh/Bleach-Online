package Logics.Streamization.TraitorAttack
{
   import Foundation.Streamization.*;
   import Foundation.Timing.STimingCore;
   import Foundation.Utilities.TUtilityString;
   import Logics.Spaces.*;
   import Logics.TraitorAttack.*;
   import flash.utils.*;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerTraitorAttack extends TUnstreamizer
   {
      
      protected static var FPoolTraitorAttack:TPoolTraitorAttack;
      
      public function TUnstreamizerTraitorAttack()
      {
         super();
      }
      
      LogicsSpace static function PoolsSetup(param1:TPoolTraitorAttack) : void
      {
         FPoolTraitorAttack = param1;
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TTraitorAttackData = null;
         _loc4_ = param2 as TTraitorAttackData;
         _loc4_.CDTime = param1.readUnsignedInt();
         _loc4_.EndTime = param1.readUnsignedInt() + STimingCore.ServerTick;
         _loc4_.CurWave = param1.readUnsignedInt();
         _loc4_.ResurrectionTimes = param1.readUnsignedInt();
      }
      
      protected function UnstreamizeTraitorAttack_MonsterInfo(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TTraitorAttackData = null;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         _loc6_ = param2 as TTraitorAttackData;
         _loc5_ = uint(param1.readShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = param1.readUnsignedInt();
            _loc8_ = param1.readUnsignedInt();
            _loc6_.MonsterList[_loc7_] = _loc8_;
            _loc4_++;
         }
      }
      
      protected function UnstreamizeTraitorAttack_RankUpdate(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TTraitorAttackRankHero = null;
         var _loc7_:TTraitorAttackRankHeros = null;
         _loc7_ = param2 as TTraitorAttackRankHeros;
         _loc7_.MySelfHarm.High = param1.readUnsignedInt();
         _loc7_.MySelfHarm.Low = param1.readUnsignedInt();
         _loc7_.TotleHarm.High = param1.readUnsignedInt();
         _loc7_.TotleHarm.Low = param1.readUnsignedInt();
         _loc7_.Clear();
         _loc5_ = uint(param1.readShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = FPoolTraitorAttack.AcquireRankHero();
            _loc6_.HeroName = TUtilityString.FetchUTF(param1);
            _loc6_.HeroHarm.High = param1.readUnsignedInt();
            _loc6_.HeroHarm.Low = param1.readUnsignedInt();
            _loc7_.Add(_loc6_);
            _loc4_++;
         }
      }
      
      protected function UnstreamizeTraitorAttack_ScoreUpdate(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TTraitorAttackData = null;
         _loc6_ = param2 as TTraitorAttackData;
         _loc5_ = 3;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.ScoreList[_loc4_] = param1.readUnsignedInt();
            _loc4_++;
         }
      }
      
      public function UnstreamizeTraitorAttackMonsterInfo(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizeTraitorAttack_MonsterInfo(param1,param2,param3);
      }
      
      public function UnstreamizeTraitorAttackRankUpdate(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizeTraitorAttack_RankUpdate(param1,param2,param3);
      }
      
      public function UnstreamizeTraitorAttackScoreUpdate(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizeTraitorAttack_ScoreUpdate(param1,param2,param3);
      }
   }
}

