package Processors.Game.Lobby.Activity.HDNewYearDay
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.utils.ByteArray;
   
   public class TProcessorHDNewYearDay extends TProcessorHDSingleWindowsBase
   {
      
      protected static const WINDOW_WIDTH:int = 888;
      
      protected static const WINDOW_HEIGHT:int = 569;
      
      protected var FProcessorHDWindowNewYearDay:TProcessorHDWindowNewYearDay;
      
      protected var FHDActivityConfigs:Vector.<THDActivityBase>;
      
      public function TProcessorHDNewYearDay(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_NewYearDay);
      }
      
      override protected function InitWindows() : void
      {
         var _loc1_:TBounds = null;
         this.FHDActivityConfigs = new Vector.<THDActivityBase>();
         _loc1_ = new TBounds();
         _loc1_.Width = WINDOW_WIDTH;
         _loc1_.Height = WINDOW_HEIGHT;
         this.FProcessorHDWindowNewYearDay = new TProcessorHDWindowNewYearDay(this);
         this.FProcessorHDWindowNewYearDay.OnClose = this.WindowClose;
         this.FProcessorHDWindowNewYearDay.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorHDWindowNewYearDay.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         this.FProcessorHDWindowNewYearDay.Visible = true;
         ComponentBoundsCenter(this.FProcessorHDWindowNewYearDay,_loc1_);
         super.InitWindows();
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         if(!Visible)
         {
            return;
         }
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         this.FProcessorHDWindowNewYearDay.SendActivityInitData(param1,FActivityInitRetData);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         if(!Visible)
         {
            return;
         }
         super.ProcessorSCAwardStatusChangeNotify(param1);
         this.FProcessorHDWindowNewYearDay.SendActivityChangeData(param1);
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
      
      protected function InitActivityData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FHDActivityConfigs.length = 0;
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_NewYearDay);
         _loc2_ = int(FActivityAtomsVect.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            GetActivityConfigByActivityAtoms(FActivityAtomsVect[_loc1_]);
            this.FHDActivityConfigs.push(FHDActivityConfig);
            Perform_CS_ActivityInitReq(FActivityAtomsVect[_loc1_].Identifier);
            _loc1_++;
         }
         this.FProcessorHDWindowNewYearDay.InitActivityData(this.FHDActivityConfigs,FActivityAtomsVect);
      }
      
      protected function WindowClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorHDWindowNewYearDay.Load();
            return;
         }
         this.InitActivityData();
         this.FProcessorHDWindowNewYearDay.Visible = true;
      }
   }
}

