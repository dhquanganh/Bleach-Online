package Processors.Game.Lobby.HellButterfly.Component
{
   import Foundation.UI.TUIComponent;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Friends.Components.TUIItem;
   import Resources.Constants.CONST_FRESHGUIDE;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TUIFriendList extends TUIItem
   {
      
      public static const FRAME_NORMAL:uint = 1;
      
      public static const FRAME_OVER:uint = 2;
      
      public static const FRAME_SELECT:uint = 3;
      
      protected var FGoodsIcon:Sprite;
      
      public var FBClick:Boolean;
      
      public var FListitem:MovieClip;
      
      protected var FEnterFriend:Function;
      
      public function TUIFriendList(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function Resources_UIDispatch(param1:MovieClip) : void
      {
         FMC_Listitem = param1;
         this.FListitem = param1;
         FTFNickname = FMC_Listitem["TF_FriendName"];
         FCountryIcon = FMC_Listitem["MC_Home"];
         FTFLevel = FMC_Listitem["TF_FriendLevel"];
         this.FGoodsIcon = FMC_Listitem["MC_GoodsIcon"];
         FMC_Listitem.addEventListener(MouseEvent.CLICK,this.ListOnClick);
      }
      
      override protected function UpdateItem() : void
      {
         var _loc1_:uint = 0;
         FTFNickname.text = FContext.Name;
         FTFLevel.text = FContext.Level.toString();
         _loc1_ = FContext.Country;
         if(_loc1_ != 0)
         {
            FCountryIcon.gotoAndStop(FContext.Country);
            FCountryIcon.visible = true;
         }
         else
         {
            FCountryIcon.visible = false;
         }
      }
      
      override protected function ListitemOnOver(param1:MouseEvent) : void
      {
         if(this.FBClick)
         {
            return;
         }
         FMC_Listitem.gotoAndStop(RENDERINGSTATE_Hovering);
      }
      
      override protected function ListitemOnOut(param1:MouseEvent) : void
      {
         if(this.FBClick)
         {
            return;
         }
         FMC_Listitem.gotoAndStop(RENDERINGSTATE_Normal);
      }
      
      protected function ListOnClick(param1:MouseEvent) : void
      {
         if(this.FEnterFriend != null)
         {
            this.FEnterFriend(FContext,this);
         }
         FMC_Listitem.gotoAndStop(FRAME_SELECT);
         this.FBClick = true;
         SLogicsCore.SinalPostFreshGuide(CONST_FRESHGUIDE.EVENTID_ClickBufferFlyFriend);
      }
      
      public function get EnterFriend() : Function
      {
         return this.FEnterFriend;
      }
      
      public function set EnterFriend(param1:Function) : void
      {
         this.FEnterFriend = param1;
      }
      
      public function set HightLight(param1:uint) : void
      {
         FMC_Listitem.gotoAndStop(param1);
      }
      
      public function SetSendGood(param1:Boolean) : void
      {
         this.FGoodsIcon.visible = param1;
      }
   }
}

