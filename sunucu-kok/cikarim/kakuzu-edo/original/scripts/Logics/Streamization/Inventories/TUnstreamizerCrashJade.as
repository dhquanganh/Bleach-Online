package Logics.Streamization.Inventories
{
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TCrashedJade;
   import Logics.Inventories.TCrashJade;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   public class TUnstreamizerCrashJade extends TUnstreamizerInventory
   {
      
      public function TUnstreamizerCrashJade()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         super.UnstreamizationPerform(param1,param2,param3);
         this.UnstreamizationPerform_CrashJadeProperties(param1,param2,param3);
         this.UnstreamizationPerform_CrashJadeByDatabase(param2,param3);
      }
      
      protected function UnstreamizationPerform_CrashJadeProperties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TCrashJade = null;
         _loc4_ = param2 as TCrashJade;
      }
      
      protected function UnstreamizationPerform_AdditionalData_CrashJade(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TCrashJade = null;
         var _loc5_:TCrashedJade = null;
         _loc4_ = param2 as TCrashJade;
         _loc4_.Quantity = 1;
         _loc4_.TimingCategory = 3;
         _loc4_.TimingState = 4;
         _loc4_.TimingTime = 0;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CrashJade,_loc4_.IDTemplate) as TCrashedJade;
         _loc4_.Level = _loc4_.IDTemplate % 100;
         _loc4_.AddAttributeType = _loc5_.AddType;
         _loc4_.AddAttributeValue = _loc5_.AddValue;
         _loc4_.LevelUpExp = _loc5_.LevelExp;
         _loc4_.SwallowExp = _loc5_.CrashedExp;
         _loc4_.NextLevelID = _loc5_.NextID;
         _loc4_.JadePower = _loc5_.JadePower;
         _loc4_.EffectID = _loc5_.EffectID;
         _loc4_.JadeTypeText = _loc5_.JadeTypeText;
         _loc4_.AddValueTxt = _loc5_.AddValueTxt;
      }
      
      protected function UnstreamizationPerform_CrashJadeByDatabase(param1:Object, param2:Object) : void
      {
      }
      
      protected function UnstreamizationPerform_GenerateCrashJadeProperties(param1:ByteArray, param2:Object, param3:Object) : void
      {
      }
      
      override protected function UnstreamizationPerform_QuestReward(param1:ByteArray, param2:Object, param3:Object) : void
      {
         super.UnstreamizationPerform_QuestReward(param1,param2,param3);
         this.UnstreamizationPerform_QRCrashJadeProperties(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_QRCrashJadeProperties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TCrashJade = null;
         _loc4_ = param2 as TCrashJade;
      }
      
      public function UnstreamizeAdditionalDataCrashJade(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_AdditionalData_CrashJade(param1,param2,param3);
         super.UnstreamizationPerform_InventoryByDatabase(param2);
         this.UnstreamizationPerform_CrashJadeByDatabase(param2,param3);
      }
      
      override public function UnstreamizeGenerateInventory(param1:ByteArray, param2:Object, param3:Object) : void
      {
         super.UnstreamizeGenerateInventory(param1,param2,param3);
         this.UnstreamizationPerform_GenerateCrashJadeProperties(param1,param2,param3);
         this.UnstreamizationPerform_CrashJadeByDatabase(param2,param3);
         this.UnstreamizationPerform_AdditionalData_CrashJade(param1,param2,param3);
      }
   }
}

