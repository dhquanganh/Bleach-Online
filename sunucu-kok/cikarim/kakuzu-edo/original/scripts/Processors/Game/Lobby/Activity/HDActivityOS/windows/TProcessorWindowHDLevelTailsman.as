package Processors.Game.Lobby.Activity.HDActivityOS.windows
{
   import Components.ScrollBar.TScrollBar;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDLevelTailsman;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDActivityOS.TActivityOSLevelTalisman;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDActivity.THDOSTabWindowBase;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.TUIActivityOSAwardList;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowHDLevelTailsman extends THDOSTabWindowBase
   {
      
      protected static const Activity_LevelTalisman:uint = CONST_ACTIVITY_MODE.Activity_LevelTalisman;
      
      protected static const COUNT_TF_Condition:uint = 2;
      
      protected static const COUNT_Slot_Award:uint = 8;
      
      protected static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      protected static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      protected static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected var FMC_Award:Sprite;
      
      protected var FMC_List:MovieClip;
      
      protected var FUIScrollBar:TScrollBar;
      
      protected var FDataLevelTailsman:TActivityOSLevelTalisman;
      
      protected var FHDLevelTailsman:THDLevelTailsman;
      
      protected var FAwardPromptVect:Vector.<String>;
      
      protected var FAwardInventoriesVect:Vector.<TInventories>;
      
      protected var FAwardListVect:Vector.<TUIActivityOSAwardList>;
      
      public function TProcessorWindowHDLevelTailsman(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_LevelTalisman;
         this.FDataLevelTailsman = new TActivityOSLevelTalisman();
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
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.LogicsPerform();
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
      
      override protected function InitWindow() : void
      {
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_ActivityOSLevelTalisman) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         this.FMC_Award = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Award];
         this.FMC_List = this.FMC_Award[CONST_ACTIVITY.RESOURCE_Link_MC_List];
         this.FUIScrollBar = new TScrollBar(this.FMC_List,242,false,0,90);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIActivityOSAwardList = null;
         var _loc4_:Sprite = null;
         var _loc5_:Vector.<String> = null;
         super.UpdateUIConfig();
         this.FHDLevelTailsman = FHDActivityConfig as THDLevelTailsman;
         this.FAwardInventoriesVect = ProcessorGetInventoriesVectByAwardID(this.FHDLevelTailsman.AwardValueVect);
         this.FAwardPromptVect = this.FHDLevelTailsman.AwardPromptVect;
         _loc2_ = int(this.FAwardInventoriesVect.length);
         this.FAwardListVect = new Vector.<TUIActivityOSAwardList>(_loc2_);
         _loc5_ = new Vector.<String>(COUNT_TF_Condition);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIActivityOSAwardList(this);
            _loc3_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            _loc3_.OnSlotOver = ProcessorOnSlotOver;
            _loc3_.OnSlotOut = ProcessorOnSlotOut;
            _loc3_.OnQuerySubscript = SlotsOnQuerySubscript;
            _loc4_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_UIActivityOSCompoundStoneAwardListElement) as Sprite;
            _loc3_.Perform_UIDispatch(_loc4_,COUNT_TF_Condition,COUNT_Slot_Award);
            _loc3_.OnBtnOkClick = this.BtnOKOnClick;
            this.FUIScrollBar.AddItem(_loc3_);
            _loc3_.y = _loc1_ * 92;
            this.FAwardListVect[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FUIScrollBar.ScrollToUp();
         this.FUIScrollBar.Visible = true;
         ProcessorFormatActivityTime(FActivityModes.GetActivityAtomsByActivityID(Activity_LevelTalisman).StartTime,FActivityModes.GetActivityAtomsByActivityID(Activity_LevelTalisman).EndTime);
         ProcessorFormatActivityCountDown(FActivityModes.GetActivityAtomsByActivityID(Activity_LevelTalisman).EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FDataLevelTailsman = param1 as TActivityOSLevelTalisman;
         FBoxStatus = this.FDataLevelTailsman.BoxStatus;
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         super.UpdateUI();
         if(this.FAwardListVect == null)
         {
            return;
         }
         _loc2_ = int(this.FAwardListVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new Vector.<String>(COUNT_TF_Condition);
            _loc3_[0] = this.FAwardPromptVect[_loc1_];
            _loc3_[1] = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_46),this.FDataLevelTailsman.OwnedCounts[_loc1_],this.FHDLevelTailsman.Conditions[_loc1_].Count);
            this.FAwardListVect[_loc1_].UpDateUI(_loc1_,this.FAwardInventoriesVect[_loc1_],_loc3_);
            this.FAwardListVect[_loc1_].UpDateBtn(FBoxStatus[_loc1_]);
            _loc1_++;
         }
      }
      
      override protected function UpdataStatus(param1:uint, param2:int, param3:Vector.<int>) : void
      {
         super.UpdataStatus(param1,param2,param3);
         this.UpdateUI();
      }
      
      override protected function Reset() : void
      {
         super.Reset();
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.SetData(FActivityInitRetData,this.FDataLevelTailsman);
         this.UpdateDataBase(this.FDataLevelTailsman);
      }
      
      private function SetData(param1:TActivityInitRetData, param2:TActivityOSLevelTalisman) : void
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
         param2.OwnedCounts = _loc5_;
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
         super.ChangeActivityStatus(param1,param2);
         this.UpdataStatus(param2.Index,param2.Status,param2.Condition);
      }
   }
}

