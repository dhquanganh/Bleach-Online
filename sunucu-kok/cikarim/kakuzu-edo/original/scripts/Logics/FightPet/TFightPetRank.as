package Logics.FightPet
{
   import Foundation.Common.Integer.UInt64;
   
   public class TFightPetRank
   {
      
      protected var FName:String;
      
      protected var FDamage:UInt64;
      
      public function TFightPetRank()
      {
         super();
         this.FDamage = new UInt64();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get Damage() : UInt64
      {
         return this.FDamage;
      }
      
      public function set Damage(param1:UInt64) : void
      {
         this.FDamage = param1;
      }
   }
}

