package Processors.Game.Lobby.Activity.HDActivityOS.windows
{
   import Components.Standard.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.*;
   import Processors.Game.Lobby.Utilities.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowHDLevelSeat extends THDOSTabWindowBase
   {
      
      protected static const Activity_LevelSeat:uint = CONST_ACTIVITY_MODE.Activity_LevelSeat;
      
      protected static const COUNT_TF_Condition:uint = 2;
      
      protected static const COUNT_Slot_Award:uint = 8;
      
      protected static const COUNT_MC_Stage:uint = 3;
      
      protected static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      protected static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      protected static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected var FMC_Award:Sprite;
      
      protected var FMC_TargetAward:MovieClip;
      
      protected var FHDLevelSeat:THDLevelSeat;
      
      protected var FAwardPromptVect:Vector.<String>;
      
      protected var FDataLevelSeat:TActivityOSLevelSeat;
      
      protected var FAwardList:TUIActivityOSAwardList;
      
      protected var FAwardInventoriesVect:Vector.<TInventories>;
      
      protected var FPrizeNums:Vector.<uint>;
      
      protected var FBoxStage:int;
      
      protected var FUITab:TUITab;
      
      protected var FTabIndex:uint;
      
      public function TProcessorWindowHDLevelSeat(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_LevelSeat;
         this.FTabIndex = 0;
         this.FDataLevelSeat = new TActivityOSLevelSeat();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityOS);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FAwardList != null)
         {
            this.FAwardList.UpDateSlot();
         }
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_ActivityOSSeat) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         this.FMC_Award = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Award];
         this.FMC_TargetAward = this.FMC_Award[CONST_ACTIVITY.RESOURCE_Link_MC_TargetAward];
         this.FUITab = new TUITab(this);
         _loc2_ = int(COUNT_MC_Stage);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_Award[CONST_ACTIVITY.RESOURCE_Link_MC_ListVect + _loc1_];
            _loc3_.mouseChildren = false;
            _loc4_ = _loc3_[CONST_ACTIVITY.RESOURCE_Link_MC_Prompt];
            _loc4_.mouseChildren = false;
            _loc4_.mouseEnabled = false;
            _loc4_.visible = false;
            this.FUITab.SetTabByIndex(_loc3_,_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FAwardList = new TUIActivityOSAwardList(this);
         this.FAwardList.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
         this.FAwardList.OnSlotOver = ProcessorOnSlotOver;
         this.FAwardList.OnSlotOut = ProcessorOnSlotOut;
         this.FAwardList.OnQuerySubscript = SlotsOnQuerySubscript;
         this.FAwardList.Perform_UIDispatch(this.FMC_TargetAward,COUNT_TF_Condition,COUNT_Slot_Award,false);
         this.FAwardList.OnTextClick = TextGotoLinkOnClick;
         this.FAwardList.OnBtnOkClick = this.BtnOKOnClick;
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIActivityOSAwardList = null;
         var _loc4_:Sprite = null;
         var _loc5_:Vector.<String> = null;
         var _loc6_:MovieClip = null;
         var _loc7_:TextField = null;
         super.UpdateUIConfig();
         this.FHDLevelSeat = FHDActivityConfig as THDLevelSeat;
         this.FAwardInventoriesVect = ProcessorGetInventoriesVectByAwardID(this.FHDLevelSeat.AwardValueVect);
         this.FAwardPromptVect = this.FHDLevelSeat.AwardPromptVect;
         _loc2_ = int(COUNT_MC_Stage);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_ = this.FUITab.GetTabByIndex(_loc1_);
            _loc7_ = _loc6_[CONST_ACTIVITY.RESOURCE_Link_TF_Name];
            _loc7_.text = this.FAwardPromptVect[_loc1_];
            _loc1_++;
         }
         ProcessorFormatActivityTime(FActivityModes.GetActivityAtomsByActivityID(Activity_LevelSeat).StartTime,FActivityModes.GetActivityAtomsByActivityID(Activity_LevelSeat).EndTime);
         ProcessorFormatActivityCountDown(FActivityModes.GetActivityAtomsByActivityID(Activity_LevelSeat).EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FDataLevelSeat = param1 as TActivityOSLevelSeat;
         FBoxStatus = this.FDataLevelSeat.BoxStatus;
         this.FPrizeNums = this.FDataLevelSeat.PrizeNums;
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.UpdateUI();
         if(FBoxStatus == null)
         {
            return;
         }
         _loc2_ = int(FBoxStatus.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(FBoxStatus[_loc1_] == Activity_AlreadyReceive || FBoxStatus[_loc1_] == Activity_CanReceive)
            {
               this.FUITab.GetTabByIndex(_loc1_).MC_Prompt.visible = true;
            }
            else
            {
               this.FUITab.GetTabByIndex(_loc1_).MC_Prompt.visible = false;
            }
            _loc1_++;
         }
         this.FBoxStage = FBoxStatus.indexOf(Activity_CanReceive);
         if(this.FBoxStage == -1)
         {
            this.FBoxStage = FBoxStatus.indexOf(Activity_CanNotReceive);
         }
         if(this.FBoxStage == -1)
         {
            this.FBoxStage = _loc2_ - 1;
         }
         this.FUITab.TabIndex = this.FTabIndex = this.FBoxStage;
         this.TabOnSwitch(this.FBoxStage);
      }
      
      override protected function UpdateUIList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         _loc3_ = new Vector.<String>(COUNT_TF_Condition);
         _loc3_[0] = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_49),this.FAwardPromptVect[this.FTabIndex]);
         _loc3_[1] = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_42),this.FPrizeNums[this.FTabIndex]);
         this.FAwardList.Clear();
         this.FAwardList.UpDateUI(this.FTabIndex,this.FAwardInventoriesVect[this.FTabIndex],_loc3_);
         this.FAwardList.UpDateBtn(FBoxStatus[this.FTabIndex]);
      }
      
      override protected function UpdataStatus(param1:uint, param2:int, param3:Vector.<int>) : void
      {
         super.UpdataStatus(param1,param2,param3);
         this.UpdateUI();
      }
      
      override protected function Reset() : void
      {
         super.Reset();
         if(this.FAwardList != null)
         {
            this.FAwardList.Clear();
         }
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.SetData(FActivityInitRetData,this.FDataLevelSeat);
         this.UpdateDataBase(this.FDataLevelSeat);
      }
      
      private function SetData(param1:TActivityInitRetData, param2:TActivityOSLevelSeat) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<uint> = null;
         var _loc6_:Vector.<int> = null;
         _loc4_ = param1.AwardStates.length;
         _loc5_ = new Vector.<uint>(_loc4_);
         _loc6_ = new Vector.<int>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_[_loc3_] = param1.AwardStates[_loc3_].Conditions[0];
            _loc6_[_loc3_] = param1.AwardStates[_loc3_].State;
            _loc3_++;
         }
         param2.BoxStatus = _loc6_;
         param2.PrizeNums = _loc5_;
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         super.BtnOKOnClick(param1,param2);
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         var _loc2_:int = 0;
         this.FTabIndex = param1 as int;
         this.UpdateUIList();
      }
      
      override public function Show(param1:TActivityAtoms) : void
      {
         super.Show(param1);
         ActivityInitReq(param1.Identifier);
      }
      
      override public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         super.ChangeActivityStatus(param1,param2);
         this.UpdataStatus(param2.Index,param2.Status,param2.Condition);
      }
   }
}

