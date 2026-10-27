package Processors.Game.Lobby.Sign
{
   import Components.Pages.*;
   import Components.Slots.TUISlot;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Achievenment.*;
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.Characters.*;
   import Logics.DailySign.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Purchases.*;
   import Logics.Unlocks.TUnlock;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Common.ShowGirlPic.*;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Sign.Components.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.TUtilityTiming;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowDailySign extends TProcessorLobbyWindow
   {
      
      public static const AwardBase:uint = CONST_DAILYSIGN.AwardBase;
      
      public static const Multiple:uint = CONST_DAILYSIGN.Multiple;
      
      public static const IndicesLog:Number = CONST_DAILYSIGN.IndicesLog;
      
      protected static const INTERVALTIME:Number = 172800000;
      
      protected static const FRAME_UnSign:uint = 1;
      
      protected static const FRAME_TemporarilyUnsign:uint = 2;
      
      protected static const FRAME_PastSign:uint = 3;
      
      protected static const FRAME_DaySign:uint = 4;
      
      protected static const CAPACITY_DAYS:uint = 42;
      
      protected static const CAPACITY_IntegralItems:uint = 10;
      
      protected static const GirlOffsetX:int = 560;
      
      protected static const GirlOffsetY:int = -15;
      
      public static const Slot_Num:int = 2;
      
      protected var SIZE_Window_Width:uint = 626;
      
      protected var SIZE_Window_Height:uint = 442;
      
      protected var FPurchaseParameters:TPurchaseParameters;
      
      protected var FMC_DailySign:MovieClip;
      
      protected var FMC_Sign:MovieClip;
      
      protected var FMC_IntegralExchange:MovieClip;
      
      protected var FBTN_Close:SimpleButton;
      
      protected var FBTN_Help:SimpleButton;
      
      protected var FUITab:TUITab;
      
      protected var FShowGirl:TShowGirlPic;
      
      protected var FAchievements:TAchievementInfors;
      
      protected var FCurrentAchievement:TAchievementInfor;
      
      protected var FGiftBagMC:Sprite;
      
      protected var FBtnGetAchievementReward:TUIButton;
      
      protected var FTalkBubble:Sprite;
      
      protected var FTFTalkBubble:TextField;
      
      protected var FTF_Today:TextField;
      
      protected var FMC_Alldays:MovieClip;
      
      protected var FBTN_DailySign:TUIButton;
      
      protected var FBTN_GetReward:TUIButton;
      
      protected var FMC_RewardBG:MovieClip;
      
      protected var FTF_SignIntegral:TextField;
      
      protected var FTF_IntegralCost:TextField;
      
      protected var FMC_Reward:MovieClip;
      
      protected var FMC_RewardHero:MovieClip;
      
      protected var FMC_RewardItem:MovieClip;
      
      protected var FTF_TodaySignReward:TextField;
      
      protected var FTFDailySignList:Vector.<TextField>;
      
      protected var FMCDayList:Vector.<TUIDay>;
      
      protected var FBTN_Coupon:TUIButton;
      
      protected var FTF_CountDown:TextField;
      
      protected var FCouponAwardSlotVec:Vector.<TUISlot>;
      
      protected var FTF_CouponDesc:TextField;
      
      protected var FAwardNameAndMountStrVec:Vector.<String>;
      
      protected var FMC_Page:MovieClip;
      
      protected var FMC_IntegralItemList:Vector.<TUIIntegralItem>;
      
      protected var FUIPage:TUIPage;
      
      protected var FTabIndex:int;
      
      protected var FPageIndex:int;
      
      protected var FDailySign:TDailySign;
      
      protected var FUIWindowInformation:TUIWindowConfirmation;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FDay:uint;
      
      protected var FToday:uint;
      
      protected var FHelpTips:THint;
      
      protected var FToolHint:THint;
      
      protected var FRewardStr:String;
      
      protected var FBAData:TBleachAgentData;
      
      protected var FHintOnMove:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnCompensate:Function;
      
      protected var FOnExchange:Function;
      
      protected var FDownHintOnOver:Function;
      
      protected var FDownHintOnOut:Function;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      protected var FOnGetReward:Function;
      
      protected var FOnGetCouponReward:Function;
      
      public function TProcessorWindowDailySign(param1:TUIComponent)
      {
         super(param1);
         this.FBAData = SLogicsCore.BleachAgentData;
         this.FHelpTips = new THint();
         this.FToolHint = new THint();
         this.FTFDailySignList = new Vector.<TextField>(3);
         this.FMCDayList = new Vector.<TUIDay>(CAPACITY_DAYS);
         this.FMC_IntegralItemList = new Vector.<TUIIntegralItem>(CAPACITY_IntegralItems);
         this.FShowGirl = new TShowGirlPic();
         this.FShowGirl.mouseEnabled = false;
         this.FShowGirl.mouseChildren = false;
         this.ConstructPurchase();
      }
      
      protected function ConstructPurchase() : void
      {
         this.FPurchaseParameters = new TPurchaseParameters();
         this.FPurchaseParameters.RoutineSuccess = this.PurchaseRoutineSuccess;
         this.FPurchaseParameters.RoutineFailure = this.PurchaseRoutineFailure;
         this.FPurchaseParameters.RoutineCancel = this.PurchaseRoutineCancel;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_DAILYSIGN.RESOURCESID_Swf_DailySign);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUIDay = null;
         var _loc4_:TUIIntegralItem = null;
         var _loc5_:MovieClip = null;
         var _loc6_:TextField = null;
         var _loc7_:TUISlot = null;
         var _loc8_:TAchievementInfor = null;
         this.FMC_DailySign = TUtilityReflection.CreateDisplayObjectInstance(CONST_DAILYSIGN.RESOURCE_ClassName_MC_DailySign) as MovieClip;
         addChild(this.FMC_DailySign);
         this.FGiftBagMC = TUtilityReflection.CreateDisplayObjectInstance("GiftBag") as MovieClip;
         this.FTalkBubble = TUtilityReflection.CreateDisplayObjectInstance("TalkLeft") as Sprite;
         this.FTFTalkBubble = this.FTalkBubble["tf_dialogueText"];
         this.FTalkBubble.x = GirlOffsetX + 200;
         this.FTalkBubble.mouseChildren = false;
         this.FTalkBubble.mouseEnabled = false;
         this.FGiftBagMC.x = GirlOffsetX + 30;
         this.FGiftBagMC.y = GirlOffsetY + 240;
         this.FShowGirl.x = GirlOffsetX;
         this.FShowGirl.y = GirlOffsetY;
         if(false)
         {
            this.FMC_DailySign.x = -100;
            this.FTalkBubble.x -= 100;
            this.FGiftBagMC.x = GirlOffsetX - 20;
            this.FShowGirl.x -= 90;
         }
         this.FBtnGetAchievementReward = new TUIButton();
         this.FBtnGetAchievementReward.Substrate = this.FGiftBagMC["GetReward"];
         this.FBtnGetAchievementReward.OnClick = this.OnBtnGetAchievementClick;
         this.FAchievements = new TAchievementInfors();
         _loc1_ = CONST_DAILYSIGN.AchievementIDMin;
         while(_loc1_ <= CONST_DAILYSIGN.AchievementIDMax)
         {
            _loc8_ = SLogicsCore.Character.AchievementData.GetAchievementByID(_loc1_);
            if(_loc8_ == null)
            {
               break;
            }
            this.FAchievements.Add(_loc8_);
            _loc1_++;
         }
         this.FMC_Sign = this.FMC_DailySign[CONST_DAILYSIGN.RESOURCE_Link_MC_Sign];
         this.FMC_IntegralExchange = this.FMC_DailySign[CONST_DAILYSIGN.RESOURCE_Link_MC_IntegralExchange];
         this.FMC_IntegralExchange.visible = false;
         this.FBTN_Close = this.FMC_DailySign[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBTN_Help = this.FMC_DailySign[CONST_COMMON.RESOURCE_Link_Btn_Help];
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_SignCloseBtn,this.FBTN_Close);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_SignCloseBtn,FParent);
         this.FUITab = new TUITab(this);
         _loc2_ = 2;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FUITab.SetTabByIndex(this.FMC_DailySign[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FTF_Today = this.FMC_Sign[CONST_DAILYSIGN.RESOURCE_Link_TF_Today];
         this.FMC_Alldays = this.FMC_Sign[CONST_DAILYSIGN.RESOURCE_Link_MC_Alldays];
         this.FMC_Alldays.visible = false;
         this.FBTN_DailySign = new TUIButton();
         this.FBTN_DailySign.Substrate = this.FMC_Sign[CONST_DAILYSIGN.RESOURCE_Link_BTN_DailySign];
         this.FBTN_DailySign.OnClick = this.BTNDailySignOnClick;
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_SignBtn,this.FBTN_DailySign);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_SignBtn,FParent);
         this.FBTN_GetReward = new TUIButton();
         this.FBTN_GetReward.Substrate = this.FMC_Sign[CONST_DAILYSIGN.RESOURCE_Link_BTN_GetReward];
         this.FBTN_GetReward.OnClick = this.BTNGetRewardOnClick;
         this.FMC_RewardBG = this.FMC_Sign[CONST_DAILYSIGN.RESOURCE_Link_MC_RewardBG];
         this.FTF_SignIntegral = this.FMC_Sign[CONST_DAILYSIGN.RESOURCE_Link_TF_SignIntegral];
         this.FTF_IntegralCost = this.FMC_Sign[CONST_DAILYSIGN.RESOURCE_Link_TF_IntegralCost];
         this.FMC_Reward = this.FMC_Sign[CONST_DAILYSIGN.RESOURCE_Link_MC_Reward];
         this.FMC_Reward.mouseEnabled = false;
         this.FMC_Reward.mouseChildren = false;
         this.FMC_RewardHero = this.FMC_Reward[CONST_DAILYSIGN.RESOURCE_Link_MC_RewardHero];
         this.FMC_RewardItem = this.FMC_Reward[CONST_DAILYSIGN.RESOURCE_Link_MC_RewardItem];
         this.FTF_TodaySignReward = this.FMC_Sign[CONST_DAILYSIGN.RESOURCE_Link_TF_TodaySignReward];
         _loc2_ = this.FTFDailySignList.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTFDailySignList[_loc1_] = this.FMC_Sign[CONST_DAILYSIGN.RESOURCE_Link_TF_DailySign + _loc1_];
            this.FTFDailySignList[_loc1_].text = "";
            _loc1_++;
         }
         this.FTFDailySignList[0].autoSize = "left";
         this.FTFDailySignList[2].autoSize = "left";
         _loc2_ = this.FMCDayList.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIDay(this);
            _loc3_.Resource = this.FMC_Alldays[CONST_DAILYSIGN.RESOURCE_Link_MC_Day + _loc1_];
            _loc3_.HintOnMove = this.HintOnMouseMove;
            _loc3_.HintOnOut = this.HintOnMouseOut;
            _loc3_.OnCompensate = this.ProcessorOnCompensate;
            _loc3_.Init();
            this.FMCDayList[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FTF_CountDown = this.FMC_Sign["TF_Time"];
         this.FTF_CouponDesc = this.FMC_Sign["TF_RewardDesc"];
         this.FBTN_Coupon = new TUIButton();
         this.FBTN_Coupon.Substrate = this.FMC_Sign["BTN_Coupon"];
         this.FBTN_Coupon.OnClick = this.OnGetMonthCardAward;
         _loc2_ = uint(Slot_Num);
         this.FCouponAwardSlotVec = new Vector.<TUISlot>();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc7_ = new TUISlot(this);
            _loc7_.Resource = this.FMC_Sign["Slot" + _loc1_];
            if(_loc7_.Resource != null)
            {
               _loc7_.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
               _loc7_.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
               TJadeCommon.InitSlot(_loc7_);
               _loc7_.Init();
               this.FCouponAwardSlotVec[_loc1_] = _loc7_;
            }
            _loc1_++;
         }
         addChild(this.FShowGirl);
         addChild(this.FGiftBagMC);
         addChild(this.FTalkBubble);
         this.FUIPage = new TUIPage(this);
         this.FMC_Page = this.FMC_IntegralExchange[CONST_DAILYSIGN.RESOURCE_Link_MC_Page];
         _loc5_ = this.FMC_Page[CONST_DAILYSIGN.RESOURCE_Link_MC_PageLeft];
         this.FUIPage.ButtonPrevious.Substrate = _loc5_;
         _loc5_ = this.FMC_Page[CONST_DAILYSIGN.RESOURCE_Link_MC_PageRight];
         this.FUIPage.ButtonNext.Substrate = _loc5_;
         _loc6_ = this.FMC_Page[CONST_DAILYSIGN.RESOURCE_Link_TF_Page];
         this.FUIPage.LabelPage = _loc6_;
         _loc6_.text = "0/0";
         this.FUIPage.PageSize = CAPACITY_IntegralItems;
         this.FUIPage.Init();
         this.FUIPage.OnChangePage = this.PageOnChange;
         _loc2_ = this.FMC_IntegralItemList.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new TUIIntegralItem(this);
            _loc4_.Resource = this.FMC_IntegralExchange[CONST_DAILYSIGN.RESOURCE_Link_MC_Equip + _loc1_];
            _loc4_.OnExchange = this.ProcessorOnExchange;
            _loc4_.DownHintOnOver = this.UIDownHintOnOver;
            _loc4_.DownHintOnOut = this.UIDownHintOnOut;
            _loc4_.Init();
            this.FMC_IntegralItemList[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FUIWindowInformation = SUtilityOverLayer.UIWindowConfirmation;
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBTN_Close.addEventListener(MouseEvent.CLICK,this.CloseOnClick,false,0,true);
         this.FBTN_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FBTN_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         this.FGiftBagMC.addEventListener(MouseEvent.MOUSE_MOVE,this.GiftBagOnMouseMove);
         this.FGiftBagMC.addEventListener(MouseEvent.MOUSE_OUT,this.GiftBagOnMouseOut);
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUIIntegralItem = null;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         this.FShowGirl.Update();
         _loc2_ = this.FMC_IntegralItemList.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_IntegralItemList[_loc1_];
            if(_loc3_ != null)
            {
               _loc3_.UpdateSlot();
            }
            _loc1_++;
         }
         this.UpdateSlots();
      }
      
      protected function UpdateUITab() : void
      {
         this.FTabIndex = 0;
         this.FUITab.SwithTagManual(this.FTabIndex);
      }
      
      protected function UpdateUISign() : void
      {
         this.UpdateTextAndButtonState();
         this.UpdateUIDay();
      }
      
      protected function UpdateUIIntegralExchange() : void
      {
         this.UpdateExchangeText();
         this.UpdatePageInfo();
         this.UpdateUIIntegralItem();
      }
      
      protected function UpdateExchangeText() : void
      {
         this.FMC_IntegralExchange["TF_SignIntegral"].text = SLogicsCore.Character.CreditIntegral.toString();
         this.FMC_IntegralExchange["TF_IntegralCost"].text = this.FTF_IntegralCost.text;
      }
      
      protected function UpdatePageInfo() : void
      {
         this.FPageIndex = 0;
         this.FUIPage.TotalQuantity = this.FDailySign.ExchangeReward.Count;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
      }
      
      protected function UpdateTextAndButtonState() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TConfigValue = null;
         var _loc4_:RegExp = /\\n/g;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.SIGN_Sign_mark) as TConfigValue;
         this.FTF_Today.text = TUtilityDate.FormatDateChinese(new Date(STimingCore.ServerTime * 1000));
         if(false)
         {
            this.FTF_Today.text = TUtilityDate.FormatDateAmerican(new Date(STimingCore.ServerTime * 1000));
         }
         _loc1_ = uint(SLogicsCore.Character.GetMainRebirthLevel() * IndicesLog * AwardBase) * Multiple;
         _loc2_ = CONST_DAILYSIGN.GetGiftCertificateByDay(new Date(STimingCore.ServerTime * 1000).date);
         if(_loc2_ != 0)
         {
            this.FTF_TodaySignReward.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin) + ":" + _loc1_ + "  " + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Vouchers) + ":" + _loc2_;
         }
         else
         {
            this.FTF_TodaySignReward.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.ITEMNAME_Coin) + ":" + _loc1_;
         }
         this.FTF_SignIntegral.text = SLogicsCore.Character.CreditIntegral.toString();
         this.FTF_IntegralCost.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_05),_loc3_.Value);
         if(this.FDailySign.SignReward == null)
         {
            this.FBTN_GetReward.Visible = false;
            this.FTFDailySignList[0].text = "";
            this.FTFDailySignList[1].text = "";
            this.FTFDailySignList[2].text = "";
            this.FMC_RewardBG.gotoAndStop(2);
            this.FMC_Reward.visible = false;
            return;
         }
         if(this.FMC_RewardItem.currentFrame != 5)
         {
            this.FMC_RewardItem.gotoAndPlay(1);
         }
         this.FMC_RewardItem.MC_Icon.MC_Box.gotoAndStop(this.FDailySign.RewardID);
         this.FMC_RewardHero.visible = false;
         this.FMC_RewardItem.visible = true;
         this.FMC_RewardItem["MC_Icon"]["TF_Text"].htmlText = this.FDailySign.SignReward.Desc.replace(_loc4_,"<br>");
         this.FBTN_GetReward.Visible = true;
         this.FMC_RewardBG.gotoAndStop(1);
         if(this.FDailySign.SignTotalDays < this.FDailySign.SignReward.Day)
         {
            this.FTFDailySignList[0].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_02);
            this.FTFDailySignList[1].text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_03),this.FDailySign.SignReward.Day - this.FDailySign.SignTotalDays);
            this.FTFDailySignList[2].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_04);
            this.FBTN_GetReward.Enabled = false;
         }
         else
         {
            this.FTFDailySignList[0].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_01);
            this.FTFDailySignList[1].text = "";
            this.FTFDailySignList[2].text = "";
            this.FBTN_GetReward.Enabled = true;
         }
      }
      
      protected function UpdateUIDay() : void
      {
         var _loc1_:* = 0;
         var _loc2_:uint = 0;
         var _loc3_:Date = null;
         var _loc4_:Date = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         var _loc10_:TUIDay = null;
         var _loc11_:Date = null;
         _loc3_ = new Date(STimingCore.ServerTime * 1000);
         _loc4_ = new Date(STimingCore.ServerTime * 1000);
         _loc11_ = new Date(this.FDailySign.ServerStartDate * 1000);
         this.FToday = _loc4_.date;
         if(_loc4_.month > this.FDailySign.CurrentMonth)
         {
            _loc2_ = this.FDailySign.DayList.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FDailySign.DayList.pop();
               _loc1_++;
            }
            this.FDailySign.DayList.length = 0;
            _loc2_ = uint(TUtilityDate.GetMonthDaysByDate(_loc3_));
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FDailySign.DayList.push("0");
               _loc1_++;
            }
         }
         else
         {
            _loc2_ = TUtilityDate.GetMonthDaysByDate(_loc3_) - this.FDailySign.DayList.length;
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FDailySign.DayList.push("0");
               _loc1_++;
            }
         }
         if(this.FDailySign.DayList[_loc4_.date - 1] == "0")
         {
            this.FBTN_DailySign.Enabled = true;
         }
         else
         {
            this.FBTN_DailySign.Enabled = false;
         }
         _loc3_.setDate(1);
         _loc5_ = _loc3_.getDay();
         _loc6_ = _loc5_ % 7;
         _loc7_ = _loc3_.getDate();
         _loc8_ = 0;
         _loc2_ = uint(TUtilityDate.GetMonthDaysByDate(_loc3_));
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc10_ = this.FMCDayList[_loc6_ + _loc1_];
            _loc10_.Day = _loc7_;
            _loc10_.SetTextInfo(_loc7_++);
            _loc9_ = _loc7_ - 2;
            _loc8_ = _loc9_ + 1;
            if(this.FDailySign.DayList[_loc9_] == "0")
            {
               _loc10_.IsSign = false;
               if(_loc8_ < _loc4_.date)
               {
                  if(_loc11_.fullYearUTC == _loc4_.fullYearUTC)
                  {
                     if(_loc11_.month < _loc4_.month)
                     {
                        _loc10_.SetUIInfo(FRAME_PastSign);
                     }
                     else if(_loc11_.month == _loc4_.month)
                     {
                        if(_loc11_.date <= _loc8_)
                        {
                           _loc10_.SetUIInfo(FRAME_PastSign);
                        }
                        else
                        {
                           _loc10_.SetUIInfo(FRAME_UnSign);
                        }
                     }
                  }
                  else
                  {
                     _loc10_.SetUIInfo(FRAME_PastSign);
                  }
               }
               else if(_loc8_ > _loc4_.date)
               {
                  _loc10_.SetUIInfo(FRAME_TemporarilyUnsign);
               }
               else
               {
                  _loc10_.SetUIInfo(FRAME_DaySign);
               }
            }
            else
            {
               _loc10_.IsSign = true;
               if(_loc8_ < _loc4_.date)
               {
                  _loc10_.SetUIInfo(FRAME_PastSign);
               }
               else if(_loc8_ == _loc4_.date)
               {
                  _loc10_.SetUIInfo(FRAME_DaySign);
               }
            }
            _loc1_++;
         }
         _loc7_ = uint(TUtilityDate.GetMonthDaysByDate(new Date(_loc3_.getTime() - INTERVALTIME)));
         _loc1_ = int(_loc6_ - 1);
         while(_loc1_ > -1)
         {
            _loc10_ = this.FMCDayList[_loc1_];
            _loc10_.SetTextInfo(_loc7_--);
            _loc10_.SetUIInfo(FRAME_UnSign);
            _loc1_--;
         }
         _loc7_ = 1;
         _loc1_ = int(_loc2_ + _loc6_);
         while(_loc1_ < CAPACITY_DAYS)
         {
            _loc10_ = this.FMCDayList[_loc1_];
            _loc10_.SetTextInfo(_loc7_++);
            _loc10_.SetUIInfo(FRAME_UnSign);
            _loc1_++;
         }
         if(!this.FMC_Alldays.visible)
         {
            this.FMC_Alldays.visible = true;
         }
      }
      
      protected function UpdateAchievement() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TAchievementInfor = null;
         var _loc3_:int = 0;
         var _loc4_:TUnlock = null;
         _loc4_ = SLogicsCore.Unlocks.GetUnlockByIdentifier(CONST_FUNCTIONSWITCH.UNLOCK_Achievement);
         if(_loc4_.State == TUnlock.UNLOCKSTATE_ForcedOff)
         {
            this.FTalkBubble.visible = false;
            this.FGiftBagMC.visible = false;
            return;
         }
         this.FCurrentAchievement = null;
         _loc1_ = 0;
         while(_loc1_ < this.FAchievements.Count)
         {
            _loc2_ = this.FAchievements.GetAchievementByIndex(_loc1_);
            if(!_loc2_.IfGotReward)
            {
               this.FCurrentAchievement = _loc2_;
               break;
            }
            _loc1_++;
         }
         this.FGiftBagMC.visible = false;
         this.FTalkBubble.visible = false;
         this.FShowGirl.IFCanGetReward = false;
         if(this.FCurrentAchievement != null)
         {
            if(this.FCurrentAchievement.IfComplete)
            {
               this.FGiftBagMC.visible = true;
               this.FShowGirl.IFCanGetReward = true;
            }
            this.FTalkBubble.visible = true;
            _loc3_ = this.FCurrentAchievement.TotalSchedule - this.FCurrentAchievement.CurrentSchedule;
            _loc3_ = _loc3_ < 0 ? 0 : _loc3_;
            this.FTFTalkBubble.htmlText = TUtilityString.Format(this.FCurrentAchievement.RewardStringFormat,_loc3_,this.FCurrentAchievement.RewardString);
         }
      }
      
      protected function UpdateUIIntegralItem() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TUIIntegralItem = null;
         _loc3_ = CAPACITY_IntegralItems;
         _loc1_ = 0;
         while(_loc1_ < _loc3_)
         {
            _loc2_ = _loc1_ + this.FPageIndex * _loc3_;
            _loc4_ = this.FMC_IntegralItemList[_loc1_];
            if(_loc2_ >= this.FDailySign.ExchangeReward.Count)
            {
               _loc4_.Resource.visible = false;
            }
            else
            {
               _loc4_.Resource.visible = true;
            }
            _loc1_++;
         }
         this.UpdateIntegralItemInfo();
      }
      
      protected function UpdateIntegralItemInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         var _loc3_:TUIIntegralItem = null;
         _loc2_ = CAPACITY_IntegralItems;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_IntegralItemList[_loc1_];
            if(_loc1_ + this.FPageIndex * _loc2_ >= this.FDailySign.ExchangeReward.Count)
            {
               return;
            }
            _loc3_.SetItemInfo(this.FDailySign.ExchangeReward.GetInventorySampleByIndex(_loc1_ + this.FPageIndex * _loc2_));
            _loc1_++;
         }
      }
      
      protected function PurchaseRoutineSuccess() : void
      {
         this.UpdateUIIntegralExchange();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TREASUREMAP_STRING_45));
      }
      
      protected function PurchaseRoutineFailure() : void
      {
      }
      
      protected function PurchaseRoutineCancel() : void
      {
      }
      
      protected function UpdateMonthCardAward() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUISlot = null;
         var _loc4_:TConfigValue = null;
         var _loc5_:TInventories = null;
         var _loc6_:Vector.<uint> = null;
         var _loc7_:int = 0;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         this.FAwardNameAndMountStrVec = new Vector.<String>();
         if(this.FDailySign.FirstRewardState == 0)
         {
            _loc9_ = int(CONST_CONFIGVALUE.MonthCard_PayUnFinishReward);
         }
         else
         {
            _loc9_ = int(CONST_CONFIGVALUE.MonthCard_PayFinishReward);
         }
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,_loc9_) as TConfigValue;
         if(_loc4_ == null)
         {
            return;
         }
         _loc6_ = _loc4_.Value as Vector.<uint>;
         _loc2_ = int(_loc6_.length);
         _loc8_ = "";
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc6_[_loc1_],_loc5_);
            if(_loc1_ == 1 && Boolean(SLogicsCore.BleachAgentData.Open))
            {
               _loc5_.GetInventoryByIndex(0).Quantity = _loc5_.GetInventoryByIndex(0).Quantity * 2;
            }
            _loc8_ = _loc5_.GetInventoryByIndex(0).Name + "*" + _loc5_.GetInventoryByIndex(0).Quantity;
            this.FAwardNameAndMountStrVec[_loc1_] = _loc8_;
            this.FCouponAwardSlotVec[_loc1_].Context = _loc5_.GetInventoryByIndex(0);
            _loc1_++;
         }
         _loc7_ = this.FDailySign.OverTime - STimingCore.ServerTick;
         if(this.FDailySign.OverTime == 0 || _loc7_ < 0)
         {
            this.FTF_CountDown.text = "";
         }
         else
         {
            this.FTF_CountDown.text = this.FormatTime(_loc7_);
         }
         if(this.FDailySign.OverTime != 0)
         {
            if(this.FDailySign.FirstRewardState == 0)
            {
               this.FBTN_Coupon.Enabled = this.FDailySign.OverTime == 0 || _loc7_ < 0 ? false : true;
               this.FBTN_Coupon.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_14);
            }
            else
            {
               this.FBTN_Coupon.Enabled = this.FDailySign.MonthRewardState == 1 || this.FDailySign.OverTime == 0 || _loc7_ < 0 ? false : true;
               if(this.FDailySign.OverTime == 0 || this.FDailySign.MonthRewardState == 0)
               {
                  this.FBTN_Coupon.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_14);
               }
               else
               {
                  this.FBTN_Coupon.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_15);
               }
            }
         }
         else
         {
            this.FBTN_Coupon.Enabled = false;
         }
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.MonthCard_Config) as TConfigValue;
         _loc6_ = _loc4_.Value as Vector.<uint>;
         this.FTF_CouponDesc.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_13),_loc6_[0],_loc6_[1],_loc6_[2]);
      }
      
      protected function FormatTime(param1:uint) : String
      {
         var _loc2_:int = 0;
         _loc2_ = param1 / TUtilityTiming.CONST_DAY;
         if(_loc2_ > 0)
         {
            return _loc2_ + TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TYPE_TIME_Day);
         }
         return TUtilityTiming.fomatTime(param1);
      }
      
      private function UpdateSlots() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FCouponAwardSlotVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FCouponAwardSlotVec[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_Sign);
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
      
      protected function CloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         this.FTabIndex = param1 as int;
         switch(this.FTabIndex)
         {
            case 0:
               this.FMC_Sign.visible = true;
               this.FMC_IntegralExchange.visible = false;
               this.UpdateUISign();
               break;
            case 1:
               this.FMC_Sign.visible = false;
               this.FMC_IntegralExchange.visible = true;
               this.UpdateUIIntegralExchange();
         }
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdateUIIntegralItem();
      }
      
      protected function BTNDailySignOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnCompensate != null)
         {
            this.FOnCompensate(this,this.FToday);
         }
         this.FRewardStr = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_06) + this.FTF_TodaySignReward.text;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickSign);
      }
      
      protected function BTNGetRewardOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnGetReward != null)
         {
            this.FOnGetReward(this);
         }
      }
      
      protected function OnGetMonthCardAward(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this.FOnGetCouponReward != null)
         {
            this.FOnGetCouponReward(this);
         }
         _loc5_ = int(this.FAwardNameAndMountStrVec.length);
         _loc3_ = "";
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ += this.FAwardNameAndMountStrVec[_loc4_] + "\n";
            _loc4_++;
         }
         SToolReward.ShowMessage(_loc3_);
      }
      
      protected function WindowInformationOnOK(param1:Object) : void
      {
         if(this.FOnCompensate != null)
         {
            this.FOnCompensate(this,this.FDay);
         }
      }
      
      protected function ProcessorOnCompensate(param1:Object, param2:uint, param3:String) : void
      {
         var _loc4_:TConfigValue = null;
         var _loc5_:TCharacter = null;
         if(this.FBAData.GetWelfareCountByType(this.FBAData.WelfareType_SignCout) > 0)
         {
            this.FRewardStr = param3;
            this.FDay = param2 as uint;
            this.WindowInformationOnOK(null);
         }
         else
         {
            _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,60112003) as TConfigValue;
            _loc5_ = SLogicsCore.Character;
            if(_loc4_.Value > _loc5_.CreditGold + _loc5_.CreditGiftCertificate)
            {
               this.FUIWindowRecharge.visible = true;
               return;
            }
            this.FUIWindowInformation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYSIGN_STRING_09),_loc4_.Value);
            this.FRewardStr = param3;
            this.FUIWindowInformation.OnOK = this.WindowInformationOnOK;
            this.FUIWindowInformation.Visible = true;
            this.FDay = param2 as uint;
         }
      }
      
      protected function ProcessorOnExchange(param1:Object, param2:TInventorySample) : void
      {
         var _loc3_:TPurchaseRequest = null;
         _loc3_ = SLogicsCore.PoolPurchase.AcquirePurchaseRequest();
         _loc3_.IDTemplate = param2.Indentifier;
         _loc3_.Quantity = 1;
         if(this.FOnExchange != null)
         {
            this.FOnExchange(this,_loc3_,this.FPurchaseParameters);
         }
      }
      
      protected function HintOnMouseMove(param1:Object, param2:THint) : void
      {
         if(this.FHintOnMove != null)
         {
            this.FHintOnMove(this,param2);
         }
      }
      
      protected function HintOnMouseOut(param1:Object, param2:THint) : void
      {
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,param2);
         }
         this.FGiftBagMC.filters = null;
      }
      
      protected function GiftBagOnMouseMove(param1:MouseEvent) : void
      {
         if(this.FHintOnMove != null && this.FCurrentAchievement != null)
         {
            this.FToolHint.Caption = this.FCurrentAchievement.FlyText;
            this.FHintOnMove(this,this.FToolHint);
            this.FGiftBagMC.filters = [TUtilityFilter.highLightFilters];
         }
      }
      
      protected function GiftBagOnMouseOut(param1:MouseEvent) : void
      {
         this.HintOnMouseOut(this,this.FToolHint);
      }
      
      protected function UIDownHintOnOver(param1:Object, param2:Object) : void
      {
         if(this.FDownHintOnOver != null)
         {
            this.FDownHintOnOver(this,param2);
         }
      }
      
      protected function UIDownHintOnOut(param1:Object, param2:Object) : void
      {
         if(this.FDownHintOnOut != null)
         {
            this.FDownHintOnOut(this,param2);
         }
      }
      
      protected function OnBtnGetAchievementClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_AchievementRewardReq);
         _loc3_.Data.writeUnsignedInt(this.FCurrentAchievement.ID);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
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
      
      public function get OnCompensate() : Function
      {
         return this.FOnCompensate;
      }
      
      public function set OnCompensate(param1:Function) : void
      {
         this.FOnCompensate = param1;
      }
      
      public function get OnExchange() : Function
      {
         return this.FOnExchange;
      }
      
      public function set OnExchange(param1:Function) : void
      {
         this.FOnExchange = param1;
      }
      
      public function get DownHintOnOver() : Function
      {
         return this.FDownHintOnOver;
      }
      
      public function set DownHintOnOver(param1:Function) : void
      {
         this.FDownHintOnOver = param1;
      }
      
      public function get DownHintOnOut() : Function
      {
         return this.FDownHintOnOut;
      }
      
      public function set DownHintOnOut(param1:Function) : void
      {
         this.FDownHintOnOut = param1;
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
      
      public function get OnGetReward() : Function
      {
         return this.FOnGetReward;
      }
      
      public function set OnGetReward(param1:Function) : void
      {
         this.FOnGetReward = param1;
      }
      
      public function get OnGetCouponReward() : Function
      {
         return this.FOnGetCouponReward;
      }
      
      public function set OnGetCouponReward(param1:Function) : void
      {
         this.FOnGetCouponReward = param1;
      }
      
      public function get RewardStr() : String
      {
         return this.FRewardStr;
      }
      
      public function set RewardStr(param1:String) : void
      {
         this.FRewardStr = param1;
      }
      
      public function Init(param1:TDailySign) : void
      {
         this.FDailySign = param1;
         this.UpdateUITab();
         this.UpdateUISign();
         this.UpdateAchievement();
         this.UpdateMonthCardAward();
         this.FShowGirl.LoadResource(CONST_DAILYSIGN.GirlID);
      }
      
      public function UpdateUI() : void
      {
         this.UpdateUISign();
         this.UpdateAchievement();
         this.FShowGirl.TriggerSpecial();
      }
      
      public function UpdateReward() : void
      {
         this.UpdateTextAndButtonState();
         this.UpdateAchievement();
         this.FShowGirl.TriggerSpecial();
      }
      
      public function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = CAPACITY_IntegralItems;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_IntegralItemList[_loc1_].Reset();
            _loc1_++;
         }
         this.FDailySign = null;
         this.FShowGirl.Reset();
      }
      
      public function AchievementInforUpdateNotify(param1:TAchievementInfor) : void
      {
         if(visible && param1.ID >= CONST_DAILYSIGN.AchievementIDMin && param1.ID <= CONST_DAILYSIGN.AchievementIDMax)
         {
            this.UpdateAchievement();
         }
      }
   }
}

