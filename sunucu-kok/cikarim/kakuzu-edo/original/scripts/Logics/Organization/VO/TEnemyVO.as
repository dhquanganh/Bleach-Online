package Logics.Organization.VO
{
   public class TEnemyVO
   {
      
      protected var FID:uint;
      
      protected var FPos:uint;
      
      protected var FHP:uint;
      
      public function TEnemyVO()
      {
         super();
         this.FHP = Math.random() * 100;
      }
      
      public function get ID() : uint
      {
         return this.FID;
      }
      
      public function set ID(param1:uint) : void
      {
         this.FID = param1;
      }
      
      public function get HP() : uint
      {
         return this.FHP;
      }
      
      public function set HP(param1:uint) : void
      {
         this.FHP = param1;
      }
      
      public function get Pos() : uint
      {
         return this.FPos;
      }
      
      public function set Pos(param1:uint) : void
      {
         this.FPos = param1;
      }
   }
}

