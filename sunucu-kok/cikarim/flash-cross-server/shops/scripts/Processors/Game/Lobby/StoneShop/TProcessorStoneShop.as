package Processors.Game.Lobby.StoneShop
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Inventories.TInventorySample;
   import Logics.Purchases.TPurchaseParameters;
   import Logics.Purchases.TPurchaseRequest;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Resources.Constants.CONST_GONGFUFIGHT;
   import flash.utils.ByteArray;
   
   public class TProcessorStoneShop extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WindowStoneShop_Width:uint = 960;
      
      protected static const SIZE_WindowStoneShop_Height:uint = 534;
      
      protected var FProcessorWindowStoneShop:TProcessorWindowStoneShop;
      
      protected var FOnPurchase:Function;
      
      public function TProcessorStoneShop(param1:TUIComponent, param2:TLobbyParameters)
      {
         var _loc3_:TBounds = null;
         super(param1,param2);
         this.FProcessorWindowStoneShop = new TProcessorWindowStoneShop(param1);
         this.FProcessorWindowStoneShop.Visible = false;
         this.FProcessorWindowStoneShop.OnClose = this.ProcessorWindowShopOnClose;
         this.FProcessorWindowStoneShop.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowStoneShop.OnPurchase = this.ProcessorOnPurchase;
         _loc3_ = new TBounds();
         _loc3_.Width = SIZE_WindowStoneShop_Width;
         _loc3_.Height = SIZE_WindowStoneShop_Height;
         ComponentBoundsCenter(this.FProcessorWindowStoneShop,_loc3_);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_GONGFUFIGHT.RESOURCESID_GongFuFight_StoneShop);
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
      
      protected function ProcessorWindowShopOnClose(param1:Object) : void
      {
         ProcessorClose();
         this.FProcessorWindowStoneShop.Dispose();
         this.UnLoad();
      }
      
      protected function ProcessorOnPurchase(param1:Object, param2:TPurchaseRequest, param3:TPurchaseParameters, param4:TInventorySample = null) : void
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
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowStoneShop.Load();
            return;
         }
         this.FProcessorWindowStoneShop.Update();
         this.FProcessorWindowStoneShop.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowStoneShop.Reset();
         this.FProcessorWindowStoneShop.Visible = false;
      }
   }
}

