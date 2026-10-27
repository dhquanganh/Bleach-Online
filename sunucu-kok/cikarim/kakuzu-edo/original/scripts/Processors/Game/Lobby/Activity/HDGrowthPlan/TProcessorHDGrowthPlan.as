package Processors.Game.Lobby.Activity.HDGrowthPlan
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDGrowthPlan.TActivityGrowthPlanData;
   import Logics.Streamization.HDGrowthPlan.TUnstreamizerGrowthPlan;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.utils.ByteArray;
   
   public class TProcessorHDGrowthPlan extends TProcessorHDSingleWindowsBase
   {
      
      protected const WINDOW_WIDTH:int = 720;
      
      protected const WINDOW_HEIGHT:int = 505;
      
      protected var FWindowGrowthPlan:TProcessorHDWindowGrowthPlan;
      
      protected var FData:TActivityGrowthPlanData;
      
      protected var FInited:Boolean;
      
      protected var FUnstreamizer:TUnstreamizerGrowthPlan;
      
      private var FOnHideHDIcon:Function;
      
      public function TProcessorHDGrowthPlan(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_GrowthPlan;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_GrowthPlan);
      }
      
      override protected function InitWindows() : void
      {
         var _loc1_:TBounds = null;
         super.InitWindows();
         _loc1_ = new TBounds();
         _loc1_.Width = this.WINDOW_WIDTH;
         _loc1_.Height = this.WINDOW_HEIGHT;
         this.FData = new TActivityGrowthPlanData();
         this.FWindowGrowthPlan = new TProcessorHDWindowGrowthPlan(this);
         this.FWindowGrowthPlan.OnClose = this.CloseWindowHandler;
         this.FWindowGrowthPlan.ActivityData = this.FData;
         ComponentBoundsCenter(this.FWindowGrowthPlan,_loc1_);
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         this.FUnstreamizer = new TUnstreamizerGrowthPlan();
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_GrowthPlan);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(FHDActivityConfig == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            this.FUnstreamizer.CoreConfigValue(null,this.FData,FHDActivityConfig);
            FMemoryID = FCurAtoms.Identifier;
         }
         this.FUnstreamizer.UnstreamizationPerform_InitData(null,this.FData,FActivityInitRetData);
         this.FInited = true;
         if(!this.Visible)
         {
            return;
         }
         this.FWindowGrowthPlan.Show(FCurAtoms,FHDActivityConfig,this.FData);
         this.ShutDownFunction(this.FData.IsFinishAllTask);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         if(this.FUnstreamizer == null)
         {
            return;
         }
         this.FUnstreamizer.FillBoxState(param1,this.FData,FHDActivityConfig);
         this.FWindowGrowthPlan.ActivityData = this.FData;
         this.FWindowGrowthPlan.RefreshBaseInfo();
         this.ShutDownFunction(this.FData.IsFinishAllTask);
      }
      
      protected function CloseWindowHandler(param1:Object) : void
      {
         ProcessorClose();
         this.FInited = true;
      }
      
      protected function ShutDownFunction(param1:Boolean) : void
      {
         if(param1)
         {
            FActivityModes.DeleteByIdentifier(FCurAtoms.Identifier);
            this.FOnHideHDIcon(this);
         }
      }
      
      public function set OnHideHDIcon(param1:Function) : void
      {
         this.FOnHideHDIcon = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FWindowGrowthPlan.Load();
            return;
         }
         if(this.FInited)
         {
            this.FWindowGrowthPlan.Visible = true;
            this.FUnstreamizer.JudgeGetAwradState(this.FData);
            this.FWindowGrowthPlan.Show(FCurAtoms,FHDActivityConfig,this.FData);
         }
         else
         {
            FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_GrowthPlan);
            FCurAtoms = GetAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_GrowthPlan);
            Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         }
      }
   }
}

