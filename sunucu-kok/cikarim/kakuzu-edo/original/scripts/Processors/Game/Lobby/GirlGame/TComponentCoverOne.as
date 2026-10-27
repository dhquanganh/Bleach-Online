package Processors.Game.Lobby.GirlGame
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityReflection;
   import Processors.Game.Lobby.Common.TProcessorLobbyWindow;
   import Resources.Constants.CONST_COMMON;
   import flash.display.MovieClip;
   
   public class TComponentCoverOne extends TProcessorLobbyWindow
   {
      
      protected static const State_Ready:int = 0;
      
      protected static const State_Covering:int = 1;
      
      protected static const State_WaitingTime:int = 2;
      
      protected static const State_WaitCancle:int = 3;
      
      protected static const CoveringStateTime:int = 500;
      
      protected var FMainUI:MovieClip;
      
      protected var FCurrentState:int;
      
      protected var FTickCount:int = 0;
      
      protected var FNotifyCancled:Boolean;
      
      protected var FOnCoverOver:Function;
      
      public function TComponentCoverOne(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function LogicsPerform() : void
      {
         super.LogicsPerform();
         if(!Visible)
         {
            return;
         }
         switch(this.FCurrentState)
         {
            case State_Ready:
               break;
            case State_Covering:
               if(this.FMainUI.currentFrame == 4)
               {
                  this.FCurrentState = State_WaitingTime;
                  if(this.FOnCoverOver != null)
                  {
                     this.FOnCoverOver(this);
                  }
               }
               this.FTickCount = 0;
               break;
            case State_WaitingTime:
               if(this.FTickCount >= CoveringStateTime)
               {
                  this.FCurrentState = State_WaitCancle;
               }
               this.FTickCount += CONST_COMMON.SIZE_FrameRatePerSecond;
               break;
            case State_WaitCancle:
               if(this.FNotifyCancled)
               {
                  this.FMainUI.play();
                  this.FCurrentState = State_Ready;
               }
         }
      }
      
      protected function UIDispatch() : void
      {
         this.FMainUI = TUtilityReflection.CreateDisplayObjectInstance("CoverOne") as MovieClip;
         addChild(this.FMainUI);
      }
      
      protected function UILocation() : void
      {
      }
      
      public function set OnCoverOver(param1:Function) : void
      {
         this.FOnCoverOver = param1;
      }
      
      public function LoadResource() : void
      {
         this.UIDispatch();
         this.UILocation();
      }
      
      public function StartCover() : void
      {
         this.FMainUI.gotoAndPlay(1);
         this.FCurrentState = State_Covering;
         this.FNotifyCancled = false;
      }
      
      public function CancleCover() : void
      {
         this.FNotifyCancled = true;
      }
      
      public function Reset() : void
      {
         this.FMainUI.stop();
         this.FCurrentState = State_Ready;
         this.FTickCount = 0;
         this.FNotifyCancled = false;
      }
   }
}

