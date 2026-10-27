package Logics.BleachTrain
{
   import Logics.DatebaseVO.VO.TGrowRoadTask;
   import Logics.Inventories.TInventories;
   
   public class TBleachTrainData
   {
      
      public static const NormalRewardIndex:int = 0;
      
      public static const VipRewardIndex:int = 1;
      
      protected var FGrowRoadTask:TGrowRoadTask;
      
      protected var FRewards:TInventories;
      
      protected var FCurrentScheduel:int;
      
      protected var FIfOpen:Boolean;
      
      protected var FIfGotReward:Boolean;
      
      protected var FIfCanGotReward:Boolean;
      
      public function TBleachTrainData()
      {
         super();
         this.FRewards = new TInventories();
      }
      
      public function get GrowRoadTask() : TGrowRoadTask
      {
         return this.FGrowRoadTask;
      }
      
      public function set GrowRoadTask(param1:TGrowRoadTask) : void
      {
         this.FGrowRoadTask = param1;
      }
      
      public function get IfOpen() : Boolean
      {
         return this.FIfOpen;
      }
      
      public function set IfOpen(param1:Boolean) : void
      {
         this.FIfOpen = param1;
      }
      
      public function get IfGotReward() : Boolean
      {
         return this.FIfGotReward;
      }
      
      public function set IfGotReward(param1:Boolean) : void
      {
         this.FIfGotReward = param1;
      }
      
      public function get IfCanGotReward() : Boolean
      {
         return this.FIfCanGotReward;
      }
      
      public function set IfCanGotReward(param1:Boolean) : void
      {
         this.FIfCanGotReward = param1;
      }
      
      public function get CurrentScheduel() : int
      {
         return this.FCurrentScheduel;
      }
      
      public function set CurrentScheduel(param1:int) : void
      {
         this.FCurrentScheduel = param1;
      }
      
      public function get Rewards() : TInventories
      {
         return this.FRewards;
      }
   }
}

