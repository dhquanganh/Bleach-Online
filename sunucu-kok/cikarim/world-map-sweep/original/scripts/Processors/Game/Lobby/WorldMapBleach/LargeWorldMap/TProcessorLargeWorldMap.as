package Processors.Game.Lobby.WorldMapBleach.LargeWorldMap
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.Bins.TBins;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Campaign.TCampaign;
   import Logics.Campaign.TMonster;
   import Logics.Campaign.TNodal;
   import Logics.Campaign.TNodalAutoMonsterInfo;
   import Logics.Campaign.TPoolCampaign;
   import Logics.Characters.TCharacter;
   import Logics.DatebaseVO.VO.TBlockPoint;
   import Logics.DatebaseVO.VO.TCity;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.DatebaseVO.VO.TEnemy;
   import Logics.DatebaseVO.VO.TEnemyArmy;
   import Logics.Items.TPoolItem;
   import Logics.SLogicsCore;
   import Logics.Streamization.Campaign.TUnstreamizerNodal;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.WorldMapBleach.InstanceAutoBattle.TWindowInstanceAutoBattle;
   import Processors.Game.Lobby.WorldMapBleach.MonsterMap.TProcessorWindowPassInstance;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_BATTLE;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_WORLDMAP;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class TProcessorLargeWorldMap extends TProcessorLobbyWindows
   {
      
      public static const SIZE_WindowSelectWorldMap_Width:uint = 574;
      
      public static const SIZE_WindowSelectWorldMap_Height:uint = 320;
      
      public static const SIZE_WindowWorldMap_Width:uint = 964;
      
      public static const SIZE_WindowWorldMap_Height:uint = 584;
      
      public static const SIZE_WindowInstanceChoose_Width:uint = 608;
      
      public static const SIZE_WindowInstanceChoose_Height:uint = 520;
      
      public static const SIZE_WindowInstanceAutoBattle_Width:uint = 494;
      
      public static const SIZE_WindowInstanceAutoBattle_Height:uint = 338;
      
      public static const SIZE_WindowPassInstance_Width:uint = 1250;
      
      public static const SIZE_WindowPassInstance_Height:uint = 650;
      
      protected var FProcessorWindowLargeWorldMap:TProcessorWindowLargeWorldMap;
      
      protected var FProcessorWindowSelectWorldMap:TProcessorWindowSelectWorldMap;
      
      protected var FProcessorWindowInstanceChoose:TProcessorWindowInstanceChoose;
      
      protected var FWindowInstanceAutoBattle:TWindowInstanceAutoBattle;
      
      protected var FProcessorWindowPassInstance:TProcessorWindowPassInstance;
      
      protected var FBoundsLargeWorldMap:TBounds;
      
      protected var FBoundsSelectWorldMap:TBounds;
      
      protected var FBoundsInstanceChoose:TBounds;
      
      protected var FBoundsInstanceAutoBattle:TBounds;
      
      protected var FBoundsPassInstance:TBounds;
      
      protected var FIsInit:Boolean;
      
      protected var FIsQuest:Boolean;
      
      protected var FIsInstanceAutoBattle:Boolean;
      
      protected var FNodalModel:TNodal;
      
      protected var UnstreamizerNodal:TUnstreamizerNodal;
      
      protected var FNodalAutoMonsterInfo:TNodalAutoMonsterInfo;
      
      protected var FTargetCityId:uint;
      
      protected var FTargetNodalId:uint;
      
      protected var FTimerID:uint;
      
      protected var FMapType:uint;
      
      protected var FPoolCampaign:TPoolCampaign;
      
      protected var FPoolItem:TPoolItem;
      
      protected var FCharacter:TCharacter;
      
      protected var FAutoByteArray:ByteArray;
      
      protected var FCityBins:TBins;
      
      protected var FSingleBins:TBins;
      
      protected var FSinglePointPath:TBins;
      
      protected var FBlockPointBins:TBins;
      
      protected var FEnemyArmyBins:TBins;
      
      protected var FEnemyBins:TBins;
      
      protected var FAutoCityID:int;
      
      protected var FAutoMissionID:int;
      
      protected var FAutoCount:int;
      
      protected var FAutoStartTime:int;
      
      protected var FAutoIsFast:Boolean;
      
      protected var FWaitToOpen:Boolean;
      
      protected var FParameter1:Boolean;
      
      protected var FParameter2:uint;
      
      protected var FParameter3:int;
      
      protected var FOnBarrierEnter:Function;
      
      protected var FOnShortcutHyperlinks:Function;
      
      protected var FOnBarrierAutoBattleInfo:Function;
      
      protected var FOnBarrierContinueAutoInfo:Function;
      
      protected var FOnInstanceAutoBattle:Function;
      
      public function TProcessorLargeWorldMap(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FNodalModel = SLogicsCore.Nodal;
         this.UnstreamizerNodal = new TUnstreamizerNodal();
         this.FPoolCampaign = SLogicsCore.PoolCampaign;
         this.FPoolItem = SLogicsCore.PoolItem;
         this.FCharacter = SLogicsCore.Character;
         this.FProcessorWindowLargeWorldMap = new TProcessorWindowLargeWorldMap(this);
         this.FProcessorWindowLargeWorldMap.OnClose = this.ProcessorOnEnterHome;
         this.FProcessorWindowLargeWorldMap.OnBarrierEnter = this.ProcessorOnEnterMonsterMap;
         this.FProcessorWindowLargeWorldMap.OnUpdataNodalModel = this.ProcessorOnUpdataNodalModel;
         this.FProcessorWindowLargeWorldMap.OnReturnHomeScene = this.ProcessorOnEnterHome;
         this.FProcessorWindowLargeWorldMap.OnEffectText = EffectGenerateText;
         this.FProcessorWindowSelectWorldMap = new TProcessorWindowSelectWorldMap(this);
         this.FProcessorWindowSelectWorldMap.OnClose = this.ProcessorOnEnterHome;
         this.FProcessorWindowSelectWorldMap.OnWorldMapEnter = this.ProcessorOnEnterWorldMap;
         this.FProcessorWindowSelectWorldMap.OnReturnHome = this.ProcessorOnEnterHome;
         this.FProcessorWindowInstanceChoose = new TProcessorWindowInstanceChoose(this,this.FNodalModel);
         this.FProcessorWindowInstanceChoose.SlotsOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowInstanceChoose.SlotsOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowInstanceChoose.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowInstanceChoose.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowInstanceChoose.OnHelpTipsOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowInstanceChoose.OnHelpTipsOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowInstanceChoose.OnEffectText = EffectGenerateText;
         this.FProcessorWindowInstanceChoose.OnEnterBattle = this.ProcessorOnInstanceEnterMonster;
         this.FProcessorWindowInstanceChoose.OnEnterAutoBattle = this.ProcessorOnInstanceAutoBattle;
         this.FWindowInstanceAutoBattle = new TWindowInstanceAutoBattle(this);
         this.FWindowInstanceAutoBattle.OnEffectText = EffectGenerateText;
         this.FWindowInstanceAutoBattle.OnPassInstance = this.ProcessorOnAutoBattlePassInstance;
         this.FWindowInstanceAutoBattle.OnClose = this.AutoBattleOnClose;
         this.FProcessorWindowPassInstance = new TProcessorWindowPassInstance(this,false);
         this.FProcessorWindowPassInstance.OnEffectText = EffectGenerateText;
         this.FProcessorWindowPassInstance.OnOverLayOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowPassInstance.OnOverLayOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FBoundsLargeWorldMap = new TBounds();
         this.FBoundsLargeWorldMap.Width = SIZE_WindowWorldMap_Width;
         this.FBoundsLargeWorldMap.Height = SIZE_WindowWorldMap_Height;
         ComponentBoundsCenter(this.FProcessorWindowLargeWorldMap,this.FBoundsLargeWorldMap);
         this.FBoundsLargeWorldMap = null;
         this.FBoundsSelectWorldMap = new TBounds();
         this.FBoundsSelectWorldMap.Width = SIZE_WindowSelectWorldMap_Width;
         this.FBoundsSelectWorldMap.Height = SIZE_WindowSelectWorldMap_Height;
         ComponentBoundsCenter(this.FProcessorWindowSelectWorldMap,this.FBoundsSelectWorldMap);
         this.FBoundsSelectWorldMap = null;
         this.FBoundsInstanceChoose = new TBounds();
         this.FBoundsInstanceChoose.Width = SIZE_WindowInstanceChoose_Width;
         this.FBoundsInstanceChoose.Height = SIZE_WindowInstanceChoose_Height;
         ComponentBoundsCenter(this.FProcessorWindowInstanceChoose,this.FBoundsInstanceChoose);
         this.FBoundsInstanceChoose = null;
         this.FBoundsInstanceAutoBattle = new TBounds();
         this.FBoundsInstanceAutoBattle.Width = SIZE_WindowInstanceAutoBattle_Width;
         this.FBoundsInstanceAutoBattle.Height = SIZE_WindowInstanceAutoBattle_Height;
         ComponentBoundsCenter(this.FWindowInstanceAutoBattle,this.FBoundsInstanceAutoBattle);
         this.FBoundsInstanceAutoBattle = null;
         this.FBoundsPassInstance = new TBounds();
         this.FBoundsPassInstance.Width = SIZE_WindowPassInstance_Width;
         this.FBoundsPassInstance.Height = SIZE_WindowPassInstance_Height;
         ComponentBoundsCenter(this.FProcessorWindowPassInstance,this.FBoundsPassInstance);
         this.FBoundsPassInstance = null;
         this.FNodalAutoMonsterInfo = new TNodalAutoMonsterInfo();
         this.FIsQuest = false;
         this.FIsInstanceAutoBattle = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_WORLDMAP.RESOURCESID_WorldMap);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIWait() : void
      {
         if(SResourcesCore.LoadingPrimary)
         {
            return;
         }
         this.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FCityBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_City);
         this.FSingleBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Single);
         this.FSinglePointPath = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SinglePointPath);
         this.FBlockPointBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BlockPoint);
         this.FEnemyArmyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_EnemyArmy);
         this.FEnemyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Enemy);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FProcessorWindowInstanceChoose != null && this.FProcessorWindowInstanceChoose.Visible == true)
         {
            this.FProcessorWindowInstanceChoose.UpdataBitmap();
         }
         if(this.FProcessorWindowPassInstance != null && this.FProcessorWindowPassInstance.Visible == true)
         {
            this.FProcessorWindowPassInstance.UpdataSlot();
            this.FProcessorWindowPassInstance.LogicsPerform_PlayerRole();
         }
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_WorldMap_ContinueAutoInfo,this.PacketPerform_SC_ContinueAutoInfo);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_WorldMap_AutoBattleInfo,this.PacketPerform_SC_AutoBattleInfo);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_WorldMap_AutoBattleFBInfo,this.PacketPerform_SC_AutoBattleFBInfo);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_WorldMap_ResetFB,this.PacketPerform_SC_ResetFB);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_WorldMap_Notify,this.PacketPerform_SC_Notify);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_WorldMap_Assessment,this.PacketPerform_SC_StarInfo);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_WorldMap_QueryChestRet,this.PacketPerform_SC_PassNodalWindow);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_LOBBY_WorldMap_ReceiveChestRet,this.PacketPerform_SC_PassNodalWindow);
      }
      
      protected function PacketPerform_SC_StarInfo(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ByteArray = null;
         _loc6_ = param1.Data;
         _loc5_ = _loc6_.readByte();
         _loc2_ = _loc6_.readByte();
         _loc4_ = _loc6_.readInt();
         _loc3_ = int(_loc6_.readUnsignedInt());
         if(_loc2_ == CONST_BATTLE.BattleType_Nodal)
         {
            this.FNodalModel.SetMissionStarByID(_loc4_,_loc5_);
         }
         else if(_loc2_ == CONST_BATTLE.BattleType_Camp)
         {
            this.FNodalModel.SetCampStarByID(_loc4_,_loc5_);
         }
      }
      
      protected function PacketPerform_SC_ContinueAutoInfo(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:TCity = null;
         _loc2_ = param1.Data;
         this.FAutoCityID = _loc2_.readUnsignedInt();
         this.FAutoMissionID = _loc2_.readUnsignedInt();
         this.FAutoCount = _loc2_.readUnsignedShort();
         this.FAutoStartTime = _loc2_.readUnsignedInt();
         this.FAutoIsFast = Boolean(_loc2_.readByte());
         this.FTargetCityId = _loc3_;
         _loc4_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_City,this.FAutoCityID) as TCity;
         if(_loc4_.Type == 2)
         {
            this.FIsInstanceAutoBattle = true;
            this.Mount();
         }
         else if(_loc4_.Type == 1)
         {
            if(this.FOnBarrierContinueAutoInfo != null)
            {
               this.GetNodalAutoMonsterInfo(this.FAutoMissionID,this.FAutoCityID);
               this.FOnBarrierContinueAutoInfo(this,this.FAutoCount,this.FAutoStartTime,this.FAutoIsFast,this.FAutoMissionID,this.FAutoCityID,this.FNodalAutoMonsterInfo);
            }
         }
      }
      
      protected function PacketPerform_SC_AutoBattleInfo(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         if(this.FWindowInstanceAutoBattle.Visible == true)
         {
            this.FWindowInstanceAutoBattle.PacketPerform_SC_AutoBattleInfo(param1);
         }
         else if(this.FOnBarrierAutoBattleInfo != null)
         {
            this.FOnBarrierAutoBattleInfo(this,param1);
         }
      }
      
      protected function PacketPerform_SC_AutoBattleFBInfo(param1:TPacket) : void
      {
      }
      
      protected function PacketPerform_SC_ResetFB(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:TCampaign = null;
         _loc4_ = param1.Data;
         _loc2_ = _loc4_.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc3_ = _loc4_.readInt();
         this.FNodalModel.ResetCampaign(_loc3_);
         this.FProcessorWindowInstanceChoose.UpDataNodalModel(this.FNodalModel);
         this.FWindowInstanceAutoBattle.UpDataNodalModel(this.FNodalModel);
      }
      
      protected function PacketPerform_SC_Notify(param1:TPacket) : void
      {
      }
      
      protected function PacketPerform_SC_PassNodalWindow(param1:TPacket) : void
      {
      }
      
      protected function PacketPerform_SC_WorldMapInfo(param1:ByteArray) : void
      {
         this.Enter(param1);
      }
      
      protected function ProcessorEnterWorldMapReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Enter_WorldMap);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function GetCityType(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:TCity = null;
         _loc2_ = -1;
         if(this.FCityBins == null)
         {
            this.FCityBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_City);
         }
         _loc3_ = this.FCityBins.GetDatebaseByIdentifier(param1) as TCity;
         if(_loc3_ != null)
         {
            _loc2_ = _loc3_.Type;
         }
         return _loc2_;
      }
      
      protected function SetAutoBattleCount() : void
      {
         this.ProcessorOnInstanceAutoBattle(this,this.FAutoCityID,this.FAutoMissionID);
         this.FWindowInstanceAutoBattle.ContinueAutoBattleCount(this.FAutoCount,this.FAutoStartTime,this.FAutoIsFast);
      }
      
      protected function GetNodalAutoMonsterInfo(param1:int, param2:int) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:TEnemyArmy = null;
         var _loc7_:TEnemy = null;
         var _loc8_:TBlockPoint = null;
         var _loc9_:Dictionary = null;
         var _loc10_:Dictionary = null;
         var _loc11_:uint = 0;
         var _loc12_:TMonster = null;
         var _loc13_:TConfigValue = null;
         var _loc14_:String = null;
         this.FCityBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_City);
         this.FSingleBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Single);
         this.FSinglePointPath = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_SinglePointPath);
         this.FBlockPointBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_BlockPoint);
         this.FEnemyArmyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_EnemyArmy);
         this.FEnemyBins = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Enemy);
         _loc8_ = this.FBlockPointBins.GetDatebaseByIdentifier(param1) as TBlockPoint;
         if(_loc8_ == null)
         {
            return;
         }
         this.FNodalAutoMonsterInfo.HootMonster.length = 0;
         this.FNodalAutoMonsterInfo.CurAutoMissionId = param1;
         this.FNodalAutoMonsterInfo.CurAutoCityId = param2;
         _loc13_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.BLOCK_AUTO_TIME) as TConfigValue;
         this.FNodalAutoMonsterInfo.CostTime = 60;
         _loc9_ = new Dictionary(true);
         _loc10_ = new Dictionary(true);
         _loc3_ = 0;
         while(_loc3_ < _loc8_.Armys.length)
         {
            _loc5_ = _loc8_.Armys[_loc3_];
            _loc6_ = this.FEnemyArmyBins.GetDatebaseByIdentifier(_loc5_) as TEnemyArmy;
            _loc4_ = 0;
            while(_loc4_ < _loc6_.EnemyIdVect.length)
            {
               _loc11_ = _loc6_.EnemyIdVect[_loc4_];
               _loc7_ = this.FEnemyBins.GetDatebaseByIdentifier(_loc11_) as TEnemy;
               if(_loc9_[_loc11_] == null)
               {
                  _loc9_[_loc11_] = 1;
                  _loc10_[_loc11_] = _loc7_.Level;
               }
               else
               {
                  _loc9_[_loc11_] += 1;
               }
               _loc4_++;
            }
            _loc3_++;
         }
         for(_loc14_ in _loc9_)
         {
            _loc12_ = this.FPoolCampaign.AcquireMonster(int(_loc14_));
            _loc12_.MonsterLevel = _loc10_[_loc14_];
            _loc12_.MonsterCount = _loc9_[_loc14_];
            this.FNodalAutoMonsterInfo.HootMonster.push(_loc12_);
         }
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         if(this.FProcessorWindowInstanceChoose == null)
         {
            return;
         }
         _loc1_ = FUICore.StageHeight;
         this.FProcessorWindowInstanceChoose.Y = (_loc1_ - SIZE_WindowInstanceChoose_Height) / 2;
      }
      
      protected function ProcessorOnEnterWorldMap(param1:uint) : void
      {
         this.FProcessorWindowSelectWorldMap.Visible = false;
         this.FProcessorWindowLargeWorldMap.Visible = true;
         this.FProcessorWindowInstanceChoose.Visible = false;
         this.FWindowInstanceAutoBattle.Visible = false;
         this.FProcessorWindowLargeWorldMap.OpenWorldMap(param1);
      }
      
      protected function ProcessorOnEnterMonsterMap(param1:Object, param2:int, param3:uint) : void
      {
         if(param3 == CONST_BATTLE.BattleType_Nodal)
         {
            if(this.FOnBarrierEnter != null)
            {
               this.FOnBarrierEnter(param1,this.FNodalModel,param2,param3);
            }
         }
         else if(param3 == CONST_BATTLE.BattleType_Camp)
         {
            this.FProcessorWindowInstanceChoose.SetCityID(param2);
            this.FProcessorWindowInstanceChoose.Visible = true;
         }
      }
      
      protected function ProcessorOnEnterHome(param1:Object, param2:int = 0, param3:int = 0) : void
      {
         var _loc4_:TPacket = null;
         var _loc5_:ByteArray = null;
         _loc4_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_LOBBY_Enter_Town);
         _loc5_ = _loc4_.Data;
         _loc5_.writeUnsignedInt(23100001);
         _loc5_.writeUnsignedInt(param3);
         SNetworkCore.Transceiver.PacketTransmit(_loc4_);
         ProcessorClose();
      }
      
      protected function ProcessorOnInstanceEnterMonster(param1:Object, param2:int, param3:int, param4:int) : void
      {
         if(param2 <= 0)
         {
            return;
         }
         if(this.FOnBarrierEnter != null)
         {
            this.FOnBarrierEnter(param1,this.FNodalModel,param2,param3,param4);
         }
      }
      
      protected function ProcessorOnInstanceAutoBattle(param1:Object, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param2 < 0 || param3 < 0)
         {
            return;
         }
         this.FNodalAutoMonsterInfo.HootMonster.length = 0;
         this.FNodalAutoMonsterInfo.CurAutoCityId = param2;
         this.FNodalAutoMonsterInfo.CurAutoMissionId = param3;
         this.FNodalAutoMonsterInfo.CostTime = 60;
         if(this.FWindowInstanceAutoBattle == null)
         {
            return;
         }
         if(this.FOnBarrierEnter != null)
         {
            this.FOnBarrierEnter(this,this.FNodalModel,param2,CONST_BATTLE.BattleType_Camp,0,false);
         }
         this.FWindowInstanceAutoBattle.OpenWindow(this.FNodalAutoMonsterInfo);
         if(this.FProcessorWindowInstanceChoose.Visible == true)
         {
            this.FProcessorWindowInstanceChoose.Visible = false;
         }
      }
      
      protected function ProcessorOnAutoBattlePassInstance(param1:Object, param2:int, param3:int) : void
      {
         if(this.FProcessorWindowPassInstance != null)
         {
            this.FProcessorWindowPassInstance.SetPassInstanceWindow(CONST_BATTLE.BattleType_Camp,param2,param3,this.ProcessorOnEnterHome);
            this.FProcessorWindowPassInstance.ShowWindows();
         }
      }
      
      protected function ProcessorOnUpdataNodalModel(param1:Object, param2:TNodal) : void
      {
         this.FNodalModel = param2;
         if(this.FProcessorWindowInstanceChoose != null)
         {
            this.FProcessorWindowInstanceChoose.UpDataNodalModel(this.FNodalModel);
         }
      }
      
      protected function ProcessorOnShortcutHyperlinks(param1:Object, param2:uint, param3:uint) : void
      {
         this.FOnShortcutHyperlinks(param1,param2,param3);
      }
      
      protected function UpdateShowWindow() : void
      {
         if(!this.FIsQuest)
         {
            this.FProcessorWindowSelectWorldMap.Visible = true;
            this.FProcessorWindowLargeWorldMap.Visible = false;
            this.FProcessorWindowInstanceChoose.Visible = false;
         }
         else
         {
            this.FProcessorWindowSelectWorldMap.Visible = false;
            this.FProcessorWindowLargeWorldMap.Visible = true;
            this.FProcessorWindowInstanceChoose.Visible = false;
         }
      }
      
      protected function AutoBattleOnClose(param1:Object) : void
      {
         if(this.FProcessorWindowLargeWorldMap.Visible == true)
         {
            return;
         }
         this.FProcessorWindowLargeWorldMap.Visible = true;
      }
      
      public function get OnBarrierEnter() : Function
      {
         return this.FOnBarrierEnter;
      }
      
      public function set OnBarrierEnter(param1:Function) : void
      {
         this.FOnBarrierEnter = param1;
      }
      
      public function get OnShortcutHyperlinks() : Function
      {
         return this.FOnShortcutHyperlinks;
      }
      
      public function set OnShortcutHyperlinks(param1:Function) : void
      {
         this.FOnShortcutHyperlinks = param1;
      }
      
      public function get OnBarrierAutoBattleInfo() : Function
      {
         return this.FOnBarrierAutoBattleInfo;
      }
      
      public function set OnBarrierAutoBattleInfo(param1:Function) : void
      {
         this.FOnBarrierAutoBattleInfo = param1;
      }
      
      public function get OnBarrierContinueAutoInfo() : Function
      {
         return this.FOnBarrierContinueAutoInfo;
      }
      
      public function set OnBarrierContinueAutoInfo(param1:Function) : void
      {
         this.FOnBarrierContinueAutoInfo = param1;
      }
      
      public function get OnInstanceAutoBattle() : Function
      {
         return this.FOnInstanceAutoBattle;
      }
      
      public function set OnInstanceAutoBattle(param1:Function) : void
      {
         this.FOnInstanceAutoBattle = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowLargeWorldMap.Load();
            this.FProcessorWindowSelectWorldMap.Load();
            this.FProcessorWindowInstanceChoose.Load();
            this.FProcessorWindowPassInstance.Load();
            this.FWindowInstanceAutoBattle.Load();
            return;
         }
         if(param1 != null)
         {
            this.PacketPerform_SC_WorldMapInfo(param1);
            if(this.FIsInstanceAutoBattle && this.FIsInit)
            {
               this.FProcessorWindowSelectWorldMap.Visible = false;
               this.FProcessorWindowLargeWorldMap.Visible = true;
               this.FIsInstanceAutoBattle = false;
               this.SetAutoBattleCount();
            }
            else
            {
               this.FWindowInstanceAutoBattle.Visible = false;
            }
            return;
         }
         this.ProcessorEnterWorldMapReq();
         this.ProcessorResize();
         if(!this.FIsQuest)
         {
            this.FProcessorWindowSelectWorldMap.Visible = true;
            this.FProcessorWindowLargeWorldMap.Visible = false;
            this.FProcessorWindowInstanceChoose.Visible = false;
            this.FProcessorWindowPassInstance.Visible = false;
            this.FWindowInstanceAutoBattle.Visible = false;
         }
         else
         {
            this.FProcessorWindowSelectWorldMap.Visible = false;
            this.FProcessorWindowLargeWorldMap.Visible = true;
            this.FProcessorWindowInstanceChoose.Visible = false;
            this.FProcessorWindowPassInstance.Visible = false;
            this.FWindowInstanceAutoBattle.Visible = false;
         }
         this.FCharacter.RoleSencePosition = CONST_COMMON.SCENEPOSITION_WORLDMAP;
      }
      
      override public function Unmount() : void
      {
         this.FProcessorWindowLargeWorldMap.Reset();
         this.FProcessorWindowInstanceChoose.Reset();
         this.FProcessorWindowSelectWorldMap.Reset();
         if(this.FIsInit)
         {
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseWorldMap);
         }
         super.Unmount();
      }
      
      public function Open(param1:Boolean, param2:uint = 1, param3:int = 0) : void
      {
         this.FIsQuest = param1;
         this.FMapType = param2;
         this.FTargetNodalId = param3;
         if(!this.FIsInit)
         {
            this.FWaitToOpen = true;
            this.FParameter1 = param1;
            this.FParameter2 = param2;
            this.FParameter3 = param3;
            return;
         }
         this.FWaitToOpen = false;
         this.UpdateShowWindow();
         if(this.FIsQuest)
         {
            this.FProcessorWindowLargeWorldMap.UpDataWorldMap(this.FNodalModel);
            this.FProcessorWindowLargeWorldMap.OpenWorldMap(param2,param3);
         }
      }
      
      public function Enter(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.UnstreamizerNodal.Unstreamize(param1,this.FNodalModel,SResourcesCore.ResourceBin);
         this.FProcessorWindowLargeWorldMap.UpDataWorldMap(this.FNodalModel);
         this.FProcessorWindowInstanceChoose.UpDataNodalModel(this.FNodalModel);
         this.FWindowInstanceAutoBattle.UpDataNodalModel(this.FNodalModel);
         if(this.FIsQuest)
         {
            this.FProcessorWindowLargeWorldMap.OpenWorldMap(this.FMapType,this.FTargetNodalId);
         }
         this.FIsInit = true;
         if(this.FWaitToOpen)
         {
            this.Open(this.FParameter1,this.FParameter2,this.FParameter3);
         }
      }
      
      public function PassInstanceAutoBattleWindow(param1:TPacket) : void
      {
         if(this.FProcessorWindowPassInstance != null)
         {
            this.FProcessorWindowPassInstance.PacketProcess(param1);
         }
      }
   }
}

