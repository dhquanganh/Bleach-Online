package Processors.Game.Lobby.TeamBattle.Room
{
   import Components.Pages.*;
   import Components.Standard.*;
   import Foundation.Network.SNetworkCore;
   import Foundation.Network.TPacket;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.Characters.*;
   import Logics.SLogicsCore;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.TeamBattle.Room.Components.*;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.ByteArray;
   
   public class TProcessorWindowInvite extends TProcessorLobbyWindow
   {
      
      protected static const CAPACITY_TABS:uint = CONST_TEAMBATTLE.CAPACITY_TABS;
      
      protected static const CAPACITY_LISTITEMS:uint = CONST_TEAMBATTLE.CAPACITY_LISTITEMS;
      
      protected static const INDEX_FRIEND:uint = CONST_TEAMBATTLE.INDEX_FRIEND;
      
      protected static const INDEX_ORGANIZATION:uint = CONST_TEAMBATTLE.INDEX_ORGANIZATION;
      
      protected static const INDEX_RECOMMEND:uint = CONST_TEAMBATTLE.INDEX_RECOMMEND;
      
      protected static const TYPE_FRIEND:uint = CONST_TEAMBATTLE.TYPE_FRIEND;
      
      protected static const TYPE_ORGANIZATION:uint = CONST_TEAMBATTLE.TYPE_ORGANIZATION;
      
      protected static const TYPE_RECOMMEND:uint = CONST_TEAMBATTLE.TYPE_RECOMMEND;
      
      protected var FFriendDigests:TFriendDigests;
      
      protected var FOrganizationDigests:TFriendDigests;
      
      protected var FRecommendDigests:TFriendDigests;
      
      protected var FCurrentDigests:TFriendDigests;
      
      protected var FSP_TeamBattleInvite:Sprite;
      
      protected var FBtn_Close:TUIButton;
      
      protected var FUITab:TUITab;
      
      protected var FUIPage:TUIPage;
      
      protected var FUIFriends:Vector.<TUIFriend>;
      
      protected var FTabIndex:int;
      
      protected var FPageIndex:int;
      
      protected var FInitialization:Boolean;
      
      protected var FInviteDigests:TFriendDigests;
      
      public function TProcessorWindowInvite(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TEAMBATTLE.RESOURCESID_Swf_TeamBattleRoom);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:MovieClip = null;
         var _loc3_:Sprite = null;
         var _loc4_:TUIFriend = null;
         this.FSP_TeamBattleInvite = TUtilityReflection.CreateDisplayObjectInstance(CONST_TEAMBATTLE.RESOURCE_Link_SP_TeamBattleInvite) as Sprite;
         addChild(this.FSP_TeamBattleInvite);
         this.FBtn_Close = new TUIButton();
         this.FBtn_Close.Substrate = this.FSP_TeamBattleInvite[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Close.OnClick = this.Btn_CloseOnClick;
         this.FUITab = new TUITab(null);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_TABS)
         {
            _loc2_ = this.FSP_TeamBattleInvite[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_];
            this.FUITab.SetTabByIndex(_loc2_,_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         _loc3_ = this.FSP_TeamBattleInvite[CONST_TEAMBATTLE.RESOURCE_Link_SP_ListItems];
         this.FUIFriends = new Vector.<TUIFriend>(CAPACITY_LISTITEMS);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_LISTITEMS)
         {
            _loc4_ = new TUIFriend(null);
            _loc4_.Resource = _loc3_[CONST_TEAMBATTLE.RESOURCE_Link_MC_Listitem + _loc1_];
            _loc4_.Tag = _loc1_;
            _loc4_.OnInvite = this.UIFriendOnInvite;
            _loc4_.Perform_UIDispatch();
            this.FUIFriends[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FUIPage = new TUIPage(null);
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FUIPage.ButtonPrevious.Substrate = this.FSP_TeamBattleInvite[CONST_COMMON.RESOURCE_Link_MC_PageLeft];
         this.FUIPage.ButtonNext.Substrate = this.FSP_TeamBattleInvite[CONST_COMMON.RESOURCE_Link_MC_PageRight];
         this.FUIPage.LabelPage = this.FSP_TeamBattleInvite[CONST_COMMON.RESOURCE_Link_TF_Page];
         this.FUIPage.LabelPage.text = "0/0";
         this.FUIPage.PageSize = CAPACITY_LISTITEMS;
         this.FUIPage.Init();
         this.FFriendDigests = new TFriendDigests();
         this.FOrganizationDigests = new TFriendDigests();
         this.FRecommendDigests = new TFriendDigests();
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FInitialization = true;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         super.LogicsPerform();
         if(!this.FInitialization)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_LISTITEMS)
         {
            this.FUIFriends[_loc1_].Update();
            _loc1_++;
         }
      }
      
      protected function ProcessorUpdateDigests() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TFriendDigest = null;
         this.FFriendDigests.Clear();
         this.FOrganizationDigests.Clear();
         this.FRecommendDigests.Clear();
         _loc2_ = this.FInviteDigests.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FInviteDigests.GetDigestByIndex(_loc1_);
            switch(_loc3_.Type)
            {
               case TYPE_FRIEND:
                  this.FFriendDigests.Add(_loc3_);
                  break;
               case TYPE_ORGANIZATION:
                  this.FOrganizationDigests.Add(_loc3_);
                  break;
               case TYPE_RECOMMEND:
                  this.FRecommendDigests.Add(_loc3_);
            }
            _loc1_++;
         }
         this.FFriendDigests.SortLevel();
         this.FOrganizationDigests.SortLevel();
         this.FRecommendDigests.SortLevel();
      }
      
      protected function ProcessorFilterDigests() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TFriendDigests = null;
         _loc1_ = this.FTabIndex;
         switch(_loc1_)
         {
            case INDEX_FRIEND:
               _loc2_ = this.FFriendDigests;
               break;
            case INDEX_ORGANIZATION:
               _loc2_ = this.FOrganizationDigests;
               break;
            case INDEX_RECOMMEND:
               _loc2_ = this.FRecommendDigests;
         }
         this.FPageIndex = 0;
         this.FUIPage.TotalQuantity = _loc2_.Count;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
         this.FCurrentDigests = _loc2_;
      }
      
      protected function ProcessorUpdateUIFriends() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUIFriend = null;
         var _loc6_:TFriendDigest = null;
         _loc3_ = this.FPageIndex;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_LISTITEMS)
         {
            _loc5_ = this.FUIFriends[_loc1_];
            _loc5_.Context = null;
            _loc5_.Visible = false;
            _loc1_++;
         }
         _loc2_ = this.FCurrentDigests.Count;
         if(_loc2_ <= 0)
         {
            return;
         }
         _loc4_ = _loc3_ * CAPACITY_LISTITEMS;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_LISTITEMS)
         {
            if(_loc1_ + _loc4_ >= _loc2_)
            {
               break;
            }
            _loc5_ = this.FUIFriends[_loc1_];
            _loc6_ = this.FCurrentDigests.GetDigestByIndex(_loc1_ + _loc4_);
            _loc5_.Context = _loc6_;
            _loc5_.Visible = true;
            _loc1_++;
         }
      }
      
      protected function Btn_CloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function UIFriendOnInvite(param1:Object, param2:TFriendDigest) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Invite_InvitePlayerReq);
         _loc4_ = _loc3_.Data;
         _loc4_.writeUnsignedInt(param2.Identifier0);
         _loc4_.writeUnsignedInt(param2.Identifier1);
         _loc4_.writeByte(SLogicsCore.TeamBattle.ModeType);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         this.FTabIndex = param1 as int;
         this.ProcessorFilterDigests();
         this.ProcessorUpdateUIFriends();
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.ProcessorUpdateUIFriends();
      }
      
      public function get InviteDigests() : TFriendDigests
      {
         return this.FInviteDigests;
      }
      
      public function set InviteDigests(param1:TFriendDigests) : void
      {
         this.FInviteDigests = param1;
      }
      
      public function Reset() : void
      {
         if(!this.FInitialization)
         {
            return;
         }
         this.FInviteDigests.Clear();
         this.FFriendDigests.Clear();
         this.FOrganizationDigests.Clear();
         this.FRecommendDigests.Clear();
         this.FCurrentDigests = null;
         this.FTabIndex = 0;
         this.FUITab.Reset();
         this.FPageIndex = 0;
         this.FUIPage.Reset();
      }
      
      public function Update() : void
      {
         this.ProcessorUpdateDigests();
         this.ProcessorFilterDigests();
         this.ProcessorUpdateUIFriends();
      }
   }
}

