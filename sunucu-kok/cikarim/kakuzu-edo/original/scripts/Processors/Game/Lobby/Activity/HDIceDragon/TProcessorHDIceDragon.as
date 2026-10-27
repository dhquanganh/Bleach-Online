package Processors.Game.Lobby.Activity.HDIceDragon
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityChineseYear.ActivityLukia.*;
   import Logics.HDActivityMode.*;
   import Logics.Inventories.*;
   import Logics.Streamization.HDActivityChineseYear.*;
   import Logics.Streamization.HDActivitySingle.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Rendering.Overlayers.HDGiftBox.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDIceDragon extends TProcessorHDSingleWindowsBase
   {
      
      protected static const SIZE_WIDTH_WindowIceDragon:uint = 858;
      
      protected static const SIZE_HEIGHT_WindowIceDragon:uint = 473;
      
      protected var FProcessorWindowIceDragon:TProcessorHDWindowIceDragon;
      
      protected var FBounds:TBounds;
      
      protected var FDataIceDragon:TActivityLukiaTotalInfor;
      
      protected var FHDIceDragon:THDChineseYearLukia;
      
      protected var FUnstreamizerActivitySingle:TUnstreamizerActivitySingle;
      
      protected var FUnstreamizerActivityChineseYear:TUnstreamizerActivityChineseYear;
      
      public function TProcessorHDIceDragon(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         FActivityID = CONST_ACTIVITY_MODE.Activity_ChineseYearLukia;
         this.FDataIceDragon = new TActivityLukiaTotalInfor();
         this.FUnstreamizerActivitySingle = new TUnstreamizerActivitySingle();
         this.FUnstreamizerActivityChineseYear = new TUnstreamizerActivityChineseYear();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityIceDragon);
      }
      
      override protected function InitWindows() : void
      {
         super.InitWindows();
         this.FProcessorWindowIceDragon = new TProcessorHDWindowIceDragon(this);
         this.FProcessorWindowIceDragon.OnBtnCloseClick = this.ProcessorWindowOnClose;
         this.FProcessorWindowIceDragon.OnEffectText = EffectGenerateText;
         this.FProcessorWindowIceDragon.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorWindowIceDragon.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         this.FProcessorWindowIceDragon.Hide();
         this.FBounds = new TBounds();
         this.FBounds.Width = SIZE_WIDTH_WindowIceDragon;
         this.FBounds.Height = SIZE_HEIGHT_WindowIceDragon;
         ComponentBoundsCenter(this.FProcessorWindowIceDragon,this.FBounds);
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHDIceDragon = FHDActivityConfig as THDChineseYearLukia;
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         if(this.FDataIceDragon.ActivitySuperBag == null || this.FDataIceDragon.ActivitySuperBag.Count <= 0)
         {
            this.ProcessorInitData();
         }
         this.UpdateEffectNotify(this);
         this.FUnstreamizerActivityChineseYear.UnstreamizeUpdateChineseYearLukia(FActivityInitRetData,this.FDataIceDragon,this.FHDIceDragon);
         if(Visible)
         {
            this.FProcessorWindowIceDragon.Show(FCurAtoms,this.FHDIceDragon,this.FDataIceDragon);
         }
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         super.ProcessorSCAwardStatusChangeNotify(param1);
         if(this.FDataIceDragon.ActivitySuperBag == null || this.FDataIceDragon.ActivitySuperBag.Count <= 0)
         {
            this.ProcessorInitData();
         }
         this.FDataIceDragon.FlushActivityData(param1.Index,param1.Status);
         this.UpdateEffectNotify(this);
         if(Visible)
         {
            this.FProcessorWindowIceDragon.Show(FCurAtoms,this.FHDIceDragon,this.FDataIceDragon);
         }
      }
      
      protected function ProcessorInitData() : void
      {
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_IceDragon);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         GetActivityConfigByActivityAtoms(FCurAtoms);
      }
      
      protected function UpdateEffectNotify(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.FDataIceDragon.ActivitySuperBag == null || this.FDataIceDragon.ActivitySuperBag.Count <= 0)
         {
            return;
         }
         if(this.FDataIceDragon.ActivityLukia.Status >= CONST_ACTIVITY_MODE.Activity_CanReceive)
         {
            FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanReceive;
         }
         else
         {
            FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
         }
         _loc3_ = this.FDataIceDragon.ActivityExchangeBag.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FDataIceDragon.ActivityLukiaChip.ChipNum >= this.FDataIceDragon.ActivityExchangeBag.ChipNeed[_loc2_])
            {
               FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanReceive;
               break;
            }
            FCurAtoms.Status = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
            _loc2_++;
         }
         if(FEffectNotification != null)
         {
            FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_IceDragon);
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
      
      protected function ProcessorWindowOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowIceDragon.Load();
            return;
         }
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_IceDragon);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHDIceDragon == null)
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
         if(this.FProcessorWindowIceDragon != null)
         {
            this.FProcessorWindowIceDragon.Hide();
         }
      }
      
      public function ProcessorEffectNotify() : void
      {
         this.UpdateEffectNotify(this);
         if(FEffectNotification != null)
         {
            FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_IceDragon);
         }
      }
   }
}

