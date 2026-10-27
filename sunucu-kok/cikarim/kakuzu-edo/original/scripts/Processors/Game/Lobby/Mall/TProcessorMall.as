package Processors.Game.Lobby.Mall
{
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Achievenment.*;
   import Logics.Characters.*;
   import Logics.Inventories.*;
   import Logics.Purchases.*;
   import Logics.Streamization.Inventories.*;
   import Logics.Streamization.VipShop.TUnstreamizerVipShop;
   import Logics.VipShop.TVipShopData;
   import Logics.VipShop.TVipShopItem;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Rendering.Overlayers.HelpTips.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import flash.utils.*;
   
   public class TProcessorMall extends TProcessorLobbyWindows
   {
      
      public static const SIZE_WindowMall_Width:uint = 794;
      
      public static const SIZE_WindowMall_Height:uint = 400;
      
      public static const SIZE_WindowPopupBox_Width:uint = 280;
      
      public static const SIZE_WindowPopupBox_Height:uint = 226;
      
      public static const TYPE_MODEL_SIGN:uint = CONST_MALL.TYPE_MODEL_SIGN;
      
      public static const TYPE_MODEL_MALL:uint = CONST_MALL.TYPE_MODEL_MALL;
      
      public static const TYPE_MODEL_TREASUREMAP:uint = CONST_MALL.TYPE_MODEL_TREASUREMAP;
      
      public static const TYPE_MODEL_HONORSHOP:uint = CONST_MALL.TYPE_MODEL_HONORSHOP;
      
      public static const CATEGORY_Normal:uint = CONST_INVENTORY.CATEGORY_Normal;
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Gem:uint = CONST_INVENTORY.CATEGORY_Gem;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      public static const CATEGORY_Material:uint = CONST_INVENTORY.CATEGORY_Material;
      
      public static const Window_OffsetX:int = -160;
      
      public static const Window_OffsetY:int = 0;
      
      protected var FCharacter:TCharacter;
      
      protected var FUnstreamizerInventorySamples:TUnstreamizerInventorySamples;
      
      protected var FInventorySamples:TInventorySamples;
      
      protected var FPurchaseRequest:TPurchaseRequest;
      
      protected var FPurchaseParameters:TPurchaseParameters;
      
      protected var FProcessorWindowMall:TProcessorWindowMall;
      
      protected var FOnMallBuy:Function;
      
      protected var FDataVipShop:TVipShopData;
      
      protected var FUnstreamizerVipShop:TUnstreamizerVipShop;
      
      protected var FOnPurchase:Function;
      
      protected var FOnSendPacketToSuperMarket:Function;
      
      protected var FOnPacketHonorShopInitRet:Function;
      
      protected var FOnPacketHonorShopNotifyRet:Function;
      
      public function TProcessorMall(param1:TUIComponent, param2:TLobbyParameters)
      {
         var _loc3_:TBounds = null;
         super(param1,param2);
         this.FCharacter = SLogicsCore.Character;
         this.FInventorySamples = this.FCharacter.InventorySamples;
         this.FUnstreamizerInventorySamples = new TUnstreamizerInventorySamples();
         this.FProcessorWindowMall = new TProcessorWindowMall(this);
         this.FProcessorWindowMall.OnClose = this.ProcessorWindowOnClose;
         this.FProcessorWindowMall.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowMall.SlotOnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowMall.SlotOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowMall.HintOnMove = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowMall.HintOnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FProcessorWindowMall.OnPurchase = this.ProcessorOnPurchase;
         this.FProcessorWindowMall.OnHelpTipsOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FProcessorWindowMall.OnHelpTipsOut = SUtilityOverLayer.UIComponentsHintOnOut;
         _loc3_ = new TBounds();
         _loc3_.Width = SIZE_WindowMall_Width;
         _loc3_.Height = SIZE_WindowMall_Height;
         ComponentBoundsCenter(this.FProcessorWindowMall,_loc3_);
         _loc3_ = null;
         this.FProcessorWindowMall.x += Window_OffsetX;
         this.FProcessorWindowMall.y += Window_OffsetY;
         if(false)
         {
            this.FProcessorWindowMall.x += 50;
         }
         this.ConstructPurchase();
         this.FDataVipShop = new TVipShopData();
         this.FUnstreamizerVipShop = new TUnstreamizerVipShop();
      }
      
      protected function ConstructPurchase() : void
      {
         this.FPurchaseParameters = new TPurchaseParameters();
         this.FPurchaseParameters.RoutineSuccess = this.PurchaseRoutineSuccess;
         this.FPurchaseParameters.RoutineFailure = this.PurchaseRoutineFailure;
         this.FPurchaseParameters.RoutineCancel = this.PurchaseRoutineCancel;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_MALL.RESOURCESID_SWF_MALL);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mall_SuperMarketRet,this.PacketPerform_SC_SuperMarket);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mall_HonorShopRet,this.PacketPerform_SC_HonorShopRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mall_HonorShopNotify,this.PacketPerform_SC_HonorShopNotify);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mall_VipShopRet,this.PACKETID_SC_Mall_VipShopRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Mall_VipShopNotify,this.PACKETID_SC_Mall_VipShopNotify);
      }
      
      protected function PACKETID_SC_Mall_VipShopRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         _loc2_ = param1.Data;
         this.FUnstreamizerVipShop.UnstreamizeVipShopInit(_loc2_,this.FDataVipShop,null);
         if(this.FProcessorWindowMall.Visible)
         {
            this.FProcessorWindowMall.UpdateDataBase(this.FDataVipShop);
         }
      }
      
      protected function PACKETID_SC_Mall_VipShopNotify(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         _loc2_ = param1.Data;
         this.FUnstreamizerVipShop.UnstreamizerVipShopNotify(_loc2_,this.FDataVipShop,null);
         if(this.FProcessorWindowMall.Visible)
         {
            this.FProcessorWindowMall.UpdateDataBase(this.FDataVipShop);
         }
      }
      
      protected function PacketPerform_SC_SuperMarket(param1:TPacket) : void
      {
         if(this.FOnSendPacketToSuperMarket != null)
         {
            this.FOnSendPacketToSuperMarket(param1);
         }
      }
      
      protected function PacketPerform_SC_HonorShopRet(param1:TPacket) : void
      {
         if(this.FOnPacketHonorShopInitRet != null)
         {
            this.FOnPacketHonorShopInitRet(param1);
         }
      }
      
      protected function PacketPerform_SC_HonorShopNotify(param1:TPacket) : void
      {
         if(this.FOnPacketHonorShopNotifyRet != null)
         {
            this.FOnPacketHonorShopNotifyRet(param1);
         }
      }
      
      protected function PurchaseRoutineSuccess() : void
      {
         if(this.FProcessorWindowMall.Visible)
         {
            this.FProcessorWindowMall.UpdatePanelCredits();
         }
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TAVERN_STRING_09));
      }
      
      protected function PurchaseRoutineFailure() : void
      {
      }
      
      protected function PurchaseRoutineCancel() : void
      {
      }
      
      protected function ProcessorWindowOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function ProcessorOnPurchase(param1:Object, param2:TPurchaseRequest, param3:TPurchaseParameters, param4:TInventorySample) : void
      {
         if(this.FOnPurchase != null)
         {
            this.FOnPurchase(param1,param2,param3,param4);
         }
      }
      
      public function get OnPurchase() : Function
      {
         return this.FOnPurchase;
      }
      
      public function set OnPurchase(param1:Function) : void
      {
         this.FOnPurchase = param1;
      }
      
      public function set OnSendPacketToSuperMarket(param1:Function) : void
      {
         this.FOnSendPacketToSuperMarket = param1;
      }
      
      public function get OnPacketHonorShopInitRet() : Function
      {
         return this.FOnPacketHonorShopInitRet;
      }
      
      public function set OnPacketHonorShopInitRet(param1:Function) : void
      {
         this.FOnPacketHonorShopInitRet = param1;
      }
      
      public function get OnPacketHonorShopNotifyRet() : Function
      {
         return this.FOnPacketHonorShopNotifyRet;
      }
      
      public function set OnPacketHonorShopNotifyRet(param1:Function) : void
      {
         this.FOnPacketHonorShopNotifyRet = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowMall.Load();
            return;
         }
         this.FProcessorWindowMall.Update();
         this.Perform_CS_VipShopInitReq();
         this.FProcessorWindowMall.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowMall.Reset();
      }
      
      protected function Perform_CS_VipShopInitReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Mall_VipShopReq);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      public function InitMallData() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:Vector.<TInventorySample> = null;
         var _loc4_:TVipShopItem = null;
         if(this.FInventorySamples.Count == 0)
         {
            this.FUnstreamizerInventorySamples.Unstreamize(null,this.FInventorySamples,null);
         }
         _loc3_ = new Vector.<TInventorySample>();
         _loc2_ = uint(this.FInventorySamples.Count);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FInventorySamples.GetInventorySampleByIndex(_loc1_).Model == 14)
            {
               _loc3_.push(this.FInventorySamples.GetInventorySampleByIndex(_loc1_));
            }
            _loc1_++;
         }
         _loc2_ = _loc3_.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = new TVipShopItem();
            _loc4_.InventorySample = _loc3_[_loc1_];
            this.FDataVipShop.InventoryItems[_loc1_] = _loc4_;
            _loc1_++;
         }
      }
      
      public function AchievementInforUpdateNotify(param1:TAchievementInfor) : void
      {
         this.FProcessorWindowMall.AchievementInforUpdateNotify(param1);
      }
   }
}

