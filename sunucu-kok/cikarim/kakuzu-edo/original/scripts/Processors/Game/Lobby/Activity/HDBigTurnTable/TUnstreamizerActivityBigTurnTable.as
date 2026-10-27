package Processors.Game.Lobby.Activity.HDBigTurnTable
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.DatebaseVO.VO.THDBigTurnTable;
   import Logics.HDActivityBigTurnTable.TActivityBigTurnTableData;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.THDBoxStateData;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerActivityBigTurnTable extends TUnstreamizer
   {
      
      public function TUnstreamizerActivityBigTurnTable()
      {
         super();
      }
      
      public function CoreConfigValue(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityBigTurnTableData = null;
         var _loc5_:THDBigTurnTable = null;
         _loc4_ = param2 as TActivityBigTurnTableData;
         _loc5_ = param3 as THDBigTurnTable;
         _loc4_.BigTurnTableLuckyPoint = _loc5_.BigTurnTableLuckyPoint;
         _loc4_.BigTurnTableLuckyLotteryOutter = _loc5_.BigTurnTableLuckyLotteryOutter;
         _loc4_.BigTurnTableLuckyLotteryInner = _loc5_.BigTurnTableLuckyLotteryInner;
         _loc4_.BigTurnTableGoldPoint = _loc5_.BigTurnTableGoldPoint;
         _loc4_.BigTurnTableGoldLotteryOutter = _loc5_.BigTurnTableGoldLotteryOutter;
         _loc4_.BigTurnTableGoldLotteryInner = _loc5_.BigTurnTableGoldLotteryInner;
         _loc4_.ScorePoint = _loc5_.ScorePoint;
         _loc4_.BigTurnTableMall = _loc5_.BigTurnTableMall;
         _loc4_.BigTurnTableBuyHero = _loc5_.BigTurnTableBuyHero;
         _loc4_.BigTurnTableLuckyLotteryOutter.CreateLotteryAward();
         _loc4_.BigTurnTableLuckyLotteryInner.CreateLotteryAward();
         _loc4_.BigTurnTableGoldLotteryOutter.CreateLotteryAward();
         _loc4_.BigTurnTableGoldLotteryInner.CreateLotteryAward();
         _loc4_.BigTurnTableMall.CreateLotteryAward();
      }
      
      public function UnstreamizationPerform_InitData(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TActivityBigTurnTableData = null;
         var _loc5_:TActivityInitRetData = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Vector.<THDBoxStateData> = null;
         _loc4_ = param2 as TActivityBigTurnTableData;
         _loc5_ = param3 as TActivityInitRetData;
         _loc8_ = _loc5_.AwardStates;
         _loc7_ = int(_loc8_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc4_.ActivityDataInit(_loc8_[_loc6_].BoxIndex,_loc8_[_loc6_].State);
            _loc6_++;
         }
         _loc8_ = _loc5_.BuyStates;
         _loc7_ = int(_loc8_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc4_.ActivityDataInit(_loc8_[_loc6_].BoxIndex,_loc8_[_loc6_].State);
            _loc6_++;
         }
         _loc8_ = _loc5_.ShowOnlyStates;
         _loc7_ = int(_loc8_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc4_.ActivityDataInit(_loc8_[_loc6_].BoxIndex,_loc8_[_loc6_].State);
            _loc6_++;
         }
      }
   }
}

