package Processors.Game.Lobby.Activity.HDActivityRecharge.windows
{
   import Components.Standard.*;
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
   import Processors.Game.Lobby.Activity.HDActivityRecharge.Component.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowHDDailyPay extends THDOSTabWindowBase
   {
      
      protected static const SLOT_NUM:uint = 6;
      
      protected var FTF_PayNum:TextField;
      
      protected var FItemList:Vector.<TDailyPayItem>;
      
      protected var FBT_GetAward:TUIButton;
      
      protected var FMC_Got:Sprite;
      
      protected var FDailyPayData:THDDailyPayData;
      
      protected var FDailyPayBin:THDDailyPay;
      
      protected var FStateBox:Vector.<int>;
      
      protected var FUnstreamizerActivityRecharge:TUnstreamizerActivityRecharge;
      
      protected var FInited:Boolean;
      
      protected var FOnUpdateTabState:Function;
      
      public function TProcessorWindowHDDailyPay(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_DailyPay;
         this.FItemList = new Vector.<TDailyPayItem>(SLOT_NUM);
         this.FUnstreamizerActivityRecharge = new TUnstreamizerActivityRecharge();
         this.FStateBox = new Vector.<int>();
         FBoxStatus = this.FStateBox;
         this.FDailyPayData = new THDDailyPayData();
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
         if(this.FItemList != null && this.FItemList.length > 0)
         {
            _loc2_ = int(this.FItemList.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FItemList[_loc1_].UpdateItem();
               _loc1_++;
            }
         }
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TDailyPayItem = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance("MC_DailyPay") as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         this.FTF_PayNum = FMC_Scene["MC_Award"]["TF_PayNum"];
         this.FTF_PayNum.text = "";
         _loc2_ = int(SLOT_NUM);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = FMC_Scene["MC_Award"]["MC_Item_" + _loc1_];
            _loc4_ = new TDailyPayItem(this,_loc3_);
            _loc4_.OnOver = ProcessorOnSlotOver;
            _loc4_.OnOut = ProcessorOnSlotOut;
            _loc4_.OnQuerySubscript = SlotsOnQuerySubscript;
            _loc4_.ItemInit();
            this.FItemList[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FBT_GetAward = new TUIButton();
         this.FBT_GetAward.Substrate = FMC_Scene["MC_Award"]["BT_GetAward"];
         this.FBT_GetAward.OnClick = this.GetAwardOnClick;
         this.FMC_Got = FMC_Scene["MC_Award"]["MC_Got"];
         this.FMC_Got.visible = false;
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventories = null;
         var _loc5_:TDailyPayItem = null;
         super.UpdateUIConfig();
         this.FDailyPayBin = FHDActivityConfig as THDDailyPay;
         this.FStateBox.length = this.FDailyPayBin.ActAwards.length;
         ProcessorFormatActivityTime(FActivityAtoms.StartTime,FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.UpdateDataBase(param1);
         this.FDailyPayData = param1 as THDDailyPayData;
         this.FStateBox.length = 0;
         this.FStateBox.push(this.FDailyPayData.Award.State);
         if(Visible)
         {
            this.UpdateUI();
         }
      }
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
         this.UpdateDailyPay();
      }
      
      private function UpdateDailyPay() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TInventories = null;
         var _loc6_:TDailyPayItem = null;
         _loc3_ = this.FDailyPayData.Award.State;
         switch(_loc3_)
         {
            case CONST_ACTIVITY_MODE.Activity_CanNotReceive:
               this.FBT_GetAward.Enabled = false;
               this.FBT_GetAward.Visible = true;
               this.FMC_Got.visible = false;
               break;
            case CONST_ACTIVITY_MODE.Activity_AlreadyReceive:
               this.FBT_GetAward.Enabled = Enabled;
               this.FBT_GetAward.Visible = false;
               this.FMC_Got.visible = true;
               break;
            case CONST_ACTIVITY_MODE.Activity_CanReceive:
               this.FBT_GetAward.Enabled = true;
               this.FBT_GetAward.Visible = true;
               this.FMC_Got.visible = false;
         }
         _loc5_ = new TInventories();
         _loc5_ = ProcessorGetInventories(this.FDailyPayData.Award.ItemIdList[0]);
         _loc2_ = SLOT_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = this.FItemList[_loc1_];
            _loc6_.Scence.visible = false;
            _loc6_.Context = null;
            _loc1_++;
         }
         _loc2_ = SLOT_NUM;
         _loc4_ = _loc5_.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = this.FItemList[_loc1_];
            if(_loc1_ < _loc4_)
            {
               _loc6_.Context = _loc5_.GetInventoryByIndex(_loc1_);
               _loc6_.Scence.visible = true;
            }
            else
            {
               _loc6_.Context = null;
               _loc6_.Scence.visible = false;
            }
            _loc1_++;
         }
         this.FTF_PayNum.text = this.FDailyPayData.Award.Name;
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         if(FActivityAtoms.Identifier != FMemoryID)
         {
            FHDActivityConfig = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HDDailyPay,FActivityAtoms.ActivityNumber) as THDActivityBase;
         }
         this.FDailyPayBin = FHDActivityConfig as THDDailyPay;
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.SetDailyPayData(FActivityInitRetData,this.FDailyPayData);
         this.CheckAtomsState(this.FDailyPayData);
         this.UpdateDataBase(this.FDailyPayData);
         this.FInited = true;
      }
      
      private function SetDailyPayData(param1:TActivityInitRetData, param2:THDDailyPayData) : void
      {
         param2.Award.State = param1.AwardStates[0].State;
         this.FUnstreamizerActivityRecharge.UnstreamizeUpdateDailyPay(param2,this.FDailyPayBin);
      }
      
      private function CheckAtomsState(param1:THDDailyPayData) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:TAwardData = null;
         _loc4_ = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
         _loc5_ = param1.Award;
         if(_loc5_.State == CONST_ACTIVITY_MODE.Activity_CanReceive)
         {
            _loc4_ = CONST_ACTIVITY_MODE.Activity_CanReceive;
         }
         else if(_loc5_.State == CONST_ACTIVITY_MODE.Activity_CanNotReceive)
         {
            _loc4_ = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
         }
         if(this.FOnUpdateTabState != null)
         {
            this.FOnUpdateTabState(FActivityID,_loc4_);
         }
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function Reset() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TDailyPayItem = null;
         super.Reset();
         _loc2_ = SLOT_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FItemList[_loc1_];
            _loc3_.Reset();
            _loc1_++;
         }
      }
      
      override protected function BtnGotoLinkOnClcik(param1:Object, param2:MouseEvent) : void
      {
         super.BtnGotoLinkOnClcik(param1,param2);
         SExternalCore.NavigateToRechargeUrl(SParametersCore.PayUrl);
      }
      
      protected function GetAwardOnClick(param1:Object, param2:MouseEvent) : void
      {
         Perform_CS_ActivityOperateReq(FActivityAtoms.Identifier,0);
      }
      
      public function get OnUpdateTabState() : Function
      {
         return this.FOnUpdateTabState;
      }
      
      public function set OnUpdateTabState(param1:Function) : void
      {
         this.FOnUpdateTabState = param1;
      }
      
      override public function Show(param1:TActivityAtoms) : void
      {
         super.Show(param1);
         ActivityInitReq(param1.Identifier);
      }
      
      override public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         super.ChangeActivityStatus(param1,param2);
         if(!this.FInited)
         {
            return;
         }
         this.FDailyPayData.Award.State = param2.Status;
         this.UpdateDataBase(this.FDailyPayData);
         UpdataStatus(param2.Index,param2.Status,param2.Condition);
      }
   }
}

