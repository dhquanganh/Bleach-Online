package Logics.HDEaster2016
{
   import Logics.DatebaseVO.VO.THDEaster2016_2;
   import Logics.HDActivityMode.TActivityServerRank;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   
   public class THDEasterData2016_2 extends TActivityOSBase
   {
      
      protected var FTime:uint;
      
      protected var FCurScore:uint;
      
      protected var FGiftStatus:Vector.<int>;
      
      protected var FGiftInvs:Vector.<TInventories>;
      
      protected var FRankVec:Vector.<TActivityServerRank>;
      
      protected var FRewards:Vector.<TInventory>;
      
      protected var FConfig:THDEaster2016_2;
      
      public function THDEasterData2016_2()
      {
         super();
         this.FGiftStatus = new Vector.<int>();
         this.FRankVec = new Vector.<TActivityServerRank>();
         this.FGiftInvs = new Vector.<TInventories>();
         this.FRewards = new Vector.<TInventory>();
      }
      
      public function get Time() : uint
      {
         return this.FTime;
      }
      
      public function set Time(param1:uint) : void
      {
         this.FTime = param1;
      }
      
      public function get CurScore() : uint
      {
         return this.FCurScore;
      }
      
      public function set CurScore(param1:uint) : void
      {
         this.FCurScore = param1;
      }
      
      public function get GiftStatus() : Vector.<int>
      {
         return this.FGiftStatus;
      }
      
      public function set GiftStatus(param1:Vector.<int>) : void
      {
         this.FGiftStatus = param1;
      }
      
      public function get Config() : THDEaster2016_2
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDEaster2016_2) : void
      {
         this.FConfig = param1;
      }
      
      public function get RankVec() : Vector.<TActivityServerRank>
      {
         return this.FRankVec;
      }
      
      public function set RankVec(param1:Vector.<TActivityServerRank>) : void
      {
         this.FRankVec = param1;
      }
      
      public function get GiftInvs() : Vector.<TInventories>
      {
         return this.FGiftInvs;
      }
      
      public function set GiftInvs(param1:Vector.<TInventories>) : void
      {
         this.FGiftInvs = param1;
      }
      
      public function get Rewards() : Vector.<TInventory>
      {
         return this.FRewards;
      }
      
      public function set Rewards(param1:Vector.<TInventory>) : void
      {
         this.FRewards = param1;
      }
   }
}

