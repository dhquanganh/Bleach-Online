package Processors.Game.Lobby.Activity.HDActivityOS.windows
{
   import Components.ScrollBar.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
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
   
   public class TProcessorWindowHDPowerRank extends THDOSTabWindowBase
   {
      
      protected static const Activity_CanNotReceive:uint = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      protected static const Activity_AlreadyReceive:uint = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      protected static const Activity_CanReceive:uint = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected static const MAX_COUNT_ShowTarget:uint = 1;
      
      protected static const MAX_COUNT_TFPrompt:uint = 1;
      
      protected var FMC_TargetAward:MovieClip;
      
      protected var FMC_RankList:MovieClip;
      
      protected var FMC_Award:MovieClip;
      
      protected var FTF_CurRank:TextField;
      
      protected var FUIScrollBarRank:TScrollBar;
      
      protected var FUIScrollBarAward:TScrollBar;
      
      protected var FHDPowerRank:THDPowerRank;
      
      protected var FDataPowerRank:TActivityOSPowerRank;
      
      protected var FTargetPromptVect:Vector.<String>;
      
      protected var FTargetInventoriesVect:Vector.<TInventories>;
      
      protected var FBoxStage:uint;
      
      protected var FTargetList:TUIActivityOSAwardList;
      
      protected var FAwardListVect:Vector.<TUIActivityOSAwardList>;
      
      protected var FInventoriesVect:Vector.<TInventories>;
      
      protected var FPromptVect:Vector.<String>;
      
      public function TProcessorWindowHDPowerRank(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_PowerRank;
         this.FDataPowerRank = new TActivityOSPowerRank();
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
         if(this.FTargetList != null)
         {
            this.FTargetList.UpDateSlot();
         }
      }
      
      override protected function InitWindow() : void
      {
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_ActivityOSPowerRank) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         this.FMC_TargetAward = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_TargetAward];
         this.FMC_RankList = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_RankList];
         this.FTF_CurRank = this.FMC_RankList[CONST_ACTIVITY.RESOURCE_Link_TF_CurRank];
         this.FMC_Award = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Award];
         this.FUIScrollBarRank = new TScrollBar(this.FMC_RankList[CONST_ACTIVITY.RESOURCE_Link_MC_List],138,false,0,23);
         this.FUIScrollBarRank.Visible = false;
         this.FUIScrollBarAward = new TScrollBar(this.FMC_Award[CONST_ACTIVITY.RESOURCE_Link_MC_List],178,false,0,60);
         this.FUIScrollBarAward.Visible = false;
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIActivityOSAwardList = null;
         var _loc4_:Vector.<String> = null;
         var _loc5_:Sprite = null;
         super.UpdateUIConfig();
         this.FHDPowerRank = FHDActivityConfig as THDPowerRank;
         this.FInventoriesVect = ProcessorGetInventoriesVectByAwardID(this.FHDPowerRank.AwardValueVect);
         this.FPromptVect = this.FHDPowerRank.AwardPromptVect;
         _loc2_ = int(this.FInventoriesVect.length);
         this.FAwardListVect = new Vector.<TUIActivityOSAwardList>(_loc2_);
         _loc4_ = new Vector.<String>(MAX_COUNT_ShowTarget);
         this.FUIScrollBarAward.Clear();
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIActivityOSAwardList(this);
            _loc3_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            _loc3_.OnSlotOver = ProcessorOnSlotOver;
            _loc3_.OnSlotOut = ProcessorOnSlotOut;
            _loc3_.OnQuerySubscript = SlotsOnQuerySubscript;
            _loc5_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_UIActivityOSLevelRankAwardListElement) as Sprite;
            _loc3_.Perform_UIDispatch(_loc5_,1,4);
            this.FUIScrollBarAward.AddItem(_loc3_);
            _loc3_.y = _loc1_ * 68;
            this.FAwardListVect[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FUIScrollBarAward.ScrollToUp();
         this.FUIScrollBarAward.Visible = true;
         this.FTargetInventoriesVect = ProcessorGetInventoriesVectByAwardID(this.FHDPowerRank.TargetValueVect);
         this.FTargetPromptVect = this.FHDPowerRank.TargetKeyVect;
         this.FTargetList = new TUIActivityOSAwardList(this);
         this.FTargetList.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
         this.FTargetList.OnSlotOver = ProcessorOnSlotOver;
         this.FTargetList.OnSlotOut = ProcessorOnSlotOut;
         this.FTargetList.OnQuerySubscript = SlotsOnQuerySubscript;
         this.FTargetList.Perform_UIDispatch(this.FMC_TargetAward,2,5);
         this.FTargetList.OnBtnOkClick = this.BtnOKOnClick;
         ProcessorFormatActivityTime(FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_PowerRank).StartTime,FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_PowerRank).EndTime);
         ProcessorFormatActivityCountDown(FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_PowerRank).EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FDataPowerRank = param1 as TActivityOSPowerRank;
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIActivityOSRankList = null;
         var _loc4_:Sprite = null;
         var _loc5_:Vector.<String> = null;
         super.UpdateUI();
         if(this.FDataPowerRank.MyRank == -1)
         {
            this.FTF_CurRank.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_48),this.FDataPowerRank.RankList.length);
         }
         else
         {
            this.FTF_CurRank.text = this.FDataPowerRank.MyRank.toString();
         }
         this.FUIScrollBarRank.Clear();
         _loc2_ = int(this.FDataPowerRank.RankList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIActivityOSRankList(this);
            _loc4_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_UIActivityOSRankListElement) as Sprite;
            _loc3_.Perform_UIDispatch(_loc4_);
            _loc3_.UpDateList(this.FDataPowerRank.RankList[_loc1_]);
            this.FUIScrollBarRank.AddItem(_loc3_);
            _loc3_.y = _loc1_ * 23;
            _loc1_++;
         }
         this.FUIScrollBarRank.ScrollToUp();
         this.FUIScrollBarRank.Visible = true;
         this.UpdateTargetAwardUI();
         _loc2_ = int(this.FAwardListVect.length);
         _loc5_ = new Vector.<String>(MAX_COUNT_TFPrompt);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_[0] = this.FPromptVect[_loc1_];
            this.FAwardListVect[_loc1_].UpDateUI(_loc1_,this.FInventoriesVect[_loc1_],_loc5_);
            _loc1_++;
         }
      }
      
      override protected function UpdataStatus(param1:uint, param2:int, param3:Vector.<int>) : void
      {
         super.UpdataStatus(param1,param2,param3);
         this.UpdateTargetAwardUI();
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Reset();
         _loc2_ = int(this.FAwardListVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAwardListVect[_loc1_].Clear();
            _loc1_++;
         }
         this.FTargetList.Clear();
      }
      
      protected function UpdateTargetAwardUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIActivityOSAwardList = null;
         var _loc4_:Vector.<String> = null;
         FBoxStatus = this.FDataPowerRank.BoxStatus;
         _loc2_ = int(FBoxStatus.length);
         this.FBoxStage = _loc2_ - 1;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(FBoxStatus[_loc1_] == Activity_CanNotReceive || FBoxStatus[_loc1_] == Activity_CanReceive)
            {
               this.FBoxStage = _loc1_;
               break;
            }
            _loc1_++;
         }
         _loc2_ = 2;
         _loc4_ = new Vector.<String>(_loc2_);
         _loc4_[0] = this.FTargetPromptVect[this.FBoxStage];
         _loc4_[1] = this.FDataPowerRank.MyHistoryPower.toString();
         this.FTargetList.UpDateUI(this.FBoxStage,this.FTargetInventoriesVect[this.FBoxStage],_loc4_);
         this.FTargetList.UpDateBtn(FBoxStatus[this.FBoxStage]);
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.SetData(FActivityInitRetData,this.FDataPowerRank);
         this.UpdateDataBase(this.FDataPowerRank);
      }
      
      private function SetData(param1:TActivityInitRetData, param2:TActivityOSPowerRank) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:THDOSRank = null;
         var _loc7_:Vector.<Object> = null;
         var _loc8_:Vector.<THDOSRank> = null;
         param2.MyRank = -1;
         param2.MyHistoryPower = param1.ParameterVec[0];
         _loc4_ = param1.AwardStates.length;
         _loc5_ = new Vector.<int>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_[_loc3_] = param1.AwardStates[_loc3_].State;
            _loc3_++;
         }
         _loc7_ = param1.AddtionalVecs[0];
         _loc4_ = _loc7_.length;
         _loc8_ = new Vector.<THDOSRank>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _loc7_[_loc3_] as THDOSRank;
            _loc8_[_loc3_] = _loc6_;
            if(_loc6_.HighID == SLogicsCore.Character.Identifier0 && _loc6_.LowID == SLogicsCore.Character.Identifier1)
            {
               param2.MyRank = _loc6_.Rank;
            }
            _loc3_++;
         }
         param2.BoxStatus = _loc5_;
         param2.RankList = _loc8_;
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

