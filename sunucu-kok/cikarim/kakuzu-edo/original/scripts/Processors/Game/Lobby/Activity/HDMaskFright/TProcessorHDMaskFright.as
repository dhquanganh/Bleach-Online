package Processors.Game.Lobby.Activity.HDMaskFright
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.HDActivityMode.*;
   import Logics.Inventories.*;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDTabWindows;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Lobby.Utilities.*;
   import Rendering.Overlayers.HDGiftBox.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDMaskFright extends TProcessorHDTabWindows
   {
      
      protected static const BACKGROUND_WIDTH:uint = 638;
      
      protected static const BACKGROUND_HIGHT:uint = 525;
      
      protected static const TAB_NUM:uint = 6;
      
      public function TProcessorHDMaskFright(param1:TUIComponent, param2:TLobbyParameters = null)
      {
         super(param1,param2);
         FTypeActivityList = CONST_SHORTCUTS.TYPE_ActiveList_MaskFright;
         FTabNum = TAB_NUM;
         FBounsTabWindows = new TBounds();
         FBounsTabWindows.Width = BACKGROUND_WIDTH;
         FBounsTabWindows.Height = BACKGROUND_HIGHT;
         ComponentBoundsCenter(this,FBounsTabWindows);
         FBounsTabWindows = null;
         FMainBackGround = CONST_ACTIVITY.RESOURCE_ClassName_Main_ActivityHorizontalTab;
      }
      
      override protected function ConstructActivity() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<Class> = null;
         var _loc4_:Class = null;
         super.ConstructActivity();
         _loc3_ = CONST_ACTIVITYRECHARGE.REFERENCE_MaskFright_Vector;
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
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityBackground);
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
      
      override protected function UpdateTabStatusNotification() : void
      {
      }
      
      override protected function UpdateTabs() : void
      {
         super.UpdateTabs();
         FTF_Title.text = TUtilityLobby.GetStringByIdentifier(CONST_SYSTEMLANGUAGE.STRING_ACTIVITY_31);
      }
      
      override protected function ProcessorOnGiftBoxMove(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:TInventories = null;
         super.ProcessorOnGiftBoxMove(param1,param2);
         _loc4_ = param2 as TInventories;
         FGiftBoxTipData.TipReset();
         FGiftBoxTipData.NormalInventories = _loc4_;
         FGiftBoxTipData.AwardType = TOverlayerGiftBox.TYPE_ALL;
         FGiftBoxTipData.NeedColour = true;
         FGiftOverLayer.Context = FGiftBoxTipData;
         FGiftOverLayer.Render(FUICore.MouseCoordinate);
         FGiftOverLayer.Show();
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
   }
}

