package Logics.Inventories
{
   public class TInventoryWake extends TAppliance
   {
      
      protected var FHeroLevel:int;
      
      protected var FWakeProperties:Vector.<TInventoryProperty>;
      
      public function TInventoryWake(param1:uint)
      {
         super(param1);
         this.FWakeProperties = new Vector.<TInventoryProperty>();
      }
      
      public function get HeroLevel() : int
      {
         return this.FHeroLevel;
      }
      
      public function set HeroLevel(param1:int) : void
      {
         this.FHeroLevel = param1;
      }
      
      public function get WakeProperties() : Vector.<TInventoryProperty>
      {
         return this.FWakeProperties;
      }
      
      public function set WakeProperties(param1:Vector.<TInventoryProperty>) : void
      {
         this.FWakeProperties = param1;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FHeroLevel = 0;
         this.FWakeProperties.length = 0;
         FStackable = false;
         FStackableQuantityMax = 0;
      }
   }
}

