package Logics.Streamization.Skills
{
   import Foundation.Resources.SResourcesCore;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.Skills.TSkill;
   import Logics.Skills.TSkills;
   import Logics.Spaces.LogicsSpace;
   import Resources.Constants.CONST_DATEBASEVO;
   import flash.utils.ByteArray;
   
   use namespace LogicsSpace;
   
   public class TUnstreamizerSkills extends TUnstreamizerSkillUnknown
   {
      
      protected var FUnstreamizerSkill:TUnstreamizerSkill;
      
      public function TUnstreamizerSkills()
      {
         super();
         this.FUnstreamizerSkill = new TUnstreamizerSkill();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Skills(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Skills(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TSkills = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TSkill = null;
         _loc4_ = param2 as TSkills;
         _loc4_.Clear();
         _loc5_ = int(param1.readUnsignedShort());
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc7_ = FPoolSkill.Acquire();
            this.FUnstreamizerSkill.Unstreamize(param1,_loc7_,param3);
            _loc4_.Add(_loc7_);
            _loc6_++;
         }
      }
      
      protected function UnstreamizationPerform_GenerateSkills(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:THero = null;
         var _loc5_:TSkill = null;
         var _loc6_:TBaseHero = null;
         _loc4_ = param2 as THero;
         _loc5_ = _loc4_.Skill;
         _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,_loc4_.Identifier) as TBaseHero;
         _loc5_.Coerce(_loc6_.Active);
         _loc5_.Mounted = true;
         this.FUnstreamizerSkill.UnstreamizeGenerateSkill(param1,_loc5_,param3);
      }
      
      public function UnstreamizeGenerateSkills(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_GenerateSkills(param1,param2,param3);
      }
   }
}

