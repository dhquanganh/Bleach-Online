package Foundation.Streamization
{
   import flash.utils.ByteArray;
   
   public class TStreamizer
   {
      
      public function TStreamizer()
      {
         super();
      }
      
      protected function StreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
      }
      
      public function Streamize(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.StreamizationPerform(param1,param2,param3);
      }
   }
}

