package Logics.Streamization.Items
{
   import Logics.Items.TItem;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerItem extends TUnstreamizerItemUnknown
   {
      
      public function TUnstreamizerItem()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TItem = null;
         _loc4_ = param2 as TItem;
         _loc4_.Type = param1.readShort();
         _loc4_.ID = param1.readInt();
         _loc4_.Count = param1.readInt();
      }
   }
}

