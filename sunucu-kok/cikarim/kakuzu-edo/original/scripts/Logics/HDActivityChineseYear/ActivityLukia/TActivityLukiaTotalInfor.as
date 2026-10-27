package Logics.HDActivityChineseYear.ActivityLukia
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityLukiaTotalInfor extends TActivityOSBase
   {
      
      protected var FActivityLukia:TActivityLukia;
      
      protected var FActivitySuperBag:TActivitySuperBag;
      
      protected var FActivityNiceBag:TActivityNiceBag;
      
      protected var FActivityExchangeBag:TActivityExchangeBag;
      
      protected var FActivityLukiaChip:TActivityLukiaChip;
      
      public function TActivityLukiaTotalInfor()
      {
         super();
      }
      
      public function get ActivityLukia() : TActivityLukia
      {
         return this.FActivityLukia;
      }
      
      public function set ActivityLukia(param1:TActivityLukia) : void
      {
         this.FActivityLukia = param1;
      }
      
      public function get ActivitySuperBag() : TActivitySuperBag
      {
         return this.FActivitySuperBag;
      }
      
      public function set ActivitySuperBag(param1:TActivitySuperBag) : void
      {
         this.FActivitySuperBag = param1;
      }
      
      public function get ActivityNiceBag() : TActivityNiceBag
      {
         return this.FActivityNiceBag;
      }
      
      public function set ActivityNiceBag(param1:TActivityNiceBag) : void
      {
         this.FActivityNiceBag = param1;
      }
      
      public function get ActivityExchangeBag() : TActivityExchangeBag
      {
         return this.FActivityExchangeBag;
      }
      
      public function set ActivityExchangeBag(param1:TActivityExchangeBag) : void
      {
         this.FActivityExchangeBag = param1;
      }
      
      public function get ActivityLukiaChip() : TActivityLukiaChip
      {
         return this.FActivityLukiaChip;
      }
      
      public function set ActivityLukiaChip(param1:TActivityLukiaChip) : void
      {
         this.FActivityLukiaChip = param1;
      }
      
      public function ChangeActivityState(param1:int, param2:int) : void
      {
         this.FActivityLukia.UpdateState(param1,param2);
         this.FActivitySuperBag.UpdateState(param1,param2);
         this.FActivityNiceBag.UpdateState(param1,param2);
         this.FActivityExchangeBag.UpdateState(param1,param2);
         this.FActivityLukiaChip.UpdateState(param1,param2);
      }
      
      public function FlushActivityData(param1:int, param2:int) : void
      {
         this.FActivityLukia.FlushActivityData(param1,param2);
         this.FActivitySuperBag.FlushActivityData(param1,param2);
         this.FActivityNiceBag.FlushActivityData(param1,param2);
         this.FActivityExchangeBag.FlushActivityData(param1,param2);
         this.FActivityLukiaChip.FlushActivityData(param1,param2);
      }
   }
}

