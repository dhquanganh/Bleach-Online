package Processors.Game.Lobby.EquipForge
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.EquipForge.TEquipForge;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_NETWORK;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   
   public class TProcessorWinShop extends TUIComponent
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FBtn_Get:TUIButton;
      
      protected var FBtn_Start:TUIButton;
      
      protected var FBtn_Over:TUIButton;
      
      protected var FBtn_Buy:TUIButton;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FData:TEquipForge;
      
      public function TProcessorWinShop(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function ProcessorGet(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_UltimateEquip_AwardReq);
         _loc4_ = _loc3_.Data;
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function ProcessorGoldOver(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_UltimateEquip_CompleteReq);
         _loc3_ = _loc2_.Data;
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ProcessorOver(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         _loc4_ = uint(TUtilityLobby.GetConfigValue(62100007));
         _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(70950004),_loc4_);
         TUtilityLobby.GoldBuy(_loc4_,this.ProcessorGoldOver,_loc3_);
      }
      
      protected function ProcessorGoldBuy(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_UltimateEquip_BuyEnergyReq);
         _loc3_ = _loc2_.Data;
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ProcessorBuy(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         _loc4_ = uint(TUtilityLobby.GetConfigValue(62100005));
         _loc3_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(70950005),_loc4_,uint(TUtilityLobby.GetConfigValue(62100006)));
         TUtilityLobby.GoldBuy(_loc4_,this.ProcessorGoldBuy,_loc3_);
      }
      
      protected function ProcessorStart(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_UltimateEquip_WorkReq);
         _loc4_ = _loc3_.Data;
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      public function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = 4;
         if(Visible != false && this.FData != null)
         {
            _loc1_ = 0;
            while(_loc1_ < _loc2_)
            {
               this.FSlots[_loc1_].Update();
               _loc1_++;
            }
            if(this.FData.TimeStamp - STimingCore.ServerTick > 0)
            {
               this.FMainUI["TF_Energy"].text = Math.floor((this.FData.TimeStamp - STimingCore.ServerTick) / 60) + "";
               this.FMainUI["Effect"].play();
            }
            else
            {
               this.FMainUI["TF_Energy"].text = this.FData.Energy + "";
               this.FMainUI["Effect"].stop();
            }
         }
      }
      
      public function Update(param1:TEquipForge) : void
      {
         var _loc2_:TInventories = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         this.FData = param1;
         _loc2_ = new TInventories();
         SToolReward.GetAwardsByAwardID(TUtilityLobby.GetConfigValue(62100003) as int,_loc2_);
         this.FSlots[0].Context = _loc2_.GetInventoryByIndex(0);
         _loc5_ = TUtilityLobby.GetConfigValue(62100004) as Object;
         _loc4_ = 3;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            SToolReward.GetAwardsByAwardID(_loc5_[_loc3_].awardId,_loc2_);
            _loc3_++;
         }
         _loc4_ = 3;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FSlots[_loc3_ + 1].Context = _loc2_.GetInventoryByIndex(_loc3_ + 1);
            _loc3_++;
         }
         this.FMainUI["TF_Last"].text = this.FData.GetCount + "";
         this.FMainUI["TF_BuyLast"].text = this.FData.BuyCount + "";
         this.FBtn_Get.Enabled = this.FData.GetCount <= 0 ? false : true;
         this.FBtn_Buy.Enabled = this.FData.BuyCount <= 0 ? false : true;
         if(this.FData.TimeStamp - STimingCore.ServerTick > 0)
         {
            this.FBtn_Buy.Enabled = this.FBtn_Get.Enabled = this.FBtn_Start.Enabled = false;
            this.FBtn_Over.Enabled = true;
         }
         else
         {
            this.FBtn_Get.Enabled = this.FData.GetCount <= 0 ? false : true;
            this.FBtn_Buy.Enabled = this.FData.BuyCount <= 0 ? false : true;
            this.FBtn_Start.Enabled = this.FData.Energy <= 0 || this.FData.GetCount > 0 ? false : true;
            this.FBtn_Over.Enabled = false;
         }
      }
      
      public function UIDispatch(param1:MovieClip) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FMainUI = param1;
         this.FBtn_Get = new TUIButton();
         this.FBtn_Get.Substrate = this.FMainUI["Btn_Get"];
         this.FBtn_Get.OnClick = this.ProcessorGet;
         this.FBtn_Start = new TUIButton();
         this.FBtn_Start.Substrate = this.FMainUI["Btn_Start"];
         this.FBtn_Start.OnClick = this.ProcessorStart;
         this.FBtn_Over = new TUIButton();
         this.FBtn_Over.Substrate = this.FMainUI["Btn_Over"];
         this.FBtn_Over.OnClick = this.ProcessorOver;
         this.FBtn_Buy = new TUIButton();
         this.FBtn_Buy.Substrate = this.FMainUI["Btn_Buy"];
         this.FBtn_Buy.OnClick = this.ProcessorBuy;
         _loc3_ = 4;
         this.FSlots = new Vector.<TUISlot>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FSlots[_loc2_] = new TUISlot(this);
            this.FSlots[_loc2_].Resource = this.FMainUI["slot" + _loc2_];
            this.FSlots[_loc2_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc2_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc2_]);
            this.FSlots[_loc2_].Init();
            _loc2_++;
         }
      }
   }
}

