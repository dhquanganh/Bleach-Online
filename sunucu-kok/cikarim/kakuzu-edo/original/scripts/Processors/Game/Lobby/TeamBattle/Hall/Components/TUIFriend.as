package Processors.Game.Lobby.TeamBattle.Hall.Components
{
   import Foundation.UI.*;
   import Logics.Characters.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIFriend extends TUIComponent
   {
      
      protected var FTFNickname:TextField;
      
      protected var FTFLevel:TextField;
      
      protected var FBtnWhisper:SimpleButton;
      
      protected var FResource:Sprite;
      
      protected var FContext:TDigest;
      
      protected var FOnWhisper:Function;
      
      public function TUIFriend(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         this.FResource.mouseEnabled = false;
         this.FTFNickname = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_TF_Nickname];
         this.FTFLevel = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_TF_Level];
         this.FBtnWhisper = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Whisper];
         this.Reset();
      }
      
      protected function addEventListenerFriend() : void
      {
         this.FResource.mouseChildren = true;
         this.FBtnWhisper.addEventListener(MouseEvent.CLICK,this.BtnWhisperOnClick,false,0,true);
      }
      
      protected function RemoveEventListenerFriend() : void
      {
         this.FResource.mouseChildren = false;
         this.FBtnWhisper.removeEventListener(MouseEvent.CLICK,this.BtnWhisperOnClick);
      }
      
      protected function UpdateItem() : void
      {
         this.FTFNickname.text = this.FContext.Name;
         this.FTFLevel.text = this.FContext.Level.toString();
      }
      
      protected function BtnWhisperOnClick(param1:MouseEvent) : void
      {
         if(this.FOnWhisper != null)
         {
            this.FOnWhisper(this,this.FContext);
         }
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         this.FResource = param1;
      }
      
      public function get Context() : TDigest
      {
         return this.FContext;
      }
      
      public function set Context(param1:TDigest) : void
      {
         this.Reset();
         if(this.FContext == null && param1 != null)
         {
            this.addEventListenerFriend();
         }
         else if(param1 == null)
         {
            this.RemoveEventListenerFriend();
         }
         this.FContext = param1;
         if(param1 != null)
         {
            this.UpdateItem();
         }
      }
      
      public function get OnWhisper() : Function
      {
         return this.FOnWhisper;
      }
      
      public function set OnWhisper(param1:Function) : void
      {
         this.FOnWhisper = param1;
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(this.FResource != null)
         {
            this.FResource.visible = param1;
         }
      }
      
      public function Perform_UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      override public function Dispose() : void
      {
         this.RemoveEventListenerFriend();
         this.FTFNickname = null;
         this.FTFLevel = null;
         this.FBtnWhisper = null;
         this.FResource = null;
         this.FContext = null;
         this.FOnWhisper = null;
      }
      
      public function Reset() : void
      {
         this.FTFNickname.text = "";
         this.FTFLevel.text = "";
      }
   }
}

