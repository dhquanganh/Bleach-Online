package Logics.Streamization.Battle
{
   import Foundation.Streamization.*;
   import Logics.Battle.model.*;
   import Resources.Constants.CONST_BATTLE;
   import flash.utils.*;
   
   public class TUnstreamizerActiveInfo extends TUnstreamizer
   {
      
      private var FUnstreamizerTargetInfo:TUnstreamizerTargetInfo;
      
      public function TUnstreamizerActiveInfo()
      {
         super();
         this.FUnstreamizerTargetInfo = new TUnstreamizerTargetInfo();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TActiveInfo = null;
         var _loc6_:TTargetInfo = null;
         var _loc7_:uint = 0;
         _loc5_ = param2 as TActiveInfo;
         _loc5_.ActiveCamp = param1.readByte();
         _loc5_.ActivePos = param1.readByte();
         _loc5_.SkillEffectId = param1.readInt();
         _loc5_.ActiveType = param1.readInt();
         if(_loc5_.ActiveType == CONST_BATTLE.Active_NormalAttackEX)
         {
            _loc5_.ActiveType = CONST_BATTLE.Active_NormalAttack;
         }
         if(_loc5_.ActiveType != CONST_BATTLE.Active_NormalAttack && _loc5_.ActiveType != CONST_BATTLE.Active_SkillAttack)
         {
            _loc5_.SkillEffectId = 0;
         }
         _loc7_ = uint(param1.readShort());
         _loc5_.TargetCount = _loc7_;
         _loc4_ = 0;
         while(_loc4_ < _loc7_)
         {
            _loc6_ = new TTargetInfo(_loc4_);
            this.FUnstreamizerTargetInfo.Unstreamize(param1,_loc6_,param3);
            _loc5_.TargetInfos[_loc4_] = _loc6_;
            _loc4_++;
         }
      }
   }
}

