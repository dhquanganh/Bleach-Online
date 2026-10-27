package Processors.Game.Lobby.Activity.HDBigTurnTable
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.HDActivityBigTurnTable.TActivityBigTurnTableData;
   import Logics.HDActivityMode.TActivityAtoms;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.utils.ByteArray;
   
   public class TProcessorHDBigTurnTable extends TProcessorHDSingleWindowsBase
   {
      
      protected static const WINDOW_WIDTH:int = 586;
      
      protected static const WINDOW_HEIGHT:int = 494;
      
      protected var FWindowBigTurn:TWindowHDBigTurn;
      
      protected var FBounds:TBounds;
      
      protected var FUnstreamizerActivityBigTurnTable:TUnstreamizerActivityBigTurnTable;
      
      protected var FActivityBigTurnTableData:TActivityBigTurnTableData;
      
      protected var FInited:Boolean;
      
      protected var FOnLoadLog:Function;
      
      public function TProcessorHDBigTurnTable(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_BigTurnTable;
         this.FActivityBigTurnTableData = new TActivityBigTurnTableData();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityBigTurn);
      }
      
      override protected function InitWindows() : void
      {
         super.InitWindows();
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_WIDTH;
         this.FBounds.Height = WINDOW_HEIGHT;
         this.FWindowBigTurn = new TWindowHDBigTurn(this);
         this.FWindowBigTurn.OnBtnCloseClick = this.ProcessorsOnBtnCloseClick;
         ComponentBoundsCenter(this.FWindowBigTurn,this.FBounds);
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         this.FUnstreamizerActivityBigTurnTable = new TUnstreamizerActivityBigTurnTable();
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_BigTurnTable);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(FHDActivityConfig == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            this.FUnstreamizerActivityBigTurnTable.CoreConfigValue(null,this.FActivityBigTurnTableData,FHDActivityConfig);
            FMemoryID = FCurAtoms.Identifier;
         }
         this.FUnstreamizerActivityBigTurnTable.UnstreamizationPerform_InitData(null,this.FActivityBigTurnTableData,FActivityInitRetData);
         this.FInited = true;
         this.CheckLotteryState();
         if(!this.Visible)
         {
            return;
         }
         this.FWindowBigTurn.Show(FCurAtoms,FHDActivityConfig,this.FActivityBigTurnTableData);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         super.ProcessorSCAwardStatusChangeNotify(param1);
         this.FActivityBigTurnTableData.ActivityDataUpdate(param1.Index,param1.Status);
         this.FWindowBigTurn.Show(FCurAtoms,FHDActivityConfig,this.FActivityBigTurnTableData);
         this.FWindowBigTurn.UpdateArrive(param1.Index,param1.Condition);
      }
      
      protected function CheckLotteryState() : void
      {
         var _loc1_:int = 0;
         _loc1_ = this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryOutter.TimeCountedDown - STimingCore.ServerTick + this.FActivityBigTurnTableData.BigTurnTableLuckyLotteryOutter.PreLotteryTime;
         if(_loc1_ > 0)
         {
            FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
         }
         else
         {
            FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanReceive;
         }
         if(FEffectNotification != null)
         {
            FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_BigTurnTable);
         }
      }
      
      protected function ProcessorsOnBtnCloseClick(param1:Object) : void
      {
         ProcessorClose();
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FWindowBigTurn.OnCreateKnifeOfKillSoulData = param1;
      }
      
      public function get OnLoadLog() : Function
      {
         return this.FOnLoadLog;
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
         this.FWindowBigTurn.OnLoadLog = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FWindowBigTurn.Load();
            return;
         }
         if(this.FInited)
         {
            this.FWindowBigTurn.Show(FCurAtoms,FHDActivityConfig,this.FActivityBigTurnTableData);
         }
         else
         {
            Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         }
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FWindowBigTurn.Hide();
         this.CheckLotteryState();
      }
   }
}

