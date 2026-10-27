package Logics.Streamization.HDLaborDay2016
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDLaborConsume;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDLaborDay2016.TLaborConsume;
   import Processors.Game.Utilities.Common.TUtilityTool;
   
   public class TUnstreamizerLaborConsume extends TUnstreamizer
   {
      
      public function TUnstreamizerLaborConsume()
      {
         super();
      }
      
      protected function Core(param1:uint, param2:Object, param3:TLaborConsume) : void
      {
         if(this.DisposeScoreShop(param1,param2,param3))
         {
            return;
         }
         if(this.DisposeBannerIndex(param1,param2,param3))
         {
            return;
         }
         switch(param1)
         {
            case param3.Config.Score:
               param3.Score = TUtilityTool.ActState(param2);
               break;
            case param3.Config.Refresh:
               param3.RefreshCount = TUtilityTool.ActState(param2);
               break;
            case param3.Config.Bag.index:
               param3.ShowState = TUtilityTool.ActState(param2);
         }
      }
      
      protected function DisposeScoreShop(param1:uint, param2:Object, param3:TLaborConsume) : Boolean
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         _loc5_ = 0;
         for each(_loc4_ in param3.Config.Mall)
         {
            if(param1 == _loc4_.index)
            {
               param3.StoreState[_loc5_] = TUtilityTool.ActState(param2);
               return true;
            }
            _loc5_++;
         }
         return false;
      }
      
      protected function DisposeBannerIndex(param1:uint, param2:Object, param3:TLaborConsume) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = param3.Config.BannerIndex.indexOf(param1);
         if(_loc4_ != -1)
         {
            param3.GiftInfo[_loc4_] = TUtilityTool.ActState(param2);
            return true;
         }
         return false;
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:TLaborConsume = null;
         var _loc8_:THDLaborConsume = null;
         _loc7_ = param2 as TLaborConsume;
         _loc8_ = param3 as THDLaborConsume;
         _loc7_.Config = _loc8_;
         _loc5_ = param1.AllBox.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.AllBox[_loc4_];
            this.Core(_loc6_.BoxIndex,_loc6_,_loc7_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TLaborConsume = null;
         _loc4_ = param2 as TLaborConsume;
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

