package Processors.Game.Lobby.Activity.HDBleachJigsaw
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HDActivityMode.*;
   import Logics.Streamization.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Rendering.Overlayers.HDGiftBox.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import flash.utils.*;
   
   public class TProcessorBleachJigsaw extends TProcessorLobbyWindows
   {
      
      public static const SIZE_Width:uint = 706;
      
      public static const SIZE_Height:uint = 501;
      
      protected var FProcessorWindowBleachJigsaw:TProcessorWindowBleachJigsaw;
      
      protected var FHDBleachJigsawConfig:THDBleachJigSaw;
      
      protected var FActivityModes:TActivityModes;
      
      protected var FCurAtoms:TActivityAtoms;
      
      protected var FHDActivityConfig:THDActivityBase;
      
      protected var FActivityID:uint;
      
      protected var FMemoryID:uint;
      
      protected var FActivityAtomsVect:Vector.<TActivityAtoms>;
      
      protected var FGiftOverLayer:TOverlayerGiftBox;
      
      protected var FUnstreamizerActivity:TUnstreamizerActivity;
      
      protected var FActivityInitRetData:TActivityInitRetData;
      
      protected var FGiftBoxTipData:TGiftBoxTipData;
      
      protected var FGetActivityConfig:Function;
      
      protected var FCheckEffectNotification:Function;
      
      protected var FEffectNotification:Function;
      
      protected var FGetActivityAtoms:Function;
      
      public function TProcessorBleachJigsaw(param1:TUIComponent, param2:TLobbyParameters)
      {
         var _loc3_:TBounds = null;
         super(param1,FParameters);
         this.FActivityModes = SLogicsCore.ActivityModes;
         this.FActivityID = CONST_ACTIVITY_MODE.Activity_BleachJigsaw;
         this.FMemoryID = 0;
         this.FUnstreamizerActivity = new TUnstreamizerActivity();
         this.FGiftBoxTipData = new TGiftBoxTipData();
         this.FProcessorWindowBleachJigsaw = new TProcessorWindowBleachJigsaw(this);
         this.FProcessorWindowBleachJigsaw.Visible = false;
         this.FProcessorWindowBleachJigsaw.OnClose = this.ProcessorOnClose;
         this.FProcessorWindowBleachJigsaw.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowBleachJigsaw.OnHintOver = this.UIComponentsOnOver;
         this.FProcessorWindowBleachJigsaw.OnHintOut = this.UIComponentsOnOut;
         this.FProcessorWindowBleachJigsaw.OnSlotOver = this.UIComponentsHintOnOver;
         this.FProcessorWindowBleachJigsaw.OnSlotOut = this.UIComponentsHintOnOut;
         _loc3_ = new TBounds();
         _loc3_.Width = SIZE_Width;
         _loc3_.Height = SIZE_Height;
         ComponentBoundsCenter(this.FProcessorWindowBleachJigsaw,_loc3_);
         _loc3_ = null;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityBleachJigsaw);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FGiftOverLayer = new TOverlayerGiftBox(this.Parent);
         this.FGiftOverLayer.visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FGiftOverLayer);
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function GetActivityConfigByActivityAtoms(param1:TActivityAtoms) : void
      {
         var _loc2_:uint = 0;
         if(this.FGetActivityConfig != null)
         {
            this.FHDActivityConfig = this.FGetActivityConfig(this,param1.ActivityNumber) as THDActivityBase;
         }
         this.FHDBleachJigsawConfig = this.FHDActivityConfig as THDBleachJigSaw;
      }
      
      protected function GetAtomsByActivityID(param1:uint) : TActivityAtoms
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TActivityAtoms = null;
         _loc3_ = this.FActivityAtomsVect.length;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FActivityAtomsVect[_loc2_];
            if(_loc4_.ActivityID == param1)
            {
               return _loc4_;
            }
            _loc2_++;
         }
         return null;
      }
      
      protected function ProcessorOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function ProcessorOnWindowOpen(param1:Object, param2:uint) : void
      {
      }
      
      protected function UIComponentsHintOnOver(param1:Object) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,param1);
      }
      
      protected function UIComponentsHintOnOut(param1:Object) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,param1);
      }
      
      protected function UIComponentsOnOver(param1:Object, param2:THint) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,param2);
      }
      
      protected function UIComponentsOnOut(param1:Object, param2:THint) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,param2);
      }
      
      protected function ProcessorOnGiftBoxMove(param1:Object, param2:Object, param3:Object = null) : void
      {
      }
      
      protected function ProcessorOnGiftBoxOut(param1:Object) : void
      {
         this.FGiftOverLayer.Hide();
      }
      
      public function get GetActivityConfig() : Function
      {
         return this.FGetActivityConfig;
      }
      
      public function set GetActivityConfig(param1:Function) : void
      {
         this.FGetActivityConfig = param1;
      }
      
      public function get CheckEffectNotification() : Function
      {
         return this.FCheckEffectNotification;
      }
      
      public function set CheckEffectNotification(param1:Function) : void
      {
         this.FCheckEffectNotification = param1;
      }
      
      public function get EffectNotification() : Function
      {
         return this.FEffectNotification;
      }
      
      public function set EffectNotification(param1:Function) : void
      {
         this.FEffectNotification = param1;
      }
      
      public function get GetActivityAtoms() : Function
      {
         return this.FGetActivityAtoms;
      }
      
      public function set GetActivityAtoms(param1:Function) : void
      {
         this.FGetActivityAtoms = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowBleachJigsaw.Load();
            return;
         }
         this.FActivityAtomsVect = this.FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_BleachJigsaw);
         this.FCurAtoms = this.GetAtomsByActivityID(this.FActivityID);
         if(this.FMemoryID != this.FCurAtoms.Identifier)
         {
            if(this.FHDBleachJigsawConfig == null)
            {
               this.GetActivityConfigByActivityAtoms(this.FCurAtoms);
            }
            this.FMemoryID = this.FCurAtoms.Identifier;
         }
         this.FProcessorWindowBleachJigsaw.Show(this.FCurAtoms,this.FHDActivityConfig);
         this.FProcessorWindowBleachJigsaw.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

