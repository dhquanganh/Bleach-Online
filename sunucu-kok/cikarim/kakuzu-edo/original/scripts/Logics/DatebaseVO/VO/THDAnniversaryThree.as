package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDAnniversaryThree extends THDActivityBase
   {
      
      protected var FShowNum:int;
      
      protected var FOnceNum:int;
      
      protected var FStartIndex:int;
      
      protected var FAwardIndex:int;
      
      protected var FScoreIndex:int;
      
      protected var FCost:int;
      
      protected var FAwardInfo:Object;
      
      protected var FTips:Object;
      
      protected var FMall:Vector.<Object>;
      
      public function THDAnniversaryThree()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FShowNum = param1.readUnsignedInt();
         this.FOnceNum = param1.readUnsignedInt();
         this.FStartIndex = param1.readUnsignedInt();
         this.FAwardIndex = param1.readUnsignedInt();
         this.FScoreIndex = param1.readUnsignedInt();
         this.FCost = param1.readUnsignedInt();
         this.FAwardInfo = Json.decode(TUtilityString.FetchUTF(param1));
         this.FTips = Json.decode(TUtilityString.FetchUTF(param1));
         this.FMall = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get ShowNum() : int
      {
         return this.FShowNum;
      }
      
      public function get StartIndex() : int
      {
         return this.FStartIndex;
      }
      
      public function get AwardIndex() : int
      {
         return this.FAwardIndex;
      }
      
      public function get Cost() : int
      {
         return this.FCost;
      }
      
      public function get AwardInfo() : Object
      {
         return this.FAwardInfo;
      }
      
      public function get Tips() : Object
      {
         return this.FTips;
      }
      
      public function get Mall() : Vector.<Object>
      {
         return this.FMall;
      }
      
      public function get OnceNum() : int
      {
         return this.FOnceNum;
      }
      
      public function get ScoreIndex() : int
      {
         return this.FScoreIndex;
      }
   }
}

