package Logics.Streamization.HDKnifeHeroCollect
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDKnifeHeroCollect;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDKnifeHeroCollect.TKnifeHeroCollectData;
   
   public class TUnstreamizerKnifeHeroCollect extends TUnstreamizer
   {
      
      public function TUnstreamizerKnifeHeroCollect()
      {
         super();
      }
      
      protected function Core(param1:uint, param2:int, param3:TKnifeHeroCollectData) : void
      {
         if(param1 == param3.Config.ConsumeGoldIndex)
         {
            param3.CurConsumeGold = param2;
         }
         else if(param1 == param3.Config.RechargeGoldIndex)
         {
            param3.CurRechargeGold = param2;
         }
         else if(!this.UpdateState(param3.Config.ConsumeGold,param3.ConsumeGoldState,param1,param2))
         {
            this.UpdateState(param3.Config.RechargeGold,param3.RechargeGoldState,param1,param2);
         }
      }
      
      protected function UpdateState(param1:Vector.<Object>, param2:Array, param3:uint, param4:int) : Boolean
      {
         var _loc5_:Object = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc7_ = param1.length;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc5_ = param1[_loc6_];
            if(_loc5_.index == param3)
            {
               param2[_loc6_] = param4;
               return true;
            }
            _loc6_++;
         }
         return false;
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TKnifeHeroCollectData = null;
         var _loc8_:THDKnifeHeroCollect = null;
         _loc7_ = param2 as TKnifeHeroCollectData;
         _loc8_ = param3 as THDKnifeHeroCollect;
         _loc7_.Config = _loc8_;
         _loc5_ = param1.AllBox.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.AllBox[_loc4_];
            this.Core(_loc6_.BoxIndex,_loc6_.State,_loc7_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TKnifeHeroCollectData = null;
         _loc4_ = param2 as TKnifeHeroCollectData;
         this.Core(param1.Index,param1.Status,_loc4_);
      }
   }
}

