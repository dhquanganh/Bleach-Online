package Logics.HDActivityOS
{
   import Logics.DatebaseVO.VO.Json.THDOSRank;
   
   public class TActivityOSLevelRank extends TActivityOSBase
   {
      
      protected var FMyCurRank:int;
      
      protected var FRankList:Vector.<THDOSRank>;
      
      public function TActivityOSLevelRank()
      {
         super();
      }
      
      public function get MyCurRank() : int
      {
         return this.FMyCurRank;
      }
      
      public function set MyCurRank(param1:int) : void
      {
         this.FMyCurRank = param1;
      }
      
      public function get RankList() : Vector.<THDOSRank>
      {
         return this.FRankList;
      }
      
      public function set RankList(param1:Vector.<THDOSRank>) : void
      {
         this.FRankList = param1;
      }
   }
}

