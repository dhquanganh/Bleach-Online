package Logics.HDActivityHalloween
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityHalloweenPayData extends TActivityOSBase
   {
      
      protected var FPayBagStatus:int;
      
      protected var FRandBagStatus:int;
      
      protected var FDayBagStatus:int;
      
      protected var FRevBagStatus:Vector.<int>;
      
      protected var FAllServerBagStatus:Vector.<int>;
      
      protected var FRevBagNum:uint;
      
      protected var FAllServerBagNum:uint;
      
      protected var FCurDay:uint;
      
      public function TActivityHalloweenPayData()
      {
         super();
         this.FRevBagStatus = new Vector.<int>(5);
         this.FAllServerBagStatus = new Vector.<int>(5);
      }
      
      public function get PayBagStatus() : int
      {
         return this.FPayBagStatus;
      }
      
      public function set PayBagStatus(param1:int) : void
      {
         this.FPayBagStatus = param1;
      }
      
      public function get RandBagStatus() : int
      {
         return this.FRandBagStatus;
      }
      
      public function set RandBagStatus(param1:int) : void
      {
         this.FRandBagStatus = param1;
      }
      
      public function get DayBagStatus() : int
      {
         return this.FDayBagStatus;
      }
      
      public function set DayBagStatus(param1:int) : void
      {
         this.FDayBagStatus = param1;
      }
      
      public function get RevBagStatus() : Vector.<int>
      {
         return this.FRevBagStatus;
      }
      
      public function set RevBagStatus(param1:Vector.<int>) : void
      {
         this.FRevBagStatus = param1;
      }
      
      public function get RevBagNum() : uint
      {
         return this.FRevBagNum;
      }
      
      public function set RevBagNum(param1:uint) : void
      {
         this.FRevBagNum = param1;
      }
      
      public function get AllServerBagNum() : uint
      {
         return this.FAllServerBagNum;
      }
      
      public function set AllServerBagNum(param1:uint) : void
      {
         this.FAllServerBagNum = param1;
      }
      
      public function get AllServerBagStatus() : Vector.<int>
      {
         return this.FAllServerBagStatus;
      }
      
      public function set AllServerBagStatus(param1:Vector.<int>) : void
      {
         this.FAllServerBagStatus = param1;
      }
      
      public function get CurDay() : uint
      {
         return this.FCurDay;
      }
      
      public function set CurDay(param1:uint) : void
      {
         this.FCurDay = param1;
      }
   }
}

