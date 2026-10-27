package Logics.HDActivityBigTurnTable
{
   import Logics.DatebaseVO.VO.Json.TRewards;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TBigTurnTableLuckyLotteryInner
   {
      
      protected var FIndex:int;
      
      protected var FBtnDescription:String;
      
      protected var FCostChip:int;
      
      protected var FFlushVec:Vector.<int>;
      
      protected var FRewards:TRewards;
      
      protected var FInventories:TInventories;
      
      public function TBigTurnTableLuckyLotteryInner(param1:Object)
      {
         super();
         this.FIndex = param1[0].index;
         this.FBtnDescription = param1[0].des;
         this.FInventories = new TInventories();
         this.FCostChip = param1[0].costChip[0].value;
         this.FFlushVec = Vector.<int>(param1[0].flag);
      }
      
      public function FlushLotteryAward(param1:Object) : void
      {
         this.FRewards = new TRewards(param1);
      }
      
      public function CreateLotteryAward() : void
      {
         SToolReward.CreateRewardInventoryByRewardInfor(this.FRewards,this.FInventories);
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get BtnDescription() : String
      {
         return this.FBtnDescription;
      }
      
      public function get CostChip() : int
      {
         return this.FCostChip;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function get Rewards() : TRewards
      {
         return this.FRewards;
      }
      
      public function get FlushVec() : Vector.<int>
      {
         return this.FFlushVec;
      }
      
      public function ActivityDataInit(param1:int, param2:int) : void
      {
         if(this.FIndex != param1)
         {
            return;
         }
      }
      
      public function ActivityDataUpdate(param1:int, param2:int) : void
      {
         if(this.FIndex != param1)
         {
            return;
         }
      }
   }
}

