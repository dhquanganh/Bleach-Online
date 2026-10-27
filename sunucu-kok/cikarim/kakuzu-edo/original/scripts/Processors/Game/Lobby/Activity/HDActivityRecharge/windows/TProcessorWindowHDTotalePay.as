package Processors.Game.Lobby.Activity.HDActivityRecharge.windows
{
   import Components.ScrollBar.*;
   import Externals.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Agent.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.HDActivityRecharge.*;
   import Logics.Inventories.*;
   import Logics.Streamization.HDActivityRecharge.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowHDTotalePay extends THDOSTabWindowBase
   {
      
      protected static const COUNT_TF_Award:uint = 1;
      
      protected static const COUNT_Slot_Award:uint = 6;
      
      protected var FUIScrollBarAward:TScrollBar;
      
      protected var FTotalPayBin:THDTotalPay;
      
      protected var FTotalPayData:THDTotalPayData;
      
      protected var FAwardListVect:Vector.<TUIActivityOSAwardList>;
      
      protected var FTF_TotalPay:TextField;
      
      protected var FStateBox:Vector.<int>;
      
      protected var FUnstreamizerActivityRecharge:TUnstreamizerActivityRecharge;
      
      protected var FInited:Boolean;
      
      public function TProcessorWindowHDTotalePay(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_TotalePay;
         this.FUnstreamizerActivityRecharge = new TUnstreamizerActivityRecharge();
         this.FStateBox = new Vector.<int>();
         FBoxStatus = this.FStateBox;
         this.FTotalPayData = new THDTotalPayData();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityRecharge);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         if(this.FAwardListVect != null && this.FAwardListVect.length > 0)
         {
            _loc2_ = int(this.FAwardListVect.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FAwardListVect[_loc1_].UpDateSlot();
               _loc1_++;
            }
         }
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance("MC_TotalPay") as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         _loc3_ = FMC_Scene["MC_Award"];
         this.FUIScrollBarAward = new TScrollBar(_loc3_[CONST_ACTIVITY.RESOURCE_Link_MC_List],200,false,-7,74);
         this.FUIScrollBarAward.Visible = false;
         this.FTF_TotalPay = FMC_Scene["MC_Award"]["TF_TotalPay"];
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIActivityOSAwardList = null;
         var _loc4_:Sprite = null;
         super.UpdateUIConfig();
         this.FTotalPayBin = FHDActivityConfig as THDTotalPay;
         this.FStateBox.length = this.FTotalPayBin.ActAwards.length;
         _loc2_ = int(this.FTotalPayBin.ActAwards.length);
         this.FAwardListVect = new Vector.<TUIActivityOSAwardList>(_loc2_);
         this.FUIScrollBarAward.Clear();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIActivityOSAwardList(this);
            _loc3_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            _loc3_.OnSlotOver = ProcessorOnSlotOver;
            _loc3_.OnSlotOut = ProcessorOnSlotOut;
            _loc3_.OnQuerySubscript = SlotsOnQuerySubscript;
            _loc3_.OnBtnOkClick = this.BtnOKOnClick;
            _loc4_ = TUtilityReflection.CreateDisplayObjectInstance("MC_AwardItem") as Sprite;
            _loc3_.Perform_UIDispatch(_loc4_,COUNT_TF_Award,COUNT_Slot_Award);
            this.FUIScrollBarAward.AddItem(_loc3_);
            this.FAwardListVect[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FUIScrollBarAward.ScrollToUp();
         this.FUIScrollBarAward.Visible = true;
         ProcessorFormatActivityTime(FActivityAtoms.StartTime,FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.UpdateDataBase(param1);
         this.FTotalPayData = param1 as THDTotalPayData;
         this.FStateBox.length = 0;
         _loc3_ = this.FTotalPayData.CountForAward();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FStateBox.push(this.FTotalPayData.GetAwardByIndex(_loc2_).State);
            _loc2_++;
         }
         FBoxStatus = this.FStateBox;
         if(Visible)
         {
            this.UpdateUI();
         }
      }
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
         this.UpdateTotalPay();
      }
      
      private function UpdateTotalPay() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIActivityOSAwardList = null;
         var _loc5_:TInventories = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:TAwardData = null;
         _loc6_ = new Vector.<String>();
         _loc2_ = this.FAwardListVect.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_.length = 0;
            _loc4_ = this.FAwardListVect[_loc1_];
            _loc7_ = this.FTotalPayData.GetAwardByIndex(_loc1_);
            _loc5_ = ProcessorGetInventories(_loc7_.ItemIdList[0]);
            _loc6_.push(_loc7_.Name);
            _loc4_.UpDateUI(_loc1_,_loc5_,_loc6_);
            _loc4_.UpDateBtn(_loc7_.State);
            _loc1_++;
         }
         this.FUIScrollBarAward.ScrollToUp();
         this.FTF_TotalPay.text = this.FTotalPayData.TotalPay.toString();
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         if(FActivityAtoms.Identifier != FMemoryID)
         {
            FHDActivityConfig = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HDTotalPay,FActivityAtoms.ActivityNumber) as THDActivityBase;
         }
         this.FTotalPayBin = FHDActivityConfig as THDTotalPay;
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.SetTotalPayData(FActivityInitRetData,this.FTotalPayData);
         this.UpdateDataBase(this.FTotalPayData);
         this.FInited = true;
      }
      
      private function SetTotalPayData(param1:TActivityInitRetData, param2:THDTotalPayData) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:THDBoxStateData = null;
         var _loc6_:TAwardData = null;
         param2.ClearAward();
         _loc4_ = param1.AwardStates.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.AwardStates[_loc3_];
            _loc6_ = new TAwardData();
            _loc6_.State = _loc5_.State;
            _loc6_.BoxIndex = _loc5_.BoxIndex;
            param2.AddAward(_loc6_);
            _loc3_++;
         }
         param2.TotalPay = param1.ParameterVec[0];
         this.FUnstreamizerActivityRecharge.UnstreamizeUpdateTotalPay(param2,this.FTotalPayBin);
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         if(this.FAwardListVect != null && this.FAwardListVect.length > 0)
         {
            _loc2_ = int(this.FAwardListVect.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FAwardListVect[_loc1_].Clear();
               _loc1_++;
            }
         }
      }
      
      override protected function BtnGotoLinkOnClcik(param1:Object, param2:MouseEvent) : void
      {
         super.BtnGotoLinkOnClcik(param1,param2);
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         super.BtnOKOnClick(param1,param2);
      }
      
      override public function Show(param1:TActivityAtoms) : void
      {
         super.Show(param1);
         ActivityInitReq(param1.Identifier);
      }
      
      override public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         var _loc3_:TAwardData = null;
         var _loc4_:int = 0;
         if(!this.FInited)
         {
            return;
         }
         super.ChangeActivityStatus(param1,param2);
         _loc4_ = param2.Index;
         if(_loc4_ == -1)
         {
            this.FTotalPayData.TotalPay = param2.Condition[0];
         }
         else
         {
            _loc3_ = this.FTotalPayData.GetAwardByIndex(_loc4_);
            _loc3_.State = param2.Status;
         }
         this.UpdateDataBase(this.FTotalPayData);
         UpdataStatus(_loc4_,param2.Status,param2.Condition);
      }
      
      override public function ChangeValue(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         super.ChangeValue(param1,param2);
         this.FTotalPayData.TotalPay = param2[0];
         this.UpdateDataBase(this.FTotalPayData);
      }
   }
}

