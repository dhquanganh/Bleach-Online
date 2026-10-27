package Logics.HDSoulCarnival
{
   import Logics.DatebaseVO.VO.THDSoulRecharge;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TSoulRecharge extends TActivityOSBase
   {
      
      protected var FCount:Vector.<int>;
      
      protected var FInvsVect:Vector.<TInventories>;
      
      protected var FConfig:THDSoulRecharge;
      
      public function TSoulRecharge()
      {
         super();
         this.FCount = new Vector.<int>(5);
         this.FInvsVect = new Vector.<TInventories>(5);
      }
      
      public function get Count() : Vector.<int>
      {
         return this.FCount;
      }
      
      public function set Count(param1:Vector.<int>) : void
      {
         this.FCount = param1;
      }
      
      public function get Config() : THDSoulRecharge
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDSoulRecharge) : void
      {
         this.FConfig = param1;
      }
      
      public function get InvsVect() : Vector.<TInventories>
      {
         return this.FInvsVect;
      }
      
      public function set InvsVect(param1:Vector.<TInventories>) : void
      {
         this.FInvsVect = param1;
      }
   }
}

