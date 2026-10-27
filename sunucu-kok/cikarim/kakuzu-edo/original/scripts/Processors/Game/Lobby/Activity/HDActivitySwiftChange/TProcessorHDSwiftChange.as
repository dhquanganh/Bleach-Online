package Processors.Game.Lobby.Activity.HDActivitySwiftChange
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDSwiftChange.TActivitySwiftChangData;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowsBase;
   import Processors.Game.Lobby.Activity.HDActivitySwiftChange.Decoder.TUnstreamizerSwiftChange;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.utils.ByteArray;
   
   public class TProcessorHDSwiftChange extends TProcessorHDSingleWindowsBase
   {
      
      protected const WINDOW_WIDTH:int = 700;
      
      protected const WINDOW_HEIGHT:int = 505;
      
      protected var FProcessorHDWindowSwiftChange:TprocessorHDWindowSwiftChange;
      
      protected var FActivitySwiftChangeData:TActivitySwiftChangData;
      
      protected var FInited:Boolean;
      
      protected var FUnstreamizerSwiftChange:TUnstreamizerSwiftChange;
      
      public function TProcessorHDSwiftChange(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_SwiftChange;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivitySwiftChange);
      }
      
      override protected function InitWindows() : void
      {
         var _loc1_:TBounds = null;
         super.InitWindows();
         _loc1_ = new TBounds();
         _loc1_.Width = this.WINDOW_WIDTH;
         _loc1_.Height = this.WINDOW_HEIGHT;
         this.FActivitySwiftChangeData = new TActivitySwiftChangData();
         this.FProcessorHDWindowSwiftChange = new TprocessorHDWindowSwiftChange(this);
         this.FProcessorHDWindowSwiftChange.OnClose = this.CloseWindowHandler;
         this.FProcessorHDWindowSwiftChange.ActivitySwiftChangeData = this.FActivitySwiftChangeData;
         ComponentBoundsCenter(this.FProcessorHDWindowSwiftChange,_loc1_);
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         this.FUnstreamizerSwiftChange = new TUnstreamizerSwiftChange();
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_SwiftChange);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(FHDActivityConfig == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            this.FUnstreamizerSwiftChange.CoreConfigValue(null,this.FActivitySwiftChangeData,FHDActivityConfig);
            FMemoryID = FCurAtoms.Identifier;
         }
         this.FUnstreamizerSwiftChange.UnstreamizationPerform_InitData(null,this.FActivitySwiftChangeData,FActivityInitRetData);
         this.FInited = true;
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorHDWindowSwiftChange.Show(FCurAtoms,FHDActivityConfig,this.FActivitySwiftChangeData);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         this.FUnstreamizerSwiftChange.FillBoxState(param1.Index,param1.Status,this.FActivitySwiftChangeData);
         this.FProcessorHDWindowSwiftChange.UpdateDebrisMarketView();
      }
      
      protected function CloseWindowHandler(param1:Object) : void
      {
         ProcessorClose();
         this.FInited = true;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorHDWindowSwiftChange.Load();
            return;
         }
         if(this.FInited)
         {
            this.FProcessorHDWindowSwiftChange.Visible = true;
            this.FProcessorHDWindowSwiftChange.Show(FCurAtoms,FHDActivityConfig,this.FActivitySwiftChangeData);
         }
         else
         {
            FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_SwiftChange);
            FCurAtoms = GetAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_SwiftChange);
            Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         }
      }
   }
}

