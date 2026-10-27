package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNewYear2016Chess extends THDActivityBase
   {
      
      protected var FOrdinaryDice:Object;
      
      protected var FSuperDice:Object;
      
      protected var FRefresh:Object;
      
      protected var FOneKeyArrive:Object;
      
      protected var FBigAward:Object;
      
      protected var FScoreIndex:uint;
      
      protected var FAwardBins:Vector.<Object>;
      
      protected var FScoreShop:Vector.<Object>;
      
      protected var FDumplinId:uint;
      
      protected var FAwardShow:Object;
      
      public function THDNewYear2016Chess()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FOrdinaryDice = Json.decode(TUtilityString.FetchUTF(param1));
         this.FSuperDice = Json.decode(TUtilityString.FetchUTF(param1));
         this.FRefresh = Json.decode(TUtilityString.FetchUTF(param1));
         this.FOneKeyArrive = Json.decode(TUtilityString.FetchUTF(param1));
         this.FBigAward = Json.decode(TUtilityString.FetchUTF(param1));
         this.FScoreIndex = param1.readUnsignedInt();
         this.FAwardBins = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FScoreShop = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FDumplinId = param1.readUnsignedInt();
         this.FAwardShow = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get OrdinaryDice() : Object
      {
         return this.FOrdinaryDice;
      }
      
      public function get SuperDice() : Object
      {
         return this.FSuperDice;
      }
      
      public function get Refresh() : Object
      {
         return this.FRefresh;
      }
      
      public function get OneKeyArrive() : Object
      {
         return this.FOneKeyArrive;
      }
      
      public function get BigAward() : Object
      {
         return this.FBigAward;
      }
      
      public function get ScoreIndex() : uint
      {
         return this.FScoreIndex;
      }
      
      public function get AwardBins() : Vector.<Object>
      {
         return this.FAwardBins;
      }
      
      public function get ScoreShop() : Vector.<Object>
      {
         return this.FScoreShop;
      }
      
      public function get DumplinId() : uint
      {
         return this.FDumplinId;
      }
      
      public function get AwardShow() : Object
      {
         return this.FAwardShow;
      }
   }
}

