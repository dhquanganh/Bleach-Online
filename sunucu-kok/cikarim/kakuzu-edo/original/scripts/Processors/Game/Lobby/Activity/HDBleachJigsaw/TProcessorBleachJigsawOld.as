package Processors.Game.Lobby.Activity.HDBleachJigsaw
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDBleachJigsaw.*;
   import Logics.Inventories.*;
   import Logics.Streamization.HDActivityBleachJigsaw.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Rendering.Overlayers.HDGiftBox.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorBleachJigsawOld extends TProcessorHDSingleWindowsBase
   {
      
      public static const SIZE_Width:uint = 706;
      
      public static const SIZE_Height:uint = 501;
      
      protected var FProcessorWindowBleachJigsawOld:TProcessorWindowBleachJigsawOld;
      
      protected var FHDBleachJigsawConfig:THDBleachJigSaw;
      
      protected var FData_BleachJigsaw:TActivityBleachJigsaw;
      
      protected var FHD_BleachJigsaw:THDBleachJigSaw;
      
      protected var FUnstreamizerActivityBleachJigsaw:TunstreamizerActivityBleachJigsaw;
      
      public function TProcessorBleachJigsawOld(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,FParameters);
         FActivityID = CONST_ACTIVITY_MODE.Activity_BleachJigsaw;
         this.FData_BleachJigsaw = new TActivityBleachJigsaw();
         this.FUnstreamizerActivityBleachJigsaw = new TunstreamizerActivityBleachJigsaw();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityBleachJigsaw);
      }
      
      override protected function InitWindows() : void
      {
         var _loc1_:TBounds = null;
         super.InitWindows();
         this.FProcessorWindowBleachJigsawOld = new TProcessorWindowBleachJigsawOld(this);
         this.FProcessorWindowBleachJigsawOld.Visible = false;
         this.FProcessorWindowBleachJigsawOld.OnBtnCloseClick = ProcessorClose;
         this.FProcessorWindowBleachJigsawOld.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowBleachJigsawOld.OnHintOver = UIComponentsOnOver;
         this.FProcessorWindowBleachJigsawOld.OnHintOut = UIComponentsOnOut;
         this.FProcessorWindowBleachJigsawOld.OnSlotOver = UIComponentsHintOnOver;
         this.FProcessorWindowBleachJigsawOld.OnSlotOut = UIComponentsHintOnOut;
         this.FProcessorWindowBleachJigsawOld.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FProcessorWindowBleachJigsawOld.OnGiftBoxOut = ProcessorOnGiftBoxOut;
         _loc1_ = new TBounds();
         _loc1_.Width = SIZE_Width;
         _loc1_.Height = SIZE_Height;
         ComponentBoundsCenter(this.FProcessorWindowBleachJigsawOld,_loc1_);
         _loc1_ = null;
      }
      
      override protected function UpdateUIConfig() : void
      {
         super.UpdateUIConfig();
         this.FHD_BleachJigsaw = FHDActivityConfig as THDBleachJigSaw;
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         super.ProcessorSCInitWindow(param1,param2);
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         this.FUnstreamizerActivityBleachJigsaw.UnstreamizeUpdateBleachJigsaw(FActivityInitRetData,this.FData_BleachJigsaw,this.FHD_BleachJigsaw);
         if(!this.Visible)
         {
            return;
         }
         this.FProcessorWindowBleachJigsawOld.Show(FCurAtoms,this.FHD_BleachJigsaw,this.FData_BleachJigsaw);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:int = 0;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         _loc2_ = -1;
         if(param1.Index >= 0 && param1.Index < 25)
         {
            this.FData_BleachJigsaw.JigSawItemsVec[param1.Index].Num = param1.Status;
            _loc2_ = param1.Index;
         }
         if(param1.Condition != null && param1.Condition.length > 0 && param1.Index >= 0 && param1.Index < 25)
         {
            this.FData_BleachJigsaw.JigSawItemsVec[param1.Index].IsHad = param1.Condition[0];
         }
         if(param1.Index == 25)
         {
            this.FData_BleachJigsaw.JigSawFinalStatus = param1.Status;
         }
         if(!this.Visible)
         {
            return;
         }
         if(this.FProcessorWindowBleachJigsawOld.Visible)
         {
            if(_loc2_ >= 0)
            {
               this.FProcessorWindowBleachJigsawOld.SetCurPos(_loc2_);
            }
            this.FProcessorWindowBleachJigsawOld.Show(FCurAtoms,this.FHD_BleachJigsaw,this.FData_BleachJigsaw);
         }
      }
      
      override public function ValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         super.ValuesChange(param1,param2);
         this.FData_BleachJigsaw.JigSawCoolDown = param2[0];
         this.FProcessorWindowBleachJigsawOld.Show(FCurAtoms,this.FHD_BleachJigsaw,this.FData_BleachJigsaw);
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
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowBleachJigsawOld.Load();
            return;
         }
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_BleachJigsaw);
         FCurAtoms = GetAtomsByActivityID(FActivityID);
         if(FMemoryID != FCurAtoms.Identifier)
         {
            if(this.FHD_BleachJigsaw == null)
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
         this.FProcessorWindowBleachJigsawOld.Hide();
      }
   }
}

