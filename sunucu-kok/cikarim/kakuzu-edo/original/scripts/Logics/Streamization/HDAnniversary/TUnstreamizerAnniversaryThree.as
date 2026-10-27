package Logics.Streamization.HDAnniversary
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDAnniversaryThree;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.TActivityServerRank;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDAnniversary.TAnniversaryThree;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.TUtilityTool;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   
   public class TUnstreamizerAnniversaryThree extends TUnstreamizer
   {
      
      public function TUnstreamizerAnniversaryThree()
      {
         super();
      }
      
      protected function ConfigHandle(param1:TAnniversaryThree) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventories = null;
         var _loc6_:TInventories = null;
         _loc3_ = 1;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TInventories();
            _loc4_ = uint(param1.Config.AwardInfo.awardid);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            param1.Bag = _loc5_;
            _loc6_ = new TInventories();
            SToolReward.GetInventoryByIDAmount(param1.Config.AwardInfo.score,param1.Config.AwardInfo.count,_loc6_);
            param1.Bag.Add(_loc6_.GetInventoryByIndex(0));
            _loc2_++;
         }
         _loc3_ = param1.Config.Mall.length;
         _loc5_ = new TInventories();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = uint(param1.Config.Mall[_loc2_].awardid);
            SToolReward.GetAwardsByAwardID(_loc4_,_loc5_);
            _loc2_++;
         }
         param1.MailInvs = _loc5_;
      }
      
      protected function Core(param1:uint, param2:Object, param3:TAnniversaryThree) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:THDAnniversaryThree = null;
         var _loc7_:uint = 0;
         _loc6_ = param3.Config;
         if(param1 == _loc6_.StartIndex)
         {
            param3.JoinStatus = TUtilityTool.ActState(param2);
         }
         else if(param1 == _loc6_.ScoreIndex)
         {
            param3.Score = TUtilityTool.ActState(param2);
         }
         else if(param1 == 10)
         {
            param3.Already = TUtilityTool.ActState(param2);
         }
         this.ShopResult(param1,param2,param3);
      }
      
      protected function ShopResult(param1:uint, param2:Object, param3:TAnniversaryThree) : void
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
               param3.MailStatus[_loc5_] = 0 - TUtilityTool.ActState(param2);
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
         var _loc8_:TAnniversaryThree = null;
         var _loc9_:THDAnniversaryThree = null;
         _loc8_ = param2 as TAnniversaryThree;
         _loc9_ = param3 as THDAnniversaryThree;
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
         _loc8_.RankVec.length = 0;
         if(param1.AddtionalVecs.length > 0)
         {
            _loc7_ = param1.AddtionalVecs[0].length;
            _loc4_ = 0;
            while(_loc4_ < _loc7_)
            {
               _loc8_.RankVec.push(param1.AddtionalVecs[0][_loc4_] as TActivityServerRank);
               _loc4_++;
            }
         }
      }
      
      public function UnstreamizeUpdateActivity(param1:TActAwardStatusInfo, param2:TActivityOSBase, param3:THDActivityBase) : void
      {
         var _loc4_:TAnniversaryThree = null;
         var _loc5_:THDAnniversaryThree = null;
         _loc4_ = param2 as TAnniversaryThree;
         _loc5_ = param3 as THDAnniversaryThree;
         if(param1.Index == _loc5_.ScoreIndex && param1.Status - _loc4_.Score > 0)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Integral) + "*" + (param1.Status - _loc4_.Score));
         }
         this.Core(param1.Index,param1,_loc4_);
      }
   }
}

