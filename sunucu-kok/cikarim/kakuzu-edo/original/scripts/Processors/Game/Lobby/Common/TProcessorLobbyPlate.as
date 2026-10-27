package Processors.Game.Lobby.Common
{
   import Foundation.UI.TUIComponent;
   import Logics.ChatOptions.TChatOptions;
   import flash.utils.ByteArray;
   
   public class TProcessorLobbyPlate extends TProcessorLobbyModule
   {
      
      protected var FOnUpdateShortcutModes:Function;
      
      protected var FOnUpdateChatOption:Function;
      
      protected var FOnUpdatePopTipsModes:Function;
      
      protected var FOnCheckPopTipsModes:Function;
      
      protected var FShowShortcutsPosition:Vector.<uint>;
      
      protected var FShowShortcutsLocation:Vector.<uint>;
      
      public function TProcessorLobbyPlate(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
      }
      
      protected function ShortcutModesNotifyUpdate() : void
      {
         if(this.FOnUpdateShortcutModes != null)
         {
            this.FOnUpdateShortcutModes(this);
         }
      }
      
      protected function ChatOptionsNotifyUpdate() : void
      {
         if(this.FOnUpdateChatOption != null)
         {
            this.FOnUpdateChatOption(this);
         }
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
      
      public function get OnUpdateShortcutModes() : Function
      {
         return this.FOnUpdateShortcutModes;
      }
      
      public function set OnUpdateShortcutModes(param1:Function) : void
      {
         this.FOnUpdateShortcutModes = param1;
      }
      
      public function get OnUpdateChatOption() : Function
      {
         return this.FOnUpdateChatOption;
      }
      
      public function set OnUpdateChatOption(param1:Function) : void
      {
         this.FOnUpdateChatOption = param1;
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
      
      public function get ShowShortcutsPosition() : Vector.<uint>
      {
         return this.FShowShortcutsPosition;
      }
      
      public function set ShowShortcutsPosition(param1:Vector.<uint>) : void
      {
         this.FShowShortcutsPosition = param1;
      }
      
      public function get ShowShortcutsLocation() : Vector.<uint>
      {
         return this.FShowShortcutsLocation;
      }
      
      public function set ShowShortcutsLocation(param1:Vector.<uint>) : void
      {
         this.FShowShortcutsLocation = param1;
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
      
      public function ChatOptionsSetup(param1:TChatOptions) : void
      {
         param1.ChatOptionsReset();
      }
   }
}

