package Foundation.Common
{
   public class TEntity64
   {
      
      protected var FIdentifier0:uint;
      
      protected var FIdentifier1:uint;
      
      public function TEntity64(param1:uint, param2:uint)
      {
         super();
         this.FIdentifier0 = param1;
         this.FIdentifier1 = param2;
      }
      
      public function get Identifier0() : uint
      {
         return this.FIdentifier0;
      }
      
      public function get Identifier1() : uint
      {
         return this.FIdentifier1;
      }
   }
}

