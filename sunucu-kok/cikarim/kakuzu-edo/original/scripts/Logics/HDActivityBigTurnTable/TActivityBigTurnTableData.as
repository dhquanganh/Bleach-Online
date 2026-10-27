package Logics.HDActivityBigTurnTable
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityBigTurnTableData extends TActivityOSBase
   {
      
      protected var FBigTurnTableLuckyPoint:TBigTurnTableLuckyPoint;
      
      protected var FBigTurnTableLuckyLotteryOutter:TBigTurnTableLuckyLotteryOutter;
      
      protected var FBigTurnTableLuckyLotteryInner:TBigTurnTableLuckyLotteryInner;
      
      protected var FBigTurnTableGoldPoint:TBigTurnTableGoldPoint;
      
      protected var FBigTurnTableGoldLotteryOutter:TBigTurnTableGoldLotteryOutter;
      
      protected var FBigTurnTableGoldLotteryInner:TBigTurnTableGoldLotteryInner;
      
      protected var FBigTurnTableBuyHero:TBigTurnTableBuyHero;
      
      protected var FScorePoint:TScorePoint;
      
      protected var FBigTurnTableMall:TBigTurnTableMall;
      
      public function TActivityBigTurnTableData()
      {
         super();
      }
      
      public function get BigTurnTableLuckyPoint() : TBigTurnTableLuckyPoint
      {
         return this.FBigTurnTableLuckyPoint;
      }
      
      public function set BigTurnTableLuckyPoint(param1:TBigTurnTableLuckyPoint) : void
      {
         this.FBigTurnTableLuckyPoint = param1;
      }
      
      public function get BigTurnTableLuckyLotteryOutter() : TBigTurnTableLuckyLotteryOutter
      {
         return this.FBigTurnTableLuckyLotteryOutter;
      }
      
      public function set BigTurnTableLuckyLotteryOutter(param1:TBigTurnTableLuckyLotteryOutter) : void
      {
         this.FBigTurnTableLuckyLotteryOutter = param1;
      }
      
      public function get BigTurnTableLuckyLotteryInner() : TBigTurnTableLuckyLotteryInner
      {
         return this.FBigTurnTableLuckyLotteryInner;
      }
      
      public function set BigTurnTableLuckyLotteryInner(param1:TBigTurnTableLuckyLotteryInner) : void
      {
         this.FBigTurnTableLuckyLotteryInner = param1;
      }
      
      public function get BigTurnTableGoldPoint() : TBigTurnTableGoldPoint
      {
         return this.FBigTurnTableGoldPoint;
      }
      
      public function set BigTurnTableGoldPoint(param1:TBigTurnTableGoldPoint) : void
      {
         this.FBigTurnTableGoldPoint = param1;
      }
      
      public function get BigTurnTableGoldLotteryOutter() : TBigTurnTableGoldLotteryOutter
      {
         return this.FBigTurnTableGoldLotteryOutter;
      }
      
      public function set BigTurnTableGoldLotteryOutter(param1:TBigTurnTableGoldLotteryOutter) : void
      {
         this.FBigTurnTableGoldLotteryOutter = param1;
      }
      
      public function get BigTurnTableGoldLotteryInner() : TBigTurnTableGoldLotteryInner
      {
         return this.FBigTurnTableGoldLotteryInner;
      }
      
      public function set BigTurnTableGoldLotteryInner(param1:TBigTurnTableGoldLotteryInner) : void
      {
         this.FBigTurnTableGoldLotteryInner = param1;
      }
      
      public function get ScorePoint() : TScorePoint
      {
         return this.FScorePoint;
      }
      
      public function set ScorePoint(param1:TScorePoint) : void
      {
         this.FScorePoint = param1;
      }
      
      public function get BigTurnTableMall() : TBigTurnTableMall
      {
         return this.FBigTurnTableMall;
      }
      
      public function set BigTurnTableMall(param1:TBigTurnTableMall) : void
      {
         this.FBigTurnTableMall = param1;
      }
      
      public function get BigTurnTableBuyHero() : TBigTurnTableBuyHero
      {
         return this.FBigTurnTableBuyHero;
      }
      
      public function set BigTurnTableBuyHero(param1:TBigTurnTableBuyHero) : void
      {
         this.FBigTurnTableBuyHero = param1;
      }
      
      public function ActivityDataInit(param1:int, param2:int) : void
      {
         this.FBigTurnTableLuckyPoint.ActivityDataInit(param1,param2);
         this.FBigTurnTableLuckyLotteryOutter.ActivityDataInit(param1,param2);
         this.FBigTurnTableLuckyLotteryInner.ActivityDataInit(param1,param2);
         this.FBigTurnTableGoldPoint.ActivityDataInit(param1,param2);
         this.FBigTurnTableGoldLotteryOutter.ActivityDataInit(param1,param2);
         this.FBigTurnTableGoldLotteryInner.ActivityDataInit(param1,param2);
         this.FScorePoint.ActivityDataInit(param1,param2);
         this.FBigTurnTableMall.ActivityDataInit(param1,param2);
         this.FBigTurnTableBuyHero.ActivityDataInit(param1,param2);
      }
      
      public function ActivityDataUpdate(param1:int, param2:int) : void
      {
         this.FBigTurnTableLuckyPoint.ActivityDataUpdate(param1,param2);
         this.FBigTurnTableLuckyLotteryOutter.ActivityDataUpdate(param1,param2);
         this.FBigTurnTableLuckyLotteryInner.ActivityDataUpdate(param1,param2);
         this.FBigTurnTableGoldPoint.ActivityDataUpdate(param1,param2);
         this.FBigTurnTableGoldLotteryOutter.ActivityDataUpdate(param1,param2);
         this.FBigTurnTableGoldLotteryInner.ActivityDataUpdate(param1,param2);
         this.FScorePoint.ActivityDataUpdate(param1,param2);
         this.FBigTurnTableMall.ActivityDataUpdate(param1,param2);
         this.FBigTurnTableBuyHero.ActivityDataUpdate(param1,param2);
      }
   }
}

