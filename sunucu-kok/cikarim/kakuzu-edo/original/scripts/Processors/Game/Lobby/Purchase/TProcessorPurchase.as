package Processors.Game.Lobby.Purchase
{
   import Components.Slots.*;
   import Components.Standard.*;
   import Foundation.Network.*;
   import Foundation.Queries.Textures.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Inventories.*;
   import Logics.Purchases.*;
   import Processors.Game.Common.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Processors.Game.Utilities.OverLayer.*;
   import Processors.Game.Windows.Information.*;
   import Rendering.Overlayers.*;
   import Rendering.Overlayers.Inventories.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorPurchase extends TProcessorOverView
   {
      
      protected static const CurrentFrame_New:uint = 1;
      
      protected static const CurrentFrame_Hot:uint = 2;
      
      public static const CATEGORY_Normal:uint = CONST_INVENTORY.CATEGORY_Normal;
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Gem:uint = CONST_INVENTORY.CATEGORY_Gem;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      public static const CATEGORY_Material:uint = CONST_INVENTORY.CATEGORY_Material;
      
      public static const Window_Width:int = 280;
      
      public static const Window_Height:int = 226;
      
      protected var FUIWindowRecharge:TUIWindowRecharge;
      
      protected var FPurchaseRequest:TPurchaseRequest;
      
      protected var FPurchaseParameters:TPurchaseParameters;
      
      protected var FModalLayer:Sprite;
      
      protected var FPopupBox:Sprite;
      
      protected var FMC_HotOrNew:MovieClip;
      
      protected var FMC_Slot:TUISlot;
      
      protected var FTF_GoodsName:TextField;
      
      protected var FBtn_Reduce:SimpleButton;
      
      protected var FBtn_Add:SimpleButton;
      
      protected var FTF_GoodsNum:TextField;
      
      protected var FMC_Price:Sprite;
      
      protected var FMC_SpecialPrice:Sprite;
      
      protected var FMC_NormalPrice:Sprite;
      
      protected var FTF_NormalPrice:TextField;
      
      protected var FMC_Bar:Sprite;
      
      protected var FTF_DiscountPrice:TextField;
      
      protected var FMC_VIP:MovieClip;
      
      protected var FMC_NowPrice:MovieClip;
      
      protected var FTF_NowPrice:TextField;
      
      protected var FTF_NowVIP:TextField;
      
      protected var FTF_OriginalPrice:TextField;
      
      protected var FBtn_Confirm:TUIButton;
      
      protected var FBtn_Cancel:TUIButton;
      
      protected var FBtn_BecomeVIP:TUIButton;
      
      protected var FMC_MoneyIcon:MovieClip;
      
      protected var FInventorySample:TInventorySample;
      
      protected var FGoodsNum:int;
      
      protected var FCurrentPrice:uint;
      
      protected var FTotalPrice:uint;
      
      protected var FOnOpenVIP:Function;
      
      public function TProcessorPurchase(param1:TUIComponent)
      {
         super(param1);
         this.FMC_Slot = new TUISlot(this);
         this.FGoodsNum = 1;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfCommon.LoadPrimary(CONST_COMMON.RESOURCESID_SwfCommon_Common);
         SResourcesCore.TexturesSwfCommon.LoadPrimary(CONST_COMMON.RESOURCESID_SwfCommon_ViewHeroInfo);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.FModalLayer = new Sprite();
         addChild(this.FModalLayer);
         this.FModalLayer.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FPopupBox = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_ClassName_MC_Purchase) as Sprite;
         addChild(this.FPopupBox);
         this.FPopupBox.x = CONST_COMMON.STAGE_Width - Window_Width >> 1;
         this.FPopupBox.y = CONST_COMMON.STAGE_Height - Window_Height >> 1;
         this.FMC_HotOrNew = this.FPopupBox[CONST_MALL.RESOURCE_Link_MC_HotOrNew];
         this.FMC_Slot.Resource = this.FPopupBox[CONST_MALL.RESOURCE_Link_MC_Slot];
         this.FMC_Slot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FMC_Slot.OnQuerySequenceContext = this.SlotsOnQuerySequenceContext;
         this.FMC_Slot.OnOver = SUtilityOverLayer.UIComponentsHintOnOver;
         this.FMC_Slot.OnOut = SUtilityOverLayer.UIComponentsHintOnOut;
         this.FMC_Slot.Init();
         this.FTF_GoodsName = this.FPopupBox[CONST_MALL.RESOURCE_Link_TF_GoodsName];
         this.FTF_GoodsName.mouseEnabled = false;
         this.FTF_GoodsName.autoSize = "left";
         this.FTF_GoodsNum = this.FPopupBox[CONST_MALL.RESOURCE_Link_TF_GoodsNum];
         this.FTF_GoodsNum.restrict = "0-9";
         this.FTF_GoodsNum.maxChars = 5;
         this.FBtn_Confirm = new TUIButton();
         this.FBtn_Confirm.Substrate = this.FPopupBox[CONST_MALL.RESOURCE_Link_BTN_Confirm];
         this.FBtn_Confirm.OnClick = this.BtnConfirmOnClick;
         this.FBtn_Cancel = new TUIButton();
         this.FBtn_Cancel.Substrate = this.FPopupBox[CONST_MALL.RESOURCE_Link_BTN_Cancel];
         this.FBtn_Cancel.OnClick = this.BtnCancelOnClick;
         this.FBtn_Add = this.FPopupBox[CONST_MALL.RESOURCE_Link_BTN_Add];
         this.FBtn_Reduce = this.FPopupBox[CONST_MALL.RESOURCE_Link_BTN_Reduce];
         this.FMC_Price = this.FPopupBox[CONST_MALL.RESOURCE_Link_MC_Price];
         this.FMC_SpecialPrice = this.FMC_Price[CONST_MALL.RESOURCE_Link_MC_SpecialPrice];
         this.FMC_Bar = this.FMC_SpecialPrice[CONST_MALL.RESOURCE_Link_MC_Bar];
         this.FTF_OriginalPrice = this.FMC_SpecialPrice[CONST_MALL.RESOURCE_Link_TF_OriginalPrice];
         this.FTF_OriginalPrice.mouseEnabled = false;
         this.FTF_DiscountPrice = this.FMC_SpecialPrice[CONST_MALL.RESOURCE_Link_TF_DiscountPrice];
         this.FTF_DiscountPrice.mouseEnabled = false;
         this.FMC_VIP = this.FMC_SpecialPrice[CONST_MALL.RESOURCE_Link_MC_VIP];
         this.FBtn_BecomeVIP = new TUIButton();
         this.FBtn_BecomeVIP.Substrate = this.FMC_SpecialPrice[CONST_MALL.RESOURCE_Link_BTN_BecomeVIP];
         this.FBtn_BecomeVIP.OnClick = this.Btn_BecomeVIPOnClick;
         this.FMC_NowPrice = this.FMC_SpecialPrice[CONST_MALL.RESOURCE_Link_MC_NowPrice];
         this.FTF_NowPrice = this.FMC_NowPrice[CONST_MALL.RESOURCE_Link_TF_NowPrice];
         this.FTF_NowPrice.mouseEnabled = false;
         this.FTF_NowVIP = this.FMC_NowPrice[CONST_MALL.RESOURCE_Link_TF_NoVIP];
         this.FTF_NowVIP.mouseEnabled = false;
         this.FMC_NormalPrice = this.FMC_Price[CONST_MALL.RESOURCE_Link_MC_NormalPrice];
         this.FTF_NormalPrice = this.FMC_NormalPrice[CONST_MALL.RESOURCE_Link_TF_NormallPrice];
         this.FTF_NormalPrice.mouseEnabled = false;
         this.FMC_MoneyIcon = this.FMC_NormalPrice[CONST_MALL.RESOURCE_Link_MC_MoneyIcon];
         this.FUIWindowRecharge = SUtilityOverLayer.UIWindowRecharge;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Reduce.addEventListener(MouseEvent.CLICK,this.BtnReduceOnClick,false,0,true);
         this.FBtn_Add.addEventListener(MouseEvent.CLICK,this.BtnAddOnClick,false,0,true);
         this.FTF_GoodsNum.addEventListener(Event.CHANGE,this.TF_GoodsNumOnTextInput,false,0,true);
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FPopupBox == null || !this.Visible)
         {
            return;
         }
         if(this.FMC_Slot != null)
         {
            this.FMC_Slot.Update();
         }
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_PurchaseRet,this.PerformPacket_SC_PurchaseRet);
      }
      
      protected function PerformPacket_SC_PurchaseRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:int = 0;
         var _loc4_:Function = null;
         var _loc5_:Function = null;
         _loc2_ = param1.Data;
         _loc3_ = int(_loc2_.readUnsignedInt());
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            _loc5_ = this.FPurchaseParameters.RoutineFailure;
            if(_loc5_ != null)
            {
               _loc5_();
            }
            return;
         }
         _loc4_ = this.FPurchaseParameters.RoutineSuccess;
         if(_loc4_ != null)
         {
            _loc4_();
         }
      }
      
      protected function UpdateUISlot() : void
      {
         var _loc1_:uint = 0;
         this.FMC_Slot.Context = this.FInventorySample.Inventory;
         this.FTF_GoodsName.text = this.FInventorySample.Name;
         this.FTF_GoodsNum.text = this.FGoodsNum.toString();
         if(this.FInventorySample.IsHot)
         {
            _loc1_ = CurrentFrame_Hot;
         }
         else if(this.FInventorySample.IsNew)
         {
            _loc1_ = CurrentFrame_New;
         }
         else
         {
            _loc1_ = 0;
         }
         if(_loc1_ != 0)
         {
            this.FMC_HotOrNew.gotoAndStop(_loc1_);
            this.FMC_HotOrNew.visible = true;
         }
         else
         {
            this.FMC_HotOrNew.visible = false;
         }
      }
      
      protected function UpdateUIPurchase() : void
      {
         this.FTF_GoodsNum.text = this.FGoodsNum.toString();
         if(this.FInventorySample.IsNew || this.FInventorySample.Model == CONST_MALL.TYPE_MODEL_STONESHOP)
         {
            this.FBtn_BecomeVIP.Visible = false;
            this.FMC_NormalPrice.visible = true;
            this.FMC_SpecialPrice.visible = false;
            if(this.FInventorySample.Model == CONST_MALL.TYPE_MODEL_STONESHOP)
            {
               this.FTF_NormalPrice.text = (this.FInventorySample.Integration * this.FGoodsNum).toString();
               this.FCurrentPrice = this.FInventorySample.Integration;
               this.FTotalPrice = uint(this.FTF_NormalPrice.text);
            }
            else
            {
               this.FTF_NormalPrice.text = (this.FInventorySample.HotPrice * this.FGoodsNum).toString();
               this.FCurrentPrice = this.FInventorySample.HotPrice;
               this.FTotalPrice = uint(this.FTF_NormalPrice.text);
            }
            this.FMC_MoneyIcon != null && (this.FMC_MoneyIcon.visible = this.FInventorySample.Model != CONST_MALL.TYPE_MODEL_STONESHOP);
         }
         else
         {
            this.FMC_NormalPrice.visible = false;
            this.FMC_SpecialPrice.visible = true;
            this.FTF_OriginalPrice.text = (this.FInventorySample.CostGold * this.FGoodsNum).toString();
            this.FTotalPrice = uint(this.FTF_OriginalPrice.text);
            if(this.FInventorySample.IsHot)
            {
               this.FBtn_BecomeVIP.Visible = false;
               this.FMC_Bar.visible = true;
               this.FTF_NowPrice.text = (this.FInventorySample.HotPrice * this.FGoodsNum).toString();
               this.FTF_DiscountPrice.visible = true;
               this.FMC_VIP.visible = false;
               this.FTF_NowPrice.visible = true;
               this.FTF_NowVIP.visible = false;
               this.FCurrentPrice = this.FInventorySample.HotPrice;
               this.FTotalPrice = uint(this.FTF_NowPrice.text);
            }
            else
            {
               this.FTF_DiscountPrice.visible = false;
               this.FMC_VIP.visible = true;
               if(this.FInventorySample.VipLevel <= SLogicsCore.Character.VipLevel && this.FInventorySample.VipLevel != 0)
               {
                  this.FBtn_BecomeVIP.Visible = false;
                  this.FMC_Bar.visible = true;
                  this.FMC_VIP.gotoAndStop(1);
                  this.FTF_NowPrice.text = (this.FInventorySample.Discount * this.FGoodsNum).toString();
                  this.FTF_NowPrice.visible = true;
                  this.FTF_NowVIP.visible = false;
                  this.FCurrentPrice = this.FInventorySample.Discount;
                  this.FTotalPrice = uint(this.FTF_NowPrice.text);
               }
               else
               {
                  this.FBtn_BecomeVIP.Visible = true;
                  this.FMC_Bar.visible = false;
                  this.FMC_VIP.gotoAndStop(2);
                  this.FTF_NowVIP.text = (this.FInventorySample.Discount * this.FGoodsNum).toString();
                  this.FCurrentPrice = this.FInventorySample.CostGold;
                  this.FTF_NowVIP.visible = true;
                  this.FTF_NowPrice.visible = false;
               }
            }
         }
      }
      
      protected function PacketPerform_CS_PurchaseReq(param1:TPurchaseRequest) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:TPacket = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_PurchaseReq);
         _loc2_ = _loc3_.Data;
         _loc2_.writeUnsignedInt(param1.IDTemplate);
         _loc2_.writeShort(param1.Quantity);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function ProcessorCloseWindow() : void
      {
         this.Visible = false;
         this.Reset();
      }
      
      public function Reset() : void
      {
         this.FInventorySample = null;
         this.FMC_Slot.Context = null;
      }
      
      protected function BtnReduceOnClick(param1:MouseEvent) : void
      {
         --this.FGoodsNum;
         if(this.FGoodsNum <= 0)
         {
            this.FGoodsNum = 1;
         }
         this.UpdateUIPurchase();
      }
      
      protected function BtnAddOnClick(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         ++this.FGoodsNum;
         this.UpdateUIPurchase();
         if(this.FInventorySample.Model == CONST_MALL.TYPE_MODEL_STONESHOP)
         {
            _loc3_ = SLogicsCore.Character.Appliances.GetCountByTempleteID(CONST_GONGFUFIGHT.StoneID) / this.FInventorySample.Integration;
         }
         else
         {
            _loc3_ = (SLogicsCore.Character.CreditGold + SLogicsCore.Character.CreditGiftCertificate) / this.FCurrentPrice;
         }
         _loc4_ = uint(this.FInventorySample.BuyTimesTotal);
         _loc2_ = _loc3_ > _loc4_ && _loc4_ != 0 ? _loc4_ : _loc3_;
         if(_loc2_ <= 0)
         {
            this.FGoodsNum = 1;
            this.UpdateUIPurchase();
            return;
         }
         if(this.FGoodsNum > _loc2_)
         {
            this.FGoodsNum = _loc2_;
            this.UpdateUIPurchase();
         }
      }
      
      protected function BtnConfirmOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TPurchaseRequest = null;
         var _loc5_:int = 0;
         _loc3_ = SLogicsCore.Character.CreditGold + SLogicsCore.Character.CreditGiftCertificate;
         if(this.FInventorySample.Model == CONST_MALL.TYPE_MODEL_STONESHOP)
         {
            _loc5_ = int(SLogicsCore.Character.Appliances.GetCountByTempleteID(this.FInventorySample.Items.Code));
            if(this.FTotalPrice > _loc5_)
            {
               EffectGenerateTextByErrorCode(21);
               return;
            }
         }
         else if(this.FTotalPrice > _loc3_)
         {
            this.FUIWindowRecharge.Visible = true;
            return;
         }
         _loc4_ = SLogicsCore.PoolPurchase.AcquirePurchaseRequest();
         _loc4_.IDTemplate = this.FInventorySample.Indentifier;
         _loc4_.Quantity = this.FGoodsNum;
         this.PacketPerform_CS_PurchaseReq(_loc4_);
         this.ProcessorCloseWindow();
      }
      
      protected function BtnCancelOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Function = null;
         _loc3_ = this.FPurchaseParameters.RoutineCancel;
         if(_loc3_ != null)
         {
            _loc3_();
         }
         this.ProcessorCloseWindow();
      }
      
      protected function Btn_BecomeVIPOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.BtnCancelOnClick(this,null);
         if(this.FOnOpenVIP != null)
         {
            this.FOnOpenVIP(this);
         }
      }
      
      protected function TF_GoodsNumOnTextInput(param1:Event) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         this.FGoodsNum = uint(this.FTF_GoodsNum.text) > 0 ? int(uint(this.FTF_GoodsNum.text)) : 1;
         this.UpdateUIPurchase();
         _loc3_ = (SLogicsCore.Character.CreditGold + SLogicsCore.Character.CreditGiftCertificate) / this.FCurrentPrice;
         _loc4_ = uint(this.FInventorySample.BuyTimesTotal);
         _loc2_ = _loc3_ > _loc4_ && _loc4_ != 0 ? _loc4_ : _loc3_;
         if(this.FGoodsNum > _loc2_)
         {
            this.FGoodsNum = _loc2_;
            this.UpdateUIPurchase();
         }
      }
      
      protected function SlotsOnQuerySequenceContext(param1:Object, param2:Object, param3:TQueryAnimationSequence, param4:uint = 0) : void
      {
         var _loc5_:TInventory = null;
         var _loc6_:TResourceRepositoryTexture = null;
         var _loc7_:TTexture = null;
         _loc5_ = param2 as TInventory;
         _loc6_ = SResourcesCore.TexturesInventory;
         _loc7_ = _loc6_.GetTextureByIdentifier(_loc5_.IDTexture);
         if(_loc7_ != null)
         {
            param3.Value = _loc7_.GetAnimationSequenceByIdentifier(param4);
         }
         else
         {
            _loc6_.LoadSecondary(_loc5_.IDTexture);
         }
      }
      
      public function get OnOpenVIP() : Function
      {
         return this.FOnOpenVIP;
      }
      
      public function set OnOpenVIP(param1:Function) : void
      {
         this.FOnOpenVIP = param1;
      }
      
      public function Purchase(param1:TPurchaseRequest, param2:TPurchaseParameters, param3:TInventorySample = null) : void
      {
         var _loc4_:TInventorySample = null;
         this.FPurchaseRequest = param1;
         this.FPurchaseParameters = param2;
         if(param3 != null)
         {
            _loc4_ = param3 as TInventorySample;
            this.FInventorySample = _loc4_;
            this.FGoodsNum = 1;
            this.UpdateUISlot();
            this.UpdateUIPurchase();
            this.Visible = true;
         }
         else
         {
            this.PacketPerform_CS_PurchaseReq(param1);
         }
      }
   }
}

