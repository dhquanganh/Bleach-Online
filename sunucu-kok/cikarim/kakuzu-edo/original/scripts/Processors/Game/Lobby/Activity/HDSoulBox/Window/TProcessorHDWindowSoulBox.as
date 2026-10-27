package Processors.Game.Lobby.Activity.HDSoulBox.Window
{
   import Externals.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Agent.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivitySoulBox.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDSoulBox.Component.TSoulBoxItem;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorHDWindowSoulBox extends THDOSTabWindowBase
   {
      
      protected static const ITEM_NUM:uint = 3;
      
      protected static const COUNT_TF_Award:uint = 3;
      
      protected static const COUNT_Slot_Award:uint = 2;
      
      protected var FSinglePayTimeBin:THDSinglePayTime;
      
      protected var FSoulBoxData:TSoulBoxData;
      
      protected var FAwardListVect:Vector.<TSoulBoxItem>;
      
      protected var FTodayEndTime:int;
      
      public function TProcessorHDWindowSoulBox(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_SinglePayTime;
         this.FSoulBoxData = new TSoulBoxData();
         this.FAwardListVect = new Vector.<TSoulBoxItem>(ITEM_NUM);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivitySoulBox);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
         this.CheckNeedUpdateState();
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
      
      protected function CheckNeedUpdateState() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:TActivityAtoms = null;
         if(this.FTodayEndTime == 0)
         {
            return;
         }
         _loc1_ = uint(STimingCore.ServerTime);
         if(_loc1_ > this.FTodayEndTime)
         {
            _loc2_ = FActivityModes.GetActivityAtomsByIdentifier(FActivityAtoms.Identifier);
            if(_loc2_ != null)
            {
               if(FUpdateStatus != null)
               {
                  FUpdateStatus(FActivityAtoms.Identifier,this.ResetState());
               }
               if(Visible)
               {
                  this.UpdateUI();
               }
               this.FTodayEndTime = this.SetEndTime();
            }
            else
            {
               this.FTodayEndTime = 0;
            }
         }
      }
      
      protected function ResetState() : int
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = this.FSoulBoxData.BoxListCount;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FSoulBoxData.GetAwardByIndex(_loc1_).State >= Activity_CanReceive)
            {
               return Activity_CanReceive;
            }
            _loc1_++;
         }
         return Activity_CanNotReceive;
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TSoulBoxItem = null;
         var _loc5_:Sprite = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_SoulBox) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         _loc3_ = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_AwardList];
         _loc2_ = int(ITEM_NUM);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new TSoulBoxItem(this);
            _loc4_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            _loc4_.OnSlotOver = ProcessorOnSlotOver;
            _loc4_.OnSlotOut = ProcessorOnSlotOut;
            _loc4_.OnQuerySubscript = SlotsOnQuerySubscript;
            _loc4_.OnBtnOkClick = this.BtnOKOnClick;
            _loc5_ = _loc3_[CONST_ACTIVITY.RESOURCE_Link_MC_Items + _loc1_];
            _loc4_.Perform_UIDispatch(_loc5_,COUNT_TF_Award,COUNT_Slot_Award,false);
            this.FAwardListVect[_loc1_] = _loc4_;
            _loc1_++;
         }
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FSinglePayTimeBin = FHDActivityConfig as THDSinglePayTime;
         if(FActivityAtoms.TimeShowType == CONST_ACTIVITY_MODE.TYPE_TimeShowNormal)
         {
            ProcessorFormatActivityTime(FActivityAtoms.StartTime,FActivityAtoms.EndTime);
         }
         else if(FActivityAtoms.TimeShowType == CONST_ACTIVITY_MODE.TYPE_TimeShowFromNowON)
         {
            ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         }
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
      
      override protected function UpdateUI() : void
      {
         super.UpdateUI();
         this.UpdateSinglePayTime();
      }
      
      private function UpdateSinglePayTime() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:TSoulBoxItem = null;
         var _loc5_:TInventories = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:THDBoxStateData = null;
         var _loc8_:TSinglePayTimeAward = null;
         var _loc9_:uint = 0;
         var _loc10_:Boolean = false;
         _loc6_ = new Vector.<String>();
         _loc2_ = this.FAwardListVect.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_.length = 0;
            _loc4_ = this.FAwardListVect[_loc1_];
            _loc7_ = this.FSoulBoxData.GetAwardByIndex(_loc1_);
            _loc8_ = this.FSinglePayTimeBin.ActAwards[_loc1_];
            _loc5_ = ProcessorGetInventories(_loc8_.Awards[0]);
            _loc6_.push(_loc8_.Key.toString());
            _loc9_ = _loc5_.GetInventoryByIndex(0).Quantity * _loc8_.Limit;
            _loc6_.push(_loc9_.toString());
            _loc6_.push(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_29),_loc8_.Limit));
            _loc5_.DeleteInventoryByIndex(0);
            _loc4_.UpDateUI(_loc1_,_loc5_,_loc6_);
            _loc4_.IsPassed = this.CheckIsPass(_loc8_);
            if(_loc7_.State == _loc8_.Limit)
            {
               _loc4_.CanGet = true;
            }
            else
            {
               _loc4_.CanGet = this.CheckCanReceive(_loc7_.Conditions[0],false);
            }
            _loc4_.UpdateItemState(_loc7_.State);
            _loc1_++;
         }
      }
      
      private function CheckIsPass(param1:TSinglePayTimeAward) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         _loc3_ = uint(STimingCore.ServerTime);
         _loc2_ = _loc3_ - FActivityAtoms.StartTime;
         if(_loc2_ >= this.FSinglePayTimeBin.PayDay * CONST_ACTIVITY.ALLDAY_TIME)
         {
            return true;
         }
         return false;
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
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         if(FActivityAtoms.Identifier != FMemoryID)
         {
            FHDActivityConfig = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_HDSinglePayTime,FActivityAtoms.ActivityNumber) as THDActivityBase;
         }
         this.FSinglePayTimeBin = FHDActivityConfig as THDSinglePayTime;
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.SetSinglePayTimeData(FActivityInitRetData,this.FSoulBoxData);
         this.FTodayEndTime = this.SetEndTime();
         if(Visible)
         {
            this.UpdateUI();
         }
      }
      
      private function SetSinglePayTimeData(param1:TActivityInitRetData, param2:TSoulBoxData) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:THDBoxStateData = null;
         param2.ClearAward();
         _loc4_ = param1.AwardStates.length;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.AwardStates[_loc3_];
            param2.AddAward(_loc5_);
            _loc3_++;
         }
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
      
      override protected function UpdataStatus(param1:uint, param2:int, param3:Vector.<int>) : void
      {
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:THDBoxStateData = null;
         var _loc8_:TSinglePayTimeAward = null;
         var _loc9_:Boolean = false;
         _loc7_ = this.FSoulBoxData.GetAwardByIndex(param1);
         _loc7_.State = param2;
         _loc7_.Conditions = param3;
         _loc4_ = Activity_AlreadyReceive;
         _loc6_ = this.FSoulBoxData.BoxListCount;
         _loc5_ = 0;
         while(_loc5_ < _loc6_)
         {
            _loc7_ = this.FSoulBoxData.GetAwardByIndex(_loc5_);
            _loc8_ = this.FSinglePayTimeBin.ActAwards[_loc5_];
            if(_loc7_.State >= Activity_CanReceive)
            {
               if(_loc7_.State == _loc8_.Limit)
               {
                  _loc4_ = Activity_CanReceive;
                  break;
               }
               if(this.CheckCanReceive(_loc7_.Conditions[0],false))
               {
                  _loc4_ = Activity_CanReceive;
                  break;
               }
               _loc4_ = Activity_CanNotReceive;
            }
            else if(_loc7_.State == Activity_CanNotReceive)
            {
               _loc4_ = Activity_CanNotReceive;
            }
            _loc5_++;
         }
         if(FUpdateStatus != null)
         {
            FUpdateStatus(FActivityAtoms.Identifier,_loc4_);
         }
      }
      
      private function CheckCanReceive(param1:int, param2:Boolean) : Boolean
      {
         var _loc3_:uint = 0;
         var _loc4_:Date = null;
         var _loc5_:int = 0;
         var _loc6_:Date = null;
         if(param2)
         {
            return true;
         }
         _loc5_ = param1;
         _loc6_ = new Date(param1 * 1000);
         _loc3_ = uint(STimingCore.ServerTime);
         _loc4_ = new Date(_loc3_ * 1000);
         if(_loc6_.day != _loc4_.day || _loc3_ - _loc5_ >= CONST_ACTIVITY.ALLDAY_TIME)
         {
            return true;
         }
         return false;
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
         var _loc3_:THDBoxStateData = null;
         super.ChangeActivityStatus(param1,param2);
         _loc3_ = this.FSoulBoxData.GetAwardByIndex(param2.Index);
         _loc3_.State = param2.Status;
         if(param2.Condition.length != 0)
         {
            _loc3_.Conditions[0] = param2.Condition[0];
         }
         if(Visible)
         {
            this.UpdateUI();
         }
         this.UpdataStatus(param2.Index,param2.Status,param2.Condition);
      }
   }
}

