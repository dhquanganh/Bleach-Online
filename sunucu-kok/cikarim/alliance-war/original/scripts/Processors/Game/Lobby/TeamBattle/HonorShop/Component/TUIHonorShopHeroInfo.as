package Processors.Game.Lobby.TeamBattle.HonorShop.Component
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.TBaseHero;
   import Logics.DatebaseVO.VO.THeroChangeAttr;
   import Logics.DatebaseVO.VO.THeroTalent;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.DatebaseVO.VO.TSkillConfig;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_CHARACTER;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_HONORSHOP;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIHonorShopHeroInfo extends TUIComponent
   {
      
      protected static const BTN_QUALITY_BULE:uint = 3;
      
      protected static const BTN_QUALITY_PURPLE:uint = 4;
      
      protected static const BTN_QUALITY_GOLD:uint = 5;
      
      protected static const BTN_QUALITY_ORANGE:uint = 6;
      
      protected static const COLOR_QUALITY_BULE:uint = 6094297;
      
      protected static const COLOR_QUALITY_PURPLE:uint = 14245117;
      
      protected static const COLOR_QUALITY_GOLD:uint = 16763904;
      
      protected static const COLOR_QUALITY_ORANGE:uint = 16724736;
      
      protected static const INDEX_Station_Front:int = 1;
      
      protected static const INDEX_Station_Middle:int = 2;
      
      protected static const INDEX_Station_After:int = 3;
      
      protected static const StarMaxNum:int = 7;
      
      protected var FMC_Scene:Sprite;
      
      protected var FMC_LargeIcon:MovieClip;
      
      protected var FBitMap:Bitmap;
      
      protected var FMC_Formation:MovieClip;
      
      protected var FTF_HeroName:TextField;
      
      protected var FTF_Profession:TextField;
      
      protected var FTF_Location:TextField;
      
      protected var FTF_Talent:TextField;
      
      protected var FTF_Skill:TextField;
      
      protected var FTF_BriefIntroduction:TextField;
      
      protected var FTF_Strength:TextField;
      
      protected var FTF_StrengthRate:TextField;
      
      protected var FTF_Agile:TextField;
      
      protected var FTF_AgileRate:TextField;
      
      protected var FTF_Life:TextField;
      
      protected var FTF_LifeRate:TextField;
      
      protected var FTF_Intelligence:TextField;
      
      protected var FTF_IntelligenceRate:TextField;
      
      protected var FMC_Assess:MovieClip;
      
      protected var FBtn_Close:TUIButton;
      
      protected var FHeroTalentBins:TBins;
      
      protected var FSkillConfigBins:TBins;
      
      protected var FRoleModelBins:TBins;
      
      protected var FSkillConfig:TSkillConfig;
      
      protected var FHeroTalent:THeroTalent;
      
      protected var FBaseHero:TBaseHero;
      
      protected var FHeadIcon:uint;
      
      protected var FStars:Sprite;
      
      protected var FHeroChangeLightStars:Vector.<Sprite>;
      
      protected var FHeroChangeDarkStars:Vector.<Sprite>;
      
      protected var FHint:THint;
      
      protected var FOnHintOver:Function;
      
      protected var FOnHintOut:Function;
      
      public function TUIHonorShopHeroInfo(param1:TUIComponent)
      {
         super(param1);
         this.FHint = new THint();
      }
      
      protected function Resources_UIDispatch(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         this.FMC_Scene = param1;
         this.FMC_LargeIcon = this.FMC_Scene[CONST_HONORSHOP.RESOURCE_Link_MC_LargeIcon];
         this.FMC_LargeIcon.mouseChildren = false;
         this.FMC_LargeIcon.mouseEnabled = false;
         this.FBitMap = new Bitmap();
         this.FMC_LargeIcon.addChild(this.FBitMap);
         this.FMC_Formation = this.FMC_Scene[CONST_HONORSHOP.RESOURCE_Link_MC_Formation];
         this.FMC_Formation.mouseEnabled = false;
         this.FMC_Formation.mouseChildren = false;
         this.FTF_HeroName = this.FMC_Scene[CONST_HONORSHOP.RESOURCE_Link_TF_HeroName];
         this.FTF_HeroName.text = "";
         this.FTF_HeroName.mouseEnabled = false;
         this.FTF_Profession = this.FMC_Scene[CONST_HONORSHOP.RESOURCE_Link_TF_Profession];
         this.FTF_Profession.mouseEnabled = false;
         this.FTF_Profession.text = "";
         this.FTF_Location = this.FMC_Scene[CONST_HONORSHOP.RESOURCE_Link_TF_Location];
         this.FTF_Location.mouseEnabled = false;
         this.FTF_Location.text = "";
         this.FTF_Talent = this.FMC_Scene[CONST_HONORSHOP.RESOURCE_Link_TF_Talent];
         this.FTF_Talent.addEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver);
         this.FTF_Talent.addEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut);
         this.FTF_Talent.text = "";
         this.FTF_Skill = this.FMC_Scene[CONST_HONORSHOP.RESOURCE_Link_TF_Skill];
         this.FTF_Skill.addEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver);
         this.FTF_Skill.addEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut);
         this.FTF_Skill.text = "";
         this.FTF_BriefIntroduction = this.FMC_Scene[CONST_HONORSHOP.RESOURCE_Link_TF_BriefIntroduction];
         this.FTF_BriefIntroduction.mouseEnabled = false;
         this.FTF_BriefIntroduction.text = "";
         this.FTF_Strength = this.FMC_Scene[CONST_HONORSHOP.RESOURCE_Link_TF_Strength];
         this.FTF_Strength.mouseEnabled = false;
         this.FTF_Strength.text = "";
         this.FTF_StrengthRate = this.FMC_Scene[CONST_HONORSHOP.RESOURCE_Link_TF_StrengthRate];
         this.FTF_StrengthRate.addEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver);
         this.FTF_StrengthRate.addEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut);
         this.FTF_StrengthRate.text = "";
         this.FTF_Agile = this.FMC_Scene[CONST_HONORSHOP.RESOURCE_Link_TF_Agile];
         this.FTF_Agile.mouseEnabled = false;
         this.FTF_Agile.text = "";
         this.FTF_AgileRate = this.FMC_Scene[CONST_HONORSHOP.RESOURCE_Link_TF_AgileRate];
         this.FTF_AgileRate.addEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver);
         this.FTF_AgileRate.addEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut);
         this.FTF_AgileRate.text = "";
         this.FTF_Life = this.FMC_Scene[CONST_HONORSHOP.RESOURCE_Link_TF_Life];
         this.FTF_Life.mouseEnabled = false;
         this.FTF_Life.text = "";
         this.FTF_LifeRate = this.FMC_Scene[CONST_HONORSHOP.RESOURCE_Link_TF_LifeRate];
         this.FTF_LifeRate.addEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver);
         this.FTF_LifeRate.addEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut);
         this.FTF_LifeRate.text = "";
         this.FTF_Intelligence = this.FMC_Scene[CONST_HONORSHOP.RESOURCE_Link_TF_Intelligence];
         this.FTF_Intelligence.mouseEnabled = false;
         this.FTF_Intelligence.text = "";
         this.FTF_IntelligenceRate = this.FMC_Scene[CONST_HONORSHOP.RESOURCE_Link_TF_IntelligenceRate];
         this.FTF_IntelligenceRate.addEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver);
         this.FTF_IntelligenceRate.addEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut);
         this.FTF_IntelligenceRate.text = "";
         this.FMC_Assess = this.FMC_Scene[CONST_HONORSHOP.RESOURCE_Link_MC_Assess];
         this.FMC_Assess.mouseChildren = false;
         this.FMC_Assess.mouseEnabled = false;
         this.FBtn_Close = new TUIButton();
         this.FBtn_Close.Substrate = this.FMC_Scene[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Close.OnClick = this.BtnOnClose;
         this.FHeroTalentBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HeroTalent);
         this.FSkillConfigBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SkillConfig);
         this.FRoleModelBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         this.FStars = this.FMC_Scene["HeroChangLevel"];
         if(this.FStars != null)
         {
            this.FStars.visible = false;
            this.FStars.addEventListener(MouseEvent.MOUSE_MOVE,this.StarOnMouseOver);
            this.FStars.addEventListener(MouseEvent.MOUSE_OUT,this.StarOnMouseOut);
         }
         this.FStars.visible = true;
         this.FHeroChangeLightStars = new Vector.<Sprite>();
         this.FHeroChangeDarkStars = new Vector.<Sprite>();
         _loc2_ = 0;
         while(_loc2_ < StarMaxNum)
         {
            this.FHeroChangeLightStars.push(this.FMC_Scene["HeroChangLevel"]["LightStar" + _loc2_]);
            this.FHeroChangeDarkStars.push(this.FMC_Scene["HeroChangLevel"]["DarkStar" + _loc2_]);
            _loc2_++;
         }
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:TRoleModel = null;
         var _loc2_:THeroChangeAttr = null;
         var _loc3_:int = 0;
         if(this.FBaseHero == null)
         {
            return;
         }
         this.FTF_HeroName.text = this.FBaseHero.Name;
         this.FTF_HeroName.textColor = this.GetColorWithQuality(this.FBaseHero.Quality);
         this.FTF_BriefIntroduction.text = this.FBaseHero.Desc;
         this.FTF_Profession.text = TUtilityLobby.GetProfessionByIndex(this.FBaseHero.Profession);
         this.FTF_Location.text = this.GetPostion(this.FBaseHero.Profession);
         this.FTF_Strength.text = this.FBaseHero.Power.toString();
         this.FTF_Intelligence.text = this.FBaseHero.Intelligence.toString();
         this.FTF_Agile.text = this.FBaseHero.Agile.toString();
         this.FTF_Life.text = this.FBaseHero.Life.toString();
         this.FTF_StrengthRate.text = this.FBaseHero.PowerGrow.toString();
         this.FTF_IntelligenceRate.text = this.FBaseHero.IntelligenceGrow.toString();
         this.FTF_AgileRate.text = this.FBaseHero.AgileGrow.toString();
         this.FTF_LifeRate.text = this.FBaseHero.LifeGrow.toString();
         this.FHeroTalent = this.FHeroTalentBins.GetDatebaseByIdentifier(this.FBaseHero.Talent) as THeroTalent;
         this.FTF_Talent.text = this.FHeroTalent.TalentName;
         this.FSkillConfig = this.FSkillConfigBins.GetDatebaseByIdentifier(this.FBaseHero.Active) as TSkillConfig;
         this.FTF_Skill.text = this.FSkillConfig.Name;
         this.FMC_Assess.gotoAndStop(this.FBaseHero.Assess);
         this.FMC_Formation.gotoAndStop(this.GetStandPositionWithProfession(this.FBaseHero.Profession));
         _loc1_ = this.FRoleModelBins.GetDatebaseByIdentifier(this.FBaseHero.Identifier) as TRoleModel;
         this.FHeadIcon = _loc1_.RoleStyle;
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FHeadIcon,this.AutoLoadCallBack);
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroChangeAttr,this.FBaseHero.Identifier) as THeroChangeAttr;
         _loc3_ = 0;
         while(_loc3_ < StarMaxNum)
         {
            this.FHeroChangeLightStars[_loc3_].visible = false;
            this.FHeroChangeDarkStars[_loc3_].visible = _loc3_ < _loc2_.HeroStar.length;
            _loc3_++;
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
      
      protected function GetStandPositionWithProfession(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case CONST_CHARACTER.PROFESSION_Agility:
            case CONST_CHARACTER.PROFESSION_Strength:
               _loc2_ = uint(INDEX_Station_Middle);
               break;
            case CONST_CHARACTER.PROFESSION_Defending:
               _loc2_ = uint(INDEX_Station_Front);
               break;
            case CONST_CHARACTER.PROFESSION_Intellect:
               _loc2_ = uint(INDEX_Station_After);
         }
         return _loc2_;
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         switch(param3)
         {
            case this.FHeadIcon:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc5_ = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FBitMap.bitmapData = _loc5_;
         }
      }
      
      protected function DoClear() : void
      {
         this.FBitMap.bitmapData = null;
      }
      
      protected function BtnOnClose(param1:Object, param2:MouseEvent) : void
      {
         this.Hide();
      }
      
      protected function TextOnOver(param1:MouseEvent) : void
      {
         var _loc2_:TextField = null;
         if(this.FOnHintOver != null)
         {
            _loc2_ = param1.currentTarget as TextField;
            if(_loc2_ == this.FTF_Skill)
            {
               this.FHint.Caption = this.FSkillConfig.Desc;
            }
            else if(_loc2_ == this.FTF_Talent)
            {
               this.FHint.Caption = this.FHeroTalent.TalentDesc;
            }
            else if(_loc2_ == this.FTF_AgileRate)
            {
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_13) + this.FBaseHero.AgileGrow.toString();
            }
            else if(_loc2_ == this.FTF_IntelligenceRate)
            {
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_15) + this.FBaseHero.IntelligenceGrow.toString();
            }
            else if(_loc2_ == this.FTF_LifeRate)
            {
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_14) + this.FBaseHero.LifeGrow.toString();
            }
            else if(_loc2_ == this.FTF_StrengthRate)
            {
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_12) + this.FBaseHero.PowerGrow.toString();
            }
            this.FOnHintOver(param1,this.FHint);
         }
      }
      
      protected function TextOnOut(param1:MouseEvent) : void
      {
         if(this.FOnHintOut != null)
         {
            this.FOnHintOut(this,this.FHint);
         }
      }
      
      protected function StarOnMouseOver(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(this.FBaseHero.Identifier));
      }
      
      protected function StarOnMouseOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(this.FBaseHero.Identifier));
      }
      
      public function get OnHintOver() : Function
      {
         return this.FOnHintOver;
      }
      
      public function set OnHintOver(param1:Function) : void
      {
         this.FOnHintOver = param1;
      }
      
      public function get OnHintOut() : Function
      {
         return this.FOnHintOut;
      }
      
      public function set OnHintOut(param1:Function) : void
      {
         this.FOnHintOut = param1;
      }
      
      public function Perform_UIDispatch(param1:Sprite) : void
      {
         this.Resources_UIDispatch(param1);
      }
      
      public function ProcessorUpdateUI(param1:TBaseHero) : void
      {
         this.FBaseHero = param1;
      }
      
      public function Clear() : void
      {
         this.DoClear();
      }
      
      public function Show() : void
      {
         this.UpdateUI();
         this.FMC_Scene.visible = true;
      }
      
      public function Hide() : void
      {
         this.FMC_Scene.visible = false;
      }
   }
}

