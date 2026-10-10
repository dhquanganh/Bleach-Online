package Resources.Constants
{
   public class CONST_GONGFUFIGHT
   {
      
      public static var GroupsPlayerNum:Vector.<uint>;
      
      public static var GroupsSuperLevelPlayerNum:Vector.<uint>;
      
      public static const RESOURCESID_GongFuFight:uint = 2466250752;
      
      public static const RESOURCESID_GongFuFightWindow:uint = 2466250753;
      
      public static const RESOURCESID_GongFuFight_StoneShop:uint = 2466250754;
      
      public static const RESOURCESID_GongFuFight_TokenShop:uint = 2466250755;
      
      public static const RESOURCE_ClassName_SP_GongFuFight_StoneShop:String = "SP_GongFuFight_StoneShop";
      
      public static const RESOURCE_ClassName_SP_GongFuFight_TokenShop:String = "SP_GongFuFight_TokenShop";
      
      public static const CAPACITY_Tabs:uint = 3;
      
      public static var CAPACITY_Heros:uint = 3;
      
      public static const CAPACITY_Page_InventorySamples:uint = 12;
      
      public static const GroupLevelNames:Vector.<String> = Vector.<String>(["D","C","B","A","S","SS","SSS"]);
      
      public static const ApplyStatus_UnApply:uint = 0;
      
      public static const ApplyStatus_Applied:uint = 1;
      
      public static const PlayerState_CanChallenge:int = 0;
      
      public static const PlayerState_Killed:int = 1;
      
      public static const PlayerState_Safe:int = 2;
      
      public static const SeasonState_Close:uint = 0;
      
      public static const SeasonState_Open:uint = 1;
      
      public static const SeasonState_Rest:uint = 2;
      
      public static var GongFuFightState_NotFight:int = 0;
      
      public static var GongFuFightState_CanFight:int = 1;
      
      public static var GongFuFightState_Wait:int = 2;
      
      public static const GONGFUFIGHTMESSAGE_Apply:int = 0;
      
      public static const GONGFUFIGHTMESSAGE_RankRecord:int = 1;
      
      public static const GONGFUFIGHTMESSAGE_PayRecord:int = 2;
      
      public static const GONGFUFIGHTMESSAGE_Pay:int = 3;
      
      public static const RankViewID:int = 1;
      
      public static const PayViewID:int = 2;
      
      public static const ChallengeCardMallID:int = 3;
      
      public static const PeakStoneMallID:int = 4;
      
      public static const GongFuFightPlayerType_Normal:int = 0;
      
      public static const GongFuFightPlayerType_SuperLevel:int = 1;
      
      public static const GongFuFightLayerAwardStartID:int = 5001;
      
      public static const TokenID:uint = 14100282;
      
      public static const StoneID:uint = 14100283;
      
      public static const HellStoneID:uint = 14100733;
      
      public function CONST_GONGFUFIGHT()
      {
         super();
      }
   }
}

