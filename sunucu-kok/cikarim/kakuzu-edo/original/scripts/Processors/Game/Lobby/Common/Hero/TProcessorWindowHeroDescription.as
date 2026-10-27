package Processors.Game.Lobby.Common.Hero
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_COMMON;
   
   public class TProcessorWindowHeroDescription extends TProcessorLobbyWindow
   {
      
      protected static const Window_Width:int = 365;
      
      protected static const Window_Height:int = 277;
      
      protected var FProcessorWindowGeneralsIntroduced:TProcessorWindowGeneralsIntroduced;
      
      protected var FHeroID:uint;
      
      public function TProcessorWindowHeroDescription(param1:TUIComponent)
      {
         super(param1);
         this.FProcessorWindowGeneralsIntroduced = new TProcessorWindowGeneralsIntroduced(this);
         this.FProcessorWindowGeneralsIntroduced.OnClose = this.ProcessorWindowGeneralsIntroducedOnClose;
      }
      
      protected function Resources_UIDispatch() : void
      {
         this.FProcessorWindowGeneralsIntroduced.UIDispatch();
      }
      
      protected function Resources_UILocations() : void
      {
         this.FProcessorWindowGeneralsIntroduced.x = (CONST_COMMON.STAGE_Width - Window_Width) / 2;
         this.FProcessorWindowGeneralsIntroduced.y = (CONST_COMMON.STAGE_Height - Window_Height) / 2;
         this.FProcessorWindowGeneralsIntroduced.visible = false;
      }
      
      protected function ProcessorWindowGeneralsIntroducedOnClose(param1:Object) : void
      {
         ProcessorWindowClose();
         this.Hide();
      }
      
      public function set HeroID(param1:uint) : void
      {
         this.FHeroID = param1;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FProcessorWindowGeneralsIntroduced.HintOnOver = param1;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FProcessorWindowGeneralsIntroduced.HintOnOut = param1;
      }
      
      public function Perform_UIDispatch() : void
      {
         this.Resources_UIDispatch();
         this.Resources_UILocations();
      }
      
      public function Show() : void
      {
         this.FProcessorWindowGeneralsIntroduced.SetHeroData(this.FHeroID);
         this.FProcessorWindowGeneralsIntroduced.Visible = true;
         this.Visible = true;
      }
      
      public function Hide() : void
      {
         this.Reset();
         this.FProcessorWindowGeneralsIntroduced.Visible = false;
         this.Visible = false;
      }
      
      public function Reset() : void
      {
         this.FProcessorWindowGeneralsIntroduced.Reset();
      }
   }
}

