package Logics.HyperStrings.Elements
{
   public class THyperStringElementTextual extends THyperStringElement
   {
      
      protected var FText:String;
      
      protected var FColor:uint;
      
      protected var FColorOverridden:Boolean;
      
      public function THyperStringElementTextual()
      {
         super();
         this.FText = "";
      }
      
      public function get Text() : String
      {
         return this.FText;
      }
      
      public function set Text(param1:String) : void
      {
         if(param1 == null)
         {
            param1 = "";
         }
         this.FText = param1;
      }
      
      public function get Color() : uint
      {
         return this.FColor;
      }
      
      public function set Color(param1:uint) : void
      {
         this.FColor = param1;
      }
      
      public function get ColorOverridden() : Boolean
      {
         return this.FColorOverridden;
      }
      
      public function set ColorOverridden(param1:Boolean) : void
      {
         this.FColorOverridden = param1;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FText = "";
         this.FColor = 0;
         this.FColorOverridden = false;
      }
      
      override public function FlushElement(param1:THyperStringElement) : void
      {
         var _loc2_:THyperStringElementText = null;
         super.FlushElement(param1);
         _loc2_ = param1 as THyperStringElementText;
         _loc2_.Text = this.FText;
         _loc2_.Color = this.FColor;
         _loc2_.ColorOverridden = this.FColorOverridden;
      }
      
      public function ColorOverride(param1:uint) : void
      {
         this.FColor = param1;
         this.FColorOverridden = true;
      }
   }
}

