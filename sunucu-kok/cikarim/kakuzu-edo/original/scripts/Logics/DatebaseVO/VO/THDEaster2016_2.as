package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDEaster2016_2 extends THDActivityBase
   {
      
      protected var FCopperEgg:Object;
      
      protected var FSliverEgg:Object;
      
      protected var FGoldEgg:Object;
      
      protected var FScoreIndex:uint;
      
      protected var FScoreGift:Object;
      
      protected var FDisCount:uint;
      
      protected var FRankNum:uint;
      
      protected var FRankAward:Vector.<Object>;
      
      protected var FAwards:Vector.<Object>;
      
      public function THDEaster2016_2()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FCopperEgg = Json.decode(TUtilityString.FetchUTF(param1));
         this.FSliverEgg = Json.decode(TUtilityString.FetchUTF(param1));
         this.FGoldEgg = Json.decode(TUtilityString.FetchUTF(param1));
         this.FScoreIndex = param1.readUnsignedInt();
         this.FScoreGift = Json.decode(TUtilityString.FetchUTF(param1));
         this.FDisCount = param1.readUnsignedInt();
         this.FRankNum = param1.readUnsignedInt();
         this.FRankAward = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FAwards = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get CopperEgg() : Object
      {
         return this.FCopperEgg;
      }
      
      public function get SliverEgg() : Object
      {
         return this.FSliverEgg;
      }
      
      public function get GoldEgg() : Object
      {
         return this.FGoldEgg;
      }
      
      public function get ScoreIndex() : uint
      {
         return this.FScoreIndex;
      }
      
      public function get ScoreGift() : Object
      {
         return this.FScoreGift;
      }
      
      public function get DisCount() : uint
      {
         return this.FDisCount;
      }
      
      public function get RankNum() : uint
      {
         return this.FRankNum;
      }
      
      public function get RankAward() : Vector.<Object>
      {
         return this.FRankAward;
      }
      
      public function get Awards() : Vector.<Object>
      {
         return this.FAwards;
      }
   }
}

