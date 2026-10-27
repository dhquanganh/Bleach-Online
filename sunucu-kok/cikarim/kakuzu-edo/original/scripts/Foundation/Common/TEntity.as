package Foundation.Common
{
   public class TEntity
   {
      
      protected var FIdentifier:uint;
      
      public function TEntity(param1:uint)
      {
         super();
         this.FIdentifier = param1;
      }
      
      public function get Identifier() : uint
      {
         return this.FIdentifier;
      }
   }
}

