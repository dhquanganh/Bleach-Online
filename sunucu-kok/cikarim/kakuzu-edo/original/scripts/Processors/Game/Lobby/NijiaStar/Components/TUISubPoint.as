package Processors.Game.Lobby.NijiaStar.Components
{
   import Foundation.UI.TUIComponent;
   import Logics.NijiaStar.TNijiaStar;
   import Logics.NijiaStar.TNijiaStarAtom;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TUISubPoint extends TUINijiaPoint
   {
      
      protected const FRAME_UnOpened:uint = 1;
      
      protected const FRAME_CanOpen:uint = 2;
      
      protected const FRAME_Opened:uint = 3;
      
      protected var FNijiaStarAtom:TNijiaStarAtom;
      
      public function TUISubPoint(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UIDispatch() : void
      {
         FResoures.MC_Sub.MC_Over.visible = false;
         FResoures.MC_Sub.MC_Over.mouseChildren = false;
         FResoures.MC_Sub.MC_Over.mouseEnabled = false;
      }
      
      protected function SetSubPointStatus(param1:TNijiaStarAtom, param2:TUIMainPoint) : void
      {
         var _loc3_:TNijiaStar = null;
         var _loc4_:MovieClip = null;
         _loc3_ = FContext as TNijiaStar;
         FResoures.gotoAndStop(param2.Tag + 1);
         this.Reset();
         _loc4_ = FResoures["MC_Sub"];
         _loc4_.buttonMode = true;
         if(_loc3_.Identifier == 0 && param1.Sort == 1)
         {
            _loc4_.gotoAndStop(this.FRAME_CanOpen);
         }
         else if(param1.Identifier <= _loc3_.Identifier)
         {
            _loc4_.gotoAndStop(this.FRAME_Opened);
         }
         else if(param1.Identifier == _loc3_.Identifier + 1)
         {
            _loc4_.gotoAndStop(this.FRAME_CanOpen);
         }
         else
         {
            _loc4_.gotoAndStop(this.FRAME_UnOpened);
         }
      }
      
      override protected function PointOnOut(param1:MouseEvent) : void
      {
         if(FOnOut != null)
         {
            FOnOut(this,this.FNijiaStarAtom);
         }
         param1.currentTarget.MC_Sub.MC_Over.visible = false;
      }
      
      override protected function PointOnOver(param1:MouseEvent) : void
      {
         if(FOnOver != null)
         {
            FOnOver(this,this.FNijiaStarAtom);
         }
         if(param1.currentTarget.MC_Sub.currentFrame != this.FRAME_CanOpen)
         {
            return;
         }
         param1.currentTarget.MC_Sub.MC_Over.visible = true;
      }
      
      override protected function PointOnClick(param1:MouseEvent) : void
      {
         if(param1.currentTarget.MC_Sub.currentFrame == this.FRAME_UnOpened)
         {
            return;
         }
         if(FOnClick != null)
         {
            FOnClick(this,this.FNijiaStarAtom);
         }
      }
      
      public function SetSubPointInfo(param1:TNijiaStarAtom, param2:TUIMainPoint) : void
      {
         this.FNijiaStarAtom = param1;
         this.SetSubPointStatus(param1,param2);
      }
      
      public function Reset() : void
      {
         FResoures.MC_Sub.MC_Over.visible = false;
         FResoures.MC_Sub.MC_Over.mouseChildren = false;
         FResoures.MC_Sub.MC_Over.mouseEnabled = false;
      }
   }
}

