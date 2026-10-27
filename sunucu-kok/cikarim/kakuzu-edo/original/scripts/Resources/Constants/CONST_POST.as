package Resources.Constants
{
   public class CONST_POST
   {
      
      public static const IDENTIFIER_GM_POST:uint = 81001023;
      
      public static const TIME_Expired:uint = 60 * 1000;
      
      public static const EventID_Additional_TeamBattle_PVE:uint = 1281;
      
      public static const EventID_Additional_TeamBattle_PVP:uint = 1282;
      
      public static const POSTKEY_HeroName:uint = 0;
      
      public static const POSTKEY_HeroNameQuality:uint = 1;
      
      public static const POSTKEY_HeroNameQualityUnderline:uint = 2;
      
      public static const POSTKEY_PlayerQualityUnderline:uint = 3;
      
      public static const POSTKEY_PlayerCountryUnderline:uint = 4;
      
      public static const POSTKEY_Country:uint = 5;
      
      public static const POSTKEY_CountryColor:uint = 6;
      
      public static const POSTKEY_Job:uint = 7;
      
      public static const POSTKEY_Boss:uint = 8;
      
      public static const POSTKEY_Item:uint = 9;
      
      public static const POSTKEY_ItemUnderline:uint = 10;
      
      public static const POSTKEY_Reward:uint = 11;
      
      public static const POSTKEY_EventName:uint = 12;
      
      public static const POSTKEY_Name:uint = 13;
      
      public static const POSTKEY_Number:uint = 14;
      
      public static const POSTKEY_Corps:uint = 15;
      
      public static const POSTKEY_Single:uint = 16;
      
      public static const POSTKEY_OutlandArmy:uint = 17;
      
      public static const POSTKEY_CityQuality:uint = 18;
      
      public static const POSTKEY_Pet:uint = 19;
      
      public static const POSTKEY_OutLineUnderline:uint = 20;
      
      public static const POSTKEY_LeagueMap:uint = 21;
      
      public static const POSTKEY_Difficulty:uint = 22;
      
      public static const POSTKEY_BableTowerName:uint = 23;
      
      public static const POSTKEY_ArenaName:uint = 24;
      
      public static const POSTKEY_EventLink:uint = 40;
      
      public static const POSTKEY_ITEMS:Vector.<String> = Vector.<String>(["HeroName","HeroNameQuality","HeroNameQualityUnderline","PlayerQualityUnderline","PlayerCountryUnderline","Country","CountryColor","Job","Boss","Item","ItemUnderline","Reward","EventName","Name","Number","Corps","Single","OutlandArmy","CityQuality","Pet","OutLineUnderline","LeagueMap","Difficulty","BableTowerName","ArenaName"]);
      
      public static const EVENT_TYPE_PLAYER:String = "PLAYER";
      
      public static const EVENT_TYPE_HERO:String = "HERO";
      
      public static const EVENT_TYPE_ITEM:String = "ITEM";
      
      public static const EVENT_TYPE_EVENT:String = "EVENT";
      
      public static const EVENT_TYPE_LINKURL:String = "LINKURL";
      
      protected static const TYPE_Avatar_Hero:uint = 101;
      
      protected static const TYPE_Avatar_Military:uint = 102;
      
      protected static const TYPE_Avatar_VIP:uint = 103;
      
      protected static const TYPE_MainFunction_Heros:uint = 104;
      
      protected static const TYPE_MainFunction_Star:uint = 105;
      
      protected static const TYPE_MainFunction_TacticalDeployment:uint = 106;
      
      protected static const TYPE_MainFunction_Backpack:uint = 107;
      
      protected static const TYPE_MainFunction_Talisman:uint = 108;
      
      protected static const TYPE_MainFunction_KnifeOfKillSoul:uint = 109;
      
      protected static const TYPE_MainFunction_Smithy:uint = 110;
      
      protected static const TYPE_MainFucntion_Mail:uint = 111;
      
      protected static const TYPE_MainFunction_OrganiZation:uint = 113;
      
      protected static const TYPE_Map_Quest:uint = 114;
      
      protected static const TYPE_Map_Friend:uint = 115;
      
      protected static const TYPE_SecondaryFunction_DailyQuest:uint = 116;
      
      protected static const TYPE_SecondaryFunction_Mall:uint = 117;
      
      protected static const TYPE_SecondaryFunction_TreasureMap:uint = 119;
      
      protected static const TYPE_SecondaryFunction_DailySign:uint = 121;
      
      protected static const TYPE_SecondaryFunction_KillHeros:uint = 122;
      
      protected static const TYPE_SecondaryFunction_Arena:uint = 123;
      
      protected static const TYPE_SecondaryFunction_DailyActivity:uint = 124;
      
      protected static const TYPE_NPC_Tavern:uint = 125;
      
      protected static const TYPE_NPC_MakeEquip:uint = 126;
      
      protected static const TYPE_NPC_Jade:uint = 127;
      
      public static const TYPE_SecondaryFunction_TeamBattle:uint = 128;
      
      public static const TYPE_SHORTCUT_Avatar:Vector.<Array> = Vector.<Array>([[TYPE_Avatar_Hero,0],[TYPE_Avatar_Military,1],[TYPE_Avatar_VIP,2]]);
      
      public static const TYPE_SHORTCUT_MainFunction:Vector.<Array> = Vector.<Array>([[TYPE_MainFunction_Heros,CONST_SHORTCUTS.TYPE_MainFunction_Heros],[TYPE_MainFunction_Star,CONST_SHORTCUTS.TYPE_MainFunction_Star],[TYPE_MainFunction_TacticalDeployment,CONST_SHORTCUTS.TYPE_MainFunction_TacticalDeployment],[TYPE_MainFunction_Backpack,CONST_SHORTCUTS.TYPE_MainFunction_Backpack],[TYPE_MainFunction_Talisman,CONST_SHORTCUTS.TYPE_MainFunction_Treasure],[TYPE_MainFunction_KnifeOfKillSoul,CONST_SHORTCUTS.TYPE_MainFunction_KnifeOfKillSoul],[TYPE_MainFunction_Smithy,CONST_SHORTCUTS.TYPE_MainFunction_Strengthen],[TYPE_MainFucntion_Mail,CONST_SHORTCUTS.TYPE_MainFunction_Mail],[TYPE_MainFunction_OrganiZation,CONST_SHORTCUTS.TYPE_MainFunction_Organization]]);
      
      public static const TYPE_SHORTCUT_Map:Vector.<Array> = Vector.<Array>([[TYPE_Map_Quest,2],[TYPE_Map_Friend,3]]);
      
      public static const TYPE_SHORTCUT_SecondaryFunction:Vector.<Array> = Vector.<Array>([[TYPE_SecondaryFunction_Mall,CONST_SHORTCUTS.TYPE_SecondaryFunction_Mall]]);
      
      public static const TYPE_SHORTCUT_SecondaryFunctionA:Vector.<Array> = Vector.<Array>([[TYPE_SecondaryFunction_DailyQuest,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyQuest],[TYPE_SecondaryFunction_DailyActivity,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_DailyActivity],[TYPE_SecondaryFunction_DailySign,CONST_SHORTCUTS.TYPE_SecondaryFunctionA_Sign]]);
      
      public static const TYPE_SHORTCUT_SecondaryFunctionB:Vector.<Array> = Vector.<Array>([[TYPE_SecondaryFunction_Arena,CONST_SHORTCUTS.TYPE_SecondaryFunctionB_Arena],[TYPE_SecondaryFunction_TeamBattle,CONST_SHORTCUTS.TYPE_SecondaryFunctionB_TeamBattle],[TYPE_SecondaryFunction_KillHeros,CONST_SHORTCUTS.TYPE_SecondaryFunctionB_KillHeros],[TYPE_SecondaryFunction_TreasureMap,CONST_SHORTCUTS.TYPE_SecondaryFunctionB_TreasureMap]]);
      
      public static const TYPE_SHORTCUT_NPC:Vector.<Array> = Vector.<Array>([[TYPE_NPC_Tavern,1],[TYPE_NPC_MakeEquip,2],[TYPE_NPC_Jade,0]]);
      
      public static const SHORTCUT_TYPES:Vector.<Vector.<Array>> = Vector.<Vector.<Array>>([TYPE_SHORTCUT_MainFunction,TYPE_SHORTCUT_SecondaryFunction,TYPE_SHORTCUT_SecondaryFunctionA,TYPE_SHORTCUT_SecondaryFunctionB,TYPE_SHORTCUT_Avatar,TYPE_SHORTCUT_Map,TYPE_SHORTCUT_NPC]);
      
      public static const SHORTCUT_POSITIONS:Vector.<uint> = Vector.<uint>([CONST_SHORTCUTS.POSITION_MainFunction,CONST_SHORTCUTS.POSITION_SecondaryFunction,CONST_SHORTCUTS.POSITION_SecondaryFunctionA,CONST_SHORTCUTS.POSITION_SecondaryFunctionB,CONST_SHORTCUTS.POSITION_Avatar,CONST_SHORTCUTS.POSITION_Map,CONST_SHORTCUTS.POSITION_NPC]);
      
      public function CONST_POST()
      {
         super();
      }
   }
}

