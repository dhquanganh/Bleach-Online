package Processors.Game.Lobby.GongFuFightWindow
{
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.GongFuFight.TGongFuFightBaseInfor;
   import Logics.GongFuFight.TGongFuFightData;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_GONGFUFIGHT;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Utilities.Timing.TUtilityTiming;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TWindowApply extends TProcessorLobbyWindow
   {
      
      public static const CODE_CANFIGHT:uint = 1 << 0;
      
      public static const CODENONEFIGHT:uint = 1 << 1;
      
      public static const CODETIME0:uint = 1 << 2;
      
      public static const CODETIME1:uint = 1 << 3;
      
      public static const CODETIME2:uint = 1 << 4;
      
      public static const CODETIME3:uint = 1 << 5;
      
      public static const CODEAPPLYYTD:uint = 1 << 6;
      
      public static const CODENONEAPPLYYTD:uint = 1 << 7;
      
      public static const CODEAPPLYNOW:uint = 1 << 8;
      
      public static const CODENONEAPPLYNOW:uint = 1 << 9;
      
      protected static const PAYWINDOW_WIDTH:int = 705;
      
      protected static const PAYWINDOW_HEIGHT:int = 491;
      
      protected static const RANKWINDOW_WIDTH:int = 522;
      
      protected static const RANKWINDOW_HEIGHT:int = 377;
      
      protected var FMainScene:Sprite;
      
      protected var FActivityDesctiption:TextField;
      
      protected var FBtnPay:TUIButton;
      
      protected var FBtnRank:TUIButton;
      
      protected var FBtnChallageCardMall:TUIButton;
      
      protected var FBtnSoulStoneMall:TUIButton;
      
      protected var FTFForecast:TextField;
      
      protected var FPrompt:TextField;
      
      protected var FBtnApply:TUIButton;
      
      protected var FEffect:MovieClip;
      
      protected var FWindowRank:TWindowRank;
      
      protected var FWindowPay:TWindowPay;
      
      protected var FBtnClose:TUIButton;
      
      protected var FGongFuFightData:TGongFuFightData;
      
      protected var FApplyFlag:Sprite;
      
      protected var Format0:String;
      
      protected var Format1:String;
      
      protected var Format2:String;
      
      protected var Format3:String;
      
      protected var Format4:String;
      
      protected var Format5:String;
      
      protected var Format6:String;
      
      protected var Format7:String;
      
      protected var Format8:String;
      
      protected var Format9:String;
      
      protected var Format10:String;
      
      protected var Format11:String;
      
      protected var FOpenSubWindow:Function;
      
      protected var FOnOpenTokenShop:Function;
      
      protected var FOnOpenStoneShop:Function;
      
      public function TWindowApply(param1:TUIComponent)
      {
         super(param1);
         this.FWindowRank = new TWindowRank(this);
         this.FWindowPay = new TWindowPay(this);
         this.FGongFuFightData = SLogicsCore.GongFuFightData;
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FMainScene = TUtilityReflection.CreateDisplayObjectInstance("GongFuApplyUI") as Sprite;
         addChildAt(this.FMainScene,0);
         this.FActivityDesctiption = this.FMainScene["ActivityDescription"];
         this.FActivityDesctiption.condenseWhite = true;
         this.FActivityDesctiption.htmlText = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_01);
         this.FBtnPay = new TUIButton();
         this.FBtnPay.Substrate = this.FMainScene["BtnPay"]["Btn_EnterPay"];
         this.FBtnPay.OnClick = this.BtnPayOnClick;
         this.FBtnRank = new TUIButton();
         this.FBtnRank.Substrate = this.FMainScene["btn_Rank"];
         this.FBtnRank.OnClick = this.BtnRankOnClick;
         this.FBtnApply = new TUIButton();
         this.FBtnApply.Substrate = this.FMainScene["BtnApply"];
         this.FBtnApply.OnClick = this.BtnApplyOnClick;
         this.FEffect = this.FMainScene["BtnApply"]["Effect"];
         this.FBtnChallageCardMall = new TUIButton();
         this.FBtnChallageCardMall.Substrate = this.FMainScene["ChallengeCardUI"]["Btn"];
         this.FBtnChallageCardMall.OnClick = this.BtnChallageCardShopOnClick;
         this.FBtnChallageCardMall.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_31);
         this.FBtnSoulStoneMall = new TUIButton();
         this.FBtnSoulStoneMall.Substrate = this.FMainScene["PeakStoneUI"]["Btn"];
         this.FBtnSoulStoneMall.OnClick = this.BtnStoneShopOnClick;
         this.FBtnSoulStoneMall.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_32);
         this.FPrompt = this.FMainScene["Prompt"];
         this.FTFForecast = this.FMainScene["Forecast"]["Value"];
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainScene["BtnClose"];
         this.FBtnClose.OnClick = this.BtnCloseOnClick;
         this.FApplyFlag = this.FMainScene["ApplyFlag"];
         this.Format0 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_02);
         this.Format1 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_03);
         this.Format2 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_04);
         this.Format3 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_05);
         this.Format4 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_06);
         this.Format5 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_07);
         this.Format6 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_08);
         this.Format7 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_09);
         this.Format8 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_10);
         this.Format9 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_11);
         this.Format10 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_12);
         this.Format11 = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_13);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
         this.FWindowPay.x = (Width - PAYWINDOW_WIDTH) / 2;
         this.FWindowPay.y = (Height - PAYWINDOW_HEIGHT) / 2;
         this.FWindowRank.x = (Width - RANKWINDOW_WIDTH) / 2;
         this.FWindowRank.y = (Height - RANKWINDOW_HEIGHT) / 2;
         this.FMainScene.visible = false;
      }
      
      protected function CheckIfTomorrowCanFight(param1:TGongFuFightBaseInfor) : Boolean
      {
         if(param1.SeasonState == CONST_GONGFUFIGHT.SeasonState_Close || param1.SeasonState == CONST_GONGFUFIGHT.SeasonState_Rest)
         {
            return false;
         }
         return param1.SeasonResetTime - STimingCore.ServerTick > CONST_COMMON.SecondPerDay;
      }
      
      protected function RenderPromptInfor(param1:TGongFuFightBaseInfor) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Date = null;
         var _loc4_:uint = 0;
         _loc2_ = this.GetCurrentCode(param1);
         this.FBtnApply.Visible = false;
         this.FTFForecast.text = "";
         this.FEffect.stop();
         this.FApplyFlag.visible = this.FGongFuFightData.GongFuFightBaseInfor.IfApplyToday;
         if(param1.SeasonState == CONST_GONGFUFIGHT.SeasonState_Close)
         {
            this.FPrompt.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_35);
            this.FTFForecast.text = "";
         }
         else if(this.IfCantain(_loc2_,CODENONEFIGHT | CODENONEAPPLYYTD))
         {
            if(param1.SeasonState == CONST_GONGFUFIGHT.SeasonState_Rest)
            {
               _loc4_ = param1.SeasonOpenTime;
            }
            else
            {
               _loc4_ = param1.SeasonCloseTime;
            }
            _loc4_ = _loc4_ - STimingCore.ServerTimeZone + STimingCore.ClientTimezoneOffset;
            _loc3_ = new Date(_loc4_ * 1000);
            this.FPrompt.text = "";
            this.FTFForecast.text = TUtilityString.Format(this.Format0,_loc3_.fullYear,_loc3_.month + 1,_loc3_.date);
         }
         else if(this.IfCantain(_loc2_,CODENONEFIGHT | CODETIME0 | CODEAPPLYYTD))
         {
            this.FTFForecast.text = "";
            this.FPrompt.text = TUtilityString.Format(this.Format1,TUtilityTiming.FormatTimeWithoutSecond(param1.TimeStartFight));
         }
         else if(this.IfCantain(_loc2_,CODENONEFIGHT | CODETIME2 | CODEAPPLYYTD))
         {
            this.FPrompt.text = this.Format9;
            if(param1.SeasonState == CONST_GONGFUFIGHT.SeasonState_Rest)
            {
               _loc4_ = param1.SeasonOpenTime;
            }
            else
            {
               _loc4_ = param1.SeasonCloseTime;
            }
            _loc4_ = _loc4_ - STimingCore.ServerTimeZone + STimingCore.ClientTimezoneOffset;
            _loc3_ = new Date(_loc4_ * 1000);
            this.FTFForecast.text = TUtilityString.Format(this.Format0,_loc3_.fullYear,_loc3_.month + 1,_loc3_.date);
         }
         else if(this.IfCantain(_loc2_,CODENONEFIGHT | CODETIME1 | CODEAPPLYYTD))
         {
            this.FTFForecast.text = "";
            this.FPrompt.text = TUtilityString.Format(this.Format1,TUtilityTiming.FormatTimeWithoutSecond(param1.TimeStartFight));
         }
         else if(this.IfCantain(_loc2_,CODE_CANFIGHT | CODETIME0 | CODENONEAPPLYYTD))
         {
            this.FTFForecast.text = "";
            this.FPrompt.text = TUtilityString.Format(this.Format2,TUtilityTiming.FormatTimeWithoutSecond(param1.TimeCanApply));
         }
         else if(this.IfCantain(_loc2_,CODE_CANFIGHT | CODETIME0 | CODEAPPLYYTD))
         {
            this.FTFForecast.text = "";
            this.FPrompt.text = TUtilityString.Format(this.Format1,TUtilityTiming.FormatTimeWithoutSecond(param1.TimeStartFight));
         }
         else if(this.IfCantain(_loc2_,CODE_CANFIGHT | CODETIME1 | CODENONEAPPLYYTD | CODENONEAPPLYNOW))
         {
            this.FTFForecast.text = "";
            this.FPrompt.text = this.Format3;
            this.FBtnApply.Visible = true;
            this.FEffect.play();
         }
         else if(this.IfCantain(_loc2_,CODE_CANFIGHT | CODETIME1 | CODENONEAPPLYYTD | CODEAPPLYNOW))
         {
            this.FTFForecast.text = "";
            this.FPrompt.text = TUtilityString.Format(this.Format4,TUtilityTiming.FormatTimeWithoutSecond(param1.TimeStartFight));
         }
         else if(this.IfCantain(_loc2_,CODE_CANFIGHT | CODETIME1 | CODEAPPLYYTD | CODENONEAPPLYNOW))
         {
            this.FTFForecast.text = "";
            this.FPrompt.text = TUtilityString.Format(this.Format5,TUtilityTiming.FormatTimeWithoutSecond(param1.TimeStartFight));
            this.FBtnApply.Visible = true;
            this.FEffect.play();
         }
         else if(this.IfCantain(_loc2_,CODE_CANFIGHT | CODETIME1 | CODEAPPLYYTD | CODEAPPLYNOW))
         {
            this.FTFForecast.text = "";
            this.FPrompt.text = TUtilityString.Format(this.Format6,TUtilityTiming.FormatTimeWithoutSecond(param1.TimeStartFight));
         }
         else if(this.IfCantain(_loc2_,CODE_CANFIGHT | CODETIME2 | CODENONEAPPLYYTD | CODENONEAPPLYNOW))
         {
            this.FTFForecast.text = "";
            this.FPrompt.text = this.Format3;
            this.FBtnApply.Visible = true;
            this.FEffect.play();
         }
         else if(this.IfCantain(_loc2_,CODE_CANFIGHT | CODETIME2 | CODENONEAPPLYYTD | CODEAPPLYNOW))
         {
            this.FTFForecast.text = "";
            this.FPrompt.text = TUtilityString.Format(this.Format4,TUtilityTiming.FormatTimeWithoutSecond(param1.TimeStartFight));
         }
         else if(this.IfCantain(_loc2_,CODE_CANFIGHT | CODETIME2 | CODEAPPLYYTD | CODENONEAPPLYNOW))
         {
            this.FTFForecast.text = "";
            this.FPrompt.text = this.Format10;
            this.FBtnApply.Visible = true;
            this.FEffect.play();
         }
         else if(this.IfCantain(_loc2_,CODE_CANFIGHT | CODETIME2 | CODEAPPLYYTD | CODEAPPLYNOW))
         {
            this.FTFForecast.text = "";
            this.FPrompt.text = TUtilityString.Format(this.Format11,TUtilityTiming.FormatTimeWithoutSecond(param1.TimeStartFight));
         }
         else if(this.IfCantain(_loc2_,CODE_CANFIGHT | CODETIME3 | CODENONEAPPLYNOW))
         {
            this.FTFForecast.text = "";
            this.FPrompt.text = this.Format7;
            this.FBtnApply.Visible = true;
            this.FEffect.play();
         }
         else if(this.IfCantain(_loc2_,CODE_CANFIGHT | CODETIME3 | CODEAPPLYNOW))
         {
            this.FTFForecast.text = "";
            this.FPrompt.text = TUtilityString.Format(this.Format8,TUtilityTiming.FormatTimeWithoutSecond(param1.TimeStartFight));
         }
      }
      
      public function GetCurrentCode(param1:TGongFuFightBaseInfor) : uint
      {
         var _loc2_:uint = 0;
         _loc2_ |= this.CheckIfTomorrowCanFight(param1) ? CODE_CANFIGHT : CODENONEFIGHT;
         if(this.CheckIfTimeHit(0,param1.TimeCanApply))
         {
            _loc2_ |= CODETIME0;
         }
         else if(this.CheckIfTimeHit(param1.TimeCanApply,param1.TimeStartFight))
         {
            _loc2_ |= CODETIME1;
         }
         else if(this.CheckIfTimeHit(param1.TimeStartFight,param1.TimeEndFight))
         {
            _loc2_ |= CODETIME2;
         }
         else
         {
            _loc2_ |= CODETIME3;
         }
         _loc2_ |= param1.ApplyYesterdaySce != 0 ? CODEAPPLYYTD : CODENONEAPPLYYTD;
         return uint(_loc2_ | (param1.IfApplyToday ? CODEAPPLYNOW : CODENONEAPPLYNOW));
      }
      
      protected function CheckIfTimeHit(param1:uint, param2:uint) : Boolean
      {
         var _loc3_:uint = 0;
         _loc3_ = (STimingCore.ServerTick - STimingCore.ServerTimeZone) % CONST_COMMON.SecondPerDay;
         return _loc3_ >= param1 && _loc3_ <= param2;
      }
      
      protected function IfCantain(param1:uint, param2:uint) : Boolean
      {
         return (param1 & param2) == param2;
      }
      
      protected function BtnPayOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_PayRecordReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FWindowPay.Update(this.FGongFuFightData);
         this.FWindowPay.Visible = true;
      }
      
      protected function BtnRankOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_RankInforReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FWindowRank.Update(this.FGongFuFightData);
         this.FWindowRank.Visible = true;
      }
      
      protected function BtnApplyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_Apply);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function BtnChallageCardShopOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnOpenTokenShop != null)
         {
            this.FOnOpenTokenShop(this);
         }
      }
      
      protected function BtnStoneShopOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnOpenStoneShop != null)
         {
            this.FOnOpenStoneShop(this);
         }
      }
      
      public function set OpenSubWindow(param1:Function) : void
      {
         this.FOpenSubWindow = param1;
      }
      
      public function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function set OnOpenTokenShop(param1:Function) : void
      {
         this.FOnOpenTokenShop = param1;
      }
      
      public function set OnOpenStoneShop(param1:Function) : void
      {
         this.FOnOpenStoneShop = param1;
      }
      
      override public function Load() : void
      {
         super.Load();
         this.FWindowPay.Load();
         this.FWindowRank.Load();
      }
      
      public function OpenView(param1:uint) : void
      {
         switch(param1)
         {
            case CONST_GONGFUFIGHT.PayViewID:
               this.FWindowPay.Update(this.FGongFuFightData);
               this.FWindowPay.OnClose = FOnClose;
               this.FWindowPay.Visible = true;
               break;
            case CONST_GONGFUFIGHT.RankViewID:
               this.FWindowRank.Update(this.FGongFuFightData);
               this.FWindowRank.OnClose = FOnClose;
               this.FWindowRank.Visible = true;
               break;
            default:
               this.FMainScene.visible = true;
               this.RenderPromptInfor(this.FGongFuFightData.GongFuFightBaseInfor);
         }
      }
      
      public function ApplyNotify(param1:Object) : void
      {
         if(this.FIsResourcesLoadCompleted)
         {
            this.RenderPromptInfor(this.FGongFuFightData.GongFuFightBaseInfor);
         }
      }
      
      public function PayInforNotify(param1:Object) : void
      {
         if(this.FIsResourcesLoadCompleted)
         {
            this.FWindowPay.Update(this.FGongFuFightData);
         }
      }
      
      public function RankRecordNotify(param1:Object) : void
      {
         if(this.FIsResourcesLoadCompleted)
         {
            this.FWindowRank.Update(this.FGongFuFightData);
         }
      }
      
      public function Reset() : void
      {
         if(this.FIsResourcesLoadCompleted)
         {
            this.FMainScene.visible = false;
            this.FWindowRank.Reset();
            this.FWindowPay.Reset();
         }
      }
   }
}

