package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDThanksTreasure extends THDActivityBase
   {
      
      protected var FScoreIndex:int;
      
      protected var FRate:int;
      
      protected var FFreeTreasure:int;
      
      protected var FFreeIndex:int;
      
      protected var FTreasureIndex:int;
      
      protected var FTreasureGold:int;
      
      protected var FOnekeyTreasureGold:int;
      
      protected var FOneKeyIndex:int;
      
      protected var FRefreshIndex:int;
      
      protected var FRefreshGold:int;
      
      protected var FGoldRate:Vector.<Object>;
      
      protected var FSilverRate:Vector.<Object>;
      
      protected var FAwardIndex:Vector.<int>;
      
      protected var FHeroGift:Object;
      
      protected var FScoreMall:Vector.<Object>;
      
      protected var FLanguage:Object;
      
      public function THDThanksTreasure()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FScoreIndex = param1.readInt();
         this.FRate = param1.readInt();
         this.FFreeTreasure = param1.readInt();
         this.FFreeIndex = param1.readInt();
         this.FTreasureIndex = param1.readInt();
         this.FTreasureGold = param1.readInt();
         this.FOnekeyTreasureGold = param1.readInt();
         this.FOneKeyIndex = param1.readInt();
         this.FRefreshIndex = param1.readInt();
         this.FRefreshGold = param1.readInt();
         this.FGoldRate = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FSilverRate = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FAwardIndex = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FHeroGift = Json.decode(TUtilityString.FetchUTF(param1));
         this.FScoreMall = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FLanguage = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get ScoreIndex() : int
      {
         return this.FScoreIndex;
      }
      
      public function get Rate() : int
      {
         return this.FRate;
      }
      
      public function get FreeTreasure() : int
      {
         return this.FFreeTreasure;
      }
      
      public function get FreeIndex() : int
      {
         return this.FFreeIndex;
      }
      
      public function get TreasureIndex() : int
      {
         return this.FTreasureIndex;
      }
      
      public function get TreasureGold() : int
      {
         return this.FTreasureGold;
      }
      
      public function get OnekeyTreasureGold() : int
      {
         return this.FOnekeyTreasureGold;
      }
      
      public function get OneKeyIndex() : int
      {
         return this.FOneKeyIndex;
      }
      
      public function get RefreshIndex() : int
      {
         return this.FRefreshIndex;
      }
      
      public function get RefreshGold() : int
      {
         return this.FRefreshGold;
      }
      
      public function get GoldRate() : Vector.<Object>
      {
         return this.FGoldRate;
      }
      
      public function get SilverRate() : Vector.<Object>
      {
         return this.FSilverRate;
      }
      
      public function get AwardIndex() : Vector.<int>
      {
         return this.FAwardIndex;
      }
      
      public function get HeroGift() : Object
      {
         return this.FHeroGift;
      }
      
      public function get ScoreMall() : Vector.<Object>
      {
         return this.FScoreMall;
      }
      
      public function get Language() : Object
      {
         return this.FLanguage;
      }
   }
}

