package Logics.SoulCollection
{
   import Logics.Inventories.TInventories;
   
   public class TCollectSoul
   {
      
      protected var FDayNum:uint;
      
      protected var FVipCount:uint;
      
      protected var FJuniorTimer:uint;
      
      protected var FSeniorTimer_0:uint;
      
      protected var FSeniorTimer_1:uint;
      
      protected var FEnergy:uint;
      
      protected var FCargoStatus:Vector.<int>;
      
      protected var FSuperInvs:TInventories;
      
      protected var FRetInvs:TInventories;
      
      protected var FSilverFreeCount:uint;
      
      public function TCollectSoul()
      {
         super();
         this.FCargoStatus = new Vector.<int>();
         this.FSuperInvs = new TInventories();
         this.FRetInvs = new TInventories();
      }
      
      public function get DayNum() : uint
      {
         return this.FDayNum;
      }
      
      public function set DayNum(param1:uint) : void
      {
         this.FDayNum = param1;
      }
      
      public function get JuniorTimer() : uint
      {
         return this.FJuniorTimer;
      }
      
      public function set JuniorTimer(param1:uint) : void
      {
         this.FJuniorTimer = param1;
      }
      
      public function get SeniorTimer_0() : uint
      {
         return this.FSeniorTimer_0;
      }
      
      public function set SeniorTimer_0(param1:uint) : void
      {
         this.FSeniorTimer_0 = param1;
      }
      
      public function get SeniorTimer_1() : uint
      {
         return this.FSeniorTimer_1;
      }
      
      public function set SeniorTimer_1(param1:uint) : void
      {
         this.FSeniorTimer_1 = param1;
      }
      
      public function get Energy() : uint
      {
         return this.FEnergy;
      }
      
      public function set Energy(param1:uint) : void
      {
         this.FEnergy = param1;
      }
      
      public function get CargoStatus() : Vector.<int>
      {
         return this.FCargoStatus;
      }
      
      public function set CargoStatus(param1:Vector.<int>) : void
      {
         this.FCargoStatus = param1;
      }
      
      public function get SuperInvs() : TInventories
      {
         return this.FSuperInvs;
      }
      
      public function set SuperInvs(param1:TInventories) : void
      {
         this.FSuperInvs = param1;
      }
      
      public function get RetInvs() : TInventories
      {
         return this.FRetInvs;
      }
      
      public function set RetInvs(param1:TInventories) : void
      {
         this.FRetInvs = param1;
      }
      
      public function get VipCount() : uint
      {
         return this.FVipCount;
      }
      
      public function set VipCount(param1:uint) : void
      {
         this.FVipCount = param1;
      }
      
      public function get SilverFreeCount() : uint
      {
         return this.FSilverFreeCount;
      }
      
      public function set SilverFreeCount(param1:uint) : void
      {
         this.FSilverFreeCount = param1;
      }
   }
}

