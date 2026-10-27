package Processors.Game.Lobby.Arena
{
   import Components.Standard.*;
   import Externals.SExternalCore;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Arena.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Components.TUIHero;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import ghostcat.util.easing.*;
   
   public class TProcessorWindowArena extends TProcessorLobbyWindow
   {
      
      protected static const CONST_RankingBoxCount:uint = 4;
      
      protected static const QUALITY_MAX:uint = 7;
      
      protected static const RANK_Id_MAX:uint = 8;
      
      protected static const TITLE_TEP_X:uint = 162;
      
      protected static const HERO_Count:uint = 8;
      
      protected static const Rank_Count:uint = 3;
      
      protected static const REPORT_MAX:uint = 5;
      
      protected static const REPORT_TextFilters:GlowFilter = new GlowFilter(0,1,2,2,10);
      
      protected static const TextFiledInitPosX:int = 2;
      
      protected static const TextFiledInitPosY:int = 5;
      
      protected static const TextFiledInitHeight:int = 20;
      
      protected static const BtnInitPosX:int = 292;
      
      protected static const BtnInitPosY:int = 5;
      
      protected static const WHEN_NUM:uint = 8;
      
      protected var FArenaData:TArenaData;
      
      protected var FCharacter:TCharacter;
      
      protected var FHelpTips:THint;
      
      protected var FMilitaryBins:TBins;
      
      protected var FRankComposeQuality:TBins;
      
      protected var FMyBoxQuality:uint;
      
      protected var FResource:MovieClip;
      
      protected var FBT_Back:TUIButton;
      
      protected var FBT_ShowPanel:TUIButton;
      
      protected var FBtn_RankingBoxs:Vector.<TUIButton>;
      
      protected var FBigBitmap:Bitmap;
      
      protected var FBigPicId:uint;
      
      protected var FStartBoxId:int;
      
      protected var FHintBtnAdd:THint;
      
      protected var FHintBoxTip:THint;
      
      protected var FRankExpendCostBins:TBins;
      
      protected var FRankRewardBins:TBins;
      
      protected var FRankMoneyBins:TBins;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FIsFightTimesCanFight:Boolean;
      
      protected var FIsColdDownCanFight:Boolean;
      
      protected var FCheckCost:uint;
      
      protected var FBT_AddCurTimes:TUIButton;
      
      protected var FBT_GetReward:TUIButton;
      
      protected var FBT_Reward:TUIButton;
      
      protected var FArenaHeros:TArenaHeros;
      
      protected var FMySelfIdentifier0:uint;
      
      protected var FMySelfIdentifier1:uint;
      
      protected var FMySelfIndex:int;
      
      protected var FFightIndex:int;
      
      protected var FUIHeros:Vector.<TUIHero>;
      
      protected var FRolesModelID:Vector.<int>;
      
      protected var FMyFire0:MovieClip;
      
      protected var FMyFire1:MovieClip;
      
      protected var FArenaReports:TArenaReports;
      
      protected var FTextReportVect:Vector.<TextField>;
      
      protected var FBtnReportVect:Vector.<TUIButton>;
      
      protected var FWhenVect:Vector.<String>;
      
      protected var FInitialization:Boolean;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FCheckCanFight:Function;
      
      public function TProcessorWindowArena(param1:TUIComponent)
      {
         super(param1);
         this.FMySelfIndex = -1;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ARENA.RESOURCE_ARENA);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TUIButton = null;
         var _loc3_:TextField = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TUIHero = null;
         var _loc6_:TBounds = null;
         var _loc7_:TCoordinate = null;
         this.FResource = TUtilityReflection.CreateDisplayObjectInstance(CONST_ARENA.RESOURCE_ClassName_MC_Arena) as MovieClip;
         this.addChild(this.FResource);
         this.FBT_Back = new TUIButton();
         this.FBT_Back.Substrate = this.FResource.btn_back;
         this.FBT_Back.OnClick = this.BT_BackOnClose;
         this.FBT_ShowPanel = new TUIButton();
         this.FBT_ShowPanel.Substrate = this.FResource.btn_showPanel;
         this.FBT_ShowPanel.OnClick = this.OnShowHeroPanel;
         this.FResource.mc_autoPoint.btn_close.addEventListener(MouseEvent.CLICK,this.CloseOnClick);
         this.FResource.mc_autoPoint.btn_help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver);
         this.FResource.mc_autoPoint.btn_help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut);
         this.FHelpTips = new THint();
         this.FBigBitmap = new Bitmap();
         this.FResource.mc_image.addChild(this.FBigBitmap);
         this.FResource.mc_image.mouseEnabled = false;
         this.FBT_AddCurTimes = new TUIButton();
         this.FBT_AddCurTimes.Substrate = this.FResource.mc_baseInfo.btn_addCurTimes;
         this.FBT_AddCurTimes.OnMove = this.Btn_AddOnMove;
         this.FBT_AddCurTimes.OnOut = this.Btn_AddOnOut;
         this.FBT_AddCurTimes.OnClick = this.OnShowWindowConfirmationAddTimes;
         this.FResource.mc_baseInfo.btn_fast.addEventListener(MouseEvent.CLICK,this.FastOnClick);
         this.FHintBoxTip = new THint();
         this.FBtn_RankingBoxs = new Vector.<TUIButton>(CONST_RankingBoxCount);
         _loc1_ = 0;
         while(_loc1_ < CONST_RankingBoxCount)
         {
            _loc2_ = new TUIButton();
            _loc2_.Substrate = this.FResource.mc_boxList["mc_box_" + _loc1_];
            _loc2_.OnMove = this.OnMouseMove;
            _loc2_.OnOut = this.OnMouseOut;
            this.FBtn_RankingBoxs[_loc1_] = _loc2_;
            _loc1_++;
         }
         this.FBT_GetReward = new TUIButton();
         this.FBT_GetReward.Substrate = this.FResource.mc_title.btn_getReward;
         this.FBT_GetReward.OnMove = this.OnRewardMouseMove;
         this.FBT_GetReward.OnOut = this.OnMouseOut;
         this.FBT_Reward = new TUIButton();
         this.FBT_Reward.Substrate = this.FResource.mc_title.mc_Reward.BT_Reward;
         this.FBT_Reward.OnMove = this.OnRewardMouseMove;
         this.FBT_Reward.OnOut = this.OnMouseOut;
         this.FBT_Reward.OnClick = this.OnGetReward;
         this.FBT_Reward.Visible = false;
         this.FRankComposeQuality = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RankComposeQuality);
         this.FRankExpendCostBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RankExpendCost);
         this.FRankRewardBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RankReward);
         this.FRankMoneyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_RankMoney);
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         this.FUIHeros = new Vector.<TUIHero>(HERO_Count);
         this.FRolesModelID = new Vector.<int>();
         _loc1_ = 0;
         while(_loc1_ < HERO_Count)
         {
            this.FResource.mc_fightHero["mc_hero_" + _loc1_].addEventListener(MouseEvent.CLICK,this.OnFightArena);
            this.FResource.mc_fightHero["mc_hero_" + _loc1_].addEventListener(MouseEvent.ROLL_OVER,this.OnHeroRoll);
            this.FResource.mc_fightHero["mc_hero_" + _loc1_].addEventListener(MouseEvent.ROLL_OUT,this.OnHeroRoll);
            _loc5_ = new TUIHero(this);
            this.FResource.mc_fightHero["mc_hero_" + _loc1_].mc_heroPoint.addChild(_loc5_);
            _loc5_.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
            _loc5_.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
            _loc6_ = new TBounds();
            _loc7_ = new TCoordinate();
            _loc5_.SequenceDefaultRole.Evaluate(_loc7_,_loc6_);
            _loc5_.X = _loc6_.X;
            _loc5_.Y = _loc6_.Y;
            this.FUIHeros[_loc1_] = _loc5_;
            _loc1_++;
         }
         this.FResource.mc_fightHero.mc_rank_1.mouseEnabled = false;
         this.FResource.mc_fightHero.mc_rank_2.mouseEnabled = false;
         this.FResource.mc_fightHero.mc_rank_3.mouseEnabled = false;
         this.ResetRank();
         this.FTextReportVect = new Vector.<TextField>(REPORT_MAX);
         this.FBtnReportVect = new Vector.<TUIButton>(REPORT_MAX);
         this.FWhenVect = new Vector.<String>(WHEN_NUM);
         _loc1_ = 0;
         while(_loc1_ < REPORT_MAX)
         {
            _loc3_ = new TextField();
            _loc3_.filters = [REPORT_TextFilters];
            this.FTextReportVect[_loc1_] = _loc3_;
            _loc3_.width = 370;
            _loc3_.height = 20;
            _loc3_.mouseEnabled = false;
            _loc3_.textColor = 16777215;
            _loc3_.x = TextFiledInitPosX;
            _loc3_.y = TextFiledInitPosY + _loc1_ * TextFiledInitHeight;
            this.FResource.mc_report.tf_report.addChild(_loc3_);
            _loc4_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_ARENA.RESOURCE_ClassName_BTN_Replay) as MovieClip;
            this.FResource.mc_report.tf_report.addChild(_loc4_);
            _loc4_.x = this.FResource.mc_report.width - _loc4_.width;
            _loc4_.y = BtnInitPosY + _loc1_ * TextFiledInitHeight;
            _loc2_ = new TUIButton();
            _loc2_.Substrate = _loc4_;
            _loc2_.OnClick = this.OnReplayClick;
            _loc2_.Visible = false;
            this.FBtnReportVect[_loc1_] = _loc2_;
            _loc1_++;
         }
         this.FWhenVect = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.ARENA_STRING_11);
         this.FInitialization = true;
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function GetQualityByRanking(param1:uint) : int
      {
         var _loc2_:uint = 0;
         var _loc3_:TRankComposeQuality = null;
         var _loc4_:uint = 0;
         _loc4_ = 1;
         _loc2_ = 0;
         while(_loc2_ < this.FRankComposeQuality.Count)
         {
            _loc3_ = this.FRankComposeQuality.GetDatebaseByIndex(_loc2_) as TRankComposeQuality;
            if(param1 >= _loc3_.From && param1 <= _loc3_.To)
            {
               _loc4_ = uint(_loc3_.Quality);
               break;
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      protected function GetArenaIdByRanking(param1:int) : int
      {
         var _loc2_:uint = 0;
         var _loc3_:TRankComposeQuality = null;
         var _loc4_:uint = 0;
         _loc4_ = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FRankComposeQuality.Count)
         {
            _loc3_ = this.FRankComposeQuality.GetDatebaseByIndex(_loc2_) as TRankComposeQuality;
            if(param1 >= _loc3_.From && param1 <= _loc3_.To)
            {
               _loc4_ = uint(_loc3_.Identifier);
               break;
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      protected function UpdataUIArena() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:String = null;
         var _loc3_:TMilitary = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:TRankExpendCost = null;
         var _loc7_:TRankComposeQuality = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:uint = 0;
         this.FBigPicId = this.FCharacter.MainHero.SmallID;
         if(this.FBigBitmap.bitmapData == null)
         {
            SResourcesCore.TexturesHeadIcon.LoadAutoSecondary(this.FBigPicId,this.AutoLoadCallBack);
         }
         _loc6_ = this.FRankExpendCostBins.GetDatebaseByIdentifier(this.FArenaData.AddTimes + 1) as TRankExpendCost;
         if(_loc6_ != null)
         {
            _loc5_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ARENA_STRING_01);
            _loc5_ = TUtilityString.Format(_loc5_,_loc6_ ? _loc6_.Cost : 0);
            this.FBT_AddCurTimes.Hint.Caption = _loc5_;
         }
         else
         {
            this.FBT_AddCurTimes.Visible = false;
         }
         this.FResource.mc_baseInfo.tf_playerName.text = this.FCharacter.NickName;
         this.FResource.mc_baseInfo.tf_strength.text = this.FCharacter.GetFightingPower().toString();
         this.FResource.mc_baseInfo.tf_SilverCoin.text = this.FCharacter.CreditSilverCoin.ToString();
         this.FResource.mc_baseInfo.tf_gold.text = this.FCharacter.CreditGold.toString();
         this.FResource.mc_baseInfo.tf_giftCertificate.text = this.FCharacter.CreditGiftCertificate.toString();
         this.FResource.mc_baseInfo.tf_level.text = "Lv." + this.FCharacter.GetMainRebirthLevel().toString();
         _loc3_ = this.FMilitaryBins.GetDatebaseByIdentifier(this.FCharacter.MilitaryRank) as TMilitary;
         this.FResource.mc_baseInfo.tf_militaryRank.text = _loc3_.Name;
         this.FResource.mc_baseInfo.tf_curRanking.text = this.FArenaData.CurRanking.toString();
         this.FResource.mc_baseInfo.tf_highRank.text = Math.min(this.FArenaData.HighRanking,this.FArenaData.CurRanking).toString();
         this.FResource.mc_baseInfo.tf_streakWin.text = this.FArenaData.StreakWin.toString();
         this.FResource.mc_baseInfo.tf_curTimes.text = this.FArenaData.FightTimes.toString();
         this.FIsFightTimesCanFight = this.FArenaData.FightTimes > 0;
         this.FMyBoxQuality = this.GetQualityByRanking(this.FArenaData.CurRanking);
         _loc9_ = this.GetArenaIdByRanking(this.FArenaData.CurRanking);
         _loc1_ = 0;
         while(_loc1_ < CONST_RankingBoxCount)
         {
            if(_loc9_ < CONST_RankingBoxCount)
            {
               _loc8_ = int(_loc1_);
            }
            else
            {
               _loc8_ = _loc9_ - CONST_RankingBoxCount + 1 + _loc1_;
            }
            if(_loc1_ == 0)
            {
               this.FStartBoxId = _loc8_;
            }
            _loc7_ = this.FRankComposeQuality.GetDatebaseByIdentifier(_loc8_) as TRankComposeQuality;
            _loc4_ = _loc7_.Quality;
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ARENA_STRING_12);
            _loc10_ = _loc7_.From + "~" + _loc7_.To;
            _loc2_ = TUtilityString.Format(_loc2_,_loc10_);
            this.FResource.mc_boxList["mc_box_" + _loc1_].tf_ranking.text = _loc2_;
            this.FResource.mc_boxList["mc_box_" + _loc1_].mc_box.mc_box.gotoAndStop(_loc4_);
            _loc1_++;
         }
         this.FResource.mc_title.mc_title.tf_curRanking.text = this.FArenaData.CurRanking.toString();
         this.FResource.mc_title.mc_title.mc_timer.visible = this.FArenaData.BoxType != 1;
         if(this.FArenaData.BoxType == 0)
         {
            this.FResource.mc_title.btn_getReward.mc_box.gotoAndStop(this.FMyBoxQuality);
            this.FResource.mc_title.mc_Reward.gotoAndStop(1);
            this.FBT_Reward.Visible = false;
         }
         else if(this.FArenaData.BoxType == 1)
         {
            _loc11_ = uint(this.GetQualityByRanking(this.FArenaData.BoxRanking));
            this.FResource.mc_title.btn_getReward.mc_box.gotoAndStop(_loc11_);
            this.FResource.mc_title.mc_Reward.gotoAndPlay(1);
            this.FBT_Reward.Visible = true;
         }
         else if(this.FArenaData.BoxType == 2)
         {
            this.FResource.mc_title.mc_Reward.gotoAndStop(1);
            this.FBT_Reward.Visible = false;
            if(this.FArenaData.BoxRanking < 1000)
            {
               _loc11_ = uint(this.GetQualityByRanking(this.FArenaData.BoxRanking));
               this.FResource.mc_title.btn_getReward.mc_box.gotoAndStop(_loc11_);
            }
            else
            {
               this.FResource.mc_title.btn_getReward.mc_box.gotoAndStop(this.FMyBoxQuality);
            }
         }
      }
      
      protected function AutoLoadCallBack(param1:Object, param2:TTexture, param3:uint) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:BitmapData = null;
         switch(param3)
         {
            case this.FBigPicId:
               _loc4_ = param2.GetAnimationSequenceByIndex(0);
               _loc5_ = _loc4_.GetAnimationFrameByIndex(0).Surface;
               this.FBigBitmap.bitmapData = _loc5_;
         }
      }
      
      protected function GetRewardMoney(param1:int, param2:int) : int
      {
         return Math.floor(2000 * Math.pow(2,param1 / 20) * Math.log(6561 / (param2 + 8)) / Math.log(3));
      }
      
      protected function MakeHtmlText(param1:uint, param2:uint, param3:uint) : String
      {
         var _loc4_:TRankComposeQuality = null;
         var _loc5_:TRankReward = null;
         var _loc6_:TRankMoney = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         _loc4_ = this.FRankComposeQuality.GetDatebaseByIdentifier(param1) as TRankComposeQuality;
         _loc8_ = (param3 - 1) * QUALITY_MAX + _loc4_.Quality;
         _loc5_ = this.FRankRewardBins.GetDatebaseByIdentifier(_loc8_) as TRankReward;
         _loc6_ = this.FRankMoneyBins.GetDatebaseByIdentifier(param2) as TRankMoney;
         _loc7_ = this.GetRewardMoney(param3,param2);
         _loc10_ = _loc5_.Tips.split("\\n");
         _loc9_ = _loc10_[0] + "\n" + _loc10_[1] + "\n";
         _loc9_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin) + " +" + _loc7_ + "\n";
         return _loc9_ + (TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Prestige) + " +" + _loc6_.Prestige);
      }
      
      protected function MakeListHtmlText(param1:uint, param2:uint, param3:uint, param4:uint) : String
      {
         var _loc5_:TRankComposeQuality = null;
         var _loc6_:TRankReward = null;
         var _loc7_:TRankMoney = null;
         var _loc8_:TRankMoney = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:String = null;
         var _loc13_:Array = null;
         _loc5_ = this.FRankComposeQuality.GetDatebaseByIdentifier(param1) as TRankComposeQuality;
         _loc11_ = (param4 - 1) * QUALITY_MAX + _loc5_.Quality;
         _loc6_ = this.FRankRewardBins.GetDatebaseByIdentifier(_loc11_) as TRankReward;
         _loc7_ = this.FRankMoneyBins.GetDatebaseByIdentifier(param2) as TRankMoney;
         _loc8_ = this.FRankMoneyBins.GetDatebaseByIdentifier(param3) as TRankMoney;
         _loc9_ = this.GetRewardMoney(param4,param2);
         _loc10_ = this.GetRewardMoney(param4,param3);
         _loc13_ = _loc6_.Tips.split("\\n");
         _loc12_ = _loc13_[0] + "\n" + _loc13_[1] + "\n";
         _loc12_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin) + " +" + _loc10_ + "~" + _loc9_ + "\n";
         _loc12_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Prestige) + " +" + _loc8_.Prestige + "~" + _loc7_.Prestige + "\n";
         _loc12_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ARENA_STRING_10);
         return TUtilityString.Format(_loc12_,_loc5_.From,_loc5_.To);
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TArenaHero = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         var _loc8_:TBounds = null;
         var _loc9_:TCoordinate = null;
         var _loc10_:TRoleModel = null;
         var _loc11_:uint = 0;
         var _loc12_:int = 0;
         var _loc13_:uint = 0;
         var _loc14_:TUIHero = null;
         _loc5_ = param2 as TArenaHero;
         _loc13_ = uint(this.FArenaHeros.Count);
         _loc12_ = 0;
         while(_loc12_ < _loc13_)
         {
            if(this.FUIHeros[_loc12_].Context == _loc5_)
            {
               _loc14_ = this.FUIHeros[_loc12_];
               break;
            }
            _loc12_++;
         }
         _loc6_ = SResourcesCore.TexturesModel;
         _loc10_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc5_.HeroId) as TRoleModel;
         _loc11_ = CONST_ROLE.GetModelIDByIndex(_loc10_.Model,CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc11_);
         if(_loc7_ != null)
         {
            _loc8_ = new TBounds();
            _loc9_ = new TCoordinate();
            param3.Value = _loc7_.GetAnimationSequenceByIndex(param4);
            param3.Value.Evaluate(_loc9_,_loc8_);
            _loc14_.X = _loc8_.X;
            _loc14_.Y = _loc8_.Y;
         }
         else
         {
            _loc6_.LoadSecondary(_loc11_);
         }
         this.SetRoleModelID(_loc11_);
      }
      
      protected function SetRoleModelID(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FRolesModelID.indexOf(param1);
         if(_loc2_ < 0)
         {
            this.FRolesModelID.push(param1);
         }
      }
      
      protected function SetHeroData(param1:TArenaHero, param2:MovieClip) : void
      {
         var _loc3_:MovieClip = null;
         var _loc4_:uint = 0;
         if(param1 == null || param2 == null)
         {
            return;
         }
         param2.tf_name.text = param1.PlayerNick;
         param2.tf_level.text = "LV." + param1.PlayerLevel.toString();
         param2.mc_country.gotoAndStop(param1.Country);
         param2.mc_rank.tf_Ranking.mouseEnabled = false;
         param2.tf_name.mouseEnabled = false;
         param2.tf_level.mouseEnabled = false;
         param2.mc_country.mouseEnabled = false;
         param2.mc_rank.gotoAndStop(1);
         if(param1.Ranking <= 3)
         {
            _loc4_ = 0;
            while(_loc4_ < this.FArenaHeros.Count)
            {
               if(this.FArenaHeros.GetHeroByIndex(_loc4_) == param1)
               {
                  break;
               }
               _loc4_++;
            }
            _loc4_++;
            _loc3_ = this.FResource["mc_fightHero"]["mc_rank_" + _loc4_];
            _loc3_.visible = true;
            _loc3_.gotoAndStop(param1.Ranking);
            if(param1.Ranking == 1)
            {
               _loc3_.firstRank.play();
            }
            else
            {
               _loc3_.mc_up.play();
               _loc3_.mc_down.play();
            }
            param2.mc_rank.gotoAndStop(2);
            this.FResource["mc_fightHero"]["mc_Steps"].visible = false;
         }
         param2.mc_rank.tf_Ranking.text = param1.Ranking.toString();
      }
      
      protected function UpdataUIHero() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TArenaHero = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:MovieClip = null;
         this.FResource.mc_fightHero.mc_rank_1.visible = false;
         this.FResource.mc_fightHero.mc_rank_2.visible = false;
         this.FResource.mc_fightHero.mc_rank_3.visible = false;
         _loc1_ = 0;
         while(_loc1_ < HERO_Count)
         {
            if(_loc1_ < this.FArenaHeros.Count)
            {
               _loc2_ = this.FArenaHeros.GetHeroByIndex(_loc1_);
               _loc3_ = _loc2_.Identifier0;
               _loc4_ = _loc2_.Identifier1;
               if(_loc3_ == this.FMySelfIdentifier0 && _loc4_ == this.FMySelfIdentifier1)
               {
                  _loc5_ = this.FResource.mc_fightHero["mc_hero_" + _loc1_];
                  this.FMySelfIndex = _loc1_;
                  _loc5_.gotoAndStop(3);
                  this.FMyFire0 = _loc5_.mc_fire_0;
                  this.FMyFire1 = _loc5_.mc_fire_1;
                  this.FMyFire0.play();
                  this.FMyFire1.play();
               }
               else
               {
                  this.FResource.mc_fightHero["mc_hero_" + _loc1_].gotoAndStop(1);
               }
               this.FResource.mc_fightHero["mc_hero_" + _loc1_].visible = true;
               this.SetHeroData(this.FArenaHeros.GetHeroByIndex(_loc1_),this.FResource.mc_fightHero["mc_hero_" + _loc1_]);
            }
            else
            {
               this.FResource.mc_fightHero["mc_hero_" + _loc1_].visible = false;
            }
            _loc1_++;
         }
      }
      
      protected function StartFightReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         var _loc3_:TArenaHero = null;
         if(TutorialNextStep != null)
         {
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_StartChallengePeople);
         }
         _loc3_ = this.FArenaHeros.GetHeroByIndex(this.FFightIndex);
         if(_loc3_.Identifier0 == this.FMySelfIdentifier0 && _loc3_.Identifier1 == this.FMySelfIdentifier1)
         {
            return;
         }
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Arena_Fight_Req);
         _loc2_ = _loc1_.Data;
         _loc2_.writeInt(_loc3_.Identifier0);
         _loc2_.writeInt(_loc3_.Identifier1);
         _loc2_.writeByte(this.FFightIndex);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function GetReportWhen(param1:uint) : String
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc2_ = "";
         _loc4_ = (STimingCore.ServerTick - STimingCore.ServerTimeZone) / 86400;
         _loc5_ = (param1 - STimingCore.ServerTimeZone) / 86400;
         _loc3_ = _loc4_ - _loc5_;
         if(_loc3_ < this.FWhenVect.length)
         {
            _loc2_ = this.FWhenVect[_loc3_];
         }
         else
         {
            _loc2_ = this.FWhenVect[this.FWhenVect.length - 1];
         }
         return _loc2_;
      }
      
      protected function MakeHtmlTextInfo(param1:TArenaReport) : String
      {
         var _loc2_:String = null;
         if(param1.IsFight)
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ARENA_STRING_03);
         }
         else
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ARENA_STRING_04);
         }
         if(param1.IsWin)
         {
            _loc2_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ARENA_STRING_05);
         }
         else
         {
            _loc2_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ARENA_STRING_06);
         }
         if(param1.ChgRanking > 0)
         {
            _loc2_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ARENA_STRING_07);
         }
         else if(param1.ChgRanking < 0)
         {
            _loc2_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ARENA_STRING_08);
         }
         else
         {
            _loc2_ += TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ARENA_STRING_09);
         }
         return TUtilityString.Format(_loc2_,this.GetReportWhen(param1.When),param1.PlayerNick,Math.abs(param1.ChgRanking));
      }
      
      protected function UpdataUIReport() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TextField = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TUIButton = null;
         _loc1_ = 0;
         while(_loc1_ < REPORT_MAX)
         {
            _loc2_ = this.FTextReportVect[_loc1_];
            _loc4_ = this.FBtnReportVect[_loc1_];
            if(_loc1_ < this.FArenaReports.Count)
            {
               _loc2_.visible = true;
               _loc2_.htmlText = this.MakeHtmlTextInfo(this.FArenaReports.GetReportByIndex(_loc1_));
               _loc4_.Visible = true;
            }
            else
            {
               _loc2_.visible = false;
               _loc4_.Visible = false;
            }
            _loc1_++;
         }
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         if(this.FResource != null)
         {
            _loc1_ = uint(stage.stageWidth);
            this.FResource.mc_autoPoint.x = _loc1_ - this.FResource.mc_autoPoint.width;
            this.FResource.mc_title.x = _loc1_ - TITLE_TEP_X;
            this.FResource.mc_report.x = _loc1_ - this.FResource.mc_report.width;
            this.FResource.mc_boxList.x = _loc1_ - this.FResource.mc_boxList.width;
         }
      }
      
      protected function CloseOnClick(param1:MouseEvent) : void
      {
         this.BT_BackOnClose(this,param1);
      }
      
      protected function BT_BackOnClose(param1:Object, param2:MouseEvent) : void
      {
         this.FArenaData.FightHeroList.Clear();
         this.FArenaData.HeroPanelList.Clear();
         this.FArenaData.ReportList.Clear();
         ProcessorWindowClose();
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_Arena);
         }
         if(this.FOnHelpTipsOver != null)
         {
            this.FOnHelpTipsOver(this,this.FHelpTips);
         }
      }
      
      protected function ButtonHelpOnOut(param1:MouseEvent) : void
      {
         if(this.FOnHelpTipsOut != null)
         {
            this.FOnHelpTipsOut(this,this.FHelpTips);
         }
      }
      
      protected function OnShowHeroPanel(param1:Object, param2:MouseEvent = null) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Arena_BigFish_Req);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      private function FastOnClick(param1:MouseEvent) : void
      {
         this.OnShowWindowConfirmationAddTimes(param1.currentTarget,param1);
      }
      
      protected function OnShowWindowConfirmationAddTimes(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TRankExpendCost = null;
         if(param1 == this.FBT_AddCurTimes)
         {
            if(this.FArenaData.AddTimes + 1 > this.FRankExpendCostBins.Count)
            {
               return;
            }
            _loc6_ = this.FRankExpendCostBins.GetDatebaseByIdentifier(this.FArenaData.AddTimes + 1) as TRankExpendCost;
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ARENA_STRING_01);
            _loc3_ = TUtilityString.Format(_loc3_,_loc6_ ? _loc6_.Cost : 0);
            this.FCheckCost = _loc6_.Cost;
            this.FUIWindowConfirmation.Text = _loc3_;
            this.FUIWindowConfirmation.OnOK = this.OnAddTimes;
         }
         else if(param1 == this.FResource.mc_baseInfo.btn_fast)
         {
            _loc4_ = this.FArenaData.ColdDown - STimingCore.ServerTick;
            if(_loc4_ < 0)
            {
               this.FResource.mc_baseInfo.btn_fast.visible = false;
               return;
            }
            _loc5_ = Math.max((int(_loc4_ - 1)) / 60 + 1,1);
            this.FCheckCost = _loc5_;
            _loc3_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ARENA_STRING_02);
            _loc3_ = TUtilityString.Format(_loc3_,_loc5_);
            this.FUIWindowConfirmation.Text = _loc3_;
            this.FUIWindowConfirmation.OnOK = this.OnFast;
         }
         if(this.FCheckCost > this.FCharacter.CreditGiftCertificate + this.FCharacter.CreditGold)
         {
            this.FUIWindowRecharge.SetGoldNum(this.FCheckCost);
            this.FUIWindowRecharge.Visible = true;
            return;
         }
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function OnAddTimes(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         if(this.FCheckCost > this.FCharacter.CreditGiftCertificate + this.FCharacter.CreditGold)
         {
            if(EffectGenerateText != null)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            }
            return;
         }
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Arena_AddOrder_Req);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function OnFast(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         if(this.FCheckCost > this.FCharacter.CreditGiftCertificate + this.FCharacter.CreditGold)
         {
            if(EffectGenerateText != null)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
            }
            return;
         }
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Arena_Faster_Req);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function OnMouseMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TRankComposeQuality = null;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:TUIButton = null;
         _loc4_ = int(String(param2.currentTarget.name).slice(7));
         _loc6_ = this.FStartBoxId + _loc4_;
         _loc5_ = this.FCharacter.GetMainRebirthLevel();
         _loc3_ = this.FRankComposeQuality.GetDatebaseByIdentifier(_loc6_) as TRankComposeQuality;
         _loc7_ = this.MakeListHtmlText(_loc6_,_loc3_.To,_loc3_.From,_loc5_);
         this.FHintBoxTip.Caption = _loc7_;
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(this,this.FHintBoxTip);
         }
      }
      
      protected function OnMouseOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHintBoxTip);
         }
         param2.currentTarget.gotoAndStop(1);
      }
      
      protected function OnRewardMouseMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TRankComposeQuality = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:String = null;
         var _loc9_:MovieClip = param2.currentTarget as MovieClip;
         if(param1 == this.FBT_GetReward)
         {
            _loc4_ = this.GetQualityByRanking(this.FArenaData.CurRanking);
            _loc5_ = (_loc4_ - 1) * QUALITY_MAX + _loc4_;
            _loc7_ = this.FCharacter.GetMainRebirthLevel();
            _loc6_ = this.GetArenaIdByRanking(this.FArenaData.CurRanking);
            _loc3_ = this.FRankComposeQuality.GetDatebaseByIdentifier(_loc6_) as TRankComposeQuality;
            _loc8_ = this.MakeHtmlText(_loc6_,this.FArenaData.CurRanking,_loc7_);
         }
         else if(param1 == this.FBT_Reward)
         {
            _loc4_ = this.GetQualityByRanking(this.FArenaData.BoxRanking);
            _loc5_ = (_loc4_ - 1) * QUALITY_MAX + _loc4_;
            _loc6_ = this.GetArenaIdByRanking(this.FArenaData.BoxRanking);
            _loc3_ = this.FRankComposeQuality.GetDatebaseByIdentifier(_loc6_) as TRankComposeQuality;
            _loc8_ = this.MakeHtmlText(_loc6_,this.FArenaData.BoxRanking,this.FArenaData.BoxLevel);
         }
         this.FHintBoxTip.Caption = _loc8_;
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(this,this.FHintBoxTip);
         }
      }
      
      protected function OnGetReward(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         if(this.FArenaData.BoxType != 1)
         {
            return;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Arena_GetReward_Req);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function Btn_AddOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(this,_loc3_.Hint);
         }
      }
      
      protected function Btn_AddOnOut(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         _loc3_ = param1 as TUIButton;
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,_loc3_.Hint);
         }
      }
      
      protected function OnFightArena(param1:MouseEvent) : void
      {
         var _loc2_:TArenaHero = null;
         if(!param1.currentTarget.buttonMode)
         {
            return;
         }
         this.FFightIndex = int(String(param1.currentTarget.name).slice(8));
         _loc2_ = this.FArenaHeros.GetHeroByIndex(this.FFightIndex);
         if(_loc2_.Identifier0 == this.FMySelfIdentifier0 && _loc2_.Identifier1 == this.FMySelfIdentifier1)
         {
            return;
         }
         if(this.FCheckCanFight != null)
         {
            if(!this.FCheckCanFight())
            {
               this.FFightIndex = -1;
               return;
            }
         }
         this.StartFightReq();
      }
      
      protected function OnHeroRoll(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         _loc3_ = param1.currentTarget as MovieClip;
         _loc2_ = uint(int(_loc3_.name.slice(8)));
         if(_loc2_ == this.FMySelfIndex)
         {
            return;
         }
         if(param1.type == MouseEvent.ROLL_OVER)
         {
            _loc3_.buttonMode = true;
            this.FResource.mc_fightHero["mc_hero_" + _loc2_].gotoAndStop(2);
         }
         else if(param1.type == MouseEvent.ROLL_OUT)
         {
            _loc3_.buttonMode = false;
            this.FResource.mc_fightHero["mc_hero_" + _loc2_].gotoAndStop(1);
         }
      }
      
      protected function OnReplayClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TArenaReport = null;
         var _loc5_:TUIButton = null;
         _loc5_ = param1 as TUIButton;
         _loc3_ = this.FBtnReportVect.indexOf(_loc5_);
         _loc4_ = this.FArenaReports.GetReportByIndex(_loc3_);
         SExternalCore.NavigateToBattleReportUrl(_loc4_.ReportId);
      }
      
      public function get Resource() : MovieClip
      {
         return this.FResource;
      }
      
      public function set Resource(param1:MovieClip) : void
      {
         this.FResource = param1;
      }
      
      public function get OnHelpTipsOver() : Function
      {
         return this.FOnHelpTipsOver;
      }
      
      public function set OnHelpTipsOver(param1:Function) : void
      {
         this.FOnHelpTipsOver = param1;
      }
      
      public function get OnHelpTipsOut() : Function
      {
         return this.FOnHelpTipsOut;
      }
      
      public function set OnHelpTipsOut(param1:Function) : void
      {
         this.FOnHelpTipsOut = param1;
      }
      
      public function get HintOnMove() : Function
      {
         return this.FHintOnMove;
      }
      
      public function set HintOnMove(param1:Function) : void
      {
         this.FHintOnMove = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get OnCheckCanFight() : Function
      {
         return this.FCheckCanFight;
      }
      
      public function set OnCheckCanFight(param1:Function) : void
      {
         this.FCheckCanFight = param1;
      }
      
      public function UpdataColdDown() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:String = null;
         if(!this.FInitialization)
         {
            return;
         }
         if(this.FArenaData == null)
         {
            return;
         }
         _loc1_ = this.FArenaData.ColdDown - STimingCore.ServerTick;
         if(_loc1_ <= 0)
         {
            this.FIsColdDownCanFight = true;
            this.FResource.mc_baseInfo.tf_fighttip.visible = true;
            this.FResource.mc_baseInfo.tf_coldtip.visible = false;
            this.FResource.mc_baseInfo.btn_fast.visible = false;
         }
         else
         {
            this.FIsColdDownCanFight = false;
            this.FResource.mc_baseInfo.tf_fighttip.visible = false;
            this.FResource.mc_baseInfo.tf_coldtip.visible = true;
            this.FResource.mc_baseInfo.btn_fast.visible = true;
            _loc3_ = TUtilityTiming.fomatTime(_loc1_);
            _loc3_ = _loc3_.slice(3);
            this.FResource.mc_baseInfo.tf_coldtip.tf_timer.text = _loc3_;
         }
         _loc2_ = this.FArenaData.ColdDownBox - STimingCore.ServerTick;
         if(_loc2_ <= 0)
         {
            this.FArenaData.ColdDownBox += TUtilityTiming.CONST_DAY;
            this.UpdataUIArena();
         }
         _loc3_ = TUtilityTiming.fomatTime(_loc2_);
         this.FResource.mc_title.mc_title.mc_timer.tf_timer.text = _loc3_;
         this.FResource.mc_title.mc_title.mc_timer.visible = true;
      }
      
      public function Update() : void
      {
         this.FResource.mc_bottomFlame.play();
      }
      
      public function SetArenaData(param1:TArenaData) : void
      {
         this.FArenaData = param1;
         this.FCharacter = SLogicsCore.Character;
         if(this.FMilitaryBins == null)
         {
            this.FMilitaryBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Military);
         }
         this.UpdataUIArena();
      }
      
      public function SetArenaReports(param1:TArenaReports) : void
      {
         this.FArenaReports = param1;
         this.UpdataUIReport();
      }
      
      public function GetRewardOk() : void
      {
         var _loc1_:Date = null;
         var _loc2_:Date = null;
         var _loc3_:TConfigValue = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this.FArenaData.BoxType = 2;
         _loc1_ = new Date(this.FArenaData.ColdDownBox * 1000);
         _loc2_ = new Date(STimingCore.ServerTick * 1000);
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.ARENA_RANK_REWARD_BOX_GET_HOUR) as TConfigValue;
         _loc4_ = _loc3_.Value as int;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.ARENA_RANK_REWARD_BOX_GET_SECOND) as TConfigValue;
         _loc5_ = _loc3_.Value as int;
         if(_loc2_.hours > _loc4_ || _loc2_.hours == _loc4_ && _loc2_.minutes > _loc5_)
         {
            if(_loc1_.date == _loc2_.date)
            {
               this.FArenaData.ColdDownBox += TUtilityTiming.CONST_DAY;
            }
         }
         this.UpdataUIArena();
      }
      
      public function AddOrderOk() : void
      {
         this.FArenaData.AddTimes += 1;
         this.FArenaData.FightTimes += 1;
         this.UpdataUIArena();
      }
      
      public function FasterOk() : void
      {
         this.FArenaData.ColdDown = 0;
         this.FIsColdDownCanFight = true;
      }
      
      public function CheckCanFight() : Boolean
      {
         if(!this.FIsFightTimesCanFight)
         {
            this.OnShowWindowConfirmationAddTimes(this.FBT_AddCurTimes,null);
            return false;
         }
         if(!this.FIsColdDownCanFight)
         {
            this.FResource.mc_baseInfo.btn_fast.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
            return false;
         }
         return true;
      }
      
      public function Reset() : void
      {
         this.ResetRank();
         this.ResetHero();
         this.FResource.mc_bottomFlame.stop();
         this.FBigBitmap.bitmapData = null;
      }
      
      public function UpdataModel() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TArenaHero = null;
         var _loc3_:MovieClip = null;
         if(this.FArenaHeros == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FArenaHeros.Count)
         {
            this.FUIHeros[_loc1_].Update();
            _loc1_++;
         }
      }
      
      public function SetUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TArenaHero = null;
         var _loc3_:MovieClip = null;
         if(this.FArenaHeros == null)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FArenaHeros.Count)
         {
            this.FUIHeros[_loc1_].Context = this.FArenaHeros.GetHeroByIndex(_loc1_);
            _loc1_++;
         }
      }
      
      public function SetArenaHeros(param1:TArenaHeros) : void
      {
         this.FArenaHeros = param1;
         this.FMySelfIdentifier0 = SLogicsCore.Character.Identifier0;
         this.FMySelfIdentifier1 = SLogicsCore.Character.Identifier1;
         this.FResource.mc_fightHero.mc_Steps.visible = true;
         this.UpdataUIHero();
         this.SetUI();
      }
      
      public function StartFight() : void
      {
         this.StartFightReq();
      }
      
      private function ResetRank() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:MovieClip = null;
         _loc2_ = Rank_Count;
         _loc1_ = 1;
         while(_loc1_ <= _loc2_)
         {
            _loc3_ = this.FResource.mc_fightHero["mc_rank_" + _loc1_];
            _loc3_.gotoAndStop(_loc1_);
            if(_loc3_.firstRank)
            {
               _loc3_.firstRank.stop();
            }
            else
            {
               _loc3_.mc_up.stop();
               _loc3_.mc_down.stop();
            }
            _loc1_++;
         }
         if(this.FMyFire0 != null)
         {
            this.FMyFire0.stop();
         }
         if(this.FMyFire1 != null)
         {
            this.FMyFire1.stop();
         }
      }
      
      protected function ResetHero() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TUIHero = null;
         _loc2_ = this.FRolesModelID.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = uint(this.FRolesModelID[_loc1_]);
            SResourcesCore.TexturesModel.DeleteByIdentifier(_loc3_,true);
            _loc1_++;
         }
         this.FRolesModelID.length = 0;
         _loc2_ = HERO_Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUIHeros[_loc1_].Context = null;
            _loc1_++;
         }
      }
   }
}

