package Processors.Game.Lobby.SkyTower
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.TCharacter;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.SLogicsCore;
   import Logics.SkyTower.TLayer;
   import Logics.SkyTower.TLayers;
   import Logics.SkyTower.TSkyTower;
   import Logics.SkyTower.TTower;
   import Logics.Streamization.SkyTower.TUnstreamizerSkyTower;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyPlate;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_BATTLE;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_MUSIC;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SIGNAL;
   import Resources.Constants.CONST_SKYTOWER;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TProcessorSkyTower extends TProcessorLobbyPlate
   {
      
      protected static const SIZE_WindowBattleRoom_Width:uint = 853;
      
      protected static const SIZE_WindowBattleRoom_Height:uint = 513;
      
      protected static const SIZE_WindowYeYi_Width:uint = 598;
      
      protected static const SIZE_WindowYeYi_Height:uint = 435;
      
      protected static const SIZE_WindowChest_Width:uint = 501;
      
      protected static const SIZE_WindowChest_Height:uint = 183;
      
      protected static const MODE_SKYTOWER_PVE:uint = CONST_SKYTOWER.MODE_SKYTOWER_PVE;
      
      protected static const MODE_SKYTOWER_PVP:uint = CONST_SKYTOWER.MODE_SKYTOWER_PVP;
      
      public static const TYPE_SKYTOWER_PVP_Challenge:uint = CONST_SKYTOWER.TYPE_SKYTOWER_PVP_Challenge;
      
      public static const TYPE_SKYTOWER_PVP_Occupy:uint = CONST_SKYTOWER.TYPE_SKYTOWER_PVP_Occupy;
      
      protected var FUnstreamizerSkyTower:TUnstreamizerSkyTower;
      
      protected var FCharacter:TCharacter;
      
      protected var FSkyTower:TSkyTower;
      
      protected var FProcessorWindowSkyTower:TProcessorWindowSkyTower;
      
      protected var FProcessorWindowBattleRoom:TProcessorWindowBattleRoom;
      
      protected var FProcessorWindowYeYi:TProcessorWindowYeYi;
      
      protected var FProcessorWindowChest:TProcessorWindowChest;
      
      protected var FBattleBack:Boolean;
      
      protected var FOnEnterTown:Function;
      
      protected var FOnInitBattle:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      public function TProcessorSkyTower(param1:TUIComponent, param2:TLobbyParameters)
      {
         var _loc3_:TBounds = null;
         super(param1,param2);
         this.FUnstreamizerSkyTower = new TUnstreamizerSkyTower();
         this.FCharacter = SLogicsCore.Character;
         this.FSkyTower = SLogicsCore.SkyTower;
         _loc3_ = new TBounds();
         this.FProcessorWindowSkyTower = new TProcessorWindowSkyTower(this);
         this.FProcessorWindowSkyTower.Visible = false;
         this.FProcessorWindowSkyTower.OnClose = this.ProcessorWindowOnClose;
         this.FProcessorWindowSkyTower.OnEnterPve = this.ProcessorOnEnterPve;
         this.FProcessorWindowSkyTower.OnChest = this.ProcessorOnChest;
         this.FProcessorWindowBattleRoom = new TProcessorWindowBattleRoom(this);
         this.FProcessorWindowBattleRoom.Visible = false;
         this.FProcessorWindowBattleRoom.OnClose = this.ProcessorWindowBattleRoomOnClose;
         this.FProcessorWindowBattleRoom.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowBattleRoom.HintOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowBattleRoom.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowBattleRoom.OnOpenYeYi = this.ProcessorOnOpenYeYo;
         _loc3_.Width = SIZE_WindowBattleRoom_Width;
         _loc3_.Height = SIZE_WindowBattleRoom_Height;
         ComponentBoundsCenter(this.FProcessorWindowBattleRoom,_loc3_);
         this.FProcessorWindowYeYi = new TProcessorWindowYeYi(param2.MountPointWindow);
         this.FProcessorWindowYeYi.Visible = false;
         this.FProcessorWindowYeYi.OnClose = this.ProcessorWindowYeYiOnClose;
         _loc3_.Width = SIZE_WindowYeYi_Width;
         _loc3_.Height = SIZE_WindowYeYi_Height;
         ComponentBoundsCenter(this.FProcessorWindowYeYi,_loc3_);
         this.FProcessorWindowChest = new TProcessorWindowChest(param2.MountPointWindow);
         this.FProcessorWindowChest.Visible = false;
         this.FProcessorWindowChest.OnClose = this.ProcessorWindowChestOnClose;
         _loc3_.Width = SIZE_WindowChest_Width;
         _loc3_.Height = SIZE_WindowChest_Height;
         ComponentBoundsCenter(this.FProcessorWindowChest,_loc3_);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_SKYTOWER.RESOURCESID_Swf_SkyTower);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SkyTower_PvpInfo_Ntf,this.PacketPerform_SC_PvpInfo_Ntf);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SkyTower_Challenge_Ret,this.PacketPerform_SC_Challenge_Ret);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SkyTower_BuyChallengeCount_Ret,this.PacketPerform_SC_BuyChallengeCount_Ret);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SkyTower_AutoBattle_Ret,this.PacketPerform_SC_AutoBattle_Ret);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SkyTower_AKeyPve_Ret,this.PacketPerform_SC_AKeyPve_Ret);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SkyTower_PvpReceiving_Ret,this.PacketPerform_SC_PvpReceiving_Ret);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SkyTower_PvpDiary_Ntf,this.PacketPerform_SC_PvpDiary_Ntf);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SkyTower_ChestInfo_Ret,this.PacketPerform_SC_ChestInfo_Ret);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_SkyTower_ReceiveChest_Ret,this.PacketPerform_SC_ReceiveChest_Ret);
      }
      
      protected function PacketPerform_SC_PvpInfo_Ntf(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:uint = 0;
         var _loc8_:TTower = null;
         var _loc9_:TLayer = null;
         var _loc10_:TLayers = null;
         this.FUnstreamizerSkyTower.UnstreamizeSkyTowerPvplayers(param1.Data,this.FSkyTower.Towers,null);
         if(this.FProcessorWindowSkyTower.Visible)
         {
            this.FProcessorWindowSkyTower.UpdateUIPvp();
         }
         if(this.FProcessorWindowBattleRoom.Visible)
         {
            this.FProcessorWindowBattleRoom.UpdateUIPvp();
         }
      }
      
      protected function PacketPerform_SC_Challenge_Ret(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TTower = null;
         var _loc7_:TLayer = null;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         var _loc11_:uint = 0;
         var _loc12_:uint = 0;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc8_ = _loc3_.readUnsignedByte();
         _loc9_ = _loc3_.readUnsignedByte();
         if(this.FSkyTower.LockedTowerID == 0)
         {
            this.FSkyTower.LockedTowerID = this.FSkyTower.SelectTowerID;
            if(this.FProcessorWindowSkyTower.Visible)
            {
               this.FProcessorWindowSkyTower.UpdateUITowers();
            }
         }
         if(_loc8_ == MODE_SKYTOWER_PVP)
         {
            if(_loc9_ == TYPE_SKYTOWER_PVP_Occupy)
            {
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_19));
               if(this.FProcessorWindowSkyTower.Visible)
               {
                  this.FProcessorWindowSkyTower.UpdateUIPvp();
               }
               if(this.FProcessorWindowBattleRoom.Visible)
               {
                  this.FProcessorWindowBattleRoom.UpdateUIPvp();
               }
               return;
            }
            if(_loc9_ == TYPE_SKYTOWER_PVP_Challenge)
            {
               ++this.FSkyTower.PVPCount;
               if(this.FProcessorWindowSkyTower.Visible)
               {
                  this.FProcessorWindowSkyTower.Update();
               }
            }
            _loc12_ = uint(CONST_BATTLE.BattleType_SkyTowerPVP);
         }
         else if(_loc8_ == MODE_SKYTOWER_PVE)
         {
            if(_loc3_.bytesAvailable >= 8)
            {
               _loc6_ = this.FSkyTower.Towers.GetTowerByIdentifier(_loc3_.readUnsignedInt());
               _loc10_ = _loc3_.readUnsignedInt();
               if(_loc6_ == null || _loc6_.Layers.GetLayerByIdentifier(_loc10_) == null)
               {
                  EffectGenerateTextByErrorCode(1);
                  return;
               }
               this.FSkyTower.SelectTowerID = _loc6_.Identifier;
               this.FSkyTower.SelectLayerID = _loc10_;
               this.FSkyTower.LockedTowerID = _loc6_.Identifier;
            }
            _loc12_ = uint(CONST_BATTLE.BattleType_SkyTowerPVE);
         }
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(this,_loc12_,this.FSkyTower.SelectLayerID);
         }
         if(this.FOnInitBattle != null)
         {
            this.FOnInitBattle(this);
         }
      }
      
      protected function PacketPerform_SC_BuyChallengeCount_Ret(param1:TPacket) : void
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
         if(_loc4_ == MODE_SKYTOWER_PVE)
         {
            this.FSkyTower.PVECount = _loc3_.readUnsignedByte();
            this.FSkyTower.PVEBuyCount = _loc3_.readUnsignedByte();
            this.FProcessorWindowBattleRoom.UpdateUIPve();
         }
         else if(_loc4_ == MODE_SKYTOWER_PVP)
         {
            this.FSkyTower.PVPCount = _loc3_.readUnsignedByte();
            this.FSkyTower.PVPBuyCount = _loc3_.readUnsignedByte();
            this.FProcessorWindowBattleRoom.UpdateUIPvp();
         }
      }
      
      protected function PacketPerform_SC_AutoBattle_Ret(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:TTower = null;
         var _loc9_:TLayer = null;
         var _loc10_:TLayers = null;
         var _loc11_:uint = 0;
         var _loc12_:TArticle = null;
         var _loc13_:TBins = null;
         var _loc14_:String = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc8_ = this.FSkyTower.Towers.GetTowerByIdentifier(this.FSkyTower.SelectTowerID);
         _loc10_ = _loc8_.Layers;
         _loc7_ = int(_loc8_.Layers.MaxLayer);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            if(_loc6_ >= _loc8_.Layers.Count)
            {
               break;
            }
            _loc9_ = _loc10_.GetLayerByIndex(_loc6_);
            _loc9_.IsClear = true;
            _loc6_++;
         }
         _loc14_ = "";
         _loc13_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         _loc5_ = int(_loc3_.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_.readUnsignedShort();
            _loc12_ = _loc13_.GetDatebaseByIdentifier(_loc3_.readUnsignedInt()) as TArticle;
            if(_loc4_ != 0)
            {
               _loc14_ += "\n";
            }
            _loc14_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_09),_loc12_.Name,_loc3_.readUnsignedInt());
            _loc4_++;
         }
         EffectGenerateText(_loc14_);
         this.FProcessorWindowBattleRoom.UpdateUIPve();
      }
      
      protected function PacketPerform_SC_AKeyPve_Ret(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TArticle = null;
         var _loc7_:TBins = null;
         var _loc8_:String = null;
         _loc3_ = param1.Data;
         _loc2_ = int(_loc3_.readUnsignedInt());
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FSkyTower.IsAKeyPve = false;
         _loc8_ = "";
         _loc7_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         _loc5_ = int(_loc3_.readUnsignedShort());
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_.readUnsignedShort();
            _loc6_ = _loc7_.GetDatebaseByIdentifier(_loc3_.readUnsignedInt()) as TArticle;
            if(_loc4_ != 0)
            {
               _loc8_ += "\n";
            }
            _loc8_ += TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_SkyTower_09),_loc6_.Name,_loc3_.readUnsignedInt());
            _loc4_++;
         }
         EffectGenerateText(_loc8_);
      }
      
      protected function PacketPerform_SC_PvpReceiving_Ret(param1:TPacket) : void
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
         if(this.FProcessorWindowSkyTower.Visible)
         {
            this.FProcessorWindowSkyTower.UpdateUIPvp();
         }
      }
      
      protected function PacketPerform_SC_PvpDiary_Ntf(param1:TPacket) : void
      {
         this.FUnstreamizerSkyTower.UnstreamizeSkyTowerPvpDiarys(param1.Data,this.FSkyTower.PvpDiarys,null);
         if(this.FProcessorWindowBattleRoom.Visible)
         {
            this.FProcessorWindowBattleRoom.UpdatePvpDiarys();
         }
      }
      
      protected function PacketPerform_SC_ChestInfo_Ret(param1:TPacket) : void
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
         this.FSkyTower.CurIntrgral = _loc3_.readUnsignedShort();
         this.FSkyTower.ReceiveChestID = _loc3_.readUnsignedInt();
         if(this.FProcessorWindowChest.Visible)
         {
            this.FProcessorWindowChest.Update();
         }
         this.FProcessorWindowSkyTower.UpdateChestState();
      }
      
      protected function PacketPerform_SC_ReceiveChest_Ret(param1:TPacket) : void
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
         this.FSkyTower.ReceiveChestID = _loc3_.readUnsignedInt();
         if(this.FProcessorWindowChest.Visible)
         {
            this.FProcessorWindowChest.UpdateChestState();
         }
         this.FProcessorWindowSkyTower.UpdateChestState();
      }
      
      protected function ProcessorEnterSkyTowerReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Enter_SkyTower);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorChestInfoReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_SkyTower_ChestInfo_Req);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorSkyTowerInfo(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            return;
         }
         this.FUnstreamizerSkyTower.Unstreamize(param1,this.FSkyTower,this.FCharacter);
      }
      
      protected function ProcessorWindowOnClose(param1:Object) : void
      {
         if(this.FOnEnterTown != null)
         {
            this.FOnEnterTown(param1);
         }
         this.FSkyTower.SelectMode = MODE_SKYTOWER_PVE;
         this.FProcessorWindowSkyTower.Dispose();
         this.FProcessorWindowBattleRoom.Dispose();
         this.FProcessorWindowYeYi.Dispose();
         this.UnLoad();
      }
      
      protected function ProcessorWindowBattleRoomOnClose(param1:Object) : void
      {
         this.FProcessorWindowBattleRoom.Reset();
      }
      
      protected function ProcessorOnOpenYeYo(param1:Object) : void
      {
         BarrierActuate(this.FProcessorWindowYeYi);
         this.FProcessorWindowYeYi.Update();
         this.FProcessorWindowYeYi.Visible = true;
         this.FProcessorWindowBattleRoom.Visible = false;
      }
      
      protected function ProcessorWindowYeYiOnClose(param1:Object) : void
      {
         BarrierDeactuate(this.FProcessorWindowYeYi);
         this.FProcessorWindowYeYi.Reset();
         this.FProcessorWindowBattleRoom.Visible = true;
      }
      
      protected function ProcessorWindowChestOnClose(param1:Object) : void
      {
         BarrierDeactuate(this.FProcessorWindowChest);
         this.FProcessorWindowChest.Reset();
      }
      
      protected function ProcessorOnEnterPve(param1:Object, param2:TTower) : void
      {
         MusicPlayNext(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SCENE_SkyTower,param2.Identifier,false);
         this.FProcessorWindowBattleRoom.Update();
         this.FProcessorWindowBattleRoom.Visible = true;
      }
      
      protected function ProcessorOnChest(param1:Object) : void
      {
         this.ProcessorChestInfoReq();
         if(!this.FProcessorWindowChest.Visible)
         {
            this.FProcessorWindowChest.Update();
            BarrierActuate(this.FProcessorWindowChest);
            this.FProcessorWindowChest.Visible = true;
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
      
      public function get OnInitBattle() : Function
      {
         return this.FOnInitBattle;
      }
      
      public function set OnInitBattle(param1:Function) : void
      {
         this.FOnInitBattle = param1;
      }
      
      public function get OnSetBattleStatus() : Function
      {
         return this.FOnSetBattleStatus;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(param1 != null)
         {
            this.ProcessorSkyTowerInfo(param1);
         }
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowSkyTower.Load();
            this.FProcessorWindowBattleRoom.Load();
            this.FProcessorWindowYeYi.Load();
            this.FProcessorWindowChest.Load();
            return;
         }
         if(!this.FBattleBack)
         {
            this.ProcessorChestInfoReq();
            this.FProcessorWindowSkyTower.Update();
            this.FProcessorWindowSkyTower.Visible = true;
         }
         else
         {
            this.FBattleBack = false;
            this.FProcessorWindowSkyTower.Update();
            this.FProcessorWindowSkyTower.Visible = true;
            this.FProcessorWindowBattleRoom.Update();
            this.FProcessorWindowBattleRoom.Visible = true;
         }
         this.FCharacter.RoleSencePosition = CONST_COMMON.SCENEPOSITION_SKYTOWER;
      }
      
      override public function Unmount() : void
      {
         this.FProcessorWindowSkyTower.Reset();
         this.FProcessorWindowSkyTower.Visible = false;
         if(this.FProcessorWindowBattleRoom.Visible)
         {
            this.FProcessorWindowBattleRoom.Reset();
            this.FProcessorWindowBattleRoom.Visible = false;
         }
         if(this.FProcessorWindowYeYi.Visible)
         {
            BarrierDeactuate(this.FProcessorWindowYeYi);
            this.FProcessorWindowYeYi.Reset();
            this.FProcessorWindowYeYi.Visible = false;
         }
         if(this.FProcessorWindowChest.Visible)
         {
            BarrierDeactuate(this.FProcessorWindowChest);
            this.FProcessorWindowChest.Reset();
            this.FProcessorWindowChest.Visible = false;
         }
         super.Unmount();
      }
      
      public function EnterSkyTowerReq() : void
      {
         if(this.FCharacter.RoleSencePosition != CONST_COMMON.SCENEPOSITION_SKYTOWER)
         {
            this.ProcessorEnterSkyTowerReq();
            this.FUnstreamizerSkyTower.UnstreamizeSkyTowers(null,this.FSkyTower,this.FCharacter);
         }
      }
      
      public function UpdateBattleResult(param1:Boolean) : void
      {
         this.FProcessorWindowBattleRoom.UpdateBattleResult(param1);
      }
   }
}

