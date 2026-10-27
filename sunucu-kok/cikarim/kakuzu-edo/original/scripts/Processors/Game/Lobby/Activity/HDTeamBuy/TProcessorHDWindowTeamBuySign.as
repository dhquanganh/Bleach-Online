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
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorHDWindowTeamBuySign extends TProcessorHDSingleWindowBase
   {
      
      protected static const COUNT_SLOT_AWARD:uint = 4;
      
      protected static const COUNT_TF_PROMPT:uint = 5;
      
      protected static const WIDTH_TEAMBUY_TotalLevel:uint = 444;
      
      protected static const WIDTH_TEAMBUY_SingleLevel:uint = 88.8;
      
      protected static const STATUS_SIGN_Normal:int = -1;
      
      protected static const STATUS_SIGN_NoSign:int = 0;
      
      protected static const STATUS_SIGN_Signing:int = 1;
      
      protected static const STATUS_SIGN_EndSign:int = 2;
      
      protected var FMC_AwardList:TUIActivityOSAwardList;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FTF_Title:TextField;
      
      protected var FTF_OriginalPrice:TextField;
      
      protected var FTF_CurSignPrice:TextField;
      
      protected var FTF_FavorablePrice:TextField;
      
      protected var FTF_SignPeopleCount:TextField;
      
      protected var FTF_SignCoolingTime:TextField;
      
      protected var FTF_CurPeople:TextField;
      
      protected var FTF_CurPrice:TextField;
      
      protected var FTF_LowPricePeople:TextField;
      
      protected var FMC_Bar:Sprite;
      
      protected var FTF_OKPeopleVect:Vector.<TextField>;
      
      protected var FTF_OKPriceVect:Vector.<TextField>;
      
      protected var FData_TeamBuy:TActivityTeamBuy;
      
      protected var FHD_TeamBuy:THDTeamBuy;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FCurAward:TActivityTBAward;
      
      protected var FStatusSign:int;
      
      protected var FIsInitData:Boolean;
      
      public function TProcessorHDWindowTeamBuySign(param1:TUIComponent)
      {
         super(param1);
         FSceneResourceName = CONST_ACTIVITY.RESOURCE_ClassName_ActivitySingleTeamBuySignUp;
         this.FIsInitWindow = false;
         FActivityID = CONST_ACTIVITY_MODE.Activity_TeamBuy;
         this.FStatusSign = STATUS_SIGN_Normal;
         this.FIsInitData = false;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FIsInitWindow)
         {
            this.FMC_AwardList.UpDateSlot();
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
         _loc4_ = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_SignUp];
         this.FBtn_OK = new TUIButton();
         this.FBtn_OK.Substrate = _loc4_[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
         this.FBtn_OK.OnClick = this.BtnSignOClick;
         this.FBtn_OK.Enabled = false;
         this.FMC_AwardList = new TUIActivityOSAwardList(this);
         this.FMC_AwardList.OnSlotOver = ProcessorOnSlotOver;
         this.FMC_AwardList.OnSlotOut = ProcessorOnSlotOut;
         this.FMC_AwardList.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
         this.FMC_AwardList.OnQuerySubscript = SlotsOnQuerySubscript;
         this.FMC_AwardList.Perform_UIDispatch(_loc4_[CONST_ACTIVITY.RESOURCE_Link_MC_SignAward],0,COUNT_SLOT_AWARD,false);
         this.FTF_Title = _loc4_[CONST_ACTIVITY.RESOURCE_Link_TF_Name];
         this.FTF_Title.mouseEnabled = false;
         this.FTF_OriginalPrice = _loc4_[CONST_ACTIVITY.RESOURCE_Link_TF_OriginalPrice];
         this.FTF_OriginalPrice.mouseEnabled = false;
         this.FTF_CurSignPrice = _loc4_[CONST_ACTIVITY.RESOURCE_Link_TF_CurSignPrice];
         this.FTF_CurSignPrice.mouseEnabled = false;
         this.FTF_FavorablePrice = _loc4_[CONST_ACTIVITY.RESOURCE_Link_TF_FavorablePrice];
         this.FTF_FavorablePrice.mouseEnabled = false;
         this.FTF_SignPeopleCount = _loc4_[CONST_ACTIVITY.RESOURCE_Link_TF_SignPeopleCount];
         this.FTF_SignPeopleCount.mouseEnabled = false;
         this.FTF_SignCoolingTime = _loc4_[CONST_ACTIVITY.RESOURCE_Link_TF_SignCoolingTime];
         this.FTF_SignCoolingTime.mouseEnabled = false;
         this.FTF_CurPeople = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_CurPeople];
         this.FTF_CurPeople.mouseEnabled = false;
         this.FTF_CurPrice = FScene[CONST_ACTIVITY.RESOURCE_Link_TF_CurPrice];
         this.FTF_CurPrice.mouseEnabled = false;
         _loc4_ = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_LowPricePeople];
         _loc4_.mouseChildren = false;
         _loc4_.mouseEnabled = false;
         this.FTF_LowPricePeople = _loc4_[CONST_ACTIVITY.RESOURCE_Link_TF_LowPricePeople];
         this.FTF_LowPricePeople.mouseEnabled = false;
         this.FMC_Bar = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_Bar];
         this.FMC_Bar.mouseEnabled = false;
         this.FMC_Bar.mouseChildren = false;
         _loc3_ = int(COUNT_TF_PROMPT);
         this.FTF_OKPeopleVect = new Vector.<TextField>(_loc3_);
         this.FTF_OKPriceVect = new Vector.<TextField>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = FScene[CONST_ACTIVITY.RESOURCE_Link_MC_PromptVect + _loc2_];
            _loc4_.mouseChildren = false;
            _loc4_.mouseEnabled = false;
            this.FTF_OKPeopleVect[_loc2_] = _loc4_[CONST_ACTIVITY.RESOURCE_Link_TF_OKPeople];
            this.FTF_OKPeopleVect[_loc2_].mouseEnabled = false;
            this.FTF_OKPriceVect[_loc2_] = _loc4_[CONST_ACTIVITY.RESOURCE_Link_TF_OKPrice];
            this.FTF_OKPriceVect[_loc2_].mouseEnabled = false;
            _loc2_++;
         }
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
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.UpdateUI();
         this.FMC_AwardList.UpDateUI(this.FData_TeamBuy.TBSignBox.Index,FInventoriesVect[0]);
         this.FMC_AwardList.UpdateUIPage();
         this.FTF_Title.text = this.FCurAward.Title.toString();
         this.FTF_OriginalPrice.text = this.FCurAward.Cost.toString();
         this.FTF_CurSignPrice.text = this.FTF_CurPrice.text = this.FData_TeamBuy.TBCurPirce.toString();
         this.FTF_FavorablePrice.text = (this.FCurAward.Cost - this.FData_TeamBuy.TBCurPirce).toString();
         this.FTF_CurPeople.text = this.FTF_SignPeopleCount.text = this.FData_TeamBuy.TBSignedPeople.toString();
         this.FTF_LowPricePeople.text = TUtilityString.Format(this.FHD_TeamBuy.TBPrompt.StrPeople,this.FData_TeamBuy.TBFavorablePeople == -1 ? 0 : this.FData_TeamBuy.TBFavorablePeople);
         _loc2_ = int(COUNT_TF_PROMPT);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTF_OKPeopleVect[_loc1_].text = this.FData_TeamBuy.TBOffRatesWithSort[_loc1_].Condition.toString();
            this.FTF_OKPriceVect[_loc1_].text = Math.floor(this.FCurAward.Cost * this.FData_TeamBuy.TBOffRatesWithSort[_loc1_].Value / 1000).toString();
            _loc1_++;
         }
         this.UpdateUIBar();
         this.UpdateUIButton();
      }
      
      protected function UpdateUIBar() : void
      {
         this.FMC_Bar.width = 0;
         if(this.FData_TeamBuy.TBCurLevel == this.FHD_TeamBuy.TBOffRates.length)
         {
            this.FMC_Bar.width = WIDTH_TEAMBUY_TotalLevel;
         }
         else
         {
            this.FMC_Bar.width = this.FData_TeamBuy.TBCurLevel * WIDTH_TEAMBUY_SingleLevel;
         }
      }
      
      protected function UpdateUIButton() : void
      {
         if(this.FData_TeamBuy.TBSignBox.BoxStatus == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
         {
            this.FBtn_OK.Caption = this.FHD_TeamBuy.TBPrompt.StrBtnSigned;
            this.FBtn_OK.Enabled = false;
         }
         else
         {
            this.FBtn_OK.Caption = this.FHD_TeamBuy.TBPrompt.StrBtnSign;
            this.FBtn_OK.Enabled = true;
         }
      }
      
      protected function CheckCoolingTime() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = uint(STimingCore.ServerTick);
         if(_loc1_ >= this.FData_TeamBuy.TBTimeZero && _loc1_ < this.FData_TeamBuy.TBTimeStartSign)
         {
            if(this.FStatusSign != STATUS_SIGN_NoSign)
            {
               this.FTF_SignCoolingTime.text = this.FHD_TeamBuy.TBPrompt.StrNoSign;
            }
            this.FStatusSign = STATUS_SIGN_NoSign;
         }
         else if(_loc1_ >= this.FData_TeamBuy.TBTimeStartSign && _loc1_ <= this.FData_TeamBuy.TBTimeEndSign)
         {
            this.FTF_SignCoolingTime.text = FormatTime(this.FData_TeamBuy.TBTimeEndSign - _loc1_);
            this.FStatusSign = STATUS_SIGN_Signing;
         }
         else if(_loc1_ > this.FData_TeamBuy.TBTimeEndSign && _loc1_ < this.FData_TeamBuy.TBTimeStartBuy)
         {
            if(this.FStatusSign != STATUS_SIGN_EndSign)
            {
               this.FTF_SignCoolingTime.text = this.FHD_TeamBuy.TBPrompt.StrEndSign;
            }
            this.FStatusSign = STATUS_SIGN_EndSign;
         }
         else if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick(this);
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
         this.FMC_AwardList.Clear();
         this.FStatusSign = STATUS_SIGN_Normal;
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
         this.FTF_Title.text = "";
         this.FTF_OriginalPrice.text = "";
         this.FTF_CurSignPrice.text = "";
         this.FTF_FavorablePrice.text = "";
         this.FTF_SignPeopleCount.text = "";
         this.FTF_SignCoolingTime.text = "";
         this.FTF_CurPeople.text = "";
         this.FTF_CurPrice.text = "";
         this.FTF_LowPricePeople.text = "";
         _loc2_ = int(this.FTF_OKPeopleVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTF_OKPeopleVect[_loc1_].text = "";
            this.FTF_OKPriceVect[_loc1_].text = "";
            _loc1_++;
         }
      }
      
      protected function BtnSignOClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData_TeamBuy.TBSignBox.Index);
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         super.BtnCloseOnClick(param1,param2);
         if(FOnBtnCloseClick != null)
         {
            FOnBtnCloseClick(this);
         }
      }
   }
}

