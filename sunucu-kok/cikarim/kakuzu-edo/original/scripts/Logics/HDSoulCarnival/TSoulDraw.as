package Logics.HDSoulCarnival
{
   import Logics.DatebaseVO.VO.THDSoulDraw;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   
   public class TSoulDraw extends TActivityOSBase
   {
      
      protected var FCurGoldAward:TInventories;
      
      protected var FCurGoldIndex:uint;
      
      protected var FCurFreeAward:Vector.<TInventory>;
      
      protected var FShowGoldAward:TInventories;
      
      protected var FShowFreeAward:TInventories;
      
      protected var FConfig:THDSoulDraw;
      
      public function TSoulDraw()
      {
         super();
         this.FCurGoldAward = new TInventories();
         this.FCurFreeAward = new Vector.<TInventory>();
         this.FShowGoldAward = new TInventories();
         this.FShowFreeAward = new TInventories();
      }
      
      public function get CurGoldAward() : TInventories
      {
         return this.FCurGoldAward;
      }
      
      public function set CurGoldAward(param1:TInventories) : void
      {
         this.FCurGoldAward = param1;
      }
      
      public function get CurFreeAward() : Vector.<TInventory>
      {
         return this.FCurFreeAward;
      }
      
      public function set CurFreeAward(param1:Vector.<TInventory>) : void
      {
         this.FCurFreeAward = param1;
      }
      
      public function get Config() : THDSoulDraw
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDSoulDraw) : void
      {
         this.FConfig = param1;
      }
      
      public function get ShowGoldAward() : TInventories
      {
         return this.FShowGoldAward;
      }
      
      public function set ShowGoldAward(param1:TInventories) : void
      {
         this.FShowGoldAward = param1;
      }
      
      public function get ShowFreeAward() : TInventories
      {
         return this.FShowFreeAward;
      }
      
      public function set ShowFreeAward(param1:TInventories) : void
      {
         this.FShowFreeAward = param1;
      }
      
      public function get CurGoldIndex() : uint
      {
         return this.FCurGoldIndex;
      }
      
      public function set CurGoldIndex(param1:uint) : void
      {
         this.FCurGoldIndex = param1;
      }
   }
}

