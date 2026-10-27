package Resources.Constants
{
   import Processors.Game.Lobby.Activity.HDActivityOS.windows.*;
   import Processors.Game.Lobby.Activity.HDChineseYear.Windows.*;
   
   public class CONST_ACTIVITYWONDERFUL
   {
      
      public static const KEY_Activity_Vector:Vector.<uint> = Vector.<uint>([CONST_ACTIVITY_MODE.Activity_LevelRank,CONST_ACTIVITY_MODE.Activity_PowerRank,CONST_ACTIVITY_MODE.Activity_ArenaRank,CONST_ACTIVITY_MODE.Activity_KillHero,CONST_ACTIVITY_MODE.Activity_CampBattle,CONST_ACTIVITY_MODE.Activity_RecruitPartner]);
      
      public static const REFERENCE_Activity_Vector:Vector.<Class> = Vector.<Class>([TProcessorWindowHDLevelRank,TProcessorWindowHDPowerRank,TProcessorWindowHDArenaRank,TProcessorWindowHDKillHero,TProcessorWindowHDCampBattle,TProcessorWindowHDRecruitPartner,TProcessorWindowHDCompoundStone,TProcessorWindowHDEquipCollection,TProcessorWindowHDLevelSeat,TProcessorWindowHDLevelTailsman,TProcessorWindowHDCityDefence,TProcessorWindowHDGroupLv,TProcessorWindowHDGroupWar,TProcessorWindowHDPetSoulDefence]);
      
      public static const JmpWindowPositionAndLocation:Vector.<int> = Vector.<int>([-1,-1,-1,-1]);
      
      public static const KEY_ActivityChineseYear_Vector:Vector.<uint> = Vector.<uint>([CONST_ACTIVITY_MODE.Activity_ChineseYearSignIn,CONST_ACTIVITY_MODE.Activity_NewYear,CONST_ACTIVITY_MODE.Activity_ChineseYearLukia]);
      
      public static const REFERENCE_ActivityChineseYear_Vector:Vector.<Class> = Vector.<Class>([TProcessorHDWindowChineseYearSignIn,TProcessorHDWindowChineseLion,TProcessorWindowDoubleFish,TProcessorHDWindowLukia]);
      
      public function CONST_ACTIVITYWONDERFUL()
      {
         super();
      }
   }
}

