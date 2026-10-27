package Processors.Game.Lobby.Activity.HDTeamBuy
{
   import Components.Standard.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityOS.*;
   import Logics.HDTeamBuy.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDWindowTeamBuyGetBuy extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_SLOT_AWARD:uint = 4;
      
      protected static const STATUS_BUY_Normal:int = -1;
      
      protected static const STATUS_BUY_Buying:int = 0;
      
      protected static const STATUS_BUY_EndBuy:int = 1;
      
      protected var FTF_BuyCoolingTime:TextField;
      
      protected var FMC_BuyAward:TUIActivityOSAwardList;
      
      protected var FTF_Title:TextField;
      
      protected var FTF_OriginalPrice:TextField;
      
      protected var FTF_CurBuyPrice:TextField;
      
      protected var FTF_FavorablePrice:TextField;
      
      protected var FTF_EndBuy:TextField;
      
      protected var FTF_BuyOKPeople:TextField;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FData_TeamBuy:TActivityTeamBuy;
      
      protected var FHD_TeamBuy:THDTeamBuy;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FCurAward:TActivityTBAward;
      
      protected var FIsInitData:Boolean;
      
      protected var FStatusSign:int;
      
      public function TProcessorHDWindowTeamBuyGetBuy(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ActivitySingleTeamBuyGetBuy;
         this.FIsInitWindow = false;
         FActivityID = CONST_ACTIVITY_MODE.Activity_LimitBuy;
         this.FIsInitData = false;
         this.FStatusSign = STATUS_BUY_Normal;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FIsInitWindow)
         {
            this.FMC_BuyAward.UpDateSlot();
         }
         if(this.FIsInitData)
         {
            this.CheckCoolingTime();
         }
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Sprite = null;
         super.InitWindow(param1);
         this.FTF_BuyCoolingTime = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_BuyCoolingTime];
         this.FMC_BuyAward = new TUIActivityOSAwardList(this);
         this.FMC_BuyAward.OnSlotOver = ProcessorOnSlotOver;
         this.FMC_BuyAward.OnSlotOut = ProcessorOnSlotOut;
         this.FMC_BuyAward.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
         this.FMC_BuyAward.OnQuerySubscript = SlotsOnQuerySubscript;
         this.FMC_BuyAward.Perform_UIDispatch(FScene[CONST_ACTIVITY.RESOURCE_Link_MC_BuyAward],0,COUNT_SLOT_AWARD,false);
         this.FTF_Title = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_Name];
         this.FTF_Title.mouseEnabled = false;
         this.FTF_OriginalPrice = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_OriginalPrice];
         this.FTF_OriginalPrice.mouseEnabled = false;
         this.FTF_CurBuyPrice = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_CurSignPrice];
         this.FTF_CurBuyPrice.mouseEnabled = false;
         this.FTF_FavorablePrice = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_FavorablePrice];
         this.FTF_FavorablePrice.mouseEnabled = false;
         this.FTF_EndBuy = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_EndBuy];
         this.FTF_EndBuy.mouseEnabled = false;
         this.FTF_BuyOKPeople = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_BuyOKPeople];
         this.FTF_BuyOKPeople.mouseEnabled = false;
         this.FBtn_OK = new TUIButton();
         this.FBtn_OK.Substrate = FScene[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
         this.FBtn_OK.OnClick = this.BtnBuyOnClick;
         this.ResetTextField();
         this.FIsInitWindow = true;
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHD_TeamBuy = FHDActivityConfig as THDTeamBuy;
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:Vector.<uint> = null;
         super.UpdateDataBase(param1);
         this.FData_TeamBuy = param1 as TActivityTeamBuy;
         this.FCurAward = this.FData_TeamBuy.TBCurAward;
         _loc2_ = new Vector.<uint>();
         _loc2_.push(this.FCurAward.Award);
         FInventoriesVect = ProcessorGetInventoriesVectByAwardID(_loc2_);
         this.UpdateUI();
         this.FIsInitData = true;
      }
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
         this.FMC_BuyAward.UpDateUI(this.FData_TeamBuy.TBBuyBox.Index,FInventoriesVect[0]);
         this.FMC_BuyAward.UpdateUIPage();
         this.FTF_Title.text = this.FCurAward.Title;
         this.FTF_OriginalPrice.text = this.FCurAward.Cost.toString();
         this.FTF_FavorablePrice.text = (this.FCurAward.Cost - this.FData_TeamBuy.TBCurPirce).toString();
         this.FTF_EndBuy.text = this.FHD_TeamBuy.TBPrompt.StrEndBuy;
         this.FTF_BuyOKPeople.text = TUtilityString.Format(this.FHD_TeamBuy.TBPrompt.StrBoughtPeople,this.FData_TeamBuy.TBBoughtPeople);
         this.FTF_CurBuyPrice.text = this.FData_TeamBuy.TBCurPirce.toString();
         this.UpdateUIButton();
      }
      
      protected function CheckCoolingTime() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = uint(STimingCore.ServerTick);
         if(_loc1_ >= this.FData_TeamBuy.TBTimeStartBuy && _loc1_ <= this.FData_TeamBuy.TBTimeEndBuy)
         {
            this.FTF_BuyCoolingTime.text = FormatTime(this.FData_TeamBuy.TBTimeEndBuy - _loc1_);
            if(this.FStatusSign != STATUS_BUY_Buying)
            {
               if(this.FData_TeamBuy.TBSignBox.BoxStatus == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
               {
                  this.FBtn_OK.Visible = true;
                  this.FTF_EndBuy.visible = false;
               }
               else
               {
                  this.FBtn_OK.Visible = false;
                  this.FTF_EndBuy.visible = true;
               }
            }
            this.FStatusSign = STATUS_BUY_Buying;
         }
         else if(_loc1_ > this.FData_TeamBuy.TBTimeEndBuy && _loc1_ <= this.FData_TeamBuy.TBTimeTwentyFour)
         {
            if(this.FStatusSign != STATUS_BUY_EndBuy)
            {
               if(this.FData_TeamBuy.TBBuyBox.BoxStatus == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
               {
                  this.FBtn_OK.Visible = false;
                  this.FTF_EndBuy.visible = true;
               }
               else
               {
                  this.FBtn_OK.Visible = true;
                  this.FTF_EndBuy.visible = false;
               }
            }
            this.FStatusSign = STATUS_BUY_EndBuy;
         }
         else if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick(this);
         }
      }
      
      protected function UpdateUIButton() : void
      {
         if(this.FData_TeamBuy.TBBuyBox.BoxStatus == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
         {
            this.FBtn_OK.Caption = this.FHD_TeamBuy.TBPrompt.StrBtnBought;
            this.FBtn_OK.Enabled = false;
         }
         else
         {
            this.FBtn_OK.Caption = this.FHD_TeamBuy.TBPrompt.StrBtnBuy;
            this.FBtn_OK.Enabled = true;
         }
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.ResetTextField();
         this.FMC_BuyAward.Clear();
         this.FIsInitData = false;
      }
      
      protected function ResetTextField() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(!this.FIsInitWindow)
         {
            return;
         }
         this.FTF_BuyCoolingTime.text = "";
         this.FTF_Title.text = "";
         this.FTF_OriginalPrice.text = "";
         this.FTF_CurBuyPrice.text = "";
         this.FTF_FavorablePrice.text = "";
         this.FTF_EndBuy.text = "";
         this.FTF_BuyOKPeople.text = "";
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick(this);
         }
      }
      
      protected function BtnBuyOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(FCharacter.CreditGold >= this.FData_TeamBuy.TBCurPirce)
         {
            FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_59),this.FData_TeamBuy.TBCurPirce);
            FUIWindowConfirmation.OnOK = this.WindowInformationOnOK;
            FUIWindowConfirmation.Visible = true;
         }
         else
         {
            FUIWindowRecharge.Visible = true;
         }
      }
      
      override protected function WindowInformationOnOK(param1:Object) : void
      {
         super.WindowInformationOnOK(param1);
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData_TeamBuy.TBBuyBox.Index);
      }
   }
}

