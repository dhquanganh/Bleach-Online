package Logics.HDLaborDay2016
{
   import Logics.DatebaseVO.VO.THDLaborDayCultivation;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TLaborDayCultivation extends TActivityOSBase
   {
      
      protected var FWaterCount:uint;
      
      protected var FWeedingCount:uint;
      
      protected var FScore:uint;
      
      protected var FBagStatus:Vector.<int>;
      
      protected var FGifts:Vector.<TInventories>;
      
      protected var FConfig:THDLaborDayCultivation;
      
      public function TLaborDayCultivation()
      {
         super();
         this.FGifts = new Vector.<TInventories>();
         this.FBagStatus = new Vector.<int>();
      }
      
      public function get WaterCount() : uint
      {
         return this.FWaterCount;
      }
      
      public function set WaterCount(param1:uint) : void
      {
         this.FWaterCount = param1;
      }
      
      public function get WeedingCount() : uint
      {
         return this.FWeedingCount;
      }
      
      public function set WeedingCount(param1:uint) : void
      {
         this.FWeedingCount = param1;
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
      
      public function get BagStatus() : Vector.<int>
      {
         return this.FBagStatus;
      }
      
      public function set BagStatus(param1:Vector.<int>) : void
      {
         this.FBagStatus = param1;
      }
      
      public function get Gifts() : Vector.<TInventories>
      {
         return this.FGifts;
      }
      
      public function set Gifts(param1:Vector.<TInventories>) : void
      {
         this.FGifts = param1;
      }
      
      public function get Config() : THDLaborDayCultivation
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDLaborDayCultivation) : void
      {
         this.FConfig = param1;
      }
   }
}

