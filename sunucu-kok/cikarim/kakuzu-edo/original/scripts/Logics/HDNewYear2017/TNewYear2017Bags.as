package Logics.HDNewYear2017
{
   import Logics.DatebaseVO.VO.THDNewYear2017Bags;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TNewYear2017Bags extends TActivityOSBase
   {
      
      protected var FBag_0Last:uint;
      
      protected var FBag_1Last:uint;
      
      protected var FBag_Award_0:Vector.<TInventories>;
      
      protected var FBag_Award_1:Vector.<TInventories>;
      
      protected var FScore:uint;
      
      protected var FMailStatus:Vector.<int>;
      
      protected var FMailInvs:TInventories;
      
      protected var FConfig:THDNewYear2017Bags;
      
      public function TNewYear2017Bags()
      {
         super();
         this.FBag_Award_0 = new Vector.<TInventories>();
         this.FBag_Award_1 = new Vector.<TInventories>();
         this.FMailStatus = new Vector.<int>();
         this.FMailInvs = new TInventories();
      }
      
      public function get Bag_0Last() : uint
      {
         return this.FBag_0Last;
      }
      
      public function set Bag_0Last(param1:uint) : void
      {
         this.FBag_0Last = param1;
      }
      
      public function get Bag_1Last() : uint
      {
         return this.FBag_1Last;
      }
      
      public function set Bag_1Last(param1:uint) : void
      {
         this.FBag_1Last = param1;
      }
      
      public function get Bag_Award_0() : Vector.<TInventories>
      {
         return this.FBag_Award_0;
      }
      
      public function set Bag_Award_0(param1:Vector.<TInventories>) : void
      {
         this.FBag_Award_0 = param1;
      }
      
      public function get Bag_Award_1() : Vector.<TInventories>
      {
         return this.FBag_Award_1;
      }
      
      public function set Bag_Award_1(param1:Vector.<TInventories>) : void
      {
         this.FBag_Award_1 = param1;
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
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
      
      public function get Config() : THDNewYear2017Bags
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDNewYear2017Bags) : void
      {
         this.FConfig = param1;
      }
   }
}

