package Logics.HDIceHeros
{
   import Logics.HDActivityMode.TActivityServerRank;
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityIceHeros extends TActivityOSBase
   {
      
      public var Runtime:Object;
      protected var FAwards:Vector.<TActivityIHAward>;
      
      protected var FChipBoxs:Vector.<TActivityIHChipBox>;
      
      protected var FHeroIDs:Vector.<uint>;
      
      protected var FCurOwned:uint;
      
      protected var FRanks:Vector.<TActivityServerRank>;
      
      protected var FMyRank:int;
      
      protected var FCurStage:uint;
      
      public function TActivityIceHeros()
      {
         super();
         this.FAwards = new Vector.<TActivityIHAward>();
         this.FChipBoxs = new Vector.<TActivityIHChipBox>();
         this.FHeroIDs = new Vector.<uint>();
         this.FRanks = new Vector.<TActivityServerRank>();
         this.FMyRank = -1;
      }
      
      protected function SortByRank(param1:TActivityServerRank, param2:TActivityServerRank) : int
      {
         if(param1.Rank < param2.Rank)
         {
            return -1;
         }
         return 1;
      }
      
      public function get AwardsCount() : uint
      {
         return this.FAwards.length;
      }
      
      public function get ChipBoxCount() : uint
      {
         return this.FChipBoxs.length;
      }
      
      public function get RankCount() : uint
      {
         return this.FRanks.length;
      }
      
      public function get HeroIDs() : Vector.<uint>
      {
         return this.FHeroIDs;
      }
      
      public function set HeroIDs(param1:Vector.<uint>) : void
      {
         this.FHeroIDs = param1;
      }
      
      public function get CurOwned() : uint
      {
         return this.FCurOwned;
      }
      
      public function set CurOwned(param1:uint) : void
      {
         this.FCurOwned = param1;
      }
      
      public function get MyRank() : int
      {
         return this.FMyRank;
      }
      
      public function set MyRank(param1:int) : void
      {
         this.FMyRank = param1;
      }
      
      public function get ChipBoxs() : Vector.<TActivityIHChipBox>
      {
         return this.FChipBoxs;
      }
      
      public function set ChipBoxs(param1:Vector.<TActivityIHChipBox>) : void
      {
         this.FChipBoxs = param1;
      }
      
      public function get CurStage() : uint
      {
         return this.FCurStage;
      }
      
      public function set CurStage(param1:uint) : void
      {
         this.FCurStage = param1;
      }
      
      public function ClearRank() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActivityServerRank = null;
         this.FRanks.length = 0;
      }
      
      public function ClearAwards() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActivityIHAward = null;
         this.FAwards.length = 0;
      }
      
      public function AddRankItem(param1:TActivityServerRank) : void
      {
         this.FRanks.push(param1);
      }
      
      public function AddAwardItem(param1:TActivityIHAward) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FAwards.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FAwards[_loc2_].Index == param1.Index)
            {
               return;
            }
            _loc2_++;
         }
         this.FAwards.push(param1);
      }
      
      public function GetRankByIndex(param1:int) : TActivityServerRank
      {
         if(this.FRanks != null && this.FRanks.length > 0)
         {
            return this.FRanks[param1];
         }
         return null;
      }
      
      public function GetAwardByIndex(param1:int) : TActivityIHAward
      {
         if(this.FAwards != null && this.FAwards.length > 0)
         {
            return this.FAwards[param1];
         }
         return null;
      }
      
      public function GetAwardByUniqueIndex(param1:uint) : TActivityIHAward
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.FAwards == null)
         {
            return null;
         }
         _loc3_ = int(this.FAwards.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FAwards[_loc2_].Index == param1)
            {
               return this.FAwards[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function GetChipBoxByIndex(param1:int) : TActivityIHChipBox
      {
         if(this.FChipBoxs != null && this.FChipBoxs.length > 0)
         {
            return this.FChipBoxs[param1];
         }
         return null;
      }
      
      public function GetChipBoxByUniqueIndex(param1:uint) : TActivityIHChipBox
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.FChipBoxs == null)
         {
            return null;
         }
         _loc3_ = int(this.FChipBoxs.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FChipBoxs[_loc2_].Index == param1)
            {
               return this.FChipBoxs[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function RankSort() : void
      {
         this.FRanks.sort(this.SortByRank);
      }
   }
}

