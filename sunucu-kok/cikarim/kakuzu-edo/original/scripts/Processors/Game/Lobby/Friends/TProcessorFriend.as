package Processors.Game.Lobby.Friends
{
   import Components.Pages.*;
   import Components.Standard.*;
   import Debugging.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Streamization.Characters.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Friends.Components.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Editors.*;
   import Processors.Game.Windows.Information.*;
   import Rendering.Overlayers.Hints.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.Timing.*;
   import Utilities.UI.Overlayers.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorFriend extends TProcessorLobbyWindows
   {
      
      protected static const STAGE_Width:uint = CONST_COMMON.STAGE_Width;
      
      protected static const STAGE_Height:uint = CONST_COMMON.STAGE_Height;
      
      protected static const SIZE_WindowFriend_Width:uint = 396;
      
      protected static const SIZE_WindowFriend_Height:uint = 435;
      
      protected static const SIZE_WindowFriendAndRecommend_Width:uint = 715;
      
      protected static const SIZE_WindowFriendAndRecommend_Height:uint = 435;
      
      protected static const TIME_INTERVAL_UpdateFriendState:uint = 300000;
      
      protected static const CAPACITY_MC_Tabs:uint = CONST_FRIEND.CAPACITY_MC_Tabs;
      
      protected static const PAGESIZE_Listitem:uint = CONST_FRIEND.PAGESIZE_Listitem;
      
      protected static const CAPACITY_Listitem:uint = CONST_FRIEND.CAPACITY_Listitem;
      
      protected static const TYPE_White:uint = CONST_FRIEND.TYPE_White;
      
      protected static const TYPE_Black:uint = CONST_FRIEND.TYPE_Black;
      
      protected static const TYPE_Recommend:uint = CONST_FRIEND.TYPE_Recommend;
      
      protected static const TYPE_Whitelist_Add:uint = CONST_FRIEND.TYPE_Whitelist_Add;
      
      protected static const TYPE_Whitelist_Delete:uint = CONST_FRIEND.TYPE_Whitelist_Delete;
      
      protected static const TYPE_Blacklist_Add:uint = CONST_FRIEND.TYPE_Blacklist_Add;
      
      protected static const TYPE_Blacklist_Delete:uint = CONST_FRIEND.TYPE_Blacklist_Delete;
      
      protected static const MODE_INQUIRY_Internal:uint = 0;
      
      protected static const MODE_INQUIRY_External:uint = 1;
      
      protected var FUnstreamizerFriendDigests:TUnstreamizerFriendDigests;
      
      protected var FUnstreamizerFriendDigest:TUnstreamizerFriendDigest;
      
      protected var FUIWindowEditorString:TUIWindowEditorString;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FHelpTips:THint;
      
      protected var FWhiteDigests:TFriendDigests;
      
      protected var FBlackDigests:TFriendDigests;
      
      protected var FRecommendDigests:TFriendDigests;
      
      protected var FCurrentDigests:TFriendDigests;
      
      protected var FFriends:TFriendDigests;
      
      protected var FMC_Friend:Sprite;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FBtnRecommend_Close:SimpleButton;
      
      protected var FUITab:TUITab;
      
      protected var FUIPage:TUIPage;
      
      protected var FMC_Whitelist:Sprite;
      
      protected var FMC_Blacklist:Sprite;
      
      protected var FMC_RecommendView:Sprite;
      
      protected var FUIWhitelItems:Vector.<TUIItem>;
      
      protected var FUIBlackItems:Vector.<TUIItem>;
      
      protected var FUIRecommendItems:Vector.<TUIItem>;
      
      protected var FUICurrentItems:Vector.<TUIItem>;
      
      protected var FBtnRecommend:SimpleButton;
      
      protected var FBtnInquiry:SimpleButton;
      
      protected var FBtnAdd:SimpleButton;
      
      protected var FBtnRefresh:TUIButton;
      
      protected var FBtnOnekeyAdd:SimpleButton;
      
      protected var FBoundsFriend:TBounds;
      
      protected var FTabIndex:int;
      
      protected var FPageIndex:int;
      
      protected var FTickUpdate:int;
      
      protected var FHintRefresh:THint;
      
      protected var FInquiryMode:uint;
      
      protected var FTypeInquiry:uint;
      
      protected var FMaxWhitelist:uint;
      
      protected var FMaxBlacklist:uint;
      
      protected var FTimingRefreshReferenceTick:int;
      
      protected var FTimeIntervalRefreshRecommendFriend:uint;
      
      protected var FIsBtnRefreshOver:Boolean;
      
      protected var FRefreshOverCount:uint;
      
      protected var FIsRefreshRecommendFriend:Boolean;
      
      protected var FIsInitialization:Boolean;
      
      protected var FOnWhisper:Function;
      
      protected var FOnMail:Function;
      
      protected var FOnInquiryRet:Function;
      
      protected var FOnProcessFriendNtf:Function;
      
      public function TProcessorFriend(param1:TUIComponent, param2:TLobbyParameters)
      {
         super(param1,param2);
         this.FUnstreamizerFriendDigests = new TUnstreamizerFriendDigests();
         this.FUnstreamizerFriendDigest = new TUnstreamizerFriendDigest();
         this.FWhiteDigests = new TFriendDigests();
         this.FBlackDigests = new TFriendDigests();
         this.FRecommendDigests = new TFriendDigests();
         this.FFriends = SLogicsCore.Friends;
         this.FIsInitialization = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_FRIEND.RESOURCESID_Swf_Friend);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:Sprite = null;
         var _loc5_:TUIItem = null;
         var _loc6_:MovieClip = null;
         var _loc7_:MovieClip = null;
         var _loc8_:Sprite = null;
         var _loc9_:MovieClip = null;
         var _loc10_:TextField = null;
         var _loc11_:Sprite = null;
         var _loc12_:TConfigValue = null;
         var _loc13_:Vector.<String> = null;
         this.FHelpTips = new THint();
         this.FUIWhitelItems = new Vector.<TUIItem>(CAPACITY_Listitem);
         this.FUIBlackItems = new Vector.<TUIItem>(CAPACITY_Listitem);
         this.FUIRecommendItems = new Vector.<TUIItem>(CAPACITY_Listitem);
         this.FBoundsFriend = new TBounds();
         this.FBoundsFriend.Width = SIZE_WindowFriend_Width;
         this.FBoundsFriend.Height = SIZE_WindowFriend_Height;
         this.FUITab = new TUITab(this);
         this.FUIPage = new TUIPage(this);
         this.FHintRefresh = new THint();
         this.FMC_Friend = TUtilityReflection.CreateDisplayObjectInstance(CONST_FRIEND.RESOURCE_ClassName_MC_Friend) as Sprite;
         addChild(this.FMC_Friend);
         this.FBtn_Close = this.FMC_Friend[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Help = this.FMC_Friend[CONST_COMMON.RESOURCE_Link_Btn_Help];
         _loc13_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.FRIEND_STRING_10);
         _loc2_ = int(CAPACITY_MC_Tabs);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_Friend[CONST_COMMON.RESOURCE_Link_MC_Tab + _loc1_];
            this.FUITab.SetTabByIndex(_loc3_,_loc1_);
            this.FUITab.SetTabCaptionByIndex(_loc13_[_loc1_],_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         _loc4_ = this.FMC_Friend[CONST_FRIEND.RESOURCE_Link_MC_FriendMountPoint];
         this.FMC_Whitelist = TUtilityReflection.CreateDisplayObjectInstance(CONST_FRIEND.RESOURCE_ClassName_MC_Whitelist) as Sprite;
         this.FMC_Blacklist = TUtilityReflection.CreateDisplayObjectInstance(CONST_FRIEND.RESOURCE_ClassName_MC_Blacklist) as Sprite;
         _loc4_.addChild(this.FMC_Whitelist);
         _loc4_.addChild(this.FMC_Blacklist);
         this.FMC_Blacklist.visible = false;
         _loc2_ = int(CAPACITY_Listitem);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc7_ = this.FMC_Whitelist[CONST_FRIEND.RESOURCE_Link_MC_Listitem + _loc1_];
            _loc5_ = new TUIItem(this);
            _loc5_.Tag = _loc1_;
            _loc5_.OnWhisper = this.ListItemOnWhisper;
            _loc5_.OnMail = this.ListItemOnMail;
            _loc5_.OnDelete = this.ListItemOnDelete;
            _loc5_.Perform_UIDispatch(_loc7_);
            _loc5_.Init();
            this.FUIWhitelItems[_loc1_] = _loc5_;
            _loc1_++;
         }
         _loc2_ = int(CAPACITY_Listitem);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc7_ = this.FMC_Blacklist[CONST_FRIEND.RESOURCE_Link_MC_Listitem + _loc1_];
            _loc5_ = new TUIItem(this);
            _loc5_.Tag = _loc1_;
            _loc5_.OnDelete = this.ListItemOnDelete;
            _loc5_.Perform_UIDispatch(_loc7_);
            _loc5_.Init();
            this.FUIBlackItems[_loc1_] = _loc5_;
            _loc1_++;
         }
         _loc8_ = this.FMC_Friend[CONST_FRIEND.RESOURCE_Link_MC_Page];
         _loc9_ = _loc8_[CONST_FRIEND.RESOURCE_Link_MC_PageLeft];
         this.FUIPage.ButtonPrevious.Substrate = _loc9_;
         _loc9_ = _loc8_[CONST_FRIEND.RESOURCE_Link_MC_PageRight];
         this.FUIPage.ButtonNext.Substrate = _loc9_;
         _loc10_ = _loc8_[CONST_BACKPACK.RESOURCE_Link_TF_Page];
         this.FUIPage.LabelPage = _loc10_;
         this.FUIPage.PageSize = PAGESIZE_Listitem;
         this.FUIPage.Init();
         this.FBtnRecommend = this.FMC_Friend[CONST_FRIEND.RESOURCE_Link_Btn_Recommend];
         this.FBtnInquiry = this.FMC_Friend[CONST_FRIEND.RESOURCE_Link_Btn_Inquiry];
         this.FBtnAdd = this.FMC_Friend[CONST_FRIEND.RESOURCE_Link_Btn_Add];
         this.FBtnAdd.visible = false;
         this.FMC_RecommendView = this.FMC_Friend[CONST_FRIEND.RESOURCE_Link_MC_RecommendView];
         this.FBtnRecommend_Close = this.FMC_RecommendView[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtnRefresh = new TUIButton();
         this.FBtnRefresh.Substrate = this.FMC_RecommendView[CONST_FRIEND.RESOURCE_Link_Btn_Refresh];
         this.FBtnRefresh.OnClick = this.BtnRefreshOnClick;
         this.FBtnOnekeyAdd = this.FMC_RecommendView[CONST_FRIEND.RESOURCE_Link_Btn_OnekeyAdd];
         _loc11_ = this.FMC_RecommendView[CONST_FRIEND.RESOURCE_Link_MC_ListItem_Recommend];
         _loc2_ = int(CAPACITY_Listitem);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc7_ = _loc11_[CONST_FRIEND.RESOURCE_Link_MC_Listitem + _loc1_];
            _loc5_ = new TUIItem(this);
            _loc5_.Tag = _loc1_;
            _loc5_.OnAdd = this.ListItemOnAdd;
            _loc5_.Perform_UIDispatch(_loc7_);
            _loc5_.Init();
            this.FUIRecommendItems[_loc1_] = _loc5_;
            _loc1_++;
         }
         this.SetRecommendWindow();
         this.FUIWindowEditorString = SUtilityOverLayer.UIWindowEditorString;
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
         _loc12_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.FRIEND_RECOMMEND_REFRESH) as TConfigValue;
         this.FTimeIntervalRefreshRecommendFriend = _loc12_.Value as uint;
         this.FTimeIntervalRefreshRecommendFriend *= 1000;
         _loc12_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.FRIEND_NUM_LIMIT) as TConfigValue;
         this.FMaxWhitelist = _loc12_.Value as uint;
         _loc12_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ConfigValue,CONST_CONFIGVALUE.FRIEND_BLACK_LIMIT) as TConfigValue;
         this.FMaxBlacklist = _loc12_.Value as uint;
         TutorialSendComponent(CONST_FRESHGUIDE.MCID_FriendsView,this.FMC_Friend);
         TutorialSendArrowParent(CONST_FRESHGUIDE.MCID_FriendsView,this);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FUIPage.OnChangePage = this.PageOnChange;
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.BtnCloseOnClick,false,0,true);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_MOVE,this.ButtonHelpOnOver,false,0,true);
         this.FBtn_Help.addEventListener(MouseEvent.MOUSE_OUT,this.ButtonHelpOnOut,false,0,true);
         this.FBtnRecommend.addEventListener(MouseEvent.CLICK,this.BtnRecommendOnClick,false,0,true);
         this.FBtnInquiry.addEventListener(MouseEvent.CLICK,this.BtnInquiryOnClick,false,0,true);
         this.FBtnAdd.addEventListener(MouseEvent.CLICK,this.BtnAddOnClick,false,0,true);
         this.FBtnRecommend_Close.addEventListener(MouseEvent.CLICK,this.BtnRecommendCloseOnClick,false,0,true);
         this.FBtnOnekeyAdd.addEventListener(MouseEvent.CLICK,this.BtnOnekeyAddOnClick,false,0,true);
         this.FIsInitialization = true;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Friend_LoadFriendResult,this.PerformPacket_SC_Friend_LoadFriendResult);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Friend_LoadRecommendFriendResult,this.PerformPacket_SC_Friend_LoadRecommendFriendResult);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Friend_ProcessFriendRet,this.PerformPacket_SC_Friend_ProcessFriendRet);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Friend_FriendState,this.PerformPacket_SC_Friend_FriendState);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Friend_InquiryFriendIDRet,this.PerformPacket_SC_Friend_InquiryFriendIDRet);
      }
      
      protected function PerformPacket_SC_Friend_LoadFriendResult(param1:TPacket) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:ByteArray = null;
         _loc3_ = param1.Data;
         _loc2_ = _loc3_.readUnsignedInt();
         if(_loc2_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc2_);
            return;
         }
         this.FUnstreamizerFriendDigests.Unstreamize(_loc3_,this.FFriends,null);
      }
      
      protected function PerformPacket_SC_Friend_LoadRecommendFriendResult(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:ByteArray = null;
         var _loc6_:TFriendDigest = null;
         var _loc7_:TFriendDigest = null;
         _loc5_ = param1.Data;
         _loc4_ = _loc5_.readUnsignedInt();
         if(_loc4_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc4_);
            return;
         }
         this.FUnstreamizerFriendDigests.Unstreamize(_loc5_,this.FRecommendDigests,null);
         _loc3_ = this.FRecommendDigests.Count;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = this.FRecommendDigests.GetDigestByIndex(_loc2_);
            _loc7_ = this.FFriends.GetDigestByIdentifier(_loc6_.Identifier0,_loc6_.Identifier1);
            if(_loc7_ == null)
            {
               this.FFriends.Add(_loc6_);
            }
            _loc2_++;
         }
         this.UpdateUserFriendDigests();
         this.UpdateListItemRecommendFriend();
      }
      
      protected function PerformPacket_SC_Friend_ProcessFriendRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:TFriendDigest = null;
         var _loc6_:TFriendDigest = null;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc4_ = _loc2_.readUnsignedByte();
         _loc5_ = SLogicsCore.PoolCharacter.AcquireFriendDigest();
         this.FUnstreamizerFriendDigest.Unstreamize(_loc2_,_loc5_,null);
         _loc6_ = this.FFriends.GetDigestByIdentifier(_loc5_.Identifier0,_loc5_.Identifier1);
         switch(_loc4_)
         {
            case TYPE_Whitelist_Add:
               if(_loc6_ != null)
               {
                  _loc6_.Type = _loc5_.Type;
               }
               else
               {
                  this.FFriends.Add(_loc5_);
               }
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FRIEND_STRING_09));
               break;
            case TYPE_Blacklist_Add:
               if(_loc6_ != null)
               {
                  _loc6_.Type = _loc5_.Type;
               }
               else
               {
                  this.FFriends.Add(_loc5_);
               }
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FRIEND_STRING_11));
               break;
            case TYPE_Whitelist_Delete:
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FRIEND_STRING_12));
               this.FFriends.DeleteByDigest(_loc5_);
               break;
            case TYPE_Blacklist_Delete:
               EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FRIEND_STRING_13));
               this.FFriends.DeleteByDigest(_loc5_);
         }
         if(this.FOnProcessFriendNtf != null)
         {
            this.FOnProcessFriendNtf(this,_loc5_);
         }
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.UpdateUserFriendDigests();
         this.UpdateListFriends();
         this.UpdateListItemRecommendFriend();
      }
      
      protected function PerformPacket_SC_Friend_FriendState(param1:TPacket) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:ByteArray = null;
         var _loc5_:uint = 0;
         var _loc6_:TFriendDigest = null;
         var _loc7_:Boolean = false;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         _loc4_ = param1.Data;
         _loc5_ = _loc4_.readUnsignedInt();
         if(_loc5_ != 0)
         {
            EffectGenerateTextByErrorCode(_loc5_);
            return;
         }
         _loc3_ = int(_loc4_.readUnsignedShort());
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc8_ = _loc4_.readUnsignedInt();
            _loc9_ = _loc4_.readUnsignedInt();
            _loc6_ = this.FFriends.GetDigestByIdentifier(_loc8_,_loc9_);
            if(_loc6_ != null)
            {
               _loc6_.IsOnline = _loc4_.readBoolean();
            }
            else
            {
               _loc7_ = _loc4_.readBoolean();
            }
            _loc2_++;
         }
         if(this.Visible)
         {
            this.UpdateListItemFriendDigests(this.FCurrentDigests,this.FUICurrentItems);
         }
      }
      
      protected function PerformPacket_SC_Friend_InquiryFriendIDRet(param1:TPacket) : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:uint = 0;
         var _loc4_:TFriendDigest = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc2_ = param1.Data;
         _loc3_ = _loc2_.readUnsignedInt();
         if(_loc3_ != 0)
         {
            if(this.FInquiryMode == MODE_INQUIRY_External)
            {
               this.FInquiryMode = MODE_INQUIRY_Internal;
               if(this.FOnInquiryRet != null)
               {
                  this.FOnInquiryRet(this,0,0);
               }
               return;
            }
            EffectGenerateTextByErrorCode(_loc3_);
            return;
         }
         _loc5_ = _loc2_.readUnsignedInt();
         _loc6_ = _loc2_.readUnsignedInt();
         if(this.FInquiryMode == MODE_INQUIRY_External)
         {
            if(this.FOnInquiryRet != null)
            {
               this.FOnInquiryRet(this,_loc5_,_loc6_);
            }
            this.FInquiryMode = MODE_INQUIRY_Internal;
         }
         _loc4_ = SLogicsCore.PoolCharacter.AcquireFriendDigest(_loc5_,_loc6_);
         this.ProcessOperatingFriends(this.FTypeInquiry,_loc4_,null);
         this.FTypeInquiry = 0;
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         super.LogicsPerform();
         if(!this.Visible)
         {
            return;
         }
         _loc1_ = int(STimingCore.TickCount);
         this.LogicsPerform_RefreshRecommendFriend(_loc1_);
      }
      
      protected function LogicsPerform_RefreshRecommendFriend(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         if(this.FIsRefreshRecommendFriend)
         {
            if(param1 - this.FTimingRefreshReferenceTick >= this.FTimeIntervalRefreshRecommendFriend)
            {
               this.FFriends.ClearListByType(TYPE_Recommend);
               this.UpdateUserFriendDigests();
               this.UpdateListItemRecommendFriend();
               this.FBtnRefresh.OnMove = null;
               this.FBtnRefresh.OnOut = null;
               this.FBtnRefresh.Enabled = true;
               this.FIsRefreshRecommendFriend = false;
               this.BtnRefreshOnOut(this,null);
               SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHintRefresh);
            }
            if(this.FIsBtnRefreshOver)
            {
               if(param1 % 150 > 100)
               {
                  _loc3_ = (this.FTimeIntervalRefreshRecommendFriend - (param1 - this.FTimingRefreshReferenceTick)) / 1000;
                  _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FRIEND_STRING_01);
                  _loc2_ = TUtilityString.Format(_loc4_,TUtilityTiming.FormatDHMBySeconds(_loc3_));
                  this.FHintRefresh.Caption = _loc2_;
                  SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHintRefresh);
               }
            }
            else if(this.FRefreshOverCount == 0)
            {
               SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHintRefresh);
               ++this.FRefreshOverCount;
            }
         }
      }
      
      protected function SetRecommendWindow(param1:Boolean = false) : void
      {
         this.FMC_RecommendView.visible = param1;
         if(param1)
         {
            this.FBoundsFriend.Width = SIZE_WindowFriendAndRecommend_Width;
            this.FBoundsFriend.Height = SIZE_WindowFriendAndRecommend_Height;
         }
         else
         {
            this.FBoundsFriend.Width = SIZE_WindowFriend_Width;
            this.FBoundsFriend.Height = SIZE_WindowFriend_Height;
         }
         this.SetComponentBoundsCenter(this.FMC_Friend,this.FBoundsFriend);
      }
      
      protected function SetComponentBoundsCenter(param1:DisplayObject, param2:TBounds) : void
      {
         param1.x = (STAGE_Width - param2.Width) / 2;
         param1.y = (STAGE_Height - param2.Height) / 2;
      }
      
      protected function UpdateUserFriendDigests() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TFriendDigest = null;
         this.FWhiteDigests.Clear();
         this.FBlackDigests.Clear();
         this.FRecommendDigests.Clear();
         _loc2_ = this.FFriends.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FFriends.GetDigestByIndex(_loc1_);
            switch(_loc3_.Type)
            {
               case TYPE_White:
                  this.FWhiteDigests.Add(_loc3_);
                  break;
               case TYPE_Black:
                  this.FBlackDigests.Add(_loc3_);
                  break;
               case TYPE_Recommend:
                  this.FRecommendDigests.Add(_loc3_);
            }
            _loc1_++;
         }
         this.FWhiteDigests.SortLevel();
         this.FBlackDigests.SortLevel();
         this.FRecommendDigests.SortLevel();
      }
      
      protected function UpdateListFriends() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TFriendDigests = null;
         var _loc3_:Vector.<TUIItem> = null;
         _loc1_ = this.FTabIndex;
         switch(_loc1_)
         {
            case 0:
               _loc2_ = this.FWhiteDigests;
               _loc3_ = this.FUIWhitelItems;
               break;
            case 1:
               _loc2_ = this.FBlackDigests;
               _loc3_ = this.FUIBlackItems;
         }
         this.FCurrentDigests = _loc2_;
         this.FUICurrentItems = _loc3_;
         this.FPageIndex = 0;
         this.FUIPage.TotalQuantity = _loc2_.Count;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
         this.UpdateListItemFriendDigests(_loc2_,_loc3_);
      }
      
      protected function UpdateListItemRecommendFriend() : void
      {
         this.UpdateRecommendListItemFriendDigests(this.FRecommendDigests,this.FUIRecommendItems);
      }
      
      protected function UpdateListItemFriendDigests(param1:TFriendDigests, param2:Vector.<TUIItem>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TUIItem = null;
         var _loc8_:TFriendDigest = null;
         _loc5_ = this.FPageIndex;
         _loc4_ = int(CAPACITY_Listitem);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = param2[_loc3_];
            _loc7_.SetVisible(false);
            _loc3_++;
         }
         _loc4_ = param1.Count;
         if(_loc4_ <= 0)
         {
            return;
         }
         _loc6_ = _loc5_ * CAPACITY_Listitem;
         _loc3_ = 0;
         while(_loc3_ < CAPACITY_Listitem)
         {
            if(_loc3_ + _loc6_ >= _loc4_)
            {
               break;
            }
            _loc7_ = param2[_loc3_];
            _loc8_ = param1.GetDigestByIndex(_loc3_ + _loc6_);
            _loc7_.Context = _loc8_;
            _loc7_.SetVisible(true);
            _loc3_++;
         }
      }
      
      protected function UpdateRecommendListItemFriendDigests(param1:TFriendDigests, param2:Vector.<TUIItem>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUIItem = null;
         var _loc6_:TFriendDigest = null;
         _loc4_ = int(CAPACITY_Listitem);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param2[_loc3_];
            _loc5_.SetVisible(false);
            _loc3_++;
         }
         _loc4_ = param1.Count;
         if(_loc4_ <= 0)
         {
            return;
         }
         _loc3_ = 0;
         while(_loc3_ < CAPACITY_Listitem)
         {
            if(_loc3_ >= _loc4_)
            {
               break;
            }
            _loc5_ = param2[_loc3_];
            _loc6_ = param1.GetDigestByIndex(_loc3_);
            _loc5_.Context = _loc6_;
            _loc5_.SetVisible(true);
            _loc3_++;
         }
      }
      
      protected function ProcessOperatingFriends(param1:uint, param2:TFriendDigest, param3:TFriendDigests) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TPacket = null;
         var _loc7_:ByteArray = null;
         var _loc8_:TFriendDigest = null;
         var _loc9_:uint = 0;
         var _loc10_:uint = 0;
         _loc6_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Friend_ProcessFriendReq);
         _loc7_ = _loc6_.Data;
         _loc7_.writeByte(param1);
         if(param2 != null)
         {
            _loc7_.writeShort(1);
            _loc9_ = param2.Identifier0;
            _loc10_ = param2.Identifier1;
            _loc7_.writeUnsignedInt(_loc9_);
            _loc7_.writeUnsignedInt(_loc10_);
         }
         else if(param3 != null)
         {
            _loc5_ = param3.Count;
            if(_loc5_ == 0)
            {
               return;
            }
            _loc7_.writeShort(_loc5_);
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc8_ = param3.GetDigestByIndex(_loc4_);
               _loc9_ = _loc8_.Identifier0;
               _loc10_ = _loc8_.Identifier1;
               _loc7_.writeUnsignedInt(_loc9_);
               _loc7_.writeUnsignedInt(_loc10_);
               _loc4_++;
            }
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc6_);
      }
      
      protected function ProcessorRecommendFriendListReq() : void
      {
         var _loc1_:TPacket = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Friend_LoadRecommendFriend);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
      }
      
      protected function ProcessorInquiryFriendIDReq(param1:String) : void
      {
         var _loc2_:TPacket = null;
         var _loc3_:ByteArray = null;
         _loc2_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Friend_InquiryFriendIDReq);
         _loc3_ = _loc2_.Data;
         TUtilityString.FlushUTF(_loc3_,param1);
         SNetworkCore.Transceiver.PacketTransmit(_loc2_);
      }
      
      protected function UpdateFriendState() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:TFriendDigest = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         _loc2_ = this.FWhiteDigests.Count;
         if(_loc2_ == 0)
         {
            return;
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Friend_FriendState);
         _loc4_ = _loc3_.Data;
         _loc4_.writeShort(_loc2_);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FWhiteDigests.GetDigestByIndex(_loc1_);
            _loc6_ = _loc5_.Identifier0;
            _loc7_ = _loc5_.Identifier1;
            _loc4_.writeUnsignedInt(_loc6_);
            _loc4_.writeUnsignedInt(_loc7_);
            _loc1_++;
         }
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
      }
      
      protected function VerificationAddFriend(param1:uint) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         var _loc4_:TFriendDigests = null;
         _loc2_ = true;
         switch(param1)
         {
            case TYPE_Whitelist_Add:
               _loc3_ = this.FMaxWhitelist;
               _loc4_ = this.FWhiteDigests;
               break;
            case TYPE_Blacklist_Add:
               _loc3_ = this.FMaxBlacklist;
               _loc4_ = this.FBlackDigests;
         }
         if(_loc4_.Count >= _loc3_)
         {
            _loc2_ = false;
         }
         return _loc2_;
      }
      
      override protected function PopTipsNotifyCheck() : void
      {
         if(FOnCheckPopTipsModes != null)
         {
            FOnCheckPopTipsModes(this,CONST_POPTIPS.POPTIP_Goto_Friend);
         }
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         this.FTabIndex = param1 as int;
         this.FMC_Whitelist.visible = false;
         this.FMC_Blacklist.visible = false;
         this.FBtnRecommend.visible = false;
         this.FBtnInquiry.visible = false;
         this.FBtnAdd.visible = false;
         switch(this.FTabIndex)
         {
            case 0:
               this.FMC_Whitelist.visible = true;
               this.FBtnRecommend.visible = true;
               this.FBtnInquiry.visible = true;
               break;
            case 1:
               this.FMC_Blacklist.visible = true;
               this.FBtnAdd.visible = true;
         }
         this.FUIPage.Reset();
         this.FPageIndex = 0;
         this.UpdateListFriends();
      }
      
      protected function PageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdateListItemFriendDigests(this.FCurrentDigests,this.FUICurrentItems);
      }
      
      protected function BtnCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorClose();
      }
      
      protected function ButtonHelpOnOver(param1:MouseEvent) : void
      {
         if(TUtilityString.Empty(this.FHelpTips.Content))
         {
            this.FHelpTips.Content = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.HELPTIPS_Friend);
         }
         SUtilityOverLayer.UIComponentsHintOnOver(this,this.FHelpTips);
      }
      
      protected function ButtonHelpOnOut(param1:MouseEvent) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,this.FHelpTips);
      }
      
      protected function BtnRecommendOnClick(param1:MouseEvent) : void
      {
         this.UpdateListItemRecommendFriend();
         this.FMC_RecommendView.visible = !this.FMC_RecommendView.visible;
         this.SetRecommendWindow(this.FMC_RecommendView.visible);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickRecommandBtn);
      }
      
      protected function BtnInquiryOnClick(param1:MouseEvent) : void
      {
         this.FTypeInquiry = TYPE_Whitelist_Add;
         this.FUIWindowEditorString.Tag = TYPE_Whitelist_Add;
         this.FUIWindowEditorString.Label = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FRIEND_STRING_02);
         this.FUIWindowEditorString.MaxChars = 32;
         this.FUIWindowEditorString.Restrict = null;
         this.FUIWindowEditorString.OnOK = this.WindowEditorStringOnOK;
         this.FUIWindowEditorString.OnCancel = this.WindowEditorStringOnCancel;
         this.FUIWindowEditorString.SetFocus();
         this.FUIWindowEditorString.Visible = true;
      }
      
      protected function BtnAddOnClick(param1:MouseEvent) : void
      {
         this.FTypeInquiry = TYPE_Blacklist_Add;
         this.FUIWindowEditorString.Tag = TYPE_Blacklist_Add;
         this.FUIWindowEditorString.Label = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FRIEND_STRING_02);
         this.FUIWindowEditorString.MaxChars = 32;
         this.FUIWindowEditorString.Restrict = null;
         this.FUIWindowEditorString.OnOK = this.WindowEditorStringOnOK;
         this.FUIWindowEditorString.OnCancel = this.WindowEditorStringOnCancel;
         this.FUIWindowEditorString.SetFocus();
         this.FUIWindowEditorString.Visible = true;
      }
      
      protected function BtnRecommendCloseOnClick(param1:MouseEvent) : void
      {
         this.FMC_RecommendView.visible = false;
         this.SetRecommendWindow();
      }
      
      protected function BtnRefreshOnClick(param1:Object, param2:MouseEvent) : void
      {
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickRefreshBtn);
         if(this.FIsRefreshRecommendFriend)
         {
            return;
         }
         this.ProcessorRecommendFriendListReq();
         this.FBtnRefresh.Enabled = false;
         this.FIsRefreshRecommendFriend = true;
         this.FTimingRefreshReferenceTick = STimingCore.TickCount;
         this.FBtnRefresh.OnMove = this.BtnRefreshOnOver;
         this.FBtnRefresh.OnOut = this.BtnRefreshOnOut;
         this.BtnRefreshOnOver(this,null);
      }
      
      protected function BtnRefreshOnOver(param1:Object, param2:MouseEvent) : void
      {
         this.FIsBtnRefreshOver = true;
      }
      
      protected function BtnRefreshOnOut(param1:Object, param2:MouseEvent) : void
      {
         this.FIsBtnRefreshOver = false;
         this.FRefreshOverCount = 0;
      }
      
      protected function BtnOnekeyAddOnClick(param1:MouseEvent) : void
      {
         this.ProcessOperatingFriends(TYPE_Whitelist_Add,null,this.FRecommendDigests);
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_ClickAddFriendOneKey);
      }
      
      protected function ListItemOnWhisper(param1:Object, param2:TFriendDigest) : void
      {
         if(this.FOnWhisper != null)
         {
            this.FOnWhisper(this,param2);
            ProcessorClose();
         }
      }
      
      protected function ListItemOnMail(param1:Object, param2:TFriendDigest) : void
      {
         if(this.FOnMail != null)
         {
            this.FOnMail(this,param2);
         }
      }
      
      protected function ListItemOnDelete(param1:Object, param2:TFriendDigest) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         _loc6_ = this.FTabIndex;
         switch(_loc6_)
         {
            case 0:
               _loc3_ = TYPE_Whitelist_Delete;
               _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FRIEND_STRING_03);
               break;
            case 1:
               _loc3_ = TYPE_Blacklist_Delete;
               _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FRIEND_STRING_04);
         }
         _loc5_ = TUtilityString.Format(_loc4_,param2.Name);
         this.FUIWindowConfirmation.Text = _loc5_;
         this.FUIWindowConfirmation.Tag = _loc3_;
         this.FUIWindowConfirmation.Context = param2;
         this.FUIWindowConfirmation.OnOK = this.WindowConfirmationOnOK;
         this.FUIWindowConfirmation.Visible = true;
      }
      
      protected function ListItemOnAdd(param1:Object, param2:TFriendDigest) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         _loc4_ = this.FTabIndex;
         switch(_loc4_)
         {
            case 0:
               _loc3_ = TYPE_Whitelist_Add;
               break;
            case 1:
               _loc3_ = TYPE_Blacklist_Add;
         }
         this.ProcessOperatingFriends(_loc3_,param2,null);
      }
      
      protected function WindowEditorStringOnOK(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:uint = 0;
         var _loc8_:TFriendDigest = null;
         _loc2_ = this.FUIWindowEditorString.Value;
         if(!TUtilityString.Empty(_loc2_))
         {
            _loc8_ = this.FFriends.GetDigestByName(_loc2_);
            if(_loc8_ != null)
            {
               switch(_loc8_.Type)
               {
                  case TYPE_White:
                     _loc7_ = TYPE_Blacklist_Add;
                     _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FRIEND_STRING_06);
                     break;
                  case TYPE_Black:
                     _loc7_ = TYPE_Whitelist_Add;
                     _loc4_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FRIEND_STRING_05);
               }
               _loc5_ = TUtilityString.Format(_loc4_,_loc8_.Name);
               this.FUIWindowConfirmation.Text = _loc5_;
               this.FUIWindowConfirmation.Tag = _loc7_;
               this.FUIWindowConfirmation.Context = _loc8_;
               this.FUIWindowConfirmation.OnOK = this.WindowConfirmationOnOK;
               this.FUIWindowConfirmation.Visible = true;
            }
            else
            {
               _loc3_ = this.VerificationAddFriend(this.FUIWindowEditorString.Tag);
               if(_loc3_)
               {
                  this.ProcessorInquiryFriendIDReq(_loc2_);
                  this.FInquiryMode = MODE_INQUIRY_Internal;
               }
               else
               {
                  switch(this.FUIWindowEditorString.Tag)
                  {
                     case TYPE_Whitelist_Add:
                        _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FRIEND_STRING_07);
                        break;
                     case TYPE_Blacklist_Add:
                        _loc6_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.FRIEND_STRING_08);
                  }
                  EffectGenerateText(_loc6_);
               }
            }
         }
         this.FUIWindowEditorString.Value = "";
      }
      
      protected function WindowConfirmationOnOK(param1:Object) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:TFriendDigest = null;
         _loc2_ = uint(this.FUIWindowConfirmation.Tag);
         _loc3_ = this.FUIWindowConfirmation.Context as TFriendDigest;
         this.ProcessOperatingFriends(_loc2_,_loc3_,null);
      }
      
      protected function WindowEditorStringOnCancel(param1:Object) : void
      {
         this.FUIWindowEditorString.Value = "";
      }
      
      public function get OnWhisper() : Function
      {
         return this.FOnWhisper;
      }
      
      public function set OnWhisper(param1:Function) : void
      {
         this.FOnWhisper = param1;
      }
      
      public function get OnMail() : Function
      {
         return this.FOnMail;
      }
      
      public function set OnMail(param1:Function) : void
      {
         this.FOnMail = param1;
      }
      
      public function get OnInquiryRet() : Function
      {
         return this.FOnInquiryRet;
      }
      
      public function set OnInquiryRet(param1:Function) : void
      {
         this.FOnInquiryRet = param1;
      }
      
      public function get OnProcessFriendNtf() : Function
      {
         return this.FOnProcessFriendNtf;
      }
      
      public function set OnProcessFriendNtf(param1:Function) : void
      {
         this.FOnProcessFriendNtf = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount();
         if(!FIsResourcesLoadCompleted)
         {
            return;
         }
         this.UpdateUserFriendDigests();
         this.UpdateListFriends();
         this.SetRecommendWindow();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_OpenFriends);
      }
      
      override public function Unmount() : void
      {
         this.FTabIndex = 0;
         this.FUITab.Reset();
         this.FPageIndex = 0;
         this.FUIPage.Reset();
         TutorialNextStep(CONST_FRESHGUIDE.EVENTID_CloseFriends);
      }
      
      public function ProcessorInquiryCharacterIDByNickname(param1:String) : void
      {
         this.ProcessorInquiryFriendIDReq(param1);
         this.FInquiryMode = MODE_INQUIRY_External;
      }
      
      public function ProcessorInterpersonalRelationshipsReq(param1:uint, param2:Object) : void
      {
         var _loc3_:TFriendDigest = null;
         _loc3_ = param2 as TFriendDigest;
         this.ProcessOperatingFriends(param1,_loc3_,null);
      }
   }
}

