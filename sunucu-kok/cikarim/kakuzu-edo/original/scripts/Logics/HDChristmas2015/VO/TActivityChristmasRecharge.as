package Logics.HDChristmas2015.VO
{
   import Logics.DatebaseVO.VO.THDChrismasRecharge;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TActivityChristmasRecharge extends TActivityOSBase
   {
      
      protected var FFree:int;
      
      protected var FRecharged:int;
      
      protected var FCards:int;
      
      protected var FGifts:Vector.<TInventories>;
      
      protected var FGiftStatus:Vector.<int>;
      
      protected var FConfig:THDChrismasRecharge;
      
      public function TActivityChristmasRecharge()
      {
         super();
         this.FGifts = new Vector.<TInventories>();
         this.FGiftStatus = new Vector.<int>();
      }
      
      public function get Free() : int
      {
         return this.FFree;
      }
      
      public function set Free(param1:int) : void
      {
         this.FFree = param1;
      }
      
      public function get Recharged() : int
      {
         return this.FRecharged;
      }
      
      public function set Recharged(param1:int) : void
      {
         this.FRecharged = param1;
      }
      
      public function get Cards() : int
      {
         return this.FCards;
      }
      
      public function set Cards(param1:int) : void
      {
         this.FCards = param1;
      }
      
      public function get Gifts() : Vector.<TInventories>
      {
         return this.FGifts;
      }
      
      public function set Gifts(param1:Vector.<TInventories>) : void
      {
         this.FGifts = param1;
      }
      
      public function get Config() : THDChrismasRecharge
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDChrismasRecharge) : void
      {
         this.FConfig = param1;
      }
      
      public function get GiftStatus() : Vector.<int>
      {
         return this.FGiftStatus;
      }
      
      public function set GiftStatus(param1:Vector.<int>) : void
      {
         this.FGiftStatus = param1;
      }
   }
}

