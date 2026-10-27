package Processors.Game.Lobby.Activity.HDNewYearDay.windows
{
   import Components.Pages.TUIPage;
   import Components.Standard.TUIButton;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.Characters.TFriendDigests;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Activity.HDNewYearDay.components.TFriendItem;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Processors.Game.Utilities.Common.SUtilityResource;
   import Resources.Constants.CONST_COMMON;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TNewYearInviteView extends TProcessorLobbyWindow
   {
      
      protected static const Friend_Item_Num:int = 10;
      
      protected var FMainUI:Sprite;
      
      protected var FFriendItems:Vector.<TFriendItem>;
      
      protected var FUIPage:TUIPage;
      
      protected var FFriends:TFriendDigests;
      
      protected var FCurPage:int;
      
      protected var FBtnClose:TUIButton;
      
      protected var FBackSp:Sprite;
      
      protected var FInviteOnSend:Function;
      
      public function TNewYearInviteView(param1:TUIComponent)
      {
         super(param1);
         this.FFriendItems = new Vector.<TFriendItem>();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TFriendItem = null;
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_NewYearDayInviteView") as Sprite;
         this.FBackSp = new Sprite();
         this.addChild(this.FBackSp);
         this.addChild(this.FMainUI);
         _loc1_ = 0;
         while(_loc1_ < Friend_Item_Num)
         {
            _loc2_ = new TFriendItem(this.FMainUI["MC_Item_" + _loc1_]);
            _loc2_.OnClick = this.ItemOnClick;
            this.FFriendItems.push(_loc2_);
            _loc1_++;
         }
         this.FBtnClose = new TUIButton();
         this.FBtnClose.Substrate = this.FMainUI["Btn_Close"];
         this.FBtnClose.OnClick = this.CloseOnClick;
         this.FUIPage = new TUIPage(this);
         this.FUIPage.ButtonPrevious.Substrate = this.FMainUI["MC_Page"]["MC_PageLeft"];
         this.FUIPage.ButtonNext.Substrate = this.FMainUI["MC_Page"]["MC_PageRight"];
         this.FUIPage.LabelPage = this.FMainUI["MC_Page"]["TF_Page"];
         this.FUIPage.PageSize = Friend_Item_Num;
         this.FUIPage.PageIndex = 0;
         this.FCurPage = 0;
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FBackSp.addChild(new Bitmap(SUtilityResource.BtmDataFullScreen));
         this.FBackSp.x = -FParent.X;
         this.FBackSp.y = -FParent.Y;
         this.FMainUI.x = (CONST_COMMON.STAGE_Width - this.FMainUI.width >> 1) - FParent.X;
         this.FMainUI.y = (CONST_COMMON.STAGE_Height - this.FMainUI.height >> 1) - FParent.Y;
      }
      
      protected function UpdateUI() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.FUIPage.SetupPage(this.FFriends.Count,this.FCurPage);
         _loc2_ = this.FFriends.Count;
         _loc1_ = 0;
         while(_loc1_ < Friend_Item_Num)
         {
            _loc3_ = _loc1_ + this.FCurPage * Friend_Item_Num;
            if(_loc3_ < _loc2_)
            {
               this.FFriendItems[_loc1_].Data = this.FFriends.GetDigestByIndex(_loc3_);
            }
            else
            {
               this.FFriendItems[_loc1_].Data = null;
            }
            _loc1_++;
         }
      }
      
      protected function CloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FCurPage = param2;
         this.UpdateUI();
      }
      
      protected function ItemOnClick(param1:int, param2:int) : void
      {
         if(this.FInviteOnSend != null)
         {
            this.FInviteOnSend(param1,param2);
         }
         ProcessorWindowClose();
      }
      
      public function get InviteOnSend() : Function
      {
         return this.FInviteOnSend;
      }
      
      public function set InviteOnSend(param1:Function) : void
      {
         this.FInviteOnSend = param1;
      }
      
      public function UIDispatch() : void
      {
         this.ResourcesPerform_UIDispatch();
      }
      
      public function Show() : void
      {
         this.Visible = true;
         this.FFriends = SLogicsCore.Friends;
         this.FCurPage = 0;
         this.UpdateUI();
      }
   }
}

