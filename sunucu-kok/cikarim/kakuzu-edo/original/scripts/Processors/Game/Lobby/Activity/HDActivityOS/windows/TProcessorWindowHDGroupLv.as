package Processors.Game.Lobby.Activity.HDActivityOS.windows
{
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivity.THDOSTabWindowBase;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.TUIActivityOSAwardList;
   import Processors.Game.Lobby.Activity.HDActivityOS.Component.TUIActivityOSDARankList;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.HyperLink.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.*;
   
   public class TProcessorWindowHDGroupLv extends THDOSTabWindowBase
   {
      
      protected static const COUNT_TF_RankList:uint = 3;
      
      protected static const COUNT_TF_AwardList:uint = 1;
      
      protected static const COUNT_LIST_RankList:uint = 3;
      
      protected static const COUNT_LIST_AwardList:uint = 3;
      
      protected static const COUNT_SLOT_AwardList:uint = 3;
      
      protected var FMC_RankList:Sprite;
      
      protected var FMC_AwardList:Sprite;
      
      protected var FHDActivityGroupLv:THDGroupLv;
      
      protected var FDataActivityGroupLv:TActivityOSGroupLv;
      
      protected var FAwardInventoriesVect:Vector.<TInventories>;
      
      protected var FRankLists:Vector.<TUIActivityOSDARankList>;
      
      protected var FAwardLists:Vector.<TUIActivityOSAwardList>;
      
      public function TProcessorWindowHDGroupLv(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_GroupLv;
         this.FDataActivityGroupLv = new TActivityOSGroupLv();
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
         if(this.FAwardLists != null && this.FAwardLists.length > 0)
         {
            _loc2_ = int(this.FAwardLists.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FAwardLists[_loc1_].UpDateSlot();
               _loc1_++;
            }
         }
      }
      
      override protected function InitWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TUIActivityOSDARankList = null;
         var _loc4_:TUIActivityOSAwardList = null;
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_ActivityOSGroupLv) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         this.FMC_RankList = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_RankList];
         this.FMC_AwardList = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Award];
         _loc2_ = int(COUNT_LIST_RankList);
         this.FRankLists = new Vector.<TUIActivityOSDARankList>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = new TUIActivityOSDARankList(this);
            _loc3_.Perform_UIDispatch(_loc1_,this.FMC_RankList[CONST_ACTIVITY.RESOURCE_Link_MC_ListVect + _loc1_],COUNT_TF_RankList);
            _loc3_.Visible = false;
            this.FRankLists[_loc1_] = _loc3_;
            _loc1_++;
         }
         _loc2_ = int(COUNT_LIST_AwardList);
         this.FAwardLists = new Vector.<TUIActivityOSAwardList>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new TUIActivityOSAwardList(this);
            _loc4_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            _loc4_.OnSlotOver = ProcessorOnSlotOver;
            _loc4_.OnSlotOut = ProcessorOnSlotOut;
            _loc4_.OnQuerySubscript = SlotsOnQuerySubscript;
            _loc4_.Perform_UIDispatch(this.FMC_AwardList[CONST_ACTIVITY.RESOURCE_Link_MC_ListVect + _loc1_],COUNT_TF_AwardList,COUNT_SLOT_AwardList,false);
            _loc4_.Visible = false;
            this.FAwardLists[_loc1_] = _loc4_;
            _loc1_++;
         }
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<String> = null;
         super.UpdateUIConfig();
         this.FHDActivityGroupLv = FHDActivityConfig as THDGroupLv;
         this.FAwardInventoriesVect = ProcessorGetInventoriesVectByAwardID(this.FHDActivityGroupLv.Awards);
         ProcessorFormatActivityTime(FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_GroupLv).StartTime,FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_GroupLv).EndTime);
         ProcessorFormatActivityCountDown(FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_GroupLv).EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FDataActivityGroupLv = param1 as TActivityOSGroupLv;
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<String> = null;
         var _loc6_:Vector.<String> = null;
         var _loc7_:Vector.<String> = null;
         _loc2_ = int(this.FAwardInventoriesVect.length);
         _loc6_ = new Vector.<String>(COUNT_TF_AwardList);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc6_[0] = this.FHDActivityGroupLv.Condition[_loc1_].Prompt;
            this.FAwardLists[_loc1_].UpDateUI(_loc1_,this.FAwardInventoriesVect[_loc1_],_loc6_);
            this.FAwardLists[_loc1_].Visible = true;
            _loc1_++;
         }
         if(this.FDataActivityGroupLv.Info == null)
         {
            return;
         }
         _loc2_ = int(COUNT_LIST_RankList);
         _loc7_ = new Vector.<String>();
         _loc5_ = new Vector.<String>(COUNT_TF_RankList);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = int(COUNT_TF_RankList);
            if(_loc1_ == 0)
            {
               _loc7_ = this.FDataActivityGroupLv.Info.OrgRank0;
            }
            else if(_loc1_ == 1)
            {
               _loc7_ = this.FDataActivityGroupLv.Info.OrgRank1;
            }
            else if(_loc1_ == 2)
            {
               _loc7_ = this.FDataActivityGroupLv.Info.OrgRank2;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(_loc3_ >= _loc7_.length)
               {
                  _loc5_[_loc3_] = "";
               }
               else
               {
                  _loc5_[_loc3_] = _loc7_[_loc3_];
               }
               _loc3_++;
            }
            if(_loc1_ < this.FRankLists.length)
            {
               this.FRankLists[_loc1_].ProcessorUpdateUI(_loc5_,_loc1_ + 1);
               this.FRankLists[_loc1_].Visible = true;
            }
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
         if(this.FAwardLists != null && this.FAwardLists.length > 0)
         {
            _loc2_ = int(this.FAwardLists.length);
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FAwardLists[_loc1_].Clear();
               _loc1_++;
            }
         }
      }
      
      override protected function UpdateSCData(param1:ByteArray) : void
      {
         super.UpdateSCData(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         this.SetData(FActivityInitRetData,this.FDataActivityGroupLv);
         this.UpdateDataBase(this.FDataActivityGroupLv);
      }
      
      private function SetData(param1:TActivityInitRetData, param2:TActivityOSGroupLv) : void
      {
         var _loc3_:Vector.<Vector.<String>> = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc5_ = param1.AddtionalVecs[0].length;
         _loc3_ = new Vector.<Vector.<String>>(_loc5_);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_[_loc4_] = param1.AddtionalVecs[0][_loc4_] as Vector.<String>;
            _loc4_++;
         }
         param2.Info.OrgRank0 = _loc3_[0];
         param2.Info.OrgRank1 = _loc3_[1];
         param2.Info.OrgRank2 = _loc3_[2];
      }
      
      override protected function BtnGotoLinkOnClcik(param1:Object, param2:MouseEvent) : void
      {
         super.BtnGotoLinkOnClcik(param1,param2);
         if(SLogicsCore.Organization.OrgId > 0)
         {
            SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Organization);
         }
         else if(FOnEffectText != null)
         {
            FOnEffectText(this,TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_45));
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

