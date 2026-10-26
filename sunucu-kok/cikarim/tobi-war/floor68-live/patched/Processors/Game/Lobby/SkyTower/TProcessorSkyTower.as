package Processors.Game.Lobby.SkyTower
{
   import Components.Slots.TUISlot;
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Queries.Textures.TQueryAnimationSequence;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.TCharacter;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.DatebaseVO.VO.TRoleModel;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Logics.SkyTower.TLayer;
   import Logics.SkyTower.TLayers;
   import Logics.SkyTower.TSkyTower;
   import Logics.SkyTower.TTower;
   import Logics.Streamization.SkyTower.TUnstreamizerSkyTower;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyPlate;
   import Processors.Game.Lobby.Components.TUIHero;
   import Processors.Game.Lobby.Jade.TJadeCommon;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_BATTLE;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_LOBBY;
   import Resources.Constants.CONST_MUSIC;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_ROLE;
   import Resources.Constants.CONST_SIGNAL;
   import Resources.Constants.CONST_SKYTOWER;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.DropShadowFilter;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.text.*;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
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
      
      public static var GoldMode:Boolean = false;
      
      protected var GoldRoot:Sprite;
      
      protected var GoldContent:Sprite;
      
      protected var GoldInfo:Object;
      
      protected var GoldPending:Boolean = false;
      
      protected var GoldHero:TUIHero;
      
      protected var GoldDrop:TUISlot;
      
      protected var GoldCrystal:TUISlot;
      
      protected var GoldPrimogem:TUISlot;
      
      protected var GoldPrimogemRoot:MovieClip;
      
      protected var GoldButton:Sprite;
      
      protected var GoldFloorSelected:Number = 0;
      
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
               flash.external.ExternalInterface.addCallback("goldProbeFight",function():void{GoldChallenge(null);});
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
         FPacketRoutines.Register(18352766,this.GoldStateRet);
         FPacketRoutines.Register(18352767,this.GoldFightRet);
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
      
      protected function GoldText(root:Sprite, value:String, x:Number, y:Number, width:Number = 300, size:int = 16, color:uint = 16769152) : TextField
      {
         var t:TextField = new TextField();
         t.defaultTextFormat = new TextFormat("Arial",size,color,true);
         t.filters = [new DropShadowFilter(1,90,0,0.7,2,2,1)];
         t.text = value;
         t.x = x;
         t.y = y;
         t.width = width;
         t.height = 38;
         t.multiline = true;
         t.wordWrap = true;
         t.mouseEnabled = false;
         root.addChild(t);
         return t;
      }
      
      protected function GoldBox(root:Sprite, x:Number, y:Number, w:Number, h:Number, color:uint) : void
      {
         var matrix:Matrix = new Matrix();
         matrix.createGradientBox(w,h,Math.PI / 2,x,y);
         root.graphics.lineStyle(1,11040821,0.9);
         root.graphics.beginGradientFill(GradientType.LINEAR,[color,724240],[1,1],[0,255],matrix);
         root.graphics.drawRoundRect(x,y,w,h,8,8);
         root.graphics.endFill();
         root.graphics.lineStyle(1,16769184,0.12);
         root.graphics.moveTo(x + 8,y + 2);
         root.graphics.lineTo(x + w - 8,y + 2);
      }
      
      protected function BuildGoldPanel() : void
      {
         if(this.GoldRoot != null)
         {
            return;
         }
         this.GoldRoot = new Sprite();
         addChild(this.GoldRoot);
         this.GoldRoot.x = 190;
         this.GoldRoot.y = 50;
         var art:Sprite = TUtilityReflection.CreateDisplayObjectInstance(CONST_SKYTOWER.RESOURCE_ClassName_SP_BattleRoom) as Sprite;
         if(art != null)
         {
            this.GoldRoot.addChild(art);
            var j:int = 0;
            while(j < art.numChildren)
            {
               art.getChildAt(j).visible = false;
               j++;
            }
            if(art[CONST_SKYTOWER.RESOURCE_Link_SP_Background] != null)
            {
               art[CONST_SKYTOWER.RESOURCE_Link_SP_Background].visible = true;
            }
            art.mouseChildren = false;
            art.mouseEnabled = false;
         }
         this.GoldBox(this.GoldRoot,0,0,853,38,5376256);
         this.GoldText(this.GoldRoot,"Tower of Gold",320,4,300,23);
         var close:Sprite = new Sprite();
         this.GoldBox(close,0,0,32,28,9048576);
         this.GoldText(close,"X",7,1,30,19);
         close.x = 812;
         close.y = 4;
         close.buttonMode = true;
         close.addEventListener(MouseEvent.CLICK,this.GoldClose,false,0,true);
         this.GoldRoot.addChild(close);
         this.GoldContent = new Sprite();
         this.GoldRoot.addChild(this.GoldContent);
         this.GoldHero = new TUIHero(this);
         this.GoldHero.OnQuerySequenceContext = this.GoldHeroQuery;
         this.GoldHero.SequenceDefaultRole = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCEID_Textures_DefaultRole,0);
         this.GoldHero.x = 320;
         this.GoldHero.y = 155;
         this.GoldHero.scaleX = this.GoldHero.scaleY = 0.95;
         this.GoldHero.mouseEnabled = false;
         this.GoldHero.mouseChildren = false;
         this.GoldRoot.addChild(this.GoldHero);
         var slot:MovieClip = new MovieClip();
         slot.x = 38;
         slot.y = 366;
         this.GoldBox(slot,0,0,48,48,6705192);
         slot[TUISlot.RESOURCE_Link_MC_Bmp_Icon] = new Sprite();
         slot.addChild(slot[TUISlot.RESOURCE_Link_MC_Bmp_Icon]);
         slot[TUISlot.RESOURCE_Link_MC_Bmp_IconHighLight] = null;
         slot[TUISlot.RESOURCE_Link_TF_Subscript] = null;
         slot[TUISlot.RESOURCE_Link_TF_EquipLevel] = null;
         slot[TUISlot.RESOURCE_Link_MC_SelectedBox] = null;
         this.GoldRoot.addChild(slot);
         this.GoldDrop = new TUISlot(this);
         this.GoldDrop.Resource = slot;
         this.GoldDrop.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.GoldDrop.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         TJadeCommon.InitSlot(this.GoldDrop);
         this.GoldDrop.Init();
         var crystal:MovieClip = new MovieClip();
         crystal.x = 229;
         crystal.y = 366;
         this.GoldBox(crystal,0,0,48,48,6705192);
         crystal[TUISlot.RESOURCE_Link_MC_Bmp_Icon] = new Sprite();
         crystal.addChild(crystal[TUISlot.RESOURCE_Link_MC_Bmp_Icon]);
         crystal[TUISlot.RESOURCE_Link_MC_Bmp_IconHighLight] = null;
         crystal[TUISlot.RESOURCE_Link_TF_Subscript] = null;
         crystal[TUISlot.RESOURCE_Link_TF_EquipLevel] = null;
         crystal[TUISlot.RESOURCE_Link_MC_SelectedBox] = null;
         this.GoldRoot.addChild(crystal);
         this.GoldCrystal = new TUISlot(this);
         this.GoldCrystal.Resource = crystal;
         this.GoldCrystal.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.GoldCrystal.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         TJadeCommon.InitSlot(this.GoldCrystal);
         this.GoldCrystal.Init();
         var primogem:MovieClip = new MovieClip();
         primogem.x = 420;
         primogem.y = 366;
         this.GoldBox(primogem,0,0,48,48,6705192);
         primogem[TUISlot.RESOURCE_Link_MC_Bmp_Icon] = new Sprite();
         primogem.addChild(primogem[TUISlot.RESOURCE_Link_MC_Bmp_Icon]);
         primogem[TUISlot.RESOURCE_Link_MC_Bmp_IconHighLight] = null;
         primogem[TUISlot.RESOURCE_Link_TF_Subscript] = null;
         primogem[TUISlot.RESOURCE_Link_TF_EquipLevel] = null;
         primogem[TUISlot.RESOURCE_Link_MC_SelectedBox] = null;
         this.GoldRoot.addChild(primogem);
         this.GoldPrimogem = new TUISlot(this);
         this.GoldPrimogem.Resource = primogem;
         this.GoldPrimogem.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.GoldPrimogem.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         TJadeCommon.InitSlot(this.GoldPrimogem);
         this.GoldPrimogem.Init();
         this.GoldPrimogemRoot = primogem;
         this.GoldButton = new Sprite();
         this.GoldBox(this.GoldButton,0,0,144,42,12010256);
         this.GoldText(this.GoldButton,"Challenge",22,7,124,18);
         this.GoldButton.x = 467;
         this.GoldButton.y = 445;
         this.GoldButton.buttonMode = true;
         this.GoldButton.mouseChildren = false;
         this.GoldButton.addEventListener(MouseEvent.CLICK,this.GoldChallenge,false,0,true);
         this.GoldRoot.addChild(this.GoldButton);
         this.GoldRoot.addEventListener(Event.ENTER_FRAME,this.GoldTick,false,0,true);
      }
      
      protected function GoldTick(e:Event) : void
      {
         if(this.GoldRoot.visible)
         {
            this.GoldHero.Update();
            this.GoldDrop.Update();
            this.GoldCrystal.Update();
            this.GoldPrimogem.Update();
            var bounds:Rectangle = this.GoldHero.getBounds(this.GoldRoot);
            if(bounds.width > 0 && bounds.height > 0)
            {
               this.GoldHero.x += 325 - (bounds.x + bounds.width / 2);
               this.GoldHero.y += 328 - bounds.bottom;
            }
         }
      }
      
      protected function GoldHeroQuery(sender:Object, context:Object, query:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var role:TRoleModel = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_RoleModel,uint(context)) as TRoleModel;
         if(role == null)
         {
            return;
         }
         var id:uint = CONST_ROLE.GetModelIDByIndex(role.Model,CONST_ROLE.ROLE_SEQUENCEINDEX_Showcase);
         var texture:Object = SResourcesCore.TexturesModel.GetTextureByIdentifier(id);
         if(texture != null)
         {
            query.Value = texture.GetAnimationSequenceByIndex(0);
         }
         else
         {
            SResourcesCore.TexturesModel.LoadSecondary(id);
         }
      }
      
      protected function GoldClose(e:MouseEvent) : void
      {
         if(this.FOnEnterTown != null)
         {
            this.FOnEnterTown(this);
         }
      }
      
      protected function RequestGoldState() : void
      {
         var p:TPacket = SNetworkCore.PacketAcquire(25293056);
         SNetworkCore.Transceiver.PacketTransmit(p);
      }
      
      protected function GoldStateRet(p:TPacket) : void
      {
         this.GoldInfo = Json.decode(p.Data.readUTF());
         if(this.GoldRoot == null || !GoldMode)
         {
            return;
         }
         this.RenderGoldPanel();
      }
      
      protected function GoldRewardAmount(item:Object, code:uint, type:int = 1) : Number
      {
         if(item == null || item.rewards == null)
         {
            return 0;
         }
         for each(var reward:Object in item.rewards)
         {
            if(uint(reward.code) == code && int(reward.type) == type)
            {
               return Number(reward.amount);
            }
         }
         return 0;
      }
      
      protected function RenderGoldPanel() : void
      {
         while(this.GoldContent.numChildren > 0)
         {
            this.GoldContent.removeChildAt(0);
         }
         this.GoldContent.graphics.clear();
         this.GoldBox(this.GoldContent,18,50,610,370,2178112);
         this.GoldContent.graphics.lineStyle(1,14265953,0.18);
         this.GoldContent.graphics.drawEllipse(221,290,208,32);
         this.GoldContent.graphics.drawEllipse(238,295,174,22);
         this.GoldBox(this.GoldContent,28,338,590,86,2629659);
         this.GoldBox(this.GoldContent,646,50,188,440,3483415);
         this.GoldText(this.GoldContent,"ASCENT",665,58,160,12,11309418);
         this.GoldBox(this.GoldContent,32,64,118,36,7492385);
         this.GoldText(this.GoldContent,"FLOOR " + this.GoldInfo.floor,43,71,110,18);
         var current:Object = this.GoldInfo.preview[0];
         this.GoldText(this.GoldContent,String(current.name),175,68,430,21,16773326);
         this.GoldText(this.GoldContent,"Level " + current.level + "   /   " + current.count + " opponent(s)",176,101,430,13,12175304);
         this.GoldText(this.GoldContent,"ATK: " + String(current.atk),176,124,430,13,16756354).height = 20;
         this.GoldHero.Context = uint(current.heroId);
         this.GoldText(this.GoldContent,"FLOOR REWARDS",38,342,360,11,11179382);
         var stoneAmount:Number = this.GoldRewardAmount(current,14100698);
         var crystalAmount:Number = this.GoldRewardAmount(current,14100779);
         var primogemAmount:Number = this.GoldRewardAmount(current,14900001);
         var inv:TInventories = new TInventories();
         SToolReward.GetInventoryByIDAmount(14100698,stoneAmount,inv);
         this.GoldDrop.Context = inv.GetInventoryByIndex(0);
         this.GoldText(this.GoldContent,"x" + stoneAmount + "\nReincarnation Stone",94,366,126,12,15913363);
         var crystals:TInventories = new TInventories();
         SToolReward.GetInventoryByIDAmount(14100779,crystalAmount,crystals);
         this.GoldCrystal.Context = crystals.GetInventoryByIndex(0);
         this.GoldText(this.GoldContent,"x" + crystalAmount + "\nBlood War Crystal",285,366,125,12,15913363);
         this.GoldPrimogemRoot.visible = primogemAmount > 0;
         if(primogemAmount > 0)
         {
            var primogems:TInventories = new TInventories();
            SToolReward.GetInventoryByIDAmount(14900001,primogemAmount,primogems);
            this.GoldPrimogem.Context = primogems.GetInventoryByIndex(0);
            this.GoldText(this.GoldContent,"x" + primogemAmount + "\nNguyên thạch",476,366,138,13,14270719);
         }
         else
         {
            this.GoldText(this.GoldContent,"Nguyên thạch:\nTừ tầng 100",426,366,180,13,11115182);
         }
         this.GoldText(this.GoldContent,this.GoldRewardAmount(current,1,0) + " Gold",450,342,164,13,16766822).height = 20;
         var i:int = 0;
         while(i < 5)
         {
            var item:Object = this.GoldInfo.preview[i];
            this.GoldBox(this.GoldContent,657,84 + i * 77,166,68,i == 0 ? 9989164 : 3682347);
            this.GoldText(this.GoldContent,(i == 0 ? "CURRENT  " : "FLOOR  ") + item.floor,669,89 + i * 77,149,16);
            this.GoldText(this.GoldContent,String(item.name),669,111 + i * 77,147,11,13026231).height = 18;
            var upcoming:Number = this.GoldRewardAmount(item,14900001);
            this.GoldText(this.GoldContent,upcoming > 0 ? "Nguyên thạch x" + upcoming : "Nguyên thạch: tầng 100",669,132 + i * 77,147,10,14270719).height = 17;
            i++;
         }
         var record:Object = this.GoldInfo.lastDefeat;
         this.GoldText(this.GoldContent,"First Defeat  /  " + (record != null ? record.first.name + " (Floor " + this.GoldInfo.recordsFloor + ")" : "--"),32,440,420,13,12499114);
         this.GoldText(this.GoldContent,"Best Defeat  /  " + (record != null ? record.best.name + " / " + record.best.turns + " turns" : "--"),32,469,420,13,12499114);
         if(record != null)
         {
            var first:Sprite = new Sprite();
            first.graphics.beginFill(0,0);
            first.graphics.drawRect(0,0,435,24);
            first.graphics.endFill();
            first.x = 32;
            first.y = 440;
            first.name = "first";
            first.buttonMode = true;
            first.addEventListener(MouseEvent.CLICK,this.GoldReplay,false,0,true);
            this.GoldContent.addChild(first);
            var best:Sprite = new Sprite();
            best.graphics.beginFill(0,0);
            best.graphics.drawRect(0,0,420,24);
            best.graphics.endFill();
            best.x = 32;
            best.y = 469;
            best.name = "best";
            best.buttonMode = true;
            best.addEventListener(MouseEvent.CLICK,this.GoldReplay,false,0,true);
            this.GoldContent.addChild(best);
         }
         this.GoldButton.alpha = this.GoldPending ? 0.5 : 1;
      }
      
      protected function GoldChallenge(e:MouseEvent) : void
      {
         if(this.GoldPending || this.GoldInfo == null)
         {
            return;
         }
         this.GoldPending = true;
         this.GoldButton.alpha = 0.5;
         var p:TPacket = SNetworkCore.PacketAcquire(25293057);
         p.Data.writeUTF("{\"floor\":68}");
         SNetworkCore.Transceiver.PacketTransmit(p);
      }
      
      protected function GoldReplay(e:MouseEvent) : void
      {
         if(this.GoldPending || this.GoldInfo == null || this.GoldInfo.lastDefeat == null)
         {
            return;
         }
         this.GoldPending = true;
         var p:TPacket = SNetworkCore.PacketAcquire(25293057);
         p.Data.writeUTF(Json.encode({
            "floor":Number(this.GoldInfo.recordsFloor),
            "mode":String(e.currentTarget.name)
         }));
         SNetworkCore.Transceiver.PacketTransmit(p);
      }
      
      protected function GoldFightRet(p:TPacket) : void
      {
         var error:int = p.Data.readInt();
         this.GoldPending = false;
         if(error != 0)
         {
            if(p.Data.bytesAvailable > 0)
            {
               EffectGenerateText(p.Data.readUTF());
            }
            else
            {
               EffectGenerateTextByErrorCode(error);
            }
            this.RequestGoldState();
            return;
         }
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_SkyTowerPVE,15910001);
         }
         if(this.FOnInitBattle != null)
         {
            this.FOnInitBattle(this);
         }
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
         if(GoldMode)
         {
            this.FProcessorWindowSkyTower.Visible = false;
            this.FProcessorWindowBattleRoom.Visible = false;
            this.BuildGoldPanel();
            this.GoldRoot.visible = true;
            this.FBattleBack = false;
            this.GoldPending = false;
            this.RequestGoldState();
            this.FCharacter.RoleSencePosition = CONST_COMMON.SCENEPOSITION_SKYTOWER;
            return;
         }
         if(this.GoldRoot != null)
         {
            this.GoldRoot.visible = false;
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
         if(this.GoldRoot != null)
         {
            this.GoldRoot.visible = false;
         }
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
         if(GoldMode)
         {
            this.ProcessorEnterSkyTowerReq();
            this.FUnstreamizerSkyTower.UnstreamizeSkyTowers(null,this.FSkyTower,this.FCharacter);
            return;
         }
         if(this.FCharacter.RoleSencePosition != CONST_COMMON.SCENEPOSITION_SKYTOWER)
         {
            this.ProcessorEnterSkyTowerReq();
            this.FUnstreamizerSkyTower.UnstreamizeSkyTowers(null,this.FSkyTower,this.FCharacter);
         }
      }
      
      public function UpdateBattleResult(param1:Boolean) : void
      {
         if(GoldMode)
         {
            this.GoldPending = false;
            this.FBattleBack = false;
            return;
         }
         this.FProcessorWindowBattleRoom.UpdateBattleResult(param1);
      }
   }
}

