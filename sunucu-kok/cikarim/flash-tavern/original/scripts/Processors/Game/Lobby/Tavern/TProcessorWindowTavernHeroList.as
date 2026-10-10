package Processors.Game.Lobby.Tavern
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Streamization.Inventories.*;
   import Logics.Tavern.*;
   import Logics.Vip.*;
   import Processors.Game.Lobby.Tavern.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorWindowTavernHeroList extends TUIComponent
   {
      
      protected static const ONEKEYTen_COUNT:uint = 10;
      
      protected static const ONEKEYWin_COUNT:uint = 30;
      
      protected static const BUTTONLIST_COUNT:uint = 4;
      
      protected static const TAMP_HEROLIST_WIDTH:uint = 390;
      
      protected static const TAMP_HEROLIST_HEIGHT:uint = 110;
      
      protected static const Random_Max:uint = 3;
      
      protected static const HERO_Count:uint = 3;
      
      protected static const CONST_HEROLIST_MAX:uint = 6;
      
      protected static const CONST_CARDLIST_MAX:uint = 2;
      
      protected static const CONST_BTN_MAX:uint = 2;
      
      protected static const INDEX_Station_Front:int = 1;
      
      protected static const INDEX_Station_Middle:int = 2;
      
      protected static const INDEX_Station_After:int = 3;
      
      protected static const INITBTN_POS_X:int = 615;
      
      protected static const INITBTN_POS_Y:int = 350;
      
      protected static const INITBTN_STAMP_WIDTH:int = 94;
      
      protected static const OFFSET_X:int = 44;
      
      protected static const BTN_QUALITY_BULE:uint = 3;
      
      protected static const BTN_QUALITY_PURPLE:uint = 4;
      
      protected static const BTN_QUALITY_GOLD:uint = 5;
      
      protected static const BTN_QUALITY_ORANGE:uint = 6;
      
      protected static const COLOR_QUALITY_BULE:uint = 6094297;
      
      protected static const COLOR_QUALITY_PURPLE:uint = 14245117;
      
      protected static const COLOR_QUALITY_GOLD:uint = 16763904;
      
      protected static const COLOR_QUALITY_ORANGE:uint = 16724736;
      
      protected static const MoraBtnType_Noraml:uint = 0;
      
      protected static const MoraBtnType_Advanced:uint = 1;
      
      protected static const MoraBtnType_OneKeyTen:uint = 2;
      
      protected static const MoraBtnType_OneKeyWin:uint = 3;
      
      protected var FScene:MovieClip;
      
      protected var FMoraBtn_Win:TUIButton;
      
      protected var FMoraBtn_10:TUIButton;
      
      protected var FMoraBtn_Blue:TUIButton;
      
      protected var FMoraBtn_Purple:TUIButton;
      
      protected var FMoraBtn_Gold:TUIButton;
      
      protected var FMoraBtn_Orange:TUIButton;
      
      protected var FCurPage:uint;
      
      protected var FTotlePage:uint;
      
      protected var FCharacter:TCharacter;
      
      protected var FVipData:TVip;
      
      protected var FHeroBitmapVect:Vector.<Bitmap>;
      
      protected var FExpCardBitmapVect:Vector.<Bitmap>;
      
      protected var FArticleBins:TBins;
      
      protected var FExpCardBins:TBins;
      
      protected var FTavernGradeBins:TBins;
      
      protected var FTavernWarriorBins:TBins;
      
      protected var FRoldModelBins:TBins;
      
      protected var FBaseHeroBins:TBins;
      
      protected var FSystemLanguageBins:TBins;
      
      protected var FTavernPayConfig:TBins;
      
      protected var FExpCardVects:Vector.<TExchangeExpCard>;
      
      protected var FCurWarriorVects:Vector.<TTavernWarrior>;
      
      protected var FCurGrade:TTavernGrade;
      
      protected var FIDTemplates:Vector.<uint>;
      
      protected var FInventories:TInventories;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FUISlots:Vector.<TUISlot>;
      
      protected var FMoras:TMoras;
      
      protected var FMoraBtnOpenHint:THint;
      
      protected var FMoraBtnHint:TPayConfig;
      
      protected var FMoraBtnIndex:int;
      
      protected var FIsLookOnly:Boolean;
      
      protected var FNormalPayConfig:TTavernPayConfig;
      
      protected var FAdvancedPayConfig:TTavernPayConfig;
      
      protected var FPayWinCost:uint;
      
      protected var FShowIndex:uint;
      
      protected var FRandomIndex:uint;
      
      protected var FRandId:int;
      
      protected var FRandVect:Vector.<int>;
      
      protected var FShowSoulEffectIndex:uint;
      
      protected var FWarriors:TWarriors;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FWindowConfirmationSure:TUIWindowConfirmation;
      
      protected var FCardSpList:Vector.<Sprite>;
      
      protected var FGeneralList:Vector.<TUIGeneral>;
      
      protected var FButtonSp:Sprite;
      
      protected var FButtonList:Vector.<TUIButton>;
      
      protected var FTavernWarriorSelected:TTavernWarrior;
      
      protected var FBT_Left:TUIButton;
      
      protected var FBT_Right:TUIButton;
      
      protected var FOnOverlay:Function;
      
      protected var FOnOut:Function;
      
      protected var FSetRecruitData:Function;
      
      protected var FSetChangeCardData:Function;
      
      protected var FEnterMora:Function;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FEffectGenerateText:Function;
      
      protected var FEnableWindowTavern:Function;
      
      protected var FEnableMora:Function;
      
      protected var FTutorialNextStep:Function;
      
      protected var FSetButtonAndLevel:Function;
      
      public function TProcessorWindowTavernHeroList(param1:TUIComponent, param2:MovieClip)
      {
         var _loc3_:TConfigValue = null;
         super(param1);
         this.FScene = param2;
         this.FMoraBtnOpenHint = new THint();
         this.FMoraBtnHint = new TPayConfig();
         this.FMoraBtnIndex = -1;
         this.FRandVect = new Vector.<int>(HERO_Count);
         this.FButtonList = new Vector.<TUIButton>();
         this.FButtonSp = new Sprite();
         this.FBT_Left = new TUIButton();
         this.FBT_Left.Substrate = this.FScene.mc_heroList.btn_left;
         this.FBT_Left.OnClick = this.OnLeftBtn;
         this.FBT_Right = new TUIButton();
         this.FBT_Right.Substrate = this.FScene.mc_heroList.btn_right;
         this.FBT_Right.OnClick = this.OnRightBtn;
         this.FArticleBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         this.FExpCardBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Exchange_ExpCard);
         this.FTavernGradeBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Tavern_Grade);
         this.FTavernWarriorBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Tavern_Warrior);
         this.FRoldModelBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RoleModel);
         this.FBaseHeroBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BaseHero);
         this.FSystemLanguageBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SystemLanguage);
         this.FTavernPayConfig = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Tavern_PayConfig);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.TAVERN_Match_Cheat) as TConfigValue;
         this.FPayWinCost = _loc3_.Value.value;
         this.FCharacter = SLogicsCore.Character;
         this.FVipData = this.FCharacter.VipData;
         this.FHeroBitmapVect = new Vector.<Bitmap>();
         this.FExpCardBitmapVect = new Vector.<Bitmap>();
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         this.InitHeroList();
      }
      
      protected function InitHeroList() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Bitmap = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TUISlot = null;
         var _loc5_:TUIGeneral = null;
         var _loc6_:Sprite = null;
         var _loc7_:MovieClip = null;
         this.FGeneralList = new Vector.<TUIGeneral>(CONST_HEROLIST_MAX);
         _loc1_ = 0;
         while(_loc1_ < CONST_HEROLIST_MAX)
         {
            _loc3_ = this.FScene["mc_heroList"]["mc_generalList"]["mc_general_" + _loc1_];
            _loc3_.addEventListener(MouseEvent.CLICK,this.OnHeroSelect);
            _loc5_ = new TUIGeneral(this,_loc3_,this.FRoldModelBins);
            _loc5_.OnClick = this.GeneralOnClick;
            this.FGeneralList[_loc1_] = _loc5_;
            _loc1_++;
         }
         this.FIDTemplates = new Vector.<uint>(CONST_CARDLIST_MAX);
         this.FInventories = new TInventories();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FUISlots = new Vector.<TUISlot>(CONST_CARDLIST_MAX);
         this.FCardSpList = new Vector.<Sprite>(CONST_CARDLIST_MAX);
         _loc1_ = 0;
         while(_loc1_ < CONST_CARDLIST_MAX)
         {
            _loc6_ = this.FScene["mc_card_" + _loc1_];
            _loc6_["bt_buy"].addEventListener(MouseEvent.CLICK,this.OnExpCardSelect);
            this.FCardSpList[_loc1_] = _loc6_;
            _loc4_ = this.GetSlot();
            _loc4_.Resource = _loc6_["slot"];
            _loc4_.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
            _loc4_.Init();
            _loc4_.OnOver = this.OnUIOverlay;
            _loc4_.OnOut = this.OnUIOut;
            this.FUISlots[_loc1_] = _loc4_;
            _loc1_++;
         }
         _loc7_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_TAVERN.RESOURCESID_CLASSNAME_KeyWin) as MovieClip;
         this.FButtonSp.addChild(_loc7_);
         this.FMoraBtn_Win = new TUIButton();
         this.FMoraBtn_Win.Substrate = _loc7_;
         this.FMoraBtn_Win.OnClick = this.OnMoraBtnClick;
         this.FMoraBtn_Win.OnMove = this.OnMoraBtnMouseMove;
         this.FMoraBtn_Win.OnOut = this.OnMoraBtnMouseOut;
         this.FMoraBtn_Win.Visible = false;
         _loc7_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_TAVERN.RESOURCESID_CLASSNAME_KeyTen) as MovieClip;
         this.FButtonSp.addChild(_loc7_);
         this.FMoraBtn_10 = new TUIButton();
         this.FMoraBtn_10.Substrate = _loc7_;
         this.FMoraBtn_10.OnClick = this.OnMoraBtnClick;
         this.FMoraBtn_10.OnMove = this.OnMoraBtnMouseMove;
         this.FMoraBtn_10.OnOut = this.OnMoraBtnMouseOut;
         this.FMoraBtn_10.Visible = false;
         _loc7_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_TAVERN.RESOURCESID_CLASSNAME_KeyBlue) as MovieClip;
         this.FButtonSp.addChild(_loc7_);
         this.FMoraBtn_Blue = new TUIButton();
         this.FMoraBtn_Blue.Substrate = _loc7_;
         this.FMoraBtn_Blue.OnClick = this.OnMoraBtnClick;
         this.FMoraBtn_Blue.OnMove = this.OnMoraBtnMouseMove;
         this.FMoraBtn_Blue.OnOut = this.OnMoraBtnMouseOut;
         this.FMoraBtn_Blue.Visible = false;
         _loc7_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_TAVERN.RESOURCESID_CLASSNAME_KeyPurple) as MovieClip;
         this.FButtonSp.addChild(_loc7_);
         this.FMoraBtn_Purple = new TUIButton();
         this.FMoraBtn_Purple.Substrate = _loc7_;
         this.FMoraBtn_Purple.OnClick = this.OnMoraBtnClick;
         this.FMoraBtn_Purple.OnMove = this.OnMoraBtnMouseMove;
         this.FMoraBtn_Purple.OnOut = this.OnMoraBtnMouseOut;
         this.FMoraBtn_Purple.Visible = false;
         _loc7_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_TAVERN.RESOURCESID_CLASSNAME_KeyGold) as MovieClip;
         this.FButtonSp.addChild(_loc7_);
         this.FMoraBtn_Gold = new TUIButton();
         this.FMoraBtn_Gold.Substrate = _loc7_;
         this.FMoraBtn_Gold.OnClick = this.OnMoraBtnClick;
         this.FMoraBtn_Gold.OnMove = this.OnMoraBtnMouseMove;
         this.FMoraBtn_Gold.OnOut = this.OnMoraBtnMouseOut;
         this.FMoraBtn_Gold.Visible = false;
         _loc7_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_TAVERN.RESOURCESID_CLASSNAME_KeyOrange) as MovieClip;
         this.FButtonSp.addChild(_loc7_);
         this.FMoraBtn_Orange = new TUIButton();
         this.FMoraBtn_Orange.Substrate = _loc7_;
         this.FMoraBtn_Orange.OnClick = this.OnMoraBtnClick;
         this.FMoraBtn_Orange.OnMove = this.OnMoraBtnMouseMove;
         this.FMoraBtn_Orange.OnOut = this.OnMoraBtnMouseOut;
         this.FMoraBtn_Orange.Visible = false;
         this.FScene["mc_wines"]["mc_winebutsSp"].addChild(this.FButtonSp);
         this.FWarriors = new TWarriors();
         this.FWarriors.SetWarriorsBins(this.FTavernWarriorBins,this.FExpCardBins);
      }
      
      private function GeneralOnClick() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < CONST_HEROLIST_MAX)
         {
            this.FGeneralList[_loc1_].ResetBox();
            _loc1_++;
         }
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
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
      
      protected function CheckBtn() : void
      {
         var _loc1_:TTavernGrade = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc4_ = uint(this.FTavernGradeBins.Count);
         _loc3_ = this.FTavernGradeBins.Count - 1;
         while(_loc3_ >= 0)
         {
            _loc1_ = this.FTavernGradeBins.GetDatebaseByIndex(_loc3_) as TTavernGrade;
            if(SLogicsCore.Character.GetMainLevel() >= _loc1_.Level)
            {
               _loc2_ = _loc1_.Page;
               break;
            }
            _loc3_--;
         }
         this.FScene.mc_heroList.btn_left.visible = Boolean(this.FCurPage != 1);
         this.FScene.mc_heroList.btn_right.visible = Boolean(this.FCurPage != this.FTotlePage || this.FCurPage > _loc2_);
      }
      
      protected function GetSlot() : TUISlot
      {
         var _loc1_:TUISlot = null;
         _loc1_ = new TUISlot(this);
         _loc1_.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         return _loc1_;
      }
      
      protected function UpdataUI() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TArticle = null;
         var _loc3_:TRoleModel = null;
         var _loc4_:TBaseHero = null;
         var _loc5_:uint = 0;
         var _loc6_:MovieClip = null;
         var _loc7_:uint = 0;
         var _loc8_:TUIButton = null;
         var _loc9_:uint = 0;
         var _loc10_:TUIGeneral = null;
         var _loc11_:Sprite = null;
         this.FCurGrade = this.FTavernGradeBins.GetDatebaseByIndex(this.FCurPage - 1) as TTavernGrade;
         this.FCurWarriorVects = this.FWarriors.GetWarriorWithPage(this.FCurPage);
         _loc1_ = 0;
         while(_loc1_ < CONST_HEROLIST_MAX)
         {
            _loc10_ = this.FGeneralList[_loc1_];
            if(this.FCurWarriorVects == null)
            {
               _loc10_.BackGroundVisible = false;
            }
            else if(_loc1_ < this.FCurWarriorVects.length)
            {
               _loc5_ = uint(this.FCurWarriorVects[_loc1_].AwardId);
               _loc3_ = this.FRoldModelBins.GetDatebaseByIdentifier(_loc5_) as TRoleModel;
               _loc4_ = this.FBaseHeroBins.GetDatebaseByIdentifier(_loc5_) as TBaseHero;
               _loc10_.RecruitedVisible = Boolean(this.FCharacter.Heros.GetHeroByIdentifier(_loc5_) != null);
               _loc7_ = this.GetStandPositionWithProfession(_loc4_.Profession);
               _loc10_.UpdateBox(this.FCurWarriorVects[_loc1_],_loc7_);
               _loc10_.BackGroundVisible = true;
            }
            else
            {
               _loc10_.BackGroundVisible = false;
            }
            _loc1_++;
         }
         if(this.FSetButtonAndLevel != null)
         {
            this.FSetButtonAndLevel(this);
         }
         if(this.FCurWarriorVects != null)
         {
            _loc1_ = 0;
            while(_loc1_ < CONST_HEROLIST_MAX)
            {
               if(_loc1_ < this.FCurWarriorVects.length)
               {
                  this.FGeneralList[_loc1_].UpdateIcon(this.FCurWarriorVects[_loc1_]);
               }
               _loc1_++;
            }
         }
         this.ResetList();
         this.SelectFirstMan();
         this.FIDTemplates.length = 0;
         this.FExpCardVects = this.FWarriors.GetExpCardWithPage(this.FCurPage);
         _loc1_ = 0;
         while(_loc1_ < CONST_CARDLIST_MAX)
         {
            _loc11_ = this.FCardSpList[_loc1_];
            if(_loc1_ < this.FExpCardVects.length)
            {
               _loc2_ = this.FArticleBins.GetDatebaseByIdentifier(this.FExpCardVects[_loc1_].Item) as TArticle;
               _loc9_ = this.GetColorWithQuality(this.FExpCardVects[_loc1_].Quality);
               _loc11_["tf_cardName"].text = _loc2_.Name;
               _loc11_["tf_cardName"].textColor = _loc9_;
               _loc11_["tf_needSoul"].text = String(this.FExpCardVects[_loc1_].Value);
               _loc11_["tf_needSoul"].textColor = _loc9_;
               _loc11_["mc_soul"].gotoAndStop(this.FExpCardVects[_loc1_].Quality);
               this.FIDTemplates.push(this.FExpCardVects[_loc1_].Item);
               _loc11_.visible = true;
            }
            else
            {
               _loc11_.visible = false;
            }
            _loc1_++;
         }
         this.FInventories.Clear();
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,this.FInventories,this.FIDTemplates);
         _loc1_ = 0;
         while(_loc1_ < this.FInventories.Count)
         {
            this.FUISlots[_loc1_].Context = this.FInventories.GetInventoryByIndex(_loc1_);
            _loc1_++;
         }
         if(this.FCurWarriorVects.length < CONST_HEROLIST_MAX)
         {
            this.FScene["mc_heroList"]["mc_generalList"].x = OFFSET_X + (CONST_HEROLIST_MAX - this.FCurWarriorVects.length) * INITBTN_STAMP_WIDTH / 2;
         }
         else
         {
            this.FScene["mc_heroList"]["mc_generalList"].x = OFFSET_X;
         }
         this.FMoraBtn_Win.Visible = false;
         this.FMoraBtn_10.Visible = false;
         this.FMoraBtn_Blue.Visible = false;
         this.FMoraBtn_Purple.Visible = false;
         this.FMoraBtn_Gold.Visible = false;
         this.FMoraBtn_Orange.Visible = false;
         while(this.FButtonList.length > 0)
         {
            this.FButtonList.shift();
         }
         _loc1_ = 0;
         while(_loc1_ < CONST_BTN_MAX)
         {
            _loc8_ = null;
            if(this.FCurGrade.WineLvs[_loc1_] == BTN_QUALITY_BULE)
            {
               _loc8_ = this.FMoraBtn_Blue;
            }
            else if(this.FCurGrade.WineLvs[_loc1_] == BTN_QUALITY_PURPLE)
            {
               _loc8_ = this.FMoraBtn_Purple;
            }
            else if(this.FCurGrade.WineLvs[_loc1_] == BTN_QUALITY_GOLD)
            {
               _loc8_ = this.FMoraBtn_Gold;
            }
            else if(this.FCurGrade.WineLvs[_loc1_] == BTN_QUALITY_ORANGE)
            {
               _loc8_ = this.FMoraBtn_Orange;
            }
            if(_loc8_ != null)
            {
               _loc8_.Visible = true;
               _loc8_.X = 222 - _loc1_ * 74;
               _loc8_.Y = 1;
               _loc8_.Tag = _loc1_;
               _loc8_.Enabled = true;
               this.FButtonList.push(_loc8_);
            }
            _loc1_++;
         }
         this.FMoraBtn_10.Visible = true;
         this.FMoraBtn_10.X = 74;
         this.FMoraBtn_10.Y = 0;
         this.FMoraBtn_10.Tag = 2;
         this.FMoraBtn_10.Enabled = this.FVipData.OneWine;
         this.FButtonList.push(this.FMoraBtn_10);
         this.FMoraBtn_Win.Visible = true;
         this.FMoraBtn_Win.X = 0;
         this.FMoraBtn_Win.Y = 0;
         this.FMoraBtn_Win.Tag = 3;
         this.FMoraBtn_Win.Enabled = this.FVipData.OneWinWine;
         this.FButtonList.push(this.FMoraBtn_Win);
         if(this.FButtonList.length < BUTTONLIST_COUNT)
         {
            _loc1_ = 0;
            while(_loc1_ < this.FButtonList.length)
            {
               this.FButtonList[this.FButtonList.length - 1 - _loc1_].Substrate.x = 74 * _loc1_;
               this.FButtonList[this.FButtonList.length - 1 - _loc1_].Substrate.y = 0;
               _loc1_++;
            }
            this.FButtonSp.x = (BUTTONLIST_COUNT - this.FButtonList.length) * 74 / 2;
         }
         else
         {
            this.FButtonSp.x = 0;
         }
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
      
      protected function GetIsCanRecruit(param1:TTavernWarrior) : Boolean
      {
         if(this.FIsLookOnly)
         {
            return false;
         }
         if(this.FCharacter.Heros.GetHeroByIdentifier(param1.AwardId))
         {
            return false;
         }
         if(this.GetSoulValueByType(param1.Awardsouls.Type) < param1.RecruitSoul)
         {
            return false;
         }
         return true;
      }
      
      protected function MakePayConfig(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TSystemLanguage = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Vector.<String> = null;
         this.FNormalPayConfig = this.FTavernPayConfig.GetDatebaseByIdentifier(this.FCurGrade.PayConfigsVect.NORMAL) as TTavernPayConfig;
         this.FAdvancedPayConfig = this.FTavernPayConfig.GetDatebaseByIdentifier(this.FCurGrade.PayConfigsVect.ADVANCED) as TTavernPayConfig;
         _loc8_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_25);
         switch(param1)
         {
            case MoraBtnType_Noraml:
               _loc2_ = uint(this.FCurGrade.WineLvs[0]);
               this.FMoraBtnHint.Title = _loc8_[_loc2_];
               this.FMoraBtnHint.Value = this.FNormalPayConfig.Value + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin);
               _loc4_ = int(CONST_SYSTEMLANGUAGE.TAVERN_STRING_01);
               _loc5_ = "";
               break;
            case MoraBtnType_Advanced:
               _loc2_ = uint(this.FCurGrade.WineLvs[1]);
               this.FMoraBtnHint.Title = _loc8_[_loc2_];
               this.FMoraBtnHint.Value = this.FAdvancedPayConfig.Value + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin);
               _loc4_ = int(CONST_SYSTEMLANGUAGE.TAVERN_STRING_02);
               _loc5_ = "";
               break;
            case MoraBtnType_OneKeyTen:
               _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_22);
               this.FMoraBtnHint.Title = _loc6_;
               this.FMoraBtnHint.Value = this.FAdvancedPayConfig.Value * ONEKEYTen_COUNT + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin);
               _loc4_ = int(CONST_SYSTEMLANGUAGE.TAVERN_STRING_03);
               _loc5_ = this.FVipData.OneWine ? "" : this.FVipData.VipOpenLevel_OneWine.toString();
               break;
            case MoraBtnType_OneKeyWin:
               _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_23);
               this.FMoraBtnHint.Title = _loc7_;
               this.FMoraBtnHint.Value = this.FAdvancedPayConfig.Value * ONEKEYTen_COUNT + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin) + "," + this.FPayWinCost * ONEKEYWin_COUNT + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_26);
               _loc4_ = int(CONST_SYSTEMLANGUAGE.TAVERN_STRING_04);
               _loc5_ = this.FVipData.OneWinWine ? "" : this.FVipData.VipOpenLevel_OneWinWine.toString();
         }
         _loc3_ = this.FSystemLanguageBins.GetDatebaseByIdentifier(_loc4_) as TSystemLanguage;
         this.FMoraBtnHint.ID = param1;
         this.FMoraBtnHint.Context = _loc3_.Desc;
         this.FMoraBtnHint.OpenLevel = _loc5_;
      }
      
      protected function CheckEnoughCredit(param1:uint) : Boolean
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         switch(param1)
         {
            case MoraBtnType_Noraml:
               _loc2_ = uint(this.FNormalPayConfig.Value);
               _loc3_ = 0;
               break;
            case MoraBtnType_Advanced:
               _loc2_ = uint(this.FAdvancedPayConfig.Value);
               _loc3_ = 0;
               break;
            case MoraBtnType_OneKeyTen:
               _loc2_ = this.FAdvancedPayConfig.Value * ONEKEYTen_COUNT;
               _loc3_ = 0;
               break;
            case MoraBtnType_OneKeyWin:
               _loc2_ = this.FAdvancedPayConfig.Value * ONEKEYTen_COUNT;
               _loc3_ = this.FPayWinCost * ONEKEYWin_COUNT;
         }
         if(this.FCharacter.CreditSilverCoin.ToNumber() < _loc2_)
         {
            if(this.FEffectGenerateText != null)
            {
               this.FEffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Coin));
            }
            return false;
         }
         if(this.FCharacter.CreditGold + this.FCharacter.CreditGiftCertificate < _loc3_)
         {
            this.FUIWindowRecharge.Visible = true;
            return false;
         }
         return true;
      }
      
      protected function GetWarriorIndexByHeroId(param1:uint) : int
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FCurWarriorVects.length)
         {
            if(this.FCurWarriorVects[_loc2_].Identifier == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      protected function StartRandomChoose() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Boolean = false;
         if(this.FRandId != -1)
         {
            if(this.FGeneralList[this.FRandId] != null)
            {
               this.FGeneralList[this.FRandId].UpdateRank(false);
            }
         }
         do
         {
            this.FRandId = Math.random() * this.FCurWarriorVects.length;
            _loc2_ = false;
            _loc1_ = 0;
            while(_loc1_ < this.FRandVect.length)
            {
               if(this.FRandVect[_loc1_] == this.FRandId)
               {
                  _loc2_ = true;
               }
               _loc1_++;
            }
         }
         while(_loc2_);
         this.FRandomIndex++;
         if(this.FRandomIndex >= Random_Max)
         {
            _loc1_ = 0;
            while(_loc1_ < this.FCurWarriorVects.length)
            {
               if(this.FCurWarriorVects[_loc1_].Identifier == this.FMoras.GetMoraByIndex(this.FShowIndex).TavernHeroId)
               {
                  this.FRandId = _loc1_;
                  break;
               }
               _loc1_++;
            }
         }
         this.FGeneralList[this.FRandId].UpdateRank(true);
         if(this.FRandomIndex >= Random_Max)
         {
            this.FRandVect[this.FShowIndex] = this.FRandId;
            this.FRandomIndex = 0;
            this.FShowIndex++;
            this.FRandId = -1;
            if(this.FShowIndex >= HERO_Count)
            {
               setTimeout(this.EndShow,1000);
               return;
            }
         }
         setTimeout(this.StartRandomChoose,250);
      }
      
      protected function EndShow() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FRandVect.length)
         {
            this.FGeneralList[_loc1_].UpdateRank(false);
            this.FRandVect[_loc1_] = 0;
            _loc1_++;
         }
         if(this.FEnterMora != null)
         {
            this.FEnterMora(this.FMoras);
         }
      }
      
      protected function ResetHeadBmp() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < CONST_HEROLIST_MAX)
         {
            this.FGeneralList[_loc1_].ResetBmp();
            _loc1_++;
         }
      }
      
      protected function OnHeroSelect(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         _loc2_ = uint(int(String(param1.currentTarget.name).slice(11)));
         this.FTavernWarriorSelected = this.FCurWarriorVects[_loc2_];
         _loc3_ = this.GetIsCanRecruit(this.FTavernWarriorSelected);
         if(this.FTavernWarriorSelected != null && this.FSetRecruitData != null)
         {
            this.FSetRecruitData(this.FTavernWarriorSelected,_loc3_);
         }
         this.FTutorialNextStep(CONST_FRESHGUIDE.EVENTID_LookFriendInfor);
      }
      
      protected function OnExpCardSelect(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TExchangeExpCard = null;
         _loc2_ = uint(int(String(param1.currentTarget.parent.name).slice(8)));
         _loc3_ = this.FExpCardVects[_loc2_];
         if(this.FSetChangeCardData != null)
         {
            this.FSetChangeCardData(_loc3_,!this.FIsLookOnly);
         }
      }
      
      protected function OnLeftBtn(param1:Object, param2:MouseEvent) : void
      {
         this.FCurPage--;
         if(this.FCurPage < 1)
         {
            this.FCurPage = 1;
         }
         this.ResetHeadBmp();
         this.UpdataUI();
         this.CheckBtn();
      }
      
      protected function OnRightBtn(param1:Object, param2:MouseEvent) : void
      {
         this.FCurPage++;
         if(this.FCurPage > this.FTotlePage)
         {
            this.FCurPage = this.FTotlePage;
         }
         this.ResetHeadBmp();
         this.UpdataUI();
         this.CheckBtn();
      }
      
      protected function OnMoraBtnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:TUIButton = null;
         _loc8_ = param1 as TUIButton;
         if(_loc8_ == null)
         {
            return;
         }
         if(this.FTutorialNextStep != null)
         {
            this.FTutorialNextStep(CONST_FRESHGUIDE.EVENTID_StartDrink);
         }
         _loc3_ = uint(_loc8_.Tag);
         if(this.FNormalPayConfig == null || this.FAdvancedPayConfig == null)
         {
            return;
         }
         if(!this.CheckEnoughCredit(_loc3_))
         {
            return;
         }
         if(this.FEnableWindowTavern != null)
         {
            this.FEnableWindowTavern(false);
         }
         if(this.FEnableMora != null)
         {
            this.FEnableMora(false);
         }
         if(_loc3_ == MoraBtnType_OneKeyWin)
         {
            if(this.FWindowConfirmationSure == null)
            {
               this.FWindowConfirmationSure = SUtilityOverLayer.UIWindowConfirmation;
            }
            this.FAdvancedPayConfig = this.FTavernPayConfig.GetDatebaseByIdentifier(this.FCurGrade.PayConfigsVect.ADVANCED) as TTavernPayConfig;
            _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_21);
            _loc6_ = TUtilityString.Format(_loc7_,this.FPayWinCost * ONEKEYWin_COUNT,this.FAdvancedPayConfig.Value * ONEKEYTen_COUNT);
            this.FWindowConfirmationSure.OnOK = this.SureOneKeyWinMora;
            this.FWindowConfirmationSure.OnCancel = this.CancelOneKeyWinMora;
            this.FWindowConfirmationSure.Text = _loc6_;
            this.FWindowConfirmationSure.Visible = true;
            return;
         }
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TavernMoraReq);
         _loc5_ = _loc4_.Data;
         _loc5_.writeByte(_loc3_);
         _loc5_.writeInt(this.FCurGrade.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function SureOneKeyWinMora(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TavernMoraReq);
         _loc3_ = _loc2_.Data;
         _loc3_.writeByte(MoraBtnType_OneKeyWin);
         _loc3_.writeInt(this.FCurGrade.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function CancelOneKeyWinMora(param1:Object) : void
      {
         if(this.FEnableWindowTavern != null)
         {
            this.FEnableWindowTavern(true);
         }
      }
      
      protected function OnMoraBtnMouseMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TUIButton = null;
         _loc4_ = param1 as TUIButton;
         _loc3_ = uint(_loc4_.Tag);
         if(_loc3_ != this.FMoraBtnIndex)
         {
            this.MakePayConfig(_loc3_);
            this.FMoraBtnIndex = _loc3_;
         }
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(param2,this.FMoraBtnHint);
         }
      }
      
      protected function OnMoraBtnMouseOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FMoraBtnIndex = -1;
            this.FHintOnOut(param2);
         }
      }
      
      protected function OnUIOverlay(param1:Object, param2:Object) : void
      {
         if(this.FOnOverlay != null)
         {
            this.FOnOverlay(param1,param2);
         }
      }
      
      protected function OnUIOut(param1:Object, param2:Object) : void
      {
         if(this.FOnOut != null)
         {
            this.FOnOut(param1,param2);
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         if(this.FScene == null)
         {
            return;
         }
         this.FScene.visible = param1;
      }
      
      override public function get Visible() : Boolean
      {
         if(this.FScene == null)
         {
            return false;
         }
         return this.FScene.visible;
      }
      
      public function set OnOverlay(param1:Function) : void
      {
         this.FOnOverlay = param1;
      }
      
      public function get OnOverlay() : Function
      {
         return this.FOnOverlay;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set SetRecruitData(param1:Function) : void
      {
         this.FSetRecruitData = param1;
      }
      
      public function get SetRecruitData() : Function
      {
         return this.FSetRecruitData;
      }
      
      public function set SetChangeCardData(param1:Function) : void
      {
         this.FSetChangeCardData = param1;
      }
      
      public function get SetChangeCardData() : Function
      {
         return this.FSetChangeCardData;
      }
      
      public function set EnterMora(param1:Function) : void
      {
         this.FEnterMora = param1;
      }
      
      public function get EnterMora() : Function
      {
         return this.FEnterMora;
      }
      
      public function set HintOnMove(param1:Function) : void
      {
         this.FHintOnMove = param1;
      }
      
      public function get HintOnMove() : Function
      {
         return this.FHintOnMove;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set EffectGenerateText(param1:Function) : void
      {
         this.FEffectGenerateText = param1;
      }
      
      public function get EffectGenerateText() : Function
      {
         return this.FEffectGenerateText;
      }
      
      public function set EnableWindowTavern(param1:Function) : void
      {
         this.FEnableWindowTavern = param1;
      }
      
      public function get EnableWindowTavern() : Function
      {
         return this.FEnableWindowTavern;
      }
      
      public function set TutorialNextStep(param1:Function) : void
      {
         this.FTutorialNextStep = param1;
      }
      
      public function get SetButtonAndLevel() : Function
      {
         return this.FSetButtonAndLevel;
      }
      
      public function set SetButtonAndLevel(param1:Function) : void
      {
         this.FSetButtonAndLevel = param1;
      }
      
      public function get CurGrade() : TTavernGrade
      {
         return this.FCurGrade;
      }
      
      public function get EnableMora() : Function
      {
         return this.FEnableMora;
      }
      
      public function set EnableMora(param1:Function) : void
      {
         this.FEnableMora = param1;
      }
      
      public function set IsLookOnly(param1:Boolean) : void
      {
         this.FIsLookOnly = param1;
      }
      
      public function get TavernWarriorSelected() : TTavernWarrior
      {
         return this.FTavernWarriorSelected;
      }
      
      public function CheckTavernHeroList() : void
      {
         var _loc1_:* = 0;
         var _loc2_:TTavernGrade = null;
         _loc1_ = int(this.FTavernGradeBins.Count - 1);
         while(_loc1_ >= 0)
         {
            _loc2_ = this.FTavernGradeBins.GetDatebaseByIndex(_loc1_) as TTavernGrade;
            if(Boolean(_loc2_) && Boolean(_loc2_.IsTavern) && SLogicsCore.Character.GetMainLevel() >= _loc2_.Level)
            {
               this.FCurPage = _loc2_.Page;
               this.FCurGrade = _loc2_;
               break;
            }
            _loc1_--;
         }
         if(this.FCurPage == this.FTavernGradeBins.Count)
         {
            this.FTotlePage = this.FCurPage;
         }
         else
         {
            this.FTotlePage = this.FCurPage + 1;
         }
         this.UpdataUI();
         this.CheckBtn();
      }
      
      public function ShowChooseMoraHero(param1:TMoras) : void
      {
         this.FMoras = param1;
         this.FRandId = -1;
         this.FShowIndex = 0;
         this.FRandomIndex = 0;
         this.FRandVect.length = 0;
         this.GeneralOnClick();
         this.StartRandomChoose();
      }
      
      public function UpdataTavernHeroHeadBitmap() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = 0;
         while(_loc1_ < this.FUISlots.length)
         {
            this.FUISlots[_loc1_].Update();
            _loc1_++;
         }
      }
      
      public function GetCoordinateByHeroId(param1:uint) : TCoordinate
      {
         var _loc2_:uint = 0;
         var _loc3_:TCoordinate = null;
         var _loc4_:TUIGeneral = null;
         _loc2_ = uint(this.GetWarriorIndexByHeroId(param1));
         _loc4_ = this.FGeneralList[_loc2_];
         _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(_loc4_);
         _loc3_.X = TAMP_HEROLIST_WIDTH + INITBTN_STAMP_WIDTH * _loc2_ + (CONST_HEROLIST_MAX - this.FCurWarriorVects.length) * INITBTN_STAMP_WIDTH / 2;
         _loc3_.Y = TAMP_HEROLIST_HEIGHT + _loc4_.y;
         if(!this.Visible)
         {
            _loc3_.X = INITBTN_POS_X;
            _loc3_.Y = INITBTN_POS_Y;
         }
         return _loc3_;
      }
      
      public function ShowOneKeyHeroById(param1:uint) : void
      {
         var General:TUIGeneral = null;
         var ResetMc:Function = null;
         var HeroId:uint = param1;
         ResetMc = function():void
         {
            General.UpdateRank(false);
         };
         this.FShowSoulEffectIndex = this.GetWarriorIndexByHeroId(HeroId);
         General = this.FGeneralList[this.FShowSoulEffectIndex];
         General.UpdateRank(true);
         setTimeout(ResetMc,300);
      }
      
      public function EnableBtn(param1:Boolean) : void
      {
         this.FScene.mouseEnabled = param1;
         this.FScene.mouseChildren = param1;
      }
      
      public function ResetList() : void
      {
         this.GeneralOnClick();
      }
      
      public function SetWineBT(param1:Boolean) : void
      {
         this.FScene.mc_wines.visible = param1;
      }
      
      public function SelectFirstMan() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TTavernWarrior = null;
         var _loc4_:Boolean = false;
         this.GeneralOnClick();
         _loc2_ = this.FCurWarriorVects.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(!this.FGeneralList[_loc1_].RecruitedTagVisible)
            {
               this.FGeneralList[_loc1_].UpdateRank(true);
               this.FTavernWarriorSelected = this.FCurWarriorVects[_loc1_];
               break;
            }
            if(_loc1_ == _loc2_ - 1 && this.FGeneralList[_loc1_].RecruitedTagVisible)
            {
               this.FGeneralList[0].UpdateRank(true);
               this.FTavernWarriorSelected = this.FCurWarriorVects[0];
            }
            _loc1_++;
         }
         _loc4_ = this.GetIsCanRecruit(this.FTavernWarriorSelected);
         if(this.FTavernWarriorSelected != null && this.FSetRecruitData != null)
         {
            this.FSetRecruitData(this.FTavernWarriorSelected,_loc4_);
         }
      }
      
      public function SetHightLight() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:Boolean = false;
         _loc1_ = this.FCurWarriorVects.indexOf(this.FTavernWarriorSelected);
         this.FGeneralList[_loc1_].UpdateRank(true);
         this.FGeneralList[_loc1_].RecruitedVisible = Boolean(this.FCharacter.Heros.GetHeroByIdentifier(this.FTavernWarriorSelected.AwardId) != null);
         _loc2_ = this.GetIsCanRecruit(this.FTavernWarriorSelected);
         if(this.FTavernWarriorSelected != null && this.FSetRecruitData != null)
         {
            this.FSetRecruitData(this.FTavernWarriorSelected,_loc2_);
         }
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         this.ResetHeadBmp();
         _loc1_ = 0;
         while(_loc1_ < this.FInventories.Count)
         {
            this.FUISlots[_loc1_].Context = null;
            _loc1_++;
         }
      }
   }
}

