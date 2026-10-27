package Processors.Game.Lobby.Activity.HDChristmas2015.Components
{
   import Foundation.Timing.STimingCore;
   import Foundation.Utilities.TUtilityReflection;
   import Logics.HDChristmas2015.VO.TSledVO;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TSledModel extends Sprite
   {
      
      protected var FMainUI:MovieClip;
      
      protected var FData:TSledVO;
      
      protected var FTotalTime:uint;
      
      protected var FTransportProtect:int;
      
      protected var FArrivals:Function;
      
      protected var FSuperTime:Boolean;
      
      public function TSledModel()
      {
         super();
         this.mouseChildren = false;
      }
      
      public function set Arrivals(param1:Function) : void
      {
         this.FArrivals = param1;
      }
      
      public function UIDispatch() : void
      {
         if(this.FMainUI == null)
         {
            this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("MC_ChristmasSled") as MovieClip;
            addChild(this.FMainUI);
         }
         this.FMainUI.gotoAndStop(1);
      }
      
      public function UpdateData(param1:TSledVO, param2:uint, param3:int) : void
      {
         this.FData = param1;
         if(this.FData.IsRobbed)
         {
            this.FMainUI.gotoAndStop(1 * 4 + param1.TypeIndex + 1);
         }
         else
         {
            this.FMainUI.gotoAndStop(0 * 4 + param1.TypeIndex + 1);
         }
         this.FTotalTime = param2;
         this.FTransportProtect = param3;
         this.FMainUI.TF_Name.text = param1.Name;
      }
      
      public function get Data() : TSledVO
      {
         return this.FData;
      }
      
      public function get SuperTime() : Boolean
      {
         return this.FSuperTime;
      }
      
      public function LogicsPerform() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(this.FData != null && parent != null && this.FMainUI != null)
         {
            _loc3_ = this.FData.StartTime * 1000;
            _loc4_ = this.FTotalTime * 1000;
            _loc5_ = this.FTransportProtect * 1000;
            _loc6_ = STimingCore.ServerTickM - _loc3_;
            _loc6_ = Math.min(_loc4_,_loc6_);
            _loc2_ = _loc6_ / _loc4_;
            _loc1_ = parent.width - width;
            x = _loc2_ * _loc1_;
            this.FSuperTime = _loc6_ <= _loc5_;
            if(_loc2_ == 1)
            {
               this.FArrivals(this);
            }
         }
      }
      
      public function playEffect() : void
      {
         this.FMainUI.MC_Effect.play();
      }
      
      public function stopEffect() : void
      {
         this.FMainUI.MC_Effect.stop();
      }
   }
}

