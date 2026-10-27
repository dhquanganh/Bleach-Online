package Processors.Game.Lobby.NijiaStar.Components
{
   import Foundation.UI.TUIComponent;
   import Processors.Game.TProcessorGame;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TUINijiaPoint extends TProcessorGame
   {
      
      protected var FResoures:MovieClip;
      
      protected var FContext:Object;
      
      protected var FFirstFrameMC:MovieClip;
      
      protected var FSencondFrameMC:MovieClip;
      
      protected var FThirdFrameMC:MovieClip;
      
      protected var FOnOver:Function;
      
      protected var FOnOut:Function;
      
      protected var FOnClick:Function;
      
      public function TUINijiaPoint(param1:TUIComponent)
      {
         super(param1);
      }
      
      protected function UIDispatch() : void
      {
         this.FResoures.buttonMode = true;
      }
      
      protected function UILocations() : void
      {
         this.FResoures.addEventListener(MouseEvent.CLICK,this.PointOnClick,false,0,true);
         this.FResoures.addEventListener(MouseEvent.MOUSE_MOVE,this.PointOnOver,false,0,true);
         this.FResoures.addEventListener(MouseEvent.MOUSE_OUT,this.PointOnOut,false,0,true);
      }
      
      protected function PointOnOver(param1:MouseEvent) : void
      {
         if(this.FOnOver != null)
         {
            this.FOnOver(this,this.Context);
         }
      }
      
      protected function PointOnOut(param1:MouseEvent) : void
      {
         if(this.FOnOut != null)
         {
            this.FOnOut(this,this.Context);
         }
      }
      
      protected function PointOnClick(param1:MouseEvent) : void
      {
         if(this.FOnClick != null)
         {
            this.FOnClick(this,this.Context);
         }
      }
      
      public function get OnOver() : Function
      {
         return this.FOnOver;
      }
      
      public function set OnOver(param1:Function) : void
      {
         this.FOnOver = param1;
      }
      
      public function get OnOut() : Function
      {
         return this.FOnOut;
      }
      
      public function set OnOut(param1:Function) : void
      {
         this.FOnOut = param1;
      }
      
      public function get OnClick() : Function
      {
         return this.FOnClick;
      }
      
      public function set OnClick(param1:Function) : void
      {
         this.FOnClick = param1;
      }
      
      public function get Resoures() : MovieClip
      {
         return this.FResoures;
      }
      
      public function set Resoures(param1:MovieClip) : void
      {
         this.FResoures = param1;
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
         this.UIDispatch();
         this.UILocations();
      }
   }
}

