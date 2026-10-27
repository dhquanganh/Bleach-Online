package Processors.Game.Lobby.BleachAgent
{
   import Components.ScrollBar.TScrollBarSimple;
   import Components.ScrollBar.TScrollTextField;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Resources.Constants.CONST_SYSTEMLANGUAGE;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TProcessorWindowWelfare extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FMask:Bitmap;
      
      protected var FScorll:TScrollBarSimple;
      
      protected var FTF_Info:TextField;
      
      protected var FScrollText:TScrollTextField;
      
      public function TProcessorWindowWelfare(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:MovieClip = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_BleachAgentWelfare") as MovieClip;
         this.FMask = new Bitmap(SUtilityResource.BtmDataFullScreen);
         addChild(this.FMask);
         addChild(this.FMainUI);
         this.FMainUI.x = (this.FMask.width - this.FMainUI.width) / 2;
         this.FMainUI.y = (this.FMask.height - this.FMainUI.height) / 2;
         this.FMainUI.Btn_Close.addEventListener(MouseEvent.CLICK,this.WindowClose);
         _loc3_ = this.FMainUI.MC_Scene;
         this.FTF_Info = _loc3_.TF_Info;
         this.FScrollText = new TScrollTextField(this.FTF_Info);
         _loc3_.addChild(this.FScrollText);
         this.FScorll = new TScrollBarSimple(this,_loc3_.mc_bar,_loc3_.btn_up,_loc3_.btn_down,273,this.FScrollText);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UIFinalize() : void
      {
         this.FTF_Info.htmlText = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_BleachAgent_01);
         super.ResourcesPerform_UIFinalize();
      }
      
      override protected function LogicsPerform() : void
      {
         if(!Visible)
         {
            return;
         }
         if(this.FScorll != null)
         {
            this.FScorll.LogicsProcess();
         }
      }
      
      protected function WindowClose(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
   }
}

