package Foundation.Streamization
{
   import flash.utils.ByteArray;
   
   public class TUnstreamizer
   {
      
      public function TUnstreamizer()
      {
         super();
      }
      
      protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
      }
      
      public function Unstreamize(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform(param1,param2,param3);
      }
   }
}

