package Logics.HDDuanwujie
{
   import Logics.DatebaseVO.VO.THDDuanwujiePet;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TDuanwujiePet extends TActivityOSBase
   {
      
      protected var FFundStatus:Vector.<int>;
      
      protected var FFundBoxes:Vector.<TInventories>;
      
      protected var FFundGIftStatus:int;
      
      protected var FFundGiftBox:TInventories;
      
      protected var FZongziStatus:Vector.<int>;
      
      protected var FZongziBoxes:Vector.<TInventories>;
      
      protected var FZongziNum:uint;
      
      protected var FServerZongziNum:uint;
      
      protected var FPetStatus:int;
      
      protected var FMailStatus:Vector.<int>;
      
      protected var FMailInvs:TInventories;
      
      protected var FConfig:THDDuanwujiePet;
      
      public function TDuanwujiePet()
      {
         super();
         this.FFundStatus = new Vector.<int>();
         this.FZongziStatus = new Vector.<int>();
         this.FFundBoxes = new Vector.<TInventories>();
         this.FFundGiftBox = new TInventories();
         this.FZongziBoxes = new Vector.<TInventories>();
         this.FMailStatus = new Vector.<int>();
         this.FMailInvs = new TInventories();
      }
      
      public function get FundStatus() : Vector.<int>
      {
         return this.FFundStatus;
      }
      
      public function set FundStatus(param1:Vector.<int>) : void
      {
         this.FFundStatus = param1;
      }
      
      public function get FundGIftStatus() : int
      {
         return this.FFundGIftStatus;
      }
      
      public function set FundGIftStatus(param1:int) : void
      {
         this.FFundGIftStatus = param1;
      }
      
      public function get ZongziStatus() : Vector.<int>
      {
         return this.FZongziStatus;
      }
      
      public function set ZongziStatus(param1:Vector.<int>) : void
      {
         this.FZongziStatus = param1;
      }
      
      public function get ZongziNum() : uint
      {
         return this.FZongziNum;
      }
      
      public function set ZongziNum(param1:uint) : void
      {
         this.FZongziNum = param1;
      }
      
      public function get ServerZongziNum() : uint
      {
         return this.FServerZongziNum;
      }
      
      public function set ServerZongziNum(param1:uint) : void
      {
         this.FServerZongziNum = param1;
      }
      
      public function get PetStatus() : int
      {
         return this.FPetStatus;
      }
      
      public function set PetStatus(param1:int) : void
      {
         this.FPetStatus = param1;
      }
      
      public function get FundBoxes() : Vector.<TInventories>
      {
         return this.FFundBoxes;
      }
      
      public function set FundBoxes(param1:Vector.<TInventories>) : void
      {
         this.FFundBoxes = param1;
      }
      
      public function get FundGiftBox() : TInventories
      {
         return this.FFundGiftBox;
      }
      
      public function set FundGiftBox(param1:TInventories) : void
      {
         this.FFundGiftBox = param1;
      }
      
      public function get ZongziBoxes() : Vector.<TInventories>
      {
         return this.FZongziBoxes;
      }
      
      public function set ZongziBoxes(param1:Vector.<TInventories>) : void
      {
         this.FZongziBoxes = param1;
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
      
      public function get Config() : THDDuanwujiePet
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDDuanwujiePet) : void
      {
         this.FConfig = param1;
      }
   }
}

