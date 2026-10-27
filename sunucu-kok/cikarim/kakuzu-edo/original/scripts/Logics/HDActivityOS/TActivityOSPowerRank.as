package Logics.HDActivityOS
{
   import Logics.DatebaseVO.VO.Json.THDOSRank;
   
   public class TActivityOSPowerRank extends TActivityOSBase
   {
      
      protected var FTargetPower:int;
      
      protected var FMyHistoryPower:int;
      
      protected var FMyRank:int;
      
      protected var FRankList:Vector.<THDOSRank>;
      
      public function TActivityOSPowerRank()
      {
         super();
      }
      
      public function get TargetPower() : int
      {
         return this.FTargetPower;
      }
      
      public function set TargetPower(param1:int) : void
      {
         this.FTargetPower = param1;
      }
      
      public function get MyHistoryPower() : int
      {
         return this.FMyHistoryPower;
      }
      
      public function set MyHistoryPower(param1:int) : void
      {
         this.FMyHistoryPower = param1;
      }
      
      public function get MyRank() : int
      {
         return this.FMyRank;
      }
      
      public function set MyRank(param1:int) : void
      {
         this.FMyRank = param1;
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

