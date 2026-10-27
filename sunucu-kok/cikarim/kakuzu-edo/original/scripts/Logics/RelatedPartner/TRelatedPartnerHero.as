package Logics.RelatedPartner
{
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TRelatedPartnerType;
   import Resources.Constants.CONST_DATEBASEVO;
   
   public class TRelatedPartnerHero
   {
      
      protected var FHeroId:int;
      
      protected var FHeroSkills:Vector.<TRelatedPartnerHeroSkill>;
      
      public function TRelatedPartnerHero()
      {
         super();
         this.FHeroSkills = new Vector.<TRelatedPartnerHeroSkill>();
      }
      
      public function get HeroSkills() : Vector.<TRelatedPartnerHeroSkill>
      {
         return this.FHeroSkills;
      }
      
      public function get HeroId() : int
      {
         return this.FHeroId;
      }
      
      public function set HeroId(param1:int) : void
      {
         this.FHeroId = param1;
      }
      
      public function SetSkillActive(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TRelatedPartnerType = null;
         _loc3_ = int(this.FHeroSkills.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RelatedPartnerType,param1) as TRelatedPartnerType;
            if(this.FHeroSkills[_loc2_].Partner.Type == _loc4_.Type)
            {
               this.FHeroSkills[_loc2_].SkillId = param1;
               return;
            }
            _loc2_++;
         }
      }
      
      public function ReplaceSkill(param1:int, param2:int) : TRelatedPartnerHeroSkill
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FHeroSkills.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FHeroSkills[_loc3_].SkillId == param1)
            {
               this.FHeroSkills[_loc3_].SkillId = param2;
               return this.FHeroSkills[_loc3_];
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(this.FHeroSkills[_loc3_].SkillId == param2)
            {
               return this.FHeroSkills[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function GetSkillInfoByType(param1:int) : TRelatedPartnerHeroSkill
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FHeroSkills.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FHeroSkills[_loc2_].Partner.Type == param1)
            {
               return this.FHeroSkills[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function ResetHeroSkill() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FHeroSkills.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FHeroSkills[_loc1_].CurSkill = null;
            if(this.FHeroSkills[_loc1_].SkillId != 0)
            {
               this.FHeroSkills[_loc1_].SkillId = this.FHeroSkills[_loc1_].Skills[0].Identifier;
            }
            _loc1_++;
         }
      }
   }
}

