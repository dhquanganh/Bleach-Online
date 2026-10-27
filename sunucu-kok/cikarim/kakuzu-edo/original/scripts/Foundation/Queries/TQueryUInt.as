package Foundation.Queries
{
   public class TQueryUInt extends TQueryUnknown
   {
      
      protected var FValue:uint;
      
      public function TQueryUInt()
      {
         super();
         this.FValue = 0;
      }
      
      public function get Value() : uint
      {
         return this.FValue;
      }
      
      public function set Value(param1:uint) : void
      {
         this.FValue = param1;
      }
   }
}

