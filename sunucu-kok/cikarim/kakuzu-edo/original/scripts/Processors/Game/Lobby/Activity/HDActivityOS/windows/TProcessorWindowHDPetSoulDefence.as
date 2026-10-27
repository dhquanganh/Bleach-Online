package Processors.Game.Lobby.Activity.HDActivityOS.windows
{
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
   import Resources.Constants.*;
   import Utilities.Timing.*;
   import flash.display.*;
   import flash.utils.*;
   
   public class TProcessorWindowHDPetSoulDefence extends THDOSTabWindowBase
   {
      
      protected static const COUNT_TF_RankList:uint = 4;
      
      protected static const COUNT_SLOT_Award:uint = 9;
      
      protected static const COUNT_LIST_RankList:uint = 7;
      
      protected var FMC_RankList:Sprite;
      
      protected var FMC_Award:Sprite;
      
      protected var FRankLists:Vector.<TUIActivityOSDARankList>;
      
      protected var FAwardList:TUIActivityOSAwardList;
      
      protected var FHDPetSoulDefence:THDPetSoulDefence;
      
      protected var FDataPetSoulDefence:TActivityOSPetSoulDefence;
      
      protected var FAwardInventoriesVect:Vector.<TInventories>;
      
      public function TProcessorWindowHDPetSoulDefence(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_PetSoulDefence;
         this.FDataPetSoulDefence = new TActivityOSPetSoulDefence();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityOS);
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
         var _loc3_:TUIActivityOSDARankList = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_ActivityOSPetSoulDefence) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         this.FMC_RankList = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_RankList];
         this.FMC_Award = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Award];
         _loc2_ = int(COUNT_LIST_RankList);
         this.FRankLists = new Vector.<TUIActivityOSDARankList>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIActivityOSDARankList(this);
            _loc3_.OnLookInfo = this.ProcessorRankListOnLookInfo;
            _loc3_.Perform_UIDispatch(_loc1_,this.FMC_RankList[CONST_ACTIVITY.RESOURCE_Link_MC_ListVect + _loc1_],COUNT_TF_RankList,2);
            _loc3_.Visible = false;
            this.FRankLists[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FAwardList = new TUIActivityOSAwardList(this);
         this.FAwardList.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
         this.FAwardList.OnSlotOver = ProcessorOnSlotOver;
         this.FAwardList.OnSlotOut = ProcessorOnSlotOut;
         this.FAwardList.OnQuerySubscript = SlotsOnQuerySubscript;
         this.FAwardList.Perform_UIDispatch(this.FMC_Award,0,COUNT_SLOT_Award);
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHDPetSoulDefence = FHDActivityConfig as THDPetSoulDefence;
         this.FAwardInventoriesVect = ProcessorGetInventoriesVectByAwardID(this.FHDPetSoulDefence.Awards);
         ProcessorFormatActivityTime(FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_PetSoulDefence).StartTime,FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_PetSoulDefence).EndTime);
         ProcessorFormatActivityCountDown(FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_PetSoulDefence).EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FDataPetSoulDefence = param1 as TActivityOSPetSoulDefence;
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         var _loc4_:String = null;
         _loc2_ = int(this.FAwardInventoriesVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FAwardList.UpDateUI(_loc1_,this.FAwardInventoriesVect[_loc1_]);
            _loc1_++;
         }
         if(this.FDataPetSoulDefence.Infos == null || this.FDataPetSoulDefence.Infos.length <= 0)
         {
            return;
         }
         _loc2_ = int(this.FRankLists.length);
         _loc3_ = new Vector.<String>(COUNT_TF_RankList);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FDataPetSoulDefence.Infos[_loc1_] != null)
            {
               _loc3_[0] = ProcessorGetDayFromTime(FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_PetSoulDefence).StartTime + _loc1_ * TUtilityTiming.CONST_DAY);
               if(this.FDataPetSoulDefence.Infos[_loc1_].Level <= 0)
               {
                  _loc3_[1] = "";
               }
               else
               {
                  _loc3_[1] = this.FDataPetSoulDefence.Infos[_loc1_].Level.toString();
               }
               _loc3_[2] = this.FDataPetSoulDefence.Infos[_loc1_].Name;
               if(this.FDataPetSoulDefence.Infos[_loc1_].Hurt <= 0)
               {
                  _loc3_[3] = "";
               }
               else
               {
                  _loc3_[3] = this.FDataPetSoulDefence.Infos[_loc1_].Hurt.toString();
               }
               this.FRankLists[_loc1_].ProcessorUpdateUI(_loc3_,this.FDataPetSoulDefence.Infos[_loc1_].Family);
            }
            else
            {
               _loc4_ = ProcessorGetDayFromTime(FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_PetSoulDefence).StartTime + _loc1_ * TUtilityTiming.CONST_DAY);
               this.FRankLists[_loc1_].ProcessorUpdateTF(_loc4_,0);
            }
            this.FRankLists[_loc1_].Visible = true;
            _loc1_++;
         }
      }
      
      override protected function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(this.FRankLists != null && this.FRankLists.length > 0)
         {
            _loc2_ = int(this.FRankLists.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FRankLists[_loc1_].Clear();
               _loc1_++;
            }
         }
         if(this.FAwardList != null)
         {
            this.FAwardList.Clear();
         }
      }
      
      protected function ProcessorRankListOnLookInfo(param1:Object, param2:int) : void
      {
         if(FOnLookInfo != null)
         {
            FOnLookInfo(param1,this.FDataPetSoulDefence.Infos[param2].UserID0,this.FDataPetSoulDefence.Infos[param2].UserID1);
         }
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.SetData(FActivityInitRetData,this.FDataPetSoulDefence);
         this.UpdateDataBase(this.FDataPetSoulDefence);
      }
      
      private function SetData(param1:TActivityInitRetData, param2:TActivityOSPetSoulDefence) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:THDDailyActivityInfo = null;
         var _loc6_:THDOSRank = null;
         var _loc7_:Vector.<Object> = null;
         _loc7_ = param1.AddtionalVecs[0];
         _loc4_ = int(_loc7_.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = _loc7_[_loc3_] as THDOSRank;
            _loc5_ = new THDDailyActivityInfo();
            _loc5_.UserID0 = _loc6_.HighID;
            _loc5_.UserID1 = _loc6_.LowID;
            _loc5_.Family = _loc6_.Family;
            _loc5_.Level = _loc6_.Level;
            _loc5_.Name = _loc6_.Name;
            _loc5_.Hurt = _loc6_.Damage;
            param2.Infos[_loc3_] = _loc5_;
            _loc3_++;
         }
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

