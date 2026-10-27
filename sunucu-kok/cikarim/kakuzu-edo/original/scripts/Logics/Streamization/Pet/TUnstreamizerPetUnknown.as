package Logics.Streamization.Pet
{
   import Foundation.Streamization.TUnstreamizer;
   import Logics.Pet.TPoolPet;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerPetUnknown extends TUnstreamizer
   {
      
      protected static var FPoolPet:TPoolPet;
      
      protected var FUnstreamizerPet:TUnstreamizerPet;
      
      public function TUnstreamizerPetUnknown()
      {
         super();
         this.FUnstreamizerPet = new TUnstreamizerPet();
      }
      
      LogicsSpace static function PoolsSetup(param1:TPoolPet) : void
      {
         FPoolPet = param1;
      }
   }
}

