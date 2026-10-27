package Resources.Constants
{
   import Resources.Strings.*;
   
   public class CONST_CHAT
   {
      
      public static const FONT_DefaultName:String = "Tahoma";
      
      public static const FONT_DefaultSize:uint = 12;
      
      public static const FONT_DefaultColor:uint = 4294967295;
      
      public static const RESOURCESID_Swf_CHAT:uint = 1;
      
      public static const RESOURCE_ClassName_MC_Chat:String = "MC_Chat";
      
      public static const RESOURCE_ClassName_MC_Notice:String = "MC_Notice";
      
      public static const RESOURCE_Link_MC_PanelChat:String = "MC_PanelChat";
      
      public static const RESOURCE_Link_MC_ScrollBar:String = "MC_ScrollBar";
      
      public static const RESOURCE_ClassName_MC_PopupMenuChannelList:String = "MC_PopupMenuChannelList";
      
      public static const RESOURCE_ClassName_MC_PopupMenuCharacterList:String = "MC_PopupMenuCharacterList";
      
      public static const RESOURCE_Link_MC_PopupMenuSubstrate:String = "MC_PopupMenuSubstrate";
      
      public static const RESOURCE_Link_MC_Menus:String = "MC_Menu_";
      
      public static const RESOURCE_Link_MC_ChannelFilters:String = "MC_ChannelFilters";
      
      public static const RESOURCE_Link_MC_HyperEditorMountPoint:String = "MC_HyperEditorMountPoint";
      
      public static const RESOURCE_Link_MC_HyperEditorSubstrate:String = "MC_HyperEditorSubstrate";
      
      public static const RESOURCE_Link_MC_ChatViewMountPoint:String = "MC_ChatViewMountPoint";
      
      public static const RESOURCE_Link_MC_ChatViewSubstrate:String = "MC_ChatViewSubstrate";
      
      public static const RESOURCE_Link_Btn_ChannelSelect:String = "Btn_ChannelSelect";
      
      public static const RESOURCE_Link_TF_ChannelName:String = "TF_ChannelName";
      
      public static const RESOURCE_Link_Btn_Btn_MessageSend:String = "Btn_MessageSend";
      
      public static const RESOURCE_Link_Btn_Expression:String = "Btn_Expression";
      
      public static const RESOURCE_Link_MC_ZoomingMax:String = "MC_ZoomingMax";
      
      public static const RESOURCE_Link_MC_ZoomingMin:String = "MC_ZoomingMin";
      
      public static const MODE_None:uint = 0;
      
      public static const MODE_Hidden:uint = 1;
      
      public static const ZOOMING_Maximize:uint = 1;
      
      public static const ZOOMING_Minimize:uint = 2;
      
      public static const CHANNEL_TYPE_Composite:uint = 0;
      
      public static const CHANNEL_TYPE_SystemOne:uint = 1;
      
      public static const CHANNEL_TYPE_World:uint = 2;
      
      public static const CHANNEL_TYPE_Country:uint = 3;
      
      public static const CHANNEL_TYPE_Organization:uint = 4;
      
      public static const CHANNEL_TYPE_Whisper:uint = 5;
      
      public static const CHANNEL_TYPE_SystemMarquee:uint = 6;
      
      public static const CHANNEL_TYPE_SystemNotice:uint = 7;
      
      public static const CHANNEL_TYPE_Team:uint = 8;
      
      public static const CHANNEL_TYPE_Nation:uint = 9;
      
      public static const CAPACITY_Channels:uint = Get_CAPACITY_Channels();
      
      public static const CHANNELS_TYPE:Vector.<uint> = Vector.<uint>([CHANNEL_TYPE_Composite,CHANNEL_TYPE_SystemOne,CHANNEL_TYPE_World,CHANNEL_TYPE_Country,CHANNEL_TYPE_Organization,CHANNEL_TYPE_Whisper,CHANNEL_TYPE_SystemMarquee,CHANNEL_TYPE_SystemNotice,CHANNEL_TYPE_Team,CHANNEL_TYPE_Nation]);
      
      public static const CHANNELS_TYPE_360:Vector.<uint> = Vector.<uint>([CHANNEL_TYPE_Composite,CHANNEL_TYPE_Whisper,CHANNEL_TYPE_Composite,CHANNEL_TYPE_Composite,CHANNEL_TYPE_World,CHANNEL_TYPE_Country,CHANNEL_TYPE_Organization,CHANNEL_TYPE_Team,CHANNEL_TYPE_Composite,CHANNEL_TYPE_Composite]);
      
      public static const CHANNELS_TYPE_Filter:Vector.<uint> = Vector.<uint>([CHANNEL_TYPE_World,CHANNEL_TYPE_World,CHANNEL_TYPE_Country,CHANNEL_TYPE_Organization,CHANNEL_TYPE_Whisper]);
      
      public static const CHANNEL_LIST_World:uint = 0;
      
      public static const CHANNEL_LIST_Country:uint = 1;
      
      public static const CHANNEL_LIST_Organization:uint = 2;
      
      public static const CHANNEL_LIST_Team:uint = 3;
      
      public static const CHANNEL_LIST_Whisper:uint = 4;
      
      public static const CHANNEL_LIST_Nation:uint = 5;
      
      public static const CAPACITY_ChannelLists:uint = Get_CAPACITY_ChannelLists();
      
      public static const CHANNELS_TYPE_LIST:Vector.<uint> = Vector.<uint>([CHANNEL_TYPE_World,CHANNEL_TYPE_Country,CHANNEL_TYPE_Organization,CHANNEL_TYPE_Team,CHANNEL_TYPE_Whisper,CHANNEL_TYPE_Nation]);
      
      public static const CHANNEL_FILTER_TYPE_Composite:uint = 0;
      
      public static const CHANNEL_FILTER_TYPE_World:uint = 1;
      
      public static const CHANNEL_FILTER_TYPE_Country:uint = 2;
      
      public static const CHANNEL_FILTER_TYPE_Organization:uint = 3;
      
      public static const CHANNEL_FILTER_TYPE_Team:uint = 4;
      
      public static const CHANNEL_FILTER_TYPE_Whisper:uint = 5;
      
      public static const CHANNEL_FILTER_TYPE_Nation:uint = 6;
      
      public static const CAPACITY_ChannelsFilter:uint = Get_CAPACITY_ChannelsFilter();
      
      public static const CHANNELS_FILTER:Vector.<uint> = Vector.<uint>([CHANNEL_TYPE_Composite,CHANNEL_TYPE_World,CHANNEL_TYPE_Country,CHANNEL_TYPE_Organization,CHANNEL_TYPE_Team,CHANNEL_TYPE_Whisper,CHANNEL_TYPE_Nation]);
      
      public static const CHANNEL_COOLING_Composite:int = 0;
      
      public static const CHANNEL_COOLING_SystemOne:int = 0;
      
      public static const CHANNEL_COOLING_World:int = 6000;
      
      public static const CHANNEL_COOLING_Country:int = 5000;
      
      public static const CHANNEL_COOLING_Organization:int = 1000;
      
      public static const CHANNEL_COOLING_Whisper:int = 1000;
      
      public static const CHANNEL_COOLING_SystemMarquee:int = 0;
      
      public static const CHANNEL_COOLING_SystemNotice:int = 0;
      
      public static const CHANNEL_COOLING_Team:int = 0;
      
      public static const CHANNELS_Cooling:Vector.<int> = Vector.<int>([CHANNEL_COOLING_Composite,CHANNEL_COOLING_SystemOne,CHANNEL_COOLING_World,CHANNEL_COOLING_Country,CHANNEL_COOLING_Organization,CHANNEL_COOLING_Whisper,CHANNEL_COOLING_SystemMarquee,CHANNEL_COOLING_SystemNotice,CHANNEL_COOLING_Team]);
      
      public static const CHANNEL_CAPTION_Composite:String = "综合";
      
      public static const CHANNEL_CAPTION_System:String = "系统";
      
      public static const CHANNEL_CAPTION_World:String = "世界";
      
      public static const CHANNEL_CAPTION_Country:String = "家族";
      
      public static const CHANNEL_CAPTION_Organization:String = "军团";
      
      public static const CHANNEL_CAPTION_Whisper:String = "私聊";
      
      public static const CHANNEL_CAPTION_Team:String = "组队";
      
      public static const SIZE_IconWidth:int = 19;
      
      public static const SIZE_IconHeight:int = 16;
      
      public static const CAPACITY_Expression:uint = 15;
      
      public static const SPECIEL_BleachAgent:uint = 15;
      
      public static const CHARACTER_SELECT_View:uint = 0;
      
      public static const CHARACTER_SELECT_Achievement:uint = 1;
      
      public static const CHARACTER_SELECT_Whisper:uint = 2;
      
      public static const CHARACTER_SELECT_CopyName:uint = 3;
      
      public static const CHARACTER_SELECT_Friend:uint = 4;
      
      public static const CHARACTER_SELECT_Shield:uint = 5;
      
      public static const CAPACITY_CharacterSelect:uint = 6;
      
      public static const WHISPER_Receive:int = 1;
      
      public static const WHISPER_Echoplex:int = 2;
      
      public function CONST_CHAT()
      {
         super();
      }
      
      protected static function Get_CAPACITY_Channels() : uint
      {
         if(Boolean(true))
         {
            return CHANNEL_TYPE_Nation + 1;
         }
         return CHANNEL_TYPE_Team + 1;
      }
      
      protected static function Get_CAPACITY_ChannelLists() : uint
      {
         if(Boolean(true))
         {
            return CHANNEL_LIST_Nation + 1;
         }
         return CHANNEL_LIST_Whisper + 1;
      }
      
      protected static function Get_CAPACITY_ChannelsFilter() : uint
      {
         if(Boolean(true))
         {
            return CHANNEL_FILTER_TYPE_Nation + 1;
         }
         return CHANNEL_FILTER_TYPE_Whisper + 1;
      }
   }
}

