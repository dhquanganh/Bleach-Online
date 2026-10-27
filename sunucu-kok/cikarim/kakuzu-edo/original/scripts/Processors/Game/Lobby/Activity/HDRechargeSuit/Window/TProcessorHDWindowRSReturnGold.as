package Processors.Game.Lobby.Activity.HDRechargeSuit.Window
{
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Agent.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityRecharge.*;
   import Logics.Streamization.HDActivityRecharge.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorHDWindowRSReturnGold extends THDOSTabWindowBase
   {
      
      protected var FTF_ReturnGold:TextField;
      
      protected var FBtn_GetGold:TUIButton;
      
      protected var FUnstreamizerActivityRecharge:TUnstreamizerActivityRecharge;
      
      protected var FData_ReturnGold:TActivityRechargeSuitReturnGold;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FIsInitData:Boolean;
      
      public function TProcessorHDWindowRSReturnGold(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_PayReturn;
         this.FData_ReturnGold = new TActivityRechargeSuitReturnGold();
         this.FUnstreamizerActivityRecharge = new TUnstreamizerActivityRecharge();
         this.FIsInitWindow = false;
         this.FIsInitData = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityRechargeCommon);
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:Sprite = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_RechargeSuitReturnGold) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         _loc1_ = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Award];
         this.FBtn_GetGold = new TUIButton();
         this.FBtn_GetGold.Substrate = _loc1_[CONST_ACTIVITY.RESOURCE_Link_BTN_OK];
         this.FBtn_GetGold.OnClick = this.BtnGetGoldOnClick;
         this.FBtn_GetGold.Enabled = false;
         this.FTF_ReturnGold = _loc1_[CONST_ACTIVITY.RESOURCE_Link_TF_ReturnGold];
         this.FTF_ReturnGold.mouseEnabled = false;
         this.FIsInitWindow = true;
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.FUnstreamizerActivityRecharge.UnstreamizeUpdateRechargeSuitReturnGold(FActivityInitRetData,this.FData_ReturnGold,null);
         this.FIsInitData = true;
         if(this.Visible)
         {
            this.UpdateUI();
         }
      }
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
         this.FTF_ReturnGold.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_65),this.FData_ReturnGold.AwardBox.BoxStatus);
         if(this.FData_ReturnGold.AwardBox.BoxStatus > CONST_ACTIVITY_MODE.Activity_CanNotReceive)
         {
            this.FBtn_GetGold.Enabled = true;
         }
         else
         {
            this.FBtn_GetGold.Enabled = false;
         }
      }
      
      protected function BtnGetGoldOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBtn_GetGold.Enabled = false;
         if(this.FData_ReturnGold.AwardBox.BoxStatus > CONST_ACTIVITY_MODE.Activity_CanNotReceive)
         {
            Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,this.FData_ReturnGold.AwardBox.Index);
         }
      }
      
      override protected function BtnGotoLinkOnClcik(param1:Object, param2:MouseEvent) : void
      {
         super.BtnGotoLinkOnClcik(param1,param2);
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      override public function Show(param1:TActivityAtoms) : void
      {
         super.Show(param1);
         ActivityInitReq(param1.Identifier);
      }
      
      override public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         var _loc3_:int = 0;
         super.ChangeActivityStatus(param1,param2);
         if(this.FIsInitData && param2.Index == this.FData_ReturnGold.AwardBox.Index)
         {
            this.FData_ReturnGold.UpdateData(param2.Status);
         }
         if(this.Visible)
         {
            this.UpdateUI();
            if(this.FData_ReturnGold.AwardBox.BoxStatus >= Activity_CanReceive)
            {
               _loc3_ = Activity_CanReceive;
            }
            else
            {
               _loc3_ = Activity_CanNotReceive;
            }
            if(FUpdateStatus != null)
            {
               FUpdateStatus(FActivityAtoms.Identifier,_loc3_);
            }
         }
      }
   }
}

