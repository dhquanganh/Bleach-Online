package Processors.Game.Lobby.Arena
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Logics.Arena.TArenaData;
   import Logics.DatebaseVO.VO.TArticle;
   import Logics.SLogicsCore;
   import Logics.Streamization.Arena.TUnstreamizerArena;
   import Logics.TimeCoolDown.TTimeCoolDown;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyPlate;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_ARENA;
   import Resources.Constants.CONST_BATTLE;
   import Resources.Constants.CONST_COMMON;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_FRESHGUIDE;
   import Resources.Constants.CONST_MUSIC;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SIGNAL;
   import Utilities.Timing.TUtilityTiming;
   import flash.utils.ByteArray;
   
   public class TProcessorArena extends TProcessorLobbyPlate
   {
      
      protected static const CONST_RING:uint = 4;
      
      protected static const Movie_Show:String = "come";
      
      protected static const Movie_Hide:String = "out";
      
      protected static const SIZE_WindowArenaList_Width:uint = 351;
      
      protected static const SIZE_WindowArenaList_Height:uint = 320;
      
      protected var FTimeCoolDown:TTimeCoolDown;
      
      protected var FArenaData:TArenaData;
      
      protected var FUnstreamizerArena:TUnstreamizerArena;
      
      protected var FProcessorWindowArena:TProcessorWindowArena;
      
      protected var FProcessorWindowArenaList:TProcessorWindowArenaList;
      
      protected var FIsInit:Boolean;
      
      protected var FAutoFight:Boolean;
      
      protected var FInitialization:Boolean;
      
      protected var FOnReturnTown:Function;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnSetBattlePacket:Function;
      
      protected var FOnInitBattle:Function;
      
      protected var FOnShowOtherHeroInfor:Function;
      
      protected var FOnSetBattleBackground:Function;
      
      public function TProcessorArena(param1:TUIComponent, param2:TLobbyParameters)
      {
         var _loc3_:TBounds = null;
         super(param1,param2);
         this.FArenaData = new TArenaData();
         this.FUnstreamizerArena = new TUnstreamizerArena();
         this.FTimeCoolDown = new TTimeCoolDown(CONST_COMMON.TIME_COOLDOWN_Arean);
         SLogicsCore.TimeCoolDowns.Add(this.FTimeCoolDown);
         this.FProcessorWindowArena = new TProcessorWindowArena(this);
         this.FProcessorWindowArena.OnClose = this.ProcessorWindowOnClose;
         this.FProcessorWindowArena.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowArena.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowArena.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowArena.OnHelpTipsOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowArena.OnHelpTipsOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowArena.OnCheckCanFight = this.CheckCanFight;
         this.FProcessorWindowArenaList = new TProcessorWindowArenaList(param2.MountPointWindow);
         this.FProcessorWindowArenaList.OnClose = this.ProcessorWindowArenaListOnClose;
         this.FProcessorWindowArenaList.OnShowOtherHeroInfor = this.ProcessorOnShowOtherHeroInfor;
         this.FProcessorWindowArenaList.Visible = false;
         _loc3_ = new TBounds();
         _loc3_.Width = SIZE_WindowArenaList_Width;
         _loc3_.Height = SIZE_WindowArenaList_Height;
         ComponentBoundsCenter(this.FProcessorWindowArenaList,_loc3_);
         this.FIsInit = false;
         this.FAutoFight = false;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         if(this.FProcessorWindowArena != null)
         {
            this.FProcessorWindowArena.UpdataColdDown();
         }
         if(this.FProcessorWindowArena != null)
         {
            this.FProcessorWindowArena.UpdataModel();
         }
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ARENA.RESOURCE_ARENA);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_ArenaView,this);
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_ArenaView,this);
         this.FInitialization = false;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Arena_BigFish_Ret,this.PacketPerform_SC_BigFish_Ret);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Arena_GetReward_Ret,this.PacketPerform_SC_GetReward_Ret);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Arena_AddOrder_Ret,this.PacketPerform_SC_AddOrder_Ret);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Arena_Faster_Ret,this.PacketPerform_SC_Faster_Ret);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Arena_Fight_Ret,this.PacketPerform_SC_Fight_Ret);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Arena_Look_Ret,this.PacketPerform_SC_Look_Ret);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Arena_Update,this.PacketPerform_SC_Update);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Arena_FightOk,this.PacketPerform_SC_FightOk);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Arena_ColdTime_Ret,this.PacketPerform_SC_ColdTime);
      }
      
      protected function ProcessorArenaInfo(param1:ByteArray) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.FUnstreamizerArena.Unstreamize(param1,this.FArenaData,SResourcesCore.ResourceBin);
         this.FTimeCoolDown.TimingTime = this.FArenaData.ColdDown - STimingCore.ServerTick;
         this.FIsInit = true;
      }
      
      protected function PacketPerform_SC_BigFish_Ret(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FUnstreamizerArena.UnstreamizeArenaHeroPanel(_loc2_,this.FArenaData.HeroPanelList,SResourcesCore.ResourceBin);
         this.FProcessorWindowArenaList.SetArenaHeroPanel(this.FArenaData.HeroPanelList);
         BarrierActuate(this.FProcessorWindowArenaList);
         this.FProcessorWindowArenaList.Visible = true;
      }
      
      protected function PacketPerform_SC_GetReward_Ret(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:TArticle = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FProcessorWindowArena.GetRewardOk();
         _loc8_ = _loc2_.readUnsignedShort();
         _loc9_ = "";
         _loc10_ = "";
         _loc7_ = 0;
         while(_loc7_ < _loc8_)
         {
            _loc4_ = uint(_loc2_.readShort());
            _loc5_ = uint(_loc2_.readInt());
            _loc6_ = uint(_loc2_.readInt());
            if(_loc4_ != 1)
            {
               _loc9_ = TUtilityLobby.GetItemName(_loc4_,_loc5_);
            }
            else
            {
               _loc11_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_Article,_loc5_) as TArticle;
               _loc9_ = _loc11_.Name;
            }
            _loc9_ += " +" + _loc6_.toString();
            _loc10_ += _loc9_ + "\n";
            _loc7_++;
         }
         EffectGenerateText(_loc10_);
      }
      
      protected function PacketPerform_SC_AddOrder_Ret(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FProcessorWindowArena.AddOrderOk();
      }
      
      protected function PacketPerform_SC_Faster_Ret(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.FProcessorWindowArena.FasterOk();
         this.FTimeCoolDown.TimingTime = 0;
      }
      
      protected function PacketPerform_SC_Fight_Ret(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         if(this.FOnSetBattlePacket != null)
         {
            this.FOnSetBattlePacket(this,param1);
         }
      }
      
      protected function PacketPerform_SC_Look_Ret(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
      }
      
      protected function PacketPerform_SC_Update(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:Boolean = false;
         if(!this.FIsInit)
         {
            return;
         }
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = Boolean(this.FArenaData.BoxType != 1);
         this.FUnstreamizerArena.Unstreamize(_loc2_,this.FArenaData,SResourcesCore.ResourceBin);
         if(_loc4_ && this.FArenaData.BoxType == 1)
         {
            this.FArenaData.ColdDownBox += TUtilityTiming.CONST_DAY;
         }
         if(Visible)
         {
            this.FProcessorWindowArena.SetArenaData(this.FArenaData);
            this.FProcessorWindowArena.SetArenaHeros(this.FArenaData.FightHeroList);
            this.FProcessorWindowArena.SetArenaReports(this.FArenaData.ReportList);
         }
         this.FTimeCoolDown.TimingTime = this.FArenaData.ColdDown - STimingCore.ServerTick;
      }
      
      protected function PacketPerform_SC_FightOk(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         this.ProcessorSetBattleStatus(this,CONST_BATTLE.BattleType_Arena,CONST_MUSIC.ID_SCENE_Arena);
         if(this.FOnInitBattle != null)
         {
            this.FOnInitBattle(this);
         }
      }
      
      protected function PacketPerform_SC_ColdTime(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FArenaData.ColdDown = _loc2_.readUnsignedInt();
         this.FTimeCoolDown.TimingTime = this.FArenaData.ColdDown - STimingCore.ServerTick;
      }
      
      protected function EnterArenaMovie() : void
      {
         this.FProcessorWindowArena.SetArenaData(this.FArenaData);
         this.FProcessorWindowArena.SetArenaHeros(this.FArenaData.FightHeroList);
         this.FProcessorWindowArena.SetArenaReports(this.FArenaData.ReportList);
         MusicPlayNext(CONST_SIGNAL.SIGNALDESTINATION_SOUND,CONST_MUSIC.PLAY_SCENE_Arena,CONST_MUSIC.ID_SCENE_Arena,false);
         this.FProcessorWindowArena.Update();
         this.FProcessorWindowArena.Visible = true;
      }
      
      protected function CheckCanFight() : Boolean
      {
         var _loc1_:Boolean = false;
         _loc1_ = this.FProcessorWindowArena.CheckCanFight();
         this.FAutoFight = !_loc1_;
         return _loc1_;
      }
      
      protected function PerformPacket_CS_ArenaColdTime() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Arena_ColdTime_Req);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorEnterArenaReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Enter_Arena);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorWindowOnClose(param1:Object) : void
      {
         if(this.FOnReturnTown != null)
         {
            this.FOnReturnTown(this);
         }
         this.FIsInit = false;
      }
      
      public function ProcessorWindowArenaListOnClose(param1:Object) : void
      {
         BarrierDeactuate(this.FProcessorWindowArenaList);
      }
      
      protected function ProcessorSetBattleStatus(param1:Object, param2:int, param3:int) : void
      {
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(param1,param2,param3);
         }
      }
      
      protected function ProcessorOnShowOtherHeroInfor(param1:Object, param2:uint, param3:uint) : void
      {
         if(this.FOnShowOtherHeroInfor != null)
         {
            this.FOnShowOtherHeroInfor(param1,param2,param3);
         }
      }
      
      public function set OnReturnTown(param1:Function) : void
      {
         this.FOnReturnTown = param1;
      }
      
      public function get OnReturnTown() : Function
      {
         return this.FOnReturnTown;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function get OnSetBattleStatus() : Function
      {
         return this.FOnSetBattleStatus;
      }
      
      public function set OnSetBattlePacket(param1:Function) : void
      {
         this.FOnSetBattlePacket = param1;
      }
      
      public function get OnSetBattlePacket() : Function
      {
         return this.FOnSetBattlePacket;
      }
      
      public function set OnInitBattle(param1:Function) : void
      {
         this.FOnInitBattle = param1;
      }
      
      public function get OnInitBattle() : Function
      {
         return this.FOnInitBattle;
      }
      
      public function set OnShowOtherHeroInfor(param1:Function) : void
      {
         this.FOnShowOtherHeroInfor = param1;
      }
      
      public function get OnShowOtherHeroInfor() : Function
      {
         return this.FOnShowOtherHeroInfor;
      }
      
      public function get OnSetBattleBackground() : Function
      {
         return this.FOnSetBattleBackground;
      }
      
      public function set OnSetBattleBackground(param1:Function) : void
      {
         this.FOnSetBattleBackground = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         var _loc2_:TPacket = null;
         super.Mount();
         if(param1 != null)
         {
            this.ProcessorArenaInfo(param1);
         }
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowArena.Load();
            this.FProcessorWindowArenaList.Load();
            return;
         }
         this.EnterArenaMovie();
         SLogicsCore.Character.RoleSencePosition = CONST_COMMON.SCENEPOSITION_ARENA;
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenArena);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         if(this.FIsInit)
         {
            TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseArena);
         }
         this.FProcessorWindowArena.Reset();
         this.FProcessorWindowArena.Visible = false;
      }
      
      public function EnterArenaReq() : void
      {
         if(SLogicsCore.Character.RoleSencePosition != CONST_COMMON.SCENEPOSITION_ARENA)
         {
            this.ProcessorEnterArenaReq();
         }
      }
      
      public function UpdateCDTime() : void
      {
         this.PerformPacket_CS_ArenaColdTime();
      }
   }
}

