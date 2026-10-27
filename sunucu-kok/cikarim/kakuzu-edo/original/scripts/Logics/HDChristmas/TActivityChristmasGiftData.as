package Logics.HDChristmas
{
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TActivityChristmasGiftData extends TActivityOSBase
   {
      
      protected var FCurDay:int;
      
      protected var FRechargeAwardStatus:int;
      
      protected var FDayAwardStatus:int;
      
      protected var FBuyCount:int;
      
      protected var FBagBuyStatusVec:Vector.<int>;
      
      protected var FBagGetStatusVec:Vector.<int>;
      
      protected var FRechargeInventories:TInventories;
      
      protected var FDayInventories:TInventories;
      
      protected var FBagBuyInventoriesVec:Vector.<TInventories>;
      
      protected var FBagGetInventoriesVec:Vector.<TInventories>;
      
      public function TActivityChristmasGiftData()
      {
         super();
         this.FBagBuyStatusVec = new Vector.<int>();
         this.FBagGetStatusVec = new Vector.<int>();
         this.FBagBuyInventoriesVec = new Vector.<TInventories>();
         this.FBagGetInventoriesVec = new Vector.<TInventories>();
      }
      
      public function get RechargeAwardStatus() : int
      {
         return this.FRechargeAwardStatus;
      }
      
      public function set RechargeAwardStatus(param1:int) : void
      {
         this.FRechargeAwardStatus = param1;
      }
      
      public function get DayAwardStatus() : int
      {
         return this.FDayAwardStatus;
      }
      
      public function set DayAwardStatus(param1:int) : void
      {
         this.FDayAwardStatus = param1;
      }
      
      public function get BuyCount() : int
      {
         return this.FBuyCount;
      }
      
      public function set BuyCount(param1:int) : void
      {
         this.FBuyCount = param1;
      }
      
      public function get BagBuyStatusVec() : Vector.<int>
      {
         return this.FBagBuyStatusVec;
      }
      
      public function set BagBuyStatusVec(param1:Vector.<int>) : void
      {
         this.FBagBuyStatusVec = param1;
      }
      
      public function get BagGetStatusVec() : Vector.<int>
      {
         return this.FBagGetStatusVec;
      }
      
      public function set BagGetStatusVec(param1:Vector.<int>) : void
      {
         this.FBagGetStatusVec = param1;
      }
      
      public function get CurDay() : int
      {
         return this.FCurDay;
      }
      
      public function set CurDay(param1:int) : void
      {
         this.FCurDay = param1;
      }
      
      public function get RechargeInventories() : TInventories
      {
         return this.FRechargeInventories;
      }
      
      public function set RechargeInventories(param1:TInventories) : void
      {
         this.FRechargeInventories = param1;
      }
      
      public function get DayInventories() : TInventories
      {
         return this.FDayInventories;
      }
      
      public function set DayInventories(param1:TInventories) : void
      {
         this.FDayInventories = param1;
      }
      
      public function get BagBuyInventoriesVec() : Vector.<TInventories>
      {
         return this.FBagBuyInventoriesVec;
      }
      
      public function get BagGetInventoriesVec() : Vector.<TInventories>
      {
         return this.FBagGetInventoriesVec;
      }
   }
}

