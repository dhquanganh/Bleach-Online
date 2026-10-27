package Processors.Game.Lobby.Activity.HDDreamComeTrue
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDDreamsComeTrue;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDDreamsComeTrue.TActivityDreamsData;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.HDDreamsComeTrue.TUnstreamizerDreams;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.utils.ByteArray;
   
   public class TProcessorHDDreamComeTrue extends TProcessorHDSingleWindowsBase
   {
      
      protected const WINDOW_WIDTH:int = 784;
      
      protected const WINDOW_HEIGHT:int = 592;
      
      protected var FProcessorHDWindowDreams:TprocessorHDWindowDreams;
      
      protected var FActivityDreamsData:TActivityDreamsData;
      
      protected var FInited:Boolean;
      
      protected var FUnstreamizerDreams:TUnstreamizerDreams;
      
      public function TProcessorHDDreamComeTrue(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_DreamsComeTrue;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_DreamsComeTrue);
      }
      
      override protected function InitWindows() : void
      {
         var _loc1_:TBounds = null;
         super.InitWindows();
         _loc1_ = new TBounds();
         _loc1_.Width = this.WINDOW_WIDTH;
         _loc1_.Height = this.WINDOW_HEIGHT;
         this.FActivityDreamsData = new TActivityDreamsData();
         this.FProcessorHDWindowDreams = new TprocessorHDWindowDreams(this);
         this.FProcessorHDWindowDreams.OnClose = this.CloseWindowHandler;
         this.FProcessorHDWindowDreams.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorHDWindowDreams.OnGiftBoxOut = this.ProcessorOnGiftBoxOut;
         this.FProcessorHDWindowDreams.ActivityDreamsData = this.FActivityDreamsData;
         ComponentBoundsCenter(this.FProcessorHDWindowDreams,_loc1_);
      }
      
      override protected function ProcessorOnGiftBoxOut(param1:Object) : void
      {
         FGiftOverLayer.Hide();
      }
      
      override protected function ProcessorOnGiftBoxMove(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:TInventories = null;
         var _loc5_:int = 0;
         super.ProcessorOnGiftBoxMove(param1,param2,param3);
         if(param3 != null)
         {
            _loc5_ = param3 as int;
         }
         _loc4_ = param2 as TInventories;
         FGiftBoxTipData.TipReset();
         FGiftBoxTipData.NormalInventories = _loc4_;
         FGiftBoxTipData.AwardType = _loc5_;
         FGiftBoxTipData.NeedColour = true;
         FGiftOverLayer.Context = FGiftBoxTipData;
         FGiftOverLayer.Render(FUICore.MouseCoordinate);
         FGiftOverLayer.Show();
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         this.FUnstreamizerDreams = new TUnstreamizerDreams();
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_Dreams);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(FHDActivityConfig == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            this.FUnstreamizerDreams.CoreConfigValue(null,this.FActivityDreamsData,FHDActivityConfig);
            FMemoryID = FCurAtoms.Identifier;
         }
         this.FUnstreamizerDreams.UnstreamizationPerform_InitData(null,this.FActivityDreamsData,FActivityInitRetData);
         if(FActivityInitRetData.AllBox.length > 0)
         {
            this.FInited = true;
         }
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorHDWindowDreams.Show(FCurAtoms,FHDActivityConfig,this.FActivityDreamsData);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         this.FUnstreamizerDreams.FillBoxState(param1,this.FActivityDreamsData,FHDActivityConfig);
         if(param1.Index == (FHDActivityConfig as THDDreamsComeTrue).LowExtractIndex || param1.Index == (FHDActivityConfig as THDDreamsComeTrue).HighExtractIndex)
         {
            this.FProcessorHDWindowDreams.GetTurntableAwardPos(param1.Status);
         }
         this.FProcessorHDWindowDreams.UpdateView();
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
            this.FProcessorHDWindowDreams.Load();
            return;
         }
         if(this.FInited)
         {
            this.FProcessorHDWindowDreams.Visible = true;
            this.FProcessorHDWindowDreams.Show(FCurAtoms,FHDActivityConfig,this.FActivityDreamsData);
         }
         else
         {
            FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_Dreams);
            FCurAtoms = GetAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_DreamsComeTrue);
            Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         }
      }
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FProcessorHDWindowDreams.OnCreateKnifeOfKillSoulData = param1;
      }
   }
}

