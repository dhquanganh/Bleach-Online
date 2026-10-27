package Processors.Game.Lobby.YellowVipBuyBox
{
   import Foundation.Common.TBounds;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import flash.utils.ByteArray;
   
   public class TProcessorYellowVipBuyGold extends TProcessorLobbyWindows
   {
      
      protected static const WINDOW_WIDTH:int = 710;
      
      protected static const WINDOW_HEIGHT:int = 403;
      
      protected var FWindowYellowVipBuyGold:TWindowYellowVipBuyGold;
      
      protected var FBounds:TBounds;
      
      public function TProcessorYellowVipBuyGold(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FWindowYellowVipBuyGold = new TWindowYellowVipBuyGold(this);
         this.FWindowYellowVipBuyGold.OnClose = this.ProcessorWindowOnClose;
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_WIDTH;
         this.FBounds.Height = WINDOW_HEIGHT;
         ComponentBoundsCenter(this.FWindowYellowVipBuyGold,this.FBounds);
         this.FBounds = null;
      }
      
      protected function ProcessorWindowOnClose(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            this.FWindowYellowVipBuyGold.Load();
            return;
         }
         this.FWindowYellowVipBuyGold.visible = true;
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

