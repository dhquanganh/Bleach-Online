package Processors.Game.Lobby.NijiaStar.Components
{
   import Foundation.UI.TUIComponent;
   import Logics.NijiaStar.TNijiaStar;
   import flash.events.MouseEvent;
   
   public class TUIMainPoint extends TUINijiaPoint
   {
      
      protected const STARTUS_NoOpen:int = -1;
      
      protected const STARTUS_Open:int = 0;
      
      private var FIndex:uint;
      
      public function TUIMainPoint(param1:TUIComponent)
      {
         super(param1);
      }
      
      override protected function UIDispatch() : void
      {
         super.UIDispatch();
         FResoures.MC_Select.mouseChildren = false;
         FResoures.MC_Select.mouseEnabled = false;
         FResoures.MC_Select.visible = false;
         FResoures.MC_Inner.mouseChildren = false;
         FResoures.MC_Inner.mouseEnabled = false;
         FResoures.MC_Inner.gotoAndStop(Tag + 1);
      }
      
      override protected function PointOnOver(param1:MouseEvent) : void
      {
         super.PointOnOver(param1);
         FResoures.MC_Select.visible = true;
      }
      
      override protected function PointOnOut(param1:MouseEvent) : void
      {
         super.PointOnOut(param1);
         FResoures.MC_Select.visible = false;
      }
      
      public function SetSubPointInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:TNijiaStar = null;
         _loc2_ = FContext as TNijiaStar;
         _loc1_ = _loc2_.Identifier;
         if(_loc1_ == this.STARTUS_NoOpen)
         {
            FResoures.MC_Inner.MC_Point.gotoAndStop(1);
            FResoures.buttonMode = false;
         }
         else if(!_loc2_.IsLastPoint)
         {
            FResoures.MC_Inner.MC_Point.gotoAndStop(2);
            FResoures.buttonMode = true;
         }
         else
         {
            FResoures.MC_Inner.MC_Point.gotoAndStop(3);
            FResoures.MC_Inner.MC_Point.MC_Effect.play();
            FResoures.buttonMode = false;
         }
      }
   }
}

