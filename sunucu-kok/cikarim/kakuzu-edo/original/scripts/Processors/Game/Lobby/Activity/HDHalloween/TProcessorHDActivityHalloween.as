package Processors.Game.Lobby.Activity.HDHalloween
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.HDActivityHalloween.TActivityHalloweenExchangeData;
   import Logics.HDActivityHalloween.TActivityHalloweenPayData;
   import Logics.HDActivityHalloween.TActivityHalloweenPumpkinData;
   import Logics.HDActivityHalloween.TActivityHalloweenTreeData;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.HDActivityHalloween.TUnstreamizerHalloweenExchange;
   import Logics.Streamization.HDActivityHalloween.TUnstreamizerHalloweenPay;
   import Logics.Streamization.HDActivityHalloween.TUnstreamizerHalloweenPumpkin;
   import Logics.Streamization.HDActivityHalloween.TUnstreamizerHalloweenTree;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDActivityHalloween extends TProcessorHDSingleWindowsBase
   {
      
      protected static const ActivitySecondIDS:Vector.<int> = Vector.<int>([CONST_ACTIVITY_MODE.Activity_HalloweenPay,CONST_ACTIVITY_MODE.Activity_HalloweenTree,CONST_ACTIVITY_MODE.Activity_HalloweenPumpkin,CONST_ACTIVITY_MODE.Activity_HalloweenShop]);
      
      protected const WINDOW_WIDTH:int = 800;
      
      protected const WINDOW_HEIGHT:int = 600;
      
      protected var FResourceInited:Boolean;
      
      protected var FMainWindow:TProcessorHDWindowHalloween;
      
      protected var FHDActivityConfigList:Vector.<THDActivityBase>;
      
      protected var FMyCustomDataList:Vector.<TActivityOSBase>;
      
      protected var FUnstreamizerList:Vector.<Object>;
      
      protected var FOnLoadLog:Function;
      
      protected var FActivitySwitch:Vector.<Boolean>;
      
      protected var FCurrentShowActivityIndex:int;
      
      protected var FInitRecord:Vector.<Boolean>;
      
      public function TProcessorHDActivityHalloween(param1:TUIComponent, param2:TLobbyParameters = null)
      {
         super(param1,param2);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_ActivityHalloween);
      }
      
      override protected function InitWindows() : void
      {
         var _loc1_:TBounds = null;
         var _loc2_:int = 0;
         super.InitWindows();
         _loc2_ = int(ActivitySecondIDS.length);
         this.FActivitySwitch = new Vector.<Boolean>(_loc2_);
         this.FHDActivityConfigList = new Vector.<THDActivityBase>(_loc2_);
         this.FMyCustomDataList = new Vector.<TActivityOSBase>();
         this.FUnstreamizerList = new Vector.<Object>();
         this.FMyCustomDataList.push(new TActivityHalloweenPayData(),new TActivityHalloweenTreeData(),new TActivityHalloweenPumpkinData(),new TActivityHalloweenExchangeData());
         this.FUnstreamizerList.push(new TUnstreamizerHalloweenPay(),new TUnstreamizerHalloweenTree(),new TUnstreamizerHalloweenPumpkin(),new TUnstreamizerHalloweenExchange());
         this.FMainWindow = new TProcessorHDWindowHalloween(this);
         this.FMainWindow.OnClose = this.CloseWindowHandler;
         this.FMainWindow.OnGiftBoxMove = this.ProcessorOnGiftBoxMove;
         this.FMainWindow.OnGiftBoxOut = this.ProcessorOnGiftBoxOut;
         this.FMainWindow.OnSelectHDType = this.SelectHDTypeOnClick;
         _loc1_ = new TBounds();
         _loc1_.Width = this.WINDOW_WIDTH;
         _loc1_.Height = this.WINDOW_HEIGHT;
         ComponentBoundsCenter(this.FMainWindow,_loc1_);
         this.FInitRecord = new Vector.<Boolean>(ActivitySecondIDS.length);
         this.FResourceInited = true;
      }
      
      override protected function ProcessorSCInitWindow(param1:TActivityAtoms, param2:ByteArray) : void
      {
         var _loc3_:int = 0;
         var _loc4_:TUnstreamizer = null;
         var _loc5_:int = 0;
         var _loc6_:TActivityAtoms = null;
         super.ProcessorSCInitWindow(param1,param2);
         if(!this.FResourceInited)
         {
            return;
         }
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_HalloweenPay);
         _loc5_ = int(ActivitySecondIDS.length);
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc6_ = GetAtomsByActivityID(ActivitySecondIDS[_loc3_]);
            this.FActivitySwitch[_loc3_] = _loc6_ != null;
            _loc3_++;
         }
         this.InitActivityData();
         _loc5_ = int(ActivitySecondIDS.length);
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc6_ = GetAtomsByActivityID(ActivitySecondIDS[_loc3_]);
            if(_loc6_ != null && _loc6_.Identifier == param1.Identifier)
            {
               this.FInitRecord[_loc3_] = true;
               break;
            }
            _loc3_++;
         }
         this.FUnstreamizerList[_loc3_].UnstreamizeInitHalloween(FActivityInitRetData,this.FMyCustomDataList[_loc3_],this.FHDActivityConfigList[_loc3_]);
         if(!this.Visible)
         {
            return;
         }
         this.FMainWindow.Visible = true;
         this.FMainWindow.Show(this.GetCurActivityAtoms(),this.FHDActivityConfigList[this.FCurrentShowActivityIndex],this.FMyCustomDataList[this.FCurrentShowActivityIndex]);
         this.FMainWindow.SetHDTabState(this.FActivitySwitch);
      }
      
      override protected function ProcessorSCAwardStatusChangeNotify(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TActivityAtoms = null;
         super.ProcessorSCAwardStatusChangeNotify(param1);
         this.InitActivityData();
         _loc4_ = this.GetCurActivityAtoms();
         if(_loc4_.Identifier != param1.ID)
         {
            return;
         }
         _loc2_ = this.FCurrentShowActivityIndex;
         if(this.FInitRecord[_loc2_])
         {
            this.FUnstreamizerList[_loc2_].UnstreamizeUpdateHalloween(param1,this.FMyCustomDataList[_loc2_],this.FHDActivityConfigList[_loc2_]);
            if(_loc2_ == this.FCurrentShowActivityIndex)
            {
               this.FMainWindow.Show(this.GetCurActivityAtoms(),this.FHDActivityConfigList[_loc2_],this.FMyCustomDataList[_loc2_]);
            }
         }
      }
      
      protected function InitActivityData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActivityAtoms = null;
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_HalloweenPay);
         _loc2_ = int(ActivitySecondIDS.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = GetAtomsByActivityID(ActivitySecondIDS[_loc1_]);
            if(_loc3_ != null)
            {
               GetActivityConfigByActivityAtoms(_loc3_);
               this.FHDActivityConfigList[_loc1_] = FHDActivityConfig;
            }
            _loc1_++;
         }
      }
      
      override protected function ProcessorOnGiftBoxOut(param1:Object) : void
      {
         FGiftOverLayer.Hide();
      }
      
      override protected function ProcessorOnGiftBoxMove(param1:Object, param2:Object, param3:Object = null) : void
      {
         var _loc4_:TInventories = null;
         var _loc5_:int = 0;
         super.ProcessorOnGiftBoxMove(param1,param2,param3);
         if(param3 != null)
         {
            _loc5_ = param3 as int;
         }
         _loc4_ = param2 as TInventories;
         FGiftBoxTipData.TipReset();
         FGiftBoxTipData.NormalInventories = _loc4_;
         FGiftBoxTipData.AwardType = _loc5_;
         FGiftBoxTipData.NeedColour = true;
         FGiftOverLayer.Context = FGiftBoxTipData;
         FGiftOverLayer.Render(FUICore.MouseCoordinate);
         FGiftOverLayer.Show();
      }
      
      protected function RequestHDInfo() : void
      {
         var _loc1_:TActivityAtoms = null;
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_HalloweenPay);
         _loc1_ = this.GetCurActivityAtoms();
         Perform_CS_ActivityInitReq(_loc1_.Identifier);
      }
      
      private function GetCurActivityAtoms() : TActivityAtoms
      {
         var _loc1_:TActivityAtoms = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = ActivitySecondIDS[this.FCurrentShowActivityIndex];
         _loc4_ = int(FActivityAtomsVect.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(_loc2_ == FActivityAtomsVect[_loc3_].ActivityID)
            {
               _loc1_ = FActivityAtomsVect[_loc3_];
               break;
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      protected function CloseWindowHandler(param1:Object) : void
      {
         ProcessorClose();
      }
      
      protected function SelectHDTypeOnClick(param1:int) : void
      {
         this.FCurrentShowActivityIndex = param1;
         FActivityID = ActivitySecondIDS[param1];
         if(!this.FInitRecord[this.FCurrentShowActivityIndex])
         {
            this.RequestHDInfo();
         }
         else
         {
            this.FMainWindow.Show(this.GetCurActivityAtoms(),this.FHDActivityConfigList[this.FCurrentShowActivityIndex],this.FMyCustomDataList[this.FCurrentShowActivityIndex]);
         }
      }
      
      override public function Mount(param1:ByteArray = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TActivityAtoms = null;
         super.Mount(param1);
         if(!FIsResourcesLoadCompleted)
         {
            this.FMainWindow.Load();
            return;
         }
         this.InitActivityData();
         _loc3_ = int(ActivitySecondIDS.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = GetAtomsByActivityID(ActivitySecondIDS[_loc2_]);
            if(_loc4_ != null)
            {
               this.FCurrentShowActivityIndex = _loc2_;
               break;
            }
            _loc2_++;
         }
         this.FMainWindow.SetupTabCurrentShowIndex(this.FCurrentShowActivityIndex);
      }
      
      override public function Unmount() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super.Unmount();
         this.FMainWindow.visible = false;
         _loc2_ = int(this.FInitRecord.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FInitRecord[_loc1_] = false;
            _loc1_++;
         }
      }
      
      override public function OperateRet(param1:Vector.<TFixedAward>) : void
      {
         this.FMainWindow.OnOperatRet(param1);
      }
      
      public function set OnLoadLog(param1:Function) : void
      {
         this.FMainWindow.OnLoadLog = param1;
      }
   }
}

