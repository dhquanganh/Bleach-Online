package Logics.VoidSoulWorld.VO
{
   public class TRankRewardVO
   {
      
      protected var FBoxCount:int;
      
      protected var FStartRank:int;
      
      protected var FEndRank:int;
      
      public function TRankRewardVO()
      {
         super();
      }
      
      public function get BoxCount() : int
      {
         return this.FBoxCount;
      }
      
      public function set BoxCount(param1:int) : void
      {
         this.FBoxCount = param1;
      }
      
      public function get StartRank() : int
      {
         return this.FStartRank;
      }
      
      public function set StartRank(param1:int) : void
      {
         this.FStartRank = param1;
      }
      
      public function get EndRank() : int
      {
         return this.FEndRank;
      }
      
      public function set EndRank(param1:int) : void
      {
         this.FEndRank = param1;
      }
   }
}

