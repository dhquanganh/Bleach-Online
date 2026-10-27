package Processors.Game.Lobby.Activity.HDActivityOS.windows
{
   import Components.ScrollBar.*;
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
   
   public class TProcessorWindowHDRecruitPartner extends THDOSTabWindowBase
   {
      
      protected static const Activity_RecruitPartner:uint = CONST_ACTIVITY_MODE.Activity_RecruitPartner;
      
      protected static const COUNT_TF_Condition:uint = 2;
      
      protected static const COUNT_Slot_Award:uint = 8;
      
      protected var FMC_Award:Sprite;
      
      protected var FHDRecruitPartner:THDRecruitPartner;
      
      protected var FDataRecruitPartner:TActivityOSRecruitPartner;
      
      protected var FAwardListVect:Vector.<TUIActivityOSAwardList>;
      
      protected var FAwardInventoriesVect:Vector.<TInventories>;
      
      protected var FAwardPromptVect:Vector.<String>;
      
      protected var FUIScrollBar:TScrollBar;
      
      public function TProcessorWindowHDRecruitPartner(param1:TUIComponent)
      {
         super(param1);
         FActivityID = CONST_ACTIVITY_MODE.Activity_RecruitPartner;
         this.FDataRecruitPartner = new TActivityOSRecruitPartner();
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
         FMC_Scene = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_ActivityOSRecruitPartner) as Sprite;
         addChild(FMC_Scene);
         super.InitWindow();
         this.FMC_Award = FMC_Scene[CONST_ACTIVITY.RESOURCE_Link_MC_Award];
         this.FUIScrollBar = new TScrollBar(this.FMC_Award[CONST_ACTIVITY.RESOURCE_Link_MC_List],242,false,0,60);
      }
      
      override protected function UpdateUIConfig() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUIActivityOSAwardList = null;
         var _loc6_:Sprite = null;
         super.UpdateUIConfig();
         this.FHDRecruitPartner = FHDActivityConfig as THDRecruitPartner;
         this.FAwardInventoriesVect = ProcessorGetInventoriesVectByAwardID(this.FHDRecruitPartner.AwardValueVect);
         this.FAwardPromptVect = this.FHDRecruitPartner.AwardPromptVect;
         _loc2_ = int(this.FAwardInventoriesVect.length);
         this.FAwardListVect = new Vector.<TUIActivityOSAwardList>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new TUIActivityOSAwardList(this);
            _loc5_.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
            _loc5_.OnSlotOver = ProcessorOnSlotOver;
            _loc5_.OnSlotOut = ProcessorOnSlotOut;
            _loc5_.OnQuerySubscript = SlotsOnQuerySubscript;
            _loc6_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_UIActivityOSPartnerAwardListElement) as Sprite;
            _loc5_.Perform_UIDispatch(_loc6_,COUNT_TF_Condition,COUNT_Slot_Award);
            _loc5_.OnBtnOkClick = this.BtnOKOnClick;
            _loc5_.OnTextClick = this.TextGotoLinkOnClick;
            _loc5_.SetShortcutHyperlinks(0);
            this.FUIScrollBar.AddItem(_loc5_);
            _loc5_.y = _loc1_ * 68;
            this.FAwardListVect[_loc1_] = _loc5_;
            _loc1_++;
         }
         this.FUIScrollBar.ScrollToUp();
         this.FUIScrollBar.Visible = true;
         ProcessorFormatActivityTime(FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_RecruitPartner).StartTime,FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_RecruitPartner).EndTime);
         ProcessorFormatActivityCountDown(FActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_RecruitPartner).EndTime);
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         this.FDataRecruitPartner = param1 as TActivityOSRecruitPartner;
         FBoxStatus = this.FDataRecruitPartner.BoxStatus;
         this.UpdateUI();
      }
      
      override protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Vector.<String> = null;
         super.UpdateUI();
         if(this.FAwardListVect == null)
         {
            return;
         }
         _loc2_ = int(this.FAwardListVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = new Vector.<String>(COUNT_TF_Condition);
            _loc5_[0] = this.FAwardPromptVect[_loc1_];
            _loc5_[1] = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_46),this.FDataRecruitPartner.Conditions[_loc1_],this.FHDRecruitPartner.ConditionCountVect[_loc1_]);
            this.FAwardListVect[_loc1_].UpDateUI(_loc1_,this.FAwardInventoriesVect[_loc1_],_loc5_);
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
         this.SetData(FActivityInitRetData,this.FDataRecruitPartner);
         this.UpdateDataBase(this.FDataRecruitPartner);
      }
      
      protected function SetData(param1:TActivityInitRetData, param2:TActivityOSRecruitPartner) : void
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
         param2.Conditions = _loc5_;
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         super.BtnOKOnClick(param1,param2);
      }
      
      override protected function TextGotoLinkOnClick(param1:Object, param2:uint) : void
      {
         super.TextGotoLinkOnClick(param1,param2);
         SUtilityHyperLink.ShortcutHyperlink(TUtilityHyperLink.HyperLink_Tavern);
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

