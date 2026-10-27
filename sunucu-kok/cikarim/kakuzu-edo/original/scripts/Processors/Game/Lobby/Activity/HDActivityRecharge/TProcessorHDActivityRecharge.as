package Processors.Game.Lobby.Activity.HDActivityRecharge
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.UI.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityRecharge.*;
   import Logics.Streamization.HDActivityRecharge.*;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDActivityRecharge.windows.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDActivityRecharge extends TProcessorHDTabWindows
   {
      
      protected static const TYPE_ActiveList_Recharge:uint = CONST_SHORTCUTS.TYPE_ActiveList_Recharge;
      
      protected var FDailyCostData:THDDailyCostData;
      
      protected var FDailyPayData:THDDailyPayData;
      
      protected var FSinglePayData:THDSinglePayData;
      
      protected var FTotalCostData:THDTotalCostData;
      
      protected var FTotalPayData:THDTotalPayData;
      
      protected var FVipBoxData:THDVipBoxData;
      
      protected var FDailyTotalPay:THDDailyTotalPayData;
      
      protected var FDailyTotalCost:THDDailyTotalCostData;
      
      protected var FUnstreamizerActivityRecharge:TUnstreamizerActivityRecharge;
      
      protected var FOnBuyMilitary:Function;
      
      protected var FOnFirstPayRet:Function;
      
      protected var FOnChangeFirstPayState:Function;
      
      protected var FOnChangeCostState:Function;
      
      protected var FOnCNMFun:Function;
      
      public function TProcessorHDActivityRecharge(param1:TUIComponent, param2:TLobbyParameters = null)
      {
         super(param1,param2);
         FTypeActivityList = TYPE_ActiveList_Recharge;
         this.FDailyCostData = new THDDailyCostData();
         this.FDailyPayData = new THDDailyPayData();
         this.FSinglePayData = new THDSinglePayData();
         this.FTotalCostData = new THDTotalCostData();
         this.FTotalPayData = new THDTotalPayData();
         this.FVipBoxData = new THDVipBoxData();
         this.FDailyTotalPay = new THDDailyTotalPayData();
         this.FDailyTotalCost = new THDDailyTotalCostData();
         this.FUnstreamizerActivityRecharge = new TUnstreamizerActivityRecharge();
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
         _loc3_ = CONST_ACTIVITYRECHARGE.REFERENCE_ACTIVITYRECHARGE_Vector;
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
      
      protected function OnUpdateTabState(param1:uint, param2:int) : void
      {
         FActivityModes.GetActivityAtomsByActivityID(param1).Status = param2;
         if(this.Visible)
         {
            UpdateTabStatusNotification();
         }
         if(FEffectNotification != null)
         {
            FEffectNotification(this,FTypeActivityList);
         }
      }
      
      override protected function InitSingleActivity(param1:THDOSTabWindowBase) : void
      {
         var _loc2_:TProcessorWindowHDDailyCost = null;
         var _loc3_:TProcessorWindowHDDailyPay = null;
         var _loc4_:TProcessorWindowHDDailyTotaleCost = null;
         var _loc5_:TProcessorWindowHDDailyTotalePay = null;
         super.InitSingleActivity(param1);
         param1.OnClose = this.OnCloseWindow;
         if(param1 is TProcessorWindowHDDailyCost)
         {
            _loc2_ = param1 as TProcessorWindowHDDailyCost;
            _loc2_.OnBuyMilitary = this.FOnBuyMilitary;
            _loc2_.OnUpdateTabState = this.OnUpdateTabState;
         }
         if(param1 is TProcessorWindowHDDailyPay)
         {
            _loc3_ = param1 as TProcessorWindowHDDailyPay;
            _loc3_.OnUpdateTabState = this.OnUpdateTabState;
         }
         if(param1 is TProcessorWindowHDDailyTotaleCost)
         {
            _loc4_ = param1 as TProcessorWindowHDDailyTotaleCost;
            _loc4_.OnUpdateTabState = this.OnUpdateTabState;
         }
         if(param1 is TProcessorWindowHDDailyTotalePay)
         {
            _loc5_ = param1 as TProcessorWindowHDDailyTotalePay;
            _loc5_.OnUpdateTabState = this.OnUpdateTabState;
         }
      }
      
      protected function OnCloseWindow(param1:Object) : void
      {
         ProcessorClose();
      }
      
      override protected function UpdateActivityAtoms() : void
      {
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_Recharge);
         super.UpdateActivityAtoms();
      }
      
      public function set OnBuyMilitary(param1:Function) : void
      {
         this.FOnBuyMilitary = param1;
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
      
      override public function UpDateActivityAtoms() : void
      {
         super.UpDateActivityAtoms();
      }
   }
}

