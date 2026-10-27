package Localization.Strings
{
   public class TStringOperation
   {
      
      protected var FText:String;
      
      protected var FIndex:int;
      
      public function TStringOperation()
      {
         super();
      }
      
      public function get Text() : String
      {
         return this.FText;
      }
      
      public function set Text(param1:String) : void
      {
         this.FText = param1;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
   }
}

