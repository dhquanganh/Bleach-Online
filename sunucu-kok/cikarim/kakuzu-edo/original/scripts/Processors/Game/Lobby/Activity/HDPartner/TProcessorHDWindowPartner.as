package Processors.Game.Lobby.Activity.HDPartner
{
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Achievenment.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityOS.*;
   import Logics.HDPartner.*;
   import Logics.Map.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.Hero.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Rendering.Overlayers.HDGiftBox.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDWindowPartner extends TProcessorHDSingleWindowBase
   {
      
      protected static const BOXNUM:int = 9;
      
      protected static const TASKNUM:int = 3;
      
      protected static const ROSENUM:int = 3;
      
      protected static const HERONUM:int = 2;
      
      protected static const StarEffectNum:int = 2;
      
      protected static const ScheduleFormat:String = "%0 / %1";
      
      protected var FGiftBagButtons:Vector.<TUIButton>;
      
      protected var FGiftBagPrices:Vector.<TextField>;
      
      protected var FTaskDescs:Vector.<TextField>;
      
      protected var FTaskSchedules:Vector.<TextField>;
      
      protected var FTaskReciveFlags:Vector.<Sprite>;
      
      protected var FTaskReciveBtns:Vector.<TUIButton>;
      
      protected var FTaskScheduleBar:Vector.<Sprite>;
      
      protected var FRoseBuyBtns:Vector.<TUIButton>;
      
      protected var FRoseLockFlag:Vector.<Sprite>;
      
      protected var FRosePrices:Vector.<TextField>;
      
      protected var FRoseNum:TextField;
      
      protected var FHeroMoudles:Vector.<TSceneSpriteMoudle>;
      
      protected var FQueryModel:TMoudleInfor;
      
      protected var FHeroNames:Vector.<TextField>;
      
      protected var FHeroExchangeFlag:Vector.<Sprite>;
      
      protected var FHeroRoseNeed:Vector.<TextField>;
      
      protected var FHeroBtnBuy:Vector.<TUIButton>;
      
      protected var FWindowShowHero:TProcessorWindowHeroDescription;
      
      protected var FHeroMountPoint:Vector.<Sprite>;
      
      protected var FHeroFightViewBtn:Vector.<TUIButton>;
      
      protected var FStarEffects:Vector.<MovieClip>;
      
      protected var FTitleMountPoint:Bitmap;
      
      protected var FTitleAnimationSequence:TAnimationSequence;
      
      protected var FTimeStore:int;
      
      protected var FTitleGetBtn:TUIButton;
      
      protected var FTitleGetFlag:Sprite;
      
      protected var FTitle:TTitle;
      
      protected var FDesc:Sprite;
      
      protected var FActivityPartnerData:TActivityPartnerData;
      
      public function TProcessorHDWindowPartner(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ActivitySinglePartner;
         FActivityID = CONST_ACTIVITY_MODE.Activity_BigTurnTable;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         this.UpdateHeroMoudle();
         this.UpdateTitle();
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         super.InitWindow(param1);
         this.UIDispatchBuyBox();
         this.UIDispatchTasks();
         this.UIDispatchRose();
         this.UIDispatchHero();
         this.UIDispatchTitle();
      }
      
      protected function UIDispatchBuyBox() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUIButton = null;
         this.FGiftBagButtons = new Vector.<TUIButton>();
         this.FGiftBagPrices = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < BOXNUM)
         {
            _loc2_ = new TUIButton();
            _loc2_.Substrate = FScene["Gift" + _loc1_]["Btn"];
            _loc2_.OnClick = this.GiftBagOnClick;
            _loc2_.OnMove = this.GiftBagOnMove;
            _loc2_.OnOut = this.GiftBagOnOut;
            this.FGiftBagButtons.push(_loc2_);
            this.FGiftBagPrices.push(FScene["Gift" + _loc1_]["TF_Price"]);
            _loc1_++;
         }
      }
      
      protected function UIDispatchTasks() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUIButton = null;
         var _loc3_:Sprite = null;
         this.FTaskDescs = new Vector.<TextField>();
         this.FTaskSchedules = new Vector.<TextField>();
         this.FTaskReciveFlags = new Vector.<Sprite>();
         this.FTaskReciveBtns = new Vector.<TUIButton>();
         this.FTaskScheduleBar = new Vector.<Sprite>();
         _loc1_ = 0;
         while(_loc1_ < TASKNUM)
         {
            _loc3_ = FScene["Task" + _loc1_];
            this.FTaskDescs.push(_loc3_["Desc"]);
            this.FTaskSchedules.push(_loc3_["TFSchedule"]);
            this.FTaskReciveFlags.push(_loc3_["ReciveFlag"]);
            this.FTaskScheduleBar.push(_loc3_["ScheduleBar"]["Mask"]);
            _loc2_ = new TUIButton();
            _loc2_.Substrate = _loc3_["BtnRecive"];
            _loc2_.OnClick = this.BtnReciveOnClick;
            _loc2_.OnMove = this.BtnReciveOnMove;
            _loc2_.OnOut = this.BtnReciveOnOut;
            this.FTaskReciveBtns.push(_loc2_);
            _loc1_++;
         }
      }
      
      protected function UIDispatchRose() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUIButton = null;
         var _loc3_:Sprite = null;
         this.FRoseBuyBtns = new Vector.<TUIButton>();
         this.FRoseLockFlag = new Vector.<Sprite>();
         this.FRosePrices = new Vector.<TextField>();
         _loc1_ = 0;
         while(_loc1_ < ROSENUM)
         {
            _loc3_ = FScene["Rose" + _loc1_];
            _loc2_ = new TUIButton();
            _loc2_.Substrate = _loc3_["Rose"];
            _loc2_.OnClick = this.BtnRoseOnClick;
            _loc2_.OnMove = this.BtnRoseOnMove;
            _loc2_.OnOut = this.BtnRoseOnOut;
            this.FRoseBuyBtns.push(_loc2_);
            this.FRoseLockFlag.push(_loc3_["Lock"]);
            this.FRosePrices.push(_loc3_["TF_Price"]);
            _loc1_++;
         }
         this.FRoseNum = FScene["TF_RoseNum"];
      }
      
      protected function UIDispatchHero() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         var _loc4_:TSceneSpriteMoudle = null;
         var _loc5_:TUIButton = null;
         this.FHeroMoudles = new Vector.<TSceneSpriteMoudle>();
         this.FQueryModel = new TMoudleInfor();
         this.FHeroNames = new Vector.<TextField>();
         this.FHeroExchangeFlag = new Vector.<Sprite>();
         this.FHeroRoseNeed = new Vector.<TextField>();
         this.FHeroBtnBuy = new Vector.<TUIButton>();
         this.FHeroMountPoint = new Vector.<Sprite>();
         this.FHeroFightViewBtn = new Vector.<TUIButton>();
         _loc1_ = 0;
         while(_loc1_ < HERONUM)
         {
            _loc2_ = FScene["MC_Hero" + _loc1_];
            _loc3_ = _loc2_["MC_MountPoint"];
            _loc3_.buttonMode = true;
            _loc3_.addEventListener(MouseEvent.CLICK,this.HeroOnClick);
            _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.HeroOnOver);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.HeroOnOut);
            this.FHeroMountPoint.push(_loc3_);
            _loc4_ = new TSceneSpriteMoudle();
            _loc3_.addChild(_loc4_);
            this.FHeroMoudles.push(_loc4_);
            this.FHeroNames.push(_loc2_["TF_HeroName"]);
            this.FHeroExchangeFlag.push(_loc2_["MC_ExchangeFlag"]);
            this.FHeroRoseNeed.push(_loc2_["TF_RoseNum"]);
            _loc5_ = new TUIButton();
            _loc5_.Substrate = _loc2_["Btn_OK"];
            _loc5_.OnClick = this.BtnExchangeOnClick;
            this.FHeroBtnBuy.push(_loc5_);
            _loc5_ = new TUIButton();
            _loc5_.Substrate = FScene["Btn_FightReport" + _loc1_];
            _loc5_.OnClick = this.BtnFightReportOnClick;
            _loc5_.Visible = false;
            this.FHeroFightViewBtn.push(_loc5_);
            _loc1_++;
         }
         this.FHeroFightViewBtn[0].Visible = true;
         this.FStarEffects = new Vector.<MovieClip>();
         _loc1_ = 0;
         while(_loc1_ < StarEffectNum)
         {
            this.FStarEffects[_loc1_] = FScene["StarEffect" + _loc1_];
            _loc1_++;
         }
         this.FWindowShowHero = new TProcessorWindowHeroDescription(FParent);
         this.FWindowShowHero.Perform_UIDispatch();
         this.FWindowShowHero.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowShowHero.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowShowHero.OnClose = this.BtnCloseShowHeroOnMouseClick;
      }
      
      protected function UIDispatchTitle() : void
      {
         var _loc1_:Sprite = null;
         this.FTitleMountPoint = new Bitmap();
         _loc1_ = FScene["MountPoint"];
         _loc1_.addChild(this.FTitleMountPoint);
         _loc1_.visible = false;
         _loc1_.addEventListener(MouseEvent.MOUSE_MOVE,this.TitleOnMove);
         _loc1_.addEventListener(MouseEvent.MOUSE_OUT,this.TitleOnOut);
         this.FTitleGetBtn = new TUIButton();
         this.FTitleGetBtn.Substrate = FScene["Btn_GetTitle"];
         this.FTitleGetBtn.OnClick = this.BtnTitleOnClick;
         this.FTitleGetFlag = FScene["MC_ExchangeFlag"];
         this.FDesc = FScene["MC_HDDesc"];
         this.FDesc.addEventListener(MouseEvent.MOUSE_MOVE,this.DescOnClick);
         this.FDesc.addEventListener(MouseEvent.MOUSE_OUT,this.DescOnOut);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FActivityPartnerData = param1 as TActivityPartnerData;
         this.FTitle = TUtilityLobby.GetTitleByID(SLogicsCore.Character.AchievementTitles,this.FActivityPartnerData.TitleID);
         FHint.Caption = FHDActivityConfig.Desc;
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         this.RenderGiftBag();
         this.RenderTasks();
         this.RenderRose();
         this.RenderHero();
         this.RenderTitle();
         this.UpdateHeroState();
         this.UpdateRoseNum();
         this.StartStarEffect();
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      protected function RenderGiftBag() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FActivityPartnerData.BoxIndexs.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FGiftBagPrices[_loc1_].text = this.FActivityPartnerData.BoxCosts[_loc1_].toString();
            _loc1_++;
         }
      }
      
      protected function RenderTasks() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         _loc2_ = int(this.FActivityPartnerData.TaskIndexs.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTaskDescs[_loc1_].text = this.FActivityPartnerData.TaskPrompts[_loc1_];
            this.FTaskReciveFlags[_loc1_].visible = this.FActivityPartnerData.TaskReciveRecored[_loc1_];
            this.FTaskReciveBtns[_loc1_].Visible = !this.FTaskReciveFlags[_loc1_].visible;
            this.FTaskReciveBtns[_loc1_].Enabled = this.FActivityPartnerData.TaskSchedule[_loc1_] >= this.FActivityPartnerData.TaskTotalSchedules[_loc1_];
            _loc3_ = this.FActivityPartnerData.TaskSchedule[_loc1_] / this.FActivityPartnerData.TaskTotalSchedules[_loc1_];
            _loc3_ = _loc3_ > 1 ? 1 : _loc3_;
            this.FTaskScheduleBar[_loc1_].scaleX = _loc3_;
            this.FTaskSchedules[_loc1_].text = TUtilityString.Format(ScheduleFormat,this.FActivityPartnerData.TaskSchedule[_loc1_],this.FActivityPartnerData.TaskTotalSchedules[_loc1_]);
            _loc1_++;
         }
      }
      
      protected function RenderRose() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < ROSENUM)
         {
            this.FRoseBuyBtns[_loc1_].Enabled = this.FActivityPartnerData.RoseOpenNum > _loc1_;
            this.FRoseLockFlag[_loc1_].visible = !this.FRoseBuyBtns[_loc1_].Enabled;
            this.FRosePrices[_loc1_].text = this.FActivityPartnerData.BuyRoseCosts[_loc1_].toString();
            _loc1_++;
         }
      }
      
      protected function RenderHero() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TBaseHero = null;
         _loc1_ = 0;
         while(_loc1_ < HERONUM)
         {
            TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,this.FActivityPartnerData.ExchangeHeroHeroIDs[_loc1_],this.FQueryModel);
            this.FHeroMoudles[_loc1_].ChangeRoleMoudle(this.FQueryModel.TextureID,1);
            _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BaseHero,this.FActivityPartnerData.ExchangeHeroHeroIDs[_loc1_]) as TBaseHero;
            this.FHeroNames[_loc1_].text = _loc2_.Name;
            this.FHeroRoseNeed[_loc1_].text = this.FActivityPartnerData.ExchangeHeroNeedRoses[_loc1_].toString();
            _loc1_++;
         }
      }
      
      protected function RenderTitle() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         SResourcesCore.TexturesAchievementTitle.LoadAutoSecondary(this.FActivityPartnerData.TitleID,this.TitlePicArrive);
         _loc1_ = true;
         _loc3_ = int(this.FActivityPartnerData.ExchangeHeroRecore.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc1_ &&= this.FActivityPartnerData.ExchangeHeroRecore[_loc2_];
            _loc2_++;
         }
         this.FTitleGetBtn.Visible = false;
         this.FTitleGetBtn.Enabled = _loc1_;
         this.FTitleGetFlag.visible = false;
      }
      
      protected function TitlePicArrive(param1:Object, param2:TTexture, param3:int) : void
      {
         this.FTitleAnimationSequence = param2.GetAnimationSequenceByIndex(0);
      }
      
      protected function UpdateHeroState() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < HERONUM)
         {
            this.FHeroBtnBuy[_loc1_].Visible = !this.FActivityPartnerData.ExchangeHeroRecore[_loc1_];
            this.FHeroBtnBuy[_loc1_].Enabled = this.FActivityPartnerData.RoseCurrentNum >= this.FActivityPartnerData.ExchangeHeroNeedRoses[_loc1_];
            this.FHeroExchangeFlag[_loc1_].visible = this.FActivityPartnerData.ExchangeHeroRecore[_loc1_];
            _loc1_++;
         }
      }
      
      protected function UpdateRoseNum() : void
      {
         this.FRoseNum.text = this.FActivityPartnerData.RoseCurrentNum.toString();
      }
      
      protected function UpdateHeroMoudle() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < HERONUM)
         {
            this.FHeroMoudles[_loc1_].UpdateView();
            _loc1_++;
         }
      }
      
      protected function UpdateTitle() : void
      {
         if(this.FTitleAnimationSequence != null)
         {
            this.FTitleMountPoint.bitmapData = this.FTitleAnimationSequence.GetAnimationFrameByTick(this.FTimeStore).Surface;
            this.FTimeStore += CONST_COMMON.SIZE_FrameRatePerSecond;
         }
      }
      
      protected function StartStarEffect() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < StarEffectNum)
         {
            this.FStarEffects[_loc1_].play();
            _loc1_++;
         }
      }
      
      protected function StopStarEffect() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < StarEffectNum)
         {
            this.FStarEffects[_loc1_].stop();
            _loc1_++;
         }
      }
      
      protected function BuyGoodsReq(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,SUtilityOverLayer.UIWindowConfirmation.Tag);
      }
      
      protected function GiftBagOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FGiftBagButtons.indexOf(param1 as TUIButton);
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SuperMarket_STRING_02),this.FActivityPartnerData.BoxCosts[_loc3_]);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.BuyGoodsReq;
         SUtilityOverLayer.UIWindowConfirmation.Tag = this.FActivityPartnerData.BoxIndexs[_loc3_];
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function GiftBagOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FGiftBagButtons.indexOf(param1 as TUIButton);
         ProcessorOnGiftBoxMove(this,this.FActivityPartnerData.BoxInventories[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function GiftBagOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function BtnReciveOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FTaskReciveBtns.indexOf(param1 as TUIButton);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FActivityPartnerData.TaskIndexs[_loc3_]);
      }
      
      protected function BtnReciveOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FTaskReciveBtns.indexOf(param1 as TUIButton);
         ProcessorOnGiftBoxMove(this,this.FActivityPartnerData.TaskInventories[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function BtnReciveOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function BtnRoseOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FRoseBuyBtns.indexOf(param1 as TUIButton);
         SUtilityOverLayer.UIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.SuperMarket_STRING_02),this.FActivityPartnerData.BuyRoseCosts[_loc3_]);
         SUtilityOverLayer.UIWindowConfirmation.OnOK = this.BuyGoodsReq;
         SUtilityOverLayer.UIWindowConfirmation.Tag = this.FActivityPartnerData.BuyRoseIndexs[_loc3_];
         SUtilityOverLayer.UIWindowConfirmation.Visible = true;
      }
      
      protected function BtnRoseOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FRoseBuyBtns.indexOf(param1 as TUIButton);
         ProcessorOnGiftBoxMove(this,this.FActivityPartnerData.BuyRoseArticls[_loc3_],TOverlayerGiftBox.TYPE_ALL);
      }
      
      protected function BtnRoseOnOut(param1:Object, param2:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      protected function BtnExchangeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FHeroBtnBuy.indexOf(param1 as TUIButton);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FActivityPartnerData.ExchangeHeroIndexs[_loc3_]);
      }
      
      protected function BtnFightReportOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FHeroFightViewBtn.indexOf(param1 as TUIButton);
         SExternalCore.NavigateToLinkUrl(this.FActivityPartnerData.ExchangeHeroFightReportAddr[_loc3_]);
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(FOnClose != null)
         {
            FOnClose(this);
         }
         this.Reset();
      }
      
      protected function BtnCloseShowHeroOnMouseClick(param1:Object) : void
      {
         FScene.mouseEnabled = true;
         FScene.mouseChildren = true;
         this.FWindowShowHero.Hide();
      }
      
      protected function HeroOnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         FScene.mouseEnabled = false;
         FScene.mouseChildren = false;
         _loc2_ = this.FHeroMountPoint.indexOf(param1.currentTarget);
         this.FWindowShowHero.HeroID = this.FActivityPartnerData.ExchangeHeroHeroIDs[_loc2_];
         this.FWindowShowHero.Show();
      }
      
      protected function HeroOnOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FHeroMountPoint.indexOf(param1.currentTarget);
         this.FHeroMountPoint[_loc2_].filters = [TUtilityFilter.highLightFilters];
      }
      
      protected function HeroOnOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FHeroMountPoint.indexOf(param1.currentTarget);
         this.FHeroMountPoint[_loc2_].filters = null;
      }
      
      protected function BtnTitleOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FActivityPartnerData.TitleIndex);
      }
      
      protected function TitleOnMove(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FTitle);
      }
      
      protected function TitleOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FTitle);
      }
      
      protected function DescOnClick(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,FHint);
      }
      
      protected function DescOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,FHint);
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         super.Reset();
         _loc1_ = 0;
         while(_loc1_ < HERONUM)
         {
            this.FHeroMoudles[_loc1_].ReleaseModuleResource();
            _loc1_++;
         }
         this.StopStarEffect();
      }
   }
}

