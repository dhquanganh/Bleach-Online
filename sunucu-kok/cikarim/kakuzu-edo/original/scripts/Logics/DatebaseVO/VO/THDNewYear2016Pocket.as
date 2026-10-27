package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNewYear2016Pocket extends THDActivityBase
   {
      
      protected var FPocketIndexs:Vector.<Object>;
      
      protected var FPocketsBin:Vector.<Object>;
      
      protected var FPocketsCount:Object;
      
      protected var FlookIndex:uint;
      
      protected var FOnceOpen:Object;
      
      protected var FOnekeyOpen:Object;
      
      protected var FRefresh:Object;
      
      protected var FBigAward:Object;
      
      protected var FRedPackageIndex:uint;
      
      protected var FRedPackageItems:Vector.<Object>;
      
      protected var FScoreIndex:uint;
      
      protected var FScoreShop:Vector.<Object>;
      
      protected var FGoldToScore:Object;
      
      protected var FRedPackageId:uint;
      
      public function THDNewYear2016Pocket()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FPocketIndexs = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FPocketsBin = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FPocketsCount = Json.decode(TUtilityString.FetchUTF(param1));
         this.FlookIndex = param1.readUnsignedInt();
         this.FOnceOpen = Json.decode(TUtilityString.FetchUTF(param1));
         this.FOnekeyOpen = Json.decode(TUtilityString.FetchUTF(param1));
         this.FRefresh = Json.decode(TUtilityString.FetchUTF(param1));
         this.FBigAward = Json.decode(TUtilityString.FetchUTF(param1));
         this.FRedPackageIndex = param1.readUnsignedInt();
         this.FRedPackageItems = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FScoreIndex = param1.readUnsignedInt();
         this.FScoreShop = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FGoldToScore = Json.decode(TUtilityString.FetchUTF(param1));
         this.FRedPackageId = param1.readUnsignedInt();
      }
      
      public function get PocketIndexs() : Vector.<Object>
      {
         return this.FPocketIndexs;
      }
      
      public function get PocketsBin() : Vector.<Object>
      {
         return this.FPocketsBin;
      }
      
      public function get PocketsCount() : Object
      {
         return this.FPocketsCount;
      }
      
      public function get lookIndex() : uint
      {
         return this.FlookIndex;
      }
      
      public function get OnceOpen() : Object
      {
         return this.FOnceOpen;
      }
      
      public function get OnekeyOpen() : Object
      {
         return this.FOnekeyOpen;
      }
      
      public function get Refresh() : Object
      {
         return this.FRefresh;
      }
      
      public function get BigAward() : Object
      {
         return this.FBigAward;
      }
      
      public function get RedPackageIndex() : uint
      {
         return this.FRedPackageIndex;
      }
      
      public function get RedPackageItems() : Vector.<Object>
      {
         return this.FRedPackageItems;
      }
      
      public function get ScoreIndex() : uint
      {
         return this.FScoreIndex;
      }
      
      public function get ScoreShop() : Vector.<Object>
      {
         return this.FScoreShop;
      }
      
      public function get GoldToScore() : Object
      {
         return this.FGoldToScore;
      }
      
      public function get RedPackageId() : uint
      {
         return this.FRedPackageId;
      }
   }
}

