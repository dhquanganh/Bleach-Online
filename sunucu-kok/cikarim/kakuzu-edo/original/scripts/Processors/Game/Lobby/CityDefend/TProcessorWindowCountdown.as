package Processors.Game.Lobby.CityDefend
{
   import Foundation.Timing.*;
   import Foundation.UI.*;
   import Processors.*;
   import Resources.Constants.*;
   import flash.display.*;
   
   public class TProcessorWindowCountdown extends TProcessor
   {
      
      protected var Bg_Sp:Shape;
      
      protected var FScene:MovieClip;
      
      protected var FCountdown:uint;
      
      protected var FIsStart:Boolean;
      
      protected var FOnColdDown:Function;
      
      public function TProcessorWindowCountdown(param1:TUIComponent)
      {
         super(param1);
         this.Bg_Sp = new Shape();
         this.Bg_Sp.graphics.beginFill(0,0.3);
         this.Bg_Sp.graphics.drawRect(0,0,CONST_COMMON.STAGE_Max_Width,CONST_COMMON.STAGE_Max_Height);
         this.Bg_Sp.graphics.endFill();
         addChild(this.Bg_Sp);
         this.FIsStart = false;
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(this.Visible)
         {
            this.LogicsPerform_Countdown();
         }
      }
      
      protected function LogicsPerform_Countdown() : void
      {
         var _loc1_:int = 0;
         if(this.FScene == null)
         {
            return;
         }
         _loc1_ = this.FCountdown - STimingCore.ServerTick;
         this.FScene.mc_time0.gotoAndStop(_loc1_ % 10 + 1);
         this.FScene.mc_time1.gotoAndStop(int(_loc1_ / 10) + 1);
         if(_loc1_ <= 0)
         {
            this.FIsStart = false;
            this.Visible = false;
            if(this.FOnColdDown != null)
            {
               this.FOnColdDown(this);
            }
         }
      }
      
      public function set OnColdDown(param1:Function) : void
      {
         this.FOnColdDown = param1;
      }
      
      public function SetScene(param1:MovieClip) : void
      {
         this.FScene = param1;
         addChild(this.FScene);
         this.FScene.mc_time0.stop();
         this.FScene.mc_time1.stop();
      }
      
      public function StartCountdown(param1:uint) : void
      {
         if(param1 - STimingCore.ServerTick <= 0)
         {
            return;
         }
         this.FCountdown = param1;
         if(this.FCountdown - STimingCore.ServerTick > 60)
         {
            this.FCountdown = STimingCore.ServerTick + 60;
         }
         this.FIsStart = true;
         this.Visible = true;
      }
      
      public function Stop() : void
      {
         this.FCountdown = 0;
         this.FIsStart = false;
         this.Visible = false;
      }
      
      public function GetLastTime() : int
      {
         return this.FCountdown - STimingCore.ServerTick;
      }
   }
}

