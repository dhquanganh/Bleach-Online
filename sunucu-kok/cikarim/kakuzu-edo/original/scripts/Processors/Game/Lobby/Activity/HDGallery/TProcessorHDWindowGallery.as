package Processors.Game.Lobby.Activity.HDGallery
{
   import Components.Standard.TUITab;
   import Foundation.UI.TUIComponent;
   import Logics.DatebaseVO.VO.*;
   import Logics.DatebaseVO.VO.Json.TActAwardStatusInfo;
   import Logics.HDActivityMode.TActivityAtoms;
   import Logics.HDActivityMode.TActivityInitRetData;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDGallery.*;
   import Logics.Streamization.HDGallery.*;
   import Processors.Game.Lobby.Activity.HDActivity.TProcessorHDSingleWindowBase;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class TProcessorHDWindowGallery extends TProcessorHDSingleWindowBase
   {
      
      protected static const TABNUM:int = 2;
      
      protected static const ActivityClassReference:Vector.<Class> = Vector.<Class>([TProcessorHDViewGallery,TProcessorHDViewReward]);
      
      protected static const WindowUIName:Vector.<String> = Vector.<String>(["MC_Page0","MC_Page1"]);
      
      protected var FActivityWindows:Vector.<TProcessorHDSingleWindowBase>;
      
      protected var FUITab:TUITab;
      
      protected var FTabMarks:Vector.<Sprite>;
      
      protected var FUnstreamizer:TUnstreamizerGallery;
      
      protected var FConfigData:THDGallery;
      
      protected var FActivityData:THDGalleryData;
      
      public function TProcessorHDWindowGallery(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function ConstructActivityWindow() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Class = null;
         this.FActivityWindows = new Vector.<TProcessorHDSingleWindowBase>();
         this.FUnstreamizer = new TUnstreamizerGallery();
         this.FActivityData = new THDGalleryData();
         _loc2_ = int(ActivityClassReference.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = ActivityClassReference[_loc1_];
            this.FActivityWindows.push(new _loc3_(this));
            _loc1_++;
         }
         (this.FActivityWindows[1] as TProcessorHDViewReward).Funclose = this.ProcessFunclose;
      }
      
      protected function ProcessFunclose() : void
      {
         this.TabOnSwitch(0);
      }
      
      override public function InitWindow(param1:Sprite = null) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         FSceneResourceName = "MC_HDGallery";
         super.InitWindow(param1);
         this.ConstructActivityWindow();
         this.FUITab = new TUITab(this);
         this.FTabMarks = new Vector.<Sprite>();
         _loc2_ = 0;
         while(_loc2_ < TABNUM)
         {
            this.FUITab.SetTabByIndex(FScene["Tab_" + _loc2_],_loc2_);
            this.FTabMarks.push(FScene["Mark_" + _loc2_]);
            this.FTabMarks[_loc2_].visible = false;
            _loc2_++;
         }
         this.FUITab.OnSwitch = this.TabOnSwitch;
         this.FUITab.Init();
         _loc3_ = int(ActivityClassReference.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = WindowUIName[_loc2_];
            this.FActivityWindows[_loc2_].InitWindow(FScene["MC_Main"][_loc4_]);
            this.FActivityWindows[_loc2_].OnGiftBoxMove = ProcessorOnGiftBoxMove;
            this.FActivityWindows[_loc2_].OnGiftBoxOut = ProcessorOnGiftBoxOut;
            _loc2_++;
         }
         FTF_CoolingTime = FScene["MC_Main"]["MC_Prompt"]["TF_CoolingTime"];
         FTF_OpenTime = FScene["MC_Main"]["MC_Prompt"]["TF_OpenTime"];
         FTF_Desc = FScene["MC_Main"]["MC_Prompt"]["TF_Desc"];
      }
      
      protected function TabOnSwitch(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FActivityWindows.length);
         this.FActivityWindows[1].Hide();
         this.FActivityWindows[param1].Show(FActivityAtoms,this.FConfigData,this.FActivityData);
         FScene.visible = true;
         this.FActivityWindows[0].mouseChildren = param1 == 1 ? false : true;
         this.FActivityWindows[0].mouseEnabled = param1 == 1 ? false : true;
      }
      
      override protected function BtnCloseOnClick(param1:Object, param2:MouseEvent) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FActivityWindows.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            this.FActivityWindows[_loc3_].Hide();
            _loc3_++;
         }
         FScene.visible = false;
         ProcessorWindowClose();
      }
      
      public function InitActivityData(param1:Vector.<THDActivityBase>, param2:Vector.<TActivityAtoms>) : void
      {
         this.FConfigData = param1[0] as THDGallery;
         FActivityAtoms = param2[0];
      }
      
      public function SendActivityInitData(param1:TActivityAtoms, param2:TActivityInitRetData) : void
      {
         Show(param1,this.FConfigData,this.FActivityData);
         this.FUnstreamizer.UnstreamizeInitActivity(param2,this.FActivityData,this.FConfigData);
         this.TabOnSwitch(0);
      }
      
      public function SendActivityChangeData(param1:TActAwardStatusInfo) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         this.FUnstreamizer.UnstreamizeUpdateActivity(param1,this.FActivityData,this.FConfigData);
         _loc3_ = int(this.FActivityWindows.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FActivityWindows[_loc2_].ProcessorUpDateDataBase(this.FActivityData);
            _loc2_++;
         }
      }
      
      override protected function UpdateDataBase(param1:TActivityOSBase) : void
      {
         super.UpdateDataBase(param1);
         ProcessorFormatActivityTimeFromNowOn(FActivityAtoms.EndTime);
         ProcessorFormatActivityCountDown(FActivityAtoms.EndTime);
      }
   }
}

