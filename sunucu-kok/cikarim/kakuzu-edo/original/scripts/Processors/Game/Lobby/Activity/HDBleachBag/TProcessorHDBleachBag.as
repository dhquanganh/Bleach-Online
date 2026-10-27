package Processors.Game.Lobby.Activity.HDBleachBag
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDBleachBag.THDBleachBagData;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.HDBleachBag.TUnstreamizerBleachBag;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.utils.ByteArray;
   
   public class TProcessorHDBleachBag extends TProcessorHDSingleWindowsBase
   {
      
      protected const WINDOW_WIDTH:int = 816;
      
      protected const WINDOW_HEIGHT:int = 539;
      
      protected var FProcessorHDWindowBleachBag:TprocessorHDWindowBleachBag;
      
      protected var FData:THDBleachBagData;
      
      protected var FInited:Boolean;
      
      protected var FUnstreamizer:TUnstreamizerBleachBag;
      
      public function TProcessorHDBleachBag(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_BleachBag;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_BleachBag);
      }
      
      override protected function InitWindows() : void
      {
         var _loc1_:TBounds = null;
         super.InitWindows();
         _loc1_ = new TBounds();
         _loc1_.Width = this.WINDOW_WIDTH;
         _loc1_.Height = this.WINDOW_HEIGHT;
         this.FData = new THDBleachBagData();
         this.FProcessorHDWindowBleachBag = new TprocessorHDWindowBleachBag(this);
         this.FProcessorHDWindowBleachBag.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorHDWindowBleachBag.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         this.FProcessorHDWindowBleachBag.OnClose = this.CloseWindowHandler;
         this.FProcessorHDWindowBleachBag.ActivityData = this.FData;
         ComponentBoundsCenter(this.FProcessorHDWindowBleachBag,_loc1_);
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         this.FUnstreamizer = new TUnstreamizerBleachBag();
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_BleachBag);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(FHDActivityConfig == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            FMemoryID = FCurAtoms.Identifier;
         }
         this.FUnstreamizer.UnstreamizeInitActivity(FActivityInitRetData,this.FData,FHDActivityConfig);
         this.FInited = true;
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorHDWindowBleachBag.Show(FCurAtoms,FHDActivityConfig,this.FData);
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
         this.FUnstreamizer.UnstreamizeUpdateActivity(param1,this.FData,FHDActivityConfig);
         this.FProcessorHDWindowBleachBag.ActivityData = this.FData;
         this.FProcessorHDWindowBleachBag.RefreshView();
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
            this.FProcessorHDWindowBleachBag.Load();
            return;
         }
         if(this.FInited)
         {
            this.FProcessorHDWindowBleachBag.Visible = true;
            this.FProcessorHDWindowBleachBag.Show(FCurAtoms,FHDActivityConfig,this.FData);
         }
         else
         {
            FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_BleachBag);
            FCurAtoms = GetAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_BleachBag);
            Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         }
      }
   }
}

