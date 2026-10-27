package Logics.BleachTrain
{
   import Logics.Inventories.TInventories;
   
   public class TBleachTrainVipBag
   {
      
      protected var FRewards:TInventories;
      
      protected var FIfSelled:Boolean;
      
      protected var FAwardID:uint;
      
      protected var FIcon:int;
      
      protected var FVipNeed:int;
      
      protected var FRewardDiscount:int;
      
      protected var FRewardOriginal:int;
      
      protected var FRewardPrice:int;
      
      public function TBleachTrainVipBag()
      {
         super();
         this.FRewards = new TInventories();
      }
      
      public function get Rewards() : TInventories
      {
         return this.FRewards;
      }
      
      public function get Icon() : int
      {
         return this.FIcon;
      }
      
      public function set Icon(param1:int) : void
      {
         this.FIcon = param1;
      }
      
      public function get VipNeed() : int
      {
         return this.FVipNeed;
      }
      
      public function set VipNeed(param1:int) : void
      {
         this.FVipNeed = param1;
      }
      
      public function get RewardDiscount() : int
      {
         return this.FRewardDiscount;
      }
      
      public function set RewardDiscount(param1:int) : void
      {
         this.FRewardDiscount = param1;
      }
      
      public function get RewardOriginal() : int
      {
         return this.FRewardOriginal;
      }
      
      public function set RewardOriginal(param1:int) : void
      {
         this.FRewardOriginal = param1;
      }
      
      public function get RewardPrice() : int
      {
         return this.FRewardPrice;
      }
      
      public function set RewardPrice(param1:int) : void
      {
         this.FRewardPrice = param1;
      }
      
      public function get AwardID() : uint
      {
         return this.FAwardID;
      }
      
      public function set AwardID(param1:uint) : void
      {
         this.FAwardID = param1;
      }
      
      public function get IfSelled() : Boolean
      {
         return this.FIfSelled;
      }
      
      public function set IfSelled(param1:Boolean) : void
      {
         this.FIfSelled = param1;
      }
   }
}

