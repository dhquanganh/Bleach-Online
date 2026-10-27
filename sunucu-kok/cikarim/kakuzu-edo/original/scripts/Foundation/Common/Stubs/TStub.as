package Foundation.Common.Stubs
{
   public class TStub
   {
      
      protected var FOwner:Object;
      
      public function TStub(param1:Object)
      {
         super();
         this.FOwner = param1;
      }
      
      public function get Owner() : Object
      {
         return this.FOwner;
      }
   }
}

