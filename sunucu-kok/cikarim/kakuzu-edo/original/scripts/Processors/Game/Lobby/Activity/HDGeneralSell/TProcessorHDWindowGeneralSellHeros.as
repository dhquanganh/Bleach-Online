package Processors.Game.Lobby.Activity.HDGeneralSell
{
   import Components.Standard.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityOS.*;
   import Logics.HDIceHeros.*;
   import Logics.Inventories.*;
   import Logics.KnifeOfKillSoul.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDChineseYear.Component.*;
   import Processors.Game.Lobby.Activity.HDGeneralSell.Compoent.TUIIceHeroAwardBox;
   import Processors.Game.Lobby.Activity.HDGeneralSell.Compoent.TUIIceHeroPlayer;
   import Processors.Game.Lobby.Common.Hero.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDWindowGeneralSellHeros extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_MC_AWARD:uint = 5;
      
      protected static const COUNT_MC_GIFTBOX:uint = 2;
      
      protected static const COUNT_MC_Rank:uint = 6;
      
      protected static const KNIFE_WIDTH:uint = 254;
      
      protected static const KNIFE_HEIGHT:uint = 435;
      
      protected static const COUNT_MC_HEROS:uint = 2;
      
      protected static const STYLEFRAME:uint = 2;
      
      protected static const ICONFRAME:uint = 1;
      
      protected static var MIDDLEPOS:uint = 220;
      
      protected var FMC_HeroList:Vector.<TUIIceHeroPlayer>;
      
      protected var FMC_GiftBoxs:Vector.<MovieClip>;
      
      protected var FBtn_GiftBoxs:Vector.<TUIButton>;
      
      protected var FMC_AwardList:Vector.<TUIIceHeroAwardBox>;
      
      protected var FBtn_ShowRank:TUIButton;
      
      protected var FTF_Owned:TextField;
      
      protected var FTF_GiftBoxCosts:Vector.<TextField>;
      
      protected var FTF_GiftName:Vector.<TextField>;
      
      protected var FMC_KnifeInfoEffect:MovieClip;
      
      protected var FBtn_ShowKnife:TUIButton;
      
      protected var FBtn_HideKnife:TUIButton;
      
      protected var FMC_KnifeInfo:Sprite;
      
      protected var FKnifePop:TKnifePop;
      
      protected var FBtn_ShowBattleInfo:TUIButton;
      
      protected var FMC_GiftBoxBar:MovieClip;
      
      protected var FHDIceHeros:THDIceHeros;
      
      protected var FDataIceHeros:TActivityIceHeros;
      
      protected var FRoleModelIDs:Vector.<uint>;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FIsPlayGiftBoxMC:Boolean;
      
      protected var FRankInventoriesVect:Vector.<TInventories>;
      
      protected var FCurGiftBox:TActivityIHChipBox;
      
      protected var FFixedAwards:Vector.<Object>;
      
      protected var FConfigValueBin:TBins;
      
      protected var FGiftPromptVect:Vector.<String>;
      
      protected var FCountOfHeros:uint;
      
      protected var FWindowShowHero:TProcessorWindowHeroDescription;
      
      protected var FIsPlayKnifeInfoEffect:Boolean;
      
      protected var FKnifeOfKillSoulData:TKnifeOfKillSoulData;
      
      protected var FOnShowRankClick:Function;
      
      protected var FOnShowHeroInfo:Function;
      
      protected var FOnAwardsOver:Function;
      
      protected var FOnAwardsOut:Function;
      
      protected var FOnGiftOver:Function;
      
      protected var FOnGiftOut:Function;
      
      protected var FSetRankInventories:Function;
      
      protected var FOnCreateKnifeOfKillSoulData:Function;
      
      public function TProcessorHDWindowGeneralSellHeros(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_GeneralSell;
         this.FIsInitWindow = false;
         this.FRoleModelIDs = new Vector.<uint>();
         this.FIsPlayGiftBoxMC = false;
         this.FFixedAwards = new Vector.<Object>();
         this.FGiftPromptVect = new Vector.<String>(COUNT_MC_GIFTBOX);
         this.FIsPlayKnifeInfoEffect = false;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.FIsInitWindow)
         {
            return;
         }
         if(this.FHDIceHeros == null)
         {
            return;
         }
         _loc2_ = int(this.FHDIceHeros.HeroIDs.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_HeroList[_loc1_].UpdateUIHero();
            _loc1_++;
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIIceHeroPlayer = null;
         var _loc5_:TUIIceHeroPlayer = null;
         var _loc6_:MovieClip = null;
         var _loc7_:TUIButton = null;
         var _loc8_:TUIIceHeroAwardBox = null;
         super.InitWindow(param1);
         _loc3_ = int(COUNT_MC_HEROS);
         this.FMC_HeroList = new Vector.<TUIIceHeroPlayer>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TUIIceHeroPlayer(this);
            _loc4_.OnBtnOKClick = this.ProcessorBtnOKOnClick;
            _loc4_.OnShowHeroClick = this.ProcessorShowHeroOnClick;
            _loc4_.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
            _loc4_.OnQuerySequenceContext = this.HeroOnQuerySequenceContext;
            _loc4_.Perform_UIDispatch(FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Heros + _loc2_]);
            this.FMC_HeroList[_loc2_] = _loc4_;
            this.FMC_HeroList[_loc2_].Visible = false;
            _loc2_++;
         }
         this.FKnifePop = new TKnifePop(this);
         this.FKnifePop.OnPopColse = this.KnifePopOnClose;
         this.FKnifePop.UIDispatch();
         this.FKnifePop.X = (this.Width - KNIFE_WIDTH) / 2;
         this.FKnifePop.Y = (this.Height - KNIFE_HEIGHT) / 2;
         this.FKnifePop.Visible = false;
         _loc3_ = int(COUNT_MC_GIFTBOX);
         this.FMC_GiftBoxs = new Vector.<MovieClip>(_loc3_);
         this.FBtn_GiftBoxs = new Vector.<TUIButton>(_loc3_);
         this.FTF_GiftBoxCosts = new Vector.<TextField>(_loc3_);
         this.FTF_GiftName = new Vector.<TextField>(_loc3_);
         this.FMC_GiftBoxBar = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Bar];
         this.FMC_GiftBoxBar.gotoAndPlay(1);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = this.FMC_GiftBoxBar[CONST_ACTIVITY.RESOURCE_Link_MC_Bar][CONST_ACTIVITY.RESOURCE_Link_MC_Gift + _loc2_];
            _loc6_.stop();
            _loc6_.visible = false;
            this.FMC_GiftBoxs[_loc2_] = _loc6_;
            this.FTF_GiftBoxCosts[_loc2_] = _loc6_[CONST_ACTIVITY.RESOURCE_Link_TF_Cost];
            this.FTF_GiftBoxCosts[_loc2_].mouseEnabled = false;
            this.FTF_GiftBoxCosts[_loc2_].text = "";
            this.FTF_GiftName[_loc2_] = _loc6_[CONST_ACTIVITY.RESOURCE_Link_TF_GiftName];
            this.FTF_GiftName[_loc2_].mouseEnabled = false;
            this.FTF_GiftName[_loc2_].text = "";
            _loc7_ = new TUIButton();
            _loc7_.Substrate = _loc6_[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
            _loc7_.OnClick = this.PorcessorGiftOnClick;
            _loc7_.OnMove = this.ProcessorGiftBoxOnOver;
            _loc7_.OnOut = this.ProcessorGiftBoxOnOut;
            this.FBtn_GiftBoxs[_loc2_] = _loc7_;
            _loc2_++;
         }
         this.FMC_GiftBoxBar[CONST_ACTIVITY.RESOURCE_Link_MC_Bar]["MC_Mask"].visible = true;
         _loc3_ = int(COUNT_MC_AWARD);
         this.FMC_AwardList = new Vector.<TUIIceHeroAwardBox>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc8_ = new TUIIceHeroAwardBox(this);
            _loc8_.OnAwardBoxOKClick = this.ProcessorBtnOKOnClick;
            _loc8_.OnAwardBoxOver = this.ProcessorAwardOnOver;
            _loc8_.OnAwardBoxOut = this.ProcessorAwardOnOut;
            _loc8_.Perform_UIDispatch(this.FMC_GiftBoxBar[CONST_ACTIVITY.RESOURCE_Link_MC_Bar][CONST_ACTIVITY.RESOURCE_Link_MC_Boxes + _loc2_]);
            this.FMC_AwardList[_loc2_] = _loc8_;
            _loc2_++;
         }
         this.FTF_Owned = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_CurOwned];
         this.FTF_Owned.mouseEnabled = false;
         this.FTF_Owned.text = "";
         this.FBtn_ShowRank = new TUIButton();
         this.FBtn_ShowRank.Substrate = FScene[CONST_ACTIVITY.RESOURCE_Link_Btn_ShowRank];
         this.FBtn_ShowRank.OnClick = this.ProcessorShowRankOnClick;
         this.FWindowShowHero = new TProcessorWindowHeroDescription(FParent);
         this.FWindowShowHero.Perform_UIDispatch();
         this.FWindowShowHero.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowShowHero.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowShowHero.OnClose = this.BtnCloseLukiaWindowOnMouseClick;
         this.SetIconFrame(ICONFRAME);
         this.SetStyleFrame(STYLEFRAME);
         this.FIsInitWindow = true;
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<uint> = null;
         var _loc4_:Vector.<uint> = null;
         var _loc5_:Vector.<uint> = null;
         var _loc6_:Vector.<TFixedAward> = null;
         var _loc7_:TConfigValue = null;
         super.UpdateUIConfig();
         this.FHDIceHeros = FHDActivityConfig as THDIceHeros;
         this.FCountOfHeros = 1;
         _loc2_ = int(COUNT_MC_AWARD);
         _loc3_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[_loc1_] = this.FHDIceHeros.Awards[COUNT_MC_HEROS + _loc1_].Awards;
            _loc1_++;
         }
         FInventoriesVect = ProcessorGetInventoriesVectByAwardID(_loc3_);
         if(this.FConfigValueBin == null)
         {
            this.FConfigValueBin = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ConfigValue);
         }
         _loc7_ = this.FConfigValueBin.GetDatebaseByIdentifier(CONST_CONFIGVALUE.HD_IceHeros) as TConfigValue;
         this.FFixedAwards = _loc7_.Value as Vector.<Object>;
         _loc2_ = int(COUNT_MC_Rank);
         _loc5_ = new Vector.<uint>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_[_loc1_] = this.FHDIceHeros.RankList[_loc1_].Awards[0];
            _loc1_++;
         }
         this.FRankInventoriesVect = ProcessorGetInventoriesVectByAwardID(_loc5_);
         if(this.FSetRankInventories != null)
         {
            this.FSetRankInventories(this,this.FRankInventoriesVect);
         }
         _loc2_ = int(COUNT_MC_GIFTBOX);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FGiftPromptVect[_loc1_] = this.FHDIceHeros.ChipBoxes[_loc1_].Prompts[0];
            if(this.FHDIceHeros.ChipBoxes[_loc1_].Inventories.Count <= 0)
            {
               this.FHDIceHeros.ChipBoxes[_loc1_].ConstructInventoies();
            }
            _loc1_++;
         }
         if(this.FHDIceHeros.IsRankShow == 1)
         {
            this.FBtn_ShowRank.Visible = true;
         }
         else
         {
            this.FBtn_ShowRank.Visible = false;
         }
         if(this.FCountOfHeros == 1)
         {
            this.FMC_HeroList[0].X = MIDDLEPOS;
            this.FMC_HeroList[1].Visible = false;
         }
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FDataIceHeros = param1 as TActivityIceHeros;
         if(this.FDataIceHeros.Runtime != null)
         {
            this.FCountOfHeros = 1;
            this.FMC_HeroList[1].Visible = false;
            FInventoriesVect = new Vector.<TInventories>();
            for each(var rewards:Array in this.FDataIceHeros.Runtime.rewards)
            {
               var fixed:Vector.<TFixedAward> = new Vector.<TFixedAward>();
               for each(var reward:Object in rewards)
               {
                  fixed.push(new TFixedAward(reward));
               }
               FInventoriesVect.push(ProcessorGetInventories(0,fixed));
            }
            FIsInitCoolingTime = false;
            if(FTF_OpenTime != null)
            {
               FTF_OpenTime.text = "Ongoing";
            }
            if(FTF_CoolingTime != null)
            {
               FTF_CoolingTime.text = "--";
            }
            if(FTF_Desc != null)
            {
               FTF_Desc.text = "Spend 10 Gold = 1 Crystal Piece. Unspent remainder carries over. Coupons do not count. Hero exchange and gift claims do not consume Pieces. Each gift\'s next milestone increases after claiming. Admin settings refresh automatically.";
            }
         }
         this.ProcessorCheckEffect();
         this.UpdateUI();
      }
      
      protected function ProcessorCheckEffect() : void
      {
         if(FUpdateStatus != null)
         {
            if(FUpdateStatus != null)
            {
               FUpdateStatus(this);
            }
         }
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.UpdateUI();
         _loc2_ = int(this.FCountOfHeros);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_HeroList[_loc1_].UpdateUI(this.FDataIceHeros.GetAwardByIndex(_loc1_),this.FDataIceHeros.CurOwned,TUIIceHeroPlayer.BuyType_Score);
            this.FMC_HeroList[_loc1_].Visible = true;
            _loc1_++;
         }
         _loc2_ = int(COUNT_MC_AWARD);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_AwardList[_loc1_].UpdateUI(this.FDataIceHeros.GetAwardByIndex(COUNT_MC_HEROS + _loc1_),this.FDataIceHeros.CurOwned,0,0);
            _loc1_++;
         }
         this.FTF_Owned.text = this.FDataIceHeros.CurOwned.toString();
         this.ProcessorUpdateUIGiftBox();
      }
      
      protected function ProcessorUpdateUIGiftBox() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActivityIHChipBox = null;
         var _loc4_:Boolean = false;
         _loc2_ = int(COUNT_MC_GIFTBOX);
         _loc4_ = false;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FDataIceHeros.GetChipBoxByIndex(_loc1_);
            if(_loc3_.Status == CONST_ACTIVITY_MODE.Activity_CanReceive)
            {
               _loc4_ = true;
            }
            else if(_loc3_.Status == CONST_ACTIVITY_MODE.Activity_CanNotReceive)
            {
               this.FMC_GiftBoxs[_loc1_].visible = false;
               this.FMC_GiftBoxs[_loc1_].stop();
            }
            this.FTF_GiftBoxCosts[_loc1_].text = _loc3_.Cost.toString();
            this.FTF_GiftName[_loc1_].text = _loc3_.Name;
            _loc1_++;
         }
         if(_loc4_)
         {
            this.ProcessorPlayMCGiftBox();
         }
      }
      
      protected function ProcessorOnShowKnifeClick(param1:Object) : void
      {
         this.FKnifePop.KnifeData = this.FKnifeOfKillSoulData;
         this.FKnifePop.Visible = true;
      }
      
      protected function KnifePopOnClose(param1:Object) : void
      {
         FScene.mouseChildren = true;
         FScene.mouseEnabled = true;
         this.FKnifePop.Visible = false;
      }
      
      protected function ProcessorPlayMCGiftBox() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FIsPlayGiftBoxMC)
         {
            return;
         }
         _loc2_ = int(COUNT_MC_GIFTBOX);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_GiftBoxs[_loc1_].play();
            this.FMC_GiftBoxs[_loc1_].visible = true;
            this.FMC_GiftBoxBar[CONST_ACTIVITY.RESOURCE_Link_MC_Bar]["MC_Mask"].visible = false;
            _loc1_++;
         }
         this.FIsPlayGiftBoxMC = true;
      }
      
      protected function SetStyleFrame(param1:uint) : void
      {
         FScene["MC_TopBg"].gotoAndStop(param1);
      }
      
      protected function SetIconFrame(param1:uint) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         FScene[CONST_ACTIVITY.RESOURCE_Link_MC_LootIcon].gotoAndStop(param1);
         _loc2_ = COUNT_MC_HEROS;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Heros + _loc3_][CONST_ACTIVITY.RESOURCE_Link_MC_LootIcon].gotoAndStop(param1);
            _loc3_++;
         }
         _loc2_ = COUNT_MC_AWARD;
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FMC_GiftBoxBar[CONST_ACTIVITY.RESOURCE_Link_MC_Bar][CONST_ACTIVITY.RESOURCE_Link_MC_Boxes + _loc3_][CONST_ACTIVITY.RESOURCE_Link_MC_LootIcon].gotoAndStop(param1);
            _loc3_++;
         }
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         super.Reset();
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.FMC_GiftBoxBar.stop();
         _loc2_ = int(this.FRoleModelIDs.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FRoleModelIDs[_loc1_];
            SResourcesCore.TexturesModel.DeleteByIdentifier(_loc3_,true);
            _loc1_++;
         }
         this.FRoleModelIDs.length = 0;
         this.FIsPlayGiftBoxMC = false;
         _loc2_ = int(COUNT_MC_GIFTBOX);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_GiftBoxs[_loc1_].stop();
            this.FMC_GiftBoxs[_loc1_].visible = false;
            this.FTF_GiftBoxCosts[_loc1_].text = "";
            this.FTF_GiftName[_loc1_].text = "";
            _loc1_++;
         }
         _loc2_ = int(COUNT_MC_HEROS);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_HeroList[_loc1_].Reset();
            _loc1_++;
         }
         _loc2_ = int(COUNT_MC_AWARD);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_AwardList[_loc1_].Reset();
            _loc1_++;
         }
         this.FWindowShowHero.Reset();
      }
      
      protected function GetInventoriesByUniqueIndex(param1:uint) : TInventories
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(COUNT_MC_GIFTBOX);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FHDIceHeros.ChipBoxes[_loc2_].Index == param1)
            {
               return this.FHDIceHeros.ChipBoxes[_loc2_].Inventories;
            }
            _loc2_++;
         }
         return null;
      }
      
      protected function PlayMCKnifeInfoEffect() : void
      {
         if(this.FIsPlayKnifeInfoEffect)
         {
            return;
         }
         this.FMC_KnifeInfoEffect.play();
         this.FIsPlayKnifeInfoEffect = true;
         this.FBtn_ShowKnife.Visible = true;
      }
      
      protected function PorcessorGiftOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:TActivityIHChipBox = null;
         _loc3_ = param2.currentTarget.parent.name;
         _loc4_ = int(_loc3_.split("_")[2]);
         _loc5_ = this.FDataIceHeros.GetChipBoxByIndex(_loc4_);
         if(FCharacter.CreditGold >= _loc5_.Cost)
         {
            this.FCurGiftBox = _loc5_;
            FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_59),_loc5_.Cost);
            FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
            FUIWindowConfirmation.OnCancel = WindowInformationOnCancel;
            FUIWindowConfirmation.Visible = true;
         }
         else
         {
            FUIWindowRecharge.Visible = true;
         }
      }
      
      protected function ProcessorBtnOKOnClick(param1:Object, param2:uint) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,param2,0,Vector.<int>([int(this.FDataIceHeros.Runtime.revision)]));
      }
      
      protected function ProcessorShowRankOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnShowRankClick != null)
         {
            this.FOnShowRankClick(this);
         }
      }
      
      protected function ProcessorAwardOnOver(param1:Object, param2:TActivityIHAward) : void
      {
         if(this.FOnAwardsOver != null)
         {
            this.FOnAwardsOver(this,FInventoriesVect[param2.Index - COUNT_MC_HEROS]);
         }
      }
      
      protected function ProcessorAwardOnOut(param1:Object, param2:TActivityIHAward) : void
      {
         if(this.FOnAwardsOut != null)
         {
            this.FOnAwardsOut(this);
         }
      }
      
      protected function ProcessorGiftBoxOnOver(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:TActivityIHChipBox = null;
         var _loc6_:Vector.<String> = null;
         _loc6_ = new Vector.<String>(1);
         _loc3_ = param2.currentTarget.parent.name;
         _loc4_ = int(_loc3_.split("_")[2]);
         _loc5_ = this.FDataIceHeros.GetChipBoxByIndex(_loc4_);
         _loc6_[0] = this.FGiftPromptVect[_loc4_];
         if(this.FOnGiftOver != null)
         {
            this.FOnGiftOver(this,this.GetInventoriesByUniqueIndex(_loc5_.Index),_loc6_);
         }
      }
      
      protected function ProcessorGiftBoxOnOut(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnGiftOut != null)
         {
            this.FOnGiftOut(this);
         }
      }
      
      protected function ProcessorShowHeroOnClick(param1:Object, param2:TActivityIHAward) : void
      {
         FScene.mouseChildren = false;
         FScene.mouseEnabled = false;
         if(param2.HeroType == 1)
         {
            this.FWindowShowHero.HeroID = param2.HeroID;
            this.FWindowShowHero.Show();
         }
         if(param2.HeroType == 2)
         {
            this.FKnifeOfKillSoulData = this.FOnCreateKnifeOfKillSoulData(param2.HeroID);
            this.FKnifePop.KnifeData = this.FKnifeOfKillSoulData;
            this.FKnifePop.Visible = true;
         }
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick(this);
         }
      }
      
      override protected function WindowInformationOnOK(param1:Object) : void
      {
         super.WindowInformationOnOK(param1);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FCurGiftBox.Index);
      }
      
      protected function HeroOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:uint = 0;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         var _loc8_:TRoleModel = null;
         var _loc9_:uint = 0;
         _loc5_ = param2 as uint;
         _loc6_ = SResourcesCore.TexturesModel;
         _loc8_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,_loc5_) as TRoleModel;
         if(_loc8_ == null)
         {
            return;
         }
         _loc9_ = (_loc8_.Model << 8) + CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc9_);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIndex(0);
         }
         else
         {
            _loc6_.LoadSecondary(_loc9_);
         }
         this.SetRoleModelID(_loc9_);
      }
      
      protected function SetRoleModelID(param1:uint) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FRoleModelIDs.indexOf(param1);
         if(_loc2_ < 0)
         {
            this.FRoleModelIDs.push(param1);
         }
      }
      
      protected function BtnCloseLukiaWindowOnMouseClick(param1:Object) : void
      {
         FScene.mouseChildren = true;
         FScene.mouseEnabled = true;
         this.FWindowShowHero.Hide();
      }
      
      protected function BtnShowKnifeInfoClick(param1:Object, param2:MouseEvent) : void
      {
         this.FMC_KnifeInfo.visible = true;
      }
      
      protected function BtnHideKnifeInfoClick(param1:Object, param2:MouseEvent) : void
      {
         FScene.mouseChildren = true;
         FScene.mouseEnabled = true;
         this.FMC_KnifeInfo.visible = false;
      }
      
      public function get OnShowRankClick() : Function
      {
         return this.FOnShowRankClick;
      }
      
      public function set OnShowRankClick(param1:Function) : void
      {
         this.FOnShowRankClick = param1;
      }
      
      public function get OnShowHeroInfo() : Function
      {
         return this.FOnShowHeroInfo;
      }
      
      public function set OnShowHeroInfo(param1:Function) : void
      {
         this.FOnShowHeroInfo = param1;
      }
      
      public function get OnAwardsOver() : Function
      {
         return this.FOnAwardsOver;
      }
      
      public function set OnAwardsOver(param1:Function) : void
      {
         this.FOnAwardsOver = param1;
      }
      
      public function get OnAwardsOut() : Function
      {
         return this.FOnAwardsOut;
      }
      
      public function set OnAwardsOut(param1:Function) : void
      {
         this.FOnAwardsOut = param1;
      }
      
      public function get OnGiftOver() : Function
      {
         return this.FOnGiftOver;
      }
      
      public function set OnGiftOver(param1:Function) : void
      {
         this.FOnGiftOver = param1;
      }
      
      public function get OnGiftOut() : Function
      {
         return this.FOnGiftOut;
      }
      
      public function set OnGiftOut(param1:Function) : void
      {
         this.FOnGiftOut = param1;
      }
      
      public function get SetRankInventories() : Function
      {
         return this.FSetRankInventories;
      }
      
      public function set SetRankInventories(param1:Function) : void
      {
         this.FSetRankInventories = param1;
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FOnCreateKnifeOfKillSoulData = param1;
      }
      
      public function ValuesChange(param1:TActivityIceHeros) : void
      {
         this.UpdateDataBase(param1);
      }
   }
}

