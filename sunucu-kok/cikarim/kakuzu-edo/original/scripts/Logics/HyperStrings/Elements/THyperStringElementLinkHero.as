package Logics.HyperStrings.Elements
{
   public class THyperStringElementLinkHero extends THyperStringElementTextual
   {
      
      protected var FIdentifier0:uint;
      
      protected var FIdentifier1:uint;
      
      protected var FIDTemplate:uint;
      
      public function THyperStringElementLinkHero()
      {
         super();
      }
      
      public function get Identifier0() : uint
      {
         return this.FIdentifier0;
      }
      
      public function set Identifier0(param1:uint) : void
      {
         this.FIdentifier0 = param1;
      }
      
      public function get Identifier1() : uint
      {
         return this.FIdentifier1;
      }
      
      public function set Identifier1(param1:uint) : void
      {
         this.FIdentifier1 = param1;
      }
      
      public function get IDTemplate() : uint
      {
         return this.FIDTemplate;
      }
      
      public function set IDTemplate(param1:uint) : void
      {
         this.FIDTemplate = param1;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FIdentifier0 = 0;
         this.FIdentifier1 = 0;
         this.FIDTemplate = 0;
      }
   }
}

