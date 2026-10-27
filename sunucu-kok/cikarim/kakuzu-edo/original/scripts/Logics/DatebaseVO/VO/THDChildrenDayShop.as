package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDChildrenDayShop extends THDActivityBase
   {
      
      protected var FScoreIndex:uint;
      
      protected var FPayIndex:uint;
      
      protected var FLoginAward:Vector.<Object>;
      
      protected var FPayAward:Vector.<Object>;
      
      protected var FGoldMall:Vector.<Object>;
      
      protected var FScoreMall:Vector.<Object>;
      
      protected var FCandyID:uint;
      
      public function THDChildrenDayShop()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FScoreIndex = param1.readUnsignedInt();
         this.FPayIndex = param1.readUnsignedInt();
         this.FLoginAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FPayAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FGoldMall = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FScoreMall = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FCandyID = param1.readUnsignedInt();
      }
      
      public function get ScoreIndex() : uint
      {
         return this.FScoreIndex;
      }
      
      public function get PayIndex() : uint
      {
         return this.FPayIndex;
      }
      
      public function get LoginAward() : Vector.<Object>
      {
         return this.FLoginAward;
      }
      
      public function get PayAward() : Vector.<Object>
      {
         return this.FPayAward;
      }
      
      public function get GoldMall() : Vector.<Object>
      {
         return this.FGoldMall;
      }
      
      public function get ScoreMall() : Vector.<Object>
      {
         return this.FScoreMall;
      }
      
      public function get CandyID() : uint
      {
         return this.FCandyID;
      }
   }
}

