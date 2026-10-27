package Logics.VoidSoulWorld.VO
{
   public class TFormHeroVO
   {
      
      protected var FPos:uint;
      
      protected var FHeroID:uint;
      
      public function TFormHeroVO()
      {
         super();
      }
      
      public function get Pos() : uint
      {
         return this.FPos;
      }
      
      public function set Pos(param1:uint) : void
      {
         this.FPos = param1;
      }
      
      public function get HeroID() : uint
      {
         return this.FHeroID;
      }
      
      public function set HeroID(param1:uint) : void
      {
         this.FHeroID = param1;
      }
   }
}

