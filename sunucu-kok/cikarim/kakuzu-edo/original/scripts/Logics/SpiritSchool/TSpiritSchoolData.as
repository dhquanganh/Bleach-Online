package Logics.SpiritSchool
{
   public class TSpiritSchoolData
   {
      
      public static const CAPITATY:uint = 6;
      
      protected var FNowLv:uint;
      
      protected var FFreeNum:uint;
      
      protected var FSsItems:Vector.<TSpiritSchoolItem>;
      
      protected var FIsOver:uint;
      
      public function TSpiritSchoolData()
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TSpiritSchoolItem = null;
         super();
         this.FNowLv = 0;
         this.FFreeNum = 0;
         this.FIsOver = 0;
         this.FSsItems = new Vector.<TSpiritSchoolItem>(CAPITATY);
         _loc1_ = 0;
         while(_loc1_ < CAPITATY)
         {
            _loc3_ = new TSpiritSchoolItem();
            this.FSsItems[_loc1_] = _loc3_;
            _loc1_++;
         }
      }
      
      public function get NowLv() : uint
      {
         return this.FNowLv;
      }
      
      public function set NowLv(param1:uint) : void
      {
         this.FNowLv = param1;
      }
      
      public function get FreeNum() : uint
      {
         return this.FFreeNum;
      }
      
      public function set FreeNum(param1:uint) : void
      {
         this.FFreeNum = param1;
      }
      
      public function get SsItems() : Vector.<TSpiritSchoolItem>
      {
         return this.FSsItems;
      }
      
      public function set SsItems(param1:Vector.<TSpiritSchoolItem>) : void
      {
         this.FSsItems = param1;
      }
      
      public function get IsOver() : uint
      {
         return this.FIsOver;
      }
      
      public function set IsOver(param1:uint) : void
      {
         this.FIsOver = param1;
      }
   }
}

