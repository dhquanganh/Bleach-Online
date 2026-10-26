package Processors.Game.Lobby.TeamBattle
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.TCharacter;
   import Logics.Purchases.TPurchaseParameters;
   import Logics.Purchases.TPurchaseRequest;
   import Logics.Rooms.Seat.TRoomSeatInfo;
   import Logics.SLogicsCore;
   import Logics.Streamization.Rooms.TUnstreamizerPlayerRoomInfo;
   import Logics.Streamization.TeamBattle.TUnstreamizerTeamBattleModel;
   import Logics.TeamBattle.TTeamBattle;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyPlate;
   import Processors.Game.Lobby.TeamBattle.Hall.TProcessorHall;
   import Processors.Game.Lobby.TeamBattle.HonorShop.TProcessorHonorShop;
   import Processors.Game.Lobby.TeamBattle.Room.TProcessorRoom;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_CHAT;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_INVENTORY;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SHORTCUTS;
   import Resources.Constants.CONST_TEAMBATTLE;
   import flash.external.ExternalInterface;
   import flash.utils.ByteArray;
   
   public class TProcessorTeamBattle extends TProcessorLobbyPlate
   {
      
      protected static const SIZE_WindowTeamBattleChoose_Width:uint = 797;
      
      protected static const SIZE_WindowTeamBattleChoose_Height:uint = 526;
      
      protected static const MODE_TEAMBATTLE_PVE:uint = CONST_TEAMBATTLE.MODE_TEAMBATTLE_PVE;
      
      protected static const MODE_TEAMBATTLE_PVP:uint = CONST_TEAMBATTLE.MODE_TEAMBATTLE_PVP;
      
      public static const CATEGORY_Ornament:uint = CONST_INVENTORY.CATEGORY_Ornament;
      
      protected var FCharacter:TCharacter;
      
      protected var FTeamBattle:TTeamBattle;
      
      protected var FRoomSeatInfo:TRoomSeatInfo;
      
      protected var FUnstreamizerTeamBattleModel:TUnstreamizerTeamBattleModel;
      
      protected var FUnstreamizerPlayerRoomInfo:TUnstreamizerPlayerRoomInfo;
      
      protected var FProcessorWindowTeamBattle:TProcessorWindowTeamBattle;
      
      protected var FProcessorWindowTeamBattleChoose:TProcessorWindowTeamBattleChoose;
      
      protected var FProcessorHonorShop:TProcessorHonorShop;
      
      protected var FProcessorHall:TProcessorHall;
      
      protected var FProcessorRoom:TProcessorRoom;
      
      protected var FParameter:ByteArray;
      
      protected var FBattleBack:Boolean;
      
      protected var FOnEnterTown:Function;
      
      protected var FOnWhisper:Function;
      
      protected var FOnAddFriend:Function;
      
      protected var FOnPurchase:Function;
      
      protected var FOnStartMiniBattleNtf:Function;
      
      protected var FOnTeamBattleMainUISet:Function;
      
      protected var FOnActivatingChannel:Function;
      
      protected var FOnEffectTeamBattlePvp:Function;
      
      public function TProcessorTeamBattle(param1:TUIComponent, param2:TLobbyParameters)
      {
         var _loc3_:TBounds = null;
         super(param1,param2);
         this.FCharacter = SLogicsCore.Character;
         this.FTeamBattle = SLogicsCore.TeamBattle;
         this.FRoomSeatInfo = this.FTeamBattle.RoomSeatInfo;
         this.FProcessorWindowTeamBattle = new TProcessorWindowTeamBattle(this);
         this.FProcessorWindowTeamBattle.Visible = false;
         this.FProcessorWindowTeamBattle.OnClose = this.ProcessorWindowOnClose;
         this.FProcessorWindowTeamBattleChoose = new TProcessorWindowTeamBattleChoose(this);
         this.FProcessorWindowTeamBattleChoose.Visible = false;
         this.FProcessorWindowTeamBattleChoose.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowTeamBattleChoose.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowTeamBattleChoose.OnReturnTown = this.ProcessorOnReturnTown;
         this.FProcessorWindowTeamBattleChoose.OnEnterHallPVE = this.ProcessorOnEnterHallPVE;
         this.FProcessorWindowTeamBattleChoose.OnEnterHallPVP = this.ProcessorOnEnterHallPVP;
         this.FProcessorWindowTeamBattleChoose.OnAutoPVP = this.ProcessorOnAutoPVP;
         this.FProcessorWindowTeamBattleChoose.OnMallHonor = this.ProcessorOnMallHonor;
         _loc3_ = new TBounds();
         _loc3_.Width = SIZE_WindowTeamBattleChoose_Width;
         _loc3_.Height = SIZE_WindowTeamBattleChoose_Height;
         ComponentBoundsCenter(this.FProcessorWindowTeamBattleChoose,_loc3_);
         this.FProcessorHonorShop = new TProcessorHonorShop(this,param2);
         this.FProcessorHonorShop.Visible = false;
         this.FProcessorHonorShop.OnDialogMsg = ProcessorsOnDialogMsg;
         this.FProcessorHonorShop.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorHonorShop.OnPurchase = this.ProcessorsOnPurchase;
         this.FProcessorHonorShop.OnReturnTeamBattleChoose = this.ProcessorHonorShopOnClose;
         this.FProcessorHall = new TProcessorHall(this,param2);
         this.FProcessorHall.Visible = false;
         this.FProcessorHall.OnDialogMsg = ProcessorsOnDialogMsg;
         this.FProcessorHall.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorHall.OnUpdateTeamBattleChoose = this.ProcessorOnUpdateTeamBattleChoose;
         this.FProcessorHall.OnReturnTeamBattleChoose = this.ProcessorOnReturnTeamBattleChoose;
         this.FProcessorHall.OnReturnRoom = this.ProcessorOnReturnRoom;
         this.FProcessorHall.OnAgainChoose = this.ProcessorOnAgainChooseReq;
         this.FProcessorHall.OnWhisper = this.ProcessorOnWhisper;
         this.FProcessorRoom = new TProcessorRoom(this,param2);
         this.FProcessorRoom.Visible = false;
         this.FProcessorRoom.OnDialogMsg = ProcessorsOnDialogMsg;
         this.FProcessorRoom.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorRoom.OnReturnTeamBattleHall = this.ProcessorOnReturnTeamBattleHall;
         this.FProcessorRoom.OnEnterCreateRoom = this.ProcessorOnEnterCreateRoom;
         this.FProcessorRoom.OnAddFriend = this.ProcessorOnAddFriend;
         this.FProcessorRoom.OnStartMiniBattleNtf = this.ProcessorOnStartMiniBattleNtf;
         this.FProcessorRoom.OnTeamBattleMainUISet = this.ProcessorOnTeamBattleMainUISet;
         this.FProcessorRoom.OnActivatingChannel = this.ProcessorOnActivatingChannel;
         this.FBattleBack = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TEAMBATTLE.RESOURCESID_Swf_TeamBattle);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FUnstreamizerTeamBattleModel = new TUnstreamizerTeamBattleModel();
         this.FUnstreamizerPlayerRoomInfo = new TUnstreamizerPlayerRoomInfo();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_TeamBattle_TeamBattlePvpOnOffNtf,this.PacketPerform_SC_TeamBattlePvpOnOffNtf);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_TeamBattle_PVP,this.PacketPerform_SC_Enter_TeamBattle_PVP);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_TeamBattle_PVE,this.PacketPerform_SC_Enter_TeamBattle_PVE);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Enter_PlayerRoom,this.PacketPerform_SC_Enter_PlayerRoom);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mall_HonorShopRet,this.PacketPerform_SC_HonorShopRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mall_HonorShopNotify,this.PacketPerform_SC_HonorShopNotify);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_TEAMBATTLEHALL_Base,CONST_NETWORK.PACKETID_SC_TEAMBATTLEHALL_End,this.PacketPerform_ProcessorTeamBattleHall);
         FPacketRoutines.RegisterRange(CONST_NETWORK.PACKETID_SC_TEAMBATTLEROOM_Base,CONST_NETWORK.PACKETID_SC_TEAMBATTLEROOM_End,this.PacketPerform_ProcessorTeamBattleRoom);
      }
      
      protected function PacketPerform_SC_TeamBattlePvpOnOffNtf(param1:TPacket) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:ByteArray = null;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readBoolean();
         this.FTeamBattle.PvpStatus = _loc2_;
         if(this.FOnEffectTeamBattlePvp != null)
         {
            this.FOnEffectTeamBattlePvp(CONST_SHORTCUTS.POSITION_SecondaryFunctionB,CONST_SHORTCUTS.TYPE_SecondaryFunctionB_TeamBattle,_loc2_);
         }
         this.FProcessorWindowTeamBattleChoose.SetPvpStatus(_loc2_);
      }
      
      protected function PacketPerform_SC_Enter_TeamBattle_PVP(param1:TPacket) : void
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
         this.FUnstreamizerTeamBattleModel.UnstreamizeTeamBattlePVPModels(_loc3_,this.FTeamBattle,this.FCharacter.GetMainLevel());
         this.FProcessorHall.Parameter = this.FParameter;
         this.FProcessorHall.Mount();
         this.FProcessorHall.Visible = true;
         this.FParameter = null;
         if(this.FProcessorWindowTeamBattleChoose.Visible)
         {
            this.FProcessorWindowTeamBattleChoose.Reset();
            this.FProcessorWindowTeamBattleChoose.Visible = false;
         }
      }
      
      protected function PacketPerform_SC_Enter_TeamBattle_PVE(param1:TPacket) : void
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
         this.FProcessorHall.Parameter = this.FParameter;
         this.FProcessorHall.Mount();
         this.FProcessorHall.Visible = true;
         this.FParameter = null;
         if(this.FProcessorWindowTeamBattleChoose.Visible)
         {
            this.FProcessorWindowTeamBattleChoose.Reset();
            this.FProcessorWindowTeamBattleChoose.Visible = false;
         }
      }
      
      protected function PacketPerform_SC_Enter_PlayerRoom(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FRoomSeatInfo.Reset();
         this.FUnstreamizerPlayerRoomInfo.Unstreamize(_loc2_,this.FRoomSeatInfo,null);
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            this.FUnstreamizerPlayerRoomInfo.UnstreamizeTeamBattlePVEMonsterInfo(null,this.FRoomSeatInfo,null);
         }
         this.FTeamBattle.SelectModelID = this.FRoomSeatInfo.ModelID;
         if(this.FProcessorHall.Visible)
         {
            this.FProcessorHall.Unmount();
            this.FProcessorHall.Visible = false;
         }
         if(this.FProcessorWindowTeamBattleChoose.Visible)
         {
            this.FProcessorWindowTeamBattleChoose.Reset();
            this.FProcessorWindowTeamBattleChoose.Visible = false;
         }
         if(!this.FProcessorRoom.Visible)
         {
            this.FProcessorRoom.Mount();
            this.FProcessorRoom.Visible = true;
         }
         this.ProcessorOnTeamBattleMainUISet(this,true,true);
         this.ProcessorOnActivatingChannel(this,CONST_CHAT.CHANNEL_TYPE_Team,true);
      }
      
      protected function PacketPerform_SC_HonorShopRet(param1:TPacket) : void
      {
         this.FProcessorHonorShop.PacketProcess(param1);
      }
      
      protected function PacketPerform_SC_HonorShopNotify(param1:TPacket) : void
      {
         this.FProcessorHonorShop.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorTeamBattleHall(param1:TPacket) : void
      {
         this.FProcessorHall.PacketProcess(param1);
      }
      
      protected function PacketPerform_ProcessorTeamBattleRoom(param1:TPacket) : void
      {
         this.FProcessorRoom.PacketProcess(param1);
      }
      
      protected function ProcessorEnterTeamBattleReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Enter_TeamBattle);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorEnterTeamBattleParametes(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         if(param1 == null || param1.length <= 0)
         {
            return;
         }
         _loc2_ = int(param1.readUnsignedInt());
         if(this.FProcessorHonorShop.Visible)
         {
            this.FProcessorHonorShop.Unmount();
            this.FProcessorHonorShop.Visible = false;
         }
         if(this.FProcessorHall.Visible)
         {
            this.FProcessorHall.Unmount();
            this.FProcessorHall.Visible = false;
         }
         if(this.FProcessorRoom.Visible)
         {
            this.FProcessorRoom.Unmount();
            this.FProcessorRoom.Visible = false;
         }
         if(!this.FProcessorWindowTeamBattleChoose.Visible)
         {
            this.FProcessorWindowTeamBattleChoose.Update();
            this.FProcessorWindowTeamBattleChoose.Visible = true;
         }
         this.FProcessorWindowTeamBattleChoose.InvitedToFastTrack(_loc2_);
      }
      
      protected function ProcessorWindowOnClose(param1:Object) : void
      {
         this.FProcessorHall.LeaveHallReq();
         if(this.FOnEnterTown != null)
         {
            this.FOnEnterTown(param1);
         }
         this.ProcessorOnActivatingChannel(this,CONST_CHAT.CHANNEL_TYPE_Team,false);
         this.FTeamBattle.Reset();
      }
      
      protected function ProcessorOnReturnTown(param1:Object) : void
      {
         this.ProcessorWindowOnClose(this);
      }
      
      protected function ProcessorOnEnterHallPVE(param1:Object) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("openAllianceWar","campaign");
         }
      }
      
      protected function ProcessorOnEnterHallPVP(param1:Object) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("openAllianceWar","battle");
         }
      }
      
      protected function ProcessorOnAutoPVP(param1:Object) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("openAllianceWar","auto");
         }
      }
      
      protected function ProcessorOnMallHonor(param1:Object) : void
      {
         if(ExternalInterface.available)
         {
            ExternalInterface.call("openAllianceWar","shop");
         }
      }
      
      protected function ProcessorsOnPurchase(param1:Object, param2:TPurchaseRequest, param3:TPurchaseParameters) : void
      {
         if(this.FOnPurchase != null)
         {
            this.FOnPurchase(param1,param2,param3);
         }
      }
      
      protected function ProcessorHonorShopOnClose(param1:Object) : void
      {
         this.FProcessorHonorShop.Unmount();
         this.FProcessorHonorShop.Visible = false;
         this.FProcessorWindowTeamBattleChoose.Update();
         this.FProcessorWindowTeamBattleChoose.Visible = true;
      }
      
      protected function ProcessorOnUpdateTeamBattleChoose(param1:Object) : void
      {
         if(this.FProcessorWindowTeamBattleChoose.Visible)
         {
            this.FProcessorWindowTeamBattleChoose.Update();
         }
      }
      
      protected function ProcessorOnReturnTeamBattleChoose(param1:Object) : void
      {
         this.FProcessorHall.ResetRoomDigests();
         this.FProcessorHall.Unmount();
         this.FProcessorHall.Visible = false;
         this.FProcessorWindowTeamBattleChoose.Update();
         this.FProcessorWindowTeamBattleChoose.Visible = true;
      }
      
      protected function ProcessorOnAgainChooseReq(param1:Object) : void
      {
         this.FProcessorHall.Unmount();
         this.FProcessorHall.Visible = false;
         this.FProcessorRoom.BattleModeChangeReq();
         this.FProcessorRoom.Visible = true;
      }
      
      protected function ProcessorOnReturnRoom(param1:Object) : void
      {
         this.FProcessorHall.Visible = false;
         this.FProcessorRoom.BackRoom();
         this.FProcessorRoom.Visible = true;
      }
      
      protected function ProcessorOnWhisper(param1:Object, param2:Object) : void
      {
         if(this.FOnWhisper != null)
         {
            this.FOnWhisper(param1,param2);
         }
      }
      
      protected function ProcessorOnReturnTeamBattleHall(param1:Object) : void
      {
         this.ProcessorOnTeamBattleMainUISet(this,false,true);
         this.FProcessorRoom.Unmount();
         this.FProcessorRoom.Visible = false;
         this.FRoomSeatInfo.Reset();
         if(this.FCharacter.RoleSencePosition == CONST_COMMON.SCENEPOSITION_TEAMBATTLE)
         {
            this.FProcessorHall.Mount();
            this.FProcessorHall.Visible = true;
         }
      }
      
      protected function ProcessorOnEnterCreateRoom(param1:Object) : void
      {
         this.FProcessorRoom.Visible = false;
         this.FProcessorHall.EnterCreateRoom();
         this.FProcessorHall.Visible = true;
      }
      
      protected function ProcessorOnAddFriend(param1:Object, param2:uint, param3:Object) : void
      {
         if(this.FOnAddFriend != null)
         {
            this.FOnAddFriend(param1,param2,param3);
         }
      }
      
      protected function ProcessorOnStartMiniBattleNtf(param1:Object) : void
      {
         if(this.FOnStartMiniBattleNtf != null)
         {
            this.FOnStartMiniBattleNtf(this);
         }
      }
      
      protected function ProcessorOnTeamBattleMainUISet(param1:Object, param2:Boolean, param3:Boolean) : void
      {
         if(this.FOnTeamBattleMainUISet != null)
         {
            this.FOnTeamBattleMainUISet(param1,param2,param3);
         }
      }
      
      protected function ProcessorOnActivatingChannel(param1:Object, param2:uint, param3:Boolean) : void
      {
         if(this.FOnActivatingChannel != null)
         {
            this.FOnActivatingChannel(param1,param2,param3);
         }
      }
      
      public function get BattleBack() : Boolean
      {
         return this.FBattleBack;
      }
      
      public function set BattleBack(param1:Boolean) : void
      {
         this.FBattleBack = param1;
      }
      
      public function get OnEnterTown() : Function
      {
         return this.FOnEnterTown;
      }
      
      public function set OnEnterTown(param1:Function) : void
      {
         this.FOnEnterTown = param1;
      }
      
      public function get OnWhisper() : Function
      {
         return this.FOnWhisper;
      }
      
      public function set OnWhisper(param1:Function) : void
      {
         this.FOnWhisper = param1;
      }
      
      public function get OnAddFriend() : Function
      {
         return this.FOnAddFriend;
      }
      
      public function set OnAddFriend(param1:Function) : void
      {
         this.FOnAddFriend = param1;
      }
      
      public function get OnPurchase() : Function
      {
         return this.FOnPurchase;
      }
      
      public function set OnPurchase(param1:Function) : void
      {
         this.FOnPurchase = param1;
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
      
      public function get OnEffectTeamBattlePvp() : Function
      {
         return this.FOnEffectTeamBattlePvp;
      }
      
      public function set OnEffectTeamBattlePvp(param1:Function) : void
      {
         this.FOnEffectTeamBattlePvp = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowTeamBattle.Load();
            this.FProcessorWindowTeamBattleChoose.Load();
            return;
         }
         if(!this.FBattleBack)
         {
            if(this.FParameter != null)
            {
               this.ProcessorEnterTeamBattleParametes(this.FParameter);
            }
            else
            {
               this.FProcessorWindowTeamBattleChoose.Update();
               this.FProcessorWindowTeamBattleChoose.Visible = true;
            }
         }
         else
         {
            if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE || this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVP && this.FTeamBattle.PvpStatus)
            {
               if(this.FTeamBattle.RoomSeatInfo.Identifier != 0)
               {
                  this.FProcessorRoom.BattleReturn();
               }
               else
               {
                  this.FProcessorHall.Mount();
                  this.FProcessorHall.Visible = true;
               }
            }
            else
            {
               this.ProcessorOnReturnTown(this);
            }
            this.FBattleBack = false;
         }
         this.FProcessorWindowTeamBattle.Visible = true;
         this.FCharacter.RoleSencePosition = CONST_COMMON.SCENEPOSITION_TEAMBATTLE;
      }
      
      override public function Unmount() : void
      {
         this.FProcessorRoom.Unmount();
         this.FProcessorRoom.Visible = false;
         this.FProcessorHall.Unmount();
         this.FProcessorHall.Reset();
         this.FProcessorHall.Visible = false;
         this.FProcessorHonorShop.Unmount();
         this.FProcessorHonorShop.Visible = false;
         this.FProcessorWindowTeamBattleChoose.Reset();
         this.FProcessorWindowTeamBattleChoose.Visible = false;
         this.FProcessorWindowTeamBattle.Reset();
         this.FProcessorWindowTeamBattle.Visible = false;
         this.FParameter = null;
         SUtilityOverLayer.HideTip();
         super.Unmount();
      }
      
      public function EnterTeamBattleReq(param1:ByteArray) : void
      {
         this.FParameter = param1;
         if(this.FCharacter.RoleSencePosition == CONST_COMMON.SCENEPOSITION_TEAMBATTLE)
         {
            this.ProcessorEnterTeamBattleParametes(this.FParameter);
         }
         else
         {
            this.ProcessorEnterTeamBattleReq();
         }
      }
      
      public function TeamBattleChatPopNtf(param1:uint, param2:uint, param3:Object) : void
      {
         this.FProcessorRoom.TeamBattleChatPopNtf(param1,param2,param3);
      }
   }
}

