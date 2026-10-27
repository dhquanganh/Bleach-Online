package Logics.Streamization.HDDuanwujie
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDDuanwujieBoat;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDDuanwujie.TDuanwujieBoat;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TUnstreamizerDuanwujieBoat extends TUnstreamizer
   {
      
      public function TUnstreamizerDuanwujieBoat()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TDuanwujieBoat) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         _loc3_ = 4;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.CheerAwards[_loc2_].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.ShowAwards = _loc5_;
         _loc3_ = uint(param1.Config.Evaluation.awardIds.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.Evaluation.awardIds[_loc2_]);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.BoatAwards[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc3_ = param1.Config.Mall.length;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.Mall[_loc2_].awardId);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.MailInvs = _loc5_;
      }
      
      protected function Core(param1:uint, param2:Object, param3:TDuanwujieBoat) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDDuanwujieBoat = null;
         var _loc8_:uint = 0;
         _loc7_ = param3.Config;
         if(param1 == _loc7_.GameCount.index)
         {
            param3.GameCount = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Score)
         {
            param3.Score = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Morale.index)
         {
            param3.Morale = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Over.index)
         {
            param3.TimeEnd = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Start)
         {
            param3.Buffs = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Evaluation.index)
         {
            param3.Evaluation = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.Cheer.index)
         {
            param3.Level = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc7_.BigAward.index)
         {
            param3.LastBigAward = TUtilityTool.ActState(param2);
         }
         this.ShopResult(param1,param2,param3);
      }
      
      protected function ShopResult(param1:uint, param2:Object, param3:TDuanwujieBoat) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc6_ = param3.Config.Mall.length;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc4_ = param3.Config.Mall[_loc5_];
            if(_loc4_.index == param1)
            {
               param3.MailStatus[_loc5_] = TUtilityTool.ActState(param2);
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
         var _loc8_:TDuanwujieBoat = null;
         var _loc9_:THDDuanwujieBoat = null;
         _loc8_ = param2 as TDuanwujieBoat;
         _loc9_ = param3 as THDDuanwujieBoat;
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
         var _loc4_:TDuanwujieBoat = null;
         var _loc5_:THDDuanwujieBoat = null;
         _loc4_ = param2 as TDuanwujieBoat;
         _loc5_ = param3 as THDDuanwujieBoat;
         if(param1.Index == _loc5_.Score && param1.Status - _loc4_.Score > 0)
         {
            SToolReward.ShowMessage(_loc5_.Texts[1] + ":" + (param1.Status - _loc4_.Score));
         }
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

