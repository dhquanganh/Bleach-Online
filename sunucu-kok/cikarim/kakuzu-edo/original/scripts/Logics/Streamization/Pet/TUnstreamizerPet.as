package Logics.Streamization.Pet
{
   import Foundation.Resources.*;
   import Foundation.Streamization.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Pet.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TUnstreamizerPet extends TUnstreamizer
   {
      
      public function TUnstreamizerPet()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
      }
      
      protected function UnstreamizationPerform_PetAttributeByDatabase(param1:Object, param2:TPetLevelUp, param3:TPetLevelUp, param4:TPetLevelUp) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TPetBase = null;
         var _loc8_:TVicePet = null;
         var _loc9_:Function = null;
         var _loc10_:Function = null;
         var _loc11_:Boolean = false;
         var _loc12_:uint = 0;
         _loc7_ = param1 as TPetBase;
         _loc11_ = _loc7_ is TMainPet;
         _loc7_.Name = param2.Name;
         if(param4 != null)
         {
            _loc7_.NextExperience = param4.NeedExp;
         }
         else
         {
            _loc7_.NextExperience = 0;
         }
         _loc7_.TotalExperience = param2.TotalExpp;
         _loc6_ = _loc7_.BaseAttributesCount;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_.SetBaseAttributeByIndex(_loc5_,param2.StarLevel[_loc5_]);
            if(param3 != null)
            {
               _loc7_.SetNextBaseAttributeByIndex(_loc5_,param3.StarLevel[_loc5_]);
            }
            _loc5_++;
         }
         _loc6_ = _loc7_.PvPAttributesCount;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            if(_loc11_)
            {
               _loc12_ = uint(param2.Attributes[_loc5_]);
            }
            else
            {
               _loc8_ = _loc7_ as TVicePet;
               _loc12_ = param2.Attributes[_loc5_] + Math.floor(param2.GrowRates[_loc5_] * (_loc7_.Level - 1));
            }
            _loc7_.SetPvPAttributeByIndex(_loc5_,_loc12_);
            if(param3 != null)
            {
               if(_loc11_)
               {
                  _loc12_ = uint(param3.Attributes[_loc5_]);
               }
               else
               {
                  _loc8_ = _loc7_ as TVicePet;
                  _loc12_ = param3.Attributes[_loc5_] + Math.floor(param3.GrowRates[_loc5_] * (_loc8_.ConditionAdvancePetLevel - 1));
               }
               _loc7_.SetNextPvPAttributeByIndex(_loc5_,_loc12_);
            }
            _loc5_++;
         }
      }
      
      protected function UnstreamizationPerform_PetResourceByDatabase(param1:Object) : void
      {
         var _loc2_:TPetBase = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TPetLevelUp = null;
         var _loc6_:TRoleModel = null;
         _loc2_ = param1 as TPetBase;
         _loc3_ = _loc2_.Level;
         _loc4_ = _loc2_.GetTemplateIDByLevel(_loc3_);
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,_loc4_) as TPetLevelUp;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc5_.PetResourceID) as TRoleModel;
         _loc2_.HeadIconID = _loc6_.RoleHead;
         _loc2_.LargeIconID = _loc6_.RoleStyle;
         _loc2_.ModelID = _loc6_.Model;
      }
      
      protected function UnstreamizationPerform_MainPetByDatabase(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TMainPet = null;
         var _loc6_:TPetLevelUp = null;
         var _loc7_:TPetLevelUp = null;
         var _loc8_:TMainPetRankUp = null;
         _loc5_ = param1 as TMainPet;
         _loc3_ = _loc5_.GetTemplateIDByLevel(_loc5_.Level);
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,_loc3_) as TPetLevelUp;
         _loc4_ = _loc5_.GetTemplateIDByLevel(_loc5_.Level + 1);
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,_loc4_) as TPetLevelUp;
         this.UnstreamizationPerform_PetAttributeByDatabase(_loc5_,_loc6_,_loc7_,_loc7_);
         _loc5_.PetState = _loc7_ != null ? CONST_PET.PetState_HasNextLevel : CONST_PET.PetState_NoNextLevel_NoAdvance;
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_MainPetRankUp,_loc5_.Identifier0) as TMainPetRankUp;
         _loc5_.Stage = _loc8_.Stage;
         _loc5_.PetRankUpCondition = _loc8_.PetRankUpCondition;
      }
      
      protected function UnstreamizationPerform_VicePetByDatabase(param1:Object) : void
      {
         var _loc2_:TVicePet = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TPetLevelUp = null;
         var _loc7_:TPetLevelUp = null;
         var _loc8_:TPetLevelUp = null;
         var _loc9_:TVicePetMake = null;
         var _loc10_:TVicePetRankUp = null;
         var _loc11_:int = 0;
         _loc2_ = param1 as TVicePet;
         _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_VicePetRankUp,_loc2_.TemplateID) as TVicePetRankUp;
         _loc2_.AdvanceState = _loc10_ != null;
         if(_loc10_ != null)
         {
            _loc2_.ConditionAdvancePropID = _loc10_.Condition[0];
            _loc2_.ConditionAdvancePropQuantity = _loc10_.Condition[1];
            _loc2_.ConditionAdvancePrice = _loc10_.NeedSilver;
            _loc2_.ConditionAdvancePetLevel = _loc10_.PetLevel;
         }
         else
         {
            _loc2_.ConditionAdvancePetLevel = 0;
         }
         _loc3_ = _loc2_.GetTemplateIDByLevel(_loc2_.Level);
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,_loc3_) as TPetLevelUp;
         if(_loc2_.AdvanceState)
         {
            _loc4_ = _loc2_.GetTemplateIDByIDLevel(_loc10_.NextPetId,_loc2_.ConditionAdvancePetLevel);
         }
         else
         {
            _loc4_ = _loc2_.GetTemplateIDByLevel(_loc2_.Level + 1);
         }
         _loc5_ = _loc2_.GetTemplateIDByLevel(_loc2_.Level + 1);
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,_loc5_) as TPetLevelUp;
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_PetLevelUp,_loc4_) as TPetLevelUp;
         this.UnstreamizationPerform_PetAttributeByDatabase(_loc2_,_loc6_,_loc7_,_loc8_);
         _loc2_.Quality = _loc6_.Quality;
         _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_VicePetMake,_loc6_.SourcePet) as TVicePetMake;
         _loc2_.CompositeState = _loc9_ != null;
         if(_loc9_ != null)
         {
            _loc2_.ConditionCompositePropID = _loc9_.Consume[0];
            _loc2_.ConditionCompositePropQuantity = _loc9_.Consume[1];
            _loc2_.ConditionCompositePrice = _loc9_.NeedSilver;
         }
         if(_loc2_.AdvanceState && _loc2_.Level >= _loc2_.ConditionAdvancePetLevel)
         {
            _loc2_.PetState = CONST_PET.PetState_NoNextLevel_CanAdvance;
         }
         else if(!_loc2_.AdvanceState)
         {
            _loc2_.PetState = CONST_PET.PetState_NoNextLevel_NoAdvance;
         }
         else
         {
            _loc2_.PetState = CONST_PET.PetState_HasNextLevel;
         }
      }
      
      protected function UnstreamizationPerform_MainPet(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TMainPet = null;
         _loc4_ = param2 as TMainPet;
         this.UnstreamizationPerform_MainPetByDatabase(_loc4_);
         this.UnstreamizationPerform_PetResourceByDatabase(_loc4_);
      }
      
      protected function UnstreamizationPerform_VicePet(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:TVicePet = null;
         _loc5_ = param2 as TVicePet;
         this.UnstreamizationPerform_VicePetByDatabase(_loc5_);
         this.UnstreamizationPerform_PetResourceByDatabase(_loc5_);
      }
      
      protected function GetAdvanceID(param1:uint) : uint
      {
         var _loc2_:TVicePetRankUp = null;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_VicePetRankUp,param1) as TVicePetRankUp;
         if(_loc2_)
         {
            return _loc2_.NextPetId;
         }
         return param1;
      }
      
      public function UnstreamizeMainPet(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_MainPet(param1,param2,param3);
      }
      
      public function UnstreamizeVicePet(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_VicePet(param1,param2,param3);
      }
   }
}

