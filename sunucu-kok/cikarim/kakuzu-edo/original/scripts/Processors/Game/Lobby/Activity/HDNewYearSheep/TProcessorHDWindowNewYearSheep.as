package Processors.Game.Lobby.Activity.HDNewYearSheep
{
   import Components.Standard.*;
   import Foundation.UI.*;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import Logics.HDActivityMode.*;
   import Logics.HDActivityOS.*;
   import Logics.HDNewYear.*;
   import Logics.HDNewYearSheep.TActivitySheepRedPacketData;
   import Logics.HDNewYearSheep.TFirecrackersData;
   import Logics.HDNewYearSheep.THDSheepGoodSellData;
   import Logics.HDNewYearSheep.TPetYearData;
   import Logics.Streamization.HDNewYear.*;
   import Logics.Streamization.HDNewYearSheep.TUnstreamizerFirecrackers;
   import Logics.Streamization.HDNewYearSheep.TUnstreamizerPetYear;
   import Logics.Streamization.HDNewYearSheep.TUnstreamizerRedPacket;
   import Logics.Streamization.HDNewYearSheep.TUnstreamizerSheepGoodSell;
   import Processors.Game.Lobby.Activity.HDActivity.*;
   import Processors.Game.Lobby.Activity.HDNewYearDay.windows.*;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TProcessorFirecrackersView;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TProcessorHDWindowSheepGoodSell;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TProcessorHDWindowSheepRedPacket;
   import Processors.Game.Lobby.Activity.HDNewYearSheep.HDWindow.TProcessorPetYearView;
   import Resources.Constants.*;
   import flash.display.*;
   import flash.events.*;
   import flash.utils.getDefinitionByName;
   
   public class TProcessorHDWindowNewYearSheep extends TProcessorHDSingleWindowBase
   {
      
      protected static var ActivityClassReference:Vector.<Class> = Vector.<Class>([TProcessorPetYearView,TProcessorHDWindowSheepRedPacket,TProcessorFirecrackersView,TProcessorHDWindowSheepGoodSell]);
      
      protected static var WindowUIName:Vector.<String> = Vector.<String>(["SheepNewYear1","SheepNewYear2","SheepNewYear3","SheepNewYear4"]);
      
      protected static var ActivitiesID:Vector.<int> = Vector.<int>([CONST_ACTIVITY_MODE.Activity_SheepPetYear,CONST_ACTIVITY_MODE.Activity_SheepRedPacket,CONST_ACTIVITY_MODE.Activity_SheepFirecrackers,CONST_ACTIVITY_MODE.Activity_SheepSellGood]);
      
      public static var ActivitiesDataReference:Vector.<Class> = Vector.<Class>([TPetYearData,TActivitySheepRedPacketData,TFirecrackersData,THDSheepGoodSellData]);
      
      public static var ActivitiesUnstreamizer:Vector.<Class> = Vector.<Class>([TUnstreamizerPetYear,TUnstreamizerRedPacket,TUnstreamizerFirecrackers,TUnstreamizerSheepGoodSell]);
      
      protected var TABNUM:int = 4;
      
      protected var FActivityWindows:Vector.<TProcessorHDSingleWindowBase>;
      
      protected var FUITab:TUITab;
      
      protected var FTabMarks:Vector.<Sprite>;
      
      protected var FActivitySwitch:Vector.<Boolean>;
      
      protected var FCurrentTabIndex:int;
      
      protected var FActivitiesUnstreamizers:Vector.<Object>;
      
      protected var FActivityDatas:Vector.<TActivityOSBase>;
      
      protected var FHDActivityConfigs:Vector.<THDActivityBase>;
      
      protected var FActivityAtomsVect:Vector.<TActivityAtoms>;
      
      public function TProcessorHDWindowNewYearSheep(param1:TUIComponent)
      {
         super(param1);
         if(false)
         {
            ActivityClassReference.splice(3,1);
            ActivityClassReference.splice(0,1);
            WindowUIName.splice(3,1);
            WindowUIName.splice(0,1);
            ActivitiesID.splice(3,1);
            ActivitiesID.splice(0,1);
            ActivitiesDataReference.splice(3,1);
            ActivitiesDataReference.splice(0,1);
            ActivitiesUnstreamizer.splice(3,1);
            ActivitiesUnstreamizer.splice(0,1);
            this.TABNUM = 2;
         }
         if(false)
         {
            ActivityClassReference.splice(0,1);
            WindowUIName.splice(0,1);
            ActivitiesID.splice(0,1);
            ActivitiesDataReference.splice(0,1);
            ActivitiesUnstreamizer.splice(0,1);
            this.TABNUM = 3;
         }
         this.ConstructActivityWindow();
      }
      
      protected function ConstructActivityWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Class = null;
         this.FActivityWindows = new Vector.<TProcessorHDSingleWindowBase>();
         this.FActivityDatas = new Vector.<TActivityOSBase>(_loc2_);
         this.FActivitiesUnstreamizers = new Vector.<Object>();
         _loc2_ = int(ActivityClassReference.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = ActivityClassReference[_loc1_];
            this.FActivityWindows.push(new _loc3_(this));
            this.FActivityDatas.push(new ActivitiesDataReference[_loc1_]());
            this.FActivitiesUnstreamizers.push(new ActivitiesUnstreamizer[_loc1_]());
            _loc1_++;
         }
         this.FHDActivityConfigs = new Vector.<THDActivityBase>(_loc2_);
         this.FActivityAtomsVect = new Vector.<TActivityAtoms>(_loc2_);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         FSceneResourceName = "Link_NewYearSheep";
         super.InitWindow(param1);
         addChildAt(FScene,0);
         this.FUITab = new TUITab(this);
         this.FTabMarks = new Vector.<Sprite>();
         _loc2_ = 0;
         while(_loc2_ < this.TABNUM)
         {
            this.FUITab.SetTabByIndex(FScene["Tab_" + _loc2_],_loc2_);
            this.FTabMarks.push(FScene["Mark" + _loc2_]);
            _loc2_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         _loc3_ = int(ActivityClassReference.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = WindowUIName[_loc2_];
            this.FActivityWindows[_loc2_].InitWindow(FScene[_loc4_]);
            this.FActivityWindows[_loc2_].OnGiftBoxMove = ProcessorOnGiftBoxMove;
            this.FActivityWindows[_loc2_].OnGiftBoxOut = ProcessorOnGiftBoxOut;
            _loc2_++;
         }
         FScene.visible = false;
      }
      
      protected function InitActivityData_Perfrom(param1:Vector.<THDActivityBase>, param2:Vector.<TActivityAtoms>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = int(this.FHDActivityConfigs.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FHDActivityConfigs[_loc3_] = null;
            this.FActivityAtomsVect[_loc3_] = null;
            _loc3_++;
         }
         _loc4_ = int(param2.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc5_ = this.IndexByAtoms(param2[_loc3_]);
            if(_loc5_ != -1)
            {
               this.FHDActivityConfigs[_loc5_] = param1[_loc3_];
               this.FActivityAtomsVect[_loc5_] = param2[_loc3_];
            }
            _loc3_++;
         }
         this.FCurrentTabIndex = this.IndexByAtoms(param2[0]);
      }
      
      protected function InitTabState(param1:Vector.<TActivityAtoms>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.TABNUM)
         {
            this.FUITab.SetTabEnabledByIndex(_loc2_,false);
            this.FTabMarks[_loc2_].visible = false;
            _loc2_++;
         }
         _loc3_ = int(param1.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.IndexByAtoms(param1[_loc2_]);
            this.FUITab.SetTabEnabledByIndex(_loc4_,true);
            _loc2_++;
         }
      }
      
      protected function InitActivitySwitch() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = int(this.FActivitySwitch.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = ActivitiesID.indexOf(this.FActivityAtomsVect[_loc1_].ActivityID);
            this.FActivitySwitch.push(_loc3_ != -1);
            _loc1_++;
         }
      }
      
      protected function IndexByAtoms(param1:TActivityAtoms) : int
      {
         return ActivitiesID.indexOf(param1.ActivityID);
      }
      
      protected function IndexByID(param1:int) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FActivityAtomsVect.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(Boolean(this.FActivityAtomsVect[_loc2_]) && param1 == this.FActivityAtomsVect[_loc2_].Identifier)
            {
               break;
            }
            _loc2_++;
         }
         return this.IndexByAtoms(this.FActivityAtomsVect[_loc2_]);
      }
      
      protected function TabOnSwitch(param1:int) : void
      {
         this.FActivityWindows[this.FCurrentTabIndex].Hide();
         this.FActivityWindows[param1].Show(this.FActivityAtomsVect[param1],this.FHDActivityConfigs[param1],this.FActivityDatas[param1]);
         FScene.visible = true;
         this.FCurrentTabIndex = param1;
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         this.FActivityWindows[this.FCurrentTabIndex].Hide();
         FScene.visible = false;
         ProcessorWindowClose();
      }
      
      public function InitActivityData(param1:Vector.<THDActivityBase>, param2:Vector.<TActivityAtoms>) : void
      {
         this.InitActivityData_Perfrom(param1,param2);
         this.InitTabState(param2);
      }
      
      public function SendActivityInitData(param1:TActivityAtoms, param2:TActivityInitRetData) : void
      {
         var _loc3_:int = 0;
         _loc3_ = this.IndexByAtoms(param1);
         this.FActivitiesUnstreamizers[_loc3_].UnstreamizeInitActivity(param2,this.FActivityDatas[_loc3_],this.FHDActivityConfigs[_loc3_]);
         if(this.FCurrentTabIndex == _loc3_)
         {
            this.FUITab.SwithTagManual(this.FCurrentTabIndex);
         }
      }
      
      public function SendActivityChangeData(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:int = 0;
         _loc2_ = this.IndexByID(param1.ID);
         this.FActivitiesUnstreamizers[_loc2_].UnstreamizeUpdateActivity(param1,this.FActivityDatas[_loc2_],this.FHDActivityConfigs[_loc2_]);
         if(this.FCurrentTabIndex == _loc2_)
         {
            this.FUITab.SwithTagManual(this.FCurrentTabIndex);
         }
      }
   }
}

