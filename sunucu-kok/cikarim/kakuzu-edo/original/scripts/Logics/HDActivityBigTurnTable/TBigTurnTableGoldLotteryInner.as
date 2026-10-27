package Logics.HDActivityBigTurnTable
{
   import Logics.DatebaseVO.VO.Json.TRewards;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TBigTurnTableGoldLotteryInner
   {
      
      protected var FIndex:int;
      
      protected var FCost:int;
      
      protected var FBtnDescription:String;
      
      protected var FFlushVec:Vector.<int>;
      
      protected var FRewards:TRewards;
      
      protected var FInventories:TInventories;
      
      public function TBigTurnTableGoldLotteryInner(param1:Object)
      {
         super();
         this.FIndex = param1[0].index;
         this.FCost = param1[0].costChip[0].value;
         this.FBtnDescription = param1[0].des;
         this.FFlushVec = Vector.<int>(param1[0].flag);
         this.FInventories = new TInventories();
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
      
      public function get Cost() : int
      {
         return this.FCost;
      }
      
      public function get BtnDescription() : String
      {
         return this.FBtnDescription;
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

