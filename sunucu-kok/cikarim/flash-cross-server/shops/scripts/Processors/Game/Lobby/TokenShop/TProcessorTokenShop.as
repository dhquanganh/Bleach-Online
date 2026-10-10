package Processors.Game.Lobby.TokenShop
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Logics.Purchases.TPurchaseParameters;
   import Logics.Purchases.TPurchaseRequest;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import Resources.Constants.CONST_GONGFUFIGHT;
   import flash.utils.ByteArray;
   
   public class TProcessorTokenShop extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WindowTokenShop_Width:uint = 503;
      
      protected static const SIZE_WindowTokenShop_Height:uint = 456;
      
      protected var FProcessorWindowTokenShop:TProcessorWindowTokenShop;
      
      protected var FOnPurchase:Function;
      
      public function TProcessorTokenShop(param1:TUIComponent, param2:TLobbyParameters)
      {
         var _loc3_:TBounds = null;
         super(param1,param2);
         this.FProcessorWindowTokenShop = new TProcessorWindowTokenShop(param1);
         this.FProcessorWindowTokenShop.Visible = false;
         this.FProcessorWindowTokenShop.OnClose = this.ProcessorWindowShopOnClose;
         this.FProcessorWindowTokenShop.OnEffectText = ProcessorsOnEffectText;
         this.FProcessorWindowTokenShop.OnPurchase = this.ProcessorOnPurchase;
         _loc3_ = new TBounds();
         _loc3_.Width = SIZE_WindowTokenShop_Width;
         _loc3_.Height = SIZE_WindowTokenShop_Height;
         ComponentBoundsCenter(this.FProcessorWindowTokenShop,_loc3_);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_GONGFUFIGHT.RESOURCESID_GongFuFight_TokenShop);
         super.ResourcesPerform_UIRequest();
      }
      
      protected function ProcessorWindowShopOnClose(param1:Object) : void
      {
         ProcessorClose();
         this.FProcessorWindowTokenShop.Dispose();
         this.UnLoad();
      }
      
      protected function ProcessorOnPurchase(param1:Object, param2:TPurchaseRequest, param3:TPurchaseParameters) : void
      {
         if(this.FOnPurchase != null)
         {
            this.FOnPurchase(param1,param2,param3);
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
            this.FProcessorWindowTokenShop.Load();
            return;
         }
         this.FProcessorWindowTokenShop.Update();
         this.FProcessorWindowTokenShop.Visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
         this.FProcessorWindowTokenShop.Reset();
         this.FProcessorWindowTokenShop.Visible = false;
      }
   }
}

