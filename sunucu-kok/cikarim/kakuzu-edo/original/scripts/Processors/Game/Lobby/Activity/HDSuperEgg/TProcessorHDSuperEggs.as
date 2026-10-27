package Processors.Game.Lobby.Activity.HDSuperEgg
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDNewYearEgg;
   import Logics.HDActivityChineseYear.TActivityChineseYearLion;
   import Logics.HDActivityChineseYear.TActivityLion;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.HDActivityChineseYear.TUnstreamizerActivityChineseYear;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.utils.ByteArray;
   
   public class TProcessorHDSuperEggs extends TProcessorHDSingleWindowsBase
   {
      
      protected static const NEWYEAR_WIDTH:uint = 916;
      
      protected static const NEWYEAR_HEIGHT:uint = 530;
      
      protected var FProcessorWindowSuperEggs:TProcessorHDWindowSuperEggs;
      
      protected var FBounds:TBounds;
      
      protected var FData_SuperEggs:TActivityChineseYearLion;
      
      protected var FHD_SuperEggs:THDNewYearEgg;
      
      protected var FUnstreamizerActivityChineseYear:TUnstreamizerActivityChineseYear;
      
      protected var FIsInitData:Boolean;
      
      public function TProcessorHDSuperEggs(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_NewYear;
         this.FData_SuperEggs = new TActivityChineseYearLion();
         this.FUnstreamizerActivityChineseYear = new TUnstreamizerActivityChineseYear();
         this.FIsInitData = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivitySuperEggs);
      }
      
      override protected function InitWindows() : void
      {
         super.InitWindows();
         this.FProcessorWindowSuperEggs = new TProcessorHDWindowSuperEggs(this);
         this.FProcessorWindowSuperEggs.OnBtnCloseClick = this.ProcessorsOnBtnCloseClick;
         this.FProcessorWindowSuperEggs.OnEffectText = EffectGenerateText;
         this.FProcessorWindowSuperEggs.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorWindowSuperEggs.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         this.FProcessorWindowSuperEggs.Hide();
         this.FBounds = new TBounds();
         this.FBounds.Width = NEWYEAR_WIDTH;
         this.FBounds.Height = NEWYEAR_HEIGHT;
         ComponentBoundsCenter(this.FProcessorWindowSuperEggs,this.FBounds);
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHD_SuperEggs = FHDActivityConfig as THDNewYearEgg;
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         if(!this.FIsInitData)
         {
            FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_SuperEggs);
            FCurAtoms = GetAtomsByActivityID(FActivityID);
            if(this.FHD_SuperEggs == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
         }
         this.FUnstreamizerActivityChineseYear.UnstreamizeUpdateChineseYearLion(FActivityInitRetData,this.FData_SuperEggs,this.FHD_SuperEggs);
         this.FIsInitData = true;
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorWindowSuperEggs.Show(FCurAtoms,this.FHD_SuperEggs,this.FData_SuperEggs);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         super.ProcessorSCAwardStatusChangeNotify(param1);
         if(this.FData_SuperEggs.Count <= 0)
         {
            return;
         }
         this.FData_SuperEggs.GetAwardByUniqueIndex(param1.Index).Status = param1.Status;
         this.UpdateEffectNotify(this);
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorWindowSuperEggs.Show(FCurAtoms,this.FHD_SuperEggs,this.FData_SuperEggs);
      }
      
      private function UpdateEffectNotify(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TActivityLion = null;
         if(this.FData_SuperEggs.Count <= 0)
         {
            return;
         }
         _loc3_ = this.FData_SuperEggs.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FData_SuperEggs.GetAwardByIndex(_loc2_);
            if(_loc4_.GetType == CONST_ACTIVITY_MODE.GETTYPE_Activity_AwardBuy)
            {
               if(_loc4_.Status >= CONST_ACTIVITY_MODE.Activity_CanReceive)
               {
                  FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanReceive;
                  break;
               }
               FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
            }
            _loc2_++;
         }
         if(FEffectNotification != null)
         {
            FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_SuperEggs);
         }
      }
      
      override protected function ProcessorOnGiftBoxMove(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:TInventories = null;
         super.ProcessorOnGiftBoxMove(param1,param2,param3);
         _loc4_ = param2 as TInventories;
         FGiftBoxTipData.TipReset();
         FGiftBoxTipData.NormalInventories = _loc4_;
         FGiftBoxTipData.AwardType = TOverlayerGiftBox.TYPE_ALL;
         FGiftBoxTipData.NeedColour = true;
         FGiftOverLayer.Context = FGiftBoxTipData;
         FGiftOverLayer.Render(FUICore.MouseCoordinate);
         FGiftOverLayer.Show();
      }
      
      protected function ProcessorsOnBtnCloseClick(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowSuperEggs.Load();
            return;
         }
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_SuperEggs);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHD_SuperEggs == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            FMemoryID = FCurAtoms.Identifier;
         }
         Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowSuperEggs.Hide();
      }
      
      public function ProcessorEffectNotify() : void
      {
         this.UpdateEffectNotify(this);
         if(FEffectNotification != null)
         {
            FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_SuperEggs);
         }
      }
   }
}

