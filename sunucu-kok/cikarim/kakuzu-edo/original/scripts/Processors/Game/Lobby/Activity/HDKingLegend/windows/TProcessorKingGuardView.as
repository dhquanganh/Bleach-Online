package Processors.Game.Lobby.Activity.HDKingLegend.windows
{
   import Components.Standard.TUIButton;
   import Externals.SExternalCore;
   import Foundation.Common.THint;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Agent.SParametersCore;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.DatebaseVO.VO.THDKingGuard;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDKingLegend.TActivityKingGuardData;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.TUIWindowConfirmation;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorKingGuardView extends TProcessorLobbyWindow
   {
      
      protected static const Guard_Count:int = 5;
      
      protected var FMainUI:Sprite;
      
      protected var FMCPrompt:Sprite;
      
      protected var FTFOpenTime:TextField;
      
      protected var FTFCoolingTime:TextField;
      
      protected var FTFDesc:TextField;
      
      protected var FTFFreeCount:TextField;
      
      protected var FTFFirstPay:TextField;
      
      protected var FTFPayCount:TextField;
      
      protected var FBtnStartGame:TUIButton;
      
      protected var FBtnRecharge:TUIButton;
      
      protected var FTFChipCountVec:Vector.<TextField>;
      
      protected var FBtnExchangeVec:Vector.<TUIButton>;
      
      protected var FBtnBuyVec:Vector.<TUIButton>;
      
      protected var FConfigValue:THDKingGuard;
      
      protected var FGameView:TKingGuardGameView;
      
      protected var FExchangeView:TKingGuardExchangeView;
      
      protected var FSendData:Function;
      
      protected var FBuyBtnGroup:Sprite;
      
      protected var FBuyIndex:int;
      
      protected var FHint:THint;
      
      protected var FActivityKingGuardData:TActivityKingGuardData;
      
      public function TProcessorKingGuardView(param1:TUIComponent, param2:Sprite)
      {
         super(param1);
         this.FMainUI = param2;
         this.FTFChipCountVec = new Vector.<TextField>();
         this.FBtnExchangeVec = new Vector.<TUIButton>();
         this.FBtnBuyVec = new Vector.<TUIButton>();
         this.InitWindow();
      }
      
      protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUIButton = null;
         this.FMCPrompt = this.FMainUI["MC_Prompt"];
         this.FTFOpenTime = this.FMCPrompt["TF_OpenTime"];
         this.FTFCoolingTime = this.FMCPrompt["TF_CoolingTime"];
         this.FTFDesc = this.FMCPrompt["TF_Desc"];
         this.FTFFreeCount = this.FMainUI["TF_FreeCount"];
         this.FTFFirstPay = this.FMainUI["TF_FirstPay"];
         this.FTFPayCount = this.FMainUI["TF_PayCount"];
         this.FBtnStartGame = new TUIButton();
         this.FBtnStartGame.Substrate = this.FMainUI["Btn_Start"];
         this.FBtnStartGame.OnClick = this.BtnStartOnClick;
         this.FBtnStartGame.OnMove = this.BtnStartOnMove;
         this.FBtnStartGame.OnOut = this.BtnStartOnOut;
         this.FBtnRecharge = new TUIButton();
         this.FBtnRecharge.Substrate = this.FMainUI["Btn_Recharge"];
         this.FBtnRecharge.OnClick = this.BtnRechangeOnClick;
         this.FBuyBtnGroup = this.FMainUI["MC_BuyBtns"];
         this.FHint = new THint();
         _loc1_ = 0;
         while(_loc1_ < Guard_Count)
         {
            _loc2_ = new TUIButton();
            _loc2_.Substrate = this.FMainUI["Btn_Exchange_" + _loc1_];
            _loc2_.OnClick = this.BtnExchangeOnClick;
            this.FBtnExchangeVec.push(_loc2_);
            this.FTFChipCountVec.push(this.FMainUI["TF_Count_" + _loc1_]);
            _loc2_ = new TUIButton();
            _loc2_.Substrate = this.FBuyBtnGroup["Btn_Buy_" + _loc1_];
            _loc2_.OnClick = this.BtnBuyOnClick;
            _loc2_.OnMove = this.BtnBuyOnMove;
            _loc2_.OnOut = this.BtnBuyOnOut;
            this.FBtnBuyVec.push(_loc2_);
            _loc1_++;
         }
         this.FGameView = new TKingGuardGameView(FParent,this.FMainUI["MC_Game"]);
         this.FGameView.SendData = this.SendServiceData;
         this.FExchangeView = new TKingGuardExchangeView(this);
         this.FExchangeView.SendData = this.SendServiceData;
         FParent.addChild(this.FExchangeView);
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         this.FTFFreeCount.text = this.FActivityKingGuardData.FreeCount + "";
         this.FTFFirstPay.text = this.FConfigValue.RechargeMoney + "";
         this.FTFPayCount.text = this.FConfigValue.RechargeCount + "";
         this.FBuyBtnGroup.visible = this.FActivityKingGuardData.CurDay >= this.FConfigValue.BuyDay;
         _loc1_ = 0;
         while(_loc1_ < Guard_Count)
         {
            this.FTFChipCountVec[_loc1_].text = this.FActivityKingGuardData.GetChip(this.FConfigValue.GetGuardType(_loc1_)) + "";
            _loc1_++;
         }
         this.UpdateMoraGame();
         if(this.FExchangeView.Visible)
         {
            this.FExchangeView.UpdateAwardData();
         }
      }
      
      protected function SendServiceData(param1:int) : void
      {
         if(this.FSendData != null)
         {
            this.FSendData(param1);
         }
      }
      
      protected function BtnExchangeOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:int = 0;
         _loc3_ = param1 as TUIButton;
         _loc4_ = this.FBtnExchangeVec.indexOf(param1);
         if(_loc4_ != -1)
         {
            this.FExchangeView.Show(this.FConfigValue.KingIndexs[_loc4_]);
         }
      }
      
      protected function BtnBuyOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TUIButton = null;
         var _loc4_:int = 0;
         var _loc5_:TUIWindowConfirmation = null;
         var _loc6_:String = null;
         _loc3_ = param1 as TUIButton;
         _loc4_ = this.FBtnBuyVec.indexOf(param1);
         if(_loc4_ != -1)
         {
            if(this.FConfigValue.ChipCosts[_loc4_] > SLogicsCore.Character.CreditGold)
            {
               SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.NOTENOUGH_Gold));
               return;
            }
            _loc5_ = SUtilityOverLayer.UIWindowConfirmation;
            _loc6_ = TUtilityString.Format(this.FConfigValue.GetString(5),this.FConfigValue.ChipCosts[_loc4_],this.FConfigValue.GetString(_loc4_));
            _loc5_.Text = _loc6_;
            _loc5_.OnOK = this.AlertOnBuy;
            _loc5_.Visible = true;
            this.FBuyIndex = this.FConfigValue.LastDayIndexs[_loc4_];
         }
      }
      
      protected function BtnBuyOnMove(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TUIButton = null;
         var _loc5_:int = 0;
         _loc4_ = param1 as TUIButton;
         _loc3_ = this.FBtnBuyVec.indexOf(_loc4_);
         if(_loc3_ != -1)
         {
            _loc5_ = this.FConfigValue.ChipCosts[_loc3_];
         }
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_02),_loc5_);
         SUtilityOverLayer.UIComponentsHintOnOver(FParent,this.FHint);
      }
      
      protected function BtnBuyOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(FParent,this.FHint);
      }
      
      protected function AlertOnBuy(param1:Object) : void
      {
         this.SendServiceData(this.FBuyIndex);
      }
      
      protected function BtnStartOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FGameView.Show(this.FActivityKingGuardData.CurGuard);
      }
      
      protected function BtnStartOnMove(param1:Object, param2:MouseEvent) : void
      {
         if(this.FActivityKingGuardData.FreeCount > 0)
         {
            return;
         }
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELLBUTTERFLY_STRING_02),this.FConfigValue.GameCost);
         SUtilityOverLayer.UIComponentsHintOnOver(FParent,this.FHint);
      }
      
      protected function BtnStartOnOut(param1:Object, param2:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(FParent,this.FHint);
      }
      
      protected function BtnRechangeOnClick(param1:Object, param2:MouseEvent) : void
      {
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      public function set ActivityKingGuardData(param1:TActivityKingGuardData) : void
      {
         this.FActivityKingGuardData = param1;
         this.FGameView.ActivityData = this.FActivityKingGuardData;
         this.FExchangeView.ActivityData = this.FActivityKingGuardData;
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FExchangeView.OnCreateKnifeOfKillSoulData = param1;
      }
      
      public function get SendData() : Function
      {
         return this.FSendData;
      }
      
      public function set SendData(param1:Function) : void
      {
         this.FSendData = param1;
      }
      
      public function ShowView(param1:TActivityAtoms = null, param2:THDActivityBase = null) : void
      {
         this.FConfigValue = param2 as THDKingGuard;
         this.FGameView.Data = this.FConfigValue;
         this.FExchangeView.Data = this.FConfigValue;
         this.UpdateUI();
      }
      
      public function UpdateMoraGame() : void
      {
         if(this.FGameView.Visible && this.FActivityKingGuardData.IsResult)
         {
            this.FGameView.UpdateGame(this.FActivityKingGuardData.Result);
         }
      }
   }
}

