package Processors.Game.Lobby.Activity.HDFirstPay
{
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.DatebaseVO.VO.THDFirstPay;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityRecharge.TAwardData;
   import Logics.HDActivityRecharge.THDFirstPayData;
   import Logics.SLogicsCore;
   import Logics.Streamization.HDActivity.TUnstreamizerActivity;
   import Logics.Streamization.HDActivityRecharge.TUnstreamizerActivityRecharge;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_INVENTORY;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SHORTCUTS;
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   
   public class TProcessorHDFirstPay extends TProcessorLobbyWindows
   {
      
      protected static const WINDOW_NUM:uint = 3;
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      protected var FWindows:Vector.<TProcessorWindowFirstPay>;
      
      protected var FFirstPayData:THDFirstPayData;
      
      protected var FUnstreamizerActivityRecharge:TUnstreamizerActivityRecharge;
      
      protected var FFirstPay:THDFirstPay;
      
      protected var FAtoms:TActivityAtoms;
      
      protected var FCurWindow:TProcessorWindowFirstPay;
      
      protected var FUnstreamizerActivity:TUnstreamizerActivity;
      
      protected var FActivityInitRetData:TActivityInitRetData;
      
      protected var FGetActivityConfig:Function;
      
      protected var FOnUpdateFirstPayIcon:Function;
      
      protected var FEffectNotification:Function;
      
      public function TProcessorHDFirstPay(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FWindows = new Vector.<TProcessorWindowFirstPay>(WINDOW_NUM);
         this.FFirstPayData = new THDFirstPayData();
         this.FUnstreamizerActivityRecharge = new TUnstreamizerActivityRecharge();
         this.FUnstreamizerActivity = new TUnstreamizerActivity();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityFirstPay);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:TProcessorWindowFirstPay = null;
         var _loc2_:Sprite = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc4_ = WINDOW_NUM;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc2_ = TUtilityReflection.CreateDisplayObjectInstance("MC_Part_" + _loc3_) as Sprite;
            addChild(_loc2_);
            _loc1_ = new TProcessorWindowFirstPay(this,_loc2_);
            _loc1_.OnClose = this.WindowOnClose;
            _loc1_.SlotOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            _loc1_.SlotOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            _loc1_.OnGetAward = this.GetAwardReq;
            _loc1_.FirstPayInit();
            _loc1_.Scence.visible = false;
            this.FWindows[_loc3_] = _loc1_;
            _loc3_++;
         }
         this.FAtoms = SLogicsCore.ActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_FirstPay);
         this.FFirstPay = this.FGetActivityConfig(this,this.FAtoms.ActivityNumber) as THDFirstPay;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FCurWindow != null)
         {
            this.FCurWindow.UpdateSlot();
         }
      }
      
      private function PerformPacket_SC_FirstPayRet(param1:TActivityAtoms, param2:ByteArray) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TProcessorWindowFirstPay = null;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         if(this.FFirstPay == null)
         {
            this.FAtoms = SLogicsCore.ActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_FirstPay);
            this.FFirstPay = this.FGetActivityConfig(this,this.FAtoms.ActivityNumber) as THDFirstPay;
         }
         else
         {
            this.FAtoms = param1;
         }
         this.FActivityInitRetData = this.FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         this.FUnstreamizerActivityRecharge.UnstreamizeUpdateFirstPay(this.FActivityInitRetData,this.FFirstPayData,this.FFirstPay);
         if(!Visible)
         {
            return;
         }
         if(this.FCurWindow != null)
         {
            this.FCurWindow.Scence.visible = false;
            this.FCurWindow = null;
         }
         _loc5_ = this.FFirstPayData.CountForAward() - 1;
         _loc6_ = this.FFirstPayData.GetAwardByIndex(_loc5_).State;
         if(_loc6_ == CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
         {
            this.FAtoms.Status = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
            if(this.FEffectNotification != null)
            {
               this.FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_FirstRecharge);
            }
            SLogicsCore.ActivityModes.DeleteByIdentifier(this.FAtoms.Identifier);
            if(this.FOnUpdateFirstPayIcon != null)
            {
               this.FOnUpdateFirstPayIcon(this);
            }
            ProcessorClose();
            return;
         }
         _loc3_ = this.CheckProcess(this.FFirstPayData);
         if(_loc3_ <= 1)
         {
            _loc5_ = _loc3_;
         }
         else
         {
            _loc5_ = 2;
         }
         _loc4_ = this.FWindows[_loc5_];
         _loc4_.UpdateWindow(_loc3_,this.FFirstPayData);
         _loc4_.Scence.visible = true;
         this.FCurWindow = _loc4_;
      }
      
      private function CheckProcess(param1:THDFirstPayData) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TAwardData = null;
         _loc3_ = param1.CountForAward();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.GetAwardByIndex(_loc2_);
            if(_loc4_.State == CONST_ACTIVITY_MODE.Activity_CanReceive)
            {
               return _loc2_;
            }
            if(_loc4_.State == CONST_ACTIVITY_MODE.Activity_CanNotReceive)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
      
      protected function WindowOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      private function FirstPayReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Activity_InitReq);
         _loc1_.Data.writeUnsignedInt(this.FAtoms.Identifier);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function GetAwardReq(param1:Object, param2:int) : void
      {
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Activity_OperateReq);
         _loc3_.Data.writeUnsignedInt(this.FAtoms.Identifier);
         _loc3_.Data.writeUnsignedInt(param2);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      private function CheckState(param1:THDFirstPayData) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TAwardData = null;
         _loc2_ = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
         _loc4_ = param1.CountForAward();
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param1.GetAwardByIndex(_loc3_);
            if(_loc5_.State == CONST_ACTIVITY_MODE.Activity_CanReceive)
            {
               _loc2_ = CONST_ACTIVITY_MODE.Activity_CanReceive;
               break;
            }
            if(_loc5_.State == CONST_ACTIVITY_MODE.Activity_CanNotReceive)
            {
               _loc2_ = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
            }
            _loc3_++;
         }
         this.FAtoms.Status = _loc2_;
         if(this.FEffectNotification != null)
         {
            this.FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_FirstRecharge);
         }
      }
      
      private function ResetUI() : void
      {
      }
      
      public function get GetActivityConfig() : Function
      {
         return this.FGetActivityConfig;
      }
      
      public function set GetActivityConfig(param1:Function) : void
      {
         this.FGetActivityConfig = param1;
      }
      
      public function get EffectNotification() : Function
      {
         return this.FEffectNotification;
      }
      
      public function set EffectNotification(param1:Function) : void
      {
         this.FEffectNotification = param1;
      }
      
      public function get OnUpdateFirstPayIcon() : Function
      {
         return this.FOnUpdateFirstPayIcon;
      }
      
      public function set OnUpdateFirstPayIcon(param1:Function) : void
      {
         this.FOnUpdateFirstPayIcon = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.FirstPayReq();
      }
      
      override public function Unmount() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         super.Unmount();
         this.FCurWindow = null;
         _loc2_ = WINDOW_NUM;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FWindows[_loc1_].Reset();
            _loc1_++;
         }
      }
      
      public function ActivitiesInitRet(param1:TActivityAtoms, param2:ByteArray) : void
      {
         this.PerformPacket_SC_FirstPayRet(param1,param2);
      }
      
      public function UpdateAtomState() : void
      {
         this.FAtoms = SLogicsCore.ActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_FirstPay);
         if(this.FEffectNotification != null)
         {
            this.FEffectNotification(this,CONST_SHORTCUTS.TYPE_ActiveList_FirstRecharge);
         }
      }
      
      public function UpdateActivityChangeState(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = param2.Index;
         _loc4_ = param2.Status;
         this.FFirstPayData.GetAwardByIndex(_loc3_).State = _loc4_;
         this.CheckState(this.FFirstPayData);
         if(Visible)
         {
            this.FirstPayReq();
         }
      }
      
      public function ValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         var _loc3_:uint = 0;
         if(Visible)
         {
            this.FFirstPayData.TotalPay = param2[0];
            _loc3_ = this.CheckProcess(this.FFirstPayData);
            this.FCurWindow.UpdateWindow(_loc3_,this.FFirstPayData);
         }
      }
      
      public function OperateRet(param1:Vector.<TFixedAward>) : void
      {
      }
   }
}

