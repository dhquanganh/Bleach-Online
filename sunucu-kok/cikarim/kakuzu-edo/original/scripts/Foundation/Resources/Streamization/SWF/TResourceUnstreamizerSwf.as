package Foundation.Resources.Streamization.SWF
{
   import Foundation.Resources.Streamization.TResourceUnstreamizer;
   import flash.utils.ByteArray;
   
   public class TResourceUnstreamizerSwf extends TResourceUnstreamizer
   {
      
      public function TResourceUnstreamizerSwf()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Traversal(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Traversal(param1:ByteArray, param2:Object, param3:Object) : void
      {
      }
   }
}

