package Resources.Constants
{
   import Processors.Game.Utilities.HyperLink.TUtilityHyperLink;
   
   public class CONST_SHINOBIDOPRACTISE
   {
      
      public static const RESOURCESID_Swf_ShinobidoPractise:uint = 1342177280;
      
      public static const RESOURCE_ClassName_MC_ShinobidoPractise:String = "MC_ShinobidoPractise";
      
      public static const RESOURCE_ClassName_MC_PromoteFightingPower:String = "MC_PromoteFightingPower";
      
      public static const RESOURCE_ClassName_MC_FightingPowerRanks:String = "MC_FightingPowerRanks";
      
      public static const RESOURCE_Link_MC_Item:String = "MC_Item_";
      
      public static const RESOURCE_Link_TF_FightingPower:String = "TF_FightingPower";
      
      public static const RESOURCE_Link_TF_Tittle:String = "TF_Tittle";
      
      public static const RESOURCE_Link_BTN_FightingPowerRankings:String = "BTN_FightingPowerRankings";
      
      public static const RESOURCE_Link_MC_PageLeft:String = "MC_PageLeft";
      
      public static const RESOURCE_Link_MC_PageRight:String = "MC_PageRight";
      
      public static const RESOURCE_Link_TF_BeatPercent:String = "TF_BeatPercent";
      
      public static const RESOURCE_Link_BTN_PromoteFightingCapacity:String = "BTN_PromoteFightingCapacity";
      
      public static const RESOURCE_Link_MC_JumpNum:String = "MC_JumpNum_";
      
      public static const RESOURCE_Link_MC_FightingRank:String = "MC_FightingRank_";
      
      public static const RESOURCE_Link_TF_UserRank:String = "TF_UserRank";
      
      public static const RESOURCE_Link_TF_UserFightingCapacity:String = "TF_UserFightingCapacity";
      
      public static const RESOURCE_Link_MC_Page:String = "MC_Page";
      
      public static const RESOURCE_Link_TF_Page:String = "TF_Page";
      
      public static const RESOURCE_Link_Vector:Vector.<String> = Vector.<String>(["Strengthen","TalismanUpgrade","SoulCalibur","Tavern","Jade","MakeRamen","ArenaBox","StoryLevel","TrialCopy","KillHero","FindTreasure"]);
      
      public static const POPTIP_Gotos:Vector.<uint> = Vector.<uint>([TUtilityHyperLink.HyperLink_Strengthen,TUtilityHyperLink.HyperLink_Treasure,TUtilityHyperLink.HyperLink_KnifeSoul,TUtilityHyperLink.HyperLink_Tavern,TUtilityHyperLink.HyperLink_Jade,TUtilityHyperLink.HyperLink_HellButterfly,TUtilityHyperLink.HyperLink_Arena,TUtilityHyperLink.HyperLink_WorldMap,TUtilityHyperLink.HyperLink_WorldMap,TUtilityHyperLink.HyperLink_KillHeros,TUtilityHyperLink.HyperLink_TreasureMap]);
      
      public static const POPTIP_FUNCTION_POSITION:Vector.<Array> = Vector.<Array>([[CONST_SHORTCUTS.POSITION_MainFunction,CONST_SHORTCUTS.TYPE_MainFunction_Strengthen],[CONST_SHORTCUTS.POSITION_MainFunction,CONST_SHORTCUTS.TYPE_MainFunction_Treasure],[CONST_SHORTCUTS.POSITION_Avatar,CONST_SHORTCUTS.TYPE_Avatar_KnifeSoul],[CONST_SHORTCUTS.POSITION_NPC,CONST_SHORTCUTS.TYPE_NPC_Tavern],[CONST_SHORTCUTS.POSITION_NPC,CONST_SHORTCUTS.TYPE_NPC_Jade],[CONST_SHORTCUTS.POSITION_Home,CONST_SHORTCUTS.TYPE_Home_HellButterfly],[CONST_SHORTCUTS.POSITION_SecondaryFunctionB,CONST_SHORTCUTS.TYPE_SecondaryFunctionB_Arena],[CONST_SHORTCUTS.POSITION_Map,CONST_SHORTCUTS.TYPE_Map_EnterWorldMap],[CONST_SHORTCUTS.POSITION_Map,CONST_SHORTCUTS.TYPE_Map_EnterWorldMap],[CONST_SHORTCUTS.POSITION_SecondaryFunctionB,CONST_SHORTCUTS.TYPE_SecondaryFunctionB_KillHeros],[CONST_SHORTCUTS.POSITION_SecondaryFunctionB,CONST_SHORTCUTS.TYPE_SecondaryFunctionB_TreasureMap]]);
      
      public static const RESOURCE_Link_MakeStrong:Vector.<String> = Vector.<String>(["Strengthen","Tavern","SoulCalibur","Jade","TalismanUpgrade"]);
      
      public static const RESOURCE_Link_MakeMoney:Vector.<String> = Vector.<String>(["StoryLevel","MakeRamen","ArenaBox","TrialCopy","FindTreasure"]);
      
      public static const RESOURCE_Link_LevelUp:Vector.<String> = Vector.<String>(["TrialCopy","StoryLevel","KillHero"]);
      
      public function CONST_SHINOBIDOPRACTISE()
      {
         super();
      }
   }
}

