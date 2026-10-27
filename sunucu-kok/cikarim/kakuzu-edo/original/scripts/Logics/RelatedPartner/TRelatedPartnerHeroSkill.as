package Logics.RelatedPartner
{
   import Logics.DatebaseVO.VO.*;
   
   public class TRelatedPartnerHeroSkill
   {
      
      protected var FPartner:TRelatedPartner;
      
      protected var FSkillId:int;
      
      protected var FSkills:Vector.<TRelatedPartnerType>;
      
      protected var FCurSkill:TRelatedPartnerType;
      
      public function TRelatedPartnerHeroSkill()
      {
         super();
         this.FSkills = new Vector.<TRelatedPartnerType>();
      }
      
      public function get Partner() : TRelatedPartner
      {
         return this.FPartner;
      }
      
      public function set Partner(param1:TRelatedPartner) : void
      {
         this.FPartner = param1;
      }
      
      public function get SkillId() : int
      {
         return this.FSkillId;
      }
      
      public function set SkillId(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FSkillId = param1;
         if(this.FSkillId == 0)
         {
            return;
         }
         _loc3_ = int(this.FSkills.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FSkills[_loc2_].Identifier == this.FSkillId)
            {
               this.FCurSkill = this.FSkills[_loc2_];
               return;
            }
            _loc2_++;
         }
      }
      
      public function get Skills() : Vector.<TRelatedPartnerType>
      {
         return this.FSkills;
      }
      
      public function get CurSkill() : TRelatedPartnerType
      {
         return this.FCurSkill;
      }
      
      public function set CurSkill(param1:TRelatedPartnerType) : void
      {
         this.FCurSkill = param1;
      }
   }
}

