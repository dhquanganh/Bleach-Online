package Logics.Streamization.HyperStrings.Elements
{
   import Logics.HyperStrings.Elements.THyperStringElementIcon;
   import flash.utils.ByteArray;
   
   public class TStreamizerHyperStringElementIcon extends TStreamizerHyperStringElement
   {
      
      public function TStreamizerHyperStringElementIcon()
      {
         super();
      }
      
      override protected function StreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THyperStringElementIcon = null;
         _loc4_ = param2 as THyperStringElementIcon;
         param1.writeShort(_loc4_.IDIcon);
      }
   }
}

