package Processors.Game.Lobby.Activity.HDActivityFund
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.*;
   import Logics.Characters.*;
   import Logics.HDActivityFund.*;
   import Logics.HDActivityMode.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDActivityFund extends TProcessorHDTabWindows
   {
      
      protected var FFundLevelData:THDFundLvData;
      
      protected var FCharacter:TCharacter;
      
      public function TProcessorHDActivityFund(param1:TUIComponent, param2:TLobbyParameters = null)
      {
         super(param1,param2);
         FTypeActivityList = CONST_SHORTCUTS.TYPE_ActiveList_Fund;
         this.FFundLevelData = new THDFundLvData();
         this.FCharacter = SLogicsCore.Character;
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
         _loc3_ = CONST_ACTIVITYFUND.REFERENCE_ACTIVITY_Vector;
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
      
      override protected function UpdateActivityStatus(param1:uint, param2:int) : void
      {
         var _loc3_:TActivityAtoms = null;
         _loc3_ = FActivityModes.GetActivityAtomsByIdentifier(param1);
         _loc3_.Status = param2;
         if(this.Visible)
         {
            UpdateTabStatusNotification();
         }
         if(FEffectNotification != null)
         {
            FEffectNotification(this,FTypeActivityList);
         }
      }
      
      protected function CheckFundLevelCanBuy() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:TFundLvAwardData = null;
         _loc1_ = this.FCharacter.GetMainLevel();
         _loc3_ = this.FFundLevelData.CountForAward();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.FFundLevelData.GetAwardByIndex(_loc2_);
            if(_loc4_.Level <= _loc1_ && _loc4_.State != CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         super.Mount(param1);
      }
      
      override public function Unmount() : void
      {
         super.Unmount();
      }
      
      public function CheckFundLevel() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:TActivityAtoms = null;
         _loc2_ = SLogicsCore.ActivityModes.GetActivityAtomsByActivityID(CONST_ACTIVITY_MODE.Activity_FundLv);
         _loc1_ = this.CheckFundLevelCanBuy();
         if(_loc1_)
         {
            _loc2_.Status = CONST_ACTIVITY_MODE.Activity_CanReceive;
         }
         else
         {
            _loc2_.Status = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
         }
         if(FEffectNotification != null)
         {
            FEffectNotification(this,FTypeActivityList);
         }
      }
   }
}

