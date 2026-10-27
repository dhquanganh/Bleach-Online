package Logics.Streamization.Inventories
{
   import Logics.Inventories.TEquipmentAppendAttribute;
   import Logics.Inventories.TEquipmentAppendAttributes;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerEquipmentAppendAttributes extends TUnstreamizerInventoryUnknown
   {
      
      protected var FUnstreamizerAppendAttribute:TUnstreamizerEquipmentAppendAttribute;
      
      public function TUnstreamizerEquipmentAppendAttributes()
      {
         super();
         this.FUnstreamizerAppendAttribute = new TUnstreamizerEquipmentAppendAttribute();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_AppendAttributes(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_AppendAttributes(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TEquipmentAppendAttribute = null;
         var _loc7_:TEquipmentAppendAttributes = null;
         _loc7_ = param2 as TEquipmentAppendAttributes;
         _loc7_.Clear();
         _loc4_ = int(param1.readUnsignedShort());
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = FPoolInventory.AcquireEquipmentAppendAttribute();
            this.FUnstreamizerAppendAttribute.Unstreamize(param1,_loc6_,param3);
            if(_loc6_.Identifier != 0)
            {
               _loc7_.Add(_loc6_);
            }
            _loc5_++;
         }
      }
   }
}

