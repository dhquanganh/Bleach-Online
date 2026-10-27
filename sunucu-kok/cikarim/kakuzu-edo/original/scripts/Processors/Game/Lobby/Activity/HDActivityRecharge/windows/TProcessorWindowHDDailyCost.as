package Processors.Game.Lobby.Activity.HDActivityRecharge.windows
{
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
   import Processors.Game.Lobby.Activity.HDActivity.THDOSTabWindowBase;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.TUIActivityOSAwardList;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorWindowHDDailyCost extends THDOSTabWindowBase
   {
      
      protected static const BOX_NUM:uint = 2;
      
      protected static const COUNT_TF_Award:uint = 3;
      
      protected static const COUNT_Slot_Award:uint = 3;
      
      protected var FAwardListVect:Vector.<TUIActivityOSAwardList>;
      
      protected var FDailyCostBin:THDDailyCost;
      
      protected var FDailyCostData:THDDailyCostData;
      
      protected var FStateBox:Vector.<int>;
      
      protected var FUnstreamizerActivityRecharge:TUnstreamizerActivityRecharge;
      
      protected var FInited:Boolean;
      
      protected var FOnBuyMilitary:Function;
      
      protected var FOnUpdateTabState:Function;
      
      public function TProcessorWindowHDDailyCost(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_DailyCost;
         this.FAwardListVect = new Vector.<TUIActivityOSAwardList>(BOX_NUM);
         this.FUnstreamizerActivityRecharge = new TUnstreamizerActivityRecharge();
         this.FStateBox = new Vector.<int>();
         FBoxStatus = this.FStateBox;
         this.FDailyCostData = new THDDailyCostData();
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
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TUIActivityOSAwardList = null;
         var _loc5_:Sprite = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance("MC_DailyCost") as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         _loc2_ = int(BOX_NUM);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new TUIActivityOSAwardList(this);
            _loc4_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            _loc4_.OnSlotOver = ProcessorOnSlotOver;
            _loc4_.OnSlotOut = ProcessorOnSlotOut;
            _loc4_.OnQuerySubscript = SlotsOnQuerySubscript;
            _loc4_.OnBtnOkClick = this.BtnOKOnClick;
            _loc5_ = FMC_Scene["MC_Award"]["MC_Box_" + _loc1_];
            _loc4_.Perform_UIDispatch(_loc5_,COUNT_TF_Award,COUNT_Slot_Award,false);
            _loc4_.OnTextClick = this.TextGotoLinkOnClick;
            this.FAwardListVect[_loc1_] = _loc4_;
            _loc1_++;
         }
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIActivityOSAwardList = null;
         var _loc4_:Sprite = null;
         super.UpdateUIConfig();
         this.FDailyCostBin = FHDActivityConfig as THDDailyCost;
         this.FStateBox.length = this.FDailyCostBin.ActAwards.length;
         ProcessorFormatActivityTime(FActivityAtoms.StartTime,FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.UpdateDataBase(param1);
         this.FDailyCostData = param1 as THDDailyCostData;
         this.FStateBox.length = 0;
         _loc3_ = this.FDailyCostData.CountForAward();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FStateBox.push(this.FDailyCostData.GetAwardByIndex(_loc2_).State);
            _loc2_++;
         }
         if(Visible)
         {
            this.UpdateUI();
         }
      }
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
         this.UpdateDailyCost();
      }
      
      private function UpdateDailyCost() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:TUIActivityOSAwardList = null;
         var _loc5_:TInventories = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:TDailyCostAwardData = null;
         var _loc8_:String = null;
         _loc6_ = new Vector.<String>();
         _loc2_ = this.FAwardListVect.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_.length = 0;
            _loc8_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.DAILYTASK_STRING_01);
            _loc4_ = this.FAwardListVect[_loc1_];
            _loc7_ = this.FDailyCostData.GetAwardByIndex(_loc1_);
            _loc5_ = ProcessorGetInventories(_loc7_.ItemIdList[0]);
            _loc6_.push(_loc7_.Name);
            _loc8_ = TUtilityString.Format(_loc8_,_loc7_.Count,this.FDailyCostBin.ActAwards[_loc1_].Key);
            _loc6_.push(_loc8_);
            if(_loc1_ == 0)
            {
               _loc6_.push("");
            }
            else if(_loc1_ == 1)
            {
               _loc6_.push("");
            }
            _loc4_.UpDateUI(_loc1_,_loc5_,_loc6_);
            _loc4_.SetShortcutHyperlinks(2);
            _loc4_.UpDateBtn(_loc7_.State);
            _loc1_++;
         }
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         if(FActivityAtoms.Identifier != FMemoryID)
         {
            FHDActivityConfig = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HDDailyCost,FActivityAtoms.ActivityNumber) as THDActivityBase;
         }
         this.FDailyCostBin = FHDActivityConfig as THDDailyCost;
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.SetDailyCostData(FActivityInitRetData,this.FDailyCostData);
         this.CheckAtomsState(this.FDailyCostData);
         this.UpdateDataBase(this.FDailyCostData);
         this.FInited = true;
      }
      
      private function SetDailyCostData(param1:TActivityInitRetData, param2:THDDailyCostData) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:THDBoxStateData = null;
         var _loc6_:TDailyCostAwardData = null;
         param2.ClearAward();
         _loc4_ = param1.AwardStates.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.AwardStates[_loc3_];
            _loc6_ = new TDailyCostAwardData();
            _loc6_.Count = _loc5_.Conditions[0];
            _loc6_.State = _loc5_.State;
            _loc6_.BoxIndex = _loc5_.BoxIndex;
            param2.AddAward(_loc6_);
            _loc3_++;
         }
         this.FUnstreamizerActivityRecharge.UnstreamizeUpdateDailyCost(param2,this.FDailyCostBin);
      }
      
      private function CheckAtomsState(param1:THDDailyCostData) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:TDailyCostAwardData = null;
         _loc4_ = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
         _loc3_ = param1.CountForAward();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = param1.GetAwardByIndex(_loc2_);
            if(_loc5_.State == CONST_ACTIVITY_MODE.Activity_CanReceive)
            {
               _loc4_ = CONST_ACTIVITY_MODE.Activity_CanReceive;
               break;
            }
            if(_loc5_.State == CONST_ACTIVITY_MODE.Activity_CanNotReceive)
            {
               _loc4_ = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
            }
            _loc2_++;
         }
         if(this.FOnUpdateTabState != null)
         {
            this.FOnUpdateTabState(FActivityID,_loc4_);
         }
         ProcessorFormatActivityCountDown(FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_DailyCost).EndTime);
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
      
      override protected function TextGotoLinkOnClick(param1:Object, param2:uint) : void
      {
         var _loc3_:TUIActivityOSAwardList = null;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:String = null;
         super.TextGotoLinkOnClick(param1,param2);
         _loc3_ = param1 as TUIActivityOSAwardList;
         _loc4_ = this.FAwardListVect.indexOf(_loc3_);
         if(_loc4_ == 0)
         {
            SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_HellButterfly);
         }
         else if(_loc4_ == 1)
         {
            Close();
            if(this.FOnBuyMilitary != null)
            {
               this.FOnBuyMilitary(this);
            }
         }
      }
      
      public function get OnBuyMilitary() : Function
      {
         return this.FOnBuyMilitary;
      }
      
      public function set OnBuyMilitary(param1:Function) : void
      {
         this.FOnBuyMilitary = param1;
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
         var _loc3_:TDailyCostAwardData = null;
         if(!this.FInited)
         {
            return;
         }
         super.ChangeActivityStatus(param1,param2);
         _loc3_ = this.FDailyCostData.GetAwardByIndex(param2.Index);
         _loc3_.State = param2.Status;
         if(param2.Condition.length > 0)
         {
            _loc3_.Count = param2.Condition[0];
         }
         this.UpdateDataBase(this.FDailyCostData);
         UpdataStatus(param2.Index,param2.Status,param2.Condition);
      }
   }
}

