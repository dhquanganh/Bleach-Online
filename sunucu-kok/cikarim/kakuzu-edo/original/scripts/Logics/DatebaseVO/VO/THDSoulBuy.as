package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDSoulBuy extends THDActivityBase
   {
      
      protected var FBuyAward:Vector.<Object>;
      
      protected var FScoreIndex:uint;
      
      protected var FScoreMall:Vector.<Object>;
      
      protected var FBigAward:Object;
      
      protected var FScoreID:uint;
      
      protected var FTexts:String;
      
      public function THDSoulBuy()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FBuyAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FScoreIndex = param1.readInt();
         this.FScoreMall = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FBigAward = Json.decode(TUtilityString.FetchUTF(param1));
         this.FScoreID = param1.readInt();
         this.FTexts = TUtilityString.FetchUTF(param1);
      }
      
      public function get BuyAward() : Vector.<Object>
      {
         return this.FBuyAward;
      }
      
      public function get ScoreIndex() : uint
      {
         return this.FScoreIndex;
      }
      
      public function get ScoreMall() : Vector.<Object>
      {
         return this.FScoreMall;
      }
      
      public function get BigAward() : Object
      {
         return this.FBigAward;
      }
      
      public function get Texts() : String
      {
         return this.FTexts;
      }
      
      public function get ScoreID() : uint
      {
         return this.FScoreID;
      }
   }
}

