package Resources.Constants
{
   import Foundation.Utilities.TUtilityString;
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   
   public class CONST_HEROCOMPANION
   {
      
      public static const RESOURCESID_Swf_Companion:uint = 671088640;
      
      public static const ResourceID_HeroCompanion:String = "MC_Companion_Window";
      
      public static const ResourceID_EmployInfo:String = "MC_Companion_EmployInfo";
      
      public static const ResourceID_EmployResult:String = "MC_Companion_EmployResult";
      
      public static const ResourceID_CompanionCardTip:String = "MC_Companion_CardTip";
      
      public static const ResourceID_CompanionCard:String = "MC_Companion_Card";
      
      public static const ResourceID_CompanionMapCard:String = "MC_Companion_MapItem";
      
      public static const ResourceID_CompanionChip:String = "MC_Companion_Chip";
      
      public static const ResourceID_PosRender:String = "MC_Companion_PosRender";
      
      public static const ResourceID_StarEffect:String = "MC_Companion_StarEffect";
      
      public static const COMPANION_WINDOW_WIDTH:int = 722;
      
      public static const COMPANION_WINDOW_HEIGHT:int = 532;
      
      public static const COMPANION_EMPLOY_WIDTH:int = 664;
      
      public static const COMPANION_EMPLOY_HEIGHT:int = 471;
      
      public static const COMPANION_RESULT_HEIGHT:int = 524;
      
      public static const TabType_Silver:int = 0;
      
      public static const TabType_Gold:int = 1;
      
      public static const TabType_Encounter:int = 2;
      
      public static const MoneyType_Sliver:int = 1;
      
      public static const MoneyType_Ticket:int = 2;
      
      public static const MoneyType_Gold:int = 3;
      
      public static const Scroll_Card_Num:int = 6;
      
      public static const Scroll_Card_Space:int = 120;
      
      public static const Seat_Equip_Num:int = 5;
      
      public static const Seat_Card_Num:int = 3;
      
      public static const Reforging_Chip_Num:int = 6;
      
      public static const Oper_Type_Add:int = 1;
      
      public static const Oper_Type_Multi:int = 2;
      
      public static const Map_List_HoriCount:int = 5;
      
      public static const Map_List_HoriSpace:int = 20;
      
      public static const PositionTable:Vector.<int> = Vector.<int>([1,7,6,8,12,11,13]);
      
      public static const SendType_EmployOne:int = 0;
      
      public static const SendType_EmployTen:int = 1;
      
      public static const SendCost_EmploySilver:int = 0;
      
      public static const SendCost_EmployGold:int = 1;
      
      public static const SendCost_EmployEncounter:int = 2;
      
      public static const Chip_Employ_Get:int = 0;
      
      public static const Chip_Employ_Exchange:int = 1;
      
      public static const Star_OffsetX:int = 20;
      
      public static const Star_OffsetY:int = 23;
      
      public static const Little_Star_Space:int = 17;
      
      public static const BigStar_OffsetY:int = -12;
      
      public static const BigStar_OffsetX:int = 18;
      
      public static const Big_Star_Space:int = 21;
      
      public static const Star_Delay:int = 200;
      
      public static const HTMLCOLOR_None:String = "#FFFFFFFF";
      
      public static const HTMLCOLOR_White:String = "#FFFFFFFF";
      
      public static const HTMLCOLOR_Green:String = "#FF68FF02";
      
      public static const HTMLCOLOR_Blue:String = "#FF0096FF";
      
      public static const HTMLCOLOR_Purple:String = "#FF9900CF";
      
      public static const HTMLCOLOR_Yellow:String = "#FFFFFF00";
      
      public static const HTMLCOLOR_Red:String = "#FFDB0030";
      
      public static const HTMLCOLOR_Orange:String = "#FFFF7300";
      
      public static const TextColor:Vector.<String> = Vector.<String>([HTMLCOLOR_None,HTMLCOLOR_Green,HTMLCOLOR_Blue,HTMLCOLOR_Purple,HTMLCOLOR_Yellow,HTMLCOLOR_Red]);
      
      public static const Employ_Count:int = 10;
      
      public static const Animation_Interval:int = 200;
      
      public static const Card_ShowTime:int = 1000;
      
      public static const Card_Scale:Number = 0.6;
      
      public static const LittleCard_OffsetY:int = 22;
      
      public static const Animation_Duration:int = 500;
      
      public static const Animation_Offset:int = 80;
      
      public static const Little_Star:int = 0;
      
      public static const Big_Star:int = 1;
      
      public static const Leader_Seat:int = 1;
      
      public static const EffectType_Upgrade:int = 1;
      
      public static const EffectType_Compose:int = 2;
      
      public function CONST_HEROCOMPANION()
      {
         super();
      }
      
      public static function GetColorStringByCount(param1:String, param2:Boolean) : String
      {
         var _loc3_:String = null;
         _loc3_ = param2 ? HTMLCOLOR_Green : HTMLCOLOR_Red;
         return TUtilityString.Format(TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_COMPANION_08),_loc3_,param1);
      }
   }
}

