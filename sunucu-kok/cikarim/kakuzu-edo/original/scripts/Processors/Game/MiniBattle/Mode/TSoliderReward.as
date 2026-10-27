package Processors.Game.MiniBattle.Mode
{
   import Logics.Inventories.TInventories;
   
   public class TSoliderReward
   {
      
      protected var FSoliderName:String;
      
      protected var FSoliderTempleteID:uint;
      
      protected var FKillNum:int;
      
      protected var FFriendAdded:Boolean;
      
      protected var FGuideAdded:Boolean;
      
      protected var FRewards:TInventories;
      
      protected var FAddedReward:TInventories;
      
      protected var FRewardHonor:int;
      
      public function TSoliderReward()
      {
         super();
         this.FRewards = new TInventories();
         this.FAddedReward = new TInventories();
      }
      
      public function get SoliderName() : String
      {
         return this.FSoliderName;
      }
      
      public function set SoliderName(param1:String) : void
      {
         this.FSoliderName = param1;
      }
      
      public function get SoliderTempleteID() : uint
      {
         return this.FSoliderTempleteID;
      }
      
      public function set SoliderTempleteID(param1:uint) : void
      {
         this.FSoliderTempleteID = param1;
      }
      
      public function get KillNum() : int
      {
         return this.FKillNum;
      }
      
      public function set KillNum(param1:int) : void
      {
         this.FKillNum = param1;
      }
      
      public function get Rewards() : TInventories
      {
         return this.FRewards;
      }
      
      public function get AddedReward() : TInventories
      {
         return this.FAddedReward;
      }
      
      public function get RewardHonor() : int
      {
         return this.FRewardHonor;
      }
      
      public function set RewardHonor(param1:int) : void
      {
         this.FRewardHonor = param1;
      }
      
      public function get FriendAdded() : Boolean
      {
         return this.FFriendAdded;
      }
      
      public function set FriendAdded(param1:Boolean) : void
      {
         this.FFriendAdded = param1;
      }
      
      public function get GuideAdded() : Boolean
      {
         return this.FGuideAdded;
      }
      
      public function set GuideAdded(param1:Boolean) : void
      {
         this.FGuideAdded = param1;
      }
      
      public function Reset() : void
      {
         this.FSoliderName = null;
         this.FSoliderTempleteID = 0;
         this.FKillNum = 0;
         this.FRewards.Clear();
         this.FAddedReward.Clear();
         this.FRewardHonor = 0;
      }
   }
}

