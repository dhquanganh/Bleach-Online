package Processors.Game.Lobby.Activity.HDSoulBox.Window
{
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Agent.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivitySoulBox.*;
   import Logics.Streamization.HDActivityRecharge.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorHDWindowMoneyPenny extends THDOSTabWindowBase
   {
      
      protected static const COUNT_MC_Percent:uint = 6;
      
      protected static const COUNT_MC_Excharged:uint = 5;
      
      protected static const WIDTH_MC_OriginalBar:uint = 561;
      
      protected static const WIDTH_MC_BarInterval:uint = 93.5;
      
      protected static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      protected static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      protected static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected var FMC_Bar:Sprite;
      
      protected var FTF_CostVect:Vector.<TextField>;
      
      protected var FTF_PercentVect:Vector.<TextField>;
      
      protected var FMC_Awards:Vector.<MovieClip>;
      
      protected var FTF_ExchargedVect:Vector.<TextField>;
      
      protected var FTF_ReturnVect:Vector.<TextField>;
      
      protected var FMC_IsTodayVect:Vector.<Sprite>;
      
      protected var FTF_TotalReturn:TextField;
      
      protected var FMC_AlreadyGet:Sprite;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FMC_Effect:MovieClip;
      
      protected var FUnstreamizerActivityRecharge:TUnstreamizerActivityRecharge;
      
      protected var FHD_MoneyPenny:THDMoneyPenny;
      
      protected var FData_MoneyPenny:TActivityMoneyPenny;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FStageBar:int;
      
      protected var FTodayEndTime:int;
      
      public function TProcessorHDWindowMoneyPenny(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_MoneyPenny;
         this.FUnstreamizerActivityRecharge = new TUnstreamizerActivityRecharge();
         this.FData_MoneyPenny = new TActivityMoneyPenny();
         this.FIsInitWindow = false;
         this.FStageBar = -1;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivitySoulBox);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.LogicsPerform();
      }
      
      protected function SetEndTime() : int
      {
         var _loc1_:uint = 0;
         var _loc2_:Date = null;
         _loc1_ = uint(STimingCore.ServerTime);
         _loc2_ = new Date(_loc1_ * 1000);
         _loc2_.hours = 23;
         _loc2_.minutes = 59;
         _loc2_.seconds = 59;
         return _loc2_.getTime() / 1000;
      }
      
      protected function ProcessorGetID() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<TActivityAtoms> = null;
         _loc3_ = SLogicsCore.ActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_SoulBox);
         _loc2_ = int(_loc3_.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc3_[_loc1_].ActivityID == CONST_ACTIVITY_MODE.Activity_MoneyPenny)
            {
               return _loc3_[_loc1_].Identifier;
            }
            _loc1_++;
         }
         return 0;
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:Sprite = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_MoneyPenny) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         _loc4_ = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_AwardList];
         this.FMC_Bar = _loc4_[CONST_ACTIVITY.RESOURCE_Link_MC_Bar];
         _loc2_ = int(COUNT_MC_Percent);
         this.FTF_CostVect = new Vector.<TextField>(_loc2_);
         this.FTF_PercentVect = new Vector.<TextField>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = _loc4_[CONST_ACTIVITY.RESOURCE_Link_MC_Grade + _loc1_];
            this.FTF_CostVect[_loc1_] = _loc3_[CONST_ACTIVITY.RESOURCE_Link_TF_Cost];
            this.FTF_CostVect[_loc1_].mouseEnabled = false;
            this.FTF_PercentVect[_loc1_] = _loc3_[CONST_ACTIVITY.RESOURCE_Link_TF_Percent];
            this.FTF_PercentVect[_loc1_].mouseEnabled = false;
            _loc1_++;
         }
         _loc2_ = int(COUNT_MC_Excharged);
         this.FMC_Awards = new Vector.<MovieClip>(_loc2_);
         this.FTF_ExchargedVect = new Vector.<TextField>(_loc2_);
         this.FTF_ReturnVect = new Vector.<TextField>(_loc2_);
         this.FMC_IsTodayVect = new Vector.<Sprite>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FMC_Awards[_loc1_] = _loc4_[CONST_ACTIVITY.RESOURCE_Link_MC_Awards + _loc1_];
            this.FMC_Awards[_loc1_].mouseChildren = false;
            this.FMC_Awards[_loc1_].mouseEnabled = false;
            this.FMC_Awards[_loc1_].gotoAndStop(2);
            this.FTF_ExchargedVect[_loc1_] = this.FMC_Awards[_loc1_][CONST_ACTIVITY.RESOURCE_Link_TF_Excharged];
            this.FTF_ExchargedVect[_loc1_].visible = false;
            this.FTF_ReturnVect[_loc1_] = this.FMC_Awards[_loc1_][CONST_ACTIVITY.RESOURCE_Link_TF_Return];
            this.FTF_ReturnVect[_loc1_].visible = false;
            this.FMC_IsTodayVect[_loc1_] = this.FMC_Awards[_loc1_][CONST_ACTIVITY.RESOURCE_Link_MC_IsToday];
            this.FMC_IsTodayVect[_loc1_].visible = false;
            _loc1_++;
         }
         _loc3_ = _loc4_[CONST_ACTIVITY.RESOURCE_Link_MC_Award];
         this.FTF_TotalReturn = _loc3_[CONST_ACTIVITY.RESOURCE_Link_TF_Return];
         this.FTF_TotalReturn.mouseEnabled = false;
         this.FMC_AlreadyGet = _loc3_[CONST_ACTIVITY.RESOURCE_Link_MC_AlreadyGet];
         this.FMC_AlreadyGet.mouseChildren = false;
         this.FMC_AlreadyGet.mouseEnabled = false;
         this.FMC_AlreadyGet.visible = false;
         this.FBtn_OK = new TUIButton();
         this.FBtn_OK.Substrate = _loc3_[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
         this.FBtn_OK.OnClick = this.BtnOKOnClick;
         this.FBtn_OK.Enabled = false;
         this.FMC_Effect = _loc4_[CONST_ACTIVITY.RESOURCE_Link_MC_OpenGiftBagEffect];
         this.FMC_Effect.mouseChildren = false;
         this.FMC_Effect.mouseEnabled = false;
         this.FMC_Effect.stop();
         this.FMC_Effect.visible = false;
         this.ProcessorClearTextField();
         this.FIsInitWindow = true;
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHD_MoneyPenny = FHDActivityConfig as THDMoneyPenny;
         ProcessorFormatActivityTime(FActivityAtoms.StartTime,FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
         this.ProcessorUpdateUIPercent();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.UpdateUI();
         this.ProcessorCheckToday();
         _loc2_ = int(COUNT_MC_Excharged);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ <= this.FData_MoneyPenny.CurDay)
            {
               this.FMC_Awards[_loc1_].gotoAndStop(1);
               this.FTF_ExchargedVect[_loc1_].visible = true;
               this.FTF_ExchargedVect[_loc1_].text = this.FData_MoneyPenny.GetBoxByIndex(_loc1_).Excharged.toString();
               this.FTF_ReturnVect[_loc1_].visible = true;
               this.FTF_ReturnVect[_loc1_].text = this.FData_MoneyPenny.GetBoxByIndex(_loc1_).Return.toString();
               if(_loc1_ == this.FData_MoneyPenny.CurDay)
               {
                  this.FMC_IsTodayVect[_loc1_].visible = true;
               }
               else
               {
                  this.FMC_IsTodayVect[_loc1_].visible = false;
               }
            }
            else
            {
               this.FMC_Awards[_loc1_].gotoAndStop(2);
               this.FTF_ExchargedVect[_loc1_].visible = false;
               this.FTF_ReturnVect[_loc1_].visible = false;
               this.FMC_IsTodayVect[_loc1_].visible = false;
            }
            _loc1_++;
         }
         this.ProcessorUpdateUIBar();
         this.ProcessorUpdateUIAwards();
      }
      
      protected function ProcessorUpdateUIPercent() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(COUNT_MC_Percent);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTF_CostVect[_loc1_].text = this.FHD_MoneyPenny.BoxConditions[_loc1_].Prompt;
            this.FTF_PercentVect[_loc1_].text = TUtilityString.Format(this.FHD_MoneyPenny.ShowStr[1],this.FHD_MoneyPenny.BoxConditions[_loc1_].Rate);
            _loc1_++;
         }
      }
      
      protected function ProcessorUpdateUIBar() : void
      {
         if(this.FStageBar == -1)
         {
            this.FMC_Bar.width = 0;
         }
         else if(this.FStageBar == this.FHD_MoneyPenny.PayDay - 1)
         {
            this.FMC_Bar.width = WIDTH_MC_OriginalBar;
         }
         else
         {
            this.FMC_Bar.width = WIDTH_MC_BarInterval * (this.FStageBar + 1);
         }
      }
      
      protected function ProcessorUpdateUIAwards() : void
      {
         var _loc1_:TActivityMoneyPennyBox = null;
         var _loc2_:int = 0;
         this.FTF_TotalReturn.text = this.FData_MoneyPenny.TotalReturn.toString();
         _loc1_ = this.FData_MoneyPenny.GetReceiveBox();
         if(_loc1_ != null)
         {
            if(_loc1_.Status >= Activity_CanReceive)
            {
               this.FBtn_OK.Visible = true;
               this.FBtn_OK.Enabled = true;
               this.FMC_AlreadyGet.visible = false;
               _loc2_ = Activity_CanReceive;
               this.FMC_Effect.play();
               this.FMC_Effect.visible = true;
            }
            else if(_loc1_.Status == Activity_CanNotReceive)
            {
               this.FBtn_OK.Visible = false;
               this.FBtn_OK.Enabled = false;
               this.FMC_AlreadyGet.visible = false;
               _loc2_ = Activity_CanNotReceive;
               this.FMC_Effect.stop();
               this.FMC_Effect.visible = false;
            }
            else
            {
               this.FBtn_OK.Enabled = false;
               this.FBtn_OK.Visible = false;
               this.FMC_AlreadyGet.visible = true;
               _loc2_ = Activity_CanNotReceive;
               this.FMC_Effect.stop();
               this.FMC_Effect.visible = false;
            }
         }
         if(FUpdateStatus != null)
         {
            FUpdateStatus(FActivityAtoms.Identifier,_loc2_);
         }
      }
      
      protected function ProcessorCheckToday() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc1_ = STimingCore.ServerTime + 20;
         _loc2_ = Math.floor((_loc1_ - FActivityAtoms.StartTime) / CONST_ACTIVITY.ALLDAY_TIME);
         this.FData_MoneyPenny.CurDay = _loc2_;
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         super.UpdateSCData(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         if(this.FHD_MoneyPenny == null)
         {
            _loc3_ = int(FActivityInitRetData.AwardStates.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               if(FActivityInitRetData.AwardStates[_loc2_].State == Activity_CanReceive)
               {
                  this.ProcessorCheckBoxStatus(Activity_CanReceive);
                  break;
               }
               this.ProcessorCheckBoxStatus(Activity_CanNotReceive);
               _loc2_++;
            }
         }
         else
         {
            this.FUnstreamizerActivityRecharge.UnstreamizeUpdateMoneyPenny(FActivityInitRetData,this.FData_MoneyPenny,this.FHD_MoneyPenny);
            this.ProcessorCheckToday();
            this.ProcessorGetMoneyPennyRate(this.FData_MoneyPenny);
         }
         if(Visible)
         {
            this.UpdateUI();
         }
      }
      
      override public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         super.ChangeActivityStatus(param1,param2);
         if(this.FData_MoneyPenny == null)
         {
            if(param2.Status >= Activity_CanReceive)
            {
               this.ProcessorCheckBoxStatus(Activity_CanReceive);
            }
            else
            {
               this.ProcessorCheckBoxStatus(Activity_CanNotReceive);
            }
         }
         else
         {
            this.FData_MoneyPenny.GetMPByUniqueIndex(param2.Index).Status = param2.Status;
            if(param2.Condition.length > 0)
            {
               this.FData_MoneyPenny.GetMPByUniqueIndex(param2.Index).Excharged = param2.Condition[0];
            }
         }
         if(this.Visible)
         {
            this.ProcessorGetMoneyPennyRate(this.FData_MoneyPenny);
            this.UpdateUI();
         }
      }
      
      protected function ProcessorCheckBoxStatus(param1:int) : void
      {
         if(FActivityAtoms == null)
         {
            return;
         }
         if(FUpdateStatus != null)
         {
            FUpdateStatus(FActivityAtoms.Identifier,param1);
         }
      }
      
      protected function ProcessorGetMoneyPennyRate(param1:TActivityMoneyPenny) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:Vector.<TActivityMoneyPennyCondition> = null;
         var _loc8_:uint = 0;
         _loc6_ = 0;
         this.FStageBar = -1;
         _loc3_ = int(param1.MPBoxStatus.length);
         _loc7_ = param1.MPConditions;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc8_ = param1.MPBoxStatus[_loc2_].Excharged;
            param1.MPBoxStatus[_loc2_].Return = 0;
            _loc5_ = int(_loc7_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               if(_loc8_ < _loc7_[_loc4_].Condition)
               {
                  break;
               }
               _loc6_ = _loc7_[_loc4_].Rate;
               if(this.FData_MoneyPenny.CurDay == _loc2_)
               {
                  this.FStageBar = _loc4_;
               }
               _loc4_++;
            }
            param1.MPBoxStatus[_loc2_].Return = Math.floor(_loc8_ * _loc6_ / 100);
            _loc2_++;
         }
      }
      
      override protected function Reset() : void
      {
         super.Reset();
         this.ProcessorClearTextField();
      }
      
      protected function ProcessorClearTextField() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(!this.FIsInitWindow)
         {
            return;
         }
         _loc2_ = int(this.FMC_Awards.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTF_ExchargedVect[_loc1_].text = "";
            this.FTF_ReturnVect[_loc1_].text = "";
            _loc1_++;
         }
         this.FTF_TotalReturn.text = "";
         this.FMC_Effect.stop();
         this.FMC_Effect.visible = false;
      }
      
      override protected function BtnGotoLinkOnClcik(param1:Object, param2:MouseEvent) : void
      {
         super.BtnGotoLinkOnClcik(param1,param2);
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         if(this.FData_MoneyPenny.GetReceiveBox().Status < Activity_CanReceive)
         {
            return;
         }
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData_MoneyPenny.GetReceiveBox().Index);
      }
      
      override public function Show(param1:TActivityAtoms) : void
      {
         super.Show(param1);
         ActivityInitReq(param1.Identifier);
      }
   }
}

