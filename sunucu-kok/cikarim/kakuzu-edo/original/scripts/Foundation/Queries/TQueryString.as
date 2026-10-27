package Foundation.Queries
{
   public class TQueryString extends TQueryUnknown
   {
      
      protected var FValue:String;
      
      public function TQueryString()
      {
         super();
         this.FValue = "";
      }
      
      public function get Value() : String
      {
         return this.FValue;
      }
      
      public function set Value(param1:String) : void
      {
         this.FValue = param1;
      }
   }
}

