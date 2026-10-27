package Processors.Game.Lobby.Activity.HDRechargeSuit
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDTabWindows;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   
   public class TProcessorHDRechargeSuit extends TProcessorHDTabWindows
   {
      
      public function TProcessorHDRechargeSuit(param1:TUIComponent, param2:TLobbyParameters = null)
      {
         super(param1,param2);
         FTypeActivityList = CONST_SHORTCUTS.TYPE_ActiveList_RechargeCommon_2;
         FTabNum = TabNum;
         FBounsTabWindows = new TBounds();
         FBounsTabWindows.Width = SIZE_WIDTH_Activity;
         FBounsTabWindows.Height = SIZE_HIGHT_Activity;
         ComponentBoundsCenter(this,FBounsTabWindows);
         FMainBackGround = CONST_ACTIVITY.RESOURCE_ClassName_ActivityTabWindow;
      }
      
      override protected function ConstructActivity() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<Class> = null;
         var _loc4_:Class = null;
         super.ConstructActivity();
         _loc3_ = CONST_ACTIVITYRECHARGE.REFERENCE_ACTIVITYRECHARGESUIT_Vector;
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
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityRecharge);
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityRechargeCommon);
      }
   }
}

