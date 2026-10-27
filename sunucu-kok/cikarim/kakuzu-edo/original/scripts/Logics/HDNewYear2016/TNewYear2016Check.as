package Logics.HDNewYear2016
{
   import Logics.DatebaseVO.VO.THDNewYear2016Check;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.Common.TUtilityTool;
   
   public class TNewYear2016Check extends TActivityOSBase
   {
      
      protected var FConfig:THDNewYear2016Check;
      
      protected var FLeftGiftsStatus:Vector.<int>;
      
      protected var FRightGiftsStatus:Vector.<int>;
      
      protected var FLeftGifts:Vector.<TInventories>;
      
      protected var FRightGifts:Vector.<TInventories>;
      
      protected var FDayGifts:Vector.<TInventories>;
      
      protected var FDayStatus:Vector.<uint>;
      
      protected var FNowDay:int;
      
      protected var FRawCheckData:uint;
      
      public function TNewYear2016Check()
      {
         super();
         this.FLeftGifts = new Vector.<TInventories>();
         this.FRightGifts = new Vector.<TInventories>();
         this.FDayGifts = new Vector.<TInventories>();
         this.FLeftGiftsStatus = new Vector.<int>();
         this.FRightGiftsStatus = new Vector.<int>();
      }
      
      public function get Config() : THDNewYear2016Check
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDNewYear2016Check) : void
      {
         this.FConfig = param1;
      }
      
      public function get LeftGiftsStatus() : Vector.<int>
      {
         return this.FLeftGiftsStatus;
      }
      
      public function set LeftGiftsStatus(param1:Vector.<int>) : void
      {
         this.FLeftGiftsStatus = param1;
      }
      
      public function get RightGiftsStatus() : Vector.<int>
      {
         return this.FRightGiftsStatus;
      }
      
      public function set RightGiftsStatus(param1:Vector.<int>) : void
      {
         this.FRightGiftsStatus = param1;
      }
      
      public function get NowDay() : int
      {
         return this.FNowDay;
      }
      
      public function set NowDay(param1:int) : void
      {
         this.FNowDay = param1;
      }
      
      public function get RawCheckData() : uint
      {
         return this.FRawCheckData;
      }
      
      public function set RawCheckData(param1:uint) : void
      {
         this.FRawCheckData = param1;
         this.BuildDayStatus();
      }
      
      protected function BuildDayStatus() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FDayStatus = new Vector.<uint>(10);
         _loc1_ = this.FRawCheckData;
         _loc3_ = 0;
         while(_loc1_ > 0)
         {
            _loc2_ = TUtilityTool.GetValueByBit(_loc1_,0);
            _loc1_ >>= 1;
            this.FDayStatus[_loc3_] = _loc2_;
            _loc3_++;
         }
      }
      
      public function get CheckedDays() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = 0;
         _loc1_ = this.FRawCheckData;
         while(_loc1_ > 0)
         {
            if(TUtilityTool.GetValueByBit(_loc1_,0) == 1)
            {
               _loc2_++;
            }
            _loc1_ >>= 1;
         }
         return _loc2_;
      }
      
      public function get LeftGifts() : Vector.<TInventories>
      {
         return this.FLeftGifts;
      }
      
      public function set LeftGifts(param1:Vector.<TInventories>) : void
      {
         this.FLeftGifts = param1;
      }
      
      public function get RightGifts() : Vector.<TInventories>
      {
         return this.FRightGifts;
      }
      
      public function set RightGifts(param1:Vector.<TInventories>) : void
      {
         this.FRightGifts = param1;
      }
      
      public function get DayGifts() : Vector.<TInventories>
      {
         return this.FDayGifts;
      }
      
      public function set DayGifts(param1:Vector.<TInventories>) : void
      {
         this.FDayGifts = param1;
      }
      
      public function get DayStatus() : Vector.<uint>
      {
         return this.FDayStatus;
      }
   }
}

