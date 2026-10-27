package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDGhostKingForg extends THDActivityBase
   {
      
      protected var FConfig:THDGhostKingForg;
      
      protected var FRechargeIndex:int;
      
      protected var FForging:Object;
      
      protected var FForgingMax:int;
      
      protected var FForgingAward:Object;
      
      protected var FScoreIndex:int;
      
      protected var FAdditionalAward:Object;
      
      protected var FAdditionalItems:Vector.<uint>;
      
      protected var FBigAward:Object;
      
      protected var FScoreShop:Vector.<Object>;
      
      protected var FLanguage:Object;
      
      public function THDGhostKingForg()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FRechargeIndex = param1.readInt();
         this.FForging = Json.decode(TUtilityString.FetchUTF(param1));
         this.FForgingMax = param1.readInt();
         this.FForgingAward = Json.decode(TUtilityString.FetchUTF(param1));
         this.FScoreIndex = param1.readInt();
         this.FAdditionalAward = Json.decode(TUtilityString.FetchUTF(param1));
         this.FAdditionalItems = Vector.<uint>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FBigAward = Json.decode(TUtilityString.FetchUTF(param1));
         this.FScoreShop = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FLanguage = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get RechargeIndex() : int
      {
         return this.FRechargeIndex;
      }
      
      public function get Forging() : Object
      {
         return this.FForging;
      }
      
      public function get ForgingMax() : int
      {
         return this.FForgingMax;
      }
      
      public function get ForgingAward() : Object
      {
         return this.FForgingAward;
      }
      
      public function get ScoreIndex() : int
      {
         return this.FScoreIndex;
      }
      
      public function get AdditionalAward() : Object
      {
         return this.FAdditionalAward;
      }
      
      public function get AdditionalItems() : Vector.<uint>
      {
         return this.FAdditionalItems;
      }
      
      public function get BigAward() : Object
      {
         return this.FBigAward;
      }
      
      public function get ScoreShop() : Vector.<Object>
      {
         return this.FScoreShop;
      }
      
      public function get Config() : THDGhostKingForg
      {
         return this.FConfig;
      }
      
      public function get Language() : Object
      {
         return this.FLanguage;
      }
   }
}

