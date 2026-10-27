package Processors.Game.Lobby.BleachAgent
{
   import Foundation.Common.TBounds;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.BleachAgent.TBleachAgentData;
   import Logics.SLogicsCore;
   import Logics.Streamization.BleachAgent.TUnstreamizerBleachAgent;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TProcessorBleachAgent extends TProcessorLobbyWindows
   {
      
      protected static const WINDOW_WIDTH:int = 890;
      
      protected static const WINDOW_HEIGTH:int = 609;
      
      protected const RESOURCESID_Swf:uint = 754974720;
      
      protected var FMainWin:TProcessorWindowBleachAgent;
      
      protected var FBounds:TBounds;
      
      protected var FUnstreamizer:TUnstreamizerBleachAgent;
      
      protected var FData:TBleachAgentData;
      
      protected var FInited:Boolean;
      
      protected var FUpdateBleachIcon:Function;
      
      public function TProcessorBleachAgent(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FMainWin = new TProcessorWindowBleachAgent(this);
         this.FMainWin.OnClose = this.ShutDownWindows;
         this.FMainWin.Visible = false;
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_WIDTH;
         this.FBounds.Height = WINDOW_HEIGTH;
         ComponentBoundsCenter(this.FMainWin,this.FBounds);
         this.FData = SLogicsCore.BleachAgentData;
         this.FUnstreamizer = new TUnstreamizerBleachAgent(this.FData);
         this.FInited = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(this.RESOURCESID_Swf);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_BleachAgent_InitInfoRet,this.PacketPerform_SC_InitInfoRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_BleachAgent_UpdateRet,this.PacketPerform_SC_UpdateRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_BleachAgent_BuyRet,this.PacketPerform_SC_BuyRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_BleachAgent_WelfareCountUpdateRet,this.PacketPerform_SC_WelfareCountUpdateRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_BleachAgent_Expire,this.PacketPerform_SC_Expire);
      }
      
      protected function PacketPerform_SC_InitInfoRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizer.InitRet(param1.Data);
         this.FInited = true;
         this.FMainWin.Visible = true;
      }
      
      protected function PacketPerform_SC_UpdateRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = this.FUnstreamizer.UpdateRet(param1.Data);
         this.FMainWin.UIUpdate();
         if(_loc3_)
         {
            SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BleachAgent_02));
         }
      }
      
      protected function PacketPerform_SC_BuyRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizer.BuyRet(param1.Data);
         this.FMainWin.UIUpdate();
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BleachAgent_03));
         this.FUpdateBleachIcon();
      }
      
      protected function PacketPerform_SC_WelfareCountUpdateRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = param1.Data.readInt();
         _loc4_ = param1.Data.readInt();
         this.FData.SetWelfareCountByType(_loc3_,_loc4_);
      }
      
      protected function PacketPerform_SC_Expire(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizer.ExpireRet(param1.Data);
         this.FUpdateBleachIcon();
      }
      
      protected function ShutDownWindows(param1:Object) : void
      {
         ProcessorClose();
      }
      
      public function set UpdateBleachIcon(param1:Function) : void
      {
         this.FUpdateBleachIcon = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FMainWin.Load();
            return;
         }
         if(this.FInited)
         {
            this.FMainWin.Visible = true;
         }
         else
         {
            this.FUnstreamizer.InitReq();
         }
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

