package Processors.Game.Lobby.Activity.HDLuckyJoy.Decoder
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.THDLuckyJoy;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import Logics.HDLuckyJoy.TActivityLuckyJoyData;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerActivityLuckyJoy extends TUnstreamizer
   {
      
      public function TUnstreamizerActivityLuckyJoy()
      {
         super();
      }
      
      public function CoreConfigValue(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityLuckyJoyData = null;
         var _loc5_:THDLuckyJoy = null;
         var _loc6_:TInventories = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc4_ = param2 as TActivityLuckyJoyData;
         _loc5_ = param3 as THDLuckyJoy;
         _loc4_.LotteryIndex = _loc5_.LotteryIndex;
         _loc4_.LotteryCost = _loc5_.LotteryCost;
         _loc4_.LotteryCount = _loc5_.LotteryCount;
         _loc4_.SeqIDs = _loc5_.SeqIDs;
         _loc4_.Awards = _loc5_.Awards;
         _loc4_.RateType = _loc5_.RateType;
         _loc4_.ScoreExchangeIndexs = _loc5_.ScoreExchangeIndexs;
         _loc4_.ScoreExchangeCosts = _loc5_.ScoreExchangeCosts;
         _loc4_.ScoreExchangeAwards = _loc5_.ScoreExchangeAwards;
         _loc4_.ScoreIndex = _loc5_.ScoreIndex;
         _loc4_.FreeTimeIndex = _loc5_.FreeTimeIndex;
         _loc4_.FreeTimeEveryDay = _loc5_.FreeTimeEveryDay;
         _loc4_.RollResultIndex = _loc5_.RollResultIndex;
         _loc4_.AwardInventories.length = 0;
         _loc8_ = int(_loc4_.Awards.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc6_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc4_.Awards[_loc7_],_loc6_);
            _loc4_.AwardInventories.push(_loc6_);
            _loc7_++;
         }
         _loc4_.ExchangeInventories.length = 0;
         _loc8_ = int(_loc4_.ScoreExchangeAwards.length);
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc6_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc4_.ScoreExchangeAwards[_loc7_],_loc6_);
            _loc4_.ExchangeInventories.push(_loc6_);
            _loc7_++;
         }
      }
      
      public function UnstreamizationPerform_InitData(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityLuckyJoyData = null;
         var _loc5_:TActivityInitRetData = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Vector.<THDBoxStateData> = null;
         var _loc9_:THDBoxStateData = null;
         _loc4_ = param2 as TActivityLuckyJoyData;
         _loc5_ = param3 as TActivityInitRetData;
         _loc7_ = int(_loc5_.AllBox.length);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc9_ = _loc5_.AllBox[_loc6_];
            this.FillBoxState(_loc9_.BoxIndex,_loc9_.State,_loc4_);
            _loc6_++;
         }
      }
      
      public function FillBoxState(param1:int, param2:int, param3:TActivityLuckyJoyData) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 == param3.ScoreIndex)
         {
            param3.CurrentScore = param2;
            return;
         }
         if(param1 == param3.FreeTimeIndex)
         {
            param3.UsedFreeTime = param2;
            return;
         }
         if(param1 == param3.RollResultIndex)
         {
            param3.RollResultSeqID = param2;
            return;
         }
      }
   }
}

