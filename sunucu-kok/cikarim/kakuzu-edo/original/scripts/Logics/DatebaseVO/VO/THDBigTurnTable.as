package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDActivityBigTurnTable.TBigTurnTableBuyHero;
   import Logics.HDActivityBigTurnTable.TBigTurnTableGoldLotteryInner;
   import Logics.HDActivityBigTurnTable.TBigTurnTableGoldLotteryOutter;
   import Logics.HDActivityBigTurnTable.TBigTurnTableGoldPoint;
   import Logics.HDActivityBigTurnTable.TBigTurnTableLuckyLotteryInner;
   import Logics.HDActivityBigTurnTable.TBigTurnTableLuckyLotteryOutter;
   import Logics.HDActivityBigTurnTable.TBigTurnTableLuckyPoint;
   import Logics.HDActivityBigTurnTable.TBigTurnTableMall;
   import Logics.HDActivityBigTurnTable.TScorePoint;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDBigTurnTable extends THDActivityBase
   {
      
      protected var FRecordQualityLimit:int;
      
      protected var FBigTurnTableLuckyPoint:TBigTurnTableLuckyPoint;
      
      protected var FBigTurnTableLuckyLotteryOutter:TBigTurnTableLuckyLotteryOutter;
      
      protected var FBigTurnTableLuckyLotteryInner:TBigTurnTableLuckyLotteryInner;
      
      protected var FBigTurnTableGoldPoint:TBigTurnTableGoldPoint;
      
      protected var FBigTurnTableGoldLotteryOutter:TBigTurnTableGoldLotteryOutter;
      
      protected var FBigTurnTableGoldLotteryInner:TBigTurnTableGoldLotteryInner;
      
      protected var FBigTurnTableBuyHero:TBigTurnTableBuyHero;
      
      protected var FScorePoint:TScorePoint;
      
      protected var FBigTurnTableMall:TBigTurnTableMall;
      
      public function THDBigTurnTable()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FRecordQualityLimit = param1.readInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FBigTurnTableLuckyPoint = new TBigTurnTableLuckyPoint(Json.decode(_loc2_));
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FBigTurnTableLuckyLotteryOutter = new TBigTurnTableLuckyLotteryOutter(Json.decode(_loc2_));
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FBigTurnTableLuckyLotteryInner = new TBigTurnTableLuckyLotteryInner(Json.decode(_loc2_));
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FBigTurnTableGoldPoint = new TBigTurnTableGoldPoint(Json.decode(_loc2_));
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FBigTurnTableGoldLotteryOutter = new TBigTurnTableGoldLotteryOutter(Json.decode(_loc2_));
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FBigTurnTableGoldLotteryInner = new TBigTurnTableGoldLotteryInner(Json.decode(_loc2_));
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FBigTurnTableMall = new TBigTurnTableMall(Json.decode(_loc2_));
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FScorePoint = new TScorePoint(Json.decode(_loc2_));
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FBigTurnTableLuckyLotteryOutter.FlushLotteryAward(_loc2_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FBigTurnTableLuckyLotteryInner.FlushLotteryAward(_loc2_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FBigTurnTableGoldLotteryOutter.FlushLotteryAward(_loc2_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FBigTurnTableGoldLotteryInner.FlushLotteryAward(_loc2_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FBigTurnTableBuyHero = new TBigTurnTableBuyHero(Json.decode(_loc2_));
      }
      
      public function get RecordQualityLimit() : int
      {
         return this.FRecordQualityLimit;
      }
      
      public function get BigTurnTableLuckyPoint() : TBigTurnTableLuckyPoint
      {
         return this.FBigTurnTableLuckyPoint;
      }
      
      public function get BigTurnTableLuckyLotteryOutter() : TBigTurnTableLuckyLotteryOutter
      {
         return this.FBigTurnTableLuckyLotteryOutter;
      }
      
      public function get BigTurnTableLuckyLotteryInner() : TBigTurnTableLuckyLotteryInner
      {
         return this.FBigTurnTableLuckyLotteryInner;
      }
      
      public function get BigTurnTableGoldPoint() : TBigTurnTableGoldPoint
      {
         return this.FBigTurnTableGoldPoint;
      }
      
      public function get BigTurnTableGoldLotteryOutter() : TBigTurnTableGoldLotteryOutter
      {
         return this.FBigTurnTableGoldLotteryOutter;
      }
      
      public function get BigTurnTableGoldLotteryInner() : TBigTurnTableGoldLotteryInner
      {
         return this.FBigTurnTableGoldLotteryInner;
      }
      
      public function get ScorePoint() : TScorePoint
      {
         return this.FScorePoint;
      }
      
      public function get BigTurnTableMall() : TBigTurnTableMall
      {
         return this.FBigTurnTableMall;
      }
      
      public function get BigTurnTableBuyHero() : TBigTurnTableBuyHero
      {
         return this.FBigTurnTableBuyHero;
      }
   }
}

