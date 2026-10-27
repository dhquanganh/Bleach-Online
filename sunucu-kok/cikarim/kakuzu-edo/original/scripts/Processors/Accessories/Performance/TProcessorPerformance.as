package Processors.Accessories.Performance
{
   import Foundation.Timing.STimingCore;
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityDate;
   import Foundation.Utilities.TUtilityString;
   import Processors.TProcessor;
   import Resources.Constants.CONST_KEYCODE;
   import Resources.Strings.STRING_PLATFORM;
   import flash.events.KeyboardEvent;
   import flash.system.System;
   import flash.utils.getTimer;
   
   public class TProcessorPerformance extends TProcessor
   {
      
      protected static const History:int = 60;
      
      protected static const KEY_P:uint = CONST_KEYCODE.KEY_P;
      
      private var FProcessorWindowProfiler:TProcessorWindowProfiler;
      
      private var FFpsList:Array = [];
      
      private var FMemList:Array = [];
      
      private var FPublishMode:String;
      
      private var FServerStartTime:int;
      
      private var FServerCurTime:int;
      
      private var FStrPlatform:String;
      
      private var FStrServerStartTime:String;
      
      private var FStrServerCurTime:String;
      
      private var FMinFps:Number;
      
      private var FMaxFps:Number;
      
      private var FMinMem:Number;
      
      private var FMaxMem:Number;
      
      private var FInitTime:int;
      
      private var FItvTime:int;
      
      private var FCurrentTime:int;
      
      private var FFrameCount:int;
      
      private var FTotalCount:int;
      
      private var FDisplayed:Boolean;
      
      public function TProcessorPerformance(param1:TUIComponent)
      {
         super(param1);
         this.FProcessorWindowProfiler = new TProcessorWindowProfiler(this);
         this.FFpsList = [];
         this.FMemList = [];
         FUICore.UIStage.addEventListener(KeyboardEvent.KEY_DOWN,this.UIStageOnKeyDown);
         this.FPublishMode = "Release";
         this.FStrPlatform = "";
         this.FStrServerStartTime = "";
         this.FStrServerCurTime = "";
         this.FMinFps = Number.MAX_VALUE;
         this.FMaxFps = Number.MIN_VALUE;
         this.FMinMem = Number.MAX_VALUE;
         this.FMaxMem = Number.MIN_VALUE;
         this.FDisplayed = false;
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      override protected function LogicsPerform() : void
      {
         if(!Visible)
         {
            return;
         }
         this.ProcessorDraw();
      }
      
      protected function ProcessorDraw() : void
      {
         this.FCurrentTime = getTimer();
         ++this.FFrameCount;
         ++this.FTotalCount;
         if(this.IntervalTime >= 1)
         {
            if(this.FDisplayed)
            {
               this.UpdateDisplay();
            }
            else
            {
               this.UpdateMinMax();
            }
            this.FFpsList.unshift(this.CurrentFps);
            this.FMemList.unshift(this.CurrentMem);
            if(this.FFpsList.length > History)
            {
               this.FFpsList.pop();
            }
            if(this.FMemList.length > History)
            {
               this.FMemList.pop();
            }
            this.FItvTime = this.FCurrentTime;
            this.FFrameCount = 0;
         }
      }
      
      private function UpdateDisplay() : void
      {
         this.UpdateMinMax();
         this.UpdateServerDate();
         this.UpdatePlatform();
         this.FProcessorWindowProfiler.Update(this.FPublishMode,this.RunningTime,this.FMinFps,this.FMaxFps,this.FMinMem,this.FMaxMem,this.FStrServerStartTime,this.FStrServerCurTime,this.CurrentFps,this.CurrentMem,this.AverageFps,this.FFpsList,this.FMemList,History,this.FStrPlatform,Version.Timestamp);
      }
      
      private function UpdateMinMax() : void
      {
         this.FMinFps = Math.min(this.CurrentFps,this.FMinFps);
         this.FMaxFps = Math.max(this.CurrentFps,this.FMaxFps);
         this.FMinMem = Math.min(this.CurrentMem,this.FMinMem);
         this.FMaxMem = Math.max(this.CurrentMem,this.FMaxMem);
      }
      
      protected function UpdateServerDate() : void
      {
         var _loc1_:int = 0;
         var _loc2_:Date = null;
         _loc1_ = int(STimingCore.ServerStartTime);
         _loc2_ = new Date();
         if(this.FServerStartTime != _loc1_)
         {
            _loc2_.setTime(_loc1_ * 1000);
            this.FStrServerStartTime = TUtilityDate.FormatDateString(_loc2_);
            this.FServerStartTime = _loc1_;
         }
         _loc1_ = int(STimingCore.ServerTime);
         if(_loc1_ >= 0 && this.FServerCurTime != _loc1_)
         {
            _loc2_.setTime(_loc1_ * 1000);
            this.FStrServerCurTime = TUtilityDate.FormatDateString(_loc2_);
            this.FServerCurTime = _loc1_;
         }
      }
      
      protected function UpdatePlatform() : void
      {
         if(TUtilityString.Empty(this.FStrPlatform))
         {
            this.FStrPlatform = STRING_PLATFORM.GetPlatformCaption();
         }
      }
      
      override protected function ProcessorResize() : void
      {
         this.FProcessorWindowProfiler.Update(this.FPublishMode,this.RunningTime,this.FMinFps,this.FMaxFps,this.FMinMem,this.FMaxMem,this.FStrServerStartTime,this.FStrServerCurTime,this.CurrentFps,this.CurrentMem,this.AverageFps,this.FFpsList,this.FMemList,History,this.FStrPlatform,Version.Timestamp);
      }
      
      protected function get CurrentFps() : Number
      {
         return this.FFrameCount / this.IntervalTime;
      }
      
      protected function get CurrentMem() : Number
      {
         return System.totalMemory / 1024 / 1000;
      }
      
      protected function get AverageFps() : Number
      {
         return this.FTotalCount / this.RunningTime;
      }
      
      protected function get RunningTime() : Number
      {
         return (this.FCurrentTime - this.FInitTime) / 1000;
      }
      
      protected function get IntervalTime() : Number
      {
         return (this.FCurrentTime - this.FItvTime) / 1000;
      }
      
      protected function UIStageOnKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.ctrlKey && param1.altKey && param1.keyCode == KEY_P)
         {
            this.Visible = !this.Visible;
            this.FDisplayed = this.Visible;
         }
         if(this.Visible)
         {
            this.FInitTime = this.FItvTime = getTimer();
            this.FTotalCount = this.FFrameCount = 0;
         }
      }
   }
}

