package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDChristmasSock extends THDActivityBase
   {
      
      protected var FTaskAwards:Vector.<Object>;
      
      protected var FRankAwards:Vector.<Object>;
      
      protected var FSockNum:int;
      
      protected var FSockItemID:int;
      
      protected var FRound:int;
      
      protected var FRankNum:int;
      
      protected var FSockAwards:Vector.<Object>;
      
      protected var FJackPoint:Object;
      
      public function THDChristmasSock()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FTaskAwards = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FRankAwards = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         _loc2_ = Json.decode(TUtilityString.FetchUTF(param1));
         this.FSockNum = _loc2_.index;
         this.FSockItemID = _loc2_.code;
         this.FSockAwards = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FRound = param1.readUnsignedInt();
         this.FRankNum = param1.readUnsignedInt();
         this.FJackPoint = Json.decode(TUtilityString.FetchUTF(param1));
      }
      
      public function get TaskAwards() : Vector.<Object>
      {
         return this.FTaskAwards;
      }
      
      public function get RankAwards() : Vector.<Object>
      {
         return this.FRankAwards;
      }
      
      public function get SockNum() : int
      {
         return this.FSockNum;
      }
      
      public function get Round() : int
      {
         return this.FRound;
      }
      
      public function get RankNum() : int
      {
         return this.FRankNum;
      }
      
      public function get SockAwards() : Vector.<Object>
      {
         return this.FSockAwards;
      }
      
      public function get JackPoint() : Object
      {
         return this.FJackPoint;
      }
      
      public function get SockItemID() : int
      {
         return this.FSockItemID;
      }
   }
}

