package Localization.Strings
{
   public class TStringParagraphParameters
   {
      
      protected var FIndent:int;
      
      protected var FWrapTrailingSpaces:Boolean;
      
      public function TStringParagraphParameters()
      {
         super();
      }
      
      public function get Indent() : int
      {
         return this.FIndent;
      }
      
      public function set Indent(param1:int) : void
      {
         this.FIndent = param1;
      }
      
      public function get WrapTrailingSpaces() : Boolean
      {
         return this.FWrapTrailingSpaces;
      }
      
      public function set WrapTrailingSpaces(param1:Boolean) : void
      {
         this.FWrapTrailingSpaces = param1;
      }
   }
}

