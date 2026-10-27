package Processors.Game.Lobby.StoneShop.Components
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIHeroInfo
   {
      
      protected static const INDEX_TACTICALDEPLOYMENT_BEFORE:uint = CONST_HEROS.INDEX_TACTICALDEPLOYMENT_BEFORE;
      
      protected static const INDEX_TACTICALDEPLOYMENT_MIDDLE:uint = CONST_HEROS.INDEX_TACTICALDEPLOYMENT_MIDDLE;
      
      protected static const INDEX_TACTICALDEPLOYMENT_AFTER:uint = CONST_HEROS.INDEX_TACTICALDEPLOYMENT_AFTER;
      
      protected static const StarMaxNum:int = 7;
      
      protected var FHint:THint;
      
      protected var FBtn_Close:TUIButton;
      
      protected var FMC_Assess:MovieClip;
      
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
      
      protected var FMC_LargeIcon:MovieClip;
      
      protected var FBmpLargeIcon:Bitmap;
      
      protected var FBaseHeroBins:TBins;
      
      protected var FHeroTalentBins:TBins;
      
      protected var FSkillConfigBins:TBins;
      
      protected var FRoleModelBins:TBins;
      
      protected var FStrTalentDesc:String;
      
      protected var FStrSkillDesc:String;
      
      protected var FStrAgileGrow:String;
      
      protected var FStrIntelligenceGrow:String;
      
      protected var FStrPowerGrow:String;
      
      protected var FStrLifeGroW:String;
      
      protected var FStars:Sprite;
      
      protected var FHeroChangeLightStars:Vector.<Sprite>;
      
      protected var FHeroChangeDarkStars:Vector.<Sprite>;
      
      protected var FResource:Sprite;
      
      protected var FContext:TInventorySample;
      
      protected var FOnHintOver:Function;
      
      protected var FOnHintOut:Function;
      
      public function TUIHeroInfo()
      {
         super();
         this.FHint = new THint();
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         this.FBtn_Close = new TUIButton();
         this.FBtn_Close.Substrate = this.FResource[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FMC_Assess = this.FResource["MC_Assess"];
         this.FMC_Assess.mouseChildren = false;
         this.FMC_Assess.mouseEnabled = false;
         this.FMC_Formation = this.FResource["MC_Formation"];
         this.FMC_Formation.mouseEnabled = false;
         this.FMC_Formation.mouseChildren = false;
         this.FTF_HeroName = this.FResource["TF_HeroName"];
         this.FTF_HeroName.mouseEnabled = false;
         this.FTF_Profession = this.FResource["TF_Profession"];
         this.FTF_Profession.mouseEnabled = false;
         this.FTF_Location = this.FResource["TF_Location"];
         this.FTF_Location.mouseEnabled = false;
         this.FTF_Talent = this.FResource["TF_Talent"];
         this.FTF_Skill = this.FResource["TF_Skill"];
         this.FTF_BriefIntroduction = this.FResource["TF_BriefIntroduction"];
         this.FTF_BriefIntroduction.mouseEnabled = false;
         this.FTF_Strength = this.FResource["TF_Strength"];
         this.FTF_Strength.mouseEnabled = false;
         this.FTF_StrengthRate = this.FResource["TF_StrengthRate"];
         this.FTF_Agile = this.FResource["TF_Agile"];
         this.FTF_Agile.mouseEnabled = false;
         this.FTF_AgileRate = this.FResource["TF_AgileRate"];
         this.FTF_Life = this.FResource["TF_Life"];
         this.FTF_Life.mouseEnabled = false;
         this.FTF_LifeRate = this.FResource["TF_LifeRate"];
         this.FTF_Intelligence = this.FResource["TF_Intelligence"];
         this.FTF_Intelligence.mouseEnabled = false;
         this.FTF_IntelligenceRate = this.FResource["TF_IntelligenceRate"];
         this.FMC_LargeIcon = this.FResource["MC_LargeIcon"];
         this.FMC_LargeIcon.mouseChildren = false;
         this.FMC_LargeIcon.mouseEnabled = false;
         this.FBmpLargeIcon = new Bitmap();
         this.FMC_LargeIcon.addChild(this.FBmpLargeIcon);
         this.FBaseHeroBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         this.FHeroTalentBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HeroTalent);
         this.FSkillConfigBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SkillConfig);
         this.FRoleModelBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         this.FStars = this.FResource["HeroChangLevel"];
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
            this.FHeroChangeLightStars.push(this.FResource["HeroChangLevel"]["LightStar" + _loc1_]);
            this.FHeroChangeDarkStars.push(this.FResource["HeroChangLevel"]["DarkStar" + _loc1_]);
            _loc1_++;
         }
         this.Reset();
      }
      
      protected function addEventListenerPlayer() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FBtn_Close.OnClick = this.Btn_CloseOnClick;
         this.FTF_Talent.addEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver,false,0,true);
         this.FTF_Talent.addEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut,false,0,true);
         this.FTF_Skill.addEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver,false,0,true);
         this.FTF_Skill.addEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut,false,0,true);
         this.FTF_StrengthRate.addEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver,false,0,true);
         this.FTF_StrengthRate.addEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut,false,0,true);
         this.FTF_AgileRate.addEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver,false,0,true);
         this.FTF_AgileRate.addEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut,false,0,true);
         this.FTF_LifeRate.addEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver,false,0,true);
         this.FTF_LifeRate.addEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut,false,0,true);
         this.FTF_IntelligenceRate.addEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver,false,0,true);
         this.FTF_IntelligenceRate.addEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut,false,0,true);
      }
      
      protected function RemoveEventListenerPlayer() : void
      {
         if(this.FResource == null)
         {
            return;
         }
         this.FBtn_Close.OnClick = null;
         this.FTF_Talent.removeEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver);
         this.FTF_Talent.removeEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut);
         this.FTF_Skill.removeEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver);
         this.FTF_Skill.removeEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut);
         this.FTF_StrengthRate.removeEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver);
         this.FTF_StrengthRate.removeEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut);
         this.FTF_AgileRate.removeEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver);
         this.FTF_AgileRate.removeEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut);
         this.FTF_LifeRate.removeEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver);
         this.FTF_LifeRate.removeEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut);
         this.FTF_IntelligenceRate.removeEventListener(MouseEvent.MOUSE_MOVE,this.TextOnOver);
         this.FTF_IntelligenceRate.removeEventListener(MouseEvent.MOUSE_OUT,this.TextOnOut);
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:TRoleModel = null;
         var _loc2_:TSkillConfig = null;
         var _loc3_:THeroTalent = null;
         var _loc4_:TBaseHero = null;
         var _loc5_:THeroChangeAttr = null;
         var _loc6_:int = 0;
         _loc4_ = this.FBaseHeroBins.GetDatebaseByIdentifier(this.FContext.TemplateID) as TBaseHero;
         this.FTF_HeroName.text = _loc4_.Name;
         this.FTF_HeroName.textColor = CONST_COMMON.QUALITYCOLOR_INDEX[_loc4_.Quality];
         this.FTF_BriefIntroduction.text = _loc4_.Desc;
         this.FTF_Profession.text = TUtilityLobby.GetProfessionByIndex(_loc4_.Profession);
         this.FTF_Location.text = this.GetProfessionByPostion(_loc4_.Profession);
         this.FTF_Strength.text = _loc4_.Power.toString();
         this.FTF_Intelligence.text = _loc4_.Intelligence.toString();
         this.FTF_Agile.text = _loc4_.Agile.toString();
         this.FTF_Life.text = _loc4_.Life.toString();
         this.FTF_StrengthRate.text = _loc4_.PowerGrow.toString();
         this.FTF_IntelligenceRate.text = _loc4_.IntelligenceGrow.toString();
         this.FTF_AgileRate.text = _loc4_.AgileGrow.toString();
         this.FTF_LifeRate.text = _loc4_.LifeGrow.toString();
         this.FStrAgileGrow = _loc4_.AgileGrow.toString();
         this.FStrIntelligenceGrow = _loc4_.IntelligenceGrow.toString();
         this.FStrPowerGrow = _loc4_.PowerGrow.toString();
         this.FStrLifeGroW = _loc4_.LifeGrow.toString();
         _loc3_ = this.FHeroTalentBins.GetDatebaseByIdentifier(_loc4_.Talent) as THeroTalent;
         this.FTF_Talent.text = _loc3_.TalentName;
         this.FStrTalentDesc = _loc3_.TalentDesc;
         _loc2_ = this.FSkillConfigBins.GetDatebaseByIdentifier(_loc4_.Active) as TSkillConfig;
         this.FTF_Skill.text = _loc2_.Name;
         this.FStrSkillDesc = _loc2_.Desc;
         this.FMC_Assess.gotoAndStop(_loc4_.Assess);
         this.FMC_Formation.gotoAndStop(this.GetStandPositionWithProfession(_loc4_.Profession));
         _loc1_ = this.FRoleModelBins.GetDatebaseByIdentifier(_loc4_.Identifier) as TRoleModel;
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(_loc1_.RoleStyle,this.AutoLoadCallBack);
         _loc5_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroChangeAttr,_loc4_.Identifier) as THeroChangeAttr;
         _loc6_ = 0;
         while(_loc6_ < StarMaxNum)
         {
            this.FHeroChangeLightStars[_loc6_].visible = false;
            this.FHeroChangeDarkStars[_loc6_].visible = _loc6_ < _loc5_.HeroStar.length;
            _loc6_++;
         }
      }
      
      protected function GetProfessionByPostion(param1:int) : String
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
      
      protected function GetStandPositionWithProfession(param1:uint) : uint
      {
         var _loc2_:uint = 0;
         switch(param1)
         {
            case CONST_CHARACTER.PROFESSION_Agility:
            case CONST_CHARACTER.PROFESSION_Strength:
               _loc2_ = INDEX_TACTICALDEPLOYMENT_MIDDLE;
               break;
            case CONST_CHARACTER.PROFESSION_Defending:
               _loc2_ = INDEX_TACTICALDEPLOYMENT_BEFORE;
               break;
            case CONST_CHARACTER.PROFESSION_Intellect:
               _loc2_ = INDEX_TACTICALDEPLOYMENT_AFTER;
         }
         return _loc2_;
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         _loc4_ = param2.GetAnimationSequenceByIndex(0);
         this.FBmpLargeIcon.bitmapData = _loc4_.GetAnimationFrameByIndex(0).Surface;
      }
      
      protected function Btn_CloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FResource.visible = false;
         this.Reset();
      }
      
      protected function TextOnOver(param1:MouseEvent) : void
      {
         var _loc2_:TextField = null;
         if(this.FOnHintOver != null)
         {
            _loc2_ = param1.currentTarget as TextField;
            if(TUtilityString.Empty(this.FHint.Caption))
            {
               if(_loc2_ == this.FTF_Skill)
               {
                  this.FHint.Caption = this.FStrSkillDesc;
               }
               else if(_loc2_ == this.FTF_Talent)
               {
                  this.FHint.Caption = this.FStrTalentDesc;
               }
               else if(_loc2_ == this.FTF_AgileRate)
               {
                  this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_13) + this.FStrAgileGrow;
               }
               else if(_loc2_ == this.FTF_IntelligenceRate)
               {
                  this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_15) + this.FStrIntelligenceGrow;
               }
               else if(_loc2_ == this.FTF_LifeRate)
               {
                  this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_14) + this.FStrLifeGroW;
               }
               else if(_loc2_ == this.FTF_StrengthRate)
               {
                  this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_12) + this.FStrPowerGrow;
               }
            }
            this.FOnHintOver(this,this.FHint);
         }
      }
      
      protected function TextOnOut(param1:MouseEvent) : void
      {
         if(this.FOnHintOut != null)
         {
            this.FOnHintOut(this,this.FHint);
            this.FHint.Caption = "";
         }
      }
      
      protected function StarOnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:TBaseHero = null;
         _loc2_ = this.FBaseHeroBins.GetDatebaseByIdentifier(this.FContext.TemplateID) as TBaseHero;
         SUtilityOverLayer.UIComponentsHintOnOver(this,SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(_loc2_.Identifier));
      }
      
      protected function StarOnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:TBaseHero = null;
         _loc2_ = this.FBaseHeroBins.GetDatebaseByIdentifier(this.FContext.TemplateID) as TBaseHero;
         SUtilityOverLayer.UIComponentsHintOnOut(this,SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(_loc2_.Identifier));
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         this.FResource = param1;
      }
      
      public function get Context() : TInventorySample
      {
         return this.FContext;
      }
      
      public function set Context(param1:TInventorySample) : void
      {
         this.Reset();
         if(this.FContext == null && param1 != null)
         {
            this.addEventListenerPlayer();
         }
         else if(param1 == null)
         {
            this.RemoveEventListenerPlayer();
         }
         this.FContext = param1;
         if(param1 != null)
         {
            this.UpdateUI();
         }
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
      
      public function set Visible(param1:Boolean) : void
      {
         if(this.FResource != null)
         {
            this.FResource.visible = param1;
         }
      }
      
      public function Perform_UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      public function Dispose() : void
      {
         this.Reset();
         this.FHint.Caption = null;
         this.FHint = null;
         this.FBtn_Close.Dispose();
         this.FBtn_Close = null;
         this.FMC_Assess = null;
         this.FMC_Formation = null;
         this.FTF_HeroName = null;
         this.FTF_Profession = null;
         this.FTF_Location = null;
         this.FTF_Talent = null;
         this.FTF_Skill = null;
         this.FTF_BriefIntroduction = null;
         this.FTF_Strength = null;
         this.FTF_StrengthRate = null;
         this.FTF_Agile = null;
         this.FTF_AgileRate = null;
         this.FTF_Life = null;
         this.FTF_LifeRate = null;
         this.FTF_Intelligence = null;
         this.FTF_IntelligenceRate = null;
         this.FMC_LargeIcon = null;
         if(this.FBmpLargeIcon.parent != null)
         {
            this.FBmpLargeIcon.parent.removeChild(this.FBmpLargeIcon);
         }
         this.FBmpLargeIcon = null;
         this.FBaseHeroBins = null;
         this.FHeroTalentBins = null;
         this.FSkillConfigBins = null;
         this.FRoleModelBins = null;
         this.FStrTalentDesc = null;
         this.FStrSkillDesc = null;
         this.FStrAgileGrow = null;
         this.FStrIntelligenceGrow = null;
         this.FStrPowerGrow = null;
         this.FStrLifeGroW = null;
         this.FResource = null;
         this.FContext = null;
         this.FOnHintOver = null;
         this.FOnHintOut = null;
      }
      
      protected function Reset() : void
      {
         this.FBmpLargeIcon.bitmapData = null;
         this.FTF_HeroName.text = "";
         this.FTF_Profession.text = "";
         this.FTF_Location.text = "";
         this.FTF_Talent.text = "";
         this.FTF_Skill.text = "";
         this.FTF_BriefIntroduction.text = "";
         this.FTF_Strength.text = "";
         this.FTF_StrengthRate.text = "";
         this.FTF_Agile.text = "";
         this.FTF_AgileRate.text = "";
         this.FTF_Life.text = "";
         this.FTF_LifeRate.text = "";
         this.FTF_Intelligence.text = "";
         this.FTF_IntelligenceRate.text = "";
         this.FStrTalentDesc = "";
         this.FStrSkillDesc = "";
         this.FStrAgileGrow = "";
         this.FStrIntelligenceGrow = "";
         this.FStrPowerGrow = "";
         this.FStrLifeGroW = "";
      }
   }
}

