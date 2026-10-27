package Processors.Game.Lobby.Activity.HDSoulBox
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.HDActivityMode.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDSoulBox extends TProcessorHDTabWindows
   {
      
      public function TProcessorHDSoulBox(param1:TUIComponent, param2:TLobbyParameters = null)
      {
         super(param1,param2);
         FTypeActivityList = CONST_SHORTCUTS.TYPE_ActiveList_SoulBox;
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
         var _loc5_:THDOSTabWindowBase = null;
         super.ConstructActivity();
         _loc3_ = CONST_ACTIVITYRECHARGE.REFERENCE_SoulBox_Vector;
         _loc2_ = int(_loc3_.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = _loc3_[_loc1_];
            _loc5_ = new _loc4_(this);
            _loc5_.UpdateStatus = this.UpdateActivityStatus;
            FActivities.push(_loc5_);
            _loc1_++;
         }
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityMain);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
      }
      
      override protected function UpdateActivityStatus(param1:uint, param2:int) : void
      {
         var _loc3_:TActivityAtoms = null;
         _loc3_ = FActivityModes.GetActivityAtomsByIdentifier(param1);
         _loc3_.Status = param2;
         if(FEffectNotification != null)
         {
            FEffectNotification(this,FTypeActivityList);
         }
      }
      
      override protected function UpdateTabs() : void
      {
         super.UpdateTabs();
      }
      
      override protected function UpdateTabStatusNotification() : void
      {
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         super.Mount(param1);
      }
      
      override public function Unmount() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THDOSTabWindowBase = null;
         super.Unmount();
         _loc2_ = int(FActivities.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = FActivities[_loc1_];
            _loc3_.Hide();
            _loc1_++;
         }
      }
   }
}

