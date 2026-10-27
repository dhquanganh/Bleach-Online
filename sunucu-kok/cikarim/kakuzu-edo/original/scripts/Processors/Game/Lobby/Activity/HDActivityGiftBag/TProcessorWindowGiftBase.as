package Processors.Game.Lobby.Activity.HDActivityGiftBag
{
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Queries.TQueryString;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.DatebaseVO.VO.TAward;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityMode.TActivityModes;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TAppliance;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Logics.SLogicsCore;
   import Logics.Streamization.HDActivity.TUnstreamizerActivity;
   import Logics.Streamization.HDActivityGB.TUnstreamizerActivityGB;
   import Logics.Streamization.Inventories.TUnstreamizerInventoryReference;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_ACTIVITY;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowGiftBase extends TProcessorLobbyWindow
   {
      
      protected static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      protected static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      protected static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected static const MAX_AWARD_COUNT:uint = 5;
      
      protected var FMC:Sprite;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FUnstreamizerInventoryReference:TUnstreamizerInventoryReference;
      
      protected var FUnstreamizerActivityGB:TUnstreamizerActivityGB;
      
      protected var FAwardBins:TBins;
      
      protected var FHDActivityConfig:THDActivityBase;
      
      protected var FDataActivity:TActivityOSBase;
      
      protected var FActivityModes:TActivityModes;
      
      protected var FActivityAtoms:TActivityAtoms;
      
      protected var FBoxStatus:Vector.<int>;
      
      protected var FIsInitWindow:Boolean;
      
      protected var FUnstreamizerActivity:TUnstreamizerActivity;
      
      protected var FActivityInitRetData:TActivityInitRetData;
      
      protected var FGetActivityConfig:Function;
      
      protected var FOnShortcutHyperlinks:Function;
      
      protected var FOnSlotOver:Function;
      
      protected var FOnSlotOut:Function;
      
      protected var FOnHintOver:Function;
      
      protected var FOnHintOut:Function;
      
      protected var FCheckOnOff:Function;
      
      protected var FCheckSecondEffectNotification:Function;
      
      protected var FOnGiftBoxOver:Function;
      
      protected var FOnGiftBoxOut:Function;
      
      protected var FActivityID:uint;
      
      protected var FMemoryID:uint;
      
      protected var FActivityData:TActivityOSBase;
      
      public function TProcessorWindowGiftBase(param1:TUIComponent)
      {
         super(param1);
         this.FActivityModes = SLogicsCore.ActivityModes;
         this.FIsInitWindow = false;
         this.FUnstreamizerActivityGB = new TUnstreamizerActivityGB();
         this.FUnstreamizerInventoryReference = new TUnstreamizerInventoryReference();
         this.FUnstreamizerActivity = new TUnstreamizerActivity();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
         this.InitWindow();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      protected function InitWindow() : void
      {
         if(this.FMC == null)
         {
            return;
         }
         this.FBtn_Close = this.FMC[CONST_ACTIVITY.RESOURCE_Link_BTN_Close];
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseWindowHandler,false,0,true);
      }
      
      protected function UpdateUI() : void
      {
      }
      
      protected function UpdateDataBase(param1:ByteArray) : void
      {
      }
      
      protected function UpdataStatus(param1:uint, param2:int, param3:Vector.<int>) : void
      {
      }
      
      protected function ProcessorGetInventoriesVectByAwardID(param1:Vector.<uint>) : Vector.<TInventories>
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Vector.<TInventories> = null;
         if(this.FAwardBins == null)
         {
            this.FAwardBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Award);
         }
         _loc3_ = int(param1.length);
         _loc4_ = new Vector.<TInventories>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_[_loc2_] = this.ProcessorGetInventories(param1[_loc2_]);
            _loc2_++;
         }
         return _loc4_;
      }
      
      protected function ProcessorGetInventories(param1:uint = 0, param2:Vector.<TFixedAward> = null) : TInventories
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TAward = null;
         var _loc6_:Vector.<TFixedAward> = null;
         var _loc7_:TInventories = null;
         var _loc8_:Vector.<uint> = null;
         var _loc9_:Vector.<uint> = null;
         if(param2 != null)
         {
            _loc6_ = param2;
         }
         else
         {
            _loc5_ = this.FAwardBins.GetDatebaseByIdentifier(param1) as TAward;
            _loc4_ = int(_loc5_.FixedAwards.length);
            _loc6_ = new Vector.<TFixedAward>(_loc4_);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc6_[_loc3_] = _loc5_.FixedAwards[_loc3_];
               _loc3_++;
            }
         }
         _loc4_ = int(_loc6_.length);
         _loc8_ = new Vector.<uint>(_loc4_);
         _loc9_ = new Vector.<uint>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc8_[_loc3_] = CONST_COMMON.RewardIDToTemplateID(_loc6_[_loc3_].Type,_loc6_[_loc3_].Code);
            _loc9_[_loc3_] = _loc6_[_loc3_].Amount;
            _loc3_++;
         }
         _loc7_ = new TInventories();
         this.FUnstreamizerInventoryReference.UnstreamizeGenerateInventoriesByIdentifiers(null,_loc7_,_loc8_);
         _loc4_ = _loc7_.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_.GetInventoryByIndex(_loc3_).Quantity = _loc9_[_loc3_];
            _loc3_++;
         }
         return _loc7_;
      }
      
      protected function ActivityGetBoxReq(param1:uint, param2:uint, param3:uint = 0) : void
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
      
      protected function GetConfig(param1:TActivityAtoms) : void
      {
         var _loc2_:uint = 0;
         if(this.FHDActivityConfig != null)
         {
            return;
         }
         _loc2_ = param1.ActivityNumber;
         if(this.FGetActivityConfig != null)
         {
            this.FHDActivityConfig = this.FGetActivityConfig(this,_loc2_) as THDActivityBase;
         }
      }
      
      protected function CheckActivityEnding() : Boolean
      {
         return false;
      }
      
      protected function UpdateUIList() : void
      {
      }
      
      protected function CheckActivityStatusNotification() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TActivityAtoms = null;
         _loc1_ = this.FBoxStatus.indexOf(Activity_CanReceive);
         _loc2_ = this.FActivityModes.GetActivityAtomsByActivityID(this.ActivityID);
         if(_loc1_ != -1)
         {
            _loc2_.Status = Activity_CanReceive;
            if(this.FCheckSecondEffectNotification != null)
            {
               this.FCheckSecondEffectNotification(_loc2_.Identifier,true);
            }
         }
         else
         {
            _loc2_.Status = Activity_CanNotReceive;
            if(this.FCheckSecondEffectNotification != null)
            {
               this.FCheckSecondEffectNotification(_loc2_.Identifier,false);
            }
         }
      }
      
      protected function Reset() : void
      {
      }
      
      public function ProcessorOnActiveInfoReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Activity_LoadActivityInfoReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ActivityInitReq(param1:uint) : void
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
      
      protected function ProcessorOnSlotOver(param1:Object, param2:Object) : void
      {
         if(this.FOnSlotOver != null)
         {
            this.FOnSlotOver(this,param2);
         }
      }
      
      protected function ProcessorOnSlotOut(param1:Object, param2:Object) : void
      {
         if(this.FOnSlotOut != null)
         {
            this.FOnSlotOut(this,param2);
         }
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      protected function SlotsOnQuerySubscript(param1:Object, param2:Object, param3:TQueryString) : void
      {
         var _loc4_:TAppliance = null;
         if(param2 is TAppliance)
         {
            _loc4_ = param2 as TAppliance;
            param3.Value = _loc4_.Quantity.toString();
         }
      }
      
      protected function PorcessorOnHintOver(param1:Object, param2:THint) : void
      {
         if(this.FOnHintOver != null)
         {
            this.FOnHintOver(this,param2);
         }
      }
      
      protected function ProcessorOnHintOut(param1:Object, param2:THint) : void
      {
         if(this.FOnHintOut != null)
         {
            this.FOnHintOut(this,param2);
         }
      }
      
      protected function BtnOKOnClick(param1:Object, param2:uint) : void
      {
      }
      
      protected function OnCloseWindowHandler(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      public function get OnShortcutHyperlinks() : Function
      {
         return this.FOnShortcutHyperlinks;
      }
      
      public function set OnShortcutHyperlinks(param1:Function) : void
      {
         this.FOnShortcutHyperlinks = param1;
      }
      
      public function get OnSlotOver() : Function
      {
         return this.FOnSlotOver;
      }
      
      public function set OnSlotOver(param1:Function) : void
      {
         this.FOnSlotOver = param1;
      }
      
      public function get OnSlotOut() : Function
      {
         return this.FOnSlotOut;
      }
      
      public function set OnSlotOut(param1:Function) : void
      {
         this.FOnSlotOut = param1;
      }
      
      public function get OnHintOver() : Function
      {
         return this.FOnHintOver;
      }
      
      public function set OnHintOver(param1:Function) : void
      {
         this.FOnHintOver = param1;
      }
      
      public function get OnHintOut() : Function
      {
         return this.FOnHintOut;
      }
      
      public function set OnHintOut(param1:Function) : void
      {
         this.FOnHintOut = param1;
      }
      
      public function get GetActivityConfig() : Function
      {
         return this.FGetActivityConfig;
      }
      
      public function set GetActivityConfig(param1:Function) : void
      {
         this.FGetActivityConfig = param1;
      }
      
      public function set ActivityID(param1:uint) : void
      {
         this.FActivityID = param1;
      }
      
      public function get ActivityID() : uint
      {
         return this.FActivityID;
      }
      
      public function get CheckOnOff() : Function
      {
         return this.FCheckOnOff;
      }
      
      public function set CheckOnOff(param1:Function) : void
      {
         this.FCheckOnOff = param1;
      }
      
      public function get CheckSecondEffectNotification() : Function
      {
         return this.FCheckSecondEffectNotification;
      }
      
      public function set CheckSecondEffectNotification(param1:Function) : void
      {
         this.FCheckSecondEffectNotification = param1;
      }
      
      public function get MemoryID() : uint
      {
         return this.FMemoryID;
      }
      
      public function set MemoryID(param1:uint) : void
      {
         this.FMemoryID = param1;
      }
      
      public function get OnGiftBoxOver() : Function
      {
         return this.FOnGiftBoxOver;
      }
      
      public function set OnGiftBoxOver(param1:Function) : void
      {
         this.FOnGiftBoxOver = param1;
      }
      
      public function get OnGiftBoxOut() : Function
      {
         return this.FOnGiftBoxOut;
      }
      
      public function set OnGiftBoxOut(param1:Function) : void
      {
         this.FOnGiftBoxOut = param1;
      }
      
      public function Show(param1:TActivityAtoms) : void
      {
         this.FActivityAtoms = param1;
         this.GetConfig(this.FActivityAtoms);
         this.MemoryID = this.FActivityAtoms.Identifier;
         this.visible = true;
      }
      
      public function Hide() : void
      {
         this.visible = false;
         this.Reset();
      }
      
      public function UpDateDataBase(param1:ByteArray) : void
      {
         this.UpdateDataBase(param1);
      }
      
      public function UpDataStatus(param1:uint, param2:int, param3:Vector.<int>) : void
      {
         this.UpdataStatus(param1,param2,param3);
      }
      
      public function GetActivityData() : TActivityOSBase
      {
         return this.FDataActivity;
      }
      
      public function ActivityInitRet(param1:ByteArray, param2:TActivityAtoms) : void
      {
      }
      
      public function ChangeActivityStatus(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
      }
   }
}

