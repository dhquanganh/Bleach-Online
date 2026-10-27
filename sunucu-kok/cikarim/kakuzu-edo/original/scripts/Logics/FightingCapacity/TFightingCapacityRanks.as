package Logics.FightingCapacity
{
   public class TFightingCapacityRanks
   {
      
      protected var FFightingCapacityRanks:Vector.<TFightingCapacityRank>;
      
      public function TFightingCapacityRanks()
      {
         super();
         this.FFightingCapacityRanks = new Vector.<TFightingCapacityRank>();
      }
      
      protected function SortByRank(param1:TFightingCapacityRank, param2:TFightingCapacityRank) : int
      {
         if(param1.Rank > param2.Rank)
         {
            return 1;
         }
         if(param1.Rank < param2.Rank)
         {
            return -1;
         }
         return 0;
      }
      
      public function get Count() : int
      {
         return this.FFightingCapacityRanks.length;
      }
      
      public function GetFightingCapacityRankByIndex(param1:int) : TFightingCapacityRank
      {
         return this.FFightingCapacityRanks[param1];
      }
      
      public function Add(param1:TFightingCapacityRank) : void
      {
         this.FFightingCapacityRanks.push(param1);
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TFightingCapacityRank = null;
         _loc1_ = int(this.FFightingCapacityRanks.length);
         _loc2_ = 0;
         while(_loc2_ < this.FFightingCapacityRanks.length)
         {
            this.FFightingCapacityRanks.pop();
            _loc2_++;
         }
         this.FFightingCapacityRanks.length = 0;
      }
      
      public function Sort() : void
      {
         this.FFightingCapacityRanks.sort(this.SortByRank);
      }
   }
}

