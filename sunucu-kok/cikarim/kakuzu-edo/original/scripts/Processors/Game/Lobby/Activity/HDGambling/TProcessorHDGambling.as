package Processors.Game.Lobby.Activity.HDGambling
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.THDGambling;
   import Logics.HDActivityGambling.TActivityGambling;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.HDActivitySingle.TUnstreamizerActivitySingle;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowsBase;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.utils.ByteArray;
   
   public class TProcessorHDGambling extends TProcessorHDSingleWindowsBase
   {
      
      protected static const WINDOW_WIDTH_Gambling:uint = 1013;
      
      protected static const WINDOW_HEIGHT_Gambling:uint = 442;
      
      protected static const COUNT_AWARD:uint = 10;
      
      protected var FDataGambling:TActivityGambling;
      
      protected var FHDGambling:THDGambling;
      
      protected var FUnstreamizerActivitySingle:TUnstreamizerActivitySingle;
      
      protected var FProcessorWindowGambling:TProcessorWindowGambling;
      
      protected var FBounds:TBounds;
      
      public function TProcessorHDGambling(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_Gambling;
         this.FDataGambling = new TActivityGambling();
         this.FUnstreamizerActivitySingle = new TUnstreamizerActivitySingle();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityGambling);
      }
      
      override protected function InitWindows() : void
      {
         super.InitWindows();
         this.FProcessorWindowGambling = new TProcessorWindowGambling(this);
         this.FProcessorWindowGambling.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorWindowGambling.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         this.FProcessorWindowGambling.OnBtnCloseClick = this.BtnOnCloseClick;
         this.FProcessorWindowGambling.UpdateStatus = this.UpdateEffectNotify;
         this.FProcessorWindowGambling.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowGambling.Hide();
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_WIDTH_Gambling;
         this.FBounds.Height = WINDOW_HEIGHT_Gambling;
         ComponentBoundsCenter(this.FProcessorWindowGambling,this.FBounds);
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHDGambling = FHDActivityConfig as THDGambling;
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         this.FUnstreamizerActivitySingle.UnstreamizeUpdateGambling(FActivityInitRetData,this.FDataGambling,this.FHDGambling);
         this.FProcessorWindowGambling.Show(FCurAtoms,this.FHDGambling,this.FDataGambling);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         _loc2_ = uint(param1.Index);
         _loc3_ = param1.Status;
         this.FDataGambling.SetDataByUniqueIndex(_loc2_,_loc3_);
         if(!this.Visible)
         {
            return;
         }
         if(this.FProcessorWindowGambling.Visible)
         {
            this.FProcessorWindowGambling.Show(FCurAtoms,null,this.FDataGambling);
         }
      }
      
      protected function UpdateEffectNotify(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.FDataGambling == null || this.FDataGambling.GetAwardDataByIndex(0) == null)
         {
            return;
         }
         _loc3_ = int(COUNT_AWARD);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FDataGambling.GetAwardDataByIndex(_loc2_).Status >= CONST_ACTIVITY_MODE.Activity_CanReceive)
            {
               FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanReceive;
               break;
            }
            FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
            _loc2_++;
         }
         if(this.FDataGambling.DataStartCount.Count > 0)
         {
            FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanReceive;
         }
         if(FEffectNotification != null)
         {
            FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_Gambling);
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
      
      protected function BtnOnCloseClick(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowGambling.Load();
            return;
         }
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_Gambling);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHDGambling == null)
            {
               GetActivityConfigByActivityAtoms(FCurAtoms);
            }
            FMemoryID = FCurAtoms.Identifier;
         }
         Perform_CS_ActivityInitReq(FCurAtoms.Identifier);
         this.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         if(this.FProcessorWindowGambling != null)
         {
            this.FProcessorWindowGambling.Hide();
         }
      }
      
      override public function ValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         super.ValuesChange(param1,param2);
         this.FDataGambling.SetDataByParameterVec(param2);
         this.FProcessorWindowGambling.ValuesChange(this.FDataGambling);
      }
      
      public function ProcessorEffectNotify() : void
      {
         this.UpdateEffectNotify(this);
      }
   }
}

