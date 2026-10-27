package Logics.HDActivityBigTurnTable
{
   import Logics.DatebaseVO.VO.Json.TRewards;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TBigTurnTableGoldLotteryOutter
   {
      
      protected var FIndex:Vector.<uint>;
      
      protected var FTime:Vector.<int>;
      
      protected var FCost:Vector.<int>;
      
      protected var FVipLimit:Vector.<int>;
      
      protected var FBtnDescription:Vector.<String>;
      
      protected var FFlushVec:Vector.<int>;
      
      protected var FGoldScore:Vector.<int>;
      
      protected var FScore:Vector.<int>;
      
      protected var FRewards:TRewards;
      
      protected var FInventories:TInventories;
      
      public function TBigTurnTableGoldLotteryOutter(param1:Object)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         super();
         this.FIndex = new Vector.<uint>();
         this.FTime = new Vector.<int>();
         this.FCost = new Vector.<int>();
         this.FVipLimit = new Vector.<int>();
         this.FBtnDescription = new Vector.<String>();
         this.FGoldScore = new Vector.<int>();
         this.FScore = new Vector.<int>();
         _loc4_ = param1 as Array;
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = _loc4_[_loc2_];
            this.FIndex.push(_loc5_.index);
            this.FCost.push(_loc5_.cost);
            this.FTime.push(_loc5_.count);
            this.FVipLimit.push(_loc5_.condition);
            this.FBtnDescription.push(_loc5_.des);
            this.FGoldScore.push(_loc5_.getChip[0].value);
            this.FScore.push(_loc5_.getChip[1].value);
            _loc2_++;
         }
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
      
      public function get Cost() : Vector.<int>
      {
         return this.FCost;
      }
      
      public function get VipLimit() : Vector.<int>
      {
         return this.FVipLimit;
      }
      
      public function get BtnDescription() : Vector.<String>
      {
         return this.FBtnDescription;
      }
      
      public function set BtnDescription(param1:Vector.<String>) : void
      {
         this.FBtnDescription = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function get Rewards() : TRewards
      {
         return this.FRewards;
      }
      
      public function get Index() : Vector.<uint>
      {
         return this.FIndex;
      }
      
      public function get Time() : Vector.<int>
      {
         return this.FTime;
      }
      
      public function get FlushVec() : Vector.<int>
      {
         return this.FFlushVec;
      }
      
      public function get GoldScore() : Vector.<int>
      {
         return this.FGoldScore;
      }
      
      public function get Score() : Vector.<int>
      {
         return this.FScore;
      }
      
      public function ActivityDataInit(param1:int, param2:int) : void
      {
      }
      
      public function ActivityDataUpdate(param1:int, param2:int) : void
      {
      }
   }
}

