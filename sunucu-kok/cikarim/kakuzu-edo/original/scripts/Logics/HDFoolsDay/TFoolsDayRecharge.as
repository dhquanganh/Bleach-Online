package Logics.HDFoolsDay
{
   import Logics.DatebaseVO.VO.THDFoolsDayRecharge;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TFoolsDayRecharge extends TActivityOSBase
   {
      
      protected var FCurBag:TInventories;
      
      protected var FCurStatus:int;
      
      protected var FProgressStatus:Vector.<int>;
      
      protected var FProgressBags:Vector.<TInventories>;
      
      protected var FJackPointStatus:int;
      
      protected var FRecharge:uint;
      
      protected var FConfig:THDFoolsDayRecharge;
      
      public function TFoolsDayRecharge()
      {
         super();
         this.FCurBag = new TInventories();
         this.FProgressStatus = new Vector.<int>();
         this.FProgressBags = new Vector.<TInventories>();
      }
      
      public function get CurBag() : TInventories
      {
         return this.FCurBag;
      }
      
      public function set CurBag(param1:TInventories) : void
      {
         this.FCurBag = param1;
      }
      
      public function get CurStatus() : int
      {
         return this.FCurStatus;
      }
      
      public function set CurStatus(param1:int) : void
      {
         this.FCurStatus = param1;
      }
      
      public function get ProgressStatus() : Vector.<int>
      {
         return this.FProgressStatus;
      }
      
      public function set ProgressStatus(param1:Vector.<int>) : void
      {
         this.FProgressStatus = param1;
      }
      
      public function get ProgressBags() : Vector.<TInventories>
      {
         return this.FProgressBags;
      }
      
      public function set ProgressBags(param1:Vector.<TInventories>) : void
      {
         this.FProgressBags = param1;
      }
      
      public function get JackPointStatus() : int
      {
         return this.FJackPointStatus;
      }
      
      public function set JackPointStatus(param1:int) : void
      {
         this.FJackPointStatus = param1;
      }
      
      public function get Recharge() : uint
      {
         return this.FRecharge;
      }
      
      public function set Recharge(param1:uint) : void
      {
         this.FRecharge = param1;
      }
      
      public function get Config() : THDFoolsDayRecharge
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDFoolsDayRecharge) : void
      {
         this.FConfig = param1;
      }
   }
}

