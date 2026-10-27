package Logics.HDActivityOS
{
   import Logics.DatebaseVO.VO.Json.THDOSRank;
   
   public class TActivityOSArenaRank extends TActivityOSBase
   {
      
      protected var FRankList:Vector.<THDOSRank>;
      
      public function TActivityOSArenaRank()
      {
         super();
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

