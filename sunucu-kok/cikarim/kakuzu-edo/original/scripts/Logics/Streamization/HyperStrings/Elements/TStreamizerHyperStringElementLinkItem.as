package Logics.Streamization.HyperStrings.Elements
{
   import Logics.HyperStrings.Elements.THyperStringElementLinkItem;
   import flash.utils.ByteArray;
   
   public class TStreamizerHyperStringElementLinkItem extends TStreamizerHyperStringElement
   {
      
      public function TStreamizerHyperStringElementLinkItem()
      {
         super();
      }
      
      override protected function StreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THyperStringElementLinkItem = null;
         _loc4_ = param2 as THyperStringElementLinkItem;
         param1.writeUnsignedInt(_loc4_.IDTemplate);
         param1.writeUnsignedInt(_loc4_.Identifier0);
         param1.writeUnsignedInt(_loc4_.Identifier1);
         param1.writeUnsignedInt(_loc4_.RoleIdentifier0);
         param1.writeUnsignedInt(_loc4_.RoleIdentifier1);
      }
   }
}

