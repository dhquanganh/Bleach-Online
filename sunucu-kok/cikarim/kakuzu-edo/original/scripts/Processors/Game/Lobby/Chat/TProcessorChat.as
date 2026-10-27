package Processors.Game.Lobby.Chat
{
   import Components.HyperStrings.*;
   import Components.Standard.*;
   import Externals.*;
   import Foundation.Common.*;
   import Foundation.Network.*;
   import Foundation.Registries.*;
   import Foundation.Resources.*;
   import Foundation.Resources.Bins.*;
   import Foundation.Resources.Repositories.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.Agent.*;
   import Logics.Characters.*;
   import Logics.ChatOptions.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.HyperStrings.*;
   import Logics.HyperStrings.Elements.*;
   import Logics.Inventories.*;
   import Logics.Spaces.*;
   import Logics.Streamization.HyperStrings.*;
   import Logics.Streamization.Post.*;
   import Processors.Game.*;
   import Processors.Game.Lobby.Chat.HyperString.Data.*;
   import Processors.Game.Lobby.Chat.HyperString.Importers.*;
   import Processors.Game.Lobby.Chat.Window.*;
   import Processors.Game.Lobby.Common.PopupMenu.*;
   import Processors.Game.Lobby.Utilities.*;
   import Processors.Game.Utilities.OverLayer.SUtilityOverLayer;
   import Processors.Game.Windows.Editors.*;
   import Processors.Game.Windows.Information.*;
   import Rendering.HyperStrings.*;
   import Resources.Constants.*;
   import Resources.Strings.*;
   import Utilities.UI.Windows.*;
   import flash.display.*;
   import flash.events.*;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   import ghostcat.util.easing.*;
   
   use namespace LogicsSpace;
   
   public class TProcessorChat extends TProcessorGame
   {
      
      protected static const SIZE_WIDTH_Chat:int = 274;
      
      protected static const SIZE_HEIGHT_Chat:int = 200;
      
      protected static const STAGE_Width:uint = CONST_COMMON.STAGE_Width;
      
      protected static const STAGE_Height:uint = CONST_COMMON.STAGE_Height;
      
      protected static const SIZE_MAX_ChatViewChars:uint = 50;
      
      protected static const SIZE_MAX_ChatViewRows:uint = 15;
      
      protected static const SIZE_WIDTH_Notice:uint = 266;
      
      protected static const SIZE_HEIGHT_LineMinimum:uint = 15;
      
      protected static const TIME_Expired:uint = CONST_POST.TIME_Expired;
      
      protected static const MODE_Hidden:uint = CONST_CHAT.MODE_Hidden;
      
      public static const CAPACITY_Channels:uint = CONST_CHAT.CAPACITY_Channels;
      
      protected static const CHANNELS_TYPE:Vector.<uint> = CONST_CHAT.CHANNELS_TYPE;
      
      protected static const CHANNELS_TYPE_LIST:Vector.<uint> = CONST_CHAT.CHANNELS_TYPE_LIST;
      
      protected static const CAPACITY_ChannelLists:uint = CONST_CHAT.CAPACITY_ChannelLists;
      
      protected static const CAPACITY_CharacterSelect:uint = CONST_CHAT.CAPACITY_CharacterSelect;
      
      protected static const CHANNELS_FILTER:Vector.<uint> = CONST_CHAT.CHANNELS_FILTER;
      
      protected static const CHANNELS_TYPE_Filter:Vector.<uint> = CONST_CHAT.CHANNELS_TYPE_Filter;
      
      protected static const CHANNEL_TYPE_Composite:uint = CONST_CHAT.CHANNEL_TYPE_Composite;
      
      protected static const CHANNEL_TYPE_SystemOne:uint = CONST_CHAT.CHANNEL_TYPE_SystemOne;
      
      protected static const CHANNEL_TYPE_World:uint = CONST_CHAT.CHANNEL_TYPE_World;
      
      protected static const CHANNEL_TYPE_Country:uint = CONST_CHAT.CHANNEL_TYPE_Country;
      
      protected static const CHANNEL_TYPE_Organization:uint = CONST_CHAT.CHANNEL_TYPE_Organization;
      
      protected static const CHANNEL_TYPE_Whisper:uint = CONST_CHAT.CHANNEL_TYPE_Whisper;
      
      protected static const CHANNEL_TYPE_SystemMarquee:uint = CONST_CHAT.CHANNEL_TYPE_SystemMarquee;
      
      protected static const CHANNEL_TYPE_SystemNotice:uint = CONST_CHAT.CHANNEL_TYPE_SystemNotice;
      
      protected static const CHANNEL_TYPE_Team:uint = CONST_CHAT.CHANNEL_TYPE_Team;
      
      protected static const CHANNEL_TYPE_Nation:uint = CONST_CHAT.CHANNEL_TYPE_Nation;
      
      protected static const CHANNELS_TYPE_360:Vector.<uint> = CONST_CHAT.CHANNELS_TYPE_360;
      
      protected static const CHARACTER_SELECT_View:uint = CONST_CHAT.CHARACTER_SELECT_View;
      
      protected static const CHARACTER_SELECT_Achievement:uint = CONST_CHAT.CHARACTER_SELECT_Achievement;
      
      protected static const CHARACTER_SELECT_Whisper:uint = CONST_CHAT.CHARACTER_SELECT_Whisper;
      
      protected static const CHARACTER_SELECT_CopyName:uint = CONST_CHAT.CHARACTER_SELECT_CopyName;
      
      protected static const CHARACTER_SELECT_Friend:uint = CONST_CHAT.CHARACTER_SELECT_Friend;
      
      protected static const CHARACTER_SELECT_Shield:uint = CONST_CHAT.CHARACTER_SELECT_Shield;
      
      protected static const WHISPER_Receive:int = CONST_CHAT.WHISPER_Receive;
      
      protected static const WHISPER_Echoplex:int = CONST_CHAT.WHISPER_Echoplex;
      
      protected static const QUALITYCOLOR_INDEX:Vector.<uint> = CONST_COMMON.QUALITYCOLOR_INDEX;
      
      protected static const ZOOMING_Maximize:uint = CONST_CHAT.ZOOMING_Maximize;
      
      protected static const ZOOMING_Minimize:uint = CONST_CHAT.ZOOMING_Minimize;
      
      protected static const TYPE_White:uint = CONST_FRIEND.TYPE_White;
      
      protected static const TYPE_Black:uint = CONST_FRIEND.TYPE_Black;
      
      protected static const TYPE_Whitelist_Add:uint = CONST_FRIEND.TYPE_Whitelist_Add;
      
      protected static const TYPE_Blacklist_Add:uint = CONST_FRIEND.TYPE_Blacklist_Add;
      
      protected var FUIWindowConfirmation:TUIWindowConfirmation;
      
      protected var FUIWindowInformation:TUIWindowInformation;
      
      protected var FPoolHyperString:TPoolHyperString;
      
      protected var FStreamizerHyperString:TStreamizerHyperString;
      
      protected var FHyperStringFontSheetChatView:THyperStringFontSheetChatView;
      
      protected var FHyperStringFontSheetChatEditor:THyperStringFontSheetChatEditor;
      
      protected var FSketcher:TSketcherHyperString;
      
      protected var FHyperStrings:Vector.<THyperString>;
      
      protected var FHyperStringFormatSheetChat:THyperStringFormatSheetChat;
      
      protected var FChannelRoutines:TRegistryRoutine;
      
      protected var FPostRoutines:TRegistryRoutine;
      
      protected var FHyperStringImporter:THyperStringImporter;
      
      protected var FCharacter:TCharacter;
      
      protected var FFriends:TFriendDigests;
      
      protected var FDigest:TDigest;
      
      protected var FStream:ByteArray;
      
      protected var FCharacterDigest:TFriendDigest;
      
      protected var FWindowChatView:TWindowChatView;
      
      protected var FHyperEditor:THyperEditor;
      
      protected var FWindowChannelSelectPopupMenu:TWindowChannelSelectPopupMenu;
      
      protected var FWindowCharacterSelectPopupMenu:TWindowCharacterSelectPopupMenu;
      
      protected var FWindowChannelFilter:TWindowChannelFilter;
      
      protected var FWindowExpression:TWindowExpression;
      
      protected var FUIWindowEditorString:TUIWindowEditorString;
      
      protected var FMC_Chat:Sprite;
      
      protected var FMC_Notice:Sprite;
      
      protected var FMC_PanelChat:Sprite;
      
      protected var FBtnExpression:SimpleButton;
      
      protected var FBtnMessageSend:SimpleButton;
      
      protected var FBtnChannelSelect:TUIButton;
      
      protected var FTFChannelName:TextField;
      
      protected var FBtnZoomingMax:TUIButton;
      
      protected var FBtnZoomingMin:TUIButton;
      
      protected var FCurSendChannelID:int;
      
      protected var FCurFilterChannelID:int;
      
      protected var FChatWhisperName:String;
      
      protected var FChatWhisperID0:uint;
      
      protected var FChatWhisperID1:uint;
      
      protected var FAlphaPanelChat:Number;
      
      protected var FChannelWorldLimit:uint;
      
      protected var FIsVisibleExpression:Boolean;
      
      protected var FIsVisibleChannelSelect:Boolean;
      
      protected var FIsVisibleCharacterSelect:Boolean;
      
      protected var FIsVisiblePanelChat:Boolean;
      
      protected var FStringsAntiAddiction:Vector.<uint>;
      
      protected var FNextTick:uint;
      
      protected var FInitialization:Boolean;
      
      protected var FOnMarquee:Function;
      
      protected var FOnEffectText:Function;
      
      protected var FOnInquiryReq:Function;
      
      protected var FOnInterpersonalRelationships:Function;
      
      protected var FOnHackWarningResponse:Function;
      
      protected var FOnShortcutHyperlinks:Function;
      
      protected var FOnShowHeroInfor:Function;
      
      protected var FOnShowInventoryInfor:Function;
      
      protected var FOnShowHeroAchievement:Function;
      
      protected var FOnShowHeroDescription:Function;
      
      protected var FOnTeamBattleChatPopNtf:Function;
      
      public function TProcessorChat(param1:TUIComponent)
      {
         super(param1);
         this.FPoolHyperString = SLogicsCore.PoolHyperString;
         this.FStreamizerHyperString = new TStreamizerHyperString();
         this.FHyperStringFontSheetChatView = new THyperStringFontSheetChatView();
         this.FHyperStringFontSheetChatEditor = new THyperStringFontSheetChatEditor();
         this.FHyperStringFormatSheetChat = new THyperStringFormatSheetChat();
         this.FChannelRoutines = new TRegistryRoutine();
         this.FPostRoutines = new TRegistryRoutine();
         this.ChannelRegisterRountines();
         this.PostRegisterRountines();
         this.FCharacter = SLogicsCore.Character;
         this.FFriends = SLogicsCore.Friends;
         this.FDigest = new TDigest(0,0);
         this.FCharacterDigest = new TFriendDigest(0,0);
         this.FStream = new ByteArray();
         this.ConstructStringsAntiAddiction();
         this.FHyperStrings = new Vector.<THyperString>();
         this.FAlphaPanelChat = 1;
         mouseEnabled = false;
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         SResourcesCore.TexturesSwfChat.LoadPrimary(CONST_CHAT.RESOURCESID_Swf_CHAT);
         SResourcesCore.TexturesLobby.LoadPrimary(CONST_LOBBY.RESOURCESID_Texture_Expression);
         super.ResourcesPerform_UIRequest();
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         var _loc1_:TBins = null;
         var _loc2_:TChannelChet = null;
         this.FMC_Chat = TUtilityReflection.CreateDisplayObjectInstance(CONST_CHAT.RESOURCE_ClassName_MC_Chat) as Sprite;
         this.FMC_Chat.mouseEnabled = false;
         addChild(this.FMC_Chat);
         this.X = 1;
         this.Y = STAGE_Height - SIZE_HEIGHT_Chat;
         FBoundsScreen.X = this.X;
         FBoundsScreen.Y = this.Y;
         FBoundsScreen.Width = this.FMC_Chat.width;
         FBoundsScreen.Height = this.FMC_Chat.height;
         this.FMC_PanelChat = this.FMC_Chat[CONST_CHAT.RESOURCE_Link_MC_PanelChat];
         this.FMC_PanelChat.mouseEnabled = false;
         this.FMC_PanelChat.mouseChildren = false;
         this.ConstructSystemNotice();
         this.ConstructHyperEditor();
         this.ConstructWindowChatView();
         this.ConstructWindowChannelFilter();
         this.FHyperStringImporter = new THyperStringImporter();
         this.ConstructHyperStringImporter();
         this.ConstructWindowChannelSelectPopupMenu();
         this.ConstructWindowCharacterSelectPopupMenu();
         this.ConstructUIWindowConfirmation();
         this.ConstructUIWindowInformation();
         this.ConstructWindowEditorString();
         this.FBtnChannelSelect = new TUIButton();
         this.FBtnChannelSelect.IsFilter = true;
         this.FBtnChannelSelect.Substrate = this.FMC_Chat[CONST_CHAT.RESOURCE_Link_Btn_ChannelSelect];
         this.FBtnChannelSelect.OnClick = this.BtnChannelSelectOnClick;
         this.FTFChannelName = this.FBtnChannelSelect.Substrate[CONST_CHAT.RESOURCE_Link_TF_ChannelName];
         this.PopupMenuChannelSelectOnClick(null,CHANNEL_TYPE_World);
         this.SwitchChannelFilterByType(CHANNEL_TYPE_Composite);
         this.FBtnZoomingMax = new TUIButton();
         this.FBtnZoomingMin = new TUIButton();
         this.FBtnZoomingMax.Substrate = this.FMC_Chat[CONST_CHAT.RESOURCE_Link_MC_ZoomingMax];
         this.FBtnZoomingMin.Substrate = this.FMC_Chat[CONST_CHAT.RESOURCE_Link_MC_ZoomingMin];
         this.FBtnZoomingMax.Visible = false;
         this.FBtnZoomingMax.OnClick = this.BtnZoomingOnClick;
         this.FBtnZoomingMin.OnClick = this.BtnZoomingOnClick;
         this.ConstructExpression();
         _loc1_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_Article);
         this.FHyperStringImporter.Articles = _loc1_;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_ChannelChet,CHANNEL_TYPE_World) as TChannelChet;
         this.FChannelWorldLimit = _loc2_.LevelAnalog;
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         this.FInitialization = true;
         super.ResourcesPerform_UILocations();
      }
      
      protected function ConstructSystemNotice() : void
      {
         this.FSketcher = new TSketcherHyperString(this);
         this.FSketcher.FontSheet = this.FHyperStringFontSheetChatView;
         this.FSketcher.FormatSheet = this.FHyperStringFormatSheetChat;
         this.FSketcher.AlignmentLineVertical = TAlignment.VERTICAL_Center;
         this.FSketcher.LineMinimumHeight = SIZE_HEIGHT_LineMinimum;
         this.FMC_Notice = TUtilityReflection.CreateDisplayObjectInstance(CONST_CHAT.RESOURCE_ClassName_MC_Notice) as Sprite;
         this.FMC_Notice.mouseEnabled = false;
         this.FMC_Notice.mouseChildren = false;
         addChild(this.FMC_Notice);
         this.FMC_Notice.y = this.FMC_Chat.y - this.FMC_Notice.height - 1;
         this.FMC_Notice.x = -this.FMC_Notice.width;
         this.FMC_Notice.visible = false;
         this.FMC_Notice.addChild(this.FSketcher);
         this.FSketcher.X = 3;
         this.FSketcher.Y = 3;
      }
      
      protected function ConstructHyperEditor() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Sprite = null;
         _loc1_ = this.FMC_Chat[CONST_CHAT.RESOURCE_Link_MC_HyperEditorMountPoint];
         _loc2_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_CHAT.RESOURCE_Link_MC_HyperEditorSubstrate) as Sprite;
         this.FHyperEditor = new THyperEditor(this,this.FHyperStringFontSheetChatEditor,this.FHyperStringFormatSheetChat);
         this.FHyperEditor.Substrate = _loc2_;
         this.FHyperEditor.MaxChars = SIZE_MAX_ChatViewChars;
         this.FHyperEditor.Font.Size = CONST_CHAT.FONT_DefaultSize;
         this.FHyperEditor.Font.Name = CONST_CHAT.FONT_DefaultName;
         this.FHyperEditor.Font.Color = CONST_CHAT.FONT_DefaultColor;
         this.FHyperEditor.OnKeyDown = this.HyperEditorMessageSendOnkeyDown;
         this.FHyperEditor.SetFocus();
         _loc1_.addChild(this.FHyperEditor);
         this.FHyperEditor.Init();
         this.FBtnMessageSend = this.FMC_Chat[CONST_CHAT.RESOURCE_Link_Btn_Btn_MessageSend];
         this.FBtnMessageSend.tabEnabled = false;
         this.FBtnMessageSend.addEventListener(MouseEvent.CLICK,this.BtnMessageSendOnClick,false,0,true);
      }
      
      protected function ConstructWindowChatView() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Sprite = null;
         var _loc3_:Sprite = null;
         var _loc4_:Sprite = null;
         var _loc5_:Sprite = null;
         var _loc6_:Sprite = null;
         var _loc7_:Sprite = null;
         var _loc8_:Sprite = null;
         _loc7_ = this.FMC_Chat[CONST_CHAT.RESOURCE_Link_MC_ChatViewMountPoint];
         _loc7_.mouseEnabled = false;
         _loc8_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_CHAT.RESOURCE_Link_MC_ChatViewSubstrate) as Sprite;
         _loc8_.mouseEnabled = false;
         _loc1_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_CHAT.RESOURCE_Link_MC_ScrollBar) as Sprite;
         this.FWindowChatView = new TWindowChatView(this,this.FHyperStringFontSheetChatView,this.FHyperStringFormatSheetChat);
         this.FWindowChatView.Substrate = _loc8_;
         this.FWindowChatView.MCScrollBar = _loc1_;
         this.FWindowChatView.MaxRows = SIZE_MAX_ChatViewRows;
         this.FWindowChatView.OnHyperStringClick = this.HyperStringLinkOnClick;
         this.FWindowChatView.OnOver = this.ChatViewOnOver;
         this.FWindowChatView.OnOut = this.ChatViewOnOut;
         _loc7_.addChild(this.FWindowChatView);
         this.FWindowChatView.Init();
      }
      
      protected function ConstructExpression() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TResourceRepositoryTexture = null;
         var _loc4_:TTexture = null;
         var _loc5_:TAnimationSequence = null;
         this.FBtnExpression = this.FMC_Chat[CONST_CHAT.RESOURCE_Link_Btn_Expression];
         this.FBtnExpression.tabEnabled = false;
         this.FBtnExpression.addEventListener(MouseEvent.CLICK,this.BtnExpressionOnClick,false,0,true);
         this.FWindowExpression = new TWindowExpression(this);
         this.FWindowExpression.X = 175;
         this.FWindowExpression.Y = 110;
         this.FWindowExpression.tabEnabled = false;
         this.FWindowExpression.OnImageClick = this.ExpressionOnClick;
         _loc3_ = SResourcesCore.TexturesLobby;
         _loc2_ = int(CONST_CHAT.CAPACITY_Expression);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = _loc3_.GetAnimationSequenceByIdentifiers(CONST_LOBBY.RESOURCESID_Texture_Expression,_loc1_);
            this.FWindowExpression.SetSequenceByIndex(_loc1_,_loc5_);
            _loc1_++;
         }
         this.FWindowExpression.Init();
         _loc4_ = _loc3_.GetTextureByIdentifier(CONST_LOBBY.RESOURCESID_Texture_Expression);
         this.FHyperEditor.TextureExpression = _loc4_;
         this.FWindowChatView.TextureExpression = _loc4_;
         this.FWindowExpression.Perform_UIDispatch();
      }
      
      protected function ConstructHyperStringImporter() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:TBins = null;
         var _loc5_:TChannelChet = null;
         _loc4_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ChannelChet);
         _loc2_ = int(CAPACITY_Channels);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = _loc4_.GetDatebaseByIdentifier(CHANNELS_TYPE[_loc1_]) as TChannelChet;
            this.FHyperStringImporter.SetChannelsName(_loc1_,_loc5_.Name);
            _loc3_ = parseInt(_loc5_.TextColor);
            this.FHyperStringImporter.SetChannelsColor(_loc1_,_loc3_);
            _loc1_++;
         }
      }
      
      protected function ConstructWindowChannelSelectPopupMenu() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TBins = null;
         var _loc5_:TChannelChet = null;
         _loc3_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_CHAT.RESOURCE_ClassName_MC_PopupMenuChannelList) as Sprite;
         this.FWindowChannelSelectPopupMenu = new TWindowChannelSelectPopupMenu(this);
         this.FWindowChannelSelectPopupMenu.OnSelect = this.PopupMenuChannelSelectOnClick;
         this.FWindowChannelSelectPopupMenu.SetSequenceButton(_loc3_);
         _loc4_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ChannelChet);
         _loc2_ = int(CAPACITY_ChannelLists);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = _loc4_.GetDatebaseByIdentifier(CHANNELS_TYPE_LIST[_loc1_]) as TChannelChet;
            this.FWindowChannelSelectPopupMenu.SetChannelsUsable(_loc1_,true);
            this.FWindowChannelSelectPopupMenu.SetChannelsName(_loc1_,_loc5_.Name);
            this.FWindowChannelSelectPopupMenu.SetChannelsCooling(_loc1_,_loc5_.CoolTime * 1000);
            _loc1_++;
         }
      }
      
      protected function ConstructWindowCharacterSelectPopupMenu() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         _loc3_ = TUtilityReflection.CreateDisplayObjectInstance(CONST_CHAT.RESOURCE_ClassName_MC_PopupMenuCharacterList) as Sprite;
         this.FWindowCharacterSelectPopupMenu = new TWindowCharacterSelectPopupMenu(this);
         this.FWindowCharacterSelectPopupMenu.OnSelect = this.PopupMenuCharacterSelectOnClick;
         this.FWindowCharacterSelectPopupMenu.SetSequenceButton(_loc3_);
         _loc2_ = int(CAPACITY_CharacterSelect);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FWindowCharacterSelectPopupMenu.SetMenuUsable(_loc1_,true);
            _loc1_++;
         }
      }
      
      protected function ConstructWindowEditorString() : void
      {
         this.FUIWindowEditorString = SUtilityOverLayer.UIWindowEditorString;
      }
      
      protected function ConstructUIWindowConfirmation() : void
      {
         this.FUIWindowConfirmation = SUtilityOverLayer.UIWindowConfirmation;
      }
      
      protected function ConstructUIWindowInformation() : void
      {
         this.FUIWindowInformation = SUtilityOverLayer.UIWindowInformation;
      }
      
      protected function ConstructWindowChannelFilter() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Sprite = null;
         var _loc4_:TBins = null;
         var _loc5_:TChannelChet = null;
         _loc3_ = this.FMC_Chat[CONST_CHAT.RESOURCE_Link_MC_ChannelFilters];
         this.FWindowChannelFilter = new TWindowChannelFilter(this);
         this.FWindowChannelFilter.OnSelect = this.BtnChannelFilterSelectOnClick;
         this.FWindowChannelFilter.SetSequenceButton(_loc3_);
         _loc4_ = SResourcesCore.ResourceBin.GetBinsByResourceID(CONST_DATEBASEVO.RESOURCEID_ChannelChet);
         _loc2_ = int(CONST_CHAT.CAPACITY_ChannelsFilter);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = _loc4_.GetDatebaseByIdentifier(CHANNELS_FILTER[_loc1_]) as TChannelChet;
            this.FWindowChannelFilter.SetChannelsUsable(_loc1_,true);
            this.FWindowChannelFilter.SetChannelsName(_loc1_,_loc5_.Name);
            _loc1_++;
         }
         this.FWindowChannelFilter.Init();
      }
      
      protected function ConstructStringsAntiAddiction() : void
      {
         this.FStringsAntiAddiction = new Vector.<uint>(CONST_INSPECTOR.TIME_AntiAddictionUpperLimit);
         this.FStringsAntiAddiction[0] = CONST_SYSTEMLANGUAGE.ANTIADDICTION_Prompt;
         this.FStringsAntiAddiction[1] = CONST_SYSTEMLANGUAGE.ANTIADDICTION_Hours_1;
         this.FStringsAntiAddiction[2] = CONST_SYSTEMLANGUAGE.ANTIADDICTION_Hours_2;
         this.FStringsAntiAddiction[3] = CONST_SYSTEMLANGUAGE.ANTIADDICTION_Hours_3;
         this.FStringsAntiAddiction[4] = CONST_SYSTEMLANGUAGE.ANTIADDICTION_Hours_4;
         this.FStringsAntiAddiction[5] = CONST_SYSTEMLANGUAGE.ANTIADDICTION_Hours_5;
      }
      
      protected function ChannelRegisterRountines() : void
      {
         this.FChannelRoutines.Register(CHANNEL_TYPE_World,this.ImportPerform_Chat_World);
         this.FChannelRoutines.Register(CHANNEL_TYPE_Country,this.ImportPerform_Chat_Country);
         this.FChannelRoutines.Register(CHANNEL_TYPE_Organization,this.ImportPerform_Chat_Organization);
         this.FChannelRoutines.Register(CHANNEL_TYPE_Whisper,this.ImportPerform_Chat_Whisper);
         this.FChannelRoutines.Register(CHANNEL_TYPE_Team,this.ImportPerform_Chat_Team);
         this.FChannelRoutines.Register(CHANNEL_TYPE_Nation,this.ImportPerform_Chat_Nation);
         this.FChannelRoutines.Register(CHANNEL_TYPE_SystemOne,this.ImportPerform_Chat_SystemOne);
         this.FChannelRoutines.Register(CHANNEL_TYPE_SystemMarquee,this.ImportPerform_Chat_SystemMarquee);
         this.FChannelRoutines.Register(CHANNEL_TYPE_SystemNotice,this.ImportPerform_Chat_SystemNotice);
      }
      
      protected function PostRegisterRountines() : void
      {
         this.FPostRoutines.Register(CHANNEL_TYPE_World,this.Perform_Post_World);
         this.FPostRoutines.Register(CHANNEL_TYPE_Country,this.Perform_Post_Country);
         this.FPostRoutines.Register(CHANNEL_TYPE_Organization,this.Perform_Post_Organization);
         this.FPostRoutines.Register(CHANNEL_TYPE_Team,this.Perform_Post_Team);
         this.FPostRoutines.Register(CHANNEL_TYPE_SystemOne,this.Perform_Post_SystemOne);
         this.FPostRoutines.Register(CHANNEL_TYPE_SystemMarquee,this.Perform_Post_SystemMarquee);
         this.FPostRoutines.Register(CHANNEL_TYPE_SystemNotice,this.Perform_Post_SystemNotice);
      }
      
      override protected function PacketRegisterRoutines() : void
      {
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Chat_ChatInfoRet,this.PacketPerform_SC_ChatInfo);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Chat_ChatNotReach,this.PacketPerform_SC_ChatNotReach);
         FPacketRoutines.Register(CONST_NETWORK.PACKETID_SC_Chat_WhisperEchoplex,this.PacketPerform_SC_ChatWhisperEchoplex);
      }
      
      protected function PacketPerform_SC_ChatInfo(param1:TPacket, param2:int = 1) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:THyperString = null;
         var _loc11_:THyperString = null;
         var _loc12_:Function = null;
         var _loc13_:int = 0;
         var _loc14_:TFriendDigest = null;
         var _loc15_:Boolean = false;
         var _loc16_:int = 0;
         var _loc17_:Boolean = false;
         if(!this.FInitialization)
         {
            return;
         }
         _loc10_ = this.FPoolHyperString.AcquireHyperString();
         _loc3_ = param1.Data;
         _loc8_ = int(_loc3_.readUnsignedByte());
         _loc6_ = _loc3_.readUnsignedInt();
         _loc7_ = _loc3_.readUnsignedInt();
         _loc15_ = _loc3_.readBoolean();
         _loc5_ = TUtilityString.FetchUTF(_loc3_);
         if(TUtilityString.Empty(_loc5_))
         {
            _loc5_ = _loc6_.toString() + _loc7_.toString();
         }
         _loc13_ = int(_loc3_.readUnsignedShort());
         if(_loc5_ == "#GM01")
         {
            _loc12_ = this.FChannelRoutines.GetRoutineByIndentifier(CHANNEL_TYPE_SystemMarquee);
            if(_loc12_ != null)
            {
               _loc12_(_loc3_,_loc10_,CHANNEL_TYPE_SystemMarquee,_loc5_,_loc6_,_loc7_,param2,_loc15_);
            }
            if(this.FOnMarquee != null)
            {
               this.FOnMarquee(this,_loc10_);
            }
         }
         else
         {
            _loc14_ = this.FFriends.GetDigestByIdentifier(_loc6_,_loc7_);
            if(_loc14_ != null && _loc14_.Type == TYPE_Black)
            {
               return;
            }
            _loc16_ = int(_loc3_.position);
            _loc17_ = TUtilityLobby.SamePlatform(SLogicsCore.Character.Identifier0,SLogicsCore.Character.Identifier1,_loc6_,_loc7_);
            if(_loc8_ != CHANNEL_TYPE_Nation || _loc17_)
            {
               _loc12_ = this.FChannelRoutines.GetRoutineByIndentifier(_loc8_);
               if(_loc12_ != null)
               {
                  _loc12_(_loc3_,_loc10_,_loc8_,_loc5_,_loc6_,_loc7_,param2,_loc15_);
               }
            }
            else
            {
               _loc10_ = null;
            }
            if(Boolean(true))
            {
               if(_loc8_ == CHANNEL_TYPE_World)
               {
                  if(_loc17_)
                  {
                     _loc11_ = this.FPoolHyperString.AcquireHyperString();
                     _loc3_.position = _loc16_;
                     _loc9_ = int(CHANNEL_TYPE_Nation);
                  }
               }
               else if(_loc8_ == CHANNEL_TYPE_Nation)
               {
                  _loc11_ = this.FPoolHyperString.AcquireHyperString();
                  _loc3_.position = _loc16_;
                  _loc9_ = int(CHANNEL_TYPE_World);
               }
               if(_loc11_ != null)
               {
                  _loc12_ = this.FChannelRoutines.GetRoutineByIndentifier(_loc9_);
                  if(_loc12_ != null)
                  {
                     _loc12_(_loc3_,_loc11_,_loc9_,_loc5_,_loc6_,_loc7_,param2,_loc15_);
                  }
               }
            }
            this.FWindowChatView.AddMessage(_loc10_,_loc8_,_loc11_);
            if(_loc8_ == CHANNEL_TYPE_Whisper && this.FCurFilterChannelID != _loc8_)
            {
               _loc4_ = CHANNELS_FILTER.indexOf(_loc8_);
               if(_loc4_ > 0)
               {
                  this.FWindowChannelFilter.SetChannelsIsEffect(_loc4_,true);
               }
            }
         }
      }
      
      protected function PacketPerform_SC_ChatNotReach(param1:TPacket) : void
      {
         this.SystemTextOuput(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_03));
      }
      
      protected function PacketPerform_SC_ChatWhisperEchoplex(param1:TPacket) : void
      {
         this.PacketPerform_SC_ChatInfo(param1,WHISPER_Echoplex);
      }
      
      protected function ImportPerform_Chat_World(param1:ByteArray, param2:THyperString, param3:uint, param4:String, param5:uint, param6:uint, param7:int = 1, param8:Boolean = false) : void
      {
         this.FHyperStringImporter.ImportAsUniversalChannel(param1,param2,param3,param4,param5,param6,param8);
      }
      
      protected function ImportPerform_Chat_Country(param1:ByteArray, param2:THyperString, param3:uint, param4:String, param5:uint, param6:uint, param7:int = 1, param8:Boolean = false) : void
      {
         this.FHyperStringImporter.ImportAsUniversalChannel(param1,param2,param3,param4,param5,param6,param8);
      }
      
      protected function ImportPerform_Chat_Organization(param1:ByteArray, param2:THyperString, param3:uint, param4:String, param5:uint, param6:uint, param7:int = 1, param8:Boolean = false) : void
      {
         this.FHyperStringImporter.ImportAsUniversalChannel(param1,param2,param3,param4,param5,param6,param8);
      }
      
      protected function ImportPerform_Chat_Whisper(param1:ByteArray, param2:THyperString, param3:uint, param4:String, param5:uint, param6:uint, param7:int = 1, param8:Boolean = false) : void
      {
         this.FHyperStringImporter.ImportAsWhisperChannel(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      protected function ImportPerform_Chat_Team(param1:ByteArray, param2:THyperString, param3:uint, param4:String, param5:uint, param6:uint, param7:int = 1, param8:Boolean = false) : void
      {
         this.FHyperStringImporter.ImportAsUniversalChannel(param1,param2,param3,param4,param5,param6,param8);
         if(this.FOnTeamBattleChatPopNtf != null)
         {
            this.FOnTeamBattleChatPopNtf(this,param5,param6,param2);
         }
      }
      
      protected function ImportPerform_Chat_Nation(param1:ByteArray, param2:THyperString, param3:uint, param4:String, param5:uint, param6:uint, param7:int = 1, param8:Boolean = false) : void
      {
         this.FHyperStringImporter.ImportAsUniversalChannel(param1,param2,param3,param4,param5,param6,param8);
      }
      
      protected function ImportPerform_Chat_SystemOne(param1:ByteArray, param2:THyperString, param3:uint, param4:String, param5:uint, param6:uint, param7:int = 1, param8:Boolean = false) : void
      {
         this.FHyperStringImporter.ImportAsSystemChannel(param1,param2,param3);
      }
      
      protected function ImportPerform_Chat_SystemMarquee(param1:ByteArray, param2:THyperString, param3:uint, param4:String, param5:uint, param6:uint, param7:int = 1, param8:Boolean = false) : void
      {
         this.FHyperStringImporter.ImportAsSystemChannel(param1,param2,param3);
      }
      
      protected function ImportPerform_Chat_SystemNotice(param1:ByteArray, param2:THyperString, param3:uint, param4:String, param5:uint, param6:uint, param7:int = 1, param8:Boolean = false) : void
      {
         this.FHyperStringImporter.ImportAsSystemChannel(param1,param2,param3);
      }
      
      protected function Perform_Post_World(param1:THyperString, param2:uint = 2) : void
      {
         this.FWindowChatView.AddMessage(param1,param2);
      }
      
      protected function Perform_Post_Country(param1:THyperString, param2:uint = 3) : void
      {
         this.FWindowChatView.AddMessage(param1,param2);
      }
      
      protected function Perform_Post_Organization(param1:THyperString, param2:uint = 4) : void
      {
         this.FWindowChatView.AddMessage(param1,param2);
      }
      
      protected function Perform_Post_Team(param1:THyperString, param2:uint = 8) : void
      {
         this.FWindowChatView.AddMessage(param1,param2);
      }
      
      protected function Perform_Post_SystemOne(param1:THyperString, param2:uint = 1) : void
      {
         this.FWindowChatView.AddMessage(param1,CHANNEL_TYPE_World);
      }
      
      protected function Perform_Post_SystemMarquee(param1:THyperString, param2:uint = 6) : void
      {
         if(this.FOnMarquee != null)
         {
            this.FOnMarquee(this,param1);
         }
      }
      
      protected function Perform_Post_SystemNotice(param1:THyperString, param2:uint = 7) : void
      {
         this.FHyperStrings.push(param1);
         param1.StubReferences.Reference(this);
      }
      
      override protected function LogicsPerform() : void
      {
         var _loc1_:int = 0;
         super.LogicsPerform();
         if(this.FInitialization)
         {
            this.FWindowChatView.Update();
            this.FWindowChatView.RenderingPerform();
            _loc1_ = int(STimingCore.TickCount);
            if(_loc1_ > this.FNextTick)
            {
               this.FWindowChannelFilter.Update();
               this.FWindowChannelSelectPopupMenu.Update();
               this.FWindowCharacterSelectPopupMenu.Update();
               this.FHyperEditor.RenderingPerform();
               this.LogicsPerfom_SystemNotice();
               this.ComponentsAlign();
               this.FNextTick += 100;
            }
            this.LogicsPerform_ChatViewPanel();
         }
      }
      
      protected function LogicsPerfom_SystemNotice() : void
      {
         var _loc1_:THyperString = null;
         if(!this.FMC_Notice.visible && this.FHyperStrings.length > 0)
         {
            _loc1_ = this.FHyperStrings.shift();
            if(_loc1_.Count <= 0)
            {
               return;
            }
            _loc1_.Delete(0);
            this.ProcessoSystemNotice(_loc1_);
            _loc1_.StubReferences.Dereference(this);
         }
      }
      
      protected function LogicsPerform_ChatViewPanel() : void
      {
         var _loc1_:Number = NaN;
         _loc1_ = this.FMC_PanelChat.alpha;
         if(this.FIsVisiblePanelChat)
         {
            if(_loc1_ < this.FAlphaPanelChat)
            {
               _loc1_ += 0.25;
            }
            if(_loc1_ > this.FAlphaPanelChat)
            {
               _loc1_ = this.FAlphaPanelChat;
            }
         }
         else
         {
            if(_loc1_ > 0)
            {
               _loc1_ -= 0.001;
            }
            if(_loc1_ < 0)
            {
               _loc1_ = 0;
            }
         }
         if(this.FMC_PanelChat.alpha != _loc1_)
         {
            this.FMC_PanelChat.alpha = _loc1_;
            this.FWindowChatView.ScrollBar.alpha = _loc1_;
         }
      }
      
      protected function ComponentsAlign() : void
      {
         this.ComponentsAlign_PanelChannelList();
      }
      
      protected function ComponentsAlign_PanelChannelList() : void
      {
         if(this.FWindowChannelSelectPopupMenu.Visible)
         {
            this.FWindowChannelSelectPopupMenu.X = this.FBtnChannelSelect.X - 3;
            this.FWindowChannelSelectPopupMenu.Y = SIZE_HEIGHT_Chat - this.FBtnChannelSelect.Substrate.height - this.FWindowChannelSelectPopupMenu.Height - 5;
         }
      }
      
      override protected function ProcessorResize() : void
      {
         var _loc1_:uint = 0;
         _loc1_ = FUICore.StageHeight;
         if(this.FMC_Chat != null)
         {
            this.X = 1;
            this.Y = _loc1_ - SIZE_HEIGHT_Chat;
         }
      }
      
      protected function InitializationChannelsState() : void
      {
         var _loc1_:Boolean = false;
         _loc1_ = false;
         this.ProcssorChannelFilterSwitch(CHANNEL_TYPE_Organization,_loc1_);
         this.ProcssorChannelListSwitch(CHANNEL_TYPE_Organization,_loc1_);
         this.ProcssorChannelFilterSwitch(CHANNEL_TYPE_Team,_loc1_);
         this.ProcssorChannelListSwitch(CHANNEL_TYPE_Team,_loc1_);
         if(this.FCharacter.Country > 0)
         {
            _loc1_ = true;
         }
         this.ProcssorChannelFilterSwitch(CHANNEL_TYPE_Country,_loc1_);
         this.ProcssorChannelListSwitch(CHANNEL_TYPE_Country,_loc1_);
      }
      
      protected function ProcssorChannelFilterSwitch(param1:uint, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         _loc3_ = CHANNELS_FILTER.indexOf(param1);
         if(_loc3_ < 0)
         {
            return;
         }
         this.FWindowChannelFilter.SetChannelsUsable(_loc3_,param2);
      }
      
      protected function ProcssorChannelListSwitch(param1:uint, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         _loc3_ = CHANNELS_TYPE_LIST.indexOf(param1);
         if(_loc3_ < 0)
         {
            return;
         }
         this.FWindowChannelSelectPopupMenu.SetChannelsUsable(_loc3_,param2);
      }
      
      protected function SwitchChannelSelectByType(param1:uint) : void
      {
         this.SetChatChannel(param1);
      }
      
      protected function SwitchChannelFilterByType(param1:uint) : void
      {
         var _loc2_:int = 0;
         this.FCurFilterChannelID = param1;
         _loc2_ = CHANNELS_FILTER.indexOf(param1);
         this.FWindowChannelFilter.SwithTabByIndex = _loc2_;
         this.FWindowChatView.SetChannelSketcherByIndex(_loc2_);
      }
      
      protected function ProcessorOnInquiryCharacterID(param1:uint, param2:uint) : void
      {
         var _loc3_:uint = 0;
         if(param1 == 0 && param2 == 0)
         {
            _loc3_ = uint(this.FUIWindowEditorString.Tag);
            this.ClearWhisper();
            this.EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_03));
         }
         else
         {
            _loc3_ = CHANNEL_TYPE_Whisper;
         }
         this.FChatWhisperID0 = param1;
         this.FChatWhisperID1 = param2;
         this.SetChatChannel(_loc3_);
      }
      
      protected function ProcessorInterpersonalRelationshipsByCharacter() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:TFriendDigest = null;
         _loc1_ = true;
         _loc2_ = this.FFriends.GetDigestByIdentifier(this.FCharacterDigest.Identifier0,this.FCharacterDigest.Identifier1);
         if(_loc2_ != null)
         {
            if(_loc2_.Type == TYPE_Whitelist_Add && _loc2_.Type == this.FCharacterDigest.Tag)
            {
               _loc1_ = false;
               this.EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_06));
            }
            else if(_loc2_.Type == TYPE_Blacklist_Add && _loc2_.Type == this.FCharacterDigest.Tag)
            {
               _loc1_ = false;
               this.EffectGenerateText(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_07));
            }
         }
         if(_loc1_)
         {
            if(this.FOnInterpersonalRelationships != null)
            {
               this.FOnInterpersonalRelationships(this,this.FCharacterDigest.Tag,this.FCharacterDigest);
            }
         }
      }
      
      protected function SetChatTargetWhisper(param1:TDigest) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = param1.Name;
         _loc3_ = param1.Identifier0;
         _loc4_ = param1.Identifier1;
         if(_loc3_ == 0 && _loc4_ == 0)
         {
            return;
         }
         if(_loc3_ != this.FChatWhisperID0 || _loc4_ != this.FChatWhisperID1)
         {
            this.FChatWhisperName = _loc2_;
            this.FChatWhisperID0 = _loc3_;
            this.FChatWhisperID1 = _loc4_;
         }
         this.SetChatChannel(CHANNEL_TYPE_Whisper);
         this.FHyperEditor.SetFocus();
      }
      
      protected function ProcessorHyperEditorOnInventoryReveal(param1:Object) : void
      {
         var _loc2_:Boolean = false;
         var _loc3_:int = 0;
         var _loc4_:uint = 0;
         var _loc5_:TInventory = null;
         var _loc6_:THyperStringElementLinkItem = null;
         _loc5_ = param1 as TInventory;
         _loc3_ = this.FCurSendChannelID;
         _loc2_ = this.CheckIsMessageSend(_loc3_);
         if(!_loc2_)
         {
            return;
         }
         _loc6_ = this.FPoolHyperString.AcquireElementLinkItem();
         _loc6_.Text = _loc5_.Name;
         _loc6_.Identifier0 = _loc5_.Identifier0;
         _loc6_.Identifier1 = _loc5_.Identifier1;
         _loc6_.IDTemplate = _loc5_.IDTemplate;
         _loc6_.RoleIdentifier0 = SLogicsCore.Character.Identifier0;
         _loc6_.RoleIdentifier1 = SLogicsCore.Character.Identifier1;
         _loc4_ = QUALITYCOLOR_INDEX[_loc5_.Quality];
         _loc6_.ColorOverride(_loc4_);
         this.FHyperEditor.Add(_loc6_);
         this.BtnMessageSendOnClick(null);
      }
      
      protected function CheckChannelWorldLimit() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:int = 0;
         _loc1_ = int(this.FCharacter.GetMainLevel());
         if(_loc1_ <= this.FChannelWorldLimit)
         {
            _loc4_ = this.FChannelWorldLimit + 1;
            _loc3_ = this.FWindowChannelSelectPopupMenu.GetCurChannelName;
            _loc2_ = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_09),_loc4_,_loc3_);
            this.SystemTextOuput(_loc2_);
            return true;
         }
         return false;
      }
      
      protected function CheckChannelCooling() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc3_ = true;
         _loc4_ = int(this.FWindowChannelSelectPopupMenu.GetCurChannelCooling);
         _loc5_ = int(this.FWindowChannelSelectPopupMenu.CurChannelsCoolingPeriod);
         _loc1_ = int(STimingCore.TickCount);
         if(_loc1_ - _loc5_ < _loc4_)
         {
            _loc2_ = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_01);
            this.SystemTextOuput(_loc2_);
            _loc3_ = false;
         }
         else
         {
            this.FWindowChannelSelectPopupMenu.CurChannelsCoolingPeriod = _loc1_;
         }
         return _loc3_;
      }
      
      protected function CheckIsMessageSend(param1:int) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         _loc2_ = this.CheckChatForbidden();
         if(_loc2_)
         {
            return false;
         }
         if(param1 == CHANNEL_TYPE_World || param1 == CHANNEL_TYPE_Nation)
         {
            _loc3_ = this.CheckChannelWorldLimit();
            if(_loc3_)
            {
               return false;
            }
         }
         return true;
      }
      
      protected function ChatMessageSend() : void
      {
         var _loc1_:TPacket = null;
         var _loc2_:ByteArray = null;
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:Boolean = false;
         if(!this.Visible)
         {
            return;
         }
         _loc4_ = this.FCurSendChannelID;
         _loc3_ = this.CheckIsMessageSend(_loc4_);
         if(!_loc3_)
         {
            return;
         }
         _loc8_ = this.CheckChannelCooling();
         if(!_loc8_)
         {
            return;
         }
         _loc5_ = 0;
         _loc6_ = 0;
         if(_loc4_ == CHANNEL_TYPE_Whisper)
         {
            if(!(this.FChatWhisperID0 != 0 && this.FChatWhisperID1 != 0))
            {
               this.SystemTextOuput(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_02));
               return;
            }
            _loc5_ = this.FChatWhisperID0;
            _loc6_ = this.FChatWhisperID1;
            _loc7_ = this.FChatWhisperName;
         }
         else
         {
            _loc5_ = 0;
            _loc6_ = 0;
            _loc7_ = this.FCharacter.NickName;
         }
         _loc1_ = SNetworkCore.PacketAcquire(CONST_NETWORK.PACKETID_CS_Chat_ChatInfo);
         _loc2_ = _loc1_.Data;
         _loc2_.writeByte(_loc4_);
         _loc2_.writeUnsignedInt(_loc5_);
         _loc2_.writeUnsignedInt(_loc6_);
         _loc2_.writeBoolean(SLogicsCore.BleachAgentData.Open);
         TUtilityString.FlushUTF(_loc2_,_loc7_);
         this.FStream.length = 0;
         this.FStreamizerHyperString.Streamize(this.FStream,this.FHyperEditor.HyperString,null);
         this.FStream.position = 0;
         _loc2_.writeShort(this.FStream.length);
         _loc2_.writeBytes(this.FStream);
         _loc2_.position = 0;
         SNetworkCore.Transceiver.PacketTransmit(_loc1_);
         this.ProcessorStatisticsInfo(_loc4_,this.FChatWhisperID0,this.FChatWhisperID1,this.FChatWhisperName,this.FHyperEditor.HyperString);
         this.FHyperEditor.SaveHistory();
         this.FHyperEditor.Clear();
         this.FStream.clear();
      }
      
      public function ProcessorStatisticsInfo(param1:uint, param2:uint, param3:uint, param4:String, param5:THyperString) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:String = null;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:THyperStringElement = null;
         var _loc13_:THyperStringElementText = null;
         _loc9_ = "";
         _loc10_ = "";
         _loc11_ = "";
         if(param1 == CHANNEL_TYPE_Whisper)
         {
            _loc9_ = param2.toString() + param3.toString();
            _loc10_ = param4;
         }
         _loc8_ = CHANNELS_TYPE_360.indexOf(param1);
         _loc7_ = param5.Count;
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc12_ = param5.GetElementByIndex(_loc6_);
            if(_loc12_ is THyperStringElementText)
            {
               _loc13_ = _loc12_ as THyperStringElementText;
               _loc11_ += _loc13_.Text;
            }
            _loc6_++;
         }
         SExternalCore.FilterMsg(this.FCharacter.NickName,_loc8_,_loc9_,_loc10_,_loc11_,STimingCore.ServerTick);
      }
      
      protected function SystemTextOuput(param1:String = "") : void
      {
         var _loc2_:THyperStringElementText = null;
         var _loc3_:THyperStringElementIcon = null;
         var _loc4_:THyperString = null;
         _loc2_ = this.FPoolHyperString.AcquireElementText();
         _loc3_ = this.FPoolHyperString.AcquireElementIcon();
         _loc4_ = this.FPoolHyperString.AcquireHyperString();
         _loc2_.Text = param1;
         _loc3_.IDIcon = 0;
         _loc4_.Add(_loc2_);
         _loc4_.Add(_loc3_);
         this.FHyperStringImporter.ImportAsSystemChannel(null,_loc4_,CHANNEL_TYPE_SystemOne);
         this.FWindowChatView.AddMessage(_loc4_,this.FCurSendChannelID);
      }
      
      protected function CheckChatForbidden() : Boolean
      {
         var _loc1_:Boolean = false;
         _loc1_ = this.FCharacter.ChatForbidden;
         if(_loc1_)
         {
            this.SystemTextOuput(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_04));
         }
         return _loc1_;
      }
      
      protected function ProcessorPopupWindowHider(param1:TUIComponent) : void
      {
         var _loc2_:Boolean = false;
         if(param1.Visible)
         {
            _loc2_ = this.HitWindowTest(param1);
            if(_loc2_)
            {
               return;
            }
            param1.Visible = false;
            this.RemoveEventListenerWindowPopup();
         }
      }
      
      protected function ProcessoSystemNotice(param1:THyperString) : void
      {
         this.FSketcher.Sketch(param1,SIZE_WIDTH_Notice);
         this.FMC_Notice.visible = true;
         TweenUtil.to(this.FMC_Notice,500,{
            "x":0,
            "onComplete":this.SystemNoticeEndTween
         });
      }
      
      protected function SystemNoticeEndTween() : void
      {
         TweenUtil.to(this.FMC_Notice,500,{
            "x":-this.FMC_Notice.width,
            "delay":TIME_Expired,
            "onComplete":this.SystemNoticeHideTween
         });
      }
      
      protected function SystemNoticeHideTween() : void
      {
         this.FMC_Notice.visible = false;
      }
      
      protected function HitWindowTest(param1:TUIComponent) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:TCoordinate = null;
         var _loc4_:TBounds = null;
         _loc3_ = TUtilityCartisian.GetScreenCoordinateByDisplayObject(param1);
         _loc4_ = new TBounds();
         _loc4_.Assign(_loc3_);
         _loc4_.Width = param1.Width;
         _loc4_.Height = param1.Height;
         return TUtilityCartisian.BoundsContainsCoordinate(_loc4_,FUICore.MouseCoordinate);
      }
      
      protected function EffectGenerateText(param1:String) : void
      {
         if(this.FOnEffectText != null)
         {
            this.FOnEffectText(this,param1);
         }
      }
      
      protected function ClearWhisper() : void
      {
         this.FChatWhisperName = "";
         this.FChatWhisperID0 = 0;
         this.FChatWhisperID1 = 0;
         this.FUIWindowEditorString.Value = "";
      }
      
      protected function addEventListenerWindowPopup() : void
      {
         FUICore.UIStage.addEventListener(MouseEvent.MOUSE_UP,this.WindowPopupHiderOnUp,false,0,true);
      }
      
      protected function RemoveEventListenerWindowPopup() : void
      {
         FUICore.UIStage.removeEventListener(MouseEvent.MOUSE_UP,this.WindowPopupHiderOnUp);
      }
      
      protected function ChatViewOnOver(param1:Object) : void
      {
         this.FIsVisiblePanelChat = true;
      }
      
      protected function ChatViewOnOut(param1:Object) : void
      {
         this.FIsVisiblePanelChat = false;
      }
      
      protected function WindowPopupHiderOnUp(param1:MouseEvent) : void
      {
         this.ProcessorPopupWindowHider(this.FWindowExpression);
         this.ProcessorPopupWindowHider(this.FWindowChannelSelectPopupMenu);
         this.ProcessorPopupWindowHider(this.FWindowCharacterSelectPopupMenu);
      }
      
      protected function BtnMessageSendOnClick(param1:MouseEvent) : void
      {
         if(this.FHyperEditor.HyperString.Count > 0)
         {
            this.ChatMessageSend();
         }
         this.FHyperEditor.SetFocus();
      }
      
      protected function BtnExpressionOnClick(param1:MouseEvent) : void
      {
         this.FWindowExpression.Visible = !this.FWindowExpression.Visible;
         if(this.FWindowExpression.Visible)
         {
            this.addEventListenerWindowPopup();
         }
      }
      
      protected function BtnChannelSelectOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FWindowChannelSelectPopupMenu.Visible = !this.FWindowChannelSelectPopupMenu.Visible;
         param2.stopPropagation();
         if(this.FWindowChannelSelectPopupMenu.Visible)
         {
            this.addEventListenerWindowPopup();
         }
      }
      
      protected function BtnZoomingOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:Boolean = false;
         _loc3_ = this.FBtnZoomingMin.Visible;
         this.FBtnZoomingMax.Visible = _loc3_;
         this.FBtnZoomingMin.Visible = !_loc3_;
         this.FWindowChatView.Visible = !_loc3_;
         this.FMC_PanelChat.visible = !_loc3_;
      }
      
      protected function ExpressionOnClick(param1:Object, param2:uint) : void
      {
         var _loc3_:THyperStringElementIcon = null;
         _loc3_ = this.FPoolHyperString.AcquireElementIcon();
         _loc3_.IDIcon = param2;
         this.FHyperEditor.Add(_loc3_);
         this.FWindowExpression.Visible = false;
         this.FHyperEditor.SetFocus();
      }
      
      protected function HyperEditorMessageSendOnkeyDown(param1:Object, param2:uint, param3:uint, param4:uint) : void
      {
         this.ChatMessageSend();
      }
      
      protected function HyperStringLinkOnClick(param1:Object, param2:THyperStringElement) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Class = null;
         var _loc8_:THyperStringElementLinkCharacter = null;
         var _loc9_:THyperStringElementLinkURL = null;
         var _loc10_:THyperStringElementLinkEvent = null;
         var _loc11_:THyperStringElementLinkItem = null;
         var _loc12_:THyperStringElementLinkHero = null;
         var _loc13_:TSystemLanguage = null;
         _loc7_ = TUtilityRTTI.GetClassByInstance(param2);
         _loc13_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,CONST_SYSTEMLANGUAGE.ChatChannel_01) as TSystemLanguage;
         switch(_loc7_)
         {
            case THyperStringElementLinkCharacter:
               _loc8_ = param2 as THyperStringElementLinkCharacter;
               this.FCharacterDigest.Name = _loc8_.Text;
               _loc5_ = _loc8_.Identifier0;
               _loc6_ = _loc8_.Identifier1;
               if(_loc5_ == this.FCharacter.Identifier0 && _loc6_ == this.FCharacter.Identifier1)
               {
                  return;
               }
               this.FCharacterDigest.Coerce(_loc5_,_loc6_);
               this.FWindowCharacterSelectPopupMenu.X = FUICore.MouseCoordinate.X - FBoundsScreen.X + 30;
               _loc3_ = FUICore.MouseCoordinate.Y - FBoundsScreen.Y - 10;
               _loc4_ = this.FWindowCharacterSelectPopupMenu.Height;
               if(_loc3_ + _loc4_ + 30 > FBoundsScreen.Height)
               {
                  _loc3_ -= _loc4_ / 3;
               }
               if(_loc3_ > 0)
               {
                  _loc3_ -= _loc4_ / 4;
               }
               this.FWindowCharacterSelectPopupMenu.Y = _loc3_;
               this.addEventListenerWindowPopup();
               this.FWindowCharacterSelectPopupMenu.Visible = true;
               break;
            case THyperStringElementLinkURL:
               _loc9_ = param2 as THyperStringElementLinkURL;
               SExternalCore.NavigateToLinkUrl(_loc9_.HyperlinkAddress);
               break;
            case THyperStringElementLinkItem:
               _loc11_ = param2 as THyperStringElementLinkItem;
               if(this.FOnShowInventoryInfor != null)
               {
                  this.FOnShowInventoryInfor(this,_loc11_.RoleIdentifier0,_loc11_.RoleIdentifier1,_loc11_.IDTemplate,_loc11_.Identifier0,_loc11_.Identifier1);
               }
               break;
            case THyperStringElementLinkHero:
               _loc12_ = param2 as THyperStringElementLinkHero;
               if(this.FOnShowHeroDescription != null)
               {
                  this.FOnShowHeroDescription(this,_loc12_.IDTemplate);
               }
               break;
            case THyperStringElementLinkEvent:
               _loc10_ = param2 as THyperStringElementLinkEvent;
               if(_loc10_.EventID != CONST_POST.EventID_Additional_TeamBattle_PVE && _loc10_.EventID != CONST_POST.EventID_Additional_TeamBattle_PVP && SLogicsCore.Character.RoleSencePosition != CONST_COMMON.SCENEPOSITION_MAINCITY)
               {
                  this.EffectGenerateText(_loc13_.Desc);
                  return;
               }
               this.GetPositionAndLocation(_loc10_);
         }
      }
      
      protected function GetPositionAndLocation(param1:THyperStringElementLinkEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:Vector.<Array> = null;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc4_ = param1.EventID;
         _loc8_ = uint(_loc4_ / 10);
         _loc3_ = CONST_POST.SHORTCUT_TYPES.length;
         _loc2_ = 0;
         loop0:
         while(_loc2_ < _loc3_)
         {
            _loc7_ = CONST_POST.SHORTCUT_TYPES[_loc2_];
            _loc10_ = 0;
            while(_loc10_ < _loc7_.length)
            {
               if(_loc8_ == _loc7_[_loc10_][0])
               {
                  _loc5_ = CONST_POST.SHORTCUT_POSITIONS[_loc2_];
                  _loc6_ = uint(_loc7_[_loc10_][1]);
                  _loc9_ = _loc4_ % 10;
                  break loop0;
               }
               _loc10_++;
            }
            _loc2_++;
         }
         if(_loc8_ == CONST_POST.TYPE_SecondaryFunction_TeamBattle)
         {
            if(this.FOnShortcutHyperlinks != null)
            {
               this.FOnShortcutHyperlinks(this,_loc5_,_loc6_,_loc9_,param1.Tag);
            }
         }
         else if(this.FOnShortcutHyperlinks != null)
         {
            this.FOnShortcutHyperlinks(this,_loc5_,_loc6_,_loc9_);
         }
      }
      
      protected function PopupMenuChannelSelectOnClick(param1:Object, param2:uint) : void
      {
         if(param2 == CHANNEL_TYPE_Whisper)
         {
            this.FUIWindowEditorString.Tag = this.FCurSendChannelID;
            this.FUIWindowEditorString.OnOK = this.WindowEditorStringOnOK;
            this.FUIWindowEditorString.OnCancel = this.WindowEditorStringOnCancel;
            this.FUIWindowEditorString.MaxChars = 32;
            this.FUIWindowEditorString.Label = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_05);
            this.FUIWindowEditorString.SetCoordinate((SIZE_WIDTH_Chat - this.FUIWindowEditorString.WindowWidth) / 2 + 5,STAGE_Height - this.FUIWindowEditorString.WindowHeight - 30);
            this.FUIWindowEditorString.SetFocus();
            this.FUIWindowEditorString.Visible = true;
         }
         else
         {
            this.SwitchChannelFilterByType(param2);
            this.FHyperEditor.SetFocus();
         }
         this.FTFChannelName.text = this.FWindowChannelSelectPopupMenu.GetCurChannelName;
         this.FCurSendChannelID = param2;
      }
      
      protected function PopupMenuCharacterSelectOnClick(param1:Object, param2:uint) : void
      {
         switch(param2)
         {
            case CHARACTER_SELECT_View:
               if(this.FOnShowHeroInfor != null)
               {
                  this.FOnShowHeroInfor(this,this.FCharacterDigest.Identifier0,this.FCharacterDigest.Identifier1);
               }
               break;
            case CHARACTER_SELECT_Achievement:
               if(this.FOnShowHeroAchievement != null)
               {
                  this.FOnShowHeroAchievement(this,this.FCharacterDigest.Identifier0,this.FCharacterDigest.Identifier1);
               }
               break;
            case CHARACTER_SELECT_Whisper:
               this.SetChatTargetWhisper(this.FCharacterDigest);
               break;
            case CHARACTER_SELECT_CopyName:
               System.setClipboard(this.FCharacterDigest.Name);
               this.FHyperEditor.SetFocus();
               break;
            case CHARACTER_SELECT_Friend:
               this.FCharacterDigest.Tag = TYPE_Whitelist_Add;
               this.ProcessorInterpersonalRelationshipsByCharacter();
               break;
            case CHARACTER_SELECT_Shield:
               this.FUIWindowConfirmation.Text = TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_08),this.FCharacterDigest.Name);
               this.FCharacterDigest.Tag = TYPE_Blacklist_Add;
               this.FUIWindowConfirmation.SetCoordinate((SIZE_WIDTH_Chat - this.FUIWindowConfirmation.WindowWidth) / 2 + 5,STAGE_Height - this.FUIWindowConfirmation.WindowHeight - 30);
               this.FUIWindowConfirmation.OnOK = this.WindowConfirmationOnOK;
               this.FUIWindowConfirmation.Visible = true;
         }
      }
      
      protected function BtnChannelFilterSelectOnClick(param1:Object, param2:uint) : void
      {
         var _loc3_:int = 0;
         this.FCurFilterChannelID = param2;
         _loc3_ = CHANNELS_FILTER.indexOf(param2);
         this.SwitchChannelSelectByType(param2);
         this.FWindowChatView.SetChannelSketcherByIndex(_loc3_);
         this.FHyperEditor.SetFocus();
      }
      
      protected function WindowConfirmationOnOK(param1:Object) : void
      {
         this.ProcessorInterpersonalRelationshipsByCharacter();
      }
      
      protected function WindowInformationOnOK(param1:Object) : void
      {
         if(this.FOnHackWarningResponse != null)
         {
            this.FOnHackWarningResponse(this);
         }
      }
      
      protected function WindowEditorStringOnOK(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         _loc2_ = this.FUIWindowEditorString.Value;
         if(TUtilityString.Empty(_loc2_))
         {
            _loc3_ = uint(this.FUIWindowEditorString.Tag);
            this.SetChatChannel(_loc3_);
            this.SystemTextOuput(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_02));
            this.ClearWhisper();
            return;
         }
         this.FChatWhisperName = _loc2_;
         if(this.FOnInquiryReq != null)
         {
            this.FOnInquiryReq(this,_loc2_);
         }
         this.FHyperEditor.SetFocus();
      }
      
      protected function WindowEditorStringOnCancel(param1:Object) : void
      {
         var _loc2_:uint = 0;
         _loc2_ = uint(this.FUIWindowEditorString.Tag);
         this.SetChatChannel(_loc2_);
         this.FUIWindowEditorString.Value = "";
      }
      
      public function get OnInquiryReq() : Function
      {
         return this.FOnInquiryReq;
      }
      
      public function set OnInquiryReq(param1:Function) : void
      {
         this.FOnInquiryReq = param1;
      }
      
      public function get OnInterpersonalRelationships() : Function
      {
         return this.FOnInterpersonalRelationships;
      }
      
      public function set OnInterpersonalRelationships(param1:Function) : void
      {
         this.FOnInterpersonalRelationships = param1;
      }
      
      public function get OnEffectText() : Function
      {
         return this.FOnEffectText;
      }
      
      public function set OnEffectText(param1:Function) : void
      {
         this.FOnEffectText = param1;
      }
      
      public function get OnMarquee() : Function
      {
         return this.FOnMarquee;
      }
      
      public function set OnMarquee(param1:Function) : void
      {
         this.FOnMarquee = param1;
      }
      
      public function get OnHackWarningResponse() : Function
      {
         return this.FOnHackWarningResponse;
      }
      
      public function set OnHackWarningResponse(param1:Function) : void
      {
         this.FOnHackWarningResponse = param1;
      }
      
      public function get OnShortcutHyperlinks() : Function
      {
         return this.FOnShortcutHyperlinks;
      }
      
      public function set OnShortcutHyperlinks(param1:Function) : void
      {
         this.FOnShortcutHyperlinks = param1;
      }
      
      public function set OnShowHeroInfor(param1:Function) : void
      {
         this.FOnShowHeroInfor = param1;
      }
      
      public function set OnShowInventoryInfor(param1:Function) : void
      {
         this.FOnShowInventoryInfor = param1;
      }
      
      public function set OnShowHeroDescription(param1:Function) : void
      {
         this.FOnShowHeroDescription = param1;
      }
      
      public function set OnShowHeroAchievement(param1:Function) : void
      {
         this.FOnShowHeroAchievement = param1;
      }
      
      public function get OnTeamBattleChatPopNtf() : Function
      {
         return this.FOnTeamBattleChatPopNtf;
      }
      
      public function set OnTeamBattleChatPopNtf(param1:Function) : void
      {
         this.FOnTeamBattleChatPopNtf = param1;
      }
      
      public function SetChatOptions(param1:TChatOptions) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         _loc2_ = param1.ChatStatus;
         _loc3_ = true;
         switch(_loc2_)
         {
            case MODE_Hidden:
               _loc3_ = false;
         }
         this.Visible = _loc3_;
      }
      
      public function SetChatChannel(param1:uint = 0) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         _loc3_ = "";
         _loc2_ = CHANNELS_TYPE_LIST.indexOf(param1);
         if(_loc2_ >= 0 && _loc2_ < CAPACITY_ChannelLists)
         {
            if(param1 == CHANNEL_TYPE_Whisper)
            {
               if(this.FChatWhisperID0 != 0 && this.FChatWhisperID1 != 0)
               {
                  this.FCurSendChannelID = param1;
                  this.FWindowChannelSelectPopupMenu.CurChannelIndex = _loc2_;
               }
               if(!TUtilityString.Empty(this.FChatWhisperName))
               {
                  _loc3_ = this.FChatWhisperName;
               }
               else
               {
                  _loc3_ = this.FWindowChannelSelectPopupMenu.GetCurChannelName;
               }
            }
            else
            {
               this.FCurSendChannelID = param1;
               this.FWindowChannelSelectPopupMenu.CurChannelIndex = _loc2_;
               _loc3_ = this.FWindowChannelSelectPopupMenu.GetCurChannelName;
            }
            this.FTFChannelName.text = _loc3_;
         }
      }
      
      public function ProcessorInquiryCharacterIDRet(param1:uint, param2:uint) : void
      {
         this.ProcessorOnInquiryCharacterID(param1,param2);
      }
      
      public function ChatWhisperByDigest(param1:Object) : void
      {
         var _loc2_:TDigest = null;
         _loc2_ = param1 as TDigest;
         this.SetChatTargetWhisper(_loc2_);
      }
      
      public function ProcessorInventoryReveal(param1:Object) : void
      {
         this.ProcessorHyperEditorOnInventoryReveal(param1);
      }
      
      public function ProcessorActivatingChannel(param1:uint, param2:Boolean) : void
      {
         this.ProcssorChannelFilterSwitch(param1,param2);
         this.ProcssorChannelListSwitch(param1,param2);
         if(param1 == CHANNEL_TYPE_Team)
         {
            if(param2)
            {
               this.PopupMenuChannelSelectOnClick(this,param1);
            }
            else
            {
               this.PopupMenuChannelSelectOnClick(this,CHANNEL_TYPE_World);
            }
         }
      }
      
      public function ProcessorAntiAddiction(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:THyperString = null;
         var _loc6_:THyperStringElementText = null;
         var _loc7_:TSystemLanguage = null;
         _loc5_ = this.FPoolHyperString.AcquireHyperString();
         _loc6_ = this.FPoolHyperString.AcquireElementText();
         _loc3_ = param1 as uint;
         if(_loc3_ > 5)
         {
            _loc3_ = 5;
         }
         _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_SystemLanguage,this.FStringsAntiAddiction[_loc3_]) as TSystemLanguage;
         _loc6_.Text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_11);
         if(_loc3_ == 0)
         {
            _loc4_ = _loc7_.Desc.split("\\r");
            _loc2_ = 0;
            while(_loc2_ < _loc4_.length)
            {
               _loc6_.Text += "\r          ";
               _loc6_.Text += _loc4_[_loc2_];
               _loc6_.Text += ";";
               _loc2_++;
            }
         }
         else
         {
            _loc6_.Text += _loc7_.Desc;
         }
         _loc5_.Add(_loc6_);
         this.FHyperStringImporter.ImportAsSystemChannel(null,_loc5_,CHANNEL_TYPE_SystemOne);
         this.FWindowChatView.AddMessage(_loc5_,this.FCurSendChannelID);
      }
      
      public function HackWarning(param1:int) : void
      {
         var _loc2_:String = null;
         var _loc3_:THyperString = null;
         var _loc4_:THyperStringElementText = null;
         var _loc5_:Vector.<String> = null;
         _loc3_ = this.FPoolHyperString.AcquireHyperString();
         _loc4_ = this.FPoolHyperString.AcquireElementText();
         _loc5_ = TUtilityLobby.GetStringsByIdentifier(CONST_SYSTEMLANGUAGE.CHAT_STRING_10);
         _loc2_ = _loc5_[param1];
         _loc4_.Text = _loc2_;
         _loc3_.Add(_loc4_);
         this.FHyperStringImporter.ImportAsSystemChannel(null,_loc3_,CHANNEL_TYPE_SystemOne);
         this.FWindowChatView.AddMessage(_loc3_,this.FCurSendChannelID);
         this.FUIWindowInformation.Text = _loc2_;
         this.FUIWindowInformation.Tag = param1;
         this.FUIWindowInformation.OnOK = this.WindowInformationOnOK;
         this.FUIWindowInformation.Visible = true;
      }
      
      public function ProcessorPost(param1:THyperString, param2:TPost) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:Function = null;
         if(!this.FInitialization)
         {
            return;
         }
         _loc5_ = param2.Channel;
         this.FHyperStringImporter.ImportAsSystemChannel(null,param1,_loc5_);
         _loc4_ = int(param2.ShowChannels.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = param2.ShowChannels[_loc3_];
            _loc6_ = this.FPostRoutines.GetRoutineByIndentifier(_loc5_);
            if(_loc6_ != null)
            {
               _loc6_(param1);
            }
            _loc3_++;
         }
      }
      
      public function CheckChannelsState() : void
      {
         this.InitializationChannelsState();
      }
   }
}

