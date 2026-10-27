package Processors.Game.Lobby.Activity.HDChineseYear.Windows
{
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityChineseYear.ActivityLukia.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.Map.*;
   import Logics.Streamization.HDActivityChineseYear.*;
   import Processors.Game.Common.Effects.Display.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.Hero.*;
   import Processors.Game.Lobby.Common.Map.SceneSprite.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorHDWindowLukia extends THDOSTabWindowBase
   {
      
      protected static const SuperBagNum:int = 2;
      
      protected static const NiceBagNum:int = 6;
      
      protected static const ExchangeBagNum:int = 3;
      
      protected static const Filters:Array = [TUtilityFilter.highLightFilters];
      
      protected var FLukiaChipNum:TextField;
      
      protected var FLukiaBtnExchange:TUIButton;
      
      protected var FLukiaExchangeChipNum:TextField;
      
      protected var FLukiaExchangeFlag:Sprite;
      
      protected var FLukiaMountPointPic:Sprite;
      
      protected var FLukiaModel:TSceneSpriteMoudle;
      
      protected var FMoudleInfor:TMoudleInfor;
      
      protected var FWindowShowHero:TProcessorWindowHeroDescription;
      
      protected var FWindowShowHeroCloseBtn:TUIButton;
      
      protected var FSuperBagDesName:Vector.<TextField>;
      
      protected var FSuperBagDesPrice:Vector.<TextField>;
      
      protected var FSuperBagPrice:Vector.<TextField>;
      
      protected var FSuperBagBtnBuy:Vector.<TUIButton>;
      
      protected var FSuperBagPic:Vector.<Sprite>;
      
      protected var FIfNiceBagCanFreeBuy:Boolean;
      
      protected var FEffectBaseGlow:TEffectBaseGlow;
      
      protected var FNiceBagMC:Vector.<MovieClip>;
      
      protected var FNiceBagAlreadyBuyFlag:Vector.<MovieClip>;
      
      protected var FExchangeBagPrice:Vector.<TextField>;
      
      protected var FExchangeBagBtnBuy:Vector.<TUIButton>;
      
      protected var FExchangeBagPic:Vector.<Sprite>;
      
      protected var FActivityLukiaTotalInfor:TActivityLukiaTotalInfor;
      
      protected var FHDChineseYearLukia:THDChineseYearLukia;
      
      protected var FHint:THint;
      
      protected var FWaitRequestIndex:int;
      
      protected var FWaitRequestMode:int;
      
      protected var FUnstreamizerActivityChineseYear:TUnstreamizerActivityChineseYear;
      
      public function TProcessorHDWindowLukia(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_ChineseYearLukia;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(Visible)
         {
            this.UpdateLukiaModel();
            if(this.FIfNiceBagCanFreeBuy)
            {
               this.FEffectBaseGlow.Run();
            }
         }
      }
      
      override public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         super.ChangeActivityStatus(param1,param2);
         this.FActivityLukiaTotalInfor.FlushActivityData(param2.Index,param2.Status);
         this.ProcessorCheckEffects();
         this.UpdateUI();
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TActivityAtoms = null;
         super.UpdateSCData(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.FUnstreamizerActivityChineseYear.UnstreamizeUpdateChineseYearLukia(FActivityInitRetData,this.FActivityLukiaTotalInfor,FHDActivityConfig);
         if(this.FActivityLukiaTotalInfor.ActivitySuperBag.BagInventories == null)
         {
            this.FActivityLukiaTotalInfor.ActivitySuperBag.BagInventories = ProcessorGetInventoriesVectByAwardID(this.FActivityLukiaTotalInfor.ActivitySuperBag.BagsID);
            this.FActivityLukiaTotalInfor.ActivityNiceBag.BagInventories = ProcessorGetInventoriesVectByAwardID(this.FActivityLukiaTotalInfor.ActivityNiceBag.BagsID);
            this.FActivityLukiaTotalInfor.ActivityExchangeBag.BagInventories = ProcessorGetInventoriesVectByAwardID(this.FActivityLukiaTotalInfor.ActivityExchangeBag.BagsID);
         }
         this.ProcessorCheckEffects();
         this.UpdateUI();
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
      }
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
         this.RenderingLukia();
         this.RenderingSuperBag();
         this.RenderingNiceBag();
         this.RenderingExchangeBag();
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         if(FActivityAtoms.TimeShowType == CONST_ACTIVITY_MODE.TYPE_TimeShowNormal)
         {
            ProcessorFormatActivityTime(FActivityAtoms.StartTime,FActivityAtoms.EndTime);
         }
         else if(FActivityAtoms.TimeShowType == CONST_ACTIVITY_MODE.TYPE_TimeShowFromNowON)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         }
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function InitWindow() : void
      {
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance("MC_ChineseLukia") as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         this.FActivityLukiaTotalInfor = new TActivityLukiaTotalInfor();
         this.FHint = new THint();
         this.InitLukiaResource();
         this.InitSuperBagResource();
         this.InitNiceBagResource();
         this.InitExchangeBagResource();
      }
      
      protected function InitLukiaResource() : void
      {
         this.FUnstreamizerActivityChineseYear = new TUnstreamizerActivityChineseYear();
         this.FLukiaChipNum = FMC_Scene["TF_SickleChipNum"];
         this.FLukiaExchangeChipNum = FMC_Scene["ExchangeCondition"]["TF_ChipNum"];
         this.FLukiaExchangeFlag = FMC_Scene["MC_AlreadyExchangeFlag"];
         this.FLukiaMountPointPic = FMC_Scene["MountPoint"];
         this.FLukiaBtnExchange = this.CreateButton(FMC_Scene["BtnLukiaExchange"],this.ExchangeLukiaOnClick);
         this.FLukiaModel = new TSceneSpriteMoudle();
         this.FLukiaMountPointPic.addChild(this.FLukiaModel);
         this.FLukiaMountPointPic.addEventListener(MouseEvent.CLICK,this.LukiaPicOnMouseClick);
         this.FLukiaMountPointPic.addEventListener(MouseEvent.MOUSE_OVER,this.LukiaPicOnMouseOver);
         this.FLukiaMountPointPic.addEventListener(MouseEvent.MOUSE_OUT,this.LukiaPicOnMouseOut);
         this.FLukiaMountPointPic.buttonMode = true;
         this.FMoudleInfor = new TMoudleInfor();
         this.FWindowShowHero = new TProcessorWindowHeroDescription(FParent);
         this.FWindowShowHero.Perform_UIDispatch();
         this.FWindowShowHero.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FWindowShowHero.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FWindowShowHero.OnClose = this.BtnCloseLukiaWindowOnMouseClick;
      }
      
      protected function InitSuperBagResource() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         this.FSuperBagDesName = new Vector.<TextField>();
         this.FSuperBagDesPrice = new Vector.<TextField>();
         this.FSuperBagPrice = new Vector.<TextField>();
         this.FSuperBagBtnBuy = new Vector.<TUIButton>();
         this.FSuperBagPic = new Vector.<Sprite>();
         _loc1_ = 0;
         while(_loc1_ < SuperBagNum)
         {
            _loc2_ = FMC_Scene["SuperBag" + _loc1_];
            this.FSuperBagDesName.push(_loc2_["TF_DescriptionTitle"]);
            this.FSuperBagDesPrice.push(_loc2_["TF_DescriptionPrice"]);
            this.FSuperBagPrice.push(_loc2_["TF_Price"]);
            this.FSuperBagBtnBuy.push(this.CreateButton(_loc2_["Btn_Buy"],this.SuperBagBtnOnClick));
            _loc2_ = FMC_Scene["SuperBagPic" + _loc1_];
            _loc2_.addEventListener(MouseEvent.MOUSE_MOVE,this.SuperBagBtnOnMouseOver);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.SuperBagBtnOnMouseOut);
            this.FSuperBagPic.push(_loc2_);
            _loc1_++;
         }
      }
      
      protected function InitNiceBagResource() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         this.FNiceBagMC = new Vector.<MovieClip>();
         this.FNiceBagAlreadyBuyFlag = new Vector.<MovieClip>();
         _loc2_ = FMC_Scene["NiceBags"];
         _loc1_ = 0;
         while(_loc1_ < NiceBagNum)
         {
            _loc3_ = _loc2_["Bag" + _loc1_];
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.NiceBagBtnOnMouseMove);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.NiceBagBtnOnMouseOut);
            _loc3_.addEventListener(MouseEvent.CLICK,this.NiceBagBtnOnClick);
            _loc3_.buttonMode = true;
            this.FNiceBagMC.push(_loc3_);
            this.FNiceBagAlreadyBuyFlag.push(_loc3_["GetFlag"]);
            _loc1_++;
         }
         this.FEffectBaseGlow = new TEffectBaseGlow();
         this.FEffectBaseGlow.SetParameters(this.FNiceBagMC[0],16776960,0.7);
      }
      
      protected function InitExchangeBagResource() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         this.FExchangeBagPrice = new Vector.<TextField>();
         this.FExchangeBagBtnBuy = new Vector.<TUIButton>();
         this.FExchangeBagPic = new Vector.<Sprite>();
         _loc1_ = 0;
         while(_loc1_ < ExchangeBagNum)
         {
            _loc2_ = FMC_Scene["ExchangeBag" + _loc1_];
            _loc3_ = _loc2_["ExchangeBagPic"];
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.ExchangeBagBtnOnMouseOver);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.ExchangeBagBtnOnMouseOut);
            this.FExchangeBagPic.push(_loc3_);
            this.FExchangeBagPrice.push(_loc2_["TF_Price"]);
            this.FExchangeBagBtnBuy.push(this.CreateButton(_loc2_["Btn_Exchange"],this.ExchangeBagBtnOnClick));
            _loc1_++;
         }
      }
      
      protected function CreateButton(param1:MovieClip, param2:Function) : TUIButton
      {
         var _loc3_:TUIButton = null;
         _loc3_ = new TUIButton();
         _loc3_.Substrate = param1;
         _loc3_.OnClick = param2;
         return _loc3_;
      }
      
      protected function RenderingLukia() : void
      {
         TUtilityTexture.QueryTwoDirectionShowCase(CONST_MAP.DIRECTION_RIGHT,this.FActivityLukiaTotalInfor.ActivityLukia.LukiaID,this.FMoudleInfor);
         this.FLukiaModel.ChangeRoleMoudle(this.FMoudleInfor.TextureID,this.FMoudleInfor.Scalx);
         this.FLukiaChipNum.text = this.FActivityLukiaTotalInfor.ActivityLukiaChip.ChipNum.toString();
         this.FLukiaExchangeChipNum.text = this.FActivityLukiaTotalInfor.ActivityLukia.EnlistNeed.toString();
         this.FLukiaExchangeFlag.visible = this.FActivityLukiaTotalInfor.ActivityLukia.IfEnlist;
         this.FLukiaBtnExchange.Enabled = !this.FActivityLukiaTotalInfor.ActivityLukia.IfEnlist && this.FActivityLukiaTotalInfor.ActivityLukia.EnlistNeed <= this.FActivityLukiaTotalInfor.ActivityLukiaChip.ChipNum;
         this.FWindowShowHero.HeroID = this.FActivityLukiaTotalInfor.ActivityLukia.LukiaID;
      }
      
      protected function UpdateLukiaModel() : void
      {
         this.FLukiaModel.UpdateView();
      }
      
      protected function RenderingSuperBag() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = false;
         _loc2_ = this.FActivityLukiaTotalInfor.ActivitySuperBag.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FSuperBagDesName[_loc1_].text = this.FActivityLukiaTotalInfor.ActivitySuperBag.DescrptionTitle[_loc1_];
            _loc3_ = this.FActivityLukiaTotalInfor.ActivitySuperBag.IfBuyed[_loc1_];
            if(!_loc3_)
            {
               this.FSuperBagDesPrice[_loc1_].text = this.FActivityLukiaTotalInfor.ActivitySuperBag.DescrptionTwo[_loc1_][0];
               this.FSuperBagPrice[_loc1_].text = this.FActivityLukiaTotalInfor.ActivitySuperBag.BagPrice[_loc1_][0].toString();
            }
            else
            {
               this.FSuperBagDesPrice[_loc1_].text = this.FActivityLukiaTotalInfor.ActivitySuperBag.DescrptionTwo[_loc1_][1];
               this.FSuperBagPrice[_loc1_].text = this.FActivityLukiaTotalInfor.ActivitySuperBag.BagPrice[_loc1_][1].toString();
            }
            _loc1_++;
         }
      }
      
      protected function RenderingNiceBag() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = this.FActivityLukiaTotalInfor.ActivityNiceBag.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FNiceBagAlreadyBuyFlag[_loc1_].visible = this.FActivityLukiaTotalInfor.ActivityNiceBag.BagsIfBuyed[_loc1_];
            _loc1_++;
         }
         this.FIfNiceBagCanFreeBuy = !this.FActivityLukiaTotalInfor.ActivityNiceBag.BagsIfBuyed[0];
         if(!this.FIfNiceBagCanFreeBuy)
         {
            this.FEffectBaseGlow.Stop();
         }
      }
      
      protected function RenderingExchangeBag() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = this.FActivityLukiaTotalInfor.ActivityExchangeBag.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FExchangeBagPrice[_loc1_].text = this.FActivityLukiaTotalInfor.ActivityExchangeBag.ChipNeed[_loc1_].toString();
            this.FExchangeBagBtnBuy[_loc1_].Enabled = this.FActivityLukiaTotalInfor.ActivityExchangeBag.ChipNeed[_loc1_] <= this.FActivityLukiaTotalInfor.ActivityLukiaChip.ChipNum;
            _loc1_++;
         }
      }
      
      protected function ProcessorCheckEffects() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!this.FActivityLukiaTotalInfor.ActivityLukia.IfEnlist && this.FActivityLukiaTotalInfor.ActivityLukia.EnlistNeed <= this.FActivityLukiaTotalInfor.ActivityLukiaChip.ChipNum)
         {
            this.NotifyPlayEffect(true);
            return;
         }
         if(!this.FActivityLukiaTotalInfor.ActivityNiceBag.BagsIfBuyed[0])
         {
            this.NotifyPlayEffect(true);
            return;
         }
         this.NotifyPlayEffect(false);
      }
      
      protected function NotifyPlayEffect(param1:Boolean) : void
      {
         if(param1)
         {
            FActivityAtoms.Status = Activity_CanReceive;
         }
         else
         {
            FActivityAtoms.Status = Activity_CanNotReceive;
         }
         if(FUpdateStatus != null)
         {
            FUpdateStatus(FActivityAtoms.Identifier,FActivityAtoms.Status);
         }
      }
      
      protected function RequestBuyBag(param1:Object) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FWaitRequestIndex,this.FWaitRequestMode);
      }
      
      protected function ExchangeLukiaOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FActivityLukiaTotalInfor.ActivityLukia.Index,CONST_ACTIVITY_MODE.TYPE_Operate_Buy);
      }
      
      protected function LukiaPicOnMouseClick(param1:MouseEvent) : void
      {
         FMC_Scene.mouseChildren = false;
         FMC_Scene.mouseEnabled = false;
         this.FWindowShowHero.Show();
      }
      
      protected function LukiaPicOnMouseOver(param1:MouseEvent) : void
      {
         this.FLukiaMountPointPic.filters = Filters;
      }
      
      protected function LukiaPicOnMouseOut(param1:MouseEvent) : void
      {
         this.FLukiaMountPointPic.filters = null;
      }
      
      protected function BtnCloseLukiaWindowOnMouseClick(param1:Object) : void
      {
         FMC_Scene.mouseChildren = true;
         FMC_Scene.mouseEnabled = true;
         this.FWindowShowHero.Hide();
      }
      
      protected function SuperBagBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc3_ = this.FSuperBagBtnBuy.indexOf(param1 as TUIButton);
         _loc5_ = this.FActivityLukiaTotalInfor.ActivitySuperBag.IfBuyed[_loc3_] ? 1 : 0;
         _loc4_ = this.FActivityLukiaTotalInfor.ActivitySuperBag.BagPrice[_loc3_][_loc5_];
         if(_loc4_ > SLogicsCore.Character.CreditGold)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_58));
            return;
         }
         this.FWaitRequestIndex = this.FActivityLukiaTotalInfor.ActivitySuperBag.Index[_loc3_];
         this.FWaitRequestMode = CONST_ACTIVITY_MODE.TYPE_Operate_Buy;
         FTabUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_59),_loc4_);
         FTabUIWindowConfirmation.OnOK = this.RequestBuyBag;
         FTabUIWindowConfirmation.Visible = true;
      }
      
      protected function SuperBagBtnOnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FSuperBagPic.indexOf(param1.currentTarget);
         this.FHint.Caption = this.FActivityLukiaTotalInfor.ActivitySuperBag.RewardInfor[_loc2_];
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function SuperBagBtnOnMouseOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function NiceBagBtnOnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = this.FNiceBagMC.indexOf(param1.currentTarget);
         if(_loc2_ != 0 && !this.FActivityLukiaTotalInfor.ActivityNiceBag.BagsIfBuyed[_loc2_ - 1])
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_60));
            return;
         }
         if(this.FActivityLukiaTotalInfor.ActivityNiceBag.BagsIfBuyed[_loc2_])
         {
            if(this.FActivityLukiaTotalInfor.ActivityNiceBag.Prices[_loc2_] == 0)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_61));
            }
            else
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_62));
            }
            return;
         }
         _loc3_ = this.FActivityLukiaTotalInfor.ActivityNiceBag.Prices[_loc2_];
         if(_loc3_ == 0)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FActivityLukiaTotalInfor.ActivityNiceBag.Index[0],CONST_ACTIVITY_MODE.TYPE_Operate_Buy);
            return;
         }
         if(_loc3_ > SLogicsCore.Character.CreditGold)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_58));
            return;
         }
         this.FWaitRequestIndex = this.FActivityLukiaTotalInfor.ActivityNiceBag.Index[_loc2_];
         this.FWaitRequestMode = CONST_ACTIVITY_MODE.TYPE_Operate_Buy;
         FTabUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_59),_loc3_);
         FTabUIWindowConfirmation.OnOK = this.RequestBuyBag;
         FTabUIWindowConfirmation.Visible = true;
      }
      
      protected function NiceBagBtnOnMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FNiceBagMC.indexOf(param1.currentTarget);
         this.FNiceBagMC[_loc2_].gotoAndStop(2);
         this.FHint.Caption = this.FActivityLukiaTotalInfor.ActivityNiceBag.RewardInfor[_loc2_];
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function NiceBagBtnOnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FNiceBagMC.indexOf(param1.currentTarget);
         this.FNiceBagMC[_loc2_].gotoAndStop(1);
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function ExchangeBagBtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.FExchangeBagBtnBuy.indexOf(param1 as TUIButton);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FActivityLukiaTotalInfor.ActivityExchangeBag.Index[_loc3_],CONST_ACTIVITY_MODE.TYPE_Operate_Buy);
      }
      
      protected function ExchangeBagBtnOnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.FExchangeBagPic.indexOf(param1.currentTarget);
         ProcessorOnGiftBoxMove(this,this.FActivityLukiaTotalInfor.ActivityExchangeBag.BagInventories[_loc2_]);
      }
      
      protected function ExchangeBagBtnOnMouseOut(param1:MouseEvent) : void
      {
         ProcessorOnGiftBoxOut(this);
      }
      
      override public function Show(param1:TActivityAtoms) : void
      {
         super.Show(param1);
         Perform_CS_ActivityInitReq(param1.Identifier);
      }
      
      override protected function Reset() : void
      {
         super.Reset();
         if(FIsResourcesLoadCompleted)
         {
            this.FWindowShowHero.Reset();
            this.FLukiaModel.Release();
            this.FEffectBaseGlow.Stop();
            this.FIfNiceBagCanFreeBuy = false;
         }
      }
   }
}

