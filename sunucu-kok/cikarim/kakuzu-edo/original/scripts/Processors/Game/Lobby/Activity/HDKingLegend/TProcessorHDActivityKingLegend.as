package Processors.Game.Lobby.Activity.HDKingLegend
{
   import Foundation.Common.*;
   import Foundation.Resources.*;
   import Foundation.Streamization.TUnstreamizer;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import Logics.DatebaseVO.VO.THDActivityBase;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDKingLegend.TActivityKingGuardData;
   import Logics.HDKingLegend.TActivityKingLegendData;
   import Logics.Inventories.TInventories;
   import Logics.Streamization.HDKingLegend.TUnstreamizerKingGuard;
   import Logics.Streamization.HDKingLegend.TUnstreamizerKingLegend;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Common.*;
   import Resources.Constants.*;
   import flash.utils.*;
   
   public class TProcessorHDActivityKingLegend extends TProcessorHDSingleWindowsBase
   {
      
      protected static const ActivitySecondIDS:Vector.<int> = Vector.<int>([CONST_ACTIVITY_MODE.Activity_KingLegend,CONST_ACTIVITY_MODE.Activity_KingGuard]);
      
      protected const WINDOW_WIDTH:int = 991;
      
      protected const WINDOW_HEIGHT:int = 601;
      
      protected var FResourceInited:Boolean;
      
      protected var FMainWindow:TProcessorHDWindowKingLegend;
      
      protected var FHDActivityConfigList:Vector.<THDActivityBase>;
      
      protected var FMyCustomDataList:Vector.<TActivityOSBase>;
      
      protected var FUnstreamizerList:Vector.<Object>;
      
      protected var FActivitySwitch:Vector.<Boolean>;
      
      protected var FCurrentShowActivityIndex:int;
      
      protected var FInitRecord:Vector.<Boolean>;
      
      public function TProcessorHDActivityKingLegend(param1:TUIComponent, param2:TLobbyParameters = null)
      {
         super(param1,param2);
      }
      
      override protected function ResourcesPerform_UIRequest() : void
      {
         super.ResourcesPerform_UIRequest();
         SResourcesCore.TexturesSwfLobby.LoadPrimary(CONST_ACTIVITY.RESOURCESID_KingLegeng);
      }
      
      override protected function InitWindows() : void
      {
         var _loc1_:TBounds = null;
         var _loc2_:int = 0;
         super.InitWindows();
         _loc2_ = int(ActivitySecondIDS.length);
         this.FActivitySwitch = new Vector.<Boolean>(length);
         this.FHDActivityConfigList = new Vector.<THDActivityBase>(length);
         this.FMyCustomDataList = new Vector.<TActivityOSBase>();
         this.FUnstreamizerList = new Vector.<Object>();
         this.FMyCustomDataList.push(new TActivityKingLegendData(),new TActivityKingGuardData());
         this.FUnstreamizerList.push(new TUnstreamizerKingLegend(),new TUnstreamizerKingGuard());
         this.FMainWindow = new TProcessorHDWindowKingLegend(this);
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
         var _loc4_:int = 0;
         var _loc5_:TUnstreamizer = null;
         var _loc6_:int = 0;
         var _loc7_:TActivityAtoms = null;
         super.ProcessorSCInitWindow(param1,param2);
         if(!this.FResourceInited)
         {
            return;
         }
         FActivityInitRetData = FUnstreamizerActivity.UnstreamizationPerform_Activity(param2,null);
         _loc6_ = int(ActivitySecondIDS.length);
         _loc3_ = 0;
         while(_loc3_ < _loc6_)
         {
            _loc7_ = GetAtomsByActivityID(ActivitySecondIDS[_loc3_]);
            this.FActivitySwitch[_loc3_] = _loc7_ != null;
            _loc3_++;
         }
         this.InitActivityData();
         _loc6_ = int(ActivitySecondIDS.length);
         _loc3_ = 0;
         while(_loc3_ < _loc6_)
         {
            _loc7_ = GetAtomsByActivityID(ActivitySecondIDS[_loc3_]);
            if(_loc7_ != null && _loc7_.Identifier == param1.Identifier)
            {
               this.FInitRecord[_loc3_] = true;
               break;
            }
            _loc3_++;
         }
         this.FUnstreamizerList[this.FCurrentShowActivityIndex].UnstreamizeInitActivity(FActivityInitRetData,this.FMyCustomDataList[this.FCurrentShowActivityIndex],this.FHDActivityConfigList[this.FCurrentShowActivityIndex]);
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
         if((Boolean(_loc4_)) && _loc4_.Identifier != param1.ID)
         {
            return;
         }
         if(this.FInitRecord[this.FCurrentShowActivityIndex])
         {
            this.FUnstreamizerList[this.FCurrentShowActivityIndex].UnstreamizeUpdateActivity(param1,this.FMyCustomDataList[this.FCurrentShowActivityIndex],this.FHDActivityConfigList[this.FCurrentShowActivityIndex]);
            this.FMainWindow.Show(this.GetCurActivityAtoms(),this.FHDActivityConfigList[this.FCurrentShowActivityIndex],this.FMyCustomDataList[this.FCurrentShowActivityIndex]);
            this.FMainWindow.UpdataData(this.FCurrentShowActivityIndex,param1.Index);
         }
      }
      
      protected function InitActivityData() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TActivityAtoms = null;
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_KingLegend);
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
         var _loc2_:int = 0;
         FActivityAtomsVect = FActivityModes.GetActivityAtomsByMainType(CONST_SHORTCUTS.TYPE_ActiveList_KingLegend);
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
      
      public function set OnCreateKnifeOfKillSoulData(param1:Function) : void
      {
         this.FMainWindow.OnCreateKnifeOfKillSoulData = param1;
      }
      
      override public function OperateRet(param1:Vector.<TFixedAward>) : void
      {
      }
   }
}

