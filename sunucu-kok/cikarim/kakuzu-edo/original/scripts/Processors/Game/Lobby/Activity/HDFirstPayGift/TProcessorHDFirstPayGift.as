package Processors.Game.Lobby.Activity.HDFirstPayGift
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDFirstPayGift.TActivityFirstPayGiftData;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.HDFirstPayGift.TUnstreamizerFirstPayGift;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.utils.ByteArray;
   
   public class TProcessorHDFirstPayGift extends TProcessorHDSingleWindowsBase
   {
      
      protected const WINDOW_WIDTH:int = 713;
      
      protected const WINDOW_HEIGHT:int = 484;
      
      protected var FWindowFirstPayBag:TProcessorHDWindowFirstPayGift;
      
      protected var FData:TActivityFirstPayGiftData;
      
      protected var FInited:Boolean;
      
      protected var FUnstreamizer:TUnstreamizerFirstPayGift;
      
      private var FOnHideHDIcon:Function;
      
      public function TProcessorHDFirstPayGift(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_FirstPayBag;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_FirstPayBag);
      }
      
      override protected function InitWindows() : void
      {
         var _loc1_:TBounds = null;
         super.InitWindows();
         _loc1_ = new TBounds();
         _loc1_.Width = this.WINDOW_WIDTH;
         _loc1_.Height = this.WINDOW_HEIGHT;
         this.FData = new TActivityFirstPayGiftData();
         this.FWindowFirstPayBag = new TProcessorHDWindowFirstPayGift(this);
         this.FWindowFirstPayBag.OnClose = this.CloseWindowHandler;
         this.FWindowFirstPayBag.ActivityData = this.FData;
         this.FWindowFirstPayBag.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FWindowFirstPayBag.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         ComponentBoundsCenter(this.FWindowFirstPayBag,_loc1_);
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         this.FUnstreamizer = new TUnstreamizerFirstPayGift();
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_FirstPayBag);
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
         this.FWindowFirstPayBag.Show(FCurAtoms,FHDActivityConfig,this.FData);
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
         this.FWindowFirstPayBag.ActivityData = this.FData;
         this.FWindowFirstPayBag.RefreshBaseInfo();
         this.ShutDownFunction(this.FData.IsFinishAllTask);
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
            this.FWindowFirstPayBag.Load();
            return;
         }
         if(this.FInited)
         {
            this.FWindowFirstPayBag.Visible = true;
            this.FWindowFirstPayBag.Show(FCurAtoms,FHDActivityConfig,this.FData);
         }
         else
         {
            FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_FirstPayBag);
            FCurAtoms = GetAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_FirstPayBag);
            Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         }
      }
   }
}

