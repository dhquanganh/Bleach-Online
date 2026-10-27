package Logics.HDNewYear2016
{
   import Logics.DatebaseVO.VO.THDNewYear2016Fund;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TNewYear2016Fund extends TActivityOSBase
   {
      
      protected var FFundStatus:Vector.<int>;
      
      protected var FBagsStatus:Vector.<int>;
      
      protected var FBagsIns:Vector.<TInventories>;
      
      protected var FRecharge:uint;
      
      protected var FConfig:THDNewYear2016Fund;
      
      public function TNewYear2016Fund()
      {
         super();
         this.FFundStatus = new Vector.<int>();
         this.FBagsStatus = new Vector.<int>();
         this.FBagsIns = new Vector.<TInventories>();
      }
      
      public function get FundStatus() : Vector.<int>
      {
         return this.FFundStatus;
      }
      
      public function set FundStatus(param1:Vector.<int>) : void
      {
         this.FFundStatus = param1;
      }
      
      public function get BagsStatus() : Vector.<int>
      {
         return this.FBagsStatus;
      }
      
      public function set BagsStatus(param1:Vector.<int>) : void
      {
         this.FBagsStatus = param1;
      }
      
      public function get Recharge() : uint
      {
         return this.FRecharge;
      }
      
      public function set Recharge(param1:uint) : void
      {
         this.FRecharge = param1;
      }
      
      public function get Config() : THDNewYear2016Fund
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDNewYear2016Fund) : void
      {
         this.FConfig = param1;
      }
      
      public function get BagsIns() : Vector.<TInventories>
      {
         return this.FBagsIns;
      }
      
      public function set BagsIns(param1:Vector.<TInventories>) : void
      {
         this.FBagsIns = param1;
      }
   }
}

