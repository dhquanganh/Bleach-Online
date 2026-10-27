package Components.Standard
{
   import Foundation.UI.TUIComponent;
   import Foundation.Utilities.TUtilityCartisian;
   import flash.events.MouseEvent;
   
   public class TUIScrollBarVertical extends TUIScrollBar
   {
      
      public function TUIScrollBarVertical(param1:TUIComponent)
      {
         super(param1);
         FBoundsClient.Width = 14;
         FBoundsClient.Height = 120;
      }
      
      override protected function ThumbUpdate() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc1_ = FBoundsClient.Height;
         _loc2_ = FMax - FMin;
         _loc3_ = _loc2_ - FPageSize;
         if(_loc3_ <= 0)
         {
            FThumbValueDomain = _loc2_;
            FThumbValueRange = 0;
            FThumbSize = _loc1_;
            FThumbSpace = 0;
            return;
         }
         _loc4_ = _loc1_ * FPageSize / _loc2_;
         if(_loc4_ < FThumbSizeMin)
         {
            _loc4_ = FThumbSizeMin;
         }
         if(_loc4_ > _loc1_)
         {
            _loc4_ = _loc1_;
         }
         _loc5_ = _loc1_ - _loc4_;
         FThumbValueDomain = _loc2_;
         FThumbValueRange = _loc3_;
         FThumbSize = _loc4_;
         FThumbSpace = _loc5_;
      }
      
      override protected function ThumbUpdateBounds() : void
      {
         this.ThumbUpdate();
         if(FThumbSpace <= 0)
         {
            FBoundsThumb.Assign(FBoundsScreen);
            return;
         }
         TUtilityCartisian.BoundsSet(FBoundsThumb,0,FButtonTop.height + (FValue - FMin) * FThumbSpace / FThumbValueRange,FBoundsClient.Width,FThumbSize);
      }
      
      override protected function UIMessagePerform_MouseMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.UIMessagePerform_MouseMove(param1);
         if(FThumbPressed)
         {
            _loc2_ = FUICore.MouseCoordinate.Y - FThumbMouseOffset - FBoundsScreen.Y;
            this.ThumbUpdate();
            _loc3_ = _loc2_ * FThumbValueRange / FThumbSpace + FMin;
            ThumbValueSet(_loc3_);
         }
      }
      
      override protected function UIMessagePerform_MouseDown(param1:MouseEvent) : void
      {
         super.UIMessagePerform_MouseDown(param1);
         this.ThumbUpdateBounds();
         if(FThumbSpace > 0)
         {
            FMouseCoordinate.Assign(FUICore.MouseCoordinate);
            FMouseCoordinate.X -= FBoundsScreen.X;
            FMouseCoordinate.Y -= FBoundsScreen.Y + FBoundsClient.Y - FButtonTop.height;
            FThumbPressed = TUtilityCartisian.BoundsContainsCoordinate(FBoundsThumb,FMouseCoordinate);
            if(FThumbPressed)
            {
               FThumbMouseOffset = FMouseCoordinate.Y - FBoundsThumb.Y;
            }
         }
      }
   }
}

