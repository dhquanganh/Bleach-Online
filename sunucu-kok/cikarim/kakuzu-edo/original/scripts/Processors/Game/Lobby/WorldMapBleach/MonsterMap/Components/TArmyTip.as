package Processors.Game.Lobby.WorldMapBleach.MonsterMap.Components
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TGameUtil;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.TEnemy;
   import Logics.DatebaseVO.VO.THeroExp;
   import Logics.DatebaseVO.VO.THeroTalent;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.DatebaseVO.VO.TSkillConfig;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_CHARACTER;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_DEPLOYMENT;
   import Resources.Constants.CONST_SKILL;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public class TArmyTip extends TUIComponent
   {
      
      protected static const TYPE_PHYSICAL:uint = 1;
      
      protected static const TYPE_MAGIC:uint = 2;
      
      protected var FScene:MovieClip;
      
      protected var FHeroData:THero;
      
      protected var FEnemyData:TEnemy;
      
      protected var FHeadBitmap:Bitmap;
      
      protected var FRoleModel:TBins;
      
      public function TArmyTip(param1:TUIComponent)
      {
         super(param1);
         this.InitDeploymentTip();
      }
      
      protected function InitDeploymentTip() : void
      {
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_DEPLOYMENT.RESOURCE_ClassName_DeploymentTip) as MovieClip;
         addChild(this.FScene);
         this.FHeadBitmap = new Bitmap();
         this.FScene.Head.mc_head.addChild(this.FHeadBitmap);
         this.FRoleModel = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
      }
      
      protected function UpdataUI() : void
      {
         var _loc1_:String = null;
         var _loc2_:THeroExp = null;
         var _loc3_:TBaseHero = null;
         var _loc4_:TSkillConfig = null;
         var _loc5_:THeroTalent = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Vector.<String> = null;
         var _loc11_:Vector.<String> = null;
         this.UpdataBitmap();
         _loc10_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_14);
         _loc11_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.STRING_Rebirth_12);
         if(this.FHeroData != null)
         {
            this.FScene.tf_speed.text = this.FHeroData.BaseAttributeSpeed.toString();
            this.FScene.tf_health.text = this.FHeroData.BaseAttributeHealth.toString();
            this.FScene.tf_physicalDefends.text = this.FHeroData.BaseAttributePhysicalDefends.toString();
            this.FScene.tf_magicDefends.text = this.FHeroData.BaseAttributeMagicDefends.toString();
            if(this.FHeroData.Profession != CONST_CHARACTER.PROFESSION_Intellect)
            {
               this.FScene.tf_attact.text = this.FHeroData.BaseAttributePhysicalAttack.toString();
               this.FScene.tf_attackName.gotoAndStop(TYPE_PHYSICAL);
            }
            else
            {
               this.FScene.tf_attact.text = this.FHeroData.BaseAttributeMagicAttack.toString();
               this.FScene.tf_attackName.gotoAndStop(TYPE_MAGIC);
            }
            this.FScene.tf_InjuryRate.text = this.FHeroData.BaseAttributeHurt + "%";
            this.FScene.mc_posIcon.gotoAndStop(this.FHeroData.StandPositionWithProfession);
            this.FScene.tf_Profession.text = TUtilityLobby.GetProfessionByIndex(this.FHeroData.Profession);
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroExp,this.FHeroData.RebirthLevel) as THeroExp;
            this.FScene.tf_name.text = this.FHeroData.Name ? this.FHeroData.Name : "";
            this.FScene.tf_skillName.text = this.FHeroData.Skill.Name;
            this.FScene.tf_talent.text = this.FHeroData.TalentName;
            this.FScene.tf_skillDescription.htmlText = this.FHeroData.Skill.Description;
            this.FScene.tf_auraSkill.text = CONST_SKILL.SkillDescByHero(CONST_SKILL.TYPE_AURA,this.FHeroData);
            this.FScene.tf_deadSkill.text = CONST_SKILL.SkillDescByHero(CONST_SKILL.TYPE_DEAD,this.FHeroData);
            _loc7_ = CONST_SKILL.SkillDescByHero(CONST_SKILL.TYPE_PASSIVE,this.FHeroData);
            _loc8_ = CONST_SKILL.SkillDescByHero(CONST_SKILL.TYPE_ROUND,this.FHeroData);
            _loc9_ = CONST_SKILL.SkillDesc(0,null);
            if(_loc7_ == _loc9_ && _loc8_ == _loc9_)
            {
               this.FScene.tf_passiveSkill.text = _loc9_;
            }
            else if(_loc7_ == _loc9_ && _loc8_ != _loc9_)
            {
               this.FScene.tf_passiveSkill.text = _loc8_;
            }
            else if(_loc7_ != _loc9_ && _loc8_ == _loc9_)
            {
               this.FScene.tf_passiveSkill.text = _loc7_;
            }
            else
            {
               this.FScene.tf_passiveSkill.text = _loc7_ + _loc8_;
            }
            if(this.FHeroData.CustomHero != null)
            {
               this.FScene.tf_CustomskillDescription.text = this.FHeroData.CustomHero.CurSkillDesc;
            }
            else
            {
               this.FScene.tf_CustomskillDescription.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_CloseViewTxt);
            }
            if(this.FHeroData.CustomHero != null && this.FHeroData.Skill.SkillID == this.FHeroData.CustomHero.CurSkill)
            {
               _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,this.FHeroData.Identifier) as TBaseHero;
               _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,_loc3_.Active) as TSkillConfig;
               _loc6_ = _loc4_.Desc;
               _loc6_ = _loc6_.split("%colour%").join("#fffe0000");
               this.FScene.tf_skillDescription.htmlText = _loc6_;
               this.FScene.tf_attackEffect.text = _loc9_;
               this.FScene.tf_attrPower.text = _loc9_;
            }
            if(this.FHeroData.RebirthNum == 0)
            {
               this.FScene.tf_attrPower.text = _loc9_;
               this.FScene.tf_attackEffect.text = _loc9_;
            }
            else
            {
               this.FScene.tf_attrPower.text = _loc10_[this.FHeroData.PropPower - 1];
               this.FScene.tf_attackEffect.text = _loc11_[this.FHeroData.AttackEffect - 1];
            }
         }
         else if(this.FEnemyData != null)
         {
            this.FScene.tf_speed.text = this.FEnemyData.Speed.toString();
            this.FScene.tf_health.text = this.FEnemyData.Hp.toString();
            this.FScene.tf_physicalDefends.text = this.FEnemyData.BaseAttributePhysicalDefends.toString();
            this.FScene.tf_magicDefends.text = this.FEnemyData.BaseAttributeMagicDefends.toString();
            if(this.FEnemyData.Profession != CONST_CHARACTER.PROFESSION_Intellect)
            {
               this.FScene.tf_attact.text = this.FEnemyData.BaseAttributePhysicalAttack.toString();
               this.FScene.tf_attackName.gotoAndStop(TYPE_PHYSICAL);
            }
            else
            {
               this.FScene.tf_attact.text = this.FEnemyData.BaseAttributeMagicAttack.toString();
               this.FScene.tf_attackName.gotoAndStop(TYPE_MAGIC);
            }
            this.FScene.tf_InjuryRate.text = "0" + "%";
            this.FScene.mc_posIcon.gotoAndStop(this.FEnemyData.StandPositionWithProfession);
            this.FScene.tf_Profession.text = TUtilityLobby.GetProfessionByIndex(this.FEnemyData.Profession);
            this.FScene.tf_name.text = this.FEnemyData.Name ? this.FEnemyData.Name : "";
            _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroTalent,this.FEnemyData.TalentId) as THeroTalent;
            if(_loc5_ != null)
            {
               this.FScene.tf_talent.text = _loc5_.TalentName;
            }
            else
            {
               this.FScene.tf_talent.text = "";
            }
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,this.FEnemyData.Skill) as TSkillConfig;
            this.FScene.tf_skillName.text = _loc4_.Name;
            TextField(this.FScene.tf_skillDescription).htmlText = _loc4_.Desc;
            this.FScene.tf_auraSkill.text = CONST_SKILL.SkillDesc(CONST_SKILL.TYPE_AURA,this.FEnemyData.SkillDesc);
            this.FScene.tf_deadSkill.text = CONST_SKILL.SkillDesc(CONST_SKILL.TYPE_DEAD,this.FEnemyData.SkillDesc);
            _loc7_ = CONST_SKILL.SkillDesc(CONST_SKILL.TYPE_PASSIVE,this.FEnemyData.SkillDesc);
            _loc8_ = CONST_SKILL.SkillDesc(CONST_SKILL.TYPE_ROUND,this.FEnemyData.SkillDesc);
            _loc9_ = CONST_SKILL.SkillDesc(0,null);
            if(_loc7_ == _loc9_ && _loc8_ == _loc9_)
            {
               this.FScene.tf_passiveSkill.text = _loc9_;
            }
            else if(_loc7_ == _loc9_ && _loc8_ != _loc9_)
            {
               this.FScene.tf_passiveSkill.text = _loc8_;
            }
            else if(_loc7_ != _loc9_ && _loc8_ == _loc9_)
            {
               this.FScene.tf_passiveSkill.text = _loc7_;
            }
            else
            {
               this.FScene.tf_passiveSkill.text = _loc7_ + _loc8_;
            }
            this.FScene.tf_CustomskillDescription.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.Exclusive_CloseViewTxt);
            this.FScene.tf_attackEffect.text = _loc9_;
            this.FScene.tf_attrPower.text = _loc9_;
            if(this.FEnemyData.AttrPower == 0)
            {
               this.FScene.tf_attrPower.text = _loc9_;
            }
            else
            {
               this.FScene.tf_attrPower.text = _loc10_[this.FEnemyData.AttrPower - 1];
            }
            if(this.FEnemyData.AttackEffect == 0)
            {
               this.FScene.tf_attackEffect.text = _loc9_;
            }
            else
            {
               this.FScene.tf_attackEffect.text = _loc11_[this.FEnemyData.AttackEffect - 1];
            }
         }
      }
      
      protected function CheckTipPoint() : void
      {
         if(mouseX > CONST_COMMON.STAGE_Width - this.FScene.width)
         {
            this.FScene.x = Math.max(mouseX - this.FScene.width - 40,0);
         }
         else
         {
            this.FScene.x = Math.min(mouseX + 40,CONST_COMMON.STAGE_Width - this.FScene.width);
         }
         if(mouseY > CONST_COMMON.STAGE_Height - this.FScene.height)
         {
            this.FScene.y = Math.max(mouseY - this.FScene.height,0);
         }
         else
         {
            this.FScene.y = Math.min(mouseY,CONST_COMMON.STAGE_Height - this.FScene.height);
         }
      }
      
      public function SetHeroData(param1:THero = null, param2:TEnemy = null) : void
      {
         if(param1 != null)
         {
            this.FHeroData = param1;
            this.FEnemyData = null;
         }
         else if(param2 != null)
         {
            this.FEnemyData = param2;
            this.FHeroData = null;
         }
         this.UpdataUI();
      }
      
      public function UpdataBitmap() : void
      {
         var _loc1_:TRoleModel = null;
         this.FHeadBitmap.bitmapData = null;
         if(this.FHeroData != null)
         {
            _loc1_ = this.FRoleModel.GetDatebaseByIdentifier(this.FHeroData.Identifier) as TRoleModel;
         }
         else if(this.FEnemyData != null)
         {
            _loc1_ = this.FRoleModel.GetDatebaseByIdentifier(this.FEnemyData.HeroIcon) as TRoleModel;
         }
         if(_loc1_ != null)
         {
            TGameUtil.ShowImageByID(TGameUtil.Type_HeadIcon,this.FHeadBitmap,_loc1_.RoleHead);
         }
         this.CheckTipPoint();
      }
   }
}

