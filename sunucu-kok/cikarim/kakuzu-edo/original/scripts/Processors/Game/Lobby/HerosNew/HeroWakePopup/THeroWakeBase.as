package Processors.Game.Lobby.HerosNew.HeroWakePopup
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class THeroWakeBase extends TProcessorLobbyWindow
   {
      
      protected var FMainUI:Sprite;
      
      protected var FBtnClose:TUIButton;
      
      protected var FPathName:String;
      
      protected var FParentNames:Vector.<String>;
      
      protected var FWakeIdentifier:int;
      
      protected var FWindowOnClose:Function;
      
      protected var FCurLayer:int;
      
      public function THeroWakeBase(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
         this.FParentNames.length = 0;
         if(this.FWindowOnClose != null)
         {
            this.FWindowOnClose(this);
         }
      }
      
      public function get WakeIdentifier() : int
      {
         return this.FWakeIdentifier;
      }
      
      public function set WakeIdentifier(param1:int) : void
      {
         this.FWakeIdentifier = param1;
      }
      
      public function get PathName() : String
      {
         return this.FPathName;
      }
      
      public function set PathName(param1:String) : void
      {
         this.FPathName = param1;
      }
      
      public function get ParentNames() : Vector.<String>
      {
         return this.FParentNames;
      }
      
      public function set ParentNames(param1:Vector.<String>) : void
      {
         this.FParentNames = param1;
      }
      
      public function get WindowOnClose() : Function
      {
         return this.FWindowOnClose;
      }
      
      public function set WindowOnClose(param1:Function) : void
      {
         this.FWindowOnClose = param1;
      }
      
      public function get CurLayer() : int
      {
         return this.FCurLayer;
      }
      
      public function set CurLayer(param1:int) : void
      {
         this.FCurLayer = param1;
         Parent.addChildAt(this,this.FCurLayer);
      }
      
      public function SetData() : void
      {
      }
      
      public function UIDispatch() : void
      {
         ResourcesPerform_UIDispatch();
      }
   }
}

