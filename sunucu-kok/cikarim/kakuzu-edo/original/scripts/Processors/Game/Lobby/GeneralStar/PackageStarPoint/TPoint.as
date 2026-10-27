package Processors.Game.Lobby.GeneralStar.PackageStarPoint
{
   import Foundation.UI.TUIComponent;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_FRESHGUIDE;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TPoint extends TUIComponent
   {
      
      public static const RENDERINGSTATE_Disabled:int = 1;
      
      public static const RENDERINGSTATE_CanPoint:int = 2;
      
      public static const RENDERINGSTATE_Pointed:int = 3;
      
      protected var FSubstrate:MovieClip;
      
      protected var FContext:Object;
      
      protected var FInitialization:Boolean;
      
      protected var FOnClickPoint:Function;
      
      protected var FOnGeneralStarMove:Function;
      
      protected var FOnGeneralStarOut:Function;
      
      public function TPoint(param1:TUIComponent)
      {
         super(param1);
         this.FInitialization = false;
      }
      
      protected function Initialization() : void
      {
         this.FSubstrate.mc_hightLight.visible = false;
         this.FSubstrate.addEventListener(MouseEvent.MOUSE_OVER,this.PointOnOver,false,0,true);
         this.FSubstrate.addEventListener(MouseEvent.MOUSE_OUT,this.PointOnOut,false,0,true);
         this.FSubstrate.addEventListener(MouseEvent.MOUSE_MOVE,this.PointOnMove,false,0,true);
         this.FSubstrate.addEventListener(MouseEvent.CLICK,this.PointOnClick,false,0,true);
         this.FInitialization = true;
      }
      
      protected function PointOnOver(param1:MouseEvent) : void
      {
      }
      
      protected function PointOnOut(param1:MouseEvent) : void
      {
         this.FSubstrate.mc_hightLight.visible = false;
         if(this.FOnGeneralStarOut != null)
         {
            this.FOnGeneralStarOut(this);
         }
      }
      
      protected function PointOnMove(param1:MouseEvent) : void
      {
         if(this.FSubstrate.currentFrame == RENDERINGSTATE_CanPoint)
         {
            this.FSubstrate.mc_hightLight.visible = true;
         }
         if(this.FOnGeneralStarMove != null)
         {
            this.FOnGeneralStarMove(this);
         }
      }
      
      protected function PointOnClick(param1:MouseEvent) : void
      {
         if(this.FSubstrate.currentFrame == RENDERINGSTATE_CanPoint)
         {
            if(this.FOnClickPoint != null)
            {
               this.FOnClickPoint(this);
            }
         }
         SLogicsCore.SinalPostFreshGuide(CONST_FRESHGUIDE.EVENTID_ClickStar);
      }
      
      public function get Substrate() : MovieClip
      {
         return this.FSubstrate;
      }
      
      public function set Substrate(param1:MovieClip) : void
      {
         this.FSubstrate = param1;
      }
      
      public function get OnClickPoint() : Function
      {
         return this.FOnClickPoint;
      }
      
      public function set OnClickPoint(param1:Function) : void
      {
         this.FOnClickPoint = param1;
      }
      
      public function get OnGeneralStarMove() : Function
      {
         return this.FOnGeneralStarMove;
      }
      
      public function set OnGeneralStarMove(param1:Function) : void
      {
         this.FOnGeneralStarMove = param1;
      }
      
      public function get OnGeneralStarOut() : Function
      {
         return this.FOnGeneralStarOut;
      }
      
      public function set OnGeneralStarOut(param1:Function) : void
      {
         this.FOnGeneralStarOut = param1;
      }
      
      public function get Context() : Object
      {
         return this.FContext;
      }
      
      public function set Context(param1:Object) : void
      {
         this.FContext = param1;
      }
      
      public function Init() : void
      {
         if(this.FInitialization)
         {
            return;
         }
         this.Initialization();
      }
      
      public function SetPointState(param1:uint) : void
      {
         this.FSubstrate.gotoAndStop(param1);
         if(param1 == RENDERINGSTATE_CanPoint)
         {
            this.FSubstrate.buttonMode = true;
         }
         else
         {
            this.FSubstrate.buttonMode = false;
         }
         if(param1 == RENDERINGSTATE_Pointed)
         {
            this.FSubstrate["mm"].play();
         }
      }
      
      public function RemoveSubstrateEvent() : void
      {
         if(this.FSubstrate.hasEventListener(MouseEvent.MOUSE_OVER))
         {
            this.FSubstrate.removeEventListener(MouseEvent.MOUSE_OVER,this.PointOnOver);
         }
         if(this.FSubstrate.hasEventListener(MouseEvent.MOUSE_OUT))
         {
            this.FSubstrate.removeEventListener(MouseEvent.MOUSE_OUT,this.PointOnOut);
         }
         if(this.FSubstrate.hasEventListener(MouseEvent.MOUSE_MOVE))
         {
            this.FSubstrate.removeEventListener(MouseEvent.MOUSE_MOVE,this.PointOnMove);
         }
         if(this.FSubstrate.hasEventListener(MouseEvent.CLICK))
         {
            this.FSubstrate.removeEventListener(MouseEvent.CLICK,this.PointOnClick);
         }
      }
   }
}

