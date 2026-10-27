package Foundation.Common.Stubs
{
   public class TStubReferences extends TStub
   {
      
      protected var FCount:int;
      
      public function TStubReferences(param1:Object)
      {
         super(param1);
      }
      
      public function get Count() : int
      {
         return this.FCount;
      }
      
      public function Reference(param1:Object) : void
      {
         ++this.FCount;
      }
      
      public function Dereference(param1:Object) : void
      {
         if(this.FCount > 0)
         {
            --this.FCount;
         }
      }
   }
}

