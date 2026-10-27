package Processors.Game.Lobby.FBBuyGold
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import flash.utils.ByteArray;
   
   public class TProcessorFBBuyGold extends TProcessorLobbyWindows
   {
      
      protected static const FBResourceID:int = 2046820352;
      
      protected static const WINDOW_WIDTH:int = 614;
      
      protected static const WINDOW_HEIGHT:int = 352;
      
      protected var FProcessorWindowBuyGold:TProcessorWindowBuyGold;
      
      public function TProcessorFBBuyGold(param1:TUIComponent, param2:TLobbyParameters)
      {
         var _loc3_:TBounds = null;
         super(param1,param2);
         this.FProcessorWindowBuyGold = new TProcessorWindowBuyGold(this);
         this.FProcessorWindowBuyGold.OnClose = this.CloseWindow;
         _loc3_ = new TBounds();
         _loc3_.Width = WINDOW_WIDTH;
         _loc3_.Height = WINDOW_HEIGHT;
         ComponentBoundsCenter(this.FProcessorWindowBuyGold,_loc3_);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(FBResourceID);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         super.ResourcesPerform_UIDispatch();
      }
      
      protected function CloseWindow(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowBuyGold.Load();
            return;
         }
         this.FProcessorWindowBuyGold.Visible = true;
      }
   }
}

