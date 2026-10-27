package Logics.Streamization.HyperStrings.Elements
{
   import Logics.HyperStrings.Elements.THyperStringElementLinkItem;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerHyperStringElementLinkItem extends TUnstreamizerHyperStringElement
   {
      
      public function TUnstreamizerHyperStringElementLinkItem()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THyperStringElementLinkItem = null;
         _loc4_ = param2 as THyperStringElementLinkItem;
         _loc4_.IDTemplate = param1.readUnsignedInt();
         _loc4_.Identifier0 = param1.readUnsignedInt();
         _loc4_.Identifier1 = param1.readUnsignedInt();
         _loc4_.RoleIdentifier0 = param1.readUnsignedInt();
         _loc4_.RoleIdentifier1 = param1.readUnsignedInt();
      }
   }
}

