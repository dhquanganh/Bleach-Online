package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TDoubleFishAward;
   import Logics.DatebaseVO.VO.Json.TDoubleFishRank;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDDoubleFish extends THDActivityBase
   {
      
      protected var FTotalPlayer:uint;
      
      protected var FKnifeID:uint;
      
      protected var FRankList:Vector.<TDoubleFishRank>;
      
      protected var FAwardList:Vector.<TDoubleFishAward>;
      
      protected var FRankDesc:String;
      
      protected var FAddValue:uint;
      
      public function THDDoubleFish()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:TDoubleFishRank = null;
         var _loc6_:Array = null;
         var _loc7_:TDoubleFishAward = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc4_) as Array;
         _loc3_ = int(_loc6_.length);
         this.FRankList = new Vector.<TDoubleFishRank>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TDoubleFishRank(_loc6_[_loc2_]);
            this.FRankList[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc4_) as Array;
         _loc3_ = int(_loc6_.length);
         this.FAwardList = new Vector.<TDoubleFishAward>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc7_ = new TDoubleFishAward(_loc6_[_loc2_]);
            this.FAwardList[_loc2_] = _loc7_;
            _loc2_++;
         }
         this.FKnifeID = param1.readUnsignedInt();
         this.FTotalPlayer = param1.readUnsignedInt();
         this.FRankDesc = TUtilityString.FetchUTF(param1);
         this.FAddValue = param1.readUnsignedInt();
      }
      
      public function get TotalPlayer() : uint
      {
         return this.FTotalPlayer;
      }
      
      public function get KnifeID() : uint
      {
         return this.FKnifeID;
      }
      
      public function get RankList() : Vector.<TDoubleFishRank>
      {
         return this.FRankList;
      }
      
      public function get AwardList() : Vector.<TDoubleFishAward>
      {
         return this.FAwardList;
      }
      
      public function get RankDesc() : String
      {
         return this.FRankDesc;
      }
      
      public function get AddValue() : uint
      {
         return this.FAddValue;
      }
   }
}

