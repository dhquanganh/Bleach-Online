package Processors.Game.Lobby.Common.Hero
{
   import Components.Standard.TUIButton;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   
   public class TProcessorWindowGeneralsIntroduced extends TProcessorLobbyWindow
   {
      
      protected static const BTN_QUALITY_BULE:uint = 3;
      
      protected static const BTN_QUALITY_PURPLE:uint = 4;
      
      protected static const BTN_QUALITY_GOLD:uint = 5;
      
      protected static const BTN_QUALITY_ORANGE:uint = 6;
      
      protected static const COLOR_QUALITY_BULE:uint = 6094297;
      
      protected static const COLOR_QUALITY_PURPLE:uint = 14245117;
      
      protected static const COLOR_QUALITY_GOLD:uint = 16763904;
      
      protected static const COLOR_QUALITY_ORANGE:uint = 16724736;
      
      protected static const StarMaxNum:int = 7;
      
      protected var FScene:MovieClip;
      
      protected var FBaseHeroBins:TBins;
      
      protected var FRoleModelBins:TBins;
      
      protected var FHeroTalentBins:TBins;
      
      protected var FSkillConfigBins:TBins;
      
      protected var FBaseHero:TBaseHero;
      
      protected var FHeadIcon:uint;
      
      protected var FHeroId:uint;
      
      protected var FHeadBitmap:Bitmap;
      
      protected var FHint:THint;
      
      protected var FHeroTalent:THeroTalent;
      
      protected var FSkillConfig:TSkillConfig;
      
      protected var FStars:Sprite;
      
      protected var FHeroChangeLightStars:Vector.<Sprite>;
      
      protected var FHeroChangeDarkStars:Vector.<Sprite>;
      
      protected var FBT_Close:TUIButton;
      
      protected var FBarrierDeactuate:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      public function TProcessorWindowGeneralsIntroduced(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfCommon.LoadPrimary(CONST_COMMON.RESOURCESID_SwfCommon_ViewHeroInfo);
         super.ResourcesPerform_UIRequest();
      }
      
      public function UIDispatch() : void
      {
         this.InitRecruit();
      }
      
      protected function InitRecruit() : void
      {
         var _loc1_:int = 0;
         this.FHint = new THint();
         this.FBaseHeroBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         this.FRoleModelBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         this.FHeroTalentBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HeroTalent);
         this.FSkillConfigBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SkillConfig);
         this.FHeadBitmap = new Bitmap();
         this.FScene = TUtilityReflection.CreateDisplayObjectInstance(CONST_TAVERN.RESOURCESID_CLASSNAME_TavernTip) as MovieClip;
         if(this.FScene == null)
         {
            return;
         }
         addChild(this.FScene);
         this.FBT_Close = new TUIButton();
         this.FBT_Close.Substrate = this.FScene.btn_close;
         this.FBT_Close.OnClick = this.BtnCloseOnClick;
         this.FScene.mc_headIcon.addChild(this.FHeadBitmap);
         this.FScene.tf_talent.addEventListener(MouseEvent.MOUSE_MOVE,this.SkillOnMove);
         this.FScene.tf_talent.addEventListener(MouseEvent.ROLL_OUT,this.SkillOnOut);
         this.FStars = this.FScene["HeroChangLevel"];
         if(this.FStars != null)
         {
            this.FStars.visible = false;
            this.FStars.addEventListener(MouseEvent.MOUSE_MOVE,this.StarOnMouseOver);
            this.FStars.addEventListener(MouseEvent.MOUSE_OUT,this.StarOnMouseOut);
         }
         this.FStars.visible = true;
         this.FHeroChangeLightStars = new Vector.<Sprite>();
         this.FHeroChangeDarkStars = new Vector.<Sprite>();
         _loc1_ = 0;
         while(_loc1_ < StarMaxNum)
         {
            this.FHeroChangeLightStars.push(this.FScene["HeroChangLevel"]["LightStar" + _loc1_]);
            this.FHeroChangeDarkStars.push(this.FScene["HeroChangLevel"]["DarkStar" + _loc1_]);
            _loc1_++;
         }
      }
      
      protected function GetPostion(param1:int) : String
      {
         var _loc2_:String = "";
         if(CONST_CHARACTER.PROFESSION_Agility == param1)
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_17);
         }
         if(CONST_CHARACTER.PROFESSION_Defending == param1)
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_16);
         }
         if(CONST_CHARACTER.PROFESSION_Intellect == param1)
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_18);
         }
         if(CONST_CHARACTER.PROFESSION_Strength == param1)
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_17);
         }
         if(CONST_CHARACTER.PROFESSION_Warlock == param1)
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_18);
         }
         return _loc2_;
      }
      
      protected function GetColorWithQuality(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case BTN_QUALITY_BULE:
               _loc2_ = COLOR_QUALITY_BULE;
               break;
            case BTN_QUALITY_PURPLE:
               _loc2_ = COLOR_QUALITY_PURPLE;
               break;
            case BTN_QUALITY_GOLD:
               _loc2_ = COLOR_QUALITY_GOLD;
               break;
            case BTN_QUALITY_ORANGE:
               _loc2_ = COLOR_QUALITY_ORANGE;
               break;
            default:
               _loc2_ = COLOR_QUALITY_BULE;
         }
         return _loc2_;
      }
      
      protected function UpdataUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:THeroChangeAttr = null;
         if(this.FBaseHero == null)
         {
            return;
         }
         this.FScene.btn_close.visible = true;
         this.FScene.tf_HeroName.text = this.FBaseHero.Name;
         this.FScene.tf_HeroName.textColor = this.GetColorWithQuality(this.FBaseHero.Quality);
         this.FScene.tf_briefIntroduction.text = this.FBaseHero.Desc;
         this.FScene.tf_profession.text = TUtilityLobby.GetProfessionByIndex(this.FBaseHero.Profession);
         this.FScene.tf_location.text = this.GetPostion(this.FBaseHero.Profession);
         this.FScene.tf_strength.text = this.FBaseHero.Power;
         this.FScene.tf_intelligence.text = this.FBaseHero.Intelligence;
         this.FScene.tf_agile.text = this.FBaseHero.Agile;
         this.FScene.tf_life.text = this.FBaseHero.Life;
         this.FScene.tf_strengthRate.text = this.FBaseHero.PowerGrow;
         this.FScene.tf_intelligenceRate.text = this.FBaseHero.IntelligenceGrow;
         this.FScene.tf_agileRate.text = this.FBaseHero.AgileGrow;
         this.FScene.tf_lifeRate.text = this.FBaseHero.LifeGrow;
         this.FHeroTalent = this.FHeroTalentBins.GetDatebaseByIdentifier(this.FBaseHero.Talent) as THeroTalent;
         this.FScene.tf_talent.text = this.FHeroTalent.TalentName;
         this.FSkillConfig = this.FSkillConfigBins.GetDatebaseByIdentifier(this.FBaseHero.Active) as TSkillConfig;
         this.FScene.tf_skill.text = this.FSkillConfig.Name;
         this.FScene.tf_SkillsIntroduced.text = this.FSkillConfig.Desc;
         this.FScene.mc_assess.gotoAndStop(this.FBaseHero.Assess);
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroChangeAttr,this.FHeroId) as THeroChangeAttr;
         _loc1_ = 0;
         while(_loc1_ < StarMaxNum)
         {
            this.FHeroChangeLightStars[_loc1_].visible = false;
            this.FHeroChangeDarkStars[_loc1_].visible = _loc1_ < _loc2_.HeroStar.length;
            _loc1_++;
         }
      }
      
      protected function HeroPicArrive(param1:Object, param2:TTexture, param3:uint) : void
      {
         if(this.FBaseHero != null && this.FHeadIcon == param3)
         {
            this.FHeadBitmap.bitmapData = param2.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(0).Surface;
         }
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent = null) : void
      {
         if(this.FBarrierDeactuate != null)
         {
            this.FBarrierDeactuate(this);
         }
         ProcessorWindowClose();
      }
      
      protected function SkillOnMove(param1:MouseEvent) : void
      {
         if(this.FHintOnOver != null)
         {
            if(param1.currentTarget == this.FScene.tf_talent)
            {
               this.FHint.Caption = this.FHeroTalent.TalentDesc;
            }
            this.FHintOnOver(param1,this.FHint);
         }
      }
      
      protected function SkillOnOut(param1:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      protected function StarOnMouseOver(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(this.FHeroId));
      }
      
      protected function StarOnMouseOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(this.FHeroId));
      }
      
      public function get BarrierDeactuate() : Function
      {
         return this.FBarrierDeactuate;
      }
      
      public function set BarrierDeactuate(param1:Function) : void
      {
         this.FBarrierDeactuate = param1;
      }
      
      public function get HintOnOver() : Function
      {
         return this.FHintOnOver;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function SetHeroData(param1:uint) : void
      {
         var _loc2_:TRoleModel = null;
         this.FHeroId = param1;
         this.FBaseHero = this.FBaseHeroBins.GetDatebaseByIdentifier(this.FHeroId) as TBaseHero;
         _loc2_ = this.FRoleModelBins.GetDatebaseByIdentifier(this.FHeroId) as TRoleModel;
         this.FHeadIcon = _loc2_.RoleHead;
         this.UpdataUI();
         SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FHeadIcon,this.HeroPicArrive);
      }
      
      public function Reset() : void
      {
         this.FHeadIcon = 0;
         if(this.FHeadBitmap != null)
         {
            this.FHeadBitmap.bitmapData = null;
         }
      }
   }
}

