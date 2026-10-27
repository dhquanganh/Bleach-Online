package Logics.Streamization.Skills
{
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TSkillConfig;
   import Logics.DatebaseVO.VO.TSoulSkill;
   import Logics.Skills.TSkill;
   import Logics.Skills.TSkills;
   import Logics.Spaces.LogicsSpace;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerSkill extends TUnstreamizerSkillUnknown
   {
      
      public function TUnstreamizerSkill()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Properties(param1,param2,param3);
         this.UnstreamizationPerform_SkillByDatabase(param2,param3);
      }
      
      protected function UnstreamizationPerform_Properties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TSkill = null;
         var _loc5_:uint = 0;
         _loc4_ = param2 as TSkill;
         _loc5_ = param1.readUnsignedInt();
         _loc4_.Coerce(_loc5_);
         _loc4_.IsUnlock = param1.readBoolean();
      }
      
      protected function UnstreamizationPerform_SkillByDatabase(param1:Object, param2:Object) : void
      {
         var _loc3_:TSkill = null;
         var _loc4_:TSkillConfig = null;
         var _loc5_:TSoulSkill = null;
         _loc3_ = param1 as TSkill;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,_loc3_.Identifier) as TSkillConfig;
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SoulSkill,_loc3_.Identifier) as TSoulSkill;
         _loc3_.Name = _loc4_.Name;
         _loc3_.Description = _loc4_.Desc;
         _loc3_.Sort = _loc4_.SortId;
         _loc3_.IDTexture = _loc4_.Icon;
         _loc3_.SkillID = _loc4_.SkillId;
         if(_loc5_ != null)
         {
            _loc3_.Level = _loc5_.SkillLv;
            _loc3_.NextID = _loc5_.NextSkillId;
            _loc3_.NeedItem = _loc5_.SoulSkillNeedItem;
         }
      }
      
      protected function UnstreamizationPerform_GenerateSkill(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_SkillByDatabase(param2,param3);
      }
      
      public function UnstreamizeGenerateSkill(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_GenerateSkill(param1,param2,param3);
      }
      
      public function UnstreamizeUpgradeSkill(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TSkill = null;
         var _loc5_:uint = 0;
         _loc4_ = param2 as TSkill;
         _loc5_ = param3 as uint;
         _loc4_.Coerce(_loc5_);
         this.UnstreamizationPerform_GenerateSkill(param1,_loc4_,param3);
      }
      
      public function UnstreamizeSupplementarySkill(param1:Object, param2:Object) : void
      {
         var _loc3_:TSkill = null;
         var _loc4_:uint = 0;
         var _loc5_:TSkills = null;
         _loc5_ = param1 as TSkills;
         _loc3_ = FPoolSkill.Acquire();
         _loc4_ = param2 as uint;
         _loc3_.Coerce(_loc4_);
         this.UnstreamizationPerform_GenerateSkill(null,_loc3_,param2);
         _loc5_.Add(_loc3_);
      }
   }
}

