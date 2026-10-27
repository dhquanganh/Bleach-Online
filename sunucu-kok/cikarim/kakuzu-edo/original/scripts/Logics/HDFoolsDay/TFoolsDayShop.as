package Logics.HDFoolsDay
{
   import Logics.DatebaseVO.VO.THDFoolsDayShop;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   
   public class TFoolsDayShop extends TActivityOSBase
   {
      
      protected var FCurIns:Vector.<TInventory>;
      
      protected var FCurInsStatus:Vector.<int>;
      
      protected var FIsShowLuck:Boolean;
      
      protected var FPrice:int;
      
      protected var FScore:int;
      
      protected var FPoint:int;
      
      protected var FFree:int;
      
      protected var FMailStatus:Vector.<int>;
      
      protected var FMailInvs:TInventories;
      
      protected var FConfig:THDFoolsDayShop;
      
      public function TFoolsDayShop()
      {
         super();
         this.FCurIns = new Vector.<TInventory>();
         this.FMailStatus = new Vector.<int>();
         this.FCurInsStatus = new Vector.<int>();
      }
      
      public function get CurIns() : Vector.<TInventory>
      {
         return this.FCurIns;
      }
      
      public function set CurIns(param1:Vector.<TInventory>) : void
      {
         this.FCurIns = param1;
      }
      
      public function get IsShowLuck() : Boolean
      {
         return this.FIsShowLuck;
      }
      
      public function set IsShowLuck(param1:Boolean) : void
      {
         this.FIsShowLuck = param1;
      }
      
      public function get Price() : int
      {
         return this.FPrice;
      }
      
      public function set Price(param1:int) : void
      {
         this.FPrice = param1;
      }
      
      public function get Score() : int
      {
         return this.FScore;
      }
      
      public function set Score(param1:int) : void
      {
         this.FScore = param1;
      }
      
      public function get Point() : int
      {
         return this.FPoint;
      }
      
      public function set Point(param1:int) : void
      {
         this.FPoint = param1;
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
      
      public function get CurInsStatus() : Vector.<int>
      {
         return this.FCurInsStatus;
      }
      
      public function set CurInsStatus(param1:Vector.<int>) : void
      {
         this.FCurInsStatus = param1;
      }
      
      public function get Config() : THDFoolsDayShop
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDFoolsDayShop) : void
      {
         this.FConfig = param1;
      }
      
      public function get Free() : int
      {
         return this.FFree;
      }
      
      public function set Free(param1:int) : void
      {
         this.FFree = param1;
      }
   }
}

