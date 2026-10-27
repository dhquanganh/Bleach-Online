package Foundation.Queries
{
   public class TQueryBoolean extends TQueryUnknown
   {
      
      protected var FValue:Boolean;
      
      public function TQueryBoolean()
      {
         super();
         this.FValue = false;
      }
      
      public function get Value() : Boolean
      {
         return this.FValue;
      }
      
      public function set Value(param1:Boolean) : void
      {
         this.FValue = param1;
      }
   }
}

