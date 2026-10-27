package Processors.Game.Lobby.Activity.HDActivityGiftBag.windows
{
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityGB.*;
   import Logics.HDActivityMode.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivityGiftBag.*;
   import Processors.Game.Lobby.Activity.HDActivityGiftBag.Component.TUIActivityGBCurAwardList;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.utils.*;
   
   public class TProcessorWindowGBOpenServer extends TProcessorWindowGiftBase
   {
      
      protected static const Activity_OpenServerGiftBag:uint = CONST_ACTIVITY_MODE.Activity_OpenServerGiftBag;
      
      protected static const COUNT_Slot_Award:uint = 5;
      
      protected static const COUNT_Prompt_Award:uint = 0;
      
      protected var FMC_Award:Sprite;
      
      protected var FBoxStage:int;
      
      protected var FHDGBOpenServer:THDGBOpenServer;
      
      protected var FDataGBOpenServer:TActivityGBOpenServer;
      
      protected var FAwardInventories:Vector.<TInventories>;
      
      protected var FAwardList:TUIActivityGBCurAwardList;
      
      public function TProcessorWindowGBOpenServer(param1:TUIComponent)
      {
         super(param1);
         ActivityID = Activity_OpenServerGiftBag;
         this.FDataGBOpenServer = new TActivityGBOpenServer();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FAwardList != null && this.Visible)
         {
            this.FAwardList.UpDateSlot();
         }
      }
      
      override protected function InitWindow() : void
      {
         FMC = TUtilityReflection.CreateDisplayObjectInstance(CONST_ACTIVITY.RESOURCE_ClassName_ActivityGBOpenServer) as Sprite;
         addChild(FMC);
         this.FMC_Award = FMC[CONST_ACTIVITY.RESOURCE_Link_MC_Award];
         this.FAwardList = new TUIActivityGBCurAwardList(this);
         this.FAwardList.OnQuerySequenceContext = SlotsOnQuerySequenceContext;
         this.FAwardList.OnSlotOver = ProcessorOnSlotOver;
         this.FAwardList.OnSlotOut = ProcessorOnSlotOut;
         this.FAwardList.OnQuerySubscript = SlotsOnQuerySubscript;
         this.FAwardList.Perform_UIDispatch(this.FMC_Award,COUNT_Slot_Award,COUNT_Prompt_Award,false);
         this.FAwardList.OnBtnOkClick = this.BtnOKOnClick;
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
         this.FAwardList.Clear();
         this.FAwardList.UpDateUI(this.FBoxStage,this.FAwardInventories[this.FBoxStage],null);
         this.FAwardList.UpDateBtn(FBoxStatus[this.FBoxStage]);
      }
      
      override protected function UpdateDataBase(param1:ByteArray) : void
      {
         super.UpdateDataBase(param1);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param1,null);
         FUnstreamizerActivityGB.UnstreamizeUpdateOpenServerGiftBag(this.FDataGBOpenServer,FActivityInitRetData);
         FDataActivity = this.FDataGBOpenServer;
         FBoxStatus = this.FDataGBOpenServer.BoxStatus;
         CheckActivityStatusNotification();
         FIsInitWindow = true;
         if(this.Visible)
         {
            this.UpdateUI();
         }
      }
      
      override protected function UpdataStatus(param1:uint, param2:int, param3:Vector.<int>) : void
      {
         super.UpdataStatus(param1,param2,param3);
         this.FDataGBOpenServer.BoxStatus[param1] = param2;
         CheckActivityStatusNotification();
         if(this.CheckActivityEnding())
         {
            ProcessorWindowClose();
            return;
         }
         this.UpdateUI();
      }
      
      override protected function CheckActivityEnding() : Boolean
      {
         var _loc1_:Boolean = false;
         if(FBoxStatus.indexOf(Activity_CanReceive) == -1)
         {
            _loc1_ = true;
            FIsInitWindow = false;
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
         this.FHDGBOpenServer = FHDActivityConfig as THDGBOpenServer;
         this.FAwardInventories = ProcessorGetInventoriesVectByAwardID(this.FHDGBOpenServer.AwardValueVect);
      }
      
      override protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
         super.BtnOKOnClick(param1,param2);
         ActivityGetBoxReq(FActivityAtoms.Identifier,param2);
      }
      
      override public function Show(param1:TActivityAtoms) : void
      {
         super.Show(param1);
         if(FIsInitWindow)
         {
            this.UpdateUI();
         }
         else
         {
            ActivityInitReq(FActivityAtoms.Identifier);
         }
      }
      
      override public function Hide() : void
      {
         super.Hide();
         if(this.FAwardList != null)
         {
            this.FAwardList.Clear();
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

