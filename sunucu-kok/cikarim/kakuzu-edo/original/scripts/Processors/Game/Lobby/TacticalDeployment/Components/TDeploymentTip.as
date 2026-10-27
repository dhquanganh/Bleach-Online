package Processors.Game.Lobby.TacticalDeployment.Components
{
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.THeroExp;
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
   
   public class TDeploymentTip extends TUIComponent
   {
      
      protected static const TYPE_PHYSICAL:uint = 1;
      
      protected static const TYPE_MAGIC:uint = 2;
      
      protected var FScene:MovieClip;
      
      protected var FHeroData:THero;
      
      protected var FHeadBitmap:Bitmap;
      
      protected var FRoleModel:TBins;
      
      public function TDeploymentTip(param1:TUIComponent)
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
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         this.UpdataBitmap();
         this.FHeadBitmap.bitmapData = null;
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
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroExp,this.FHeroData.Level) as THeroExp;
         this.FScene.tf_name.text = this.FHeroData.Name ? this.FHeroData.Name : "";
         this.FScene.tf_name.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[this.FHeroData.Quality];
         this.FScene.tf_skillName.text = this.FHeroData.Skill.Name;
         this.FScene.tf_talent.text = this.FHeroData.TalentName;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,this.FHeroData.Identifier) as TBaseHero;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SkillConfig,this.FHeroData.Skill.Identifier) as TSkillConfig;
         _loc5_ = _loc4_.Desc;
         _loc5_ = _loc5_.split("%colour%").join("#fffe0000");
         this.FScene.tf_skillDescription.htmlText = _loc5_;
         this.FScene.tf_auraSkill.text = CONST_SKILL.SkillDescByHero(CONST_SKILL.TYPE_AURA,this.FHeroData);
         this.FScene.tf_deadSkill.text = CONST_SKILL.SkillDescByHero(CONST_SKILL.TYPE_DEAD,this.FHeroData);
         _loc6_ = CONST_SKILL.SkillDescByHero(CONST_SKILL.TYPE_PASSIVE,this.FHeroData);
         _loc7_ = CONST_SKILL.SkillDescByHero(CONST_SKILL.TYPE_ROUND,this.FHeroData);
         _loc8_ = CONST_SKILL.SkillDesc(0,null);
         if(_loc6_ == _loc8_ && _loc7_ == _loc8_)
         {
            this.FScene.tf_passiveSkill.text = _loc8_;
         }
         else if(_loc6_ == _loc8_ && _loc7_ != _loc8_)
         {
            this.FScene.tf_passiveSkill.text = _loc7_;
         }
         else if(_loc6_ != _loc8_ && _loc7_ == _loc8_)
         {
            this.FScene.tf_passiveSkill.text = _loc6_;
         }
         else
         {
            this.FScene.tf_passiveSkill.text = _loc6_ + _loc7_;
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
            _loc5_ = _loc4_.Desc;
            _loc5_ = _loc5_.split("%colour%").join("#fffe0000");
            this.FScene.tf_skillDescription.htmlText = _loc5_;
         }
         this.FScene.tf_attackEffect.text = _loc8_;
         this.FScene.tf_attrPower.text = _loc8_;
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
      
      protected function PicHeadArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TRoleModel = null;
         if(this.FHeroData == null)
         {
            return;
         }
         _loc4_ = this.FRoleModel.GetDatebaseByIdentifier(this.FHeroData.Identifier) as TRoleModel;
         if(_loc4_.RoleHead == param3)
         {
            this.FHeadBitmap.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      public function SetHeroData(param1:THero) : void
      {
         var _loc2_:TRoleModel = null;
         this.FHeroData = param1;
         if(this.FHeroData == null)
         {
            return;
         }
         this.UpdataUI();
         _loc2_ = this.FRoleModel.GetDatebaseByIdentifier(this.FHeroData.Identifier) as TRoleModel;
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(_loc2_.RoleHead,this.PicHeadArrive);
      }
      
      public function UpdataBitmap() : void
      {
         this.CheckTipPoint();
      }
      
      public function Reset() : void
      {
         this.FHeadBitmap.bitmapData = null;
      }
   }
}

