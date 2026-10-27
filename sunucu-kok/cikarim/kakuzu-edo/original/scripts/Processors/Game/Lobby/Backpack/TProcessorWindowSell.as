package Processors.Game.Lobby.Backpack
{
   import Components.Standard.TUIButton;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TProcessorWindowSell extends TProcessorLobbyWindow
   {
      
      protected static const CAPACITY_Item:uint = CONST_BACKPACK.CAPACITY_MC_ItemCaptions;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FMC_Item:Vector.<MovieClip>;
      
      protected var FTF_ItemCaptions:Vector.<TextField>;
      
      protected var FTF_ItemQuantities:Vector.<TextField>;
      
      protected var FMC_Btn_AllSale:TUIButton;
      
      protected var FInventories:TInventories;
      
      protected var FOnInventoryOver:Function;
      
      protected var FOnInventoryOut:Function;
      
      protected var FOnAllSell:Function;
      
      protected var FOnInventoryClick:Function;
      
      public function TProcessorWindowSell(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_BACKPACK.RESOURCESID_Swf_Backpack);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:MovieClip = null;
         this.FMC_Item = new Vector.<MovieClip>(CAPACITY_Item);
         this.FTF_ItemCaptions = new Vector.<TextField>(CAPACITY_Item);
         this.FTF_ItemQuantities = new Vector.<TextField>(CAPACITY_Item);
         this.FInventories = new TInventories();
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_BACKPACK.RESOURCE_ClassName_MC_Sell) as Sprite;
         addChild(_loc2_);
         this.FBtn_Close = _loc2_[CONST_COMMON.RESOURCE_Link_Btn_Close];
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Item)
         {
            _loc3_ = _loc2_[CONST_BACKPACK.RESOURCE_Link_MC_ItemCaptions + _loc1_];
            this.FTF_ItemCaptions[_loc1_] = _loc3_[CONST_BACKPACK.RESOURCE_Link_TF_ItemCaption];
            this.FTF_ItemQuantities[_loc1_] = _loc3_[CONST_BACKPACK.RESOURCE_Link_TF_ItemQuantity];
            _loc3_.addEventListener(MouseEvent.CLICK,this.ItemOnClick,false,0,true);
            _loc3_.addEventListener(MouseEvent.MOUSE_MOVE,this.ItemOnMove,false,0,true);
            _loc3_.addEventListener(MouseEvent.MOUSE_OUT,this.ItemOnOut,false,0,true);
            this.FMC_Item[_loc1_] = _loc3_;
            _loc3_.gotoAndStop(_loc1_ % 2 + 1);
            this.SetItemCaptionByIndex(_loc1_,"","");
            _loc1_++;
         }
         this.FMC_Btn_AllSale = new TUIButton();
         this.FMC_Btn_AllSale.Substrate = _loc2_[CONST_BACKPACK.RESOURCE_Link_MC_Btn_AllSale];
         this.FMC_Btn_AllSale.OnClick = this.BtnAllSellOnClick;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.BtnCloseOnClick,false,0,true);
         super.ResourcesPerform_UILocations();
      }
      
      protected function SetItemCaptionByIndex(param1:int, param2:String, param3:String) : void
      {
         var _loc4_:TextField = null;
         var _loc5_:TextField = null;
         _loc4_ = this.FTF_ItemCaptions[param1];
         _loc4_.text = param2;
         _loc5_ = this.FTF_ItemQuantities[param1];
         _loc5_.text = param3;
      }
      
      protected function ClearAllItemCaption() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TInventory = null;
         _loc2_ = this.FInventories.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FInventories.GetInventoryByIndex(_loc1_);
            _loc3_.IsSelling = false;
            this.ClearItemCaptionByIndex(_loc1_);
            _loc1_++;
         }
         this.FInventories.Clear();
      }
      
      protected function ClearItemCaptionByIndex(param1:int) : void
      {
         var _loc2_:TextField = null;
         var _loc3_:TextField = null;
         _loc2_ = this.FTF_ItemCaptions[param1];
         _loc2_.text = "";
         _loc3_ = this.FTF_ItemQuantities[param1];
         _loc3_.text = "";
      }
      
      protected function ProcessorAddSellInventory(param1:TInventory) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TInventory = null;
         if(this.FInventories.Count >= CAPACITY_Item)
         {
            return false;
         }
         _loc3_ = this.FInventories.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FInventories.GetInventoryByIndex(_loc2_);
            if(_loc4_.Identifier == param1.Identifier)
            {
               break;
            }
            _loc2_++;
         }
         if(_loc4_ != null && param1.IsSelling)
         {
            this.FInventories.DeleteInventoryByIndex(_loc2_);
            param1.IsSelling = false;
         }
         else
         {
            this.FInventories.Add(param1);
            param1.IsSelling = true;
         }
         this.UpdateSellListByInventories(this.FInventories);
         return true;
      }
      
      protected function UpdateSellListByInventories(param1:TInventories) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:TInventory = null;
         _loc3_ = this.FInventories.Count;
         _loc2_ = 0;
         while(_loc2_ < CAPACITY_Item)
         {
            if(_loc2_ < _loc3_)
            {
               _loc6_ = this.FInventories.GetInventoryByIndex(_loc2_);
               _loc4_ = _loc6_.Name;
               _loc5_ = "x" + _loc6_.Quantity.toString();
            }
            else
            {
               _loc4_ = "";
               _loc5_ = "";
            }
            this.SetItemCaptionByIndex(_loc2_,_loc4_,_loc5_);
            _loc2_++;
         }
      }
      
      protected function BtnCloseOnClick(param1:MouseEvent) : void
      {
         this.FOnInventoryClick(this,this.FInventories);
         ProcessorWindowClose();
      }
      
      protected function ItemOnClick(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:TInventory = null;
         var _loc6_:TInventories = null;
         _loc6_ = new TInventories();
         _loc4_ = param1.currentTarget as MovieClip;
         _loc2_ = this.FMC_Item.indexOf(_loc4_);
         _loc3_ = this.FInventories.Count;
         if(_loc2_ >= _loc3_)
         {
            return;
         }
         _loc5_ = this.FInventories.GetInventoryByIndex(_loc2_);
         _loc5_.IsSelling = false;
         _loc6_.Add(_loc5_);
         this.FOnInventoryClick(this,_loc6_);
         this.FInventories.DeleteInventoryByIndex(_loc2_);
         this.UpdateSellListByInventories(this.FInventories);
         if(this.FOnInventoryOut != null)
         {
            this.FOnInventoryOut(this,_loc5_);
         }
      }
      
      protected function ItemOnMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:TInventory = null;
         _loc4_ = param1.currentTarget as MovieClip;
         _loc2_ = this.FMC_Item.indexOf(_loc4_);
         _loc3_ = this.FInventories.Count;
         if(_loc2_ >= _loc3_)
         {
            return;
         }
         _loc5_ = this.FInventories.GetInventoryByIndex(_loc2_);
         if(this.FOnInventoryOver != null)
         {
            this.FOnInventoryOver(this,_loc5_);
         }
      }
      
      protected function ItemOnOut(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = null;
         var _loc5_:TInventory = null;
         _loc4_ = param1.currentTarget as MovieClip;
         _loc2_ = this.FMC_Item.indexOf(_loc4_);
         _loc3_ = this.FInventories.Count;
         if(_loc2_ >= _loc3_)
         {
            return;
         }
         _loc5_ = this.FInventories.GetInventoryByIndex(_loc2_);
         if(this.FOnInventoryOut != null)
         {
            this.FOnInventoryOut(this,_loc5_);
         }
      }
      
      protected function BtnAllSellOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FInventories.Count <= 0)
         {
            return;
         }
         if(this.FOnAllSell != null)
         {
            this.FOnAllSell(this,this.FInventories);
         }
      }
      
      public function get OnInventoryOver() : Function
      {
         return this.FOnInventoryOver;
      }
      
      public function set OnInventoryOver(param1:Function) : void
      {
         this.FOnInventoryOver = param1;
      }
      
      public function get OnInventoryOut() : Function
      {
         return this.FOnInventoryOut;
      }
      
      public function set OnInventoryOut(param1:Function) : void
      {
         this.FOnInventoryOut = param1;
      }
      
      public function get OnAllSell() : Function
      {
         return this.FOnAllSell;
      }
      
      public function set OnAllSell(param1:Function) : void
      {
         this.FOnAllSell = param1;
      }
      
      public function get OnInventoryClick() : Function
      {
         return this.FOnInventoryClick;
      }
      
      public function set OnInventoryClick(param1:Function) : void
      {
         this.FOnInventoryClick = param1;
      }
      
      public function Reset() : void
      {
         this.ClearAllItemCaption();
      }
      
      public function AddInventory(param1:TInventory) : Boolean
      {
         return this.ProcessorAddSellInventory(param1);
      }
   }
}

