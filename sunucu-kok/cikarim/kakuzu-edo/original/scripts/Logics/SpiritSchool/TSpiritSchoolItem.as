package Logics.SpiritSchool
{
   public class TSpiritSchoolItem
   {
      
      protected var FIndex:uint;
      
      protected var FNowLv:uint;
      
      protected var FNowExp:uint;
      
      protected var FExpMax:uint;
      
      protected var FEffectName:String;
      
      protected var FAddValue:uint;
      
      protected var FAddValueNext:uint;
      
      protected var FStatus:int;
      
      public function TSpiritSchoolItem()
      {
         super();
      }
      
      public function get Index() : uint
      {
         return this.FIndex;
      }
      
      public function set Index(param1:uint) : void
      {
         this.FIndex = param1;
      }
      
      public function get NowLv() : uint
      {
         return this.FNowLv;
      }
      
      public function set NowLv(param1:uint) : void
      {
         this.FNowLv = param1;
      }
      
      public function get NowExp() : uint
      {
         return this.FNowExp;
      }
      
      public function set NowExp(param1:uint) : void
      {
         this.FNowExp = param1;
      }
      
      public function get ExpMax() : uint
      {
         return this.FExpMax;
      }
      
      public function set ExpMax(param1:uint) : void
      {
         this.FExpMax = param1;
      }
      
      public function get EffectName() : String
      {
         return this.FEffectName;
      }
      
      public function set EffectName(param1:String) : void
      {
         this.FEffectName = param1;
      }
      
      public function get AddValue() : uint
      {
         return this.FAddValue;
      }
      
      public function set AddValue(param1:uint) : void
      {
         this.FAddValue = param1;
      }
      
      public function get AddValueNext() : uint
      {
         return this.FAddValueNext;
      }
      
      public function set AddValueNext(param1:uint) : void
      {
         this.FAddValueNext = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
   }
}

