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
   import Processors.Game.Lobby.Activity.HDActivity.THDOSTabWindowBase;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.TUIActivityOSAwardList;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.utils.*;
   
   public class TProcessorWindowHDCampBattle extends THDOSTabWindowBase
   {
      
      protected static const Activity_CampBattle:uint = CONST_ACTIVITY_MODE.Activity_CampBattle;
      
      protected static const COUNT_TF_Condition:uint = 2;
      
      protected static const COUNT_Slot_Award:uint = 8;
      
      protected static const COUNT_MC_Stage:uint = 2;
      
      protected static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      protected static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      protected static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected var FMC_Award:Sprite;
      
      protected var FMC_TargetAward:MovieClip;
      
      protected var FHDCampBattle:THDCampBattle;
      
      protected var FDataCampBattle:TActivityOSCampBattle;
      
      protected var FAwardPromptVect:Vector.<String>;
      
      protected var FAwardInventories:Vector.<TInventories>;
      
      protected var FBoxStage:int;
      
      protected var FAwardList:TUIActivityOSAwardList;
      
      protected var FLimitCountVect:Vector.<uint>;
      
      protected var FUITab:TUITab;
      
      protected var FTabIndex:uint;
      
      public function TProcessorWindowHDCampBattle(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_CampBattle;
         this.FTabIndex = 0;
         this.FDataCampBattle = new TActivityOSCampBattle();
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
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_ActivityOSCampBattle) as Sprite;
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
         this.FAwardList.SetShortcutHyperlinks(0);
         this.FAwardList.OnTextClick = this.TextGotoLinkOnClick;
         this.FAwardList.OnBtnOkClick = this.BtnOKOnClick;
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHDCampBattle = FHDActivityConfig as THDCampBattle;
         this.FAwardInventories = ProcessorGetInventoriesVectByAwardID(this.FHDCampBattle.AwardValueVect);
         this.FAwardPromptVect = this.FHDCampBattle.AwardPromptVect;
         this.UpdateStageUI();
         ProcessorFormatActivityTime(FActivityModes.GetActivityAtomsByActivityID(Activity_CampBattle).StartTime,FActivityModes.GetActivityAtomsByActivityID(Activity_CampBattle).EndTime);
         ProcessorFormatActivityCountDown(FActivityModes.GetActivityAtomsByActivityID(Activity_CampBattle).EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FDataCampBattle = param1 as TActivityOSCampBattle;
         FBoxStatus = this.FDataCampBattle.BoxStatus;
         this.FLimitCountVect = this.FDataCampBattle.LimitCount;
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
      
      override protected function UpdataStatus(param1:uint, param2:int, param3:Vector.<int>) : void
      {
         super.UpdataStatus(param1,param2,param3);
         this.FLimitCountVect[param1] = param3[0];
         this.UpdateUI();
      }
      
      override protected function Reset() : void
      {
         super.Reset();
         if(this.FUITab != null)
         {
            this.FUITab.Reset();
         }
         if(this.FAwardList != null)
         {
            this.FAwardList.Clear();
         }
      }
      
      override protected function UpdateUIList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         _loc2_ = int(COUNT_TF_Condition);
         _loc3_ = new Vector.<String>(_loc2_);
         _loc3_[0] = this.FAwardPromptVect[this.FTabIndex];
         _loc3_[1] = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_42),this.FLimitCountVect[this.FTabIndex]);
         this.FAwardList.Clear();
         this.FAwardList.UpDateUI(this.FTabIndex,this.FAwardInventories[this.FTabIndex],_loc3_);
         this.FAwardList.SetShortcutHyperlinks(0);
         this.FAwardList.UpDateBtn(FBoxStatus[this.FTabIndex]);
      }
      
      protected function UpdateStageUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         if(this.FUITab == null)
         {
            return;
         }
         _loc2_ = int(COUNT_MC_Stage);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FUITab.GetTabByIndex(_loc1_);
            _loc3_[CONST_ACTIVITY.RESOURCE_Link_MC_Pic][CONST_ACTIVITY.RESOURCE_Link_TF_Name].text = this.FAwardPromptVect[_loc1_];
            _loc1_++;
         }
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.SetData(FActivityInitRetData,this.FDataCampBattle);
         this.UpdateDataBase(this.FDataCampBattle);
      }
      
      private function SetData(param1:TActivityInitRetData, param2:TActivityOSCampBattle) : void
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
         param2.LimitCount = _loc5_;
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         super.BtnOKOnClick(param1,param2);
      }
      
      override protected function TextGotoLinkOnClick(param1:Object, param2:uint) : void
      {
         super.TextGotoLinkOnClick(param1,param2);
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_WorldMap);
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

