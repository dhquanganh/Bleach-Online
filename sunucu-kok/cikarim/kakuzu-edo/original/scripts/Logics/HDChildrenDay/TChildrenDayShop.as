package Logics.HDChildrenDay
{
   import Logics.DatebaseVO.VO.THDChildrenDayShop;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TChildrenDayShop extends TActivityOSBase
   {
      
      protected var FBags_Award:Vector.<TInventories>;
      
      protected var FBagStatus:Vector.<int>;
      
      protected var FScore:uint;
      
      protected var FTodayPay:uint;
      
      protected var FMailStatus:Vector.<int>;
      
      protected var FMailInvs:TInventories;
      
      protected var FMailMoneyStatus:Vector.<int>;
      
      protected var FMailMoneyInvs:TInventories;
      
      protected var FConfig:THDChildrenDayShop;
      
      public function TChildrenDayShop()
      {
         super();
         this.FBags_Award = new Vector.<TInventories>(6);
         this.FBagStatus = new Vector.<int>(6);
         this.FMailStatus = new Vector.<int>();
         this.FMailInvs = new TInventories();
         this.FMailMoneyStatus = new Vector.<int>();
         this.FMailMoneyInvs = new TInventories();
      }
      
      public function get Bags_Award() : Vector.<TInventories>
      {
         return this.FBags_Award;
      }
      
      public function set Bags_Award(param1:Vector.<TInventories>) : void
      {
         this.FBags_Award = param1;
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
      
      public function get MailStatus() : Vector.<int>
      {
         return this.FMailStatus;
      }
      
      public function set MailStatus(param1:Vector.<int>) : void
      {
         this.FMailStatus = param1;
      }
      
      public function get MailInvs() : TInventories
      {
         return this.FMailInvs;
      }
      
      public function set MailInvs(param1:TInventories) : void
      {
         this.FMailInvs = param1;
      }
      
      public function get MailMoneyStatus() : Vector.<int>
      {
         return this.FMailMoneyStatus;
      }
      
      public function set MailMoneyStatus(param1:Vector.<int>) : void
      {
         this.FMailMoneyStatus = param1;
      }
      
      public function get MailMoneyInvs() : TInventories
      {
         return this.FMailMoneyInvs;
      }
      
      public function set MailMoneyInvs(param1:TInventories) : void
      {
         this.FMailMoneyInvs = param1;
      }
      
      public function get Config() : THDChildrenDayShop
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDChildrenDayShop) : void
      {
         this.FConfig = param1;
      }
      
      public function get BagStatus() : Vector.<int>
      {
         return this.FBagStatus;
      }
      
      public function set BagStatus(param1:Vector.<int>) : void
      {
         this.FBagStatus = param1;
      }
      
      public function get TodayPay() : uint
      {
         return this.FTodayPay;
      }
      
      public function set TodayPay(param1:uint) : void
      {
         this.FTodayPay = param1;
      }
   }
}

