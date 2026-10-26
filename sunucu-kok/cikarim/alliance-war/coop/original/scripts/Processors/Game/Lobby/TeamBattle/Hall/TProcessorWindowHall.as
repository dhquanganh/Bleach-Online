package Processors.Game.Lobby.TeamBattle.Hall
{
   import Components.Drops.*;
   import Components.Lists.*;
   import Components.Lists.Data.*;
   import Components.Pages.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.Rooms.*;
   import Logics.TeamBattle.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.TeamBattle.Hall.Components.*;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Editors.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorWindowHall extends TProcessorLobbyWindow
   {
      
      protected static const CAPACITY_Rooms:uint = CONST_TEAMBATTLE.CAPACITY_Rooms;
      
      protected static const CAPACITY_Friends:uint = CONST_TEAMBATTLE.CAPACITY_Friends;
      
      protected static const CAPACITY_Tabs:uint = CONST_TEAMBATTLE.CAPACITY_Tabs;
      
      protected static const MODE_TEAMBATTLE_PVE:uint = CONST_TEAMBATTLE.MODE_TEAMBATTLE_PVE;
      
      protected static const MODE_TEAMBATTLE_PVP:uint = CONST_TEAMBATTLE.MODE_TEAMBATTLE_PVP;
      
      protected static const TYPE_ENTER_NORMAL:uint = CONST_TEAMBATTLE.TYPE_ENTER_NORMAL;
      
      protected static const TYPE_ENTER_QUICK:uint = CONST_TEAMBATTLE.TYPE_ENTER_QUICK;
      
      protected var FCharacter:TCharacter;
      
      protected var FLeagueMapPves:TBins;
      
      protected var FLeagueMapPvps:TBins;
      
      protected var FTeamBattle:TTeamBattle;
      
      protected var FRoomDigests:TRoomDigests;
      
      protected var FFriendDigests:TDigests;
      
      protected var FHint:THint;
      
      protected var FUIWindowEditorString:TUIWindowEditorString;
      
      protected var FSP_TeamBattleHall:Sprite;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FTF_Title:TextField;
      
      protected var FSP_PVE_Select:Sprite;
      
      protected var FSP_PVP_Select:Sprite;
      
      protected var FUIDropList:TUIDropList;
      
      protected var FUIList:TUIList;
      
      protected var FUIRooms:Vector.<TUIRoom>;
      
      protected var FUIPageRoom:TUIPage;
      
      protected var FUIFriends:Vector.<TUIFriend>;
      
      protected var FUIPageFriend:TUIPage;
      
      protected var FUITabs:TUITab;
      
      protected var FBtn_QuickPVE:TUIButton;
      
      protected var FBtn_CreatePVE:TUIButton;
      
      protected var FBtn_QuickPVP:TUIButton;
      
      protected var FBtn_CreatePVP:TUIButton;
      
      protected var FBtn_Search:TUIButton;
      
      protected var FTF_Search:TextField;
      
      protected var FSP_Password:Sprite;
      
      protected var FBtn_Setup:TUIButton;
      
      protected var FTF_Password:TextField;
      
      protected var FSP_modifed:Sprite;
      
      protected var FBtn_Unselect:TUIButton;
      
      protected var FBtn_Selected:TUIButton;
      
      protected var FFilterRoomDigests:TRoomDigests;
      
      protected var FFilterRoomModel:Function;
      
      protected var FModels:TModels;
      
      protected var FCurModelID:uint;
      
      protected var FEnterRoomID:int;
      
      protected var FEnterPassword:String;
      
      protected var FTabIndex:int;
      
      protected var FPageRoomIndex:int;
      
      protected var FPageFriendIndex:int;
      
      protected var FFilterModelID:uint;
      
      protected var FPVPCurLevel:uint;
      
      protected var FInitialization:Boolean;
      
      protected var FHintOnOver:Function;
      
      protected var FHintOnOut:Function;
      
      protected var FOnCreateRoom:Function;
      
      protected var FOnWhisper:Function;
      
      public function TProcessorWindowHall(param1:TUIComponent)
      {
         super(param1);
         this.FCharacter = SLogicsCore.Character;
         this.FTeamBattle = SLogicsCore.TeamBattle;
         this.FFilterRoomDigests = new TRoomDigests();
         this.FEnterPassword = "";
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_TEAMBATTLE.RESOURCESID_Swf_TeamBattleHall);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Sprite = null;
         var _loc3_:MovieClip = null;
         var _loc4_:TUIRoom = null;
         var _loc5_:TUIFriend = null;
         var _loc6_:TLeagueMapPvp = null;
         this.FHint = new THint();
         this.FLeagueMapPves = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_LeagueMapPve);
         this.FLeagueMapPvps = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_LeagueMapPvp);
         this.FSP_TeamBattleHall = TUtilityReflection.CreateDisplayObjectInstance(CONST_TEAMBATTLE.RESOURCE_ClassName_SP_TeamBattleHall) as Sprite;
         addChild(this.FSP_TeamBattleHall);
         this.FBtn_Close = this.FSP_TeamBattleHall[CONST_COMMON.RESOURCE_Link_Btn_Close];
         this.FBtn_Close.tabEnabled = false;
         this.FTF_Title = this.FSP_TeamBattleHall[CONST_TEAMBATTLE.RESOURCE_Link_TF_Title];
         this.FTF_Title.text = "";
         this.FSP_PVE_Select = this.FSP_TeamBattleHall[CONST_TEAMBATTLE.RESOURCE_Link_SP_PVE_Select];
         this.FSP_PVP_Select = this.FSP_TeamBattleHall[CONST_TEAMBATTLE.RESOURCE_Link_SP_PVP_Select];
         this.FSP_PVE_Select.visible = false;
         this.FSP_PVP_Select.visible = false;
         this.FUITabs = new TUITab(null);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Tabs)
         {
            _loc3_ = this.FSP_PVP_Select[CONST_TEAMBATTLE.RESOURCE_Link_Tab_Level + _loc1_];
            (_loc3_.getChildAt(1) as TextField).mouseEnabled = false;
            this.FUITabs.SetTabByIndex(_loc3_,_loc1_);
            _loc6_ = this.FLeagueMapPvps.GetDatebaseByIndex(_loc1_) as TLeagueMapPvp;
            this.FUITabs.SetTabCaptionByIndex(TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_40),_loc6_.OpenLevel),_loc1_);
            _loc1_++;
         }
         this.FUITabs.OnSwitch = this.TabsOnSwitch;
         this.FUITabs.OnOver = this.TabsOnOver;
         this.FUITabs.OnOut = this.TabsOnOut;
         this.FUITabs.Init();
         this.FUIDropList = new TUIDropList(this);
         this.FUIDropList.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_Link_SP_Drop) as Sprite;
         this.FUIDropList.OnClick = this.UIDropListOnClick;
         _loc2_ = this.FSP_PVE_Select[CONST_COMMON.RESOURCE_Link_SP_DropList];
         _loc2_.addChild(this.FUIDropList);
         this.FUIList = this.FUIDropList.UIList;
         this.FUIList.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_Link_SP_ListPanel) as Sprite;
         this.FUIList.ScrollBarResource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_Link_SP_ScrollBar) as Sprite;
         this.FUIList.ScrollBar.Zoom9GridX = 4;
         this.FUIList.ScrollBar.Zoom9GridY = 5;
         this.FUIList.ScrollBar.Zoom9GridWidth = 2;
         this.FUIList.ScrollBar.Zoom9GridHeigh = 1;
         this.FUIDropList.Perform_UIDispatch();
         this.FUIList.EvaluateBoundScreen();
         this.FUIRooms = new Vector.<TUIRoom>(CAPACITY_Rooms);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Rooms)
         {
            _loc4_ = new TUIRoom(null);
            _loc4_.Resource = this.FSP_TeamBattleHall[CONST_TEAMBATTLE.RESOURCE_Link_MC_Room + _loc1_];
            _loc4_.Perform_UIDispatch();
            _loc4_.Visible = false;
            _loc4_.OnClick = this.UIRoomOnClick;
            this.FUIRooms[_loc1_] = _loc4_;
            _loc1_++;
         }
         this.FUIPageRoom = new TUIPage(null);
         this.FUIPageRoom.OnChangePage = this.PageRoomOnChange;
         this.FUIPageRoom.ButtonPrevious.Substrate = this.FSP_TeamBattleHall[CONST_COMMON.RESOURCE_Link_MC_PageLeft];
         this.FUIPageRoom.ButtonNext.Substrate = this.FSP_TeamBattleHall[CONST_COMMON.RESOURCE_Link_MC_PageRight];
         this.FUIPageRoom.LabelPage = this.FSP_TeamBattleHall[CONST_COMMON.RESOURCE_Link_TF_Page];
         this.FUIPageRoom.LabelPage.text = "0/0";
         this.FUIPageRoom.PageSize = CAPACITY_Rooms;
         this.FUIPageRoom.Init();
         this.FUIFriends = new Vector.<TUIFriend>(CAPACITY_Friends);
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Friends)
         {
            _loc5_ = new TUIFriend(null);
            _loc5_.Resource = this.FSP_TeamBattleHall[CONST_TEAMBATTLE.RESOURCE_Link_SP_FriendItem + _loc1_];
            _loc5_.OnWhisper = this.UIFriendOnWhisper;
            _loc5_.Perform_UIDispatch();
            this.FUIFriends[_loc1_] = _loc5_;
            _loc1_++;
         }
         this.FUIPageFriend = new TUIPage(null);
         this.FUIPageFriend.OnChangePage = this.PageFriendOnChange;
         this.FUIPageFriend.ButtonPrevious.Substrate = this.FSP_TeamBattleHall[CONST_COMMON.RESOURCE_Link_MC_PageLeft + 1];
         this.FUIPageFriend.ButtonNext.Substrate = this.FSP_TeamBattleHall[CONST_COMMON.RESOURCE_Link_MC_PageRight + 1];
         this.FUIPageFriend.LabelPage = this.FSP_TeamBattleHall[CONST_COMMON.RESOURCE_Link_TF_Page + 1];
         this.FUIPageFriend.LabelPage.text = "0/0";
         this.FUIPageFriend.PageSize = CAPACITY_Friends;
         this.FUIPageFriend.Init();
         this.FBtn_QuickPVE = new TUIButton();
         this.FBtn_QuickPVE.Substrate = this.FSP_TeamBattleHall[CONST_TEAMBATTLE.RESOURCE_Link_Btn_QuickPVE];
         this.FBtn_QuickPVE.OnClick = this.Btn_QuickOnClick;
         this.FBtn_CreatePVE = new TUIButton();
         this.FBtn_CreatePVE.Substrate = this.FSP_TeamBattleHall[CONST_TEAMBATTLE.RESOURCE_Link_Btn_CreatePVE];
         this.FBtn_CreatePVE.OnClick = this.Btn_CreateOnClick;
         this.FBtn_QuickPVP = new TUIButton();
         this.FBtn_QuickPVP.Substrate = this.FSP_TeamBattleHall[CONST_TEAMBATTLE.RESOURCE_Link_Btn_QuickPVP];
         this.FBtn_QuickPVP.OnClick = this.Btn_QuickOnClick;
         this.FBtn_CreatePVP = new TUIButton();
         this.FBtn_CreatePVP.Substrate = this.FSP_TeamBattleHall[CONST_TEAMBATTLE.RESOURCE_Link_Btn_CreatePVP];
         this.FBtn_CreatePVP.OnClick = this.Btn_CreateOnClick;
         this.FBtn_Search = new TUIButton();
         this.FBtn_Search.Substrate = this.FSP_TeamBattleHall[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Search];
         this.FBtn_Search.OnClick = this.Btn_SearchOnClick;
         this.FTF_Search = this.FSP_TeamBattleHall[CONST_TEAMBATTLE.RESOURCE_Link_TF_Search];
         this.FTF_Search.maxChars = 5;
         this.FTF_Search.restrict = "[0-9]";
         this.FTF_Search.text = "";
         this.FSP_Password = this.FSP_TeamBattleHall[CONST_TEAMBATTLE.RESOURCE_Link_SP_SetPassword];
         this.FBtn_Setup = new TUIButton();
         this.FBtn_Setup.Substrate = this.FSP_Password[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Setup];
         this.FBtn_Setup.OnClick = this.Btn_SetupOnClick;
         this.FSP_modifed = this.FSP_Password[CONST_TEAMBATTLE.RESOURCE_Link_SP_Modifed];
         this.FTF_Password = this.FSP_Password[CONST_TEAMBATTLE.RESOURCE_Link_TF_Password];
         this.FTF_Password.addEventListener(Event.CHANGE,this.TF_PasswordOnChange);
         this.FTF_Password.maxChars = 6;
         this.FTF_Password.restrict = "[0-9]";
         this.FTF_Password.text = "";
         _loc2_ = this.FSP_TeamBattleHall[CONST_TEAMBATTLE.RESOURCE_Link_SP_Password];
         this.FBtn_Unselect = new TUIButton();
         this.FBtn_Unselect.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Unselect];
         this.FBtn_Unselect.OnClick = this.Btn_UnselectOnClick;
         this.FBtn_Selected = new TUIButton();
         this.FBtn_Selected.Substrate = _loc2_[CONST_TEAMBATTLE.RESOURCE_Link_Btn_Selected];
         this.FBtn_Selected.OnClick = this.Btn_SelectedOnClick;
         this.FUIWindowEditorString = SUtilityOverLayer.UIWindowEditorString;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.ButtonCloseOnClick,false,0,true);
         this.FInitialization = true;
         super.ResourcesPerform_UILocations();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            if(this.FInitialization)
            {
               this.FUIDropList.UIList.RenderingPerform();
            }
         }
      }
      
      protected function ProcessorUpdatePVE() : void
      {
         this.FFilterRoomModel = this.ProcessorFilterPveModelID;
         this.FModels = this.FTeamBattle.PVEModels;
         this.FCurModelID = this.FTeamBattle.CurPveModelID;
         this.ProcessorUpdateModelList();
         this.FTF_Title.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_05);
         this.FSP_PVE_Select.visible = true;
         this.FBtn_QuickPVE.Visible = true;
         this.FBtn_CreatePVE.Visible = true;
         this.FBtn_QuickPVP.Visible = false;
         this.FBtn_CreatePVP.Visible = false;
      }
      
      protected function ProcessorUpdatePVP() : void
      {
         this.FFilterRoomModel = this.ProcessorFilterPvpModelID;
         this.FModels = this.FTeamBattle.PVPModels;
         this.FCurModelID = this.FTeamBattle.CurPvpModelID;
         this.FTF_Title.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_06);
         this.FSP_PVP_Select.visible = true;
         this.FBtn_QuickPVE.Visible = false;
         this.FBtn_CreatePVE.Visible = false;
         this.FBtn_QuickPVP.Visible = true;
         this.FBtn_CreatePVP.Visible = true;
      }
      
      protected function ProcessorUpdateCommon() : void
      {
         this.FSP_Password.visible = this.FTeamBattle.IsCreatePassword;
         this.FSP_modifed.visible = this.FTeamBattle.PasswordModifed;
         this.FBtn_Setup.Enabled = !this.FTeamBattle.PasswordModifed;
         if(!TUtilityString.Empty(this.FTeamBattle.Password))
         {
            this.FTF_Password.text = this.FTeamBattle.Password;
         }
         else
         {
            this.FTF_Password.text = "";
         }
         if(this.FTeamBattle.IsCreatePassword)
         {
            this.FBtn_Selected.Visible = true;
            this.FBtn_Unselect.Visible = false;
         }
         else
         {
            this.FBtn_Selected.Visible = false;
            this.FBtn_Unselect.Visible = true;
         }
      }
      
      protected function UpdateUITabs() : void
      {
         var _loc1_:* = 0;
         var _loc2_:int = 0;
         var _loc3_:TModel = null;
         var _loc4_:TModels = null;
         var _loc5_:Boolean = false;
         _loc2_ = -1;
         _loc4_ = this.FTeamBattle.PVPModels;
         _loc1_ = int(CAPACITY_Tabs - 1);
         while(_loc1_ >= 0)
         {
            _loc3_ = _loc4_.GetModelByIndex(_loc1_);
            if(_loc3_.IsUnlock)
            {
               if(_loc2_ < 0)
               {
                  _loc2_ = _loc1_;
               }
               _loc5_ = true;
            }
            else
            {
               _loc5_ = false;
            }
            this.FUITabs.SetTabEnabledByIndex(_loc1_,_loc5_,true);
            _loc1_--;
         }
         this.FUITabs.SwithTagManual(_loc2_);
         _loc3_ = _loc4_.GetModelByIndex(_loc2_);
         this.FPVPCurLevel = _loc2_;
         this.FTeamBattle.SelectModelID = _loc3_.Identifier;
      }
      
      protected function UpdateUIPageRooms() : void
      {
         this.FUIPageRoom.TotalQuantity = this.FFilterRoomDigests.Count;
         this.FUIPageRoom.PageIndex = this.FPageRoomIndex;
         this.FUIPageRoom.Update();
      }
      
      protected function UpdateFriendsUIPage() : void
      {
         this.FUIPageFriend.TotalQuantity = this.FFriendDigests.Count;
         this.FUIPageFriend.PageIndex = this.FPageFriendIndex;
         this.FUIPageFriend.Update();
      }
      
      protected function ProcessorUpdateModelList() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TListItemText = null;
         var _loc4_:TLeagueMapPve = null;
         var _loc5_:uint = 0;
         var _loc6_:TModel = null;
         var _loc7_:String = null;
         _loc3_ = new TListItemText(null);
         _loc3_.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_Link_MC_ListItem) as MovieClip;
         _loc3_.Perform_UIDispatch();
         _loc3_.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_01);
         _loc3_.Tag = 0;
         this.FUIList.Add(_loc3_);
         _loc2_ = this.FLeagueMapPves.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FLeagueMapPves.GetDatebaseByIndex(_loc1_) as TLeagueMapPve;
            _loc5_ = uint(_loc4_.Identifier);
            _loc6_ = this.FTeamBattle.PVEModels.GetModelByIdentifier(_loc5_);
            if(!(_loc5_ > this.FTeamBattle.CurPveModelID || !_loc6_.IsUnlock))
            {
               _loc3_ = new TListItemText(null);
               _loc3_.Resource = TUtilityReflection.CreateDisplayObjectInstance(CONST_COMMON.RESOURCE_Link_MC_ListItem) as MovieClip;
               _loc3_.Perform_UIDispatch();
               if(_loc5_ % 2 == 0)
               {
                  _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_03);
               }
               else
               {
                  _loc7_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_02);
               }
               _loc3_.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_04),_loc4_.OpenLevel,_loc4_.Name,_loc7_);
               _loc3_.Tag = _loc4_.Identifier;
               this.FUIList.Add(_loc3_);
            }
            _loc1_++;
         }
      }
      
      protected function ProcessorFilterRoomDigests() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TModel = null;
         var _loc4_:TRoomDigest = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Boolean = false;
         this.FFilterRoomDigests.Clear();
         _loc2_ = this.FRoomDigests.Count;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FRoomDigests.GetDigestByIndex(_loc1_);
            _loc3_ = this.FModels.GetModelByIdentifier(_loc4_.ModelID);
            _loc7_ = this.FFilterRoomModel(_loc3_.IsUnlock,this.FFilterModelID,this.FCurModelID,_loc4_.ModelID);
            if(_loc7_)
            {
               this.FFilterRoomDigests.Add(_loc4_);
            }
            _loc1_++;
         }
      }
      
      protected function ProcessorUpdateUIRooms() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:TRoomDigest = null;
         var _loc8_:TUIRoom = null;
         _loc6_ = this.FPageRoomIndex;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Rooms)
         {
            _loc8_ = this.FUIRooms[_loc1_];
            _loc8_.Context = null;
            _loc8_.Visible = false;
            _loc1_++;
         }
         _loc2_ = this.FFilterRoomDigests.Count;
         if(_loc2_ <= 0)
         {
            return;
         }
         _loc5_ = _loc6_ * CAPACITY_Rooms;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Rooms)
         {
            if(_loc1_ + _loc5_ >= _loc2_)
            {
               return;
            }
            _loc7_ = this.FFilterRoomDigests.GetDigestByIndex(_loc1_ + _loc5_);
            _loc8_ = this.FUIRooms[_loc1_];
            _loc8_.Context = _loc7_;
            _loc8_.Visible = true;
            _loc1_++;
         }
      }
      
      protected function ProcessorUpdateUIFriends() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:TUIFriend = null;
         var _loc6_:TDigest = null;
         _loc4_ = this.FPageFriendIndex;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Friends)
         {
            _loc5_ = this.FUIFriends[_loc1_];
            _loc5_.Context = null;
            _loc5_.Visible = false;
            _loc1_++;
         }
         _loc2_ = this.FFriendDigests.Count;
         if(_loc2_ <= 0)
         {
            return;
         }
         _loc3_ = _loc4_ * CAPACITY_Friends;
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Friends)
         {
            if(_loc1_ + _loc3_ >= _loc2_)
            {
               break;
            }
            _loc5_ = this.FUIFriends[_loc1_];
            _loc6_ = this.FFriendDigests.GetDigestByIndex(_loc1_ + _loc3_);
            _loc5_.Context = _loc6_;
            _loc5_.Visible = true;
            _loc1_++;
         }
      }
      
      protected function ProcessorEnterRoomReq() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleHall_EnterPlayerRoom);
         _loc2_ = _loc1_.Data;
         _loc2_.writeByte(this.FTeamBattle.ModeType);
         _loc2_.writeByte(TYPE_ENTER_NORMAL);
         _loc2_.writeUnsignedInt(this.FEnterRoomID);
         TUtilityString.FlushUTF(_loc2_,this.FEnterPassword);
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
         this.FEnterPassword = "";
         this.FEnterRoomID = 0;
      }
      
      protected function ProcessorFilterPveModelID(param1:Boolean, param2:uint, param3:uint, param4:uint) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         if(param2 != 0)
         {
            if(param2 != param4)
            {
               return false;
            }
         }
         else if(param3 < param4)
         {
            return false;
         }
         return true;
      }
      
      protected function ProcessorFilterPvpModelID(param1:Boolean, param2:uint, param3:uint, param4:uint) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         if(param2 != 0)
         {
            if(param2 != param4)
            {
               return false;
            }
         }
         else if(param3 != param4)
         {
            return false;
         }
         return true;
      }
      
      protected function ButtonCloseOnClick(param1:MouseEvent) : void
      {
         ProcessorWindowClose();
      }
      
      protected function TabsOnSwitch(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TLeagueMapPvp = null;
         _loc2_ = param1 as int;
         _loc3_ = this.FLeagueMapPvps.GetDatebaseByIndex(_loc2_) as TLeagueMapPvp;
         this.FFilterModelID = _loc3_.Identifier;
         this.FTeamBattle.SelectModelID = _loc3_.Identifier;
         this.FTabIndex = _loc2_;
         this.FPageRoomIndex = 0;
         this.UpdateUIPageRooms();
         this.UpdateUIRooms();
      }
      
      protected function TabsOnOver(param1:Object, param2:int, param3:Boolean) : void
      {
         var _loc4_:TLeagueMapPvp = null;
         if(param3)
         {
            return;
         }
         _loc4_ = this.FLeagueMapPvps.GetDatebaseByIndex(param2) as TLeagueMapPvp;
         this.FHint.Caption = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_41),_loc4_.OpenLevel);
         if(this.FHintOnOver != null)
         {
            this.FHintOnOver(this,this.FHint);
         }
      }
      
      protected function TabsOnOut(param1:Object, param2:int, param3:Boolean) : void
      {
         if(param3)
         {
            return;
         }
         if(this.FHintOnOut != null)
         {
            this.FHintOnOut(this,this.FHint);
         }
      }
      
      protected function PageRoomOnChange(param1:Object, param2:int) : void
      {
         this.FPageRoomIndex = param2;
         this.UpdateUIRooms();
      }
      
      protected function PageFriendOnChange(param1:Object, param2:int) : void
      {
         this.FPageFriendIndex = param2;
      }
      
      protected function UIDropListOnClick(param1:Object, param2:int) : void
      {
         this.FFilterModelID = this.FUIList.GetItemByIndex(param2).Tag;
         this.UpdateUIRooms();
      }
      
      protected function UIRoomOnClick(param1:Object, param2:TRoomDigest) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:TModel = null;
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            _loc4_ = this.FTeamBattle.PVEModels.GetModelByIdentifier(param2.ModelID);
            _loc3_ = this.FTeamBattle.CurPveModelID;
         }
         else if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVP)
         {
            _loc4_ = this.FTeamBattle.PVPModels.GetModelByIdentifier(param2.ModelID);
            _loc3_ = this.FTeamBattle.CurPvpModelID;
         }
         if(!_loc4_.IsUnlock)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_65));
            return;
         }
         if(param2.IsFighting)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_66));
            return;
         }
         if(param2.PlayerCount >= param2.PlayerCapacity)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_07));
            return;
         }
         this.FEnterRoomID = param2.Identifier;
         this.FTeamBattle.SelectModelID = param2.ModelID;
         if(param2.Passworded)
         {
            this.FUIWindowEditorString.OnOK = this.WindowEditorStringOnOK;
            this.FUIWindowEditorString.OnCancel = this.WindowEditorStringOnCancel;
            this.FUIWindowEditorString.MaxChars = 6;
            this.FUIWindowEditorString.Restrict = "[0-9]";
            this.FUIWindowEditorString.Label = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_08);
            this.FUIWindowEditorString.SetFocus();
            this.FUIWindowEditorString.Visible = true;
            return;
         }
         this.ProcessorEnterRoomReq();
      }
      
      protected function UIFriendOnWhisper(param1:Object, param2:TDigest) : void
      {
         if(this.FOnWhisper != null)
         {
            this.FOnWhisper(this,param2);
         }
      }
      
      protected function Btn_QuickOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:TRoomDigest = null;
         var _loc6_:uint = 0;
         _loc6_ = 0;
         this.FEnterPassword = "";
         if(this.FTeamBattle.IsCreatePassword)
         {
            this.FEnterPassword = this.FTeamBattle.Password;
         }
         if(this.FRoomDigests.Count > 0)
         {
            _loc5_ = this.FRoomDigests.GetDigestByIndex(0);
            if(!_loc5_.Passworded)
            {
               _loc6_ = _loc5_.Identifier;
               this.FEnterPassword = "";
            }
         }
         _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleHall_EnterPlayerRoom);
         _loc4_ = _loc3_.Data;
         _loc4_.writeByte(this.FTeamBattle.ModeType);
         _loc4_.writeByte(TYPE_ENTER_QUICK);
         _loc4_.writeUnsignedInt(_loc6_);
         TUtilityString.FlushUTF(_loc4_,this.FEnterPassword);
         SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         this.FEnterPassword = "";
      }
      
      protected function Btn_CreateOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:TPacket = null;
         var _loc4_:ByteArray = null;
         var _loc5_:String = null;
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            if(this.FOnCreateRoom != null)
            {
               this.FOnCreateRoom(this);
            }
         }
         else if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVP)
         {
            _loc3_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_TeamBattleHall_CreatePlayerRoom);
            _loc4_ = _loc3_.Data;
            _loc4_.writeByte(this.FTeamBattle.ModeType);
            _loc4_.writeUnsignedInt(this.FTeamBattle.SelectModelID);
            _loc5_ = "";
            if(this.FTeamBattle.IsCreatePassword)
            {
               _loc5_ = this.FTeamBattle.Password;
            }
            TUtilityString.FlushUTF(_loc4_,_loc5_);
            SNetworkCore.Transceiver.PacketTransmit(_loc3_);
         }
      }
      
      protected function Btn_SearchOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:TRoomDigest = null;
         var _loc7_:Boolean = false;
         _loc7_ = false;
         _loc5_ = parseInt(this.FTF_Search.text);
         _loc4_ = this.FRoomDigests.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc6_ = this.FRoomDigests.GetDigestByIndex(_loc3_);
            if(_loc5_ == _loc6_.Identifier)
            {
               this.UIRoomOnClick(this,_loc6_);
               _loc7_ = true;
               break;
            }
            _loc3_++;
         }
         if(!_loc7_)
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_24));
         }
      }
      
      protected function Btn_SetupOnClick(param1:Object, param2:MouseEvent) : void
      {
         if(!TUtilityString.Empty(this.FTF_Password.text))
         {
            EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_21));
            this.FTeamBattle.Password = this.FTF_Password.text;
            this.FTeamBattle.PasswordModifed = true;
            this.FSP_modifed.visible = true;
            this.FBtn_Setup.Enabled = false;
         }
      }
      
      protected function TF_PasswordOnChange(param1:Event) : void
      {
         if(this.FSP_modifed.visible)
         {
            this.FSP_modifed.visible = false;
            this.FBtn_Setup.Enabled = true;
         }
      }
      
      protected function Btn_UnselectOnClick(param1:Object, param2:MouseEvent) : void
      {
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_22));
         this.FSP_Password.visible = true;
         this.FBtn_Unselect.Visible = false;
         this.FBtn_Selected.Visible = true;
         this.FTeamBattle.IsCreatePassword = true;
      }
      
      protected function Btn_SelectedOnClick(param1:Object, param2:MouseEvent) : void
      {
         EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.TeamBattle_String_23));
         this.FSP_Password.visible = false;
         this.FBtn_Unselect.Visible = true;
         this.FBtn_Selected.Visible = false;
         this.FTeamBattle.IsCreatePassword = false;
      }
      
      protected function WindowEditorStringOnOK(param1:Object) : void
      {
         var _loc2_:String = null;
         _loc2_ = this.FUIWindowEditorString.Value;
         if(TUtilityString.Empty(_loc2_))
         {
            return;
         }
         this.FEnterPassword = _loc2_;
         this.ProcessorEnterRoomReq();
         this.FUIWindowEditorString.Value = "";
      }
      
      protected function WindowEditorStringOnCancel(param1:Object) : void
      {
         this.FEnterRoomID = 0;
         this.FTeamBattle.SelectModelID = 0;
         this.FUIWindowEditorString.Value = "";
      }
      
      public function get RoomDigests() : TRoomDigests
      {
         return this.FRoomDigests;
      }
      
      public function set RoomDigests(param1:TRoomDigests) : void
      {
         this.FRoomDigests = param1;
      }
      
      public function get FriendDigests() : TDigests
      {
         return this.FFriendDigests;
      }
      
      public function set FriendDigests(param1:TDigests) : void
      {
         this.FFriendDigests = param1;
      }
      
      public function set HintOnOver(param1:Function) : void
      {
         this.FHintOnOver = param1;
      }
      
      public function get HintOnOver() : Function
      {
         return this.FHintOnOver;
      }
      
      public function set HintOnOut(param1:Function) : void
      {
         this.FHintOnOut = param1;
      }
      
      public function get HintOnOut() : Function
      {
         return this.FHintOnOut;
      }
      
      public function get OnCreateRoom() : Function
      {
         return this.FOnCreateRoom;
      }
      
      public function set OnCreateRoom(param1:Function) : void
      {
         this.FOnCreateRoom = param1;
      }
      
      public function get OnWhisper() : Function
      {
         return this.FOnWhisper;
      }
      
      public function set OnWhisper(param1:Function) : void
      {
         this.FOnWhisper = param1;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TUIRoom = null;
         if(!this.FInitialization)
         {
            return;
         }
         _loc1_ = 0;
         while(_loc1_ < CAPACITY_Rooms)
         {
            _loc2_ = this.FUIRooms[_loc1_];
            _loc2_.Context = null;
            _loc2_.Visible = false;
            _loc1_++;
         }
         this.FUIList.Clear();
         this.FFilterRoomDigests.Clear();
         this.FCurModelID = 0;
         this.FModels = null;
         this.FFilterRoomModel = null;
         this.FPageRoomIndex = 0;
         this.FPageFriendIndex = 0;
         this.FEnterRoomID = 0;
         this.FFilterModelID = 0;
         this.FPVPCurLevel = 0;
         this.FTF_Title.text = "";
         this.FTF_Search.text = "";
         this.FEnterPassword = "";
         this.FSP_PVE_Select.visible = false;
         this.FSP_PVP_Select.visible = false;
      }
      
      public function Update() : void
      {
         if(this.FTeamBattle.ModeType == MODE_TEAMBATTLE_PVE)
         {
            this.ProcessorUpdatePVE();
         }
         else
         {
            if(this.FTeamBattle.ModeType != MODE_TEAMBATTLE_PVP)
            {
               return;
            }
            this.ProcessorUpdatePVP();
            this.UpdateUITabs();
         }
         this.ProcessorUpdateCommon();
         this.UpdateUIRooms();
         this.UpdateUIFriends();
      }
      
      public function UpdateUIRooms() : void
      {
         if(this.FTeamBattle.ModeType == 0)
         {
            return;
         }
         this.ProcessorFilterRoomDigests();
         this.UpdateUIPageRooms();
         this.ProcessorUpdateUIRooms();
      }
      
      public function UpdateUIFriends() : void
      {
         this.UpdateFriendsUIPage();
         this.ProcessorUpdateUIFriends();
      }
   }
}

