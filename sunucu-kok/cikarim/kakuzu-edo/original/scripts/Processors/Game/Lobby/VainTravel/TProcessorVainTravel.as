package Processors.Game.Lobby.VainTravel
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.TBlackMarket;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Streamization.VainTravel.TUnstreamizerVainTravel;
   import Logics.VainTravel.TVainTravelData;
   import Logics.VainTravel.TVainTravelFightReport;
   import Logics.VainTravel.TVainTravelPlayerInfor;
   import Processors.Game.Lobby.BlackMarket.InterfaceTimeMarket;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_BATTLE;
   import Resources.Constants.CONST_BLACKMARKET;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_MUSIC;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import Resources.Constants.CONST_VAINTRAVEL;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.utils.ByteArray;
   
   public class TProcessorVainTravel extends TProcessorLobbyWindows implements InterfaceTimeMarket
   {
      
      protected static const WINDOW_POINTSELECT_WIDTH:int = 858;
      
      protected static const WINDOW_POINTSELECT_HEIGHT:int = 515;
      
      protected static const WINDOW_BATTLEREADY_WIDTH:int = 654;
      
      protected static const WINDOW_BATTLEREADY_HEIGHT:int = 483;
      
      protected static const WINDOW_SHOP_WIDTH:int = 390;
      
      protected static const WINDOW_SHOP_HEIGHT:int = 376;
      
      protected static const WINDOW_FIGHTREPORT_WIDTH:int = 335;
      
      protected static const WINDOW_FIGHTREPORT_HEIGHT:int = 277;
      
      protected var FProcessorWindowPointSelect:TProcessorWindowPointSelect;
      
      protected var FProcessorWindowBattleReady:TProcessorWindowBattleReady;
      
      protected var FProcessorWindowShop:TProcessorWindowShop;
      
      protected var FProcessorWindowFightReport:TProcessorWindowFightReport;
      
      protected var FLayerMask:Sprite;
      
      protected var FUnstreamizerVainTravel:TUnstreamizerVainTravel;
      
      protected var FVainTravelData:TVainTravelData;
      
      protected var FInited:Boolean;
      
      protected var FTypes:Vector.<int>;
      
      protected var FCodes:Vector.<int>;
      
      protected var FAmounts:Vector.<int>;
      
      protected var FOnSetBattleStatus:Function;
      
      protected var FOnInitBattle:Function;
      
      public function TProcessorVainTravel(param1:TUIComponent, param2:TLobbyParameters)
      {
         var _loc3_:TBounds = null;
         super(param1,param2);
         this.FVainTravelData = new TVainTravelData(CONST_VAINTRAVEL.VAINPOINTNUM);
         _loc3_ = new TBounds();
         _loc3_.Width = WINDOW_POINTSELECT_WIDTH;
         _loc3_.Height = WINDOW_POINTSELECT_HEIGHT;
         this.FProcessorWindowPointSelect = new TProcessorWindowPointSelect(this);
         this.FProcessorWindowPointSelect.OnClose = this.CloseSubWindow;
         this.FProcessorWindowPointSelect.OnOpenReadyWindow = this.OpenBattleReadyWindow;
         this.FProcessorWindowPointSelect.OnOpenShop = this.OpenShopReq;
         this.FProcessorWindowPointSelect.OnOpenFightReport = this.OpenFightReport;
         ComponentBoundsCenter(this.FProcessorWindowPointSelect,_loc3_);
         _loc3_.Width = WINDOW_BATTLEREADY_WIDTH;
         _loc3_.Height = WINDOW_BATTLEREADY_HEIGHT;
         this.FProcessorWindowBattleReady = new TProcessorWindowBattleReady(this);
         this.FProcessorWindowBattleReady.OnClose = this.CloseBattleReadyWindow;
         ComponentBoundsCenter(this.FProcessorWindowBattleReady,_loc3_);
         _loc3_.Width = WINDOW_SHOP_WIDTH;
         _loc3_.Height = WINDOW_SHOP_HEIGHT;
         this.FProcessorWindowShop = new TProcessorWindowShop(this);
         this.FProcessorWindowShop.OnClose = this.CloseShop;
         ComponentBoundsCenter(this.FProcessorWindowShop,_loc3_);
         _loc3_.Width = WINDOW_FIGHTREPORT_WIDTH;
         _loc3_.Height = WINDOW_FIGHTREPORT_HEIGHT;
         this.FProcessorWindowFightReport = new TProcessorWindowFightReport(this);
         this.FProcessorWindowFightReport.OnClose = this.CloseFightReport;
         ComponentBoundsCenter(this.FProcessorWindowFightReport,_loc3_);
         this.FUnstreamizerVainTravel = new TUnstreamizerVainTravel();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_VAINTRAVEL.RESOURCESID_Swf_VainTravel);
         this.FLayerMask = new Sprite();
         addChild(this.FLayerMask);
         this.FLayerMask.visible = false;
         this.FLayerMask.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FLayerMask.x = -x;
         this.FLayerMask.y = -y;
         addChild(this.FProcessorWindowBattleReady);
         addChild(this.FProcessorWindowFightReport);
         addChild(this.FProcessorWindowShop);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FTypes = new Vector.<int>();
         this.FCodes = new Vector.<int>();
         this.FAmounts = new Vector.<int>();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:TConfigValue = null;
         this.FInited = false;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.VainTravelResetFreeTimeEveryDay) as TConfigValue;
         this.FVainTravelData.FreeTimeEveryDay = _loc1_.Value as int;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.VainTravelResetFreeTimeCost) as TConfigValue;
         this.FVainTravelData.ResetCost = Vector.<int>(_loc1_.Value);
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.VainTravelReliveTimeEveryDay) as TConfigValue;
         this.FVainTravelData.ReliveTimeEveryDay = _loc1_.Value as int;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.VainTravelReliveCost) as TConfigValue;
         this.FVainTravelData.ReliveCostVec = Vector.<int>(_loc1_.Value);
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.VainTravelShopResetTime) as TConfigValue;
         this.FVainTravelData.VainTravelShopData.FlushTime = Vector.<int>(_loc1_.Value);
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.VainTravelShopResetCost) as TConfigValue;
         this.FVainTravelData.VainTravelShopData.FlushCosts = Vector.<Object>(_loc1_.Value);
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         super.PacketRegisterRoutines();
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VainTravel_InitRet,this.PacketPerform_InitRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VainTravel_BattleRet,this.PacketPerform_BattleRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VainTravel_DailyResetRet,this.PacketPerform_DailyResetRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VainTravel_TakeRewardRet,this.PacketPerform_TakeRewardRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VainTravel_FightReportNotify,this.PacketPerform_FightReportNotify);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VainTravel_ReliveRet,this.PacketPerform_BuyReliveRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_VainTravel_RefreshRet,this.PacketPerform_RefreshRet);
      }
      
      protected function PacketPerform_InitRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizerVainTravel.UnstreamizationInitPlayerList(param1.Data,this.FVainTravelData,null);
         this.FVainTravelData.VainTravelTodayFightReports.sort(this.FightReportSortMehod);
         this.FVainTravelData.VainTravelNiceFightReports.sort(this.FightReportSortMehod);
         this.FInited = true;
         if(Visible)
         {
            this.FProcessorWindowPointSelect.Show(this.FVainTravelData);
         }
      }
      
      protected function PacketPerform_BattleRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:ByteArray = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:TVainTravelPlayerInfor = null;
         _loc5_ = param1.Data;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         _loc6_ = _loc5_.readByte();
         _loc7_ = param1.Data.readByte();
         _loc4_ = _loc5_.readShort();
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc8_ = _loc5_.readByte();
            _loc9_ = _loc5_.readInt();
            _loc10_ = _loc5_.readByte();
            if(_loc8_ == CONST_VAINTRAVEL.Camp_My)
            {
               _loc11_ = this.FVainTravelData.MyHeroIDS.indexOf(_loc9_);
               this.FVainTravelData.MyHeroBloodRate[_loc11_] = _loc10_;
            }
            else
            {
               _loc12_ = this.FVainTravelData.PlayerInforByIndex(_loc7_);
               _loc11_ = _loc12_.HeroTemplateID.indexOf(_loc9_);
               _loc12_.HeroBloodRate[_loc11_] = _loc10_;
            }
            _loc3_++;
         }
         if(_loc6_ == CONST_VAINTRAVEL.BattleResult_Win)
         {
            this.CloseBattleReadyWindow(this);
            this.FProcessorWindowBattleReady.visible = false;
            this.FProcessorWindowPointSelect.Show(this.FVainTravelData);
            _loc12_ = this.FVainTravelData.PlayerInforByIndex(_loc7_);
            _loc12_.CurrentState = CONST_VAINTRAVEL.PlayerState_Box;
         }
         else
         {
            this.FProcessorWindowBattleReady.BattleResultNotify();
            if(this.FVainTravelData.CanReliveTime > 0)
            {
               ++this.FVainTravelData.CurrentReliveTime;
               this.FProcessorWindowPointSelect.Show(this.FVainTravelData);
            }
         }
         if(this.FOnSetBattleStatus != null)
         {
            this.FOnSetBattleStatus(this,CONST_BATTLE.BattleType_VainTravel,CONST_MUSIC.ID_SCENE_GongFuFight);
         }
         if(this.FOnInitBattle != null)
         {
            this.FOnInitBattle(this);
         }
      }
      
      protected function PacketPerform_DailyResetRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_08));
      }
      
      protected function PacketPerform_TakeRewardRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:ByteArray = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc5_ = param1.Data;
         _loc6_ = _loc5_.readInt();
         if(_loc6_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc6_);
            return;
         }
         _loc7_ = _loc5_.readByte();
         this.FTypes.length = 0;
         this.FCodes.length = 0;
         this.FAmounts.length = 0;
         _loc3_ = _loc5_.readShort();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FTypes.push(_loc5_.readShort());
            this.FCodes.push(_loc5_.readInt());
            this.FAmounts.push(_loc5_.readInt());
            _loc2_++;
         }
         _loc4_ = "";
         _loc3_ = int(this.FTypes.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ += SToolReward.GetNameByTypeCode(this.FTypes[_loc2_],this.FCodes[_loc2_]);
            _loc4_ = _loc4_ + TUtilityString.Format("*%1 ",_loc4_,this.FAmounts[_loc2_]);
            _loc2_++;
         }
         SUtilityOverLayer.UIWindowInformation.Text = _loc4_;
         SUtilityOverLayer.UIWindowInformation.Visible = true;
         SUtilityOverLayer.UIWindowInformation.OnOK = null;
         this.FVainTravelData.PlayerInforByIndex(_loc7_).CurrentState = CONST_VAINTRAVEL.PlayerState_Dead;
         if(Visible)
         {
            this.FProcessorWindowPointSelect.Show(this.FVainTravelData);
         }
      }
      
      protected function PacketPerform_FightReportNotify(param1:TPacket) : void
      {
         var _loc2_:TVainTravelFightReport = null;
         _loc2_ = new TVainTravelFightReport();
         this.FUnstreamizerVainTravel.UnstreamizationSingleFightReport(param1.Data,_loc2_,null);
         switch(_loc2_.FightReportType)
         {
            case CONST_VAINTRAVEL.BattleReportType_Today:
               this.FVainTravelData.VainTravelTodayFightReports.push(_loc2_);
               break;
            case CONST_VAINTRAVEL.BattleReportType_Nice:
               this.FVainTravelData.VainTravelNiceFightReports.push(_loc2_);
         }
         this.FVainTravelData.VainTravelTodayFightReports.sort(this.FightReportSortMehod);
         this.FVainTravelData.VainTravelNiceFightReports.sort(this.FightReportSortMehod);
         if(this.FProcessorWindowFightReport.Visible)
         {
            this.OpenFightReport(this);
         }
      }
      
      public function MallInforInitRet(param1:int, param2:TPacket) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBlackMarket = null;
         var _loc7_:Vector.<TBlackMarket> = null;
         _loc3_ = param2.Data;
         this.FVainTravelData.VainTravelShopData.GoodsVec.length = 0;
         this.FVainTravelData.VainTravelShopData.BuiedTime.length = 0;
         this.FVainTravelData.VainTravelShopData.Inventories.Clear();
         this.FVainTravelData.VainTravelShopData.Configs.length = 0;
         this.FVainTravelData.VainTravelShopData.CurrentFlashTime = _loc3_.readInt();
         this.FVainTravelData.VainTravelShopData.CurrentGoodBornTime = _loc3_.readInt();
         this.FVainTravelData.VainTravelCoinNum = _loc3_.readInt();
         _loc5_ = _loc3_.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FVainTravelData.VainTravelShopData.GoodsVec.push(_loc3_.readInt());
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BlackMarket,this.FVainTravelData.VainTravelShopData.GoodsVec[_loc4_]) as TBlackMarket;
            SToolReward.GetInventoryByIDAmount(_loc6_.ItemID,_loc6_.Number,this.FVainTravelData.VainTravelShopData.Inventories);
            this.FVainTravelData.VainTravelShopData.Configs.push(_loc6_);
            this.FVainTravelData.VainTravelShopData.BuiedTime.push(_loc3_.readInt());
            _loc4_++;
         }
         this.OpenShop(this);
      }
      
      public function MallRefreshRet(param1:int, param2:TPacket) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TBlackMarket = null;
         var _loc7_:Vector.<TBlackMarket> = null;
         _loc3_ = param2.Data;
         this.FVainTravelData.VainTravelShopData.CurrentFlashTime = _loc3_.readInt();
         this.FVainTravelData.VainTravelShopData.CurrentGoodBornTime = _loc3_.readInt();
         this.FVainTravelData.VainTravelCoinNum = _loc3_.readInt();
         this.FVainTravelData.VainTravelShopData.GoodsVec.length = 0;
         this.FVainTravelData.VainTravelShopData.BuiedTime.length = 0;
         this.FVainTravelData.VainTravelShopData.Inventories.Clear();
         this.FVainTravelData.VainTravelShopData.Configs.length = 0;
         _loc5_ = _loc3_.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FVainTravelData.VainTravelShopData.GoodsVec.push(_loc3_.readInt());
            _loc6_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BlackMarket,this.FVainTravelData.VainTravelShopData.GoodsVec[_loc4_]) as TBlackMarket;
            SToolReward.GetInventoryByIDAmount(_loc6_.ItemID,_loc6_.Number,this.FVainTravelData.VainTravelShopData.Inventories);
            this.FVainTravelData.VainTravelShopData.Configs.push(_loc6_);
            this.FVainTravelData.VainTravelShopData.BuiedTime.push(0);
            _loc4_++;
         }
         if(this.FProcessorWindowShop.Visible)
         {
            this.OpenShop(null);
         }
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_08));
      }
      
      public function MallBuyGoodRet(param1:int, param2:TPacket) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = param2.Data.readInt();
         this.FVainTravelData.VainTravelCoinNum = param2.Data.readInt();
         _loc4_ = this.FVainTravelData.VainTravelShopData.GoodsVec.indexOf(_loc3_);
         ++this.FVainTravelData.VainTravelShopData.BuiedTime[_loc4_];
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_09));
         if(this.FProcessorWindowShop.Visible)
         {
            this.FProcessorWindowShop.Show(this.FVainTravelData);
         }
      }
      
      protected function PacketPerform_BuyReliveRet(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         _loc2_ = param1.Data.readInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         ++this.FVainTravelData.CurrentReliveTimeBuied;
         if(this.FProcessorWindowPointSelect.Visible)
         {
            this.FProcessorWindowPointSelect.Show(this.FVainTravelData);
         }
         SToolReward.ShowMessage(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_VAINTRAVEL_06));
      }
      
      protected function PacketPerform_RefreshRet(param1:TPacket) : void
      {
         this.FVainTravelData.CurrentResetTime = 0;
         this.FVainTravelData.CurrentResetTimeBuied = 0;
         this.FVainTravelData.CurrentReliveTime = 0;
         this.FVainTravelData.CurrentReliveTimeBuied = 0;
         this.FVainTravelData.VainTravelShopData.CurrentFlashTime = 0;
         if(this.FProcessorWindowPointSelect.Visible)
         {
            this.FProcessorWindowPointSelect.Show(this.FVainTravelData);
         }
      }
      
      protected function BaseInforReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_VainTravel_InitReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ShopInforReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TimeMall_InitDataReq);
         _loc1_.Data.writeInt(CONST_BLACKMARKET.MarketID_VainTravelMarket);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function FightReportSortMehod(param1:TVainTravelFightReport, param2:TVainTravelFightReport) : int
      {
         if(param1.FightReportTime < param2.FightReportTime)
         {
            return -1;
         }
         if(param1.FightReportTime > param2.FightReportTime)
         {
            return 1;
         }
         return 0;
      }
      
      protected function CloseSubWindow(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function OpenBattleReadyWindow(param1:Object) : void
      {
         this.FLayerMask.visible = true;
         this.FProcessorWindowBattleReady.Show(this.FVainTravelData,param1 as TVainTravelPlayerInfor);
      }
      
      protected function CloseBattleReadyWindow(param1:Object) : void
      {
         this.FLayerMask.visible = false;
         this.FProcessorWindowBattleReady.Visible = false;
      }
      
      protected function OpenShopReq(param1:Object) : void
      {
         this.ShopInforReq();
      }
      
      protected function OpenShop(param1:Object) : void
      {
         this.FLayerMask.visible = true;
         this.FProcessorWindowShop.Show(this.FVainTravelData);
      }
      
      protected function CloseShop(param1:Object) : void
      {
         this.FLayerMask.visible = false;
         this.FProcessorWindowShop.Visible = false;
      }
      
      protected function OpenFightReport(param1:Object) : void
      {
         this.FLayerMask.visible = true;
         this.FProcessorWindowFightReport.Show(this.FVainTravelData);
      }
      
      protected function CloseFightReport(param1:Object) : void
      {
         this.FLayerMask.visible = false;
         this.FProcessorWindowFightReport.Visible = false;
      }
      
      public function set OnSetBattleStatus(param1:Function) : void
      {
         this.FOnSetBattleStatus = param1;
      }
      
      public function set OnInitBattle(param1:Function) : void
      {
         this.FOnInitBattle = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowPointSelect.Load();
            this.FProcessorWindowBattleReady.Load();
            this.FProcessorWindowShop.Load();
            this.FProcessorWindowFightReport.Load();
            return;
         }
         if(this.FInited)
         {
            this.FProcessorWindowPointSelect.Show(this.FVainTravelData);
         }
         else
         {
            this.BaseInforReq();
         }
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
      
      public function ProcessorChangePosition(param1:Object) : void
      {
         if(Visible)
         {
            this.FProcessorWindowBattleReady.ProcessorChangePosition();
         }
      }
   }
}

