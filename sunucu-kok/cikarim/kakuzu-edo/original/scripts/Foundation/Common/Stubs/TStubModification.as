package Foundation.Common.Stubs
{
   public class TStubModification extends TStub
   {
      
      protected var FModified:Boolean;
      
      public function TStubModification(param1:Object, param2:Boolean = false)
      {
         super(param1);
         this.FModified = param2;
      }
      
      public function get Modified() : Boolean
      {
         return this.FModified;
      }
      
      public function set Modified(param1:Boolean) : void
      {
         this.FModified = param1;
      }
   }
}

