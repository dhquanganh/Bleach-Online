package Processors.Game.Lobby.TeamBattle.Room.Components
{
   import Components.Standard.*;
   import Foundation.Timing.STimingCore;
   import Foundation.UI.*;
   import Foundation.Utilities.TUtilityString;
   import Logics.Characters.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   
   public class TUIFriend extends TUIComponent
   {
      
      protected static const TIME_INTERVAL_INVITE_PERIOD:int = 10000;
      
      protected static const RENDERINGSTATE_Normal:int = 1;
      
      protected static const RENDERINGSTATE_Hovering:int = 2;
      
      protected var FResource:MovieClip;
      
      protected var FTFNickname:TextField;
      
      protected var FCountryIcon:MovieClip;
      
      protected var FTFLevel:TextField;
      
      protected var FBtn_Invite:TUIButton;
      
      protected var FTickInvite:int;
      
      protected var FContext:TFriendDigest;
      
      protected var FOnInvite:Function;
      
      public function TUIFriend(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function ResourcesPerform_UIDispatch() : void
      {
         this.FTFNickname = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_TF_Nickname];
         this.FCountryIcon = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_MC_CountryIconMountPoint];
         this.FTFLevel = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_TF_Level];
         this.FBtn_Invite = new TUIButton();
         this.FBtn_Invite.Substrate = this.FResource[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Invite];
         this.Reset();
      }
      
      protected function addEventListenerFriend() : void
      {
         this.FResource.mouseEnabled = true;
         this.FResource.mouseChildren = true;
         this.FResource.addEventListener(MouseEvent.MOUSE_OVER,this.ListitemOnOver,false,0,true);
         this.FResource.addEventListener(MouseEvent.MOUSE_OUT,this.ListitemOnOut,false,0,true);
         this.FBtn_Invite.OnClick = this.Btn_InviteOnClick;
      }
      
      protected function RemoveEventListenerFriend() : void
      {
         this.FResource.mouseEnabled = false;
         this.FResource.mouseChildren = false;
         this.FResource.removeEventListener(MouseEvent.MOUSE_OVER,this.ListitemOnOver);
         this.FResource.removeEventListener(MouseEvent.MOUSE_OUT,this.ListitemOnOut);
         this.FBtn_Invite.OnClick = null;
      }
      
      protected function UpdateItem() : void
      {
         var _loc1_:uint = 0;
         this.FTFNickname.text = this.FContext.Name;
         this.FTFLevel.text = this.FContext.Level.toString();
         _loc1_ = this.FContext.Country;
         if(_loc1_ != 0)
         {
            this.FCountryIcon.gotoAndStop(_loc1_);
            this.FCountryIcon.visible = true;
         }
         this.FBtn_Invite.Visible = true;
      }
      
      protected function ListitemOnOver(param1:MouseEvent) : void
      {
         this.FResource.gotoAndStop(RENDERINGSTATE_Hovering);
      }
      
      protected function ListitemOnOut(param1:MouseEvent) : void
      {
         this.FResource.gotoAndStop(RENDERINGSTATE_Normal);
      }
      
      protected function Btn_InviteOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FBtn_Invite.Enabled = false;
         this.FTickInvite = STimingCore.TickCount;
         if(this.FOnInvite != null)
         {
            this.FOnInvite(this,this.FContext);
         }
      }
      
      public function get Resource() : MovieClip
      {
         return this.FResource;
      }
      
      public function set Resource(param1:MovieClip) : void
      {
         this.FResource = param1;
      }
      
      public function get Context() : TFriendDigest
      {
         return this.FContext;
      }
      
      public function set Context(param1:TFriendDigest) : void
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
      
      public function get OnInvite() : Function
      {
         return this.FOnInvite;
      }
      
      public function set OnInvite(param1:Function) : void
      {
         this.FOnInvite = param1;
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
      
      public function Reset() : void
      {
         this.FTickInvite = 0;
         this.FTFNickname.text = "";
         this.FTFLevel.text = "";
         this.FCountryIcon.visible = false;
         this.FBtn_Invite.Visible = false;
         this.FBtn_Invite.Enabled = true;
      }
      
      public function Update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(!this.FBtn_Invite.Enabled)
         {
            _loc1_ = int(STimingCore.TickCount);
            if(_loc1_ - this.FTickInvite >= TIME_INTERVAL_INVITE_PERIOD)
            {
               this.FBtn_Invite.Caption = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_73);
               this.FBtn_Invite.Enabled = true;
            }
            else
            {
               _loc2_ = (TIME_INTERVAL_INVITE_PERIOD - (_loc1_ - this.FTickInvite)) / 1000;
               this.FBtn_Invite.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_74),_loc2_);
            }
         }
      }
   }
}

