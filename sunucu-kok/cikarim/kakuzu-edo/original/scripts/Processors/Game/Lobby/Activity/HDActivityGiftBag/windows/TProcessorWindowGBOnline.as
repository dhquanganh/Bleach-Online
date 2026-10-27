package Processors.Game.Lobby.Activity.HDActivityGiftBag.windows
{
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityGB.*;
   import Logics.HDActivityMode.*;
   import Logics.Inventories.*;
   import Logics.TimeCoolDown.*;
   import Processors.Game.Lobby.Activity.HDActivityGiftBag.*;
   import Processors.Game.Lobby.Activity.HDActivityGiftBag.Component.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.utils.*;
   
   public class TProcessorWindowGBOnline extends TProcessorWindowGiftBase
   {
      
      protected static const Activity_OnlineGiftBag:uint = CONST_ACTIVITY_MODE.Activity_OnlineGiftBag;
      
      protected static const COUNT_Slot_Award:uint = 3;
      
      protected static const CONFIGS_ID_Vect:Vector.<uint> = CONST_ACTIVITY.CONFIGS_ID_Vect;
      
      protected static const CONFIGS_ResourceID_Vect:Vector.<uint> = CONST_ACTIVITY.CONFIGS_ResourceID_Vect;
      
      protected static const CardinalNumber_ActivityID:uint = 10000;
      
      protected var FMC_CurAward:MovieClip;
      
      protected var FMC_NextAward:MovieClip;
      
      protected var FMC_Ending:Sprite;
      
      protected var FBoxStage:int;
      
      protected var FHDGBOnline:THDGBOnline;
      
      protected var FDataOnline:TActivityGBOnline;
      
      protected var FAwardInventories:Vector.<TInventories>;
      
      protected var FCurAwardList:TUIActivityGBCurAwardList;
      
      protected var FNextAwardList:TUIActivityGBNextAwardList;
      
      protected var FOnlineCoolingDown:TTimeCoolDown;
      
      protected var FChangedOnlineStatus:Boolean;
      
      protected var FIsInit:Boolean;
      
      public function TProcessorWindowGBOnline(param1:TUIComponent)
      {
         super(param1);
         ActivityID = Activity_OnlineGiftBag;
         this.FDataOnline = new TActivityGBOnline();
         this.FOnlineCoolingDown = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_Activity_OnlineGiftBag);
         SLogicsCore.TimeCoolDowns.Add(this.FOnlineCoolingDown);
         this.FIsInit = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityGB);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(SLogicsCore.TimeCoolDowns.GetTimeByIdentifier(CONST_COMMON.TIME_COOLDOWN_Activity_OnlineGiftBag) != null)
         {
            if(this.FOnlineCoolingDown.TimingTime <= 0 && this.FChangedOnlineStatus)
            {
               this.FChangedOnlineStatus = false;
               this.CoolingDownComplete();
            }
         }
         if(this.FCurAwardList != null)
         {
            this.FCurAwardList.UpDateSlot();
         }
         if(this.FNextAwardList != null)
         {
            this.FNextAwardList.UpDateSlot();
         }
      }
      
      override protected function InitWindow() : void
      {
         FMC = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_ActivityGBOnline) as Sprite;
         addChild(FMC);
         this.FMC_CurAward = FMC[CONST_ACTIVITY.RESOURCE_Link_MC_Award];
         this.FMC_NextAward = FMC[CONST_ACTIVITY.RESOURCE_Link_MC_NextAward];
         this.FMC_Ending = FMC[CONST_ACTIVITY.RESOURCE_Link_MC_Ending];
         this.FMC_Ending.visible = false;
         this.FCurAwardList = new TUIActivityGBCurAwardList(this);
         this.FCurAwardList.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
         this.FCurAwardList.OnSlotOver = ProcessorOnSlotOver;
         this.FCurAwardList.OnSlotOut = ProcessorOnSlotOut;
         this.FCurAwardList.OnQuerySubscript = SlotsOnQuerySubscript;
         this.FCurAwardList.Perform_UIDispatch(this.FMC_CurAward,COUNT_Slot_Award,0,false);
         this.FCurAwardList.OnBtnOkClick = this.BtnOKOnClick;
         this.FNextAwardList = new TUIActivityGBNextAwardList(this);
         this.FNextAwardList.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
         this.FNextAwardList.OnSlotOver = ProcessorOnSlotOver;
         this.FNextAwardList.OnSlotOut = ProcessorOnSlotOut;
         this.FNextAwardList.OnQuerySubscript = SlotsOnQuerySubscript;
         this.FNextAwardList.Perform_UIDispatch(this.FMC_NextAward,COUNT_Slot_Award,false);
         super.InitWindow();
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
         this.FBoxStage = FBoxStatus.indexOf(Activity_CanReceive);
         if(this.FBoxStage == -1)
         {
            this.FBoxStage = FBoxStatus.indexOf(Activity_CanNotReceive);
         }
         if(this.FBoxStage == -1)
         {
            this.FBoxStage = _loc2_ - 1;
         }
         this.FCurAwardList.Clear();
         this.FCurAwardList.UpDateUI(this.FBoxStage,this.FAwardInventories[this.FBoxStage],null);
         this.FCurAwardList.UpDateBtn(FBoxStatus[this.FBoxStage]);
         this.FNextAwardList.Clear();
         if(this.FBoxStage + 1 >= this.FAwardInventories.length)
         {
            this.FNextAwardList.Visible = false;
            this.FMC_Ending.visible = true;
         }
         else
         {
            this.FNextAwardList.UpDateUI(this.FBoxStage + 1,this.FAwardInventories[this.FBoxStage + 1]);
            this.FMC_Ending.visible = false;
         }
      }
      
      override protected function UpdateDataBase(param1:ByteArray) : void
      {
         super.UpdateDataBase(param1);
         if(this.FIsInit)
         {
            if(this.FOnlineCoolingDown.TimingTime <= 0)
            {
               this.CoolingDownComplete();
            }
            return;
         }
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         FUnstreamizerActivityGB.UnstreamizeUpdateOnlineGiftBag(this.FDataOnline,FActivityInitRetData);
         FDataActivity = this.FDataOnline;
         this.FormatBoxStatus();
         this.SetCoolingDown(this.FDataOnline.Step);
         if(this.Visible)
         {
            this.UpdateUI();
         }
         CheckActivityStatusNotification();
         this.FIsInit = true;
      }
      
      protected function FormatBoxStatus() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(FHDActivityConfig == null)
         {
            this.FHDGBOnline = this.GetConfigByActivityNumber(FActivityModes.GetActivityAtomsByActivityID(ActivityID).ActivityNumber) as THDGBOnline;
         }
         _loc2_ = int(this.FHDGBOnline.ActAwardVect.length);
         FBoxStatus = new Vector.<int>(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(_loc1_ < this.FDataOnline.Step)
            {
               _loc3_ = -1;
            }
            else
            {
               _loc3_ = 0;
            }
            FBoxStatus[_loc1_] = _loc3_;
            _loc1_++;
         }
         this.FDataOnline.BoxStatus = FBoxStatus;
      }
      
      public function GetConfigByActivityNumber(param1:uint) : TDatebaseVO
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:TDatebaseVO = null;
         _loc3_ = param1 % CardinalNumber_ActivityID;
         _loc2_ = param1 - _loc3_;
         _loc4_ = CONFIGS_ID_Vect.indexOf(_loc2_);
         _loc2_ = CONFIGS_ResourceID_Vect[_loc4_];
         return SResourcesCore.ResourceBin.GetDatebase(_loc2_,param1);
      }
      
      protected function SetCoolingDown(param1:uint) : void
      {
         var _loc2_:uint = 0;
         if(param1 >= this.FHDGBOnline.AwardKeyVect.length)
         {
            SLogicsCore.TimeCoolDowns.Delete(this.FOnlineCoolingDown);
            return;
         }
         this.FBoxStage = this.FDataOnline.Step;
         _loc2_ = this.FHDGBOnline.AwardKeyVect[param1];
         this.FOnlineCoolingDown.TimingTime = _loc2_;
         this.FChangedOnlineStatus = true;
      }
      
      override protected function UpdataStatus(param1:uint, param2:int, param3:Vector.<int>) : void
      {
         super.UpdataStatus(param1,param2,param3);
         this.FDataOnline.BoxStatus[param1] = param2;
         FBoxStatus = this.FDataOnline.BoxStatus;
         CheckActivityStatusNotification();
         switch(param2)
         {
            case Activity_CanReceive:
            case Activity_CanNotReceive:
               break;
            case Activity_AlreadyReceive:
               if(!this.CheckActivityEnding())
               {
                  this.FDataOnline.Step = param1 + 1;
                  this.SetCoolingDown(this.FDataOnline.Step);
                  break;
               }
               ProcessorWindowClose();
               return;
         }
         this.UpdateUI();
      }
      
      override protected function CheckActivityEnding() : Boolean
      {
         var _loc1_:Boolean = false;
         if(FBoxStatus.indexOf(Activity_CanNotReceive) == -1 && FBoxStatus.indexOf(Activity_CanReceive) == -1)
         {
            _loc1_ = true;
            FActivityModes.DeleteByIdentifier(FActivityAtoms.Identifier);
            if(FCheckOnOff != null)
            {
               FCheckOnOff(this);
            }
         }
         return _loc1_;
      }
      
      override protected function GetConfig(param1:TActivityAtoms) : void
      {
         super.GetConfig(param1);
         this.FHDGBOnline = FHDActivityConfig as THDGBOnline;
         this.FAwardInventories = ProcessorGetInventoriesVectByAwardID(this.FHDGBOnline.AwardValueVect);
      }
      
      protected function CoolingDownComplete() : void
      {
         FBoxStatus[this.FBoxStage] = Activity_CanReceive;
         FActivityModes.GetActivityAtomsByActivityID(ActivityID).Status = Activity_CanReceive;
         CheckActivityStatusNotification();
         if(this.Visible)
         {
            this.UpdateUI();
         }
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         super.BtnOKOnClick(param1,param2);
         ActivityGetBoxReq(FActivityAtoms.Identifier,param2);
      }
      
      override public function Show(param1:TActivityAtoms) : void
      {
         super.Show(param1);
         this.UpdateUI();
      }
      
      override public function Hide() : void
      {
         super.Hide();
         if(this.FCurAwardList != null)
         {
            this.FCurAwardList.Clear();
         }
         if(this.FNextAwardList != null)
         {
            this.FNextAwardList.Clear();
         }
      }
      
      override public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         super.ChangeActivityStatus(param1,param2);
         this.UpdataStatus(param2.Index,param2.Status,param2.Condition);
      }
      
      override public function ActivityInitRet(param1:ByteArray, param2:TActivityAtoms) : void
      {
         super.ActivityInitRet(param1,param2);
         FActivityAtoms = param2;
         this.UpdateDataBase(param1);
      }
   }
}

