package Logics.HDNationalDay2017
{
   import Logics.DatebaseVO.VO.THDNationalDayOne2017;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TNationalDay2017One extends TActivityOSBase
   {
      
      protected var FLeftBagsStatus:Vector.<int>;
      
      protected var FLeftInvs:TInventories;
      
      protected var FDayStatus:Vector.<int>;
      
      protected var FNowDay:uint;
      
      protected var FDayInvs:TInventories;
      
      protected var FRightBagsStatus:Vector.<int>;
      
      protected var FRightBags:Vector.<TInventories>;
      
      protected var FConfig:THDNationalDayOne2017;
      
      public function TNationalDay2017One()
      {
         super();
         this.FLeftBagsStatus = new Vector.<int>();
         this.FLeftInvs = new TInventories();
         this.FDayStatus = new Vector.<int>(10);
         this.FDayInvs = new TInventories();
         this.FRightBagsStatus = new Vector.<int>();
         this.FRightBags = new Vector.<TInventories>();
      }
      
      public function get LeftBagsStatus() : Vector.<int>
      {
         return this.FLeftBagsStatus;
      }
      
      public function set LeftBagsStatus(param1:Vector.<int>) : void
      {
         this.FLeftBagsStatus = param1;
      }
      
      public function get LeftInvs() : TInventories
      {
         return this.FLeftInvs;
      }
      
      public function set LeftInvs(param1:TInventories) : void
      {
         this.FLeftInvs = param1;
      }
      
      public function get DayStatus() : Vector.<int>
      {
         return this.FDayStatus;
      }
      
      public function set DayStatus(param1:Vector.<int>) : void
      {
         this.FDayStatus = param1;
      }
      
      public function get DayInvs() : TInventories
      {
         return this.FDayInvs;
      }
      
      public function set DayInvs(param1:TInventories) : void
      {
         this.FDayInvs = param1;
      }
      
      public function get RightBagsStatus() : Vector.<int>
      {
         return this.FRightBagsStatus;
      }
      
      public function set RightBagsStatus(param1:Vector.<int>) : void
      {
         this.FRightBagsStatus = param1;
      }
      
      public function get RightBags() : Vector.<TInventories>
      {
         return this.FRightBags;
      }
      
      public function set RightBags(param1:Vector.<TInventories>) : void
      {
         this.FRightBags = param1;
      }
      
      public function get Config() : THDNationalDayOne2017
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDNationalDayOne2017) : void
      {
         this.FConfig = param1;
      }
      
      public function get NowDay() : uint
      {
         return this.FNowDay;
      }
      
      public function set NowDay(param1:uint) : void
      {
         this.FNowDay = param1;
      }
      
      public function get CheckedDays() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         _loc3_ = 0;
         _loc1_ = 10;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.DayStatus[_loc2_] == -1)
            {
               _loc3_++;
            }
            _loc2_++;
         }
         return _loc3_;
      }
   }
}

