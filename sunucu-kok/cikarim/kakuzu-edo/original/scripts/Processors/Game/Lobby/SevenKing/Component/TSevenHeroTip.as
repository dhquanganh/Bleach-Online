package Processors.Game.Lobby.SevenKing.Component
{
   import Foundation.Common.Integer.UInt64;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Characters.THero;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.THeroExp;
   import Logics.DatebaseVO.VO.TSkillConfig;
   import Logics.Rebirth.TRebirthData;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_CHARACTER;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SEVENKING;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   
   public class TSevenHeroTip extends TUIComponent
   {
      
      protected static const TYPE_PHYSICAL:uint = 1;
      
      protected static const TYPE_MAGIC:uint = 2;
      
      protected var FScene:MovieClip;
      
      protected var FHeroData:THero;
      
      protected var FHeadBitmap:Bitmap;
      
      protected var FRoleModel:TBins;
      
      protected var FHeroHeadId:uint;
      
      protected var FRebirthData:TRebirthData;
      
      public function TSevenHeroTip(param1:TUIComponent)
      {
         super(param1);
         this.InitDeploymentTip();
         this.FRebirthData = SLogicsCore.RebirthData;
      }
      
      protected function InitDeploymentTip() : void
      {
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_SEVENKING.RESOURCESID_CLASSNAME_Tip) as MovieClip;
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
         var _loc6_:UInt64 = null;
         this.FHeadBitmap.bitmapData = null;
         this.FScene.tf_power.text = this.FHeroData.BaseAttributePower.toString();
         this.FScene.tf_intelligence.text = this.FHeroData.BaseAttributeIntelligence.toString();
         this.FScene.tf_agile.text = this.FHeroData.BaseAttributeAgile.toString();
         this.FScene.tf_speed.text = this.FHeroData.BaseAttributeSpeed.toString();
         this.FScene.tf_health.text = this.FHeroData.BaseAttributeHealth.toString();
         this.FScene.tf_physicalDefends.text = this.FHeroData.BaseAttributePhysicalDefends.toString();
         this.FScene.tf_magicDefends.text = this.FHeroData.BaseAttributeMagicDefends.toString();
         if(this.FHeroData.Profession != CONST_CHARACTER.PROFESSION_Intellect)
         {
            this.FScene.tf_attact.text = this.FHeroData.BaseAttributePhysicalAttack.toString();
            this.FScene.mc_attackName.gotoAndStop(TYPE_PHYSICAL);
         }
         else
         {
            this.FScene.tf_attact.text = this.FHeroData.BaseAttributeMagicAttack.toString();
            this.FScene.mc_attackName.gotoAndStop(TYPE_MAGIC);
         }
         this.FScene.tf_hit.text = this.FHeroData.BaseAttributeHit + "%";
         this.FScene.tf_dodge.text = this.FHeroData.BaseAttributeDodge + "%";
         this.FScene.tf_crit.text = this.FHeroData.BaseAttributeCrit + "%";
         this.FScene.tf_gridFile.text = this.FHeroData.BaseAttributeGridFile + "%";
         this.FScene.tf_wreck.text = this.FHeroData.BaseAttributeWreck + "%";
         this.FScene.tf_help.text = this.FHeroData.BaseAttributeHelp + "%";
         this.FScene.tf_punch.text = this.FHeroData.BaseAttributePunch + "%";
         this.FScene.tf_uprising.text = this.FHeroData.BaseAttributeUprising + "%";
         this.FScene.mc_posIcon.gotoAndStop(this.FHeroData.StandPositionWithProfession);
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroExp,this.FHeroData.RebirthLevel) as THeroExp;
         _loc6_ = this.FRebirthData.CalNeedExpByUInt64(_loc2_.NeedExp,this.FHeroData.RebirthNum);
         this.FScene.tf_level.text = String(this.FHeroData.RebirthLevel);
         this.FScene.tf_name.text = this.FHeroData.Name ? this.FHeroData.Name : "";
         this.FScene.tf_name.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[this.FHeroData.Quality];
         this.FScene.tf_exp.text = this.FHeroData.Experience.ToString() + "/" + _loc6_.ToString();
         this.FScene.mc_expLine.scaleX = this.FHeroData.Experience.ToNumber() / _loc6_.ToNumber();
         this.FScene.tf_skillName.text = this.FHeroData.Skill.Name;
         this.FScene.tf_talent.text = this.FHeroData.TalentName;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,this.FHeroData.Identifier) as TBaseHero;
         this.FScene.mc_evaluate.gotoAndStop(_loc3_.Assess);
         this.FHeroHeadId = this.FHeroData.Identifier;
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FHeroHeadId,this.AutoLoadCallBack);
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         switch(param3)
         {
            case this.FHeroHeadId:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc5_ = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FHeadBitmap.bitmapData = _loc5_;
               this.CheckTipPoint();
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
      
      public function SetHeroData(param1:THero) : void
      {
         this.FHeroData = param1;
         this.UpdataUI();
      }
      
      public function Reset() : void
      {
         this.FHeroData = null;
         this.FHeadBitmap.bitmapData = null;
      }
   }
}

