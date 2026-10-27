package Processors.Game.Lobby.Activity.HDTimeLimitTurntable
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDTimeLimitTurntableConfig;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDTimeLimitTurntable.TActivityGoldTurntableData;
   import Logics.Streamization.HDTimeLimitTurntable.TUnstreamizerGoldTurntable;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.utils.ByteArray;
   
   public class TProcessorHDTimeLimitTurntable extends TProcessorHDSingleWindowsBase
   {
      
      protected const WINDOW_WIDTH:int = 720;
      
      protected const WINDOW_HEIGHT:int = 505;
      
      protected var FProcessorHDWindowTurntable:TprocessorHDWindowTimeLimitView;
      
      protected var FData:TActivityGoldTurntableData;
      
      protected var FInited:Boolean;
      
      protected var FUnstreamizerTurntable:TUnstreamizerGoldTurntable;
      
      protected var FOnLoadLog:Function;
      
      public function TProcessorHDTimeLimitTurntable(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_TimeLimitTurntable;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_GoldTurntable);
      }
      
      override protected function InitWindows() : void
      {
         var _loc1_:TBounds = null;
         super.InitWindows();
         _loc1_ = new TBounds();
         _loc1_.Width = this.WINDOW_WIDTH;
         _loc1_.Height = this.WINDOW_HEIGHT;
         this.FData = new TActivityGoldTurntableData();
         this.FProcessorHDWindowTurntable = new TprocessorHDWindowTimeLimitView(this);
         this.FProcessorHDWindowTurntable.OnClose = this.CloseWindowHandler;
         this.FProcessorHDWindowTurntable.ActivityData = this.FData;
         ComponentBoundsCenter(this.FProcessorHDWindowTurntable,_loc1_);
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         this.FUnstreamizerTurntable = new TUnstreamizerGoldTurntable();
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_GoldTurntable);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(FHDActivityConfig == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            this.FUnstreamizerTurntable.CoreConfigValue(null,this.FData,FHDActivityConfig);
            FMemoryID = FCurAtoms.Identifier;
         }
         this.FUnstreamizerTurntable.UnstreamizationPerform_InitData(FHDActivityConfig,this.FData,FActivityInitRetData);
         this.FInited = true;
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorHDWindowTurntable.Show(FCurAtoms,FHDActivityConfig,this.FData);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         if(this.FUnstreamizerTurntable == null)
         {
            return;
         }
         this.FUnstreamizerTurntable.FillBoxState(param1,this.FData,FHDActivityConfig);
         if(param1.Index == (FHDActivityConfig as THDTimeLimitTurntableConfig).LowExtractIndex || param1.Index == (FHDActivityConfig as THDTimeLimitTurntableConfig).HighExtractIndex)
         {
            this.FProcessorHDWindowTurntable.GetTurntableAwardPos(param1.Status);
         }
         this.FProcessorHDWindowTurntable.ActivityData = this.FData;
         this.FProcessorHDWindowTurntable.RefreshBaseInfo();
      }
      
      protected function CloseWindowHandler(param1:Object) : void
      {
         ProcessorClose();
         this.FInited = true;
      }
      
      public function get OnLoadLog() : Function
      {
         return this.FOnLoadLog;
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FOnLoadLog = param1;
         this.FProcessorHDWindowTurntable.OnLoadLog = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorHDWindowTurntable.Load();
            return;
         }
         if(this.FInited)
         {
            this.FProcessorHDWindowTurntable.Visible = true;
            this.FProcessorHDWindowTurntable.Show(FCurAtoms,FHDActivityConfig,this.FData);
         }
         else
         {
            FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_GoldTurntable);
            FCurAtoms = GetAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_TimeLimitTurntable);
            Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         }
      }
   }
}

