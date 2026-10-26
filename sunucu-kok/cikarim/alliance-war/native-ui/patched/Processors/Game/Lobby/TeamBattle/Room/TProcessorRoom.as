package Processors.Game.Lobby.TeamBattle.Room
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.TResourceRepositoryTexture;
   import Foundation.Resources.Textures.TTexture;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Rooms.Seat.*;
   import Logics.Rooms.Seat.Player.*;
   import Logics.Spaces.LogicsSpace;
   import Logics.Streamization.Characters.*;
   import Logics.Streamization.Rooms.*;
   import Logics.TeamBattle.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.TeamBattle.Room.Components.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Information.*;
   import Rendering.Overlayers.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.utils.*;
   
   use namespace LogicsSpace;
   
   public class TProcessorRoom extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WindowTeamBattleRoom_Width:uint = 1147 - 290;
      
      protected static const SIZE_WindowTeamBattleRoom_Height:uint = 570;
      
      protected static const SIZE_WindowTeamBattleInvite_Width:uint = 316;
      
      protected static const SIZE_WindowTeamBattleInvite_Height:uint = 404;
      
      protected static const TYPE_OPERATING_ADD:uint = CONST_TEAMBATTLE.TYPE_OPERATING_ADD;
      
      protected static const TYPE_OPERATING_UPDATE:uint = CONST_TEAMBATTLE.TYPE_OPERATING_UPDATE;
      
      protected static const TYPE_OPERATING_DELETE:uint = CONST_TEAMBATTLE.TYPE_OPERATING_DELETE;
      
      public static const CAPACITY_PLAYERS:uint = CONST_TEAMBATTLE.CAPACITY_PLAYERS;
      
      protected static const TYPE_OPERATING_READY:uint = CONST_TEAMBATTLE.TYPE_OPERATING_READY;
      
      protected static const TYPE_OPERATING_CANCEL:uint = CONST_TEAMBATTLE.TYPE_OPERATING_CANCEL;
      
      protected static const TYPE_OPERATING_APPLY:uint = CONST_TEAMBATTLE.TYPE_OPERATING_APPLY;
      
      protected static const TYPE_OPERATING_KICK:uint = CONST_TEAMBATTLE.TYPE_OPERATING_KICK;
      
      protected static const TYPE_OPERATING_TRANSFER:uint = CONST_TEAMBATTLE.TYPE_OPERATING_TRANSFER;
      
      protected static const TYPE_OPERATING_LEAVE:uint = CONST_TEAMBATTLE.TYPE_OPERATING_LEAVE;
      
      protected static const TYPE_OPERATING_REFUSALAPPLY:uint = CONST_TEAMBATTLE.TYPE_OPERATING_REFUSALAPPLY;
      
      protected static const TYPE_OPERATING_CHANGEPOSITION:uint = CONST_TEAMBATTLE.TYPE_OPERATING_CHANGEPOSITION;
      
      protected var FUnstreamizerInviteFriendDigests:TUnstreamizerInviteFriendDigests;
      
      protected var FUnstreamizerPlayerRoomInfo:TUnstreamizerPlayerRoomInfo;
      
      protected var FUnstreamizerPlayerRoomDigest:TUnstreamizerPlayerRoomDigest;
      
      protected var FInviteDigests:TFriendDigests;
      
      protected var FCharacter:TCharacter;
      
      protected var FTeamBattle:TTeamBattle;
      
      protected var FRoomSeatInfo:TRoomSeatInfo;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FOverlayerPlayer:TOverlayerPlayer;
      
      protected var FOverlayerMonster:TOverlayerMonster;
      
      protected var FProcessorWindowRoom:TProcessorWindowRoom;
      
      protected var FProcessorWindowInvite:TProcessorWindowInvite;
      
      protected var FProcessorWindowPreparation:TProcessorWindowPreparation;
      
      protected var FInitialization:Boolean;
      
      protected var FOnReturnTeamBattleHall:Function;
      
      protected var FOnEnterCreateRoom:Function;
      
      protected var FOnAddFriend:Function;
      
      protected var FOnStartMiniBattleNtf:Function;
      
      protected var FOnTeamBattleMainUISet:Function;
      
      protected var FOnActivatingChannel:Function;
      
      public function TProcessorRoom(param1:TUIComponent, param2:TLobbyParameters)
      {
         var _loc3_:TBounds = null;
         super(param1,param2);
         this.FUnstreamizerPlayerRoomDigest = new TUnstreamizerPlayerRoomDigest();
         this.FInviteDigests = new TFriendDigests();
         this.FCharacter = SLogicsCore.Character;
         this.FTeamBattle = SLogicsCore.TeamBattle;
         this.FRoomSeatInfo = this.FTeamBattle.RoomSeatInfo;
         this.FProcessorWindowRoom = new TProcessorWindowRoom(param1);
         this.FProcessorWindowRoom.Visible = false;
         this.FProcessorWindowRoom.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowRoom.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowRoom.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowRoom.OnPlayerTipOver = this.UIComponentsPlayerTipOnOver;
         this.FProcessorWindowRoom.OnPlayerTipOut = this.UIComponentsPlayerTipOnOut;
         this.FProcessorWindowRoom.OnOpenInvite = this.ProcessorOnOpenInvite;
         this.FProcessorWindowRoom.OnEnterCreateRoom = this.ProcessorOnEnterCreateRoom;
         this.FProcessorWindowRoom.OnAddFriend = this.ProcessorOnAddFriend;
         _loc3_ = new TBounds();
         _loc3_.Width = SIZE_WindowTeamBattleRoom_Width;
         _loc3_.Height = SIZE_WindowTeamBattleRoom_Height;
         ComponentBoundsCenter(this.FProcessorWindowRoom,_loc3_);
         this.FProcessorWindowInvite = new TProcessorWindowInvite(param1);
         this.FProcessorWindowInvite.Visible = false;
         this.FProcessorWindowInvite.OnClose = this.ProcessorWindowInviteOnClose;
         this.FProcessorWindowInvite.InviteDigests = this.FInviteDigests;
         _loc3_ = new TBounds();
         _loc3_.Width = SIZE_WindowTeamBattleInvite_Width;
         _loc3_.Height = SIZE_WindowTeamBattleInvite_Height;
         ComponentBoundsCenter(this.FProcessorWindowInvite,_loc3_);
         _loc3_ = null;
         this.FProcessorWindowPreparation = new TProcessorWindowPreparation(param1);
         this.FProcessorWindowPreparation.Visible = false;
         this.FProcessorWindowPreparation.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowPreparation.OnClose = this.ProcessorWindowPreparationOnClose;
         this.FProcessorWindowPreparation.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowPreparation.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowPreparation.OnPlayerTipOver = this.UIComponentsPlayerTipOnOver;
         this.FProcessorWindowPreparation.OnPlayerTipOut = this.UIComponentsPlayerTipOnOut;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TEAMBATTLE.RESOURCESID_Swf_TeamBattleRoom);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FUnstreamizerInviteFriendDigests = new TUnstreamizerInviteFriendDigests();
         this.FUnstreamizerPlayerRoomInfo = new TUnstreamizerPlayerRoomInfo();
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         this.FOverlayerPlayer = new TOverlayerPlayer(this.Parent);
         this.FOverlayerPlayer.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_TEAMBATTLE.RESOURCE_Link_SP_PlayerTip) as Sprite;
         this.FOverlayerPlayer.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FOverlayerPlayer.Perform_UIDispatch();
         this.FOverlayerPlayer.Visible = false;
         this.FOverlayerMonster = new TOverlayerMonster(this.Parent);
         this.FOverlayerMonster.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_TEAMBATTLE.RESOURCE_Link_SP_MonsterTip) as Sprite;
         this.FOverlayerMonster.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FOverlayerMonster.Perform_UIDispatch();
         this.FOverlayerMonster.Visible = false;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FInitialization = true;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleRoom_RoomInOperating,this.PerformPacket_ProcessorRoomInOperating);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleRoom_CharInfoChangeNtf,this.PerformPacket_ProcessorCharInfoChangeNtf);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleRoom_PlayerComeInNtf,this.PerformPacket_ProcessorPlayerComeInNtf);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleRoom_BattlePveModeChange,this.PerformPacket_ProcessorBattlePveModeChange);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleRoom_ChangePassword,this.PerformPacket_ProcessorChangePassword);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleRoom_StartGame,this.PerformPacket_ProcessorStartGame);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleRoom_BattleMatching,this.PerformPacket_ProcessorBattleMatching);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleRoom_StartBattlePVE,this.PerformPacket_ProcessorStartBattlePVE);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleRoom_StartBattlePVPNtf,this.PerformPacket_ProcessorStartBattlePVPNtf);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleRoom_FriendListReq,this.PerformPacket_ProcessorFriendListReq);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleRoom_BattlePveModeChangeConfirmation,this.PerformPacket_ProcessorBattlePveModeChangeConfirmation);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleRoom_BattlePveStartWait,this.PerformPacket_ProcessorBattlePveStartWait);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleRoom_BattlePveReturnRoom,this.PerformPacket_ProcessorBattlePveReturnRoom);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattleRoom_BattlePvpStartWait,this.PerformPacket_ProcessorBattlePvpStartWait);
      }
      
      protected function PerformPacket_ProcessorRoomInOperating(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedByte();
         _loc5_ = _loc3_.readUnsignedByte();
         _loc6_ = _loc3_.readUnsignedByte();
         this.ProcessorRoomInOperatingRet(_loc4_,_loc5_,_loc6_);
      }
      
      protected function ProcessorRoomInOperatingRet(param1:uint, param2:uint, param3:uint) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<TPlayerRoomDigest> = null;
         var _loc7_:TPlayerRoomDigest = null;
         var _loc8_:TPlayerRoomDigest = null;
         var _loc9_:TPlayerRoomDigest = null;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         _loc6_ = this.FRoomSeatInfo.PlayerRoomDigests;
         _loc5_ = int(_loc6_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc7_ = _loc6_[_loc4_];
            if(!(_loc7_.Identifier0 == 0 && _loc7_.Identifier1 == 0))
            {
               if(_loc7_.SeatIndex == param2)
               {
                  _loc8_ = _loc7_;
               }
               if(_loc7_.SeatIndex == param3)
               {
                  _loc9_ = _loc7_;
               }
            }
            _loc4_++;
         }
         switch(param1)
         {
            case TYPE_OPERATING_READY:
               if(_loc8_ != null)
               {
                  _loc8_.Ready = true;
               }
               break;
            case TYPE_OPERATING_CANCEL:
               _loc8_.Ready = false;
               break;
            case TYPE_OPERATING_APPLY:
               if(this.FRoomSeatInfo.OneselfIndex == param3)
               {
                  this.FProcessorWindowRoom.OpenApplyConfirmation(_loc8_);
               }
               break;
            case TYPE_OPERATING_KICK:
               if(this.FRoomSeatInfo.OneselfIndex == param3)
               {
                  if(this.FOnReturnTeamBattleHall != null)
                  {
                     this.FOnReturnTeamBattleHall(this);
                  }
                  this.ProcessorOnActivatingChannel(this,CONST_CHAT.CHANNEL_TYPE_Team,false);
               }
               _loc9_.Reset();
               if(this.FProcessorWindowPreparation.Visible)
               {
                  this.FProcessorWindowPreparation.UpdateFriendlyForces();
               }
               break;
            case TYPE_OPERATING_TRANSFER:
               this.FRoomSeatInfo.RoomOwnerIndex = param3;
               break;
            case TYPE_OPERATING_LEAVE:
               if(this.FRoomSeatInfo.PlayerCount == 1)
               {
                  EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_20));
               }
               if(this.FRoomSeatInfo.OneselfIndex == param2)
               {
                  if(this.FOnReturnTeamBattleHall != null)
                  {
                     this.FOnReturnTeamBattleHall(this);
                  }
                  this.ProcessorOnActivatingChannel(this,CONST_CHAT.CHANNEL_TYPE_Team,false);
                  this.FTeamBattle.AutoReady = false;
               }
               if(_loc8_ != null)
               {
                  _loc8_.Reset();
               }
               if(this.FProcessorWindowPreparation.Visible)
               {
                  this.FProcessorWindowPreparation.UpdateFriendlyForces();
               }
               break;
            case TYPE_OPERATING_REFUSALAPPLY:
               break;
            case TYPE_OPERATING_CHANGEPOSITION:
               _loc10_ = this.FRoomSeatInfo.OneselfIndex;
               _loc11_ = this.FRoomSeatInfo.RoomOwnerIndex;
               if(_loc10_ == param2)
               {
                  this.FRoomSeatInfo.OneselfIndex = param3;
               }
               else if(_loc10_ == param3)
               {
                  this.FRoomSeatInfo.OneselfIndex = param2;
               }
               if(_loc11_ == param2)
               {
                  this.FRoomSeatInfo.RoomOwnerIndex = param3;
               }
               else if(_loc11_ == param3)
               {
                  this.FRoomSeatInfo.RoomOwnerIndex = param2;
               }
               if(_loc8_ != null)
               {
                  _loc8_.SeatIndex = param3;
               }
               if(_loc9_ != null)
               {
                  _loc9_.SeatIndex = param2;
               }
               this.FProcessorWindowPreparation.UpdateFriendlyForces();
         }
         if(this.FProcessorWindowRoom.Visible)
         {
            this.FProcessorWindowRoom.UpdateRoomSeatInfo();
         }
      }
      
      protected function PerformPacket_ProcessorCharInfoChangeNtf(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:Vector.<TPlayerRoomDigest> = null;
         var _loc5_:TPlayerRoomDigest = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         _loc2_ = param1.Data;
         _loc4_ = this.FRoomSeatInfo.PlayerRoomDigests;
         _loc2_.readUnsignedShort();
         _loc6_ = _loc2_.position;
         _loc2_.readUnsignedByte();
         _loc7_ = _loc2_.readUnsignedInt();
         _loc8_ = _loc2_.readUnsignedInt();
         _loc3_ = 0;
         while(_loc3_ < CAPACITY_PLAYERS)
         {
            _loc5_ = _loc4_[_loc3_];
            if(_loc5_.Identifier0 == _loc7_ && _loc5_.Identifier1 == _loc8_)
            {
               _loc2_.position = _loc6_;
               this.FUnstreamizerPlayerRoomDigest.Unstreamize(_loc2_,_loc5_,null);
               break;
            }
            _loc3_++;
         }
         if(this.FProcessorWindowRoom.Visible)
         {
            this.FProcessorWindowRoom.UpdateCharInfoChange();
         }
      }
      
      protected function PerformPacket_ProcessorPlayerComeInNtf(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:Vector.<TPlayerRoomDigest> = null;
         var _loc5_:TPlayerRoomDigest = null;
         _loc2_ = param1.Data;
         _loc4_ = this.FRoomSeatInfo.PlayerRoomDigests;
         _loc2_.readUnsignedShort();
         _loc3_ = 0;
         while(_loc3_ < CAPACITY_PLAYERS)
         {
            _loc5_ = _loc4_[_loc3_];
            if(_loc5_.Identifier0 == 0 && _loc5_.Identifier1 == 0)
            {
               this.FUnstreamizerPlayerRoomDigest.Unstreamize(_loc2_,_loc5_,null);
               break;
            }
            _loc3_++;
         }
         if(this.FProcessorWindowRoom.Visible)
         {
            this.FProcessorWindowRoom.UpdateRoomSeatInfo();
         }
      }
      
      protected function PerformPacket_ProcessorBattlePveModeChange(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ByteArray = null;
         var _loc7_:String = null;
         var _loc8_:Vector.<TPlayerRoomDigest> = null;
         var _loc9_:int = 0;
         var _loc10_:TPlayerRoomDigest = null;
         var _loc11_:uint = 0;
         var _loc12_:TLeagueMapPve = null;
         _loc6_ = param1.Data;
         _loc5_ = int(_loc6_.readUnsignedInt());
         if(_loc5_ != 0)
         {
            _loc8_ = this.FRoomSeatInfo.PlayerRoomDigests;
            _loc3_ = int(_loc6_.readUnsignedShort());
            _loc7_ = "";
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               _loc9_ = int(_loc6_.readUnsignedByte());
               _loc4_ = 0;
               while(_loc4_ < CAPACITY_PLAYERS)
               {
                  _loc10_ = _loc8_[_loc4_];
                  if(_loc9_ == _loc10_.SeatIndex && (_loc10_.Identifier0 != 0 || _loc10_.Identifier1 != 0))
                  {
                     if(!TUtilityString.Empty(_loc7_))
                     {
                        _loc7_ += ",";
                     }
                     _loc7_ += _loc10_.Nickname;
                  }
                  _loc4_++;
               }
               _loc2_++;
            }
            _loc11_ = _loc6_.readUnsignedInt();
            this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_18),_loc7_);
            this.FUIWindowConfirmation.Tag = _loc11_;
            this.FUIWindowConfirmation.OnOK = this.UIWindowConfirmationOnOK;
            this.FUIWindowConfirmation.OnCancel = this.UIWindowConfirmationOnCancel;
            this.FUIWindowConfirmation.Visible = true;
            EffectGenerateTextByErrorCode(_loc5_);
            return;
         }
         _loc6_.readUnsignedShort();
         _loc11_ = _loc6_.readUnsignedInt();
         this.FRoomSeatInfo.ModelID = _loc11_;
         this.FTeamBattle.SelectModelID = _loc11_;
         this.FTeamBattle.AgainModelID = 0;
         this.FUnstreamizerPlayerRoomInfo.UnstreamizeTeamBattlePVEMonsterInfo(null,this.FRoomSeatInfo,null);
         this.FProcessorWindowRoom.Update();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_67));
      }
      
      protected function PerformPacket_ProcessorChangePassword(param1:TPacket) : void
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
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_21));
         this.FRoomSeatInfo.Password = TUtilityString.FetchUTF(_loc3_);
         this.FProcessorWindowRoom.UpdatePasswordUI();
      }
      
      protected function PerformPacket_ProcessorStartGame(param1:TPacket) : void
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
         if(this.FOnTeamBattleMainUISet != null)
         {
            this.FOnTeamBattleMainUISet(this,false,true);
         }
         this.UIComponentsPlayerTipOnOut(this,null);
         this.FProcessorWindowRoom.SyncBattleWait();
         this.FProcessorWindowRoom.Visible = false;
         this.FProcessorWindowPreparation.BattleStartWaitReq();
         this.FProcessorWindowPreparation.Update();
         this.FProcessorWindowPreparation.Visible = true;
      }
      
      protected function PerformPacket_ProcessorBattleMatching(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedByte();
         this.FProcessorWindowPreparation.UpdateMatching(_loc4_);
      }
      
      protected function PerformPacket_ProcessorStartBattlePVE(param1:TPacket) : void
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
         this.UIComponentsPlayerTipOnOut(this,null);
         this.FProcessorWindowPreparation.SyncBattleWait();
         if(this.FOnStartMiniBattleNtf != null)
         {
            this.FOnStartMiniBattleNtf(this);
         }
      }
      
      protected function PerformPacket_ProcessorStartBattlePVPNtf(param1:TPacket) : void
      {
         this.UIComponentsPlayerTipOnOut(this,null);
         this.FProcessorWindowPreparation.SyncBattleWait();
         if(this.FOnStartMiniBattleNtf != null)
         {
            this.FOnStartMiniBattleNtf(this);
         }
      }
      
      protected function PerformPacket_ProcessorFriendListReq(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:TFriendDigest = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizerInviteFriendDigests.Unstreamize(_loc3_,this.FInviteDigests,null);
         _loc4_ = this.FInviteDigests.GetDigestByIdentifier(this.FCharacter.Identifier0,this.FCharacter.Identifier1);
         if(_loc4_ != null)
         {
            this.FInviteDigests.DeleteByDigest(_loc4_);
         }
         if(this.FProcessorWindowInvite.Visible)
         {
            this.FProcessorWindowInvite.Update();
         }
      }
      
      protected function PerformPacket_ProcessorBattlePveModeChangeConfirmation(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:uint = 0;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = _loc3_.readUnsignedInt();
         this.FRoomSeatInfo.ModelID = _loc4_;
         this.FTeamBattle.SelectModelID = _loc4_;
         this.FTeamBattle.AgainModelID = 0;
         this.FUnstreamizerPlayerRoomInfo.UnstreamizeTeamBattlePVEMonsterInfo(null,this.FRoomSeatInfo,null);
         this.FProcessorWindowRoom.Update();
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_67));
      }
      
      protected function PerformPacket_ProcessorBattlePveStartWait(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = int(_loc3_.readUnsignedInt());
         this.FProcessorWindowPreparation.UpdateTimeCD(_loc4_);
      }
      
      protected function PerformPacket_ProcessorBattlePveReturnRoom(param1:TPacket) : void
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
         if(this.FOnTeamBattleMainUISet != null)
         {
            this.FOnTeamBattleMainUISet(this,true,true);
         }
         this.UIComponentsPlayerTipOnOut(this,null);
         this.FProcessorWindowPreparation.SyncBattleWait();
         this.FProcessorWindowPreparation.Reset();
         this.FProcessorWindowPreparation.Visible = false;
         this.FProcessorWindowRoom.Update();
         this.FProcessorWindowRoom.Visible = true;
      }
      
      protected function PerformPacket_ProcessorBattlePvpStartWait(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc4_ = int(_loc3_.readUnsignedInt());
         this.FProcessorWindowPreparation.UpdateTimeCD(_loc4_);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.FInitialization)
         {
            return;
         }
         if(this.FOverlayerMonster.Visible)
         {
            this.FOverlayerMonster.Update();
         }
         if(this.FOverlayerPlayer.Visible)
         {
            this.FOverlayerPlayer.Update();
         }
      }
      
      protected function ProcessorWindowInviteOnClose(param1:Object) : void
      {
         this.FProcessorWindowRoom.Enabled = true;
         this.FProcessorWindowInvite.Reset();
         this.FProcessorWindowInvite.Visible = false;
      }
      
      protected function ProcessorWindowPreparationOnClose(param1:Object) : void
      {
         this.FProcessorWindowPreparation.Reset();
         this.FProcessorWindowPreparation.Visible = false;
      }
      
      protected function ProcessorOnOpenInvite(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleRoom_FriendListReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
         this.FProcessorWindowRoom.Enabled = false;
         this.FProcessorWindowInvite.Visible = true;
      }
      
      protected function ProcessorOnEnterCreateRoom(param1:Object) : void
      {
         if(this.FOnEnterCreateRoom != null)
         {
            this.FOnEnterCreateRoom(param1);
         }
         this.FProcessorWindowRoom.Visible = false;
      }
      
      protected function ProcessorOnAddFriend(param1:Object, param2:uint, param3:Object) : void
      {
         if(this.FOnAddFriend != null)
         {
            this.FOnAddFriend(param1,param2,param3);
         }
      }
      
      protected function UIWindowConfirmationOnOK(param1:Object) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleRoom_BattlePveModeChangeConfirmation);
         _loc3_ = _loc2_.Data;
         _loc3_.writeUnsignedInt(this.FUIWindowConfirmation.Tag);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function UIWindowConfirmationOnCancel(param1:Object) : void
      {
         this.FUIWindowConfirmation.Tag = 0;
      }
      
      protected function UIComponentsPlayerTipOnOver(param1:Object, param2:TPlayerRoomDigest) : void
      {
         var _loc3_:TUIComponent = null;
         if(param2.IsMonster)
         {
            this.FOverlayerMonster.Context = param2;
            this.FOverlayerMonster.Render(FUICore.MouseCoordinate);
            this.FOverlayerMonster.Show();
         }
         else
         {
            this.FOverlayerPlayer.Context = param2;
            this.FOverlayerPlayer.Render(FUICore.MouseCoordinate);
            this.FOverlayerPlayer.Show();
         }
      }
      
      protected function UIComponentsPlayerTipOnOut(param1:Object, param2:TPlayerRoomDigest) : void
      {
         var _loc3_:TOverlayer = null;
         if(param2 == null)
         {
            this.FOverlayerMonster.Hide();
            this.FOverlayerPlayer.Hide();
         }
         else if(param2.IsMonster)
         {
            this.FOverlayerMonster.Context = null;
            this.FOverlayerMonster.Hide();
         }
         else
         {
            this.FOverlayerPlayer.Context = null;
            this.FOverlayerPlayer.Hide();
         }
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:uint, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TResourceRepositoryTexture = null;
         var _loc6_:TTexture = null;
         _loc5_ = SResourcesCore.TexturesHeadIcon;
         _loc6_ = _loc5_.GetTextureByIdentifier(param2);
         if(_loc6_ != null)
         {
            param3.Value = _loc6_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc5_.LoadSecondary(param2);
         }
      }
      
      protected function ProcessorOnActivatingChannel(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(this.FOnActivatingChannel != null)
         {
            this.FOnActivatingChannel(param1,param2,param3);
         }
      }
      
      public function get OnReturnTeamBattleHall() : Function
      {
         return this.FOnReturnTeamBattleHall;
      }
      
      public function set OnReturnTeamBattleHall(param1:Function) : void
      {
         this.FOnReturnTeamBattleHall = param1;
      }
      
      public function get OnEnterCreateRoom() : Function
      {
         return this.FOnEnterCreateRoom;
      }
      
      public function set OnEnterCreateRoom(param1:Function) : void
      {
         this.FOnEnterCreateRoom = param1;
      }
      
      public function get OnAddFriend() : Function
      {
         return this.FOnAddFriend;
      }
      
      public function set OnAddFriend(param1:Function) : void
      {
         this.FOnAddFriend = param1;
      }
      
      public function get OnStartMiniBattleNtf() : Function
      {
         return this.FOnStartMiniBattleNtf;
      }
      
      public function set OnStartMiniBattleNtf(param1:Function) : void
      {
         this.FOnStartMiniBattleNtf = param1;
      }
      
      public function get OnTeamBattleMainUISet() : Function
      {
         return this.FOnTeamBattleMainUISet;
      }
      
      public function set OnTeamBattleMainUISet(param1:Function) : void
      {
         this.FOnTeamBattleMainUISet = param1;
      }
      
      public function get OnActivatingChannel() : Function
      {
         return this.FOnActivatingChannel;
      }
      
      public function set OnActivatingChannel(param1:Function) : void
      {
         this.FOnActivatingChannel = param1;
      }
      
      public function RefreshRoom() : void
      {
         if(FIsResourcesLoadCompleted)this.FProcessorWindowRoom.Update();
      }

      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(param1 != null)
         {
         }
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowRoom.Load();
            this.FProcessorWindowPreparation.Load();
            this.FProcessorWindowInvite.Load();
            return;
         }
         this.FProcessorWindowRoom.Update();
         this.FProcessorWindowRoom.Visible = true;
      }
      
      override public function Unmount() : void
      {
         this.FProcessorWindowRoom.Reset();
         this.FProcessorWindowRoom.Visible = false;
         this.FProcessorWindowPreparation.Reset();
         this.FProcessorWindowPreparation.Visible = false;
         this.FProcessorWindowInvite.Reset();
         this.FProcessorWindowInvite.Visible = false;
         if(this.FOverlayerPlayer != null)
         {
            this.FOverlayerPlayer.Context = null;
            this.FOverlayerPlayer.Hide();
         }
         if(this.FOverlayerMonster != null)
         {
            this.FOverlayerMonster.Context = null;
            this.FOverlayerMonster.Hide();
         }
         super.Unmount();
      }
      
      public function BackRoom() : void
      {
         if(this.FOnTeamBattleMainUISet != null)
         {
            this.FOnTeamBattleMainUISet(this,true,true);
         }
         this.FProcessorWindowRoom.Visible = true;
      }
      
      public function BattleReturn() : void
      {
         this.FProcessorWindowRoom.Update();
         this.FProcessorWindowRoom.Visible = true;
         if(this.FOnTeamBattleMainUISet != null)
         {
            this.FOnTeamBattleMainUISet(this,true,true);
         }
      }
      
      public function BattleModeChangeReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleRoom_BattlePveModeChange);
         _loc2_ = _loc1_.Data;
         _loc2_.writeUnsignedInt(this.FTeamBattle.AgainModelID);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
         this.FProcessorWindowRoom.Visible = true;
      }
      
      public function TeamBattleChatPopNtf(param1:uint, param2:uint, param3:Object) : void
      {
         this.FProcessorWindowRoom.TeamBattleChatPopNtf(param1,param2,param3);
      }
   }
}

