package Processors.Game.Lobby.Activity.HDActivityOS.windows
{
   import Components.ScrollBar.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
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
   import Processors.Game.Utilities.HyperLink.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowHDArenaRank extends THDOSTabWindowBase
   {
      
      protected static const COUNT_TF_RankList:uint = 4;
      
      protected static const COUNT_MC_RankList:uint = 3;
      
      protected static const COUNT_TF_LuckyNum:uint = 1;
      
      protected static const COUNT_Slot_LuckyAward:uint = 1;
      
      protected static const COUNT_TF_Award:uint = 1;
      
      protected static const COUNT_Slot_Award:uint = 8;
      
      protected static const COUNT_DayFromOpenServerDay:uint = 7;
      
      protected static const ALLDAY_TIME:uint = CONST_ACTIVITY.ALLDAY_TIME;
      
      protected var FMC_AwardList:MovieClip;
      
      protected var FMC_RankList:MovieClip;
      
      protected var FMC_LuckyAward:MovieClip;
      
      protected var FHDArenaRank:THDArenaRank;
      
      protected var FDataArenaRank:TActivityOSArenaRank;
      
      protected var FRankListVect:Vector.<Sprite>;
      
      protected var FAwardPromptVect:Vector.<String>;
      
      protected var FAwardInventoriesVect:Vector.<TInventories>;
      
      protected var FAwardListVect:Vector.<TUIActivityOSAwardList>;
      
      protected var FLuckyInventoriesVect:Vector.<TInventories>;
      
      protected var FLuckyNumVect:Vector.<Vector.<uint>>;
      
      protected var FLuckyAwardList:TUIActivityOSAwardList;
      
      protected var FUIScrollBarAward:TScrollBar;
      
      public function TProcessorWindowHDArenaRank(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_ArenaRank;
         this.FDataArenaRank = new TActivityOSArenaRank();
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
         if(this.FLuckyAwardList != null)
         {
            this.FLuckyAwardList.UpDateSlot();
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
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_ActivityOSArenaRank) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         this.FMC_RankList = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_RankList];
         _loc2_ = int(COUNT_MC_RankList);
         this.FRankListVect = new Vector.<Sprite>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_RankList[CONST_ACTIVITY.RESOURCE_Link_MC_ListVect + _loc1_];
            this.FRankListVect[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FMC_LuckyAward = this.FMC_RankList[CONST_ACTIVITY.RESOURCE_Link_MC_Award];
         this.FMC_AwardList = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Award];
         this.FLuckyAwardList = new TUIActivityOSAwardList(this);
         this.FLuckyAwardList.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
         this.FLuckyAwardList.OnSlotOver = ProcessorOnSlotOver;
         this.FLuckyAwardList.OnSlotOut = ProcessorOnSlotOut;
         this.FLuckyAwardList.OnQuerySubscript = SlotsOnQuerySubscript;
         this.FLuckyAwardList.Perform_UIDispatch(this.FMC_LuckyAward,COUNT_TF_Award,COUNT_Slot_LuckyAward,false);
         this.FLuckyAwardList.UpDateUI(0);
         this.FUIScrollBarAward = new TScrollBar(this.FMC_AwardList[CONST_ACTIVITY.RESOURCE_Link_MC_List],130,false,0,60);
         this.FUIScrollBarAward.Visible = false;
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIActivityOSAwardList = null;
         var _loc4_:Sprite = null;
         super.UpdateUIConfig();
         this.FHDArenaRank = FHDActivityConfig as THDArenaRank;
         this.FAwardInventoriesVect = ProcessorGetInventoriesVectByAwardID(this.FHDArenaRank.AwardValueVect);
         this.FAwardPromptVect = this.FHDArenaRank.AwardPromptVect;
         _loc2_ = int(this.FAwardPromptVect.length);
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
            _loc4_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_UIActivityOSArenaRankAwardListElement) as Sprite;
            _loc3_.Perform_UIDispatch(_loc4_,COUNT_TF_Award,COUNT_Slot_Award);
            this.FUIScrollBarAward.AddItem(_loc3_);
            _loc3_.y = _loc1_ * 68;
            this.FAwardListVect[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FUIScrollBarAward.ScrollToUp();
         this.FUIScrollBarAward.Visible = true;
         ProcessorFormatActivityTime(FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_ArenaRank).StartTime,FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_ArenaRank).EndTime);
         ProcessorFormatActivityCountDown(FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_ArenaRank).EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FDataArenaRank = param1 as TActivityOSArenaRank;
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         super.UpdateUI();
         this.UpdateRankListUI();
         _loc2_ = int(this.FAwardInventoriesVect.length);
         _loc3_ = new Vector.<String>(COUNT_TF_LuckyNum);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_[0] = this.FAwardPromptVect[_loc1_];
            this.FAwardListVect[_loc1_].UpDateUI(_loc1_,this.FAwardInventoriesVect[_loc1_],_loc3_);
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
         this.FLuckyAwardList.Clear();
      }
      
      protected function UpdateRankListUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<uint> = null;
         var _loc7_:Vector.<Vector.<String>> = null;
         var _loc8_:Vector.<TFixedAward> = null;
         var _loc9_:TextField = null;
         var _loc10_:Vector.<String> = null;
         var _loc11_:uint = 0;
         _loc6_ = this.FHDArenaRank.RankDayVect;
         _loc7_ = this.FHDArenaRank.LuckyVect;
         _loc8_ = this.FHDArenaRank.LuckyItemVect;
         _loc2_ = int(this.FRankListVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc9_ = this.FRankListVect[_loc1_][CONST_ACTIVITY.RESOURCE_Link_TF_Prompt + 0];
            _loc9_.htmlText = this.ProcessorGetDate(_loc6_[_loc1_]);
            _loc4_ = int(COUNT_TF_RankList);
            _loc3_ = 1;
            while(_loc3_ < _loc4_)
            {
               _loc5_ = _loc3_ - 1 + _loc1_ * 3;
               _loc9_ = this.FRankListVect[_loc1_][CONST_ACTIVITY.RESOURCE_Link_TF_Prompt + _loc3_];
               if(this.FDataArenaRank.RankList[_loc5_].HighID > 0 || this.FDataArenaRank.RankList[_loc5_].LowID > 0)
               {
                  _loc9_.htmlText = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_40),_loc3_,this.FDataArenaRank.RankList[_loc5_].Name,this.FDataArenaRank.RankList[_loc5_].Level);
               }
               else
               {
                  _loc9_.htmlText = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_41);
               }
               _loc3_++;
            }
            _loc1_++;
         }
         _loc11_ = this.ProcessorGetDayCount();
         if(_loc11_ >= COUNT_DayFromOpenServerDay)
         {
            _loc11_ = COUNT_DayFromOpenServerDay - 1;
         }
         this.FLuckyAwardList.UpDateUI(0,ProcessorGetInventories(0,this.FHDArenaRank.LuckyItemVect),_loc7_[_loc11_]);
      }
      
      protected function ProcessorGetDate(param1:uint) : String
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:Date = null;
         _loc3_ = FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_ArenaRank).StartTime;
         _loc2_ = uint(STimingCore.ServerStartTime);
         _loc4_ = new Date(_loc3_ * 1000 + (param1 - 1) * ALLDAY_TIME * 1000);
         if(false)
         {
            return TUtilityDate.FormatDateAmerican(_loc4_);
         }
         return TUtilityDate.FormatDateChinese(_loc4_);
      }
      
      protected function ProcessorGetDayCount() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc1_ = uint(STimingCore.ServerTime);
         _loc2_ = FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_ArenaRank).StartTime;
         _loc3_ = _loc1_ - _loc2_;
         return uint(Math.floor((_loc3_ - _loc3_ % ALLDAY_TIME) / ALLDAY_TIME));
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:THDOSRank = null;
         var _loc5_:Vector.<THDOSRank> = null;
         var _loc6_:Vector.<Object> = null;
         super.UpdateSCData(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         _loc6_ = FActivityInitRetData.AddtionalVecs[0];
         _loc3_ = _loc6_.length;
         _loc5_ = new Vector.<THDOSRank>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = _loc6_[_loc2_] as THDOSRank;
            _loc5_[_loc2_] = _loc4_;
            _loc2_++;
         }
         this.FDataArenaRank.RankList = _loc5_;
         this.UpdateDataBase(this.FDataArenaRank);
      }
      
      override protected function BtnGotoLinkOnClcik(param1:Object, param2:MouseEvent) : void
      {
         super.BtnGotoLinkOnClcik(param1,param2);
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Arena);
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

