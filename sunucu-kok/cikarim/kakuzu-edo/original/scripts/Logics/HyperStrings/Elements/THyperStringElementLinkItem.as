package Logics.HyperStrings.Elements
{
   public class THyperStringElementLinkItem extends THyperStringElementText
   {
      
      protected var FIdentifier0:uint;
      
      protected var FIdentifier1:uint;
      
      protected var FRoleIdentifier0:uint;
      
      protected var FRoleIdentifier1:uint;
      
      protected var FIDTemplate:uint;
      
      public function THyperStringElementLinkItem()
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
      
      public function get RoleIdentifier0() : uint
      {
         return this.FRoleIdentifier0;
      }
      
      public function set RoleIdentifier0(param1:uint) : void
      {
         this.FRoleIdentifier0 = param1;
      }
      
      public function get RoleIdentifier1() : uint
      {
         return this.FRoleIdentifier1;
      }
      
      public function set RoleIdentifier1(param1:uint) : void
      {
         this.FRoleIdentifier1 = param1;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FIdentifier0 = 0;
         this.FIdentifier1 = 0;
         this.FIDTemplate = 0;
      }
      
      override public function FlushElement(param1:THyperStringElement) : void
      {
         var _loc2_:THyperStringElementLinkItem = null;
         super.FlushElement(param1);
         _loc2_ = param1 as THyperStringElementLinkItem;
         _loc2_.Identifier0 = this.FIdentifier0;
         _loc2_.Identifier1 = this.FIdentifier1;
         _loc2_.IDTemplate = this.FIDTemplate;
         _loc2_.Text = FText.substr(1,FText.length - 2);
      }
   }
}

