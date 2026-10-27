package Processors.Game.Lobby.Activity.HDActivityOS
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.Agent.SParametersCore;
   import Logics.HDActivityOS.*;
   import Logics.Streamization.HDActivityOS.*;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDTabWindows;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   
   public class TProcessorHDOS extends TProcessorHDTabWindows
   {
      
      protected static var TYPE_ActiveList_Wonderful:uint = CONST_SHORTCUTS.TYPE_ActiveList_Wonderful;
      
      public static const Activity_LevelRank:uint = CONST_ACTIVITY_MODE.Activity_LevelRank;
      
      public static const Activity_PowerRank:uint = CONST_ACTIVITY_MODE.Activity_PowerRank;
      
      public static const Activity_ArenaRank:uint = CONST_ACTIVITY_MODE.Activity_ArenaRank;
      
      public static const Activity_KillHero:uint = CONST_ACTIVITY_MODE.Activity_KillHero;
      
      public static const Activity_CampBattle:uint = CONST_ACTIVITY_MODE.Activity_CampBattle;
      
      public static const Activity_RecruitPartner:uint = CONST_ACTIVITY_MODE.Activity_RecruitPartner;
      
      public static const Activity_LevelSeat:uint = CONST_ACTIVITY_MODE.Activity_LevelSeat;
      
      public static const Activity_CompoundStone:uint = CONST_ACTIVITY_MODE.Activity_CompoundStone;
      
      public static const Activity_EquipCollection:uint = CONST_ACTIVITY_MODE.Activity_EquipCollection;
      
      public static const Activity_LevelTalisman:uint = CONST_ACTIVITY_MODE.Activity_LevelTalisman;
      
      public static const Activity_PetSoulDefence:uint = CONST_ACTIVITY_MODE.Activity_PetSoulDefence;
      
      public static const Activity_GroupLv:uint = CONST_ACTIVITY_MODE.Activity_GroupLv;
      
      public static const Activity_GroupWar:uint = CONST_ACTIVITY_MODE.Activity_GroupWar;
      
      public static const Activity_CityDefence:uint = CONST_ACTIVITY_MODE.Activity_CityDefence;
      
      protected var FUnstreamizerActivityOS:TUnstreamizerActivityOS;
      
      protected var FDataLevelRank:TActivityOSLevelRank;
      
      protected var FDataPowerRank:TActivityOSPowerRank;
      
      protected var FDataArenaRank:TActivityOSArenaRank;
      
      protected var FDataRecruitPartner:TActivityOSRecruitPartner;
      
      protected var FDataKillHero:TActivityOSKillHero;
      
      protected var FDataCampBattle:TActivityOSCampBattle;
      
      protected var FDataLevelSeat:TActivityOSLevelSeat;
      
      protected var FDataCompoundStone:TActivityOSCompoundStone;
      
      protected var FDataEquipCollection:TActivityOSEquipCollection;
      
      protected var FDataLevelTalisman:TActivityOSLevelTalisman;
      
      protected var FDataPetSoulDefence:TActivityOSPetSoulDefence;
      
      protected var FDataGroupLv:TActivityOSGroupLv;
      
      protected var FDataGroupWar:TActivityOSGroupWar;
      
      protected var FDataCityDefence:TActivityOSCityDefence;
      
      public function TProcessorHDOS(param1:TUIComponent, param2:TLobbyParameters = null)
      {
         super(param1,param2);
         if(false)
         {
            if(SParametersCore.IsCombine)
            {
               TYPE_ActiveList_Wonderful = CONST_SHORTCUTS.TYPE_ActiveList_CombineActivity;
            }
         }
         FTypeActivityList = TYPE_ActiveList_Wonderful;
         this.FUnstreamizerActivityOS = new TUnstreamizerActivityOS();
         FTabNum = TabNum;
         FBounsTabWindows = new TBounds();
         FBounsTabWindows.Width = SIZE_WIDTH_Activity;
         FBounsTabWindows.Height = SIZE_HIGHT_Activity;
         ComponentBoundsCenter(this,FBounsTabWindows);
         FBounsTabWindows = null;
         FMainBackGround = CONST_ACTIVITY.RESOURCE_ClassName_ActivityTabWindow;
      }
      
      override protected function ConstructActivity() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<Class> = null;
         var _loc4_:Class = null;
         super.ConstructActivity();
         _loc3_ = CONST_ACTIVITYWONDERFUL.REFERENCE_Activity_Vector;
         _loc2_ = int(_loc3_.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_[_loc1_];
            FActivities.push(new _loc4_(this));
            _loc1_++;
         }
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityMain);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

