package Processors.Game.Lobby.SuperMarket
{
   import Foundation.Common.TBounds;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Achievenment.TAchievementInfor;
   import Logics.Purchases.TPurchaseParameters;
   import Logics.Purchases.TPurchaseRequest;
   import Logics.SuperMarket.TSuperMarketData;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Resources.Constants.CONST_NETWORK;
   import Resources.Constants.CONST_SHORTCUTS;
   import Resources.Constants.CONST_SUPERMARKET;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.utils.ByteArray;
   
   public class TProcessorSuperMarket extends TProcessorLobbyWindows
   {
      
      protected static const UIWIDTH:int = 745;
      
      protected static const UIHEIGHT:int = 456;
      
      protected static const OffsetX:int = 70;
      
      protected var FProcessorWindowSuperMarket:TProcessorWindowSuperMarket;
      
      protected var FBounds:TBounds;
      
      protected var FSuperMarketData:TSuperMarketData;
      
      protected var FAlreadyBuiedID:Vector.<uint>;
      
      protected var FOnShutDownFunction:Function;
      
      protected var FOnPurchase:Function;
      
      public function TProcessorSuperMarket(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FSuperMarketData = new TSuperMarketData();
         this.FProcessorWindowSuperMarket = new TProcessorWindowSuperMarket(this);
         this.FProcessorWindowSuperMarket.SuperMarketData = this.FSuperMarketData;
         this.FProcessorWindowSuperMarket.OnClose = this.ProcessorWindowSuperMarketOnClose;
         this.FProcessorWindowSuperMarket.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowSuperMarket.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowSuperMarket.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowSuperMarket.OnPurchase = this.ProcessorOnPurchase;
         this.FProcessorWindowSuperMarket.OnRequestMarketState = this.RequestMarketState;
         this.FBounds = new TBounds();
         this.FBounds.Width = UIWIDTH;
         this.FBounds.Height = UIHEIGHT;
         ComponentBoundsCenter(this.FProcessorWindowSuperMarket,this.FBounds);
         this.FBounds = null;
         this.FProcessorWindowSuperMarket.x += OffsetX;
         this.FAlreadyBuiedID = new Vector.<uint>();
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_SUPERMARKET.RESOURCESID_SUPERMARKET);
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
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mall_SuperMarketRet,this.PacketPerform_SC_SuperMarketStateRet);
      }
      
      protected function PacketPerform_SC_MallBuy(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
         }
         else
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_09));
         }
         this.RequestMarketState();
         this.FProcessorWindowSuperMarket.BuySuccessNotify();
      }
      
      protected function PacketPerform_SC_SuperMarketStateRet(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Vector.<uint> = null;
         _loc2_ = param1.Data.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
         }
         else
         {
            this.FAlreadyBuiedID.length = 0;
            _loc4_ = param1.Data.readShort();
            if(_loc4_ == 7 && this.FOnShutDownFunction != null)
            {
               this.FOnShutDownFunction(this,CONST_SHORTCUTS.POSITION_SecondaryFunctionC,CONST_SHORTCUTS.TYPE_SecondaryFunctionC_SuperMarket);
            }
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               _loc6_ = int(param1.Data.readUnsignedInt());
               param1.Data.readUnsignedInt();
               _loc7_ = CONST_SUPERMARKET.GiftBagIDMallID;
               _loc5_ = _loc7_.indexOf(_loc6_);
               if(_loc5_ != -1)
               {
                  this.FSuperMarketData.AlreadyBuySuitID = _loc6_;
               }
               else
               {
                  _loc7_ = CONST_SUPERMARKET.ArmMallID;
                  _loc5_ = _loc7_.indexOf(_loc6_);
                  if(_loc5_ != -1)
                  {
                     this.FSuperMarketData.AlreadyBuyArmID = _loc6_;
                  }
                  else
                  {
                     this.FSuperMarketData.AlreadyBuyEquipID.push(_loc6_);
                  }
               }
               _loc3_++;
            }
            this.FSuperMarketData.LoadCompelet = true;
            this.FProcessorWindowSuperMarket.Update();
            if(visible)
            {
               this.FProcessorWindowSuperMarket.visible = true;
            }
         }
      }
      
      protected function ProcessorWindowSuperMarketOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function ProcessorOnPurchase(param1:Object, param2:TPurchaseRequest, param3:TPurchaseParameters) : void
      {
         if(this.FOnPurchase != null)
         {
            this.FOnPurchase(param1,param2,param3);
         }
      }
      
      public function set OnShutDownFunction(param1:Function) : void
      {
         this.FOnShutDownFunction = param1;
      }
      
      public function get OnPurchase() : Function
      {
         return this.FOnPurchase;
      }
      
      public function set OnPurchase(param1:Function) : void
      {
         this.FOnPurchase = param1;
      }
      
      public function RequestMarketState() : void
      {
         var _loc1_:ByteArray = null;
         var _loc2_:TPacket = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Mall_SuperMarketReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.RequestMarketState();
            this.FProcessorWindowSuperMarket.Load();
            return;
         }
         if(this.FSuperMarketData.LoadCompelet)
         {
            this.FProcessorWindowSuperMarket.Update();
            this.FProcessorWindowSuperMarket.visible = true;
         }
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowSuperMarket.Reset();
      }
      
      public function AchievementInforUpdateNotify(param1:TAchievementInfor) : void
      {
         this.FProcessorWindowSuperMarket.AchievementInforUpdateNotify(param1);
      }
   }
}

