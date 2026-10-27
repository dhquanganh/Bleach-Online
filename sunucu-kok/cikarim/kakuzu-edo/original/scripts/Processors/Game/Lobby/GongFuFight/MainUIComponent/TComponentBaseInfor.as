package Processors.Game.Lobby.GongFuFight.MainUIComponent
{
   import Components.Standard.TUIButton;
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.TCharacter;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.GongFuFight.TGongFuFightBaseInfor;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_GONGFUFIGHT;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TComponentBaseInfor extends TProcessorLobbyWindow
   {
      
      protected var FTFSliverCoin:TextField;
      
      protected var FTFGoldCoin:TextField;
      
      protected var FTFGiftCoin:TextField;
      
      protected var FTFPvPValue:TextField;
      
      protected var FTFYesterDayRank:TextField;
      
      protected var FTFCurrentRank:TextField;
      
      protected var FTFCurrentGroupRank:TextField;
      
      protected var FTFScoreYesterDay:TextField;
      
      protected var FTFCurrentScore:TextField;
      
      protected var FTFCrrentFightTime:TextField;
      
      protected var FBtnApply:TUIButton;
      
      protected var FApplyFlag:Sprite;
      
      protected var FApplyEffect:MovieClip;
      
      protected var FTFSeasonInfor:TextField;
      
      protected var FBtnAddFightTime:TUIButton;
      
      protected var FHint:THint;
      
      protected var FAddFightTimeCost:int;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FAddFightTimeFormat:String;
      
      protected var FSeasonInforFormat:String;
      
      protected var FGongFuFightBaseInfor:TGongFuFightBaseInfor;
      
      public function TComponentBaseInfor(param1:TUIComponent)
      {
         super(param1);
      }
      
      public function UIDispatch(param1:Sprite) : void
      {
         var _loc2_:Sprite = null;
         var _loc3_:TConfigValue = null;
         _loc2_ = param1["SP_PanelCredits"];
         this.FTFSliverCoin = _loc2_["TF_SilverCoin"];
         this.FTFGoldCoin = _loc2_["TF_Gold"];
         this.FTFGiftCoin = _loc2_["TF_GiftCertificate"];
         _loc2_ = param1["PanleBaseInfor"];
         this.FTFPvPValue = _loc2_["PVPValue"];
         this.FTFYesterDayRank = _loc2_["YesterDayRank"];
         this.FTFCurrentRank = _loc2_["CurrentRank"];
         this.FTFCurrentGroupRank = _loc2_["CurrentGroupRank"];
         this.FTFScoreYesterDay = _loc2_["ScoreYesterDay"];
         this.FTFCurrentScore = _loc2_["CurrentScore"];
         this.FTFCrrentFightTime = _loc2_["CrrentFightTime"];
         this.FTFSeasonInfor = param1["SeasonInfor"]["Lable"];
         this.FBtnAddFightTime = new TUIButton();
         this.FBtnAddFightTime.Substrate = _loc2_["btn_addCurTimes"];
         this.FBtnAddFightTime.OnClick = this.BtnAddFightTimeOnClick;
         this.FBtnAddFightTime.OnMove = this.BtnAddFightTimeOnMove;
         this.FBtnAddFightTime.OnOut = this.BtnAddFightTimeOnOut;
         this.FBtnApply = new TUIButton();
         this.FBtnApply.Substrate = param1["BtnApply"];
         this.FBtnApply.OnClick = this.BtnApplyOnClick;
         this.FApplyFlag = param1["ApplyFlag"];
         this.FApplyEffect = param1["BtnApply"]["ApplyEffect"];
         this.FApplyEffect.mouseEnabled = false;
         this.FApplyEffect.mouseChildren = false;
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         _loc3_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.GongFuFight_BuyFightTimeCost) as TConfigValue;
         this.FAddFightTimeCost = _loc3_.Value as int;
         this.FHint = new THint();
         this.FAddFightTimeFormat = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_27);
         this.FSeasonInforFormat = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_GongFuGight_28);
      }
      
      protected function UILocation() : void
      {
      }
      
      protected function RenderView(param1:TGongFuFightBaseInfor) : void
      {
         var _loc2_:TCharacter = null;
         var _loc3_:Date = null;
         var _loc4_:uint = 0;
         _loc2_ = SLogicsCore.Character;
         this.FTFSliverCoin.text = _loc2_.CreditSilverCoin.ToString();
         this.FTFGoldCoin.text = _loc2_.CreditGold.toString();
         this.FTFGiftCoin.text = _loc2_.CreditGiftCertificate.toString();
         this.FTFPvPValue.text = _loc2_.Heros.GetHeroByIndex(0).PvPAttributeFightingPower.toString();
         this.FTFYesterDayRank.text = param1.RankYesterday.toString();
         this.FTFCurrentRank.text = param1.RankToday.toString();
         this.FTFCurrentGroupRank.text = CONST_GONGFUFIGHT.GroupLevelNames[param1.GrounpLevel];
         this.FTFScoreYesterDay.text = param1.ScoreYesterDay.toString();
         this.FTFCurrentScore.text = param1.ScoreToday.toString();
         this.FTFCrrentFightTime.text = param1.CurFightTimes.toString();
         _loc4_ = param1.SeasonResetTime - STimingCore.ServerTimeZone + STimingCore.ClientTimezoneOffset;
         _loc3_ = new Date(_loc4_ * 1000);
         this.FTFSeasonInfor.text = TUtilityString.Format(this.FSeasonInforFormat,_loc3_.fullYear,_loc3_.month + 1,_loc3_.date);
         if(!param1.IfApplyToday)
         {
            this.FApplyEffect.visible = true;
            this.FApplyEffect.play();
            this.FApplyFlag.visible = false;
            this.FBtnApply.Visible = this.CheckIfTomorrowCanFight(this.FGongFuFightBaseInfor);
         }
         else
         {
            this.FApplyEffect.visible = false;
            this.FApplyEffect.stop();
            this.FApplyFlag.visible = true;
            this.FBtnApply.Visible = false;
         }
      }
      
      protected function AddFightTimeRequest(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_AddFightTimeReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function CheckIfTomorrowCanFight(param1:TGongFuFightBaseInfor) : Boolean
      {
         if(param1.SeasonState == CONST_GONGFUFIGHT.SeasonState_Close || param1.SeasonState == CONST_GONGFUFIGHT.SeasonState_Rest)
         {
            return false;
         }
         return param1.SeasonResetTime - STimingCore.ServerTick > CONST_COMMON.SecondPerDay;
      }
      
      protected function BtnAddFightTimeOnMove(param1:Object, param2:MouseEvent) : void
      {
         this.FHint.Caption = TUtilityString.Format(this.FAddFightTimeFormat,this.FAddFightTimeCost);
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHint);
      }
      
      protected function BtnAddFightTimeOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHint);
      }
      
      protected function BtnAddFightTimeOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FUIWindowConfirmation.Text = TUtilityString.Format(this.FAddFightTimeFormat,this.FAddFightTimeCost);
         this.FUIWindowConfirmation.OnOK = this.AddFightTimeRequest;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function BtnApplyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_GongFuFight_Apply);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      public function Update(param1:TGongFuFightBaseInfor) : void
      {
         this.FGongFuFightBaseInfor = param1;
         this.RenderView(param1);
      }
      
      public function Reset() : void
      {
      }
      
      public function NotEnoughFightTime() : void
      {
         this.FUIWindowConfirmation.Visible = true;
         this.FUIWindowConfirmation.OnOK = this.AddFightTimeRequest;
         this.FUIWindowConfirmation.Text = TUtilityString.Format(this.FAddFightTimeFormat,this.FAddFightTimeCost);
      }
   }
}

