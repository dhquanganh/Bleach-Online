package Logics.HDRushInSeireitei
{
   import Logics.HDActivityMode.TActivityServerRank;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Pet.TVicePet;
   
   public class THDRushInSeireiteiData extends TActivityOSBase
   {
      
      protected var FCurLevelIndex:int;
      
      protected var FRefreshType:int;
      
      protected var FCurScore:int;
      
      protected var FTotalScore:int;
      
      protected var FNomalCount:int;
      
      protected var FSpecialCount:int;
      
      protected var FLevelStatusVec:Vector.<int>;
      
      protected var FShopStatusVec:Vector.<int>;
      
      protected var FRankVec:Vector.<TActivityServerRank>;
      
      protected var FShopRefresh:Boolean;
      
      protected var FVicePet:TVicePet;
      
      public function THDRushInSeireiteiData()
      {
         super();
         this.FRankVec = new Vector.<TActivityServerRank>();
      }
      
      public function get CurLevelIndex() : int
      {
         return this.FCurLevelIndex;
      }
      
      public function set CurLevelIndex(param1:int) : void
      {
         this.FCurLevelIndex = param1;
      }
      
      public function get RefreshType() : int
      {
         return this.FRefreshType;
      }
      
      public function set RefreshType(param1:int) : void
      {
         this.FRefreshType = param1;
      }
      
      public function get CurScore() : int
      {
         return this.FCurScore;
      }
      
      public function set CurScore(param1:int) : void
      {
         this.FCurScore = param1;
      }
      
      public function get NomalCount() : int
      {
         return this.FNomalCount;
      }
      
      public function set NomalCount(param1:int) : void
      {
         this.FNomalCount = param1;
      }
      
      public function get SpecialCount() : int
      {
         return this.FSpecialCount;
      }
      
      public function set SpecialCount(param1:int) : void
      {
         this.FSpecialCount = param1;
      }
      
      public function get LevelStatusVec() : Vector.<int>
      {
         return this.FLevelStatusVec;
      }
      
      public function set LevelStatusVec(param1:Vector.<int>) : void
      {
         this.FLevelStatusVec = param1;
      }
      
      public function get ShopStatusVec() : Vector.<int>
      {
         return this.FShopStatusVec;
      }
      
      public function set ShopStatusVec(param1:Vector.<int>) : void
      {
         this.FShopStatusVec = param1;
      }
      
      public function get RankVec() : Vector.<TActivityServerRank>
      {
         return this.FRankVec;
      }
      
      public function get ShopRefresh() : Boolean
      {
         return this.FShopRefresh;
      }
      
      public function set ShopRefresh(param1:Boolean) : void
      {
         this.FShopRefresh = param1;
      }
      
      public function get VicePet() : TVicePet
      {
         return this.FVicePet;
      }
      
      public function set VicePet(param1:TVicePet) : void
      {
         this.FVicePet = param1;
      }
      
      public function get TotalScore() : int
      {
         return this.FTotalScore;
      }
      
      public function set TotalScore(param1:int) : void
      {
         this.FTotalScore = param1;
      }
   }
}

