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
   
   public class TProcessorWindowHDLevelRank extends THDOSTabWindowBase
   {
      
      protected static const COUNT_TF_PROMPT:uint = 1;
      
      protected var FMC_RankList:MovieClip;
      
      protected var FTF_CurRank:TextField;
      
      protected var FMC_Award:MovieClip;
      
      protected var FUIScrollBarRank:TScrollBar;
      
      protected var FUIScrollBarAward:TScrollBar;
      
      protected var FHDLevelRank:THDLevelRank;
      
      protected var FHDInventoriesVect:Vector.<TInventories>;
      
      protected var FHDAwardTextVect:Vector.<String>;
      
      protected var FDataLevelRank:TActivityOSLevelRank;
      
      protected var FRankListVect:Vector.<TUIActivityOSRankList>;
      
      protected var FAwardListVect:Vector.<TUIActivityOSAwardList>;
      
      protected var FRankListCount:int;
      
      public function TProcessorWindowHDLevelRank(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_LevelRank;
         this.FHDAwardTextVect = new Vector.<String>(COUNT_TF_PROMPT);
         this.FRankListCount = 100;
         this.FRankListVect = new Vector.<TUIActivityOSRankList>(this.FRankListCount);
         this.FDataLevelRank = new TActivityOSLevelRank();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityOS);
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
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIActivityOSRankList = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_ActivityOSLevelRank) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
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
         var _loc4_:Vector.<Object> = null;
         var _loc5_:Sprite = null;
         var _loc6_:Vector.<String> = null;
         super.UpdateUIConfig();
         if(FHDActivityConfig == null)
         {
            return;
         }
         this.FHDLevelRank = FHDActivityConfig as THDLevelRank;
         _loc4_ = this.FHDLevelRank.ActAwardVect;
         _loc2_ = int(_loc4_.length);
         this.FHDAwardTextVect = this.FHDLevelRank.AwardPromptVect;
         this.FHDInventoriesVect = ProcessorGetInventoriesVectByAwardID(this.FHDLevelRank.AwardValueVect);
         _loc2_ = int(_loc4_.length);
         this.FAwardListVect = new Vector.<TUIActivityOSAwardList>(_loc2_);
         _loc6_ = new Vector.<String>(1);
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
         ProcessorFormatActivityTime(FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_LevelRank).StartTime,FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_LevelRank).EndTime);
         ProcessorFormatActivityCountDown(FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_LevelRank).EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FDataLevelRank = param1 as TActivityOSLevelRank;
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
         if(this.FDataLevelRank.MyCurRank == -1)
         {
            this.FTF_CurRank.text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_48),this.FDataLevelRank.RankList.length);
         }
         else
         {
            this.FTF_CurRank.text = this.FDataLevelRank.MyCurRank.toString();
         }
         this.FUIScrollBarRank.Clear();
         _loc2_ = int(this.FDataLevelRank.RankList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIActivityOSRankList(this);
            _loc4_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_UIActivityOSRankListElement) as Sprite;
            _loc3_.Perform_UIDispatch(_loc4_);
            _loc3_.UpDateList(this.FDataLevelRank.RankList[_loc1_]);
            this.FUIScrollBarRank.AddItem(_loc3_);
            _loc3_.y = _loc1_ * 23;
            _loc1_++;
         }
         this.FUIScrollBarRank.ScrollToUp();
         this.FUIScrollBarRank.Visible = true;
         _loc2_ = int(this.FHDInventoriesVect.length);
         _loc5_ = new Vector.<String>(COUNT_TF_PROMPT);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_[0] = this.FHDAwardTextVect[_loc1_];
            this.FAwardListVect[_loc1_].UpDateUI(_loc1_,this.FHDInventoriesVect[_loc1_],_loc5_);
            _loc1_++;
         }
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
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.SetData(FActivityInitRetData,this.FDataLevelRank);
         this.UpdateDataBase(this.FDataLevelRank);
      }
      
      private function SetData(param1:TActivityInitRetData, param2:TActivityOSLevelRank) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Vector.<int> = null;
         var _loc6_:THDOSRank = null;
         var _loc7_:Vector.<Object> = null;
         var _loc8_:Vector.<THDOSRank> = null;
         param2.MyCurRank = -1;
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
               param2.MyCurRank = _loc6_.Rank;
            }
            _loc3_++;
         }
         param2.RankList = _loc8_;
      }
      
      override public function Show(param1:TActivityAtoms) : void
      {
         super.Show(param1);
         ActivityInitReq(param1.Identifier);
      }
      
      override public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         super.ChangeActivityStatus(param1,param2);
         UpdataStatus(param2.Index,param2.Status,param2.Condition);
      }
   }
}

