package Logics.Streamization.KillHero
{
   import Foundation.Resources.Repositories.*;
   import Foundation.Streamization.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Items.*;
   import Logics.KillHero.*;
   import Logics.SLogicsCore;
   import Logics.Streamization.Items.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TUnstreamizerKillHero extends TUnstreamizer
   {
      
      private var FUnstreamizerReward:TUnstreamizerRewards;
      
      private var FUnstreamizerSingleKillHero:TUnstreamizerSingleKillHero;
      
      public function TUnstreamizerKillHero()
      {
         super();
         this.FUnstreamizerReward = new TUnstreamizerRewards();
         this.FUnstreamizerSingleKillHero = new TUnstreamizerSingleKillHero();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TSingleKillHero = null;
         var _loc6_:TResourceRepositoryBin = null;
         var _loc7_:TKillHero = null;
         var _loc8_:uint = 0;
         var _loc9_:TConfigValue = null;
         var _loc10_:TRaidersDailyConfig = null;
         var _loc11_:TRaidersDailyConfig = null;
         var _loc12_:uint = 0;
         var _loc13_:int = 0;
         _loc7_ = param2 as TKillHero;
         _loc6_ = param3 as TResourceRepositoryBin;
         _loc9_ = _loc6_.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.KILL_RESET_ACTION) as TConfigValue;
         _loc7_.NeedMilitaryOrder = _loc9_.Value as int;
         _loc9_ = _loc6_.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.KILL_RAIDERS_FIRST_ID) as TConfigValue;
         _loc12_ = (_loc9_.Value as int) - 1;
         _loc8_ = uint(param1.readShort());
         _loc4_ = 0;
         while(_loc4_ < _loc8_)
         {
            _loc13_ = int(param1.readUnsignedInt());
            _loc5_ = new TSingleKillHero(_loc13_);
            this.FUnstreamizerSingleKillHero.Unstreamize(param1,_loc5_,param3);
            _loc7_.KillHeroInfo[_loc4_] = _loc5_;
            _loc12_ = Math.max(_loc12_,_loc13_);
            _loc4_++;
         }
         _loc10_ = _loc6_.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RaidersDailyConfig,_loc12_) as TRaidersDailyConfig;
         if(_loc10_ == null)
         {
            _loc7_.CurHeroId = _loc12_ + 1;
            _loc5_ = new TSingleKillHero(_loc12_ + 1);
            _loc5_.EnterCount = 0;
            _loc5_.ResetCount = 0;
            _loc5_.IsPassed = false;
            _loc10_ = _loc6_.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RaidersDailyConfig,_loc5_.KillHeroId) as TRaidersDailyConfig;
            _loc5_.HeroIds = _loc10_.HeroVect;
            _loc7_.KillHeroInfo[0] = _loc5_;
            _loc4_++;
         }
         else if(_loc10_.NextHard != 0)
         {
            _loc11_ = _loc6_.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RaidersDailyConfig,_loc10_.NextHard) as TRaidersDailyConfig;
            if(SLogicsCore.Character.GetMainLevel() >= _loc11_.Level)
            {
               _loc7_.CurHeroId = _loc10_.NextHard;
            }
            else
            {
               _loc7_.CurHeroId = _loc12_;
            }
         }
         else
         {
            _loc7_.CurHeroId = _loc12_;
         }
         while(_loc10_.NextHard != 0)
         {
            _loc5_ = new TSingleKillHero(_loc10_.NextHard);
            _loc5_.EnterCount = 0;
            _loc5_.ResetCount = 0;
            _loc5_.IsPassed = false;
            _loc10_ = _loc6_.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RaidersDailyConfig,_loc5_.KillHeroId) as TRaidersDailyConfig;
            _loc5_.HeroIds = _loc10_.HeroVect;
            _loc7_.KillHeroInfo[_loc4_] = _loc5_;
            _loc4_++;
         }
         _loc8_ = uint(param1.readShort());
         _loc4_ = 0;
         while(_loc4_ < _loc8_)
         {
            _loc13_ = int(param1.readUnsignedInt());
            _loc5_ = _loc7_.GetSingleKillHeroById(_loc13_);
            _loc5_.FirstId = TUtilityString.FetchUTF(param1);
            _loc5_.FirstName = TUtilityString.FetchUTF(param1);
            _loc5_.BestId = TUtilityString.FetchUTF(param1);
            _loc5_.BestName = TUtilityString.FetchUTF(param1);
            _loc4_++;
         }
         _loc7_.IsInit = true;
      }
      
      protected function Unstreamization_Notify(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TSingleKillHero = null;
         var _loc7_:TKillHero = null;
         var _loc8_:TResourceRepositoryBin = null;
         var _loc9_:uint = 0;
         _loc7_ = param2 as TKillHero;
         _loc8_ = param3 as TResourceRepositoryBin;
         _loc5_ = param1.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc9_ = param1.readUnsignedInt();
            _loc6_ = _loc7_.GetSingleKillHeroById(_loc9_);
            if(_loc6_ == null)
            {
               _loc6_ = new TSingleKillHero(_loc9_);
            }
            _loc6_.EnterCount = param1.readByte();
            _loc6_.ResetCount = param1.readByte();
            _loc6_.IsPassed = true;
            _loc7_.KillHeroInfo[_loc4_] = _loc6_;
            _loc4_++;
         }
      }
      
      protected function Unstreamization_BestFirstNotify(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TSingleKillHero = null;
         var _loc5_:uint = 0;
         var _loc6_:TKillHero = null;
         var _loc7_:uint = 0;
         _loc6_ = param2 as TKillHero;
         _loc5_ = param1.readUnsignedInt();
         _loc7_ = param1.readUnsignedInt();
         _loc4_ = _loc6_.GetSingleKillHeroById(_loc7_);
         if(_loc4_ == null)
         {
            return;
         }
         if(_loc5_ == 2001)
         {
            _loc4_.BestId = TUtilityString.FetchUTF(param1);
            _loc4_.BestName = TUtilityString.FetchUTF(param1);
         }
         else if(_loc5_ == 2000)
         {
            _loc4_.FirstId = TUtilityString.FetchUTF(param1);
            _loc4_.FirstName = TUtilityString.FetchUTF(param1);
         }
      }
      
      public function UnstreamizationNotify(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.Unstreamization_Notify(param1,param2,param3);
      }
      
      public function UnstreamizationBestFirstNotify(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.Unstreamization_BestFirstNotify(param1,param2,param3);
      }
   }
}

