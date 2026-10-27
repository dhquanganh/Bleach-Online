package Processors.Game.Lobby.Activity.HDLikeUs
{
   import Externals.SExternalCore;
   import Foundation.Network.*;
   import Foundation.UI.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorLikeUs extends TProcessorLobbyWindows
   {
      
      protected static const TYPE_ICON_UNRECEIVED:uint = 1;
      
      protected static const TYPE_ICON_UNLINK:uint = 2;
      
      protected static const TYPE_RECEIVE_LINK:uint = 1;
      
      protected static const TYPE_RECEIVE_RECEIVED:uint = 2;
      
      protected var FLikeUsStatus:int;
      
      protected var FOnShutDownFunction:Function;
      
      protected var FOnChangeShortcutIcon:Function;
      
      public function TProcessorLikeUs(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LikeUs_DataRet,this.PerformPacket_SC_LikeUs_DataRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LikeUs_ReceiveRet,this.PerformPacket_SC_LikeUs_ReceiveRet);
      }
      
      protected function PerformPacket_SC_LikeUs_DataRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FLikeUsStatus = _loc3_.readUnsignedInt();
         switch(this.FLikeUsStatus)
         {
            case TYPE_ICON_UNRECEIVED:
               if(this.FOnChangeShortcutIcon != null)
               {
                  this.FOnChangeShortcutIcon(this,CONST_SHORTCUTS.POSITION_SecondaryFunction,CONST_SHORTCUTS.TYPE_SecondaryFunction_Likeus);
               }
               break;
            case TYPE_ICON_UNLINK:
               break;
            default:
               this.FOnShutDownFunction(this,CONST_SHORTCUTS.POSITION_SecondaryFunction,CONST_SHORTCUTS.TYPE_SecondaryFunction_Likeus);
         }
      }
      
      protected function PerformPacket_SC_LikeUs_ReceiveRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = int(_loc3_.readUnsignedInt());
         switch(_loc4_)
         {
            case TYPE_RECEIVE_LINK:
               if(this.FOnChangeShortcutIcon != null)
               {
                  this.FOnChangeShortcutIcon(this,CONST_SHORTCUTS.POSITION_SecondaryFunction,CONST_SHORTCUTS.TYPE_SecondaryFunction_Likeus);
               }
               this.FLikeUsStatus = TYPE_ICON_UNRECEIVED;
               break;
            case TYPE_RECEIVE_RECEIVED:
               if(this.FOnShutDownFunction != null)
               {
                  this.FOnShutDownFunction(this,CONST_SHORTCUTS.POSITION_SecondaryFunction,CONST_SHORTCUTS.TYPE_SecondaryFunction_Likeus);
               }
         }
         SToolReward.ShowReward(_loc3_);
      }
      
      public function get OnShutDownFunction() : Function
      {
         return this.FOnShutDownFunction;
      }
      
      public function set OnShutDownFunction(param1:Function) : void
      {
         this.FOnShutDownFunction = param1;
      }
      
      public function get OnChangeShortcutIcon() : Function
      {
         return this.FOnChangeShortcutIcon;
      }
      
      public function set OnChangeShortcutIcon(param1:Function) : void
      {
         this.FOnChangeShortcutIcon = param1;
      }
      
      public function ProcessorLikeUs() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LikeUs_ReceiveReq);
         _loc2_ = _loc1_.Data;
         switch(this.FLikeUsStatus)
         {
            case TYPE_ICON_UNRECEIVED:
               _loc2_.writeUnsignedInt(TYPE_RECEIVE_RECEIVED);
               break;
            case TYPE_ICON_UNLINK:
               _loc2_.writeUnsignedInt(TYPE_RECEIVE_LINK);
               SExternalCore.NavigateToLinkUrl((TUtilityLobby.GetObjectByIdentifier(CONST_CONFIGVALUE.STRING_LikeUsUrl) as Object).url);
               break;
            default:
               return;
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
   }
}

