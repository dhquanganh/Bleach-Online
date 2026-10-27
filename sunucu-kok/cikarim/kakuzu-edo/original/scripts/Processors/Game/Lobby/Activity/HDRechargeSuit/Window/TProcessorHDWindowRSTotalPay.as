package Processors.Game.Lobby.Activity.HDRechargeSuit.Window
{
   import Components.ScrollBar.*;
   import Externals.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Agent.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityRecharge.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorHDWindowRSTotalPay extends THDOSTabWindowBase
   {
      
      protected static const COUNT_TF_Award:uint = 1;
      
      protected static const COUNT_SLOT_Award:uint = 6;
      
      protected var FTF_TotalPay:TextField;
      
      protected var FUI_ScrollBar:TScrollBar;
      
      protected var FData_RSTotalPay:THDTotalPayData;
      
      protected var FHD_RSTotalPay:THDTotalPay;
      
      protected var FTotalAwardList:Vector.<TUIActivityOSAwardList>;
      
      protected var FInventoriesVect:Vector.<TInventories>;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FIsInitData:Boolean;
      
      public function TProcessorHDWindowRSTotalPay(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_TotalePay;
         this.FData_RSTotalPay = new THDTotalPayData();
         this.FTotalAwardList = new Vector.<TUIActivityOSAwardList>();
         this.FIsInitWindow = false;
         this.FIsInitData = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityRechargeCommon);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!this.FIsInitData)
         {
            return;
         }
         _loc2_ = int(this.FTotalAwardList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FTotalAwardList[_loc1_].UpDateSlot();
            _loc1_++;
         }
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:Sprite = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_RechargeSuitTotalPay) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         _loc1_ = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Award];
         this.FTF_TotalPay = _loc1_[CONST_ACTIVITY.RESOURCE_Link_TF_TotalPay];
         this.FUI_ScrollBar = new TScrollBar(_loc1_[CONST_ACTIVITY.RESOURCE_Link_MC_List],200,false,-7,74);
         this.FUI_ScrollBar.Visible = false;
         this.FIsInitWindow = true;
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIActivityOSAwardList = null;
         var _loc4_:Sprite = null;
         var _loc5_:Vector.<uint> = null;
         super.UpdateUIConfig();
         this.FHD_RSTotalPay = FHDActivityConfig as THDTotalPay;
         if(this.FTotalAwardList.length > 0)
         {
            _loc2_ = int(this.FTotalAwardList.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FTotalAwardList[_loc1_] = null;
               _loc1_++;
            }
            this.FTotalAwardList.length = 0;
         }
         _loc2_ = int(this.FHD_RSTotalPay.ActAwards.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIActivityOSAwardList(this);
            _loc3_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            _loc3_.OnSlotOver = ProcessorOnSlotOver;
            _loc3_.OnSlotOut = ProcessorOnSlotOut;
            _loc3_.OnQuerySubscript = SlotsOnQuerySubscript;
            _loc4_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_Link_MC_AwardList) as Sprite;
            _loc3_.Perform_UIDispatch(_loc4_,COUNT_TF_Award,COUNT_SLOT_Award);
            this.FTotalAwardList.push(_loc3_);
            _loc1_++;
         }
         _loc2_ = int(this.FHD_RSTotalPay.ActAwards.length);
         _loc5_ = new Vector.<uint>();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_.push(this.FHD_RSTotalPay.ActAwards[_loc1_].Awards[0]);
            _loc1_++;
         }
         this.FInventoriesVect = ProcessorGetInventoriesVectByAwardID(_loc5_);
         this.FIsInitData = true;
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.FData_RSTotalPay.TotalPay = FActivityInitRetData.ParameterVec[0];
         if(this.Visible)
         {
            this.UpdateUI();
         }
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         super.UpdateUI();
         if(!this.FIsInitData)
         {
            return;
         }
         this.FUI_ScrollBar.Clear();
         _loc2_ = int(this.FTotalAwardList.length);
         _loc3_ = new Vector.<String>(COUNT_TF_Award);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[0] = this.FHD_RSTotalPay.ActAwards[_loc1_].Prompt;
            this.FTotalAwardList[_loc1_].UpDateUI(_loc1_,this.FInventoriesVect[_loc1_],_loc3_);
            this.FTotalAwardList[_loc1_].UpdateUIPage();
            this.FUI_ScrollBar.AddItem(this.FTotalAwardList[_loc1_]);
            _loc1_++;
         }
         this.FUI_ScrollBar.ScrollToUp();
         this.FUI_ScrollBar.Visible = true;
         this.FTF_TotalPay.text = this.FData_RSTotalPay.TotalPay.toString();
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
         this.FUI_ScrollBar.Clear();
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
      
      override public function ChangeValue(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         super.ChangeValue(param1,param2);
         this.FData_RSTotalPay.TotalPay = param2[0];
         if(this.Visible)
         {
            this.UpdateUI();
         }
      }
   }
}

