package Logics.HDKnifeChess
{
   import Logics.DatebaseVO.VO.THDKnifeChessRecharge;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TKnifeChessRecharge extends TActivityOSBase
   {
      
      protected var FConfig:THDKnifeChessRecharge;
      
      protected var FZoneHad:uint;
      
      protected var FHadRecharge:uint;
      
      protected var FToday:uint;
      
      protected var FBagStatus:Vector.<int>;
      
      protected var FBags:Vector.<TInventories>;
      
      public function TKnifeChessRecharge()
      {
         super();
         this.FBagStatus = new Vector.<int>(5);
         this.FBags = new Vector.<TInventories>();
      }
      
      public function get Config() : THDKnifeChessRecharge
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDKnifeChessRecharge) : void
      {
         this.FConfig = param1;
      }
      
      public function get ZoneHad() : uint
      {
         return this.FZoneHad;
      }
      
      public function set ZoneHad(param1:uint) : void
      {
         this.FZoneHad = param1;
      }
      
      public function get HadRecharge() : uint
      {
         return this.FHadRecharge;
      }
      
      public function set HadRecharge(param1:uint) : void
      {
         this.FHadRecharge = param1;
      }
      
      public function get BagStatus() : Vector.<int>
      {
         return this.FBagStatus;
      }
      
      public function set BagStatus(param1:Vector.<int>) : void
      {
         this.FBagStatus = param1;
      }
      
      public function get Bags() : Vector.<TInventories>
      {
         return this.FBags;
      }
      
      public function set Bags(param1:Vector.<TInventories>) : void
      {
         this.FBags = param1;
      }
      
      public function get Today() : uint
      {
         return this.FToday;
      }
      
      public function set Today(param1:uint) : void
      {
         this.FToday = param1;
      }
   }
}

