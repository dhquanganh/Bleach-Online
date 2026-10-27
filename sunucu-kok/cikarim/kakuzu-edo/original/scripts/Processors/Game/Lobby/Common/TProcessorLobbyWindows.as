package Processors.Game.Lobby.Common
{
   import Foundation.UI.TUIComponent;
   import flash.utils.ByteArray;
   
   public class TProcessorLobbyWindows extends TProcessorLobbyModule
   {
      
      protected var FOnClose:Function;
      
      protected var FOnUpdatePopTipsModes:Function;
      
      protected var FOnCheckPopTipsModes:Function;
      
      public function TProcessorLobbyWindows(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      protected function ProcessorClose() : void
      {
         if(this.FOnClose != null)
         {
            this.FOnClose(this);
         }
         Visible = false;
      }
      
      protected function PopTipsNotifyUpdate() : void
      {
         if(this.FOnUpdatePopTipsModes != null)
         {
            this.FOnUpdatePopTipsModes(this);
         }
      }
      
      protected function PopTipsNotifyCheck() : void
      {
      }
      
      public function get OnClose() : Function
      {
         return this.FOnClose;
      }
      
      public function set OnClose(param1:Function) : void
      {
         this.FOnClose = param1;
      }
      
      public function get OnUpdatePopTipsModes() : Function
      {
         return this.FOnUpdatePopTipsModes;
      }
      
      public function set OnUpdatePopTipsModes(param1:Function) : void
      {
         this.FOnUpdatePopTipsModes = param1;
      }
      
      public function get OnCheckPopTipsModes() : Function
      {
         return this.FOnCheckPopTipsModes;
      }
      
      public function set OnCheckPopTipsModes(param1:Function) : void
      {
         this.FOnCheckPopTipsModes = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.PopTipsNotifyCheck();
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

