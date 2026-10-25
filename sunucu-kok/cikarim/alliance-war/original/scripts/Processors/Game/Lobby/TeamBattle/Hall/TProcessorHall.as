package Processors.Game.Lobby.TeamBattle.Hall
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.TCharacter;
   import Logics.Characters.TDigest;
   import Logics.Characters.TDigests;
   import Logics.Characters.TPoolCharacter;
   import Logics.Rooms.TPoolRoomDigest;
   import Logics.Rooms.TRoomDigest;
   import Logics.Rooms.TRoomDigests;
   import Logics.SLogicsCore;
   import Logics.Streamization.Characters.TUnstreamizerDigest;
   import Logics.Streamization.Rooms.TUnstreamizerRoomDigest;
   import Logics.Streamization.TeamBattle.TUnstreamizerTeamBattleModel;
   import Logics.TeamBattle.TTeamBattle;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Resources.Constants.CONST_TEAMBATTLE;
   import flash.utils.ByteArray;
   
   public class TProcessorHall extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WindowTeamBattleHall_Width:uint = 752;
      
      protected static const SIZE_WindowTeamBattleHall_Height:uint = 563;
      
      protected static const SIZE_WindowTeamBattleCreateRoom_Width:uint = 880;
      
      protected static const SIZE_WindowTeamBattleCreateRoom_Height:uint = 513;
      
      protected static const TYPE_OPERATING_ADD:uint = CONST_TEAMBATTLE.TYPE_OPERATING_ADD;
      
      protected static const TYPE_OPERATING_UPDATE:uint = CONST_TEAMBATTLE.TYPE_OPERATING_UPDATE;
      
      protected static const TYPE_OPERATING_DELETE:uint = CONST_TEAMBATTLE.TYPE_OPERATING_DELETE;
      
      protected static const TYPE_ENTER_NORMAL:uint = CONST_TEAMBATTLE.TYPE_ENTER_NORMAL;
      
      protected static const TYPE_EnterCreateRoom_Hall:uint = CONST_TEAMBATTLE.TYPE_EnterCreateRoom_Hall;
      
      protected static const TYPE_EnterCreateRoom_Room:uint = CONST_TEAMBATTLE.TYPE_EnterCreateRoom_Room;
      
      protected var FUnstreamizerTeamBattleModel:TUnstreamizerTeamBattleModel;
      
      protected var FUnstreamizerRoomDigest:TUnstreamizerRoomDigest;
      
      protected var FUnstreamizerDigest:TUnstreamizerDigest;
      
      protected var FRoomDigests:TRoomDigests;
      
      protected var FFriendDigests:TDigests;
      
      protected var FPoolRoomDigest:TPoolRoomDigest;
      
      protected var FPoolCharacter:TPoolCharacter;
      
      protected var FCharacter:TCharacter;
      
      protected var FTeamBattle:TTeamBattle;
      
      protected var FProcessorWindowHall:TProcessorWindowHall;
      
      protected var FProcessorWindowCreateRoom:TProcessorWindowCreateRoom;
      
      protected var FParameter:ByteArray;
      
      protected var FOnUpdateTeamBattleChoose:Function;
      
      protected var FOnReturnTeamBattleChoose:Function;
      
      protected var FOnReturnRoom:Function;
      
      protected var FOnAgainChoose:Function;
      
      protected var FOnWhisper:Function;
      
      public function TProcessorHall(param1:TUIComponent, param2:TLobbyParameters)
      {
         var _loc3_:TBounds = null;
         super(param1,param2);
         this.FCharacter = SLogicsCore.Character;
         this.FTeamBattle = SLogicsCore.TeamBattle;
         this.FUnstreamizerTeamBattleModel = new TUnstreamizerTeamBattleModel();
         this.FUnstreamizerRoomDigest = new TUnstreamizerRoomDigest();
         this.FUnstreamizerDigest = new TUnstreamizerDigest();
         this.FRoomDigests = new TRoomDigests();
         this.FFriendDigests = new TDigests();
         this.FPoolRoomDigest = new TPoolRoomDigest();
         this.FPoolCharacter = SLogicsCore.PoolCharacter;
         this.FProcessorWindowHall = new TProcessorWindowHall(param1);
         this.FProcessorWindowHall.Visible = false;
         this.FProcessorWindowHall.OnClose = this.ProcessorWindowOnClose;
         this.FProcessorWindowHall.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowHall.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowHall.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowHall.OnCreateRoom = this.ProcessorOnCreateRoom;
         this.FProcessorWindowHall.OnWhisper = this.ProcessorOnWhisper;
         this.FProcessorWindowHall.RoomDigests = this.FRoomDigests;
         this.FProcessorWindowHall.FriendDigests = this.FFriendDigests;
         _loc3_ = new TBounds();
         _loc3_.Width = SIZE_WindowTeamBattleHall_Width;
         _loc3_.Height = SIZE_WindowTeamBattleHall_Height;
         ComponentBoundsCenter(this.FProcessorWindowHall,_loc3_);
         this.FProcessorWindowCreateRoom = new TProcessorWindowCreateRoom(param1);
         this.FProcessorWindowCreateRoom.Visible = false;
         this.FProcessorWindowCreateRoom.OnClose = this.ProcessorWindowOnClose;
         this.FProcessorWindowCreateRoom.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowCreateRoom.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowCreateRoom.OnAgainChoose = this.ProcessorOnAgainChoose;
         this.FProcessorWindowCreateRoom.OnReturnHall = this.ProcessorOnReturnHall;
         _loc3_.Width = SIZE_WindowTeamBattleCreateRoom_Width;
         _loc3_.Height = SIZE_WindowTeamBattleCreateRoom_Height;
         ComponentBoundsCenter(this.FProcessorWindowCreateRoom,_loc3_);
         _loc3_ = null;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TEAMBATTLE.RESOURCESID_Swf_TeamBattleHall);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleHall_RoomListNtf,this.PacketPerform_ProcessorRoomListNtf);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleHall_FriendListNtf,this.PacketPerform_ProcessorFriendListNtf);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleHall_CreatePlayerRoom,this.PacketPerform_ProcessorCreatePlayerRoom);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleHall_EnterPlayerRoom,this.PacketPerform_ProcessorEnterPlayerRoom);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleHall_TeamBattleInfoNtf,this.PacketPerform_ProcessorTeamBattleInfoNtf);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleHall_LeaveHall,this.PacketPerform_ProcessorLeaveHall);
      }
      
      protected function PacketPerform_ProcessorRoomListNtf(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:TRoomDigest = null;
         var _loc6_:TRoomDigest = null;
         var _loc7_:uint = 0;
         _loc4_ = param1.Data;
         _loc3_ = int(_loc4_.readUnsignedShort());
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FPoolRoomDigest.Acquire();
            this.FUnstreamizerRoomDigest.Unstreamize(_loc4_,_loc5_,this.FTeamBattle.ModeType);
            _loc7_ = _loc5_.OperatingType;
            if(_loc7_ == TYPE_OPERATING_ADD)
            {
               _loc6_ = this.FRoomDigests.GetDigestByIdentifier(_loc5_.Identifier);
               if(_loc6_ == null)
               {
                  this.FRoomDigests.Add(_loc5_);
               }
            }
            else if(_loc7_ == TYPE_OPERATING_UPDATE)
            {
               this.FRoomDigests.DeleteByIdentifier(_loc5_.Identifier);
               this.FRoomDigests.Add(_loc5_);
            }
            else if(_loc7_ == TYPE_OPERATING_DELETE)
            {
               this.FRoomDigests.DeleteByIdentifier(_loc5_.Identifier);
            }
            _loc2_++;
         }
         this.FRoomDigests.SortRooms();
         if(this.FProcessorWindowHall.Visible)
         {
            this.FProcessorWindowHall.UpdateUIRooms();
         }
      }
      
      protected function PacketPerform_ProcessorFriendListNtf(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:TDigest = null;
         var _loc6_:TDigest = null;
         var _loc7_:uint = 0;
         _loc4_ = param1.Data;
         _loc3_ = int(_loc4_.readUnsignedShort());
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FPoolCharacter.AcquireDigest();
            this.FUnstreamizerDigest.Unstreamize(_loc4_,_loc5_,null);
            _loc7_ = _loc5_.Type;
            if(_loc5_.Identifier0 == this.FCharacter.Identifier0 && _loc5_.Identifier1 == this.FCharacter.Identifier1)
            {
               _loc5_.Type = TYPE_OPERATING_DELETE;
               _loc7_ = TYPE_OPERATING_DELETE;
            }
            if(_loc7_ == TYPE_OPERATING_ADD)
            {
               _loc6_ = this.FFriendDigests.GetDigestByIdentifier(_loc5_.Identifier0,_loc5_.Identifier1);
               if(_loc6_ == null)
               {
                  this.FFriendDigests.Add(_loc5_);
               }
            }
            else if(_loc7_ == TYPE_OPERATING_UPDATE)
            {
               this.FFriendDigests.DeleteByDigest(_loc5_);
               this.FFriendDigests.Add(_loc5_);
            }
            else if(_loc7_ == TYPE_OPERATING_DELETE)
            {
               this.FFriendDigests.DeleteByDigest(_loc5_);
            }
            _loc2_++;
         }
         this.FFriendDigests.SortLevel();
         if(this.FProcessorWindowHall.Visible)
         {
            this.FProcessorWindowHall.UpdateUIFriends();
         }
      }
      
      protected function PacketPerform_ProcessorCreatePlayerRoom(param1:TPacket) : void
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
      }
      
      protected function PacketPerform_ProcessorEnterPlayerRoom(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            SLogicsCore.TeamBattle.SelectModelID = 0;
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_19));
      }
      
      protected function PacketPerform_ProcessorTeamBattleInfoNtf(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         _loc3_ = param1.Data;
         this.FTeamBattle.PVPRewardCount = _loc3_.readUnsignedShort();
         this.FTeamBattle.PVERewardCount = _loc3_.readUnsignedShort();
         this.FTeamBattle.Honor = _loc3_.readUnsignedInt();
         this.FUnstreamizerTeamBattleModel.Unstreamize(_loc3_,this.FTeamBattle,null);
         if(this.FOnUpdateTeamBattleChoose != null)
         {
            this.FOnUpdateTeamBattleChoose(this);
         }
      }
      
      protected function PacketPerform_ProcessorLeaveHall(param1:TPacket) : void
      {
         if(this.FOnReturnTeamBattleChoose != null)
         {
            this.FOnReturnTeamBattleChoose(this);
         }
         this.FFriendDigests.Clear();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         this.FPoolRoomDigest.Update();
      }
      
      protected function ProcessorLeaveHall() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleHall_LeaveHall);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorEnterHallParametes(param1:ByteArray) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         _loc4_ = int(param1.readUnsignedInt());
         _loc5_ = "";
         param1.clear();
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleHall_EnterPlayerRoom);
         _loc3_ = _loc2_.Data;
         _loc3_.writeByte(this.FTeamBattle.ModeType);
         _loc3_.writeByte(TYPE_ENTER_NORMAL);
         _loc3_.writeUnsignedInt(_loc4_);
         TUtilityString.FlushUTF(_loc3_,_loc5_);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function ProcessorWindowOnClose(param1:Object) : void
      {
         this.ProcessorLeaveHall();
      }
      
      protected function ProcessorOnAgainChoose(param1:Object) : void
      {
         if(this.FOnAgainChoose != null)
         {
            this.FOnAgainChoose(param1);
         }
      }
      
      protected function ProcessorOnReturnHall(param1:Object, param2:uint) : void
      {
         this.FProcessorWindowCreateRoom.Reset();
         this.FProcessorWindowCreateRoom.Visible = false;
         if(param2 == TYPE_EnterCreateRoom_Hall)
         {
            this.FProcessorWindowHall.Update();
            this.FProcessorWindowHall.Visible = true;
         }
         else if(param2 == TYPE_EnterCreateRoom_Room)
         {
            if(this.FOnReturnRoom != null)
            {
               this.FOnReturnRoom(param1);
            }
         }
      }
      
      protected function ProcessorOnCreateRoom(param1:Object) : void
      {
         this.FProcessorWindowHall.Reset();
         this.FProcessorWindowHall.Visible = false;
         this.FProcessorWindowCreateRoom.Update(TYPE_EnterCreateRoom_Hall);
         this.FProcessorWindowCreateRoom.Visible = true;
      }
      
      protected function ProcessorOnWhisper(param1:Object, param2:Object) : void
      {
         if(this.FOnWhisper != null)
         {
            this.FOnWhisper(param1,param2);
         }
      }
      
      public function get Parameter() : ByteArray
      {
         return this.FParameter;
      }
      
      public function set Parameter(param1:ByteArray) : void
      {
         this.FParameter = param1;
      }
      
      public function get OnUpdateTeamBattleChoose() : Function
      {
         return this.FOnUpdateTeamBattleChoose;
      }
      
      public function set OnUpdateTeamBattleChoose(param1:Function) : void
      {
         this.FOnUpdateTeamBattleChoose = param1;
      }
      
      public function get OnReturnTeamBattleChoose() : Function
      {
         return this.FOnReturnTeamBattleChoose;
      }
      
      public function set OnReturnTeamBattleChoose(param1:Function) : void
      {
         this.FOnReturnTeamBattleChoose = param1;
      }
      
      public function get OnReturnRoom() : Function
      {
         return this.FOnReturnRoom;
      }
      
      public function set OnReturnRoom(param1:Function) : void
      {
         this.FOnReturnRoom = param1;
      }
      
      public function get OnAgainChoose() : Function
      {
         return this.FOnAgainChoose;
      }
      
      public function set OnAgainChoose(param1:Function) : void
      {
         this.FOnAgainChoose = param1;
      }
      
      public function get OnWhisper() : Function
      {
         return this.FOnWhisper;
      }
      
      public function set OnWhisper(param1:Function) : void
      {
         this.FOnWhisper = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowHall.Load();
            this.FProcessorWindowCreateRoom.Load();
            return;
         }
         if(this.FParameter != null)
         {
            this.ProcessorEnterHallParametes(this.FParameter);
            this.FParameter = null;
         }
         this.FProcessorWindowHall.Update();
         this.FProcessorWindowHall.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowHall.Reset();
         this.FProcessorWindowHall.Visible = false;
         this.FProcessorWindowCreateRoom.Reset();
         this.FProcessorWindowCreateRoom.Visible = false;
      }
      
      public function Reset() : void
      {
         this.FRoomDigests.Clear();
         this.FFriendDigests.Clear();
      }
      
      public function ResetRoomDigests() : void
      {
         this.FRoomDigests.Clear();
      }
      
      public function LeaveHallReq() : void
      {
         this.ProcessorLeaveHall();
      }
      
      public function Update() : void
      {
         ProcessorResize();
      }
      
      public function EnterCreateRoom() : void
      {
         this.FProcessorWindowCreateRoom.Update(TYPE_EnterCreateRoom_Room);
         this.FProcessorWindowCreateRoom.Visible = true;
      }
   }
}

