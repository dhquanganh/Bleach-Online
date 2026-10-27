package Processors.Game.Lobby.ShinobidoPractise
{
   import Foundation.Common.TBounds;
   import Foundation.Common.THint;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.FightingCapacity.TFightingCapacityRank;
   import Logics.FightingCapacity.TFightingCapacityRanks;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Utilities.HyperLink.SUtilityHyperLink;
   import Rendering.Overlayers.HelpTips.TOverlayerHelpTips;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SHINOBIDOPRACTISE;
   import flash.utils.ByteArray;
   
   public class TProcessorShinobidoPractise extends TProcessorLobbyWindows
   {
      
      public static const SIZE_WindowMail_Width:uint = 541;
      
      public static const SIZE_WindowMail_Height:uint = 330;
      
      protected static const OFFSIDE_X:uint = 357;
      
      protected static const OFFSIDE_Y:uint = 353;
      
      protected var FBounds:TBounds;
      
      protected var FProcessorWindowShinobidoPractise:TProcessorWindowShinobidoPractise;
      
      protected var FProcessorWindowFightingCapacityRank:TProcessorWindowFightingCapacityRank;
      
      protected var FOverlayerHelpTips:TOverlayerHelpTips;
      
      protected var FFightingCapacityRanks:TFightingCapacityRanks;
      
      protected var FSingleRank:uint;
      
      public function TProcessorShinobidoPractise(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorWindowShinobidoPractise = new TProcessorWindowShinobidoPractise(this);
         this.FProcessorWindowShinobidoPractise.OnClose = this.ProcessorWindowOnClose;
         this.FProcessorWindowShinobidoPractise.OnHelpTipsOver = this.UIHelpTipsHintOnOver;
         this.FProcessorWindowShinobidoPractise.OnHelpTipsOut = this.UIHelpTipsHintOnOut;
         this.FProcessorWindowShinobidoPractise.OnOpenFightingCapacityRank = this.ProcessorOnOpenFightingCapacityRank;
         this.FProcessorWindowShinobidoPractise.OnGoto = this.ProcessorOnGoto;
         this.FBounds = new TBounds();
         this.FBounds.X = this.FProcessorWindowShinobidoPractise.x;
         this.FBounds.Y = this.FProcessorWindowShinobidoPractise.y;
         this.FBounds.Width = SIZE_WindowMail_Width;
         this.FBounds.Height = SIZE_WindowMail_Height;
         ComponentBoundsCenter(this.FProcessorWindowShinobidoPractise,this.FBounds);
         this.FBounds = null;
         this.FProcessorWindowFightingCapacityRank = new TProcessorWindowFightingCapacityRank(this);
         this.FProcessorWindowFightingCapacityRank.X = (CONST_COMMON.STAGE_Width - OFFSIDE_X) / 2;
         this.FProcessorWindowFightingCapacityRank.Y = (CONST_COMMON.STAGE_Height - OFFSIDE_Y) / 2;
         this.FFightingCapacityRanks = new TFightingCapacityRanks();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_SHINOBIDOPRACTISE.RESOURCESID_Swf_ShinobidoPractise);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_FightingShow_ALLFightRankRet,this.PerformPacket_SC_ALLFightRankRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_FightingShow_SingleFightRankRet,this.PerformPacket_SC_SingleFightRankRet);
         super.PacketRegisterRoutines();
      }
      
      protected function PerformPacket_SC_ALLFightRankRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:TFightingCapacityRank = null;
         _loc2_ = param1.Data;
         _loc2_.readUnsignedInt();
         _loc3_ = uint(_loc2_.readShort());
         this.FFightingCapacityRanks.Clear();
         _loc4_ = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = new TFightingCapacityRank();
            _loc5_.Rank = _loc2_.readUnsignedInt();
            _loc5_.Family = _loc2_.readUnsignedInt();
            _loc5_.Name = TUtilityString.FetchUTF(_loc2_);
            _loc5_.Level = _loc2_.readUnsignedInt();
            _loc5_.FightingCapacity = _loc2_.readUnsignedInt();
            this.FFightingCapacityRanks.Add(_loc5_);
            _loc4_++;
         }
         this.FFightingCapacityRanks.Sort();
      }
      
      protected function PerformPacket_SC_SingleFightRankRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         this.FSingleRank = _loc3_;
         if(this.FProcessorWindowFightingCapacityRank.Visible)
         {
            this.FProcessorWindowFightingCapacityRank.Init(this.FFightingCapacityRanks,this.FSingleRank);
         }
      }
      
      protected function PerformPacket_CS_ALLFightRankReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_FightingShow_ALLFightRankReq);
         _loc2_ = _loc1_.Data;
         _loc2_.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function PerformPacket_CS_SingleFightRankReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_FightingShow_SingleFightRankReq);
         _loc2_ = _loc1_.Data;
         _loc2_.writeUnsignedInt(0);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorOnGoto(param1:Object, param2:uint) : void
      {
         this.ProcessorWindowOnClose(this);
         SUtilityHyperLink.ShortcutHyperlink(param2);
      }
      
      protected function ProcessorOnOpenFightingCapacityRank(param1:Object) : void
      {
         this.FProcessorWindowFightingCapacityRank.Visible = true;
         this.FProcessorWindowFightingCapacityRank.Init(this.FFightingCapacityRanks,this.FSingleRank);
      }
      
      protected function ProcessorWindowOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function UIHelpTipsHintOnOver(param1:Object, param2:THint) : void
      {
         this.FOverlayerHelpTips.Context = param2;
         this.FOverlayerHelpTips.Render(FUICore.MouseCoordinate);
         this.FOverlayerHelpTips.Show();
      }
      
      protected function UIHelpTipsHintOnOut(param1:Object) : void
      {
         this.FOverlayerHelpTips.Hide();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowShinobidoPractise.Load();
            this.FProcessorWindowFightingCapacityRank.Load();
            return;
         }
         this.FProcessorWindowShinobidoPractise.Visible = true;
         this.FProcessorWindowShinobidoPractise.Init();
         this.PerformPacket_CS_ALLFightRankReq();
         this.PerformPacket_CS_SingleFightRankReq();
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FFightingCapacityRanks.Clear();
      }
   }
}

