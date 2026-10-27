package Processors.Game.Lobby.Activity.HDSoulCarnival.TUIComponent
{
   import Components.Slots.TUISlot;
   import Components.Standard.TUIButton;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_NETWORK;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TUIBar extends TUIComponent
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FSlots:Vector.<TUISlot>;
      
      protected var FBtn_OK:TUIButton;
      
      protected var FUIndex:uint;
      
      protected var FActID:uint;
      
      public function TUIBar(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function ProcessorOK(param1:Object, param2:MouseEvent) : void
      {
         this.Perform_CS_ActivityOperateReq(this.FActID,this.FUIndex + 1);
      }
      
      protected function Perform_CS_ActivityOperateReq(param1:uint, param2:uint, param3:uint = 0, param4:Vector.<int> = null) : void
      {
         var _loc5_:TPacket = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(param1 <= 0)
         {
            return;
         }
         _loc5_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Activity_OperateReq);
         _loc5_.Data.writeUnsignedInt(param1);
         _loc5_.Data.writeUnsignedInt(param2);
         if(param4 != null)
         {
            _loc7_ = int(param4.length);
            _loc5_.Data.writeShort(_loc7_);
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc5_.Data.writeInt(param4[_loc6_]);
               _loc6_++;
            }
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc5_);
      }
      
      public function LogicsPerform() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = 4;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FSlots[_loc1_] != null)
            {
               this.FSlots[_loc1_].Update();
            }
            _loc1_++;
         }
      }
      
      public function UIDispatch(param1:MovieClip, param2:uint) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FMainUI = param1;
         this.FUIndex = param2;
         this.FBtn_OK = new TUIButton();
         this.FBtn_OK.Substrate = this.FMainUI["Btn_OK"];
         this.FBtn_OK.OnClick = this.ProcessorOK;
         _loc4_ = 4;
         this.FSlots = new Vector.<TUISlot>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FSlots[_loc3_] = new TUISlot(this);
            this.FSlots[_loc3_].Resource = param1["slot" + _loc3_];
            if(this.FSlots[_loc3_].Resource == null)
            {
               return;
            }
            this.FSlots[_loc3_].OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
            this.FSlots[_loc3_].OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
            TJadeCommon.InitSlot(this.FSlots[_loc3_]);
            this.FSlots[_loc3_].Init();
            _loc3_++;
         }
      }
      
      public function Update(param1:uint, param2:uint, param3:TInventories, param4:uint) : void
      {
         var _loc5_:uint = 0;
         this.FMainUI["TF_0"].text = param1 + "";
         this.FMainUI["TF_1"].text = param2 + "";
         this.FActID = param4;
         this.FBtn_OK.Enabled = param2 > 0 ? true : false;
         param2 = uint(param3.Count);
         _loc5_ = 0;
         while(_loc5_ < param2)
         {
            if(_loc5_ < 4)
            {
               this.FSlots[_loc5_].Context = param3.GetInventoryByIndex(_loc5_);
            }
            _loc5_++;
         }
      }
   }
}

