package Processors.Game.Lobby.Tavern
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Textures.TAnimationSequence;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorWindowRecruit extends TProcessorLobbyWindow
   {
      
      protected static const TYPE_Tavern:uint = 1;
      
      protected static const TYPE_Other:uint = 2;
      
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
      
      protected var FScene:MovieClip;
      
      protected var FBaseHeroBins:TBins;
      
      protected var FRoleModelBins:TBins;
      
      protected var FHeroTalentBins:TBins;
      
      protected var FSkillConfigBins:TBins;
      
      protected var FMilitaryBins:TBins;
      
      protected var FConfigValueBin:TBins;
      
      protected var FBaseHero:TBaseHero;
      
      protected var FHeadIcon:uint;
      
      protected var FTavernWarriorId:uint;
      
      protected var FHeroId:uint;
      
      protected var FIsCanRecruit:Boolean;
      
      protected var FNeedSoulType:uint;
      
      protected var FNeedSoulValue:uint;
      
      protected var FHeadBitmap:Bitmap;
      
      protected var FCharacter:TCharacter;
      
      protected var FHint:THint;
      
      protected var FHeroTalent:THeroTalent;
      
      protected var FSkillConfig:TSkillConfig;
      
      protected var FConfigValue:TConfigValue;
      
      protected var FCurType:uint;
      
      protected var FSource:Vector.<Object>;
      
      protected var FBT_Recruit:TUIButton;
      
      public static var PendingRecruitId:uint = 0;

      protected var FBT_AddQuality:TUIButton;
      
      protected var FStars:Sprite;
      
      protected var FHeroChangeLightStars:Vector.<Sprite>;
      
      protected var FHeroChangeDarkStars:Vector.<Sprite>;
      
      protected var FBarrierDeactuate:Function;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      public function TProcessorWindowRecruit(param1:TUIComponent, param2:MovieClip = null)
      {
         super(param1);
         this.FScene = param2;
         this.InitRecruit();
      }
      
      protected function InitRecruit() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FHint = new THint();
         this.FBaseHeroBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         this.FRoleModelBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         this.FHeroTalentBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_HeroTalent);
         this.FSkillConfigBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SkillConfig);
         this.FMilitaryBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Military);
         this.FConfigValueBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         this.FConfigValue = this.FConfigValueBin.GetDatebaseByIdentifier(CONST_CONFIGVALUE.TAVERN_Hero_Source) as TConfigValue;
         this.FSource = this.FConfigValue.Value as Vector.<Object>;
         this.FHeadBitmap = new Bitmap();
         this.FBT_Recruit = new TUIButton();
         this.FBT_Recruit.Substrate = this.FScene.btn_recruitBtn;
         this.FBT_Recruit.OnClick = this.OnRecruit;
         this.FBT_AddQuality = new TUIButton();
         this.FBT_AddQuality.Substrate = this.FScene.btn_AddQualityBtn;
         this.FBT_AddQuality.OnClick = this.OnAddQuality;
         this.FScene.mc_largeIcon.mc_Icon.addChild(this.FHeadBitmap);
         this.FScene.tf_skill.addEventListener(MouseEvent.MOUSE_MOVE,this.SkillOnMove);
         this.FScene.tf_skill.addEventListener(MouseEvent.ROLL_OUT,this.SkillOnOut);
         this.FScene.tf_talent.addEventListener(MouseEvent.MOUSE_MOVE,this.SkillOnMove);
         this.FScene.tf_talent.addEventListener(MouseEvent.ROLL_OUT,this.SkillOnOut);
         this.FScene.tf_strengthRate.addEventListener(MouseEvent.MOUSE_MOVE,this.SkillOnMove);
         this.FScene.tf_strengthRate.addEventListener(MouseEvent.ROLL_OUT,this.SkillOnOut);
         this.FScene.tf_agileRate.addEventListener(MouseEvent.MOUSE_MOVE,this.SkillOnMove);
         this.FScene.tf_agileRate.addEventListener(MouseEvent.ROLL_OUT,this.SkillOnOut);
         this.FScene.tf_lifeRate.addEventListener(MouseEvent.MOUSE_MOVE,this.SkillOnMove);
         this.FScene.tf_lifeRate.addEventListener(MouseEvent.ROLL_OUT,this.SkillOnOut);
         this.FScene.tf_intelligenceRate.addEventListener(MouseEvent.MOUSE_MOVE,this.SkillOnMove);
         this.FScene.tf_intelligenceRate.addEventListener(MouseEvent.ROLL_OUT,this.SkillOnOut);
         this.FStars = this.FScene["HeroChangLevel"];
         if(this.FStars != null)
         {
            this.FStars.visible = false;
            this.FStars.addEventListener(MouseEvent.MOUSE_MOVE,this.StarOnMouseOver);
            this.FStars.addEventListener(MouseEvent.MOUSE_OUT,this.StarOnMouseOut);
         }
         if(this.FStars != null) this.FStars.visible = true;
         this.FHeroChangeLightStars = new Vector.<Sprite>();
         this.FHeroChangeDarkStars = new Vector.<Sprite>();
         _loc1_ = 0;
         while(_loc1_ < StarMaxNum)
         {
            this.FHeroChangeLightStars.push(this.FScene["HeroChangLevel"]["LightStar" + _loc1_]);
            this.FHeroChangeDarkStars.push(this.FScene["HeroChangLevel"]["DarkStar" + _loc1_]);
            _loc1_++;
         }
         this.FCharacter = SLogicsCore.Character;
      }
      
      protected function GetSoulValueByType(param1:uint) : int
      {
         switch(param1)
         {
            case BTN_QUALITY_BULE:
               return this.FCharacter.HeroSoulBlueSoul;
            case BTN_QUALITY_PURPLE:
               return this.FCharacter.HeroSoulPurpleSoul;
            case BTN_QUALITY_GOLD:
               return this.FCharacter.HeroSoulGoldSoul;
            case BTN_QUALITY_ORANGE:
               return this.FCharacter.HeroSoulOrangeSoul;
            default:
               return 0;
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
         var _loc2_:int = 0;
         var _loc3_:THeroChangeAttr = null;
         if(this.FBaseHero == null)
         {
            return;
         }
         if(this.FCurType == TYPE_Tavern)
         {
            this.FBT_Recruit.Enabled = this.FIsCanRecruit;
            this.FBT_Recruit.Visible = true;
         }
         else
         {
            this.FBT_Recruit.Visible = false;
         }
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
         this.FScene.mc_assess.gotoAndStop(this.FBaseHero.Assess);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HeroChangeAttr,this.FBaseHero.Identifier) as THeroChangeAttr;
         _loc1_ = 0;
         while(_loc1_ < StarMaxNum)
         {
            this.FHeroChangeLightStars[_loc1_].visible = false;
            this.FHeroChangeDarkStars[_loc1_].visible = _loc3_ != null && _loc1_ < _loc3_.HeroStar.length;
            _loc1_++;
         }
         this.FScene.mc_formation.gotoAndStop(this.GetStandPositionWithProfession(this.FBaseHero.Profession));
         this.FScene.mc_tag.visible = Boolean(this.FCharacter.Heros.GetHeroByIdentifier(this.FBaseHero.Identifier) != null);
         if(Boolean(SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FBaseHero.Identifier)) && Boolean(SLogicsCore.Character.MainHero.Level >= uint(TUtilityLobby.GetConfigValue(60104010))) && SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FBaseHero.Identifier).AddQuality < TUtilityLobby.GetConfigValue(60104007).length)
         {
            this.FBT_AddQuality.Visible = true;
            this.FScene.TF_AddQualityNow.text = SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FBaseHero.Identifier).AddQuality;
            this.FScene.TF_AddQualityNeed.text = uint(TUtilityLobby.GetConfigValue(60104007)[SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FBaseHero.Identifier).AddQuality]);
         }
         else
         {
            this.FBT_AddQuality.Visible = false;
            this.FScene.TF_AddQualityNow.text = 0;
            this.FScene.TF_AddQualityNeed.text = 0;
            if(Boolean(SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FBaseHero.Identifier)) && SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FBaseHero.Identifier).AddQuality == TUtilityLobby.GetConfigValue(60104007).length)
            {
               this.FScene.TF_AddQualityNow.text = TUtilityLobby.GetConfigValue(60104007).length;
            }
         }
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
      
      protected function IsCanRecruit() : Boolean
      {
         var _loc1_:TMilitary = null;
         var _loc2_:int = 0;
         _loc1_ = this.FMilitaryBins.GetDatebaseByIdentifier(this.FCharacter.MilitaryRank) as TMilitary;
         _loc2_ = _loc1_.MaxHeroNum + SLogicsCore.Character.HeroAddSlotNum;
         if(this.FCharacter.Heros.Count >= _loc2_)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_08));
            return false;
         }
         if(this.GetSoulValueByType(this.FNeedSoulType) < this.FNeedSoulValue)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Soul));
            return false;
         }
         return true;
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
               this.FHeadBitmap.bitmapData = _loc5_;
         }
      }
      
      protected function OnRecruit(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_MoreEnlist);
         if(this.FCurType != TYPE_Tavern)
         {
            return;
         }
         if(Boolean(param2) && Boolean(param2.currentTarget) && !param2.currentTarget.buttonMode)
         {
            return;
         }
         if(PendingRecruitId != 0 || !this.IsCanRecruit())
         {
            return;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TavernRecruitReq);
         _loc4_ = _loc3_.Data;
         PendingRecruitId = this.FTavernWarriorId;
         _loc4_.writeInt(this.FTavernWarriorId);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.OnCloseRecruit();
      }
      
      protected function OnAddQuality(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         if(this.FBaseHero == null || SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FBaseHero.Identifier) == null) return;
         if(SLogicsCore.Character.MainHero.Level < uint(TUtilityLobby.GetConfigValue(60104010))) return;
         if(SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FBaseHero.Identifier).AddQuality >= TUtilityLobby.GetConfigValue(60104007).length) return;
         if(this.FCharacter.HeroSoulOrangeSoul < uint(TUtilityLobby.GetConfigValue(60104007)[SLogicsCore.Character.Heros.GetHeroByIdentifier(this.FBaseHero.Identifier).AddQuality]))
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(70130028));
            return;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TavernAddQuality_Req);
         _loc4_ = _loc3_.Data;
         _loc4_.writeInt(this.FHeroId);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function OnCloseRecruit(param1:MouseEvent = null) : void
      {
         Visible = false;
         if(this.FBarrierDeactuate != null)
         {
            this.FBarrierDeactuate(this);
         }
      }
      
      protected function SkillOnMove(param1:MouseEvent) : void
      {
         if(this.FHintOnOver != null)
         {
            if(param1.currentTarget == this.FScene.tf_skill)
            {
               this.FHint.Caption = this.FSkillConfig.Desc;
            }
            else if(param1.currentTarget == this.FScene.tf_talent)
            {
               this.FHint.Caption = this.FHeroTalent.TalentDesc;
            }
            else if(param1.currentTarget == this.FScene.tf_strengthRate)
            {
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_12) + this.FBaseHero.PowerGrow.toString();
            }
            else if(param1.currentTarget == this.FScene.tf_agileRate)
            {
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_13) + this.FBaseHero.AgileGrow.toString();
            }
            else if(param1.currentTarget == this.FScene.tf_lifeRate)
            {
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_14) + this.FBaseHero.LifeGrow.toString();
            }
            else if(param1.currentTarget == this.FScene.tf_intelligenceRate)
            {
               this.FHint.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_15) + this.FBaseHero.IntelligenceGrow.toString();
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
         SUtilityOverLayer.UIComponentsHintOnOver(this,SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(this.FBaseHero.Identifier));
      }
      
      protected function StarOnMouseOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,SLogicsCore.HeroChangeData.GetHeroChangeByHeroID(this.FBaseHero.Identifier));
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
      
      public function set RecruitVisible(param1:Boolean) : void
      {
         this.FScene.visible = param1;
      }
      
      public function get RecruitVisible() : Boolean
      {
         return this.FScene.visible;
      }
      
      public function SetRecruitData(param1:TTavernWarrior, param2:Boolean) : void
      {
         var _loc3_:TRoleModel = null;
         this.FCurType = TYPE_Tavern;
         this.FTavernWarriorId = param1.Identifier;
         this.FHeroId = param1.AwardId;
         this.FIsCanRecruit = param2;
         this.FNeedSoulType = param1.Awardsouls.Type;
         this.FNeedSoulValue = param1.RecruitSoul;
         this.FBaseHero = this.FBaseHeroBins.GetDatebaseByIdentifier(this.FHeroId) as TBaseHero;
         _loc3_ = this.FRoleModelBins.GetDatebaseByIdentifier(this.FHeroId) as TRoleModel;
         this.FHeadIcon = _loc3_.RoleStyle;
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FHeadIcon,this.AutoLoadCallBack);
         this.UpdataUI();
      }
      
      public function SetHeroData(param1:uint) : void
      {
         var _loc2_:TRoleModel = null;
         this.FCurType = TYPE_Other;
         this.FHeroId = param1;
         this.FBaseHero = this.FBaseHeroBins.GetDatebaseByIdentifier(this.FHeroId) as TBaseHero;
         _loc2_ = this.FRoleModelBins.GetDatebaseByIdentifier(this.FHeroId) as TRoleModel;
         this.FHeadIcon = _loc2_.RoleHead;
         SResourcesCore.TexturesLargeIcon.LoadAutoSecondary(this.FHeadIcon,this.AutoLoadCallBack);
         this.UpdataUI();
      }
      
      public function Reset() : void
      {
         this.FHeadBitmap.bitmapData = null;
      }
   }
}

