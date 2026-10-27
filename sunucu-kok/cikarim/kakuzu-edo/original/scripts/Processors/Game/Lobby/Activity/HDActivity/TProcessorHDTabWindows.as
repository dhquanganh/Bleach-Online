package Processors.Game.Lobby.Activity.HDActivity
{
   import Components.Pages.*;
   import Components.Standard.*;
   import Foundation.Common.*;
   import Foundation.UI.*;
   import Foundation.Utilities.*;
   import Logics.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.Streamization.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Processors.Game.Utilities.OverLayer.*;
   import Rendering.Overlayers.HDGiftBox.*;
   import Resources.Constants.*;
   import Utilities.UI.Overlayers.*;
   import flash.display.*;
   import flash.events.*;
   import flash.text.*;
   import flash.utils.*;
   
   public class TProcessorHDTabWindows extends TProcessorLobbyWindows
   {
      
      protected static const SIZE_WIDTH_Activity:uint = 736;
      
      protected static const SIZE_HIGHT_Activity:uint = 540;
      
      protected static const STATUS_Tab_CanGet:uint = 1;
      
      protected static const STATUS_Tab_AlreadyGet:uint = 2;
      
      public static const CATEGORY_Equipment:uint = CONST_INVENTORY.CATEGORY_Equipment;
      
      public static const CATEGORY_Treasure:uint = CONST_INVENTORY.CATEGORY_Treasure;
      
      protected static const TabNum:int = 9;
      
      protected static const POSITION_ActiveList:uint = CONST_SHORTCUTS.POSITION_ActiveList;
      
      protected static const Activity_CanNotReceive:int = CONST_ACTIVITY_MODE.Activity_CanNotReceive;
      
      protected static const Activity_AlreadyReceive:int = CONST_ACTIVITY_MODE.Activity_AlreadyReceive;
      
      protected static const Activity_CanReceive:int = CONST_ACTIVITY_MODE.Activity_CanReceive;
      
      protected var FMC_MainScene:Sprite;
      
      protected var FMC_WindowMountPoint:Sprite;
      
      protected var FUITab:TUITab;
      
      protected var FUIPage:TUIPage;
      
      protected var FBtn_Close:SimpleButton;
      
      protected var FBtn_Help:SimpleButton;
      
      protected var FTF_Title:TextField;
      
      protected var FMC_TabPage:Sprite;
      
      protected var FTF_Page:TextField;
      
      protected var FPageIndex:int;
      
      protected var FTabIndex:int;
      
      protected var FCurrentShowActivityWindowStore:THDOSTabWindowBase;
      
      protected var FGiftOverLayer:TOverlayerGiftBox;
      
      protected var FGiftBoxTipData:TGiftBoxTipData;
      
      protected var FActivityModes:TActivityModes;
      
      protected var FActivityAtomsVect:Vector.<TActivityAtoms>;
      
      protected var FActivities:Vector.<THDOSTabWindowBase>;
      
      protected var FBounsTabWindows:TBounds;
      
      protected var FTabNum:uint;
      
      protected var FNeedPage:Boolean;
      
      protected var FInitWindow:Boolean;
      
      protected var FMainBackGround:String;
      
      protected var FActivityInitRetData:TActivityInitRetData;
      
      protected var FUnstreamizerActivity:TUnstreamizerActivity;
      
      protected var FGetActivityConfig:Function;
      
      protected var FCheckEffectNotification:Function;
      
      protected var FEffectNotification:Function;
      
      protected var FOnLookInfo:Function;
      
      protected var FTypeActivityList:uint;
      
      public function TProcessorHDTabWindows(param1:TUIComponent, param2:TLobbyParameters = null)
      {
         super(param1,param2);
         this.FActivityModes = SLogicsCore.ActivityModes;
         this.FActivityAtomsVect = new Vector.<TActivityAtoms>();
         this.FUnstreamizerActivity = new TUnstreamizerActivity();
         this.FActivities = new Vector.<THDOSTabWindowBase>();
         this.ConstructActivity();
         this.FTabIndex = -1;
         this.FPageIndex = 0;
         this.FGiftBoxTipData = new TGiftBoxTipData();
      }
      
      protected function ConstructActivity() : void
      {
      }
      
      override protected function ResourcesPerform_UIDispatch() : void
      {
         this.InitWindowResources();
         this.FGiftOverLayer = new TOverlayerGiftBox(this.Parent);
         this.FGiftOverLayer.visible = false;
         TUtilityUIOverlayer.ResourcesDispatch(this.FGiftOverLayer);
         super.ResourcesPerform_UIDispatch();
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.FActivities != null)
         {
            if(this.FActivities[0].ResourcesReady && this.FInitWindow)
            {
               this.UpdateActivityAtoms();
               this.Visible = true;
               this.FInitWindow = false;
            }
         }
      }
      
      override protected function ResourcesPerform_UILocations() : void
      {
         super.ResourcesPerform_UILocations();
         if(this.FBtn_Close == null)
         {
            return;
         }
         this.FBtn_Close.addEventListener(MouseEvent.CLICK,this.OnCloseWindowHandler,false,0,true);
      }
      
      protected function InitWindowResources() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:THDOSTabWindowBase = null;
         this.FMC_MainScene = TUtilityReflection.CreateDisplayObjectInstance(this.FMainBackGround) as Sprite;
         addChild(this.FMC_MainScene);
         this.FMC_WindowMountPoint = this.FMC_MainScene[CONST_ACTIVITY.RESOURCE_Link_MC_ActivityInner];
         this.FBtn_Help = this.FMC_MainScene[CONST_ACTIVITY.RESOURCE_Link_BTN_Help];
         this.FBtn_Close = this.FMC_MainScene[CONST_ACTIVITY.RESOURCE_Link_BTN_Close];
         this.FTF_Title = this.FMC_MainScene[CONST_ACTIVITY.RESOURCE_Link_TF_Title];
         if(this.FTF_Title != null)
         {
            this.FTF_Title.mouseEnabled = false;
            this.FTF_Title.text = "";
         }
         this.FUITab = new TUITab(this);
         _loc2_ = int(this.FTabNum);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FMC_MainScene[CONST_ACTIVITY.RESOURCE_Link_BTN_Tabs + _loc1_];
            if(_loc3_.MC_Status != null)
            {
               MovieClip(_loc3_.MC_Status).gotoAndStop(STATUS_Tab_CanGet);
               MovieClip(_loc3_.MC_Status).visible = false;
            }
            this.FUITab.SetTabByIndex(_loc3_,_loc1_);
            this.FUITab.SetTabCaptionByIndex("",_loc1_);
            _loc1_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         this.FUIPage = new TUIPage(this);
         this.FMC_TabPage = this.FMC_MainScene[CONST_ACTIVITY.RESOURCE_Link_MC_TabPage];
         if(this.FMC_TabPage != null)
         {
            this.FUIPage.ButtonPrevious.Substrate = this.FMC_TabPage[CONST_ACTIVITY.RESOURCE_Link_BTN_Left];
            this.FUIPage.ButtonNext.Substrate = this.FMC_TabPage[CONST_ACTIVITY.RESOURCE_Link_BTN_Right];
            this.FTF_Page = this.FMC_TabPage[CONST_ACTIVITY.RESOURCE_Link_TF_Page];
            this.FUIPage.LabelPage = this.FTF_Page;
            this.FUIPage.PageSize = this.FTabNum;
            this.FUIPage.OnChangePage = this.TabPageOnChange;
            this.FUIPage.Init();
            this.FNeedPage = true;
         }
         _loc2_ = int(this.FActivities.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FActivities[_loc1_];
            this.InitSingleActivity(_loc4_);
            _loc4_.visible = false;
            _loc1_++;
         }
      }
      
      protected function InitSingleActivity(param1:THDOSTabWindowBase) : void
      {
         param1.OnEffectText = ProcessorsOnEffectText;
         param1.OnHintOver = this.UIComponentsOnOver;
         param1.OnHintOut = this.UIComponentsOnOut;
         param1.OnSlotOver = this.UIComponentsHintOnOver;
         param1.OnSlotOut = this.UIComponentsHintOnOut;
         param1.GetActivityConfig = this.FGetActivityConfig;
         param1.UpdateStatus = this.UpdateActivityStatus;
         param1.OnLookInfo = this.ProcessorActivityOnLookInfo;
         param1.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         param1.OnGiftBoxOut = this.ProcessorOnGiftBoxOut;
         if(this.FMC_WindowMountPoint != null)
         {
            this.FMC_WindowMountPoint.addChild(param1);
         }
      }
      
      protected function UpdateTabs() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.FUITab.Count <= 0)
         {
            return;
         }
         _loc2_ = int(this.FTabNum);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FPageIndex * this.FTabNum + _loc1_;
            if(_loc3_ < this.FActivityAtomsVect.length)
            {
               this.FUITab.SetTabCaptionByIndex(this.FActivityAtomsVect[_loc3_].ActivityName,_loc1_);
               this.FUITab.SetTabShowByIndex(_loc1_);
            }
            else
            {
               this.FUITab.SetTabHideByIndex(_loc1_);
            }
            _loc1_++;
         }
         this.FUITab.Reset();
         if(this.FNeedPage)
         {
            this.UpdateUIPage();
         }
      }
      
      protected function UpdateUIPage() : void
      {
         this.FUIPage.TotalQuantity = this.FActivityAtomsVect.length;
         this.FUIPage.PageIndex = this.FPageIndex;
         this.FUIPage.Update();
      }
      
      protected function UpdateTabStatusNotification() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = int(this.FTabNum);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FTabNum * this.FPageIndex + _loc1_;
            if(_loc4_ >= this.FActivityAtomsVect.length)
            {
               break;
            }
            _loc3_ = this.FActivityAtomsVect[_loc4_].Status;
            if(_loc3_ == Activity_CanNotReceive)
            {
               this.FUITab.GetTabByIndex(_loc1_).MC_Status.visible = false;
            }
            else if(_loc3_ == Activity_AlreadyReceive)
            {
               this.FUITab.GetTabByIndex(_loc1_).MC_Status.visible = true;
               this.FUITab.GetTabByIndex(_loc1_).MC_Status.gotoAndStop(2);
            }
            else if(_loc3_ >= Activity_CanReceive)
            {
               this.FUITab.GetTabByIndex(_loc1_).MC_Status.visible = true;
               this.FUITab.GetTabByIndex(_loc1_).MC_Status.gotoAndStop(1);
            }
            _loc1_++;
         }
      }
      
      protected function UpdateActivityStatus(param1:uint, param2:int) : void
      {
         this.FActivityModes.GetActivityAtomsByIdentifier(param1).Status = param2;
         if(this.Visible)
         {
            this.UpdateTabs();
            this.UpdateTabStatusNotification();
         }
         if(this.FEffectNotification != null)
         {
            this.FEffectNotification(this,this.FTypeActivityList);
         }
      }
      
      protected function ProcessorActivityOnLookInfo(param1:Object, param2:uint, param3:uint) : void
      {
         if(this.FOnLookInfo != null)
         {
            this.FOnLookInfo(param1,param2,param3);
         }
      }
      
      protected function ProcessorOnGiftBoxMove(param1:Object, param2:Object, param3:Object = null) : void
      {
      }
      
      protected function ProcessorOnGiftBoxOut(param1:Object) : void
      {
         this.FGiftOverLayer.Hide();
      }
      
      protected function GetIndexByActivityAtoms(param1:uint) : uint
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = int(this.FActivityAtomsVect.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FActivityAtomsVect[_loc2_].Identifier == param1)
            {
               _loc4_ = _loc2_;
               break;
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      protected function GetActivityByActivityID(param1:uint) : THDOSTabWindowBase
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:THDOSTabWindowBase = null;
         _loc3_ = int(this.FActivities.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FActivities[_loc2_].ActivityID == param1)
            {
               _loc4_ = this.FActivities[_loc2_];
            }
            _loc2_++;
         }
         return _loc4_;
      }
      
      protected function UpdateActivityAtoms() : void
      {
         this.FActivityAtomsVect = this.FActivityModes.GetActivityAtomsByMainType(this.FTypeActivityList);
         if(this.FActivityAtomsVect.length <= 0)
         {
            ProcessorClose();
            return;
         }
         this.UpdateTabStatusNotification();
         this.TabOnSwitch(0);
         this.UpdateTabs();
      }
      
      protected function SortOnAtoms() : void
      {
      }
      
      protected function Clear() : void
      {
      }
      
      protected function WindowUpdateActivityChangeState(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         var _loc3_:THDOSTabWindowBase = null;
         _loc3_ = this.GetActivityByActivityID(param1.ActivityID);
         _loc3_.ChangeActivityStatus(param1,param2);
      }
      
      protected function WindowActivitiesInitRet(param1:TActivityAtoms, param2:ByteArray) : void
      {
         var _loc3_:THDOSTabWindowBase = null;
         if(this.Visible)
         {
            _loc3_ = this.GetActivityByActivityID(param1.ActivityID);
            _loc3_.ActivityInitRet(param2,param1);
         }
         else
         {
            this.FActivityInitRetData = this.FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
            this.ProcessorUpdateWithoutVisible(param1);
         }
      }
      
      protected function ProcessorUpdateWithoutVisible(param1:TActivityAtoms) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FActivityInitRetData.AwardStates.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FActivityInitRetData.AwardStates[_loc2_].State >= Activity_CanReceive)
            {
               param1.Status = Activity_CanReceive;
               break;
            }
            _loc2_++;
         }
         this.UpdateActivityStatus(param1.Identifier,param1.Status);
      }
      
      protected function WindowValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         var _loc3_:THDOSTabWindowBase = null;
         _loc3_ = this.GetActivityByActivityID(param1.ActivityID);
         _loc3_.ChangeValue(param1,param2);
      }
      
      protected function WindowOperateRet(param1:TActivityAtoms) : void
      {
         var _loc2_:THDOSTabWindowBase = null;
         _loc2_ = this.GetActivityByActivityID(param1.ActivityID);
         _loc2_.OperateRet();
      }
      
      protected function TabOnSwitch(param1:Object) : void
      {
         var _loc2_:TActivityAtoms = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc6_ = uint(param1 as int);
         if(_loc6_ == this.FTabIndex)
         {
            return;
         }
         this.FTabIndex = _loc6_;
         _loc4_ = this.FPageIndex * this.FTabNum + this.FTabIndex;
         if(_loc4_ >= this.FActivityAtomsVect.length)
         {
            _loc4_ = 0;
            this.FPageIndex = 0;
            this.FTabIndex = 0;
            if(this.FNeedPage)
            {
               this.TabPageOnChange(this,this.FPageIndex);
            }
         }
         _loc2_ = this.FActivityAtomsVect[_loc4_];
         if(this.FCurrentShowActivityWindowStore != null)
         {
            this.FCurrentShowActivityWindowStore.Hide();
         }
         _loc3_ = int(this.GetIndexByActivityAtoms(_loc2_.Identifier));
         if(_loc3_ == -1)
         {
            return;
         }
         this.FCurrentShowActivityWindowStore = this.GetActivityByActivityID(_loc2_.ActivityID);
         this.FCurrentShowActivityWindowStore.ActivityID = _loc2_.ActivityID;
         this.FCurrentShowActivityWindowStore.Show(_loc2_);
      }
      
      protected function TabPageOnChange(param1:Object, param2:int) : void
      {
         this.FPageIndex = param2;
         this.UpdateTabs();
         this.UpdateTabStatusNotification();
      }
      
      protected function OnCloseWindowHandler(param1:MouseEvent) : void
      {
         ProcessorClose();
      }
      
      protected function UIComponentsHintOnOver(param1:Object) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,param1);
      }
      
      protected function UIComponentsHintOnOut(param1:Object) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,param1);
      }
      
      protected function UIComponentsOnOver(param1:Object, param2:THint) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOver(this,param2);
      }
      
      protected function UIComponentsOnOut(param1:Object, param2:THint) : void
      {
         SUtilityOverLayer.UIComponentsHintOnOut(this,param2);
      }
      
      public function get GetActivityConfig() : Function
      {
         return this.FGetActivityConfig;
      }
      
      public function set GetActivityConfig(param1:Function) : void
      {
         this.FGetActivityConfig = param1;
      }
      
      public function get CheckEffectNotification() : Function
      {
         return this.FCheckEffectNotification;
      }
      
      public function set CheckEffectNotification(param1:Function) : void
      {
         this.FCheckEffectNotification = param1;
      }
      
      public function set TypeActivityList(param1:uint) : void
      {
         this.FTypeActivityList = param1;
      }
      
      public function get EffectNotification() : Function
      {
         return this.FEffectNotification;
      }
      
      public function set EffectNotification(param1:Function) : void
      {
         this.FEffectNotification = param1;
      }
      
      public function get OnLookInfo() : Function
      {
         return this.FOnLookInfo;
      }
      
      public function set OnLookInfo(param1:Function) : void
      {
         this.FOnLookInfo = param1;
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            _loc3_ = int(this.FActivities.length);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.FActivities[_loc2_].Load();
               _loc2_++;
            }
            return;
         }
         this.FInitWindow = true;
      }
      
      override public function Unmount() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:THDOSTabWindowBase = null;
         super.Unmount();
         this.Visible = false;
         this.FTabIndex = -1;
         this.FUITab.TabIndex = 0;
         this.FPageIndex = 0;
         this.FInitWindow = false;
      }
      
      public function UpDateActivityAtoms() : void
      {
         if(this.Visible)
         {
            this.UpdateActivityAtoms();
         }
         else if(this.FEffectNotification != null)
         {
            this.FEffectNotification(this,this.FTypeActivityList);
         }
      }
      
      public function UpdateActivityChangeState(param1:TActivityAtoms, param2:TActAwardStatusInfo) : void
      {
         if(!this.Visible)
         {
            if(param2.Status >= Activity_CanReceive)
            {
               this.UpdateActivityStatus(param1.Identifier,param2.Status);
            }
            return;
         }
         this.WindowUpdateActivityChangeState(param1,param2);
      }
      
      public function ActivitiesInitRet(param1:TActivityAtoms, param2:ByteArray) : void
      {
         this.WindowActivitiesInitRet(param1,param2);
      }
      
      public function ValuesChange(param1:TActivityAtoms, param2:Vector.<int>) : void
      {
         this.WindowValuesChange(param1,param2);
      }
      
      public function OperateRet(param1:Vector.<TFixedAward>) : void
      {
      }
   }
}

