package Logics.KnifeOfKillSoul.VO
{
   public class TKnifeStrengthenPhase
   {
      
      protected var FActivate:Boolean;
      
      protected var FHeroID:Vector.<int>;
      
      protected var FAttribute:Vector.<Object>;
      
      protected var FIconID:Vector.<int>;
      
      public function TKnifeStrengthenPhase()
      {
         super();
      }
      
      public function get Activate() : Boolean
      {
         return this.FActivate;
      }
      
      public function set Activate(param1:Boolean) : void
      {
         this.FActivate = param1;
      }
      
      public function get HeroID() : Vector.<int>
      {
         return this.FHeroID;
      }
      
      public function set HeroID(param1:Vector.<int>) : void
      {
         this.FHeroID = param1;
      }
      
      public function get Attribute() : Vector.<Object>
      {
         return this.FAttribute;
      }
      
      public function set Attribute(param1:Vector.<Object>) : void
      {
         this.FAttribute = param1;
      }
      
      public function get IconID() : Vector.<int>
      {
         return this.FIconID;
      }
      
      public function set IconID(param1:Vector.<int>) : void
      {
         this.FIconID = param1;
      }
   }
}

