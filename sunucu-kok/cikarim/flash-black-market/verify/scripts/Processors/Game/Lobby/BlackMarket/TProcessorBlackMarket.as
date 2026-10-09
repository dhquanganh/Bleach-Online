package Processors.Game.Lobby.BlackMarket
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.BlackMarket.TBlackMarketTotalData;
   import Logics.DatebaseVO.VO.TBlackMarket;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Inventories.TInventories;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import Resources.Constants.CONST_BLACKMARKET;
   import Resources.Constants.CONST_CONFIGVALUE;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SHORTCUTS;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   public class TProcessorBlackMarket extends TProcessorLobbyWindows implements InterfaceTimeMarket
   {
      
      protected static const WINDOW_WIDTH:int = 785;
      
      protected static const WINDOW_HEIGHT:int = 468;
      
      protected var FBounds:TBounds;
      
      protected var FProcessorWindowMarketMainUI:TProcessorWindowMarketMainUI;
      
      protected var FBlackMarketTotalData:TBlackMarketTotalData;
      
      protected var FEffectNotification:Function;
      
      protected var FOnOpenSecretMallNotify:Function;
      
      public function TProcessorBlackMarket(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_WIDTH;
         this.FBounds.Height = WINDOW_HEIGHT;
         this.FProcessorWindowMarketMainUI = new TProcessorWindowMarketMainUI(this);
         this.FProcessorWindowMarketMainUI.OnClose = this.CloseWindows;
         ComponentBoundsCenter(this.FProcessorWindowMarketMainUI,this.FBounds);
         this.FBlackMarketTotalData = new TBlackMarketTotalData();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_BLACKMARKET.BLACKMAREKT_RESOURCEID);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         var _loc1_:TConfigValue = null;
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.BlackMarketRefresh) as TConfigValue;
         this.FBlackMarketTotalData.BlackMarketData.FlushCosts = Vector.<Object>(_loc1_.Value);
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.SecretMarketRefresh) as TConfigValue;
         this.FBlackMarketTotalData.SecretMarketData.FlushCosts = Vector.<Object>(_loc1_.Value);
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.BlackMarketFlushTime) as TConfigValue;
         this.FBlackMarketTotalData.BlackMarketData.FlushTime = Vector.<int>(_loc1_.Value);
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.BlackMarketCountDown) as TConfigValue;
         this.FBlackMarketTotalData.SecretMarketData.SecretMarketDurationTime = _loc1_.Value as int;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         super.PacketRegisterRoutines();
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_BlackMarket_InitInforRet,this.PacketPerform_InitInforRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_BlackMarket_OpenMarketNotify,this.PacketPerform_OpenMarketNotify);
      }
      
      public function MallInforInitRet(param1:int, param2:TPacket) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<int> = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:TInventories = null;
         var _loc9_:TBlackMarket = null;
         var _loc10_:Vector.<TBlackMarket> = null;
         _loc3_ = param2.Data;
         if(param1 == CONST_BLACKMARKET.MarketID_BlackMarket)
         {
            this.FBlackMarketTotalData.BlackMarketData.CurrentFlashTime = _loc3_.readInt();
            this.FBlackMarketTotalData.BlackMarketData.CurrentGoodBornTime = _loc3_.readInt();
            _loc6_ = this.FBlackMarketTotalData.BlackMarketData.GoodsVec;
            _loc7_ = this.FBlackMarketTotalData.BlackMarketData.BuiedTime;
            this.FBlackMarketTotalData.BlackMarketData.Inited = true;
            _loc8_ = this.FBlackMarketTotalData.BlackMarketData.Inventories;
            _loc10_ = this.FBlackMarketTotalData.BlackMarketData.Configs;
         }
         else
         {
            this.FBlackMarketTotalData.SecretMarketData.CurrentFlashTime = _loc3_.readInt();
            this.FBlackMarketTotalData.SecretMarketData.CurrentGoodBornTime = _loc3_.readInt();
            _loc6_ = this.FBlackMarketTotalData.SecretMarketData.GoodsVec;
            _loc7_ = this.FBlackMarketTotalData.SecretMarketData.BuiedTime;
            this.FBlackMarketTotalData.SecretMarketData.Inited = true;
            _loc8_ = this.FBlackMarketTotalData.SecretMarketData.Inventories;
            _loc10_ = this.FBlackMarketTotalData.SecretMarketData.Configs;
         }
         _loc6_.length = 0;
         _loc7_.length = 0;
         _loc8_.Clear();
         _loc10_.length = 0;
         _loc3_.readInt();
         _loc5_ = _loc3_.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.push(_loc3_.readInt());
            _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BlackMarket,_loc6_[_loc4_]) as TBlackMarket;
            if(param1 == CONST_BLACKMARKET.MarketID_BlackMarket && _loc9_.Identifier == 20000001)
            {
               _loc9_.ApplyLocalOffer({
                  "itemID":14100005,
                  "number":50,
                  "price":{
                     "type":0,
                     "code":1,
                     "amount":50
                  },
                  "totalTimes":1
               });
            }
            SToolReward.GetInventoryByIDAmount(_loc9_.ItemID,_loc9_.Number,_loc8_);
            _loc10_.push(_loc9_);
            _loc7_.push(_loc3_.readInt());
            _loc4_++;
         }
         if(param1 == CONST_BLACKMARKET.MarketID_BlackMarket && _loc3_.bytesAvailable > 0)
         {
            this.ApplyServerOffers(_loc3_,_loc8_,_loc10_);
         }
         this.FProcessorWindowMarketMainUI.GoodsInforNotify();
      }
      
      public function MallRefreshRet(param1:int, param2:TPacket) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<int> = null;
         var _loc7_:Vector.<int> = null;
         var _loc8_:TInventories = null;
         var _loc9_:TBlackMarket = null;
         var _loc10_:Vector.<TBlackMarket> = null;
         _loc3_ = param2.Data;
         if(param1 == CONST_BLACKMARKET.MarketID_BlackMarket)
         {
            this.FBlackMarketTotalData.BlackMarketData.CurrentFlashTime = _loc3_.readInt();
            this.FBlackMarketTotalData.BlackMarketData.CurrentGoodBornTime = _loc3_.readInt();
            _loc6_ = this.FBlackMarketTotalData.BlackMarketData.GoodsVec;
            _loc7_ = this.FBlackMarketTotalData.BlackMarketData.BuiedTime;
            this.FBlackMarketTotalData.BlackMarketData.Inited = true;
            _loc8_ = this.FBlackMarketTotalData.BlackMarketData.Inventories;
            _loc10_ = this.FBlackMarketTotalData.BlackMarketData.Configs;
         }
         else
         {
            this.FBlackMarketTotalData.SecretMarketData.CurrentFlashTime = _loc3_.readInt();
            this.FBlackMarketTotalData.SecretMarketData.CurrentGoodBornTime = _loc3_.readInt();
            _loc6_ = this.FBlackMarketTotalData.SecretMarketData.GoodsVec;
            _loc7_ = this.FBlackMarketTotalData.SecretMarketData.BuiedTime;
            this.FBlackMarketTotalData.SecretMarketData.Inited = true;
            _loc8_ = this.FBlackMarketTotalData.SecretMarketData.Inventories;
            _loc10_ = this.FBlackMarketTotalData.SecretMarketData.Configs;
         }
         _loc6_.length = 0;
         _loc7_.length = 0;
         _loc8_.Clear();
         _loc10_.length = 0;
         _loc3_.readInt();
         _loc5_ = _loc3_.readShort();
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_.push(_loc3_.readInt());
            _loc9_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_BlackMarket,_loc6_[_loc4_]) as TBlackMarket;
            if(param1 == CONST_BLACKMARKET.MarketID_BlackMarket && _loc9_.Identifier == 20000001)
            {
               _loc9_.ApplyLocalOffer({
                  "itemID":14100005,
                  "number":50,
                  "price":{
                     "type":0,
                     "code":1,
                     "amount":50
                  },
                  "totalTimes":1
               });
            }
            SToolReward.GetInventoryByIDAmount(_loc9_.ItemID,_loc9_.Number,_loc8_);
            _loc10_.push(_loc9_);
            _loc7_[_loc4_] = param1 == CONST_BLACKMARKET.MarketID_BlackMarket ? _loc3_.readInt() : 0;
            _loc4_++;
         }
         if(param1 == CONST_BLACKMARKET.MarketID_BlackMarket && _loc3_.bytesAvailable > 0)
         {
            this.ApplyServerOffers(_loc3_,_loc8_,_loc10_);
         }
         this.FProcessorWindowMarketMainUI.GoodsInforNotify();
      }
      
      protected function ApplyServerOffers(data:ByteArray, inventories:TInventories, configs:Vector.<TBlackMarket>) : void
      {
         var settings:Object = Json.decode(data.readUTF());
         var offers:Array = settings.offers as Array;
         this.FBlackMarketTotalData.BlackMarketData.ServerRefreshSeconds = int(settings.refreshSeconds);
         var costs:Vector.<Object> = this.FBlackMarketTotalData.BlackMarketData.FlushCosts;
         costs.length = 0;
         var n:int = 0;
         while(n <= this.FBlackMarketTotalData.BlackMarketData.CurrentFlashTime)
         {
            costs.push({
               "type":0,
               "code":1,
               "amount":int(settings.refreshGold)
            });
            n++;
         }
         inventories.Clear();
         var i:int = 0;
         while(i < configs.length)
         {
            if(configs[i] != null && i < offers.length)
            {
               configs[i].ApplyLocalOffer(offers[i]);
               SToolReward.GetInventoryByIDAmount(configs[i].ItemID,configs[i].Number,inventories);
            }
            i++;
         }
      }
      
      public function MallBuyGoodRet(param1:int, param2:TPacket) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = param2.Data.readInt();
         switch(param1)
         {
            case CONST_BLACKMARKET.MarketID_BlackMarket:
               _loc4_ = this.FBlackMarketTotalData.BlackMarketData.GoodsVec.indexOf(_loc3_);
               if(_loc4_ < 0)
               {
                  return;
               }
               this.FBlackMarketTotalData.BlackMarketData.BuiedTime[_loc4_] = param2.Data.bytesAvailable >= 4 ? param2.Data.readInt() : this.FBlackMarketTotalData.BlackMarketData.BuiedTime[_loc4_] + 1;
               break;
            case CONST_BLACKMARKET.MarketID_SecretMarket:
               _loc4_ = this.FBlackMarketTotalData.SecretMarketData.GoodsVec.indexOf(_loc3_);
               ++this.FBlackMarketTotalData.SecretMarketData.BuiedTime[_loc4_];
         }
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_09));
         this.FProcessorWindowMarketMainUI.BuyRetNotify();
      }
      
      protected function PacketPerform_InitInforRet(param1:TPacket) : void
      {
         this.FBlackMarketTotalData.SecretMarketData.SecretMarketState = param1.Data.readByte();
         this.FBlackMarketTotalData.SecretMarketData.SecretMarketOpenTime = param1.Data.readInt();
         this.FBlackMarketTotalData.Inited = true;
         this.FProcessorWindowMarketMainUI.Show(this.FBlackMarketTotalData);
         if(this.FEffectNotification != null && this.FBlackMarketTotalData.SecretMarketData.SecretMarketState == CONST_BLACKMARKET.MarketState_Open)
         {
            this.FEffectNotification(CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_BlackMarket,true);
         }
      }
      
      protected function PacketPerform_OpenMarketNotify(param1:TPacket) : void
      {
         this.FBlackMarketTotalData.SecretMarketData.SecretMarketState = CONST_BLACKMARKET.MarketState_Open;
         this.FBlackMarketTotalData.SecretMarketData.Inited = false;
         if(Visible)
         {
            this.FProcessorWindowMarketMainUI.SecretMarketOpenNotify();
         }
         if(this.FEffectNotification != null)
         {
            this.FEffectNotification(CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_BlackMarket,true);
         }
         if(this.FOnOpenSecretMallNotify != null)
         {
            this.FOnOpenSecretMallNotify(this);
         }
      }
      
      protected function CloseWindows(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function ReqMarketBaseInfor() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_BlackMarket_InitInforReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function set EffectNotification(param1:Function) : void
      {
         this.FEffectNotification = param1;
      }
      
      public function set OnOpenSecretMallNotify(param1:Function) : void
      {
         this.FOnOpenSecretMallNotify = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowMarketMainUI.Load();
            return;
         }
         if(!this.FBlackMarketTotalData.Inited)
         {
            this.ReqMarketBaseInfor();
         }
         else
         {
            this.FProcessorWindowMarketMainUI.Show(this.FBlackMarketTotalData);
         }
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

