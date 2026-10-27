package Logics.Streamization.HDEaster2016
{
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDEaster2016_1;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDEaster2016.THDEasterData2016_1;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerEaster2016_1 extends TUnstreamizer
   {
      
      public function TUnstreamizerEaster2016_1()
      {
         super();
      }
      
      protected function ConfigHandle(param1:THDEasterData2016_1) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc3_ = param1.Config.RechargeGift.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.RechargeGift[_loc2_].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.RechargeAwards[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc3_ = param1.Config.ConsumeGift.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.ConsumeGift[_loc2_].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.ConsunmeAwards[_loc2_] = _loc5_;
            _loc2_++;
         }
      }
      
      protected function Core(param1:uint, param2:Object, param3:THDEasterData2016_1) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDEaster2016_1 = null;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.PageIndex)
         {
            param3.Round = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.ConsumeIndex)
         {
            param3.Consumed = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Egg01Index)
         {
            param3.HaveEgg01 = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Egg02Index)
         {
            param3.HaveEgg02 = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Egg03Index)
         {
            param3.HaveEgg03 = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.BigAward.index)
         {
            param3.JackPointStatus = TUtilityTool.ActState(param2);
         }
         _loc6_ = _loc7_.RechargeTask.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.RechargeTask[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.RechargeTaskStatus[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
         _loc6_ = _loc7_.ConsumeTask.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.ConsumeTask[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.ConsumeTaskStatus[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
         _loc6_ = _loc7_.RechargeGift.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.RechargeGift[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.RechargeGiftStatus[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
         _loc6_ = _loc7_.ConsumeGift.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = _loc7_.ConsumeGift[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.ConsumeGiftStatus[_loc5_] = TUtilityTool.ActState(param2);
            }
            _loc5_++;
         }
      }
      
      public function UnstreamizeInitActivity(param1:TActivityInitRetData, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDBoxStateData = null;
         var _loc7_:uint = 0;
         var _loc8_:THDEasterData2016_1 = null;
         var _loc9_:THDEaster2016_1 = null;
         _loc8_ = param2 as THDEasterData2016_1;
         _loc9_ = param3 as THDEaster2016_1;
         if(_loc8_.Config == null)
         {
            _loc8_.Config = _loc9_;
            this.ConfigHandle(_loc8_);
         }
         _loc5_ = param1.AllBox.length;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = param1.AllBox[_loc4_];
            this.Core(_loc6_.BoxIndex,_loc6_,_loc8_);
            _loc4_++;
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:THDEasterData2016_1 = null;
         var _loc5_:THDEaster2016_1 = null;
         _loc4_ = param2 as THDEasterData2016_1;
         _loc5_ = param3 as THDEaster2016_1;
         if(param1.Index == _loc5_.Egg02Index)
         {
            if(param1.Status - _loc4_.HaveEgg02 > 0)
            {
               SToolReward.ShowMessage(TUtilityString.Format(_loc5_.Text[3],param1.Status - _loc4_.HaveEgg02));
            }
         }
         if(param1.Index == _loc5_.Egg03Index)
         {
            if(param1.Status - _loc4_.HaveEgg03 > 0)
            {
               SToolReward.ShowMessage(TUtilityString.Format(_loc5_.Text[4],param1.Status - _loc4_.HaveEgg03));
            }
         }
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

