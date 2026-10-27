package Logics.HDActivityBigTurnTable
{
   import Logics.DatebaseVO.VO.Json.TRewards;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TBigTurnTableLuckyLotteryOutter
   {
      
      protected var FIndex:int;
      
      protected var FTimeCountedDown:int;
      
      protected var FPreLotteryTime:int;
      
      protected var FRewards:TRewards;
      
      protected var FBtnDescription:String;
      
      protected var FFlushVec:Vector.<int>;
      
      protected var FChipAmount:Vector.<int>;
      
      protected var FInventories:TInventories;
      
      public function TBigTurnTableLuckyLotteryOutter(param1:Object)
      {
         super();
         this.FIndex = param1[0].index;
         this.FTimeCountedDown = param1[0].condition[0].value;
         this.FBtnDescription = param1[0].des;
         this.FChipAmount = new Vector.<int>();
         this.FChipAmount.push(param1[0].getChip[0].value);
         this.FChipAmount.push(param1[0].getChip[1].value);
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
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get TimeCountedDown() : int
      {
         return this.FTimeCountedDown;
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
      
      public function get ChipAmount() : Vector.<int>
      {
         return this.FChipAmount;
      }
      
      public function get PreLotteryTime() : int
      {
         return this.FPreLotteryTime;
      }
      
      public function set PreLotteryTime(param1:int) : void
      {
         this.FPreLotteryTime = param1;
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
         this.FPreLotteryTime = param2;
      }
      
      public function ActivityDataUpdate(param1:int, param2:int) : void
      {
         if(this.FIndex != param1)
         {
            return;
         }
         this.FPreLotteryTime = param2;
      }
   }
}

