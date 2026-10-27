package Processors.Game.Lobby.Mall.Components
{
   import Components.Slots.TUISlot;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.TConfigValue;
   import Logics.Inventories.TInventorySample;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.CONST_DATEBASEVO;
   import Resources.Constants.CONST_LOBBY;
   import Resources.Constants.CONST_MALL;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TUIMallItem extends TUIComponent
   {
      
      protected static const CurrentFrame_New:uint = 1;
      
      protected static const CurrentFrame_Hot:uint = 2;
      
      protected var FContext:TInventorySample;
      
      protected var FMallItem:MovieClip;
      
      protected var FTF_GoodsName:TextField;
      
      protected var FMC_HotOrNew:MovieClip;
      
      protected var FMC_SelectBox:Sprite;
      
      protected var FMC_Slot:TUISlot;
      
      protected var FMC_Price:Sprite;
      
      protected var FMC_SpecialPrice:Sprite;
      
      protected var FMC_NormalPrice:Sprite;
      
      protected var FMC_Bar:Sprite;
      
      protected var FTF_DiscountPrice:TextField;
      
      protected var FTF_VIPPrice:TextField;
      
      protected var FTF_NowPrice:TextField;
      
      protected var FTF_OriginalPrice:TextField;
      
      protected var FMC_Background:MovieClip;
      
      protected var FTF_NormalPrice:TextField;
      
      protected var FIsInitialization:Boolean;
      
      protected var FYellowDiamondDiscount:int;
      
      protected var FItemOnClick:Function;
      
      protected var FSlotOnOut:Function;
      
      protected var FSlotOnOver:Function;
      
      protected var FOnQuerySequenceContext:Function;
      
      protected var FSubstrate:MovieClip;
      
      public function TUIMallItem(param1:TUIComponent)
      {
         super(param1);
         this.FIsInitialization = false;
      }
      
      protected function Resources_UIDispatch() : void
      {
         var _loc1_:TConfigValue = null;
         this.FMallItem = this.FSubstrate;
         this.FMC_Background = this.FMallItem[CONST_MALL.RESOURCE_Link_MC_Background];
         this.FTF_GoodsName = this.FMallItem[CONST_MALL.RESOURCE_Link_TF_GoodsName];
         this.FTF_GoodsName.mouseEnabled = false;
         this.FMC_HotOrNew = this.FMallItem[CONST_MALL.RESOURCE_Link_MC_HotOrNew];
         this.FMC_Slot = new TUISlot(this);
         this.FMC_Slot.Resource = this.FMallItem[CONST_MALL.RESOURCE_Link_MC_Slot];
         this.FMC_Slot.SequenceDefaultIcon = SResourcesCore.TexturesLobby.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_SlotDefaultEffect,0);
         this.FMC_Slot.OnQuerySequenceContext = this.FOnQuerySequenceContext;
         this.FMC_Slot.OnOver = this.FSlotOnOver;
         this.FMC_Slot.OnOut = this.FSlotOnOut;
         this.FMC_Slot.Init();
         this.FMC_Price = this.FMallItem[CONST_MALL.RESOURCE_Link_MC_Price];
         this.FMC_SpecialPrice = this.FMC_Price[CONST_MALL.RESOURCE_Link_MC_SpecialPrice];
         this.FMC_Bar = this.FMC_SpecialPrice[CONST_MALL.RESOURCE_Link_MC_Bar];
         this.FTF_DiscountPrice = this.FMC_SpecialPrice[CONST_MALL.RESOURCE_Link_TF_DiscountPrice];
         this.FTF_DiscountPrice.mouseEnabled = false;
         this.FTF_VIPPrice = this.FMC_SpecialPrice[CONST_MALL.RESOURCE_Link_TF_VIPPrice];
         this.FTF_VIPPrice.mouseEnabled = false;
         this.FTF_NowPrice = this.FMC_SpecialPrice[CONST_MALL.RESOURCE_Link_TF_NowPrice];
         this.FTF_NowPrice.mouseEnabled = false;
         this.FTF_OriginalPrice = this.FMC_SpecialPrice[CONST_MALL.RESOURCE_Link_TF_OriginalPrice];
         this.FTF_OriginalPrice.mouseEnabled = false;
         this.FMC_NormalPrice = this.FMC_Price[CONST_MALL.RESOURCE_Link_MC_NormalPrice];
         this.FTF_NormalPrice = this.FMC_NormalPrice[CONST_MALL.RESOURCE_Link_TF_NormallPrice];
         _loc1_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,99990001) as TConfigValue;
         if(_loc1_ != null)
         {
            this.FYellowDiamondDiscount = _loc1_.Value as int;
         }
      }
      
      protected function Resources_UILocations() : void
      {
         this.FMallItem.addEventListener(MouseEvent.MOUSE_OVER,this.ItemOnOver,false,0,true);
         this.FMallItem.addEventListener(MouseEvent.MOUSE_OUT,this.ItemOnOut,false,0,true);
         this.FMallItem.addEventListener(MouseEvent.MOUSE_DOWN,this.ItemOnDown,false,0,true);
         this.FMallItem.addEventListener(MouseEvent.MOUSE_UP,this.ItemOnUp,false,0,true);
      }
      
      protected function ItemOnOver(param1:MouseEvent) : void
      {
         this.FMC_Background.gotoAndStop("over");
      }
      
      protected function ItemOnOut(param1:MouseEvent) : void
      {
         this.FMC_Background.gotoAndStop("up");
      }
      
      protected function ItemOnDown(param1:MouseEvent) : void
      {
         this.FMC_Background.gotoAndStop("up");
      }
      
      protected function ItemOnUp(param1:MouseEvent) : void
      {
         this.FMC_Background.gotoAndStop("up");
         if(this.FItemOnClick != null)
         {
            this.FItemOnClick(this,this.FContext);
         }
      }
      
      protected function UpdateMallItemInfo() : void
      {
         var _loc1_:uint = 0;
         if(this.FContext.IsHot)
         {
            _loc1_ = CurrentFrame_Hot;
         }
         else if(this.FContext.IsNew)
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
         this.FTF_GoodsName.text = this.FContext.Name;
         this.FMC_Slot.Context = this.FContext.Inventory;
         this.SetPrice();
      }
      
      protected function SetPrice() : void
      {
         if(this.FContext.IsNew)
         {
            this.FMC_NormalPrice.visible = true;
            this.FMC_SpecialPrice.visible = false;
            this.FTF_NormalPrice.text = this.FContext.CostGold.toString();
         }
         else
         {
            this.FMC_NormalPrice.visible = false;
            this.FMC_SpecialPrice.visible = true;
            this.FTF_OriginalPrice.text = this.FContext.CostGold.toString();
            if(this.FContext.IsHot)
            {
               this.FMC_Bar.visible = true;
               this.FTF_NowPrice.text = this.FContext.HotPrice.toString();
               this.FTF_DiscountPrice.visible = true;
               this.FTF_VIPPrice.visible = false;
               this.FTF_DiscountPrice.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_MALL_01);
            }
            else
            {
               if(this.FContext.VipLevel <= SLogicsCore.Character.VipLevel && this.FContext.VipLevel != 0)
               {
                  this.FMC_Bar.visible = true;
                  this.FTF_DiscountPrice.visible = false;
                  this.FTF_VIPPrice.visible = true;
               }
               else
               {
                  this.FMC_Bar.visible = false;
                  this.FTF_DiscountPrice.visible = false;
                  this.FTF_VIPPrice.visible = true;
               }
               this.FTF_NowPrice.text = this.FContext.Discount.toString();
            }
         }
      }
      
      public function get Context() : TInventorySample
      {
         return this.FContext;
      }
      
      public function set Context(param1:TInventorySample) : void
      {
         if(param1 != this.FContext)
         {
            this.FContext = param1;
            this.FMC_Slot.Context = null;
            if(param1 != null)
            {
               this.FMC_Slot.Context = param1.Inventory;
               this.UpdateMallItemInfo();
            }
         }
      }
      
      public function get ItemOnClick() : Function
      {
         return this.FItemOnClick;
      }
      
      public function set ItemOnClick(param1:Function) : void
      {
         this.FItemOnClick = param1;
      }
      
      public function get SlotOnOut() : Function
      {
         return this.FSlotOnOut;
      }
      
      public function set SlotOnOut(param1:Function) : void
      {
         this.FSlotOnOut = param1;
      }
      
      public function get SlotOnOver() : Function
      {
         return this.FSlotOnOver;
      }
      
      public function set SlotOnOver(param1:Function) : void
      {
         this.FSlotOnOver = param1;
      }
      
      public function get OnQuerySequenceContext() : Function
      {
         return this.FOnQuerySequenceContext;
      }
      
      public function set OnQuerySequenceContext(param1:Function) : void
      {
         this.FOnQuerySequenceContext = param1;
      }
      
      public function get Substrate() : MovieClip
      {
         return this.FSubstrate;
      }
      
      public function set Substrate(param1:MovieClip) : void
      {
         this.FSubstrate = param1;
      }
      
      public function Perform_UIDispatch() : void
      {
         this.Resources_UIDispatch();
         this.Resources_UILocations();
         this.FIsInitialization = true;
      }
      
      public function UpdateSlot() : void
      {
         this.FMC_Slot.Update();
      }
   }
}

