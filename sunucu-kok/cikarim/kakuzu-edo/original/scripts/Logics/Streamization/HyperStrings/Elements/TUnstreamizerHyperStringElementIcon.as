package Logics.Streamization.HyperStrings.Elements
{
   import Logics.HyperStrings.Elements.THyperStringElementIcon;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerHyperStringElementIcon extends TUnstreamizerHyperStringElement
   {
      
      public function TUnstreamizerHyperStringElementIcon()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THyperStringElementIcon = null;
         _loc4_ = param2 as THyperStringElementIcon;
         _loc4_.IDIcon = param1.readUnsignedShort();
      }
   }
}

