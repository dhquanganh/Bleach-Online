package Logics.CityDefend
{
   public class TCityDefendRanks
   {
      
      protected var FCityDefendRanks:Vector.<TCityDefendRank>;
      
      public function TCityDefendRanks()
      {
         super();
         this.FCityDefendRanks = new Vector.<TCityDefendRank>();
      }
      
      protected function OnSortHarm(param1:TCityDefendRank, param2:TCityDefendRank) : int
      {
         if(param1.RankHarm < param2.RankHarm)
         {
            return 1;
         }
         return -1;
      }
      
      public function get Count() : int
      {
         return this.FCityDefendRanks.length;
      }
      
      public function GetRankByIndex(param1:int) : TCityDefendRank
      {
         return this.FCityDefendRanks[param1];
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TCityDefendRank = null;
         _loc1_ = int(this.FCityDefendRanks.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FCityDefendRanks[_loc2_];
            _loc3_.StubReferences.Dereference(this);
            _loc2_++;
         }
         this.FCityDefendRanks.length = 0;
      }
      
      public function Add(param1:TCityDefendRank) : void
      {
         param1.StubReferences.Reference(this);
         this.FCityDefendRanks.push(param1);
      }
      
      public function Sort() : void
      {
         this.FCityDefendRanks.sort(this.OnSortHarm);
      }
   }
}

