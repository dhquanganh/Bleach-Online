package Processors.Game.Lobby.Home.Component
{
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Logics.Characters.TFriendDigest;
   import Resources.Constants.CONST_HOME;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TItemFriend extends TUIComponent
   {
      
      protected var FTFLevel:TextField;
      
      protected var FTFName:TextField;
      
      protected var FBtnVisit:TUIButton;
      
      protected var FIsInitialization:Boolean;
      
      protected var FResource:Sprite;
      
      protected var FFriendDigest:TFriendDigest;
      
      protected var FOnClick:Function;
      
      public function TItemFriend(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function Initialization() : void
      {
         this.FResource.mouseEnabled = false;
         this.FTFLevel = this.FResource[CONST_HOME.RESOURCE_Link_TF_Level];
         this.FTFName = this.FResource[CONST_HOME.RESOURCE_Link_TF_Name];
         this.FBtnVisit = new TUIButton();
         this.FBtnVisit.Substrate = this.FResource[CONST_HOME.RESOURCE_Link_Btn_Visit];
         this.FBtnVisit.OnClick = this.BtnVisitOnClick;
         this.FIsInitialization = true;
      }
      
      protected function RenderingPerform() : void
      {
         if(this.Context != null)
         {
            this.FTFLevel.text = this.Context.Level.toString();
            this.FTFName.text = this.Context.Name;
         }
         else
         {
            this.FTFLevel.text = "0";
            this.FTFName.text = "";
         }
      }
      
      protected function BtnVisitOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnClick != null)
         {
            this.FOnClick(this,this.FFriendDigest);
         }
      }
      
      public function get Resource() : Sprite
      {
         return this.FResource;
      }
      
      public function set Resource(param1:Sprite) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(param1 != this.FResource)
         {
            this.FResource = param1;
         }
         if(!this.FIsInitialization)
         {
            this.Initialization();
         }
      }
      
      public function get Context() : TFriendDigest
      {
         return this.FFriendDigest;
      }
      
      public function set Context(param1:TFriendDigest) : void
      {
         if(param1 != this.FFriendDigest)
         {
            this.FFriendDigest = param1;
            this.RenderingPerform();
         }
      }
      
      override public function set Visible(param1:Boolean) : void
      {
         super.Visible = param1;
         if(!this.FIsInitialization)
         {
            return;
         }
         this.FResource.visible = param1;
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
   }
}

