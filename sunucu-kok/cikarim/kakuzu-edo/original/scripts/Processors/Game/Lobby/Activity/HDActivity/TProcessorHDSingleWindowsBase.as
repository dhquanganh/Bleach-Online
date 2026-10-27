package Processors.Game.Lobby.Activity.HDActivity
{
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.TActivityModes;
   import Logics.HDActivityMode.TGiftBoxTipData;
   import Logics.SLogicsCore;
   import Logics.Streamization.HDActivity.TUnstreamizerActivity;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_INVENTORY;
   import Resources.Constants.CONST_NETWORK;
   import Utilities.UI.Overlayers.TUtilityUIOverlayer;
   import flash.utils.ByteArray;
   
   public class TProcessorHDSingleWindowsBase extends TProcessorLobbyWindows
   {
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
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
      
      public function TProcessorHDSingleWindowsBase(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FActivityModes = SLogicsCore.ActivityModes;
         this.FMemoryID = 0;
         this.FUnstreamizerActivity = new TUnstreamizerActivity();
         this.FGiftBoxTipData = new TGiftBoxTipData();
         this.InitWindows();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FGiftOverLayer = new TOverlayerGiftBox(this.Parent);
         this.FGiftOverLayer.visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FGiftOverLayer);
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function InitWindows() : void
      {
      }
      
      protected function Perform_CS_ActivityInitReq(param1:uint) : void
      {
         var _loc2_:TPacket = null;
         if(param1 <= 0)
         {
            return;
         }
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Activity_InitReq);
         _loc2_.Data.writeUnsignedInt(param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function Perform_CS_ActivityOperateReq(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc4_:TPacket = null;
         if(param1 <= 0)
         {
            return;
         }
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Activity_OperateReq);
         _loc4_.Data.writeUnsignedInt(param1);
         _loc4_.Data.writeUnsignedInt(param2);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
      }
      
      protected function GetActivityConfigByActivityAtoms(param1:TActivityAtoms) : void
      {
         var _loc2_:uint = 0;
         if(this.FGetActivityConfig != null)
         {
            this.FHDActivityConfig = this.FGetActivityConfig(this,param1.ActivityNumber) as THDActivityBase;
         }
         this.UpdateUIConfig();
      }
      
      protected function UpdateUIConfig() : void
      {
      }
      
      protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
      }
      
      protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
      }
      
      protected function GetAtomsByActivityID(param1:uint) : TActivityAtoms
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TActivityAtoms = null;
         if(this.FActivityAtomsVect == null)
         {
            return null;
         }
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
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
      
      public function ActivitiesInitRet(param1:TActivityAtoms, param2:ByteArray) : void
      {
         this.ProcessorSCInitWindow(param1,param2);
      }
      
      public function UpdateActivityChangeState(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         this.ProcessorSCAwardStatusChangeNotify(param2);
      }
      
      public function ValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         if(!this.Visible)
         {
            return;
         }
      }
      
      public function OperateRet(param1:Vector.<TFixedAward>) : void
      {
      }
   }
}

