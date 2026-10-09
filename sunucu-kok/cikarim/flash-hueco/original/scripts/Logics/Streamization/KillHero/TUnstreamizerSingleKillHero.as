package Logics.Streamization.KillHero
{
   import Foundation.Resources.Repositories.TResourceRepositoryBin;
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.TRaidersDailyConfig;
   import Logics.KillHero.TSingleKillHero;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerSingleKillHero extends TUnstreamizer
   {
      
      public function TUnstreamizerSingleKillHero()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TSingleKillHero = null;
         var _loc5_:TResourceRepositoryBin = null;
         var _loc6_:TRaidersDailyConfig = null;
         _loc4_ = param2 as TSingleKillHero;
         _loc5_ = param3 as TResourceRepositoryBin;
         _loc4_.EnterCount = param1.readByte();
         _loc4_.ResetCount = param1.readByte();
         _loc4_.IsPassed = true;
         _loc6_ = _loc5_.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RaidersDailyConfig,_loc4_.KillHeroId) as TRaidersDailyConfig;
         _loc4_.HeroIds = _loc6_.HeroVect;
      }
   }
}

