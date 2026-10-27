package Processors.Game.Lobby.OrganizationalWar
{
   import Components.ScrollBar.*;
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Agent.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.OrganizationalWar.*;
   import Logics.TimeCoolDown.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowOrganizationalWar extends TProcessorLobbyWindow
   {
      
      protected static const TAB_INDEX_PLAYER:int = 0;
      
      protected static const TAB_INDEX_ORGANIZATION:int = 1;
      
      protected static const ReflushBlankTime:int = 1000;
      
      protected var FGoalData:TOrganizationalWarGoalData;
      
      protected var FScrollBar:TScrollBar;
      
      protected var FReportAddr:Vector.<String>;
      
      protected var FReportItems:Vector.<DisplayObject>;
      
      protected var FTextFildRanksName:Vector.<TextField>;
      
      protected var FTextFildRanksRecord:Vector.<TextField>;
      
      protected var FUITab:TUITab;
      
      protected var FRankName:TextField;
      
      protected var FBtn_Inspirit:SimpleButton;
      
      protected var FHint_Inspirit:THint;
      
      protected var FMC_OrganizationInspirit:MovieClip;
      
      protected var FMC_PlayerInspirit:MovieClip;
      
      protected var FTF_WinTimes:TextField;
      
      protected var FTF_PlayerRecord:TextField;
      
      protected var FTF_PlayerRank:TextField;
      
      protected var FTF_OrganizationRecord:TextField;
      
      protected var FTF_OrganizationRank:TextField;
      
      protected var FTF_ColdDownTime:TextField;
      
      protected var FBTN_ClearTime:SimpleButton;
      
      protected var FDieTimeCoolDown:TTimeCoolDown;
      
      protected var FBTN_AutoBattle:MovieClip;
      
      protected var FAutoBattleState:int;
      
      protected var FTF_SiliverCoin:TextField;
      
      protected var FTF_GoldCoin:TextField;
      
      protected var FTF_GiftCoin:TextField;
      
      protected var FRemindTime:MovieClip;
      
      protected var FMC_High:MovieClip;
      
      protected var FMC_Low:MovieClip;
      
      protected var FActiveDescribtion:MovieClip;
      
      protected var FHelpTips:THint;
      
      protected var FSystemTimeCoolDown:TTimeCoolDown;
      
      protected var FTickStore:int;
      
      protected var FUIWindowInformation:TUIWindowInformation;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FConfirmationWaitBack:Boolean;
      
      protected var FParameters:TLobbyParameters;
      
      protected var FActuatorBarrierAction:Boolean;
      
      protected var FOrganizationalWarCoolDown:TTimeCoolDown;
      
      protected var FActivityColdTime:TextField;
      
      protected var FTimeRecord:uint;
      
      protected var FCommandRequet:Function;
      
      protected var FOnHintOver:Function;
      
      protected var FOnHintOut:Function;
      
      protected var FGobackCity:Function;
      
      protected var FOnHelpTipsOver:Function;
      
      protected var FOnHelpTipsOut:Function;
      
      public function TProcessorWindowOrganizationalWar(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1);
         this.FParameters = param2;
         this.FOrganizationalWarCoolDown = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_OrganizationalWar_ActiveColdTime);
         SLogicsCore.TimeCoolDowns.Add(this.FOrganizationalWarCoolDown);
         this.FSystemTimeCoolDown = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_OrganizationalWar_SystemColdTime);
         SLogicsCore.TimeCoolDowns.Add(this.FSystemTimeCoolDown);
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         this.BattleReportUIDispatch(param1);
         this.RankUIDispatch(param1);
         this.RemaindTimeUIDispatch(param1);
         this.PlayerInforUIDispatch(param1);
         this.InspiritUIDispatch(param1);
         this.FUIWindowInformation = SUtilityOverLayer.UIWindowInformation;
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
      }
      
      public function UILocations() : void
      {
         this.BattleReportUILocation();
         this.RankUILocation();
         this.RemaindTimeUILocation();
         this.PlayerInforUILocation();
         this.InspiritUILocation();
         FIsResourcesLoadCompleted = true;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         if(SLogicsCore.Character.RoleSencePosition != CONST_COMMON.SCENEPOSITION_ORGANIZATIONWAR)
         {
            return;
         }
         this.CheckIfActiveOver();
         this.UpdateSystemColdTime();
         this.UpdateDieColdTime();
         this.UpdateActivityColdTime();
         if(STimingCore.TickCount - this.FTickStore > ReflushBlankTime)
         {
            this.UpdateInspiritBtn();
            this.FTickStore = STimingCore.TickCount;
         }
      }
      
      protected function UpdateActivityColdTime() : void
      {
         if(this.FTimeRecord != this.FOrganizationalWarCoolDown.TimingTime)
         {
            this.FActivityColdTime.text = TUtilityTiming.fomatTime(this.FOrganizationalWarCoolDown.TimingTime);
            this.FTimeRecord = this.FOrganizationalWarCoolDown.TimingTime;
         }
      }
      
      protected function CheckIfActiveOver() : void
      {
         if(!this.FGoalData.Running)
         {
            if(!this.FConfirmationWaitBack)
            {
               this.FUIWindowInformation.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_16);
               this.FUIWindowInformation.OnOK = this.GoBackConfirm;
               this.FUIWindowInformation.Visible = true;
               this.FConfirmationWaitBack = true;
               this.FSystemTimeCoolDown.TimingTime = 0;
               this.FRemindTime.visible = false;
            }
         }
      }
      
      protected function GoBackConfirm(param1:Object) : void
      {
         if(this.FGobackCity != null)
         {
            this.FGobackCity(this);
            if(this.FActuatorBarrierAction)
            {
               this.FParameters.ActuatorBarrier.Deactuate(this.FRemindTime);
               this.FActuatorBarrierAction = false;
               this.FRemindTime.visible = false;
            }
         }
      }
      
      protected function BattleReportUIDispatch(param1:MovieClip) : void
      {
         var _loc2_:String = null;
         this.FScrollBar = new TScrollBar(param1["mc_list"],84,true,1,20);
         this.FScrollBar.ScrollToUp();
         this.FReportAddr = new Vector.<String>();
         this.FReportItems = new Vector.<DisplayObject>();
      }
      
      protected function BattleReportUILocation() : void
      {
      }
      
      private function BattleReportTextClick(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:SimpleButton = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         _loc3_ = param1.currentTarget as SimpleButton;
         _loc2_ = _loc3_.parent as MovieClip;
         _loc4_ = this.FReportItems.indexOf(_loc2_);
         _loc5_ = this.FReportAddr[_loc4_];
         SExternalCore.NavigateToBattleReportUrl(_loc5_);
      }
      
      protected function RankUIDispatch(param1:MovieClip) : void
      {
         var _loc2_:int = 0;
         this.FTextFildRanksName = new Vector.<TextField>();
         this.FTextFildRanksRecord = new Vector.<TextField>();
         this.FUITab = new TUITab(this);
         this.FUITab.SetTabByIndex(param1["Tab1"],TAB_INDEX_PLAYER);
         if(param1["Tab1"]["TabName"] != null)
         {
            param1["Tab1"]["TabName"].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_24);
            param1["Tab1"]["TabName"].mouseEnabled = false;
         }
         this.FUITab.SetTabByIndex(param1["Tab2"],TAB_INDEX_ORGANIZATION);
         if(param1["Tab2"]["TabName"] != null)
         {
            param1["Tab2"]["TabName"].text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_23);
            param1["Tab2"]["TabName"].mouseEnabled = false;
         }
         this.FRankName = param1["RankName"];
         this.FUITab.OnSwitch = this.SwitchTab;
         this.FUITab.Init();
         _loc2_ = 0;
         while(_loc2_ < CONST_ORGANIZATIONALWAR.RankInforNum)
         {
            this.FTextFildRanksName.push(param1["Name" + (_loc2_ + 1)]);
            this.FTextFildRanksRecord.push(param1["Value" + (_loc2_ + 1)]);
            _loc2_++;
         }
      }
      
      protected function RankUILocation() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < CONST_ORGANIZATIONALWAR.RankInforNum)
         {
            this.FTextFildRanksName[_loc1_].text = "";
            this.FTextFildRanksRecord[_loc1_].text = "";
            _loc1_++;
         }
         this.FRankName.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_21);
      }
      
      protected function RankUpdate_Perform() : void
      {
         var _loc1_:int = 0;
         switch(this.FUITab.TabIndex)
         {
            case TAB_INDEX_PLAYER:
               this.FillRankInfor(this.FGoalData.PlayerRankInfors,this.FGoalData.PlayerRankActiveNum);
               _loc1_ = this.FGoalData.PlayerRankActiveNum;
               this.FRankName.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_21);
               break;
            case TAB_INDEX_ORGANIZATION:
               this.FillRankInfor(this.FGoalData.OrganizationRankInfors,this.FGoalData.OrganizationRankActiveNum);
               _loc1_ = this.FGoalData.OrganizationRankActiveNum;
               this.FRankName.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_22);
         }
         while(_loc1_ < this.FTextFildRanksName.length)
         {
            this.FTextFildRanksName[_loc1_].text = "";
            this.FTextFildRanksRecord[_loc1_].text = "";
            _loc1_++;
         }
      }
      
      protected function FillRankInfor(param1:Vector.<TRankInfor>, param2:int) : void
      {
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param2)
         {
            this.FTextFildRanksName[_loc3_].text = _loc3_ + 1 + "." + param1[_loc3_].Describtion;
            this.FTextFildRanksRecord[_loc3_].text = param1[_loc3_].KeyValue.toString();
            _loc3_++;
         }
      }
      
      protected function SwitchTab(param1:int) : void
      {
         this.RankUpdate();
      }
      
      protected function InspiritUIDispatch(param1:MovieClip) : void
      {
         this.FBtn_Inspirit = param1["Btn_Inspirit"];
         this.FMC_OrganizationInspirit = param1["Organization_Inspirit"];
         this.FMC_PlayerInspirit = param1["Player_Inspirit"];
         this.FHint_Inspirit = new THint();
      }
      
      protected function InspiritUILocation() : void
      {
         this.FBtn_Inspirit.addEventListener(MouseEvent.CLICK,this.InspiritConfirm);
         this.FMC_OrganizationInspirit.addEventListener(MouseEvent.MOUSE_OVER,this.MouseOverInspirit);
         this.FMC_OrganizationInspirit.addEventListener(MouseEvent.MOUSE_OUT,this.MouseOutInspirit);
         this.FMC_OrganizationInspirit.buttonMode = true;
         this.FMC_PlayerInspirit.addEventListener(MouseEvent.MOUSE_OVER,this.MouseOverInspirit);
         this.FMC_PlayerInspirit.addEventListener(MouseEvent.MOUSE_OUT,this.MouseOutInspirit);
         this.FMC_PlayerInspirit.buttonMode = true;
      }
      
      protected function UpdateInspiritBtn() : void
      {
         if(this.FGoalData.CurrentInspironNum >= this.FGoalData.InspironData.length)
         {
            this.FBtn_Inspirit.filters = [TUtilityFilter.gBlackFilters];
            this.FBtn_Inspirit.mouseEnabled = false;
         }
         else
         {
            this.FBtn_Inspirit.filters = null;
            this.FBtn_Inspirit.mouseEnabled = true;
         }
      }
      
      protected function InspiritConfirm(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this.FGoalData.CurrentInspironNum >= this.FGoalData.InspironCost.length)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_5));
            return;
         }
         _loc2_ = int(this.FGoalData.InspironCost[this.FGoalData.CurrentInspironNum]);
         this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_3),_loc2_);
         this.FUIWindowConfirmation.OnOK = this.OnClickInspiritBtn;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function OnClickInspiritBtn(param1:Object) : void
      {
         if(this.FCommandRequet != null)
         {
            this.FCommandRequet(CONST_ORGANIZATIONALWAR.CommandID_Inspirit,0,this.InspiritInforSet);
         }
      }
      
      protected function InspiritInforSet(param1:uint) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.FGoalData.CurrentInspironNum == 0)
         {
            _loc3_ = 0;
         }
         else
         {
            _loc3_ = int(this.FGoalData.InspironData[this.FGoalData.CurrentInspironNum - 1]);
         }
         this.FGoalData.CurrentInspironNum = param1;
         this.PlayerInforUpdate();
         _loc4_ = int(this.FGoalData.InspironData[this.FGoalData.CurrentInspironNum - 1]);
         _loc4_ = _loc4_ - _loc3_;
         _loc2_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_4),_loc4_.toString(),_loc4_.toString());
         EffectGenerateText(_loc2_);
      }
      
      protected function MouseOverInspirit(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc2_ = param1.currentTarget as MovieClip;
         if(_loc2_ == this.FMC_OrganizationInspirit)
         {
            _loc5_ = this.FGoalData.OrganizationAdded / 10;
            _loc6_ = this.FGoalData.OrganizationAdded % 10;
            _loc4_ = _loc5_.toString();
            if(_loc6_ != 0)
            {
               _loc4_ += "." + _loc6_.toString();
            }
            this.FHint_Inspirit.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_7),_loc4_);
         }
         else if(this.FGoalData.CurrentInspironNum >= this.FGoalData.InspironData.length)
         {
            this.FHint_Inspirit.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_9),this.FGoalData.InspironData[this.FGoalData.CurrentInspironNum - 1],this.FGoalData.InspironData[this.FGoalData.CurrentInspironNum - 1]);
         }
         else
         {
            if(this.FGoalData.CurrentInspironNum == 0)
            {
               _loc3_ = 0;
            }
            else
            {
               _loc3_ = this.FGoalData.InspironData[this.FGoalData.CurrentInspironNum - 1];
               _loc3_ = this.FGoalData.InspironData[this.FGoalData.CurrentInspironNum - 1];
            }
            this.FHint_Inspirit.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_8),_loc3_,_loc3_,this.FGoalData.InspironData[this.FGoalData.CurrentInspironNum],this.FGoalData.InspironData[this.FGoalData.CurrentInspironNum]);
         }
         if(this.FOnHintOver != null)
         {
            this.FOnHintOver(this,this.FHint_Inspirit);
         }
      }
      
      protected function MouseOutInspirit(param1:MouseEvent) : void
      {
         if(this.FOnHintOut != null)
         {
            this.FOnHintOut(this,this.FHint_Inspirit);
         }
      }
      
      protected function PlayerInforUIDispatch(param1:MovieClip) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = param1["InforTable"];
         this.FTF_WinTimes = _loc2_["ContinueWin"];
         this.FTF_PlayerRecord = _loc2_["CurrentRecord"];
         this.FTF_PlayerRank = _loc2_["CurrentRank"];
         this.FTF_OrganizationRecord = _loc2_["OrganizationalRecord"];
         this.FTF_OrganizationRank = _loc2_["OrganizationalRank"];
         this.FTF_ColdDownTime = _loc2_["ColdTime"];
         this.FBTN_ClearTime = _loc2_["Btn_Cleartime"];
         this.FBTN_AutoBattle = _loc2_["task"];
         this.FTF_SiliverCoin = param1["TF_Siliver"];
         this.FTF_GoldCoin = param1["TF_Gold"];
         this.FTF_GiftCoin = param1["TF_GiftMoney"];
         this.FDieTimeCoolDown = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_OrganizationalWar_DieColdTime);
         SLogicsCore.TimeCoolDowns.Add(this.FDieTimeCoolDown);
      }
      
      protected function PlayerInforUILocation() : void
      {
         this.FTF_WinTimes.text = "";
         this.FTF_PlayerRecord.text = "";
         this.FTF_PlayerRank.text = "";
         this.FTF_OrganizationRecord.text = "";
         this.FTF_OrganizationRank.text = "";
         this.FTF_ColdDownTime.text = "";
         this.FTF_SiliverCoin.text = "";
         this.FTF_GoldCoin.text = "";
         this.FTF_GiftCoin.text = "";
         this.FBTN_ClearTime.addEventListener(MouseEvent.CLICK,this.ClearColdTimeConfirm);
         this.FBTN_AutoBattle.addEventListener(MouseEvent.CLICK,this.AutoBattleRequest);
         this.FAutoBattleState = CONST_ORGANIZATIONALWAR.AutoBattle_No;
         this.FBTN_AutoBattle.gotoAndStop(this.FAutoBattleState);
      }
      
      protected function PlayerInforUpdate() : void
      {
         var _loc1_:TCharacter = null;
         _loc1_ = SLogicsCore.Character;
         this.FTF_SiliverCoin.text = _loc1_.CreditSilverCoin.ToString();
         this.FTF_GoldCoin.text = _loc1_.CreditGold.toString();
         this.FTF_GiftCoin.text = _loc1_.CreditGiftCertificate.toString();
         this.FTF_WinTimes.text = this.FGoalData.WinTimes.toString();
         this.FTF_PlayerRecord.text = this.FGoalData.PlayerRecord.toString();
         this.FTF_PlayerRank.text = this.FGoalData.PlayerRank.toString();
         this.FTF_OrganizationRecord.text = this.FGoalData.OrganizationRecord.toString();
         this.FTF_OrganizationRank.text = this.FGoalData.OrganizationRank.toString();
      }
      
      protected function ClearColdTimeConfirm(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this.FDieTimeCoolDown.TimingTime <= 0)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_11));
            return;
         }
         _loc2_ = Math.ceil(this.FDieTimeCoolDown.TimingTime / 10);
         this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_2),_loc2_.toString());
         this.FUIWindowConfirmation.OnOK = this.ClearColdTime;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function ClearColdTime(param1:Object) : void
      {
         if(this.FCommandRequet != null)
         {
            this.FCommandRequet(CONST_ORGANIZATIONALWAR.CommandID_ClearColdTime,0,this.ClearColdTimeSet);
         }
      }
      
      protected function ClearColdTimeSet(param1:uint) : void
      {
         this.FDieTimeCoolDown.TimingTime = 0;
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_12));
         this.PlayerInforUpdate();
      }
      
      protected function UpdateDieColdTime() : void
      {
         this.FTF_ColdDownTime.text = TUtilityTiming.fomatTime(this.FDieTimeCoolDown.TimingTime);
      }
      
      protected function AutoBattleRequest(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this.FCommandRequet != null)
         {
            _loc2_ = this.FAutoBattleState == CONST_ORGANIZATIONALWAR.AutoBattle_Yes ? 0 : 1;
            this.FCommandRequet(CONST_ORGANIZATIONALWAR.CommandID_AutoFight,_loc2_,this.AutoBattleSet);
         }
      }
      
      protected function AutoBattleSet(param1:uint) : void
      {
         this.FAutoBattleState = this.FAutoBattleState == CONST_ORGANIZATIONALWAR.AutoBattle_No ? CONST_ORGANIZATIONALWAR.AutoBattle_Yes : CONST_ORGANIZATIONALWAR.AutoBattle_No;
         this.FBTN_AutoBattle.gotoAndStop(this.FAutoBattleState);
      }
      
      protected function RemaindTimeUIDispatch(param1:MovieClip) : void
      {
         this.FRemindTime = param1["RemindTime"];
         this.FMC_High = this.FRemindTime["High"];
         this.FMC_Low = this.FRemindTime["Low"];
         this.FActiveDescribtion = param1["ActiveCommit"];
         this.FActivityColdTime = param1["tf_time"];
         this.FHelpTips = new THint();
      }
      
      protected function RemaindTimeUILocation() : void
      {
         this.FRemindTime.visible = false;
         this.FActiveDescribtion.buttonMode = true;
         this.FActiveDescribtion.addEventListener(MouseEvent.MOUSE_OVER,this.ActivityDescribtionMouseOver);
         this.FActiveDescribtion.addEventListener(MouseEvent.MOUSE_OUT,this.ActivityDescribtionMouseOut);
      }
      
      protected function UpdateSystemColdTime() : void
      {
         var _loc1_:int = 0;
         this.FRemindTime.visible = this.FSystemTimeCoolDown.TimingTime > 0;
         if(this.FRemindTime.visible)
         {
            if(!this.FActuatorBarrierAction)
            {
               this.FParameters.ActuatorBarrier.Actuate(this.FRemindTime);
               this.FActuatorBarrierAction = true;
            }
         }
         else if(this.FActuatorBarrierAction)
         {
            this.FParameters.ActuatorBarrier.Deactuate(this.FRemindTime);
            this.FActuatorBarrierAction = false;
         }
         if(!this.FRemindTime.visible)
         {
            return;
         }
         if(this.FSystemTimeCoolDown.TimingTime > 99)
         {
            this.FMC_High.gotoAndStop(10);
            this.FMC_Low.gotoAndStop(10);
         }
         else
         {
            _loc1_ = this.FSystemTimeCoolDown.TimingTime / 10 + 1;
            this.FMC_High.gotoAndStop(_loc1_);
            _loc1_ = this.FSystemTimeCoolDown.TimingTime % 10 + 1;
            this.FMC_Low.gotoAndStop(_loc1_);
         }
      }
      
      protected function ActivityDescribtionMouseOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_OrganizationalWar);
         }
         if(this.FOnHelpTipsOver != null)
         {
            this.FOnHelpTipsOver(this,this.FHelpTips);
         }
      }
      
      protected function ActivityDescribtionMouseOut(param1:MouseEvent) : void
      {
         if(this.FOnHelpTipsOut != null)
         {
            this.FOnHelpTipsOut(this,this.FHelpTips);
         }
      }
      
      public function set GoalData(param1:TOrganizationalWarGoalData) : void
      {
         this.FGoalData = param1;
      }
      
      public function get CommandRequet() : Function
      {
         return this.FCommandRequet;
      }
      
      public function set CommandRequet(param1:Function) : void
      {
         this.FCommandRequet = param1;
      }
      
      public function set OnHintOver(param1:Function) : void
      {
         this.FOnHintOver = param1;
      }
      
      public function set OnHintOut(param1:Function) : void
      {
         this.FOnHintOut = param1;
      }
      
      public function set GobackCity(param1:Function) : void
      {
         this.FGobackCity = param1;
      }
      
      public function set OnHelpTipsOver(param1:Function) : void
      {
         this.FOnHelpTipsOver = param1;
      }
      
      public function set OnHelpTipsOut(param1:Function) : void
      {
         this.FOnHelpTipsOut = param1;
      }
      
      public function BattleReport(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:String = null;
         var _loc6_:ByteArray = null;
         var _loc7_:String = null;
         var _loc8_:TUIOrganizationalWarPlayer = null;
         var _loc9_:MovieClip = null;
         _loc6_ = param1.Data;
         _loc2_ = _loc6_.readUnsignedInt();
         _loc3_ = _loc6_.readUnsignedInt();
         _loc4_ = _loc6_.readUnsignedByte();
         _loc5_ = TUtilityString.FetchUTF(_loc6_);
         this.FReportAddr.splice(0,0,_loc5_);
         if(_loc4_ == 1)
         {
            _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_0);
         }
         else
         {
            _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.OrganizationalWar_STRING_1);
         }
         _loc8_ = this.FGoalData.OrganizationRole.GetRoleByIdentifier(_loc2_,_loc3_);
         _loc7_ = TUtilityString.Format(_loc7_,_loc8_.RoleData.Name);
         _loc9_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_CITYDEFEND.RESOURCE_ClassName_MC_Report) as MovieClip;
         _loc9_.btn_look.addEventListener(MouseEvent.MOUSE_UP,this.BattleReportTextClick);
         _loc9_.tf_info.htmlText = _loc7_;
         this.FReportItems.splice(0,0,_loc9_);
         this.FScrollBar.Clear();
         this.FScrollBar.AddItems(this.FReportItems);
         this.FScrollBar.ScrollToUp();
      }
      
      public function Reset() : void
      {
         this.FConfirmationWaitBack = false;
         this.FAutoBattleState = CONST_ORGANIZATIONALWAR.AutoBattle_No;
         if(this.FBTN_AutoBattle != null)
         {
            this.FBTN_AutoBattle.gotoAndStop(this.FAutoBattleState);
         }
      }
      
      public function RankUpdate() : void
      {
         this.RankUpdate_Perform();
         this.PlayerInforUpdate();
      }
   }
}

