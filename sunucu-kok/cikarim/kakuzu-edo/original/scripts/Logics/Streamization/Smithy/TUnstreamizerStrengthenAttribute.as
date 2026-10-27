package Logics.Streamization.Smithy
{
   import Logics.Inventories.TEquipmentAppendAttributes;
   import Logics.Smithy.TSmithyAttributeList;
   import Logics.Smithy.TSmithyRefinedPakcetUnstreamizerData;
   import Logics.Streamization.Inventories.TUnstreamizerEquipmentAppendAttributes;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerStrengthenAttribute
   {
      
      protected var UnstreamizerEquipmentAppendAttributes:TUnstreamizerEquipmentAppendAttributes;
      
      public function TUnstreamizerStrengthenAttribute()
      {
         super();
         this.UnstreamizerEquipmentAppendAttributes = new TUnstreamizerEquipmentAppendAttributes();
      }
      
      protected function UnstreamizationPerform_StrengthenAttributes(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TSmithyRefinedPakcetUnstreamizerData = null;
         var _loc5_:TSmithyAttributeList = null;
         var _loc6_:TEquipmentAppendAttributes = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         _loc4_ = param2 as TSmithyRefinedPakcetUnstreamizerData;
         _loc4_.ResultCode = param1.readUnsignedInt();
         if(_loc4_.ResultCode != 0)
         {
            return;
         }
         _loc4_.SkillID = param1.readUnsignedInt();
         _loc5_ = _loc4_.SmithyAttributeList;
         _loc5_.Count = param1.readUnsignedShort();
         _loc8_ = _loc5_.Count;
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc6_ = _loc5_.GetAttributesByIndex(_loc7_);
            _loc6_.Clear();
            this.UnstreamizerEquipmentAppendAttributes.Unstreamize(param1,_loc6_,null);
            _loc7_++;
         }
      }
      
      public function UnstreamizeStrengthenAttributes(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_StrengthenAttributes(param1,param2,param3);
      }
   }
}

