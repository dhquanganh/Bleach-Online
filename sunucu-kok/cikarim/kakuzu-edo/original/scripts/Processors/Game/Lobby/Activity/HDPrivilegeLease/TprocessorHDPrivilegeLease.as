package Processors.Game.Lobby.Activity.HDPrivilegeLease
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDPrivilegeLease.TActivityPrivilegeLeaseData;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowsBase;
   import Processors.Game.Lobby.Activity.HDPrivilegeLease.Decoder.TUnstreamizerPrivilegeLease;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.utils.ByteArray;
   
   public class TprocessorHDPrivilegeLease extends TProcessorHDSingleWindowsBase
   {
      
      protected const WINDOW_WIDTH:int = 740;
      
      protected const WINDOW_HEIGHT:int = 580;
      
      protected var FPrivilegeleaseView:TprocessorHDWindowsPrivilegeLease;
      
      protected var FActivityPrivilegeLeaseData:TActivityPrivilegeLeaseData;
      
      protected var FInited:Boolean;
      
      protected var FUnstreamizerPrivilegeLease:TUnstreamizerPrivilegeLease;
      
      protected var FBins:TBins;
      
      public function TprocessorHDPrivilegeLease(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_PrivilegeLease;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityPrivilegeLease);
      }
      
      override protected function InitWindows() : void
      {
         var _loc1_:TBounds = null;
         super.InitWindows();
         _loc1_ = new TBounds();
         _loc1_.Width = this.WINDOW_WIDTH;
         _loc1_.Height = this.WINDOW_HEIGHT;
         this.FActivityPrivilegeLeaseData = new TActivityPrivilegeLeaseData();
         this.FPrivilegeleaseView = new TprocessorHDWindowsPrivilegeLease(this);
         this.FPrivilegeleaseView.OnClose = this.CloseWindowHandler;
         this.FPrivilegeleaseView.ActivityPrivilegeLeaseData = this.FActivityPrivilegeLeaseData;
         ComponentBoundsCenter(this.FPrivilegeleaseView,_loc1_);
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         this.FUnstreamizerPrivilegeLease = new TUnstreamizerPrivilegeLease();
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_PrivilegeLease);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         this.FBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_TimeHero);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(FHDActivityConfig == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            this.FUnstreamizerPrivilegeLease.CoreConfigValue(null,this.FActivityPrivilegeLeaseData,FHDActivityConfig,this.FBins);
            FMemoryID = FCurAtoms.Identifier;
         }
         this.FUnstreamizerPrivilegeLease.UnstreamizationPerform_InitData(null,this.FActivityPrivilegeLeaseData,FActivityInitRetData);
         this.FInited = true;
         if(!this.Visible)
         {
            return;
         }
         this.FPrivilegeleaseView.Show(FCurAtoms,FHDActivityConfig,this.FActivityPrivilegeLeaseData);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         this.FUnstreamizerPrivilegeLease.FillBoxState(param1.Index,param1.Status,this.FActivityPrivilegeLeaseData);
         if(this.FPrivilegeleaseView.visible)
         {
            this.FPrivilegeleaseView.RefreshHeroState();
         }
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
            this.FPrivilegeleaseView.Load();
            return;
         }
         if(this.FInited)
         {
            this.FPrivilegeleaseView.Visible = true;
            this.FUnstreamizerPrivilegeLease.RefreshHeroState(this.FActivityPrivilegeLeaseData);
            this.FPrivilegeleaseView.Show(FCurAtoms,FHDActivityConfig,this.FActivityPrivilegeLeaseData);
         }
         else
         {
            FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_PrivilegeLease);
            FCurAtoms = GetAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_PrivilegeLease);
            Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         }
      }
   }
}

