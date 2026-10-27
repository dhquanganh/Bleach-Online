package Processors.Game.Lobby.Activity.HDNewYearDay.components
{
   import Components.Standard.TUIButton;
   import Logics.Characters.TFriendDigest;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   
   public class TFriendItem
   {
      
      protected var FMainUI:Sprite;
      
      protected var FTFName:TextField;
      
      protected var FTFLevel:TextField;
      
      protected var FIcon:MovieClip;
      
      protected var FBackBar:MovieClip;
      
      protected var FBtnInvite:TUIButton;
      
      protected var FOnClick:Function;
      
      protected var FData:TFriendDigest;
      
      public function TFriendItem(param1:Sprite)
      {
         super();
         this.FMainUI = param1;
         this.InitView();
      }
      
      protected function InitView() : void
      {
         this.FBackBar = this.FMainUI["MC_Listitem_0"];
         this.FBackBar.gotoAndStop(1);
         this.FBackBar.addEventListener(MouseEvent.MOUSE_OVER,this.BackOnOver);
         this.FBackBar.addEventListener(MouseEvent.MOUSE_OUT,this.BackOnOut);
         this.FBtnInvite = new TUIButton();
         this.FBtnInvite.Substrate = this.FMainUI["Btn_Invite"];
         this.FBtnInvite.OnClick = this.BtnOnClick;
         this.FTFName = this.FBackBar["TF_Nickname"];
         this.FTFLevel = this.FBackBar["TF_Level"];
         this.FIcon = this.FBackBar["MC_CountryIconMountPoint"];
         this.FIcon.stop();
      }
      
      protected function BtnOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(this.FOnClick != null)
         {
            this.FOnClick(this.FData.Identifier0,this.FData.Identifier1);
         }
      }
      
      protected function BackOnOver(param1:MouseEvent) : void
      {
         this.FBackBar.gotoAndStop(2);
      }
      
      protected function BackOnOut(param1:MouseEvent) : void
      {
         this.FBackBar.gotoAndStop(1);
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get Data() : TFriendDigest
      {
         return this.FData;
      }
      
      public function set Data(param1:TFriendDigest) : void
      {
         this.FData = param1;
         if(this.FData == null)
         {
            this.FMainUI.visible = false;
            return;
         }
         this.FMainUI.visible = true;
         if(this.FData.Country == 0)
         {
            this.FIcon.visible = false;
         }
         else
         {
            this.FIcon.visible = true;
            this.FIcon.gotoAndStop(this.FData.Country);
         }
         this.FTFName.text = this.FData.Name;
         this.FTFLevel.text = this.FData.Level + "";
      }
   }
}

