package Logics.Streamization.Inventories
{
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TEquipAdditional;
   import Logics.Inventories.TEquipmentAppendAttribute;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerEquipmentAppendAttribute extends TUnstreamizerInventoryUnknown
   {
      
      public static const BASEATTRIBUTENAMES:Vector.<uint> = CONST_COMMON.BASEATTRIBUTENAMES;
      
      public function TUnstreamizerEquipmentAppendAttribute()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Properties(param1,param2,param3);
         this.UnstreamizationPerform_AppendAttributePropertiesByDatabase(param2,param3);
      }
      
      protected function UnstreamizationPerform_Properties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TEquipmentAppendAttribute = null;
         _loc4_ = param2 as TEquipmentAppendAttribute;
         _loc4_.Identifier = param1.readUnsignedInt();
         _loc4_.Category = param1.readUnsignedInt();
         _loc4_.Value = param1.readUnsignedShort();
      }
      
      protected function UnstreamizationPerform_AppendAttributePropertiesByDatabase(param1:Object, param2:Object) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TEquipAdditional = null;
         var _loc5_:TEquipmentAppendAttribute = null;
         _loc5_ = param1 as TEquipmentAppendAttribute;
         if(_loc5_.Identifier == 0)
         {
            return;
         }
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_EquipAdditional,_loc5_.Identifier) as TEquipAdditional;
         _loc3_ = BASEATTRIBUTENAMES.indexOf(_loc4_.Category);
         if(_loc3_ >= 0)
         {
            _loc5_.Name = TUtilityLobby.GetBaseAttributeNameByIndex(_loc3_);
         }
         else
         {
            _loc5_.Name = "";
         }
         _loc5_.Sort = _loc4_.SortNumber;
         _loc5_.Divisor = _loc4_.Divisor;
         _loc5_.Percentage = _loc4_.Percentage;
         _loc5_.MaxValue = _loc4_.MaxValue;
         _loc5_.MinValue = _loc4_.MinValue;
      }
      
      public function UnstreamizationAppendAttributePropertiesByDatabase(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_AppendAttributePropertiesByDatabase(param2,param3);
      }
   }
}

