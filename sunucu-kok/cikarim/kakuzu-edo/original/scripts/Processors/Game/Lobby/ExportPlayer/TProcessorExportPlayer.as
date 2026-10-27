package Processors.Game.Lobby.ExportPlayer
{
   import Foundation.Common.TBounds;
   import Foundation.Resources.SResourcesCore;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Common.TLobbyParameters;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindows;
   import flash.utils.ByteArray;
   
   public class TProcessorExportPlayer extends TProcessorLobbyWindows
   {
      
      protected static var WINDOW_WIDTH:int = 992;
      
      protected static var WINDOW_HEIGTH:int = 599;
      
      protected const EXPORTPLAYER_RESOURCEID:uint = 738197504;
      
      protected var FProcessorWindowMainUI:TProcessorExportPlayerMainUI;
      
      protected var FBounds:TBounds;
      
      public function TProcessorExportPlayer(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FProcessorWindowMainUI = new TProcessorExportPlayerMainUI(this);
         this.FProcessorWindowMainUI.OnClose = this.Exit;
         this.FBounds = new TBounds();
         this.FBounds.Width = WINDOW_WIDTH;
         this.FBounds.Height = WINDOW_HEIGTH;
         ComponentBoundsCenter(this.FProcessorWindowMainUI,this.FBounds);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(this.EXPORTPLAYER_RESOURCEID);
         super.ResourcesPerform_UIRequest();
      }
      
      protected function Exit(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FProcessorWindowMainUI.Load();
            return;
         }
         this.FProcessorWindowMainUI.Visible = true;
      }
   }
}

