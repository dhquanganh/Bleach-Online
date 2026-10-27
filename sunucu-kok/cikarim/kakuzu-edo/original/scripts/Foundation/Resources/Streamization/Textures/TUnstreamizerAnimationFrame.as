package Foundation.Resources.Streamization.Textures
{
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Resources.Textures.TAnimationFrame;
   import Foundation.Streamization.TUnstreamizer;
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TUnstreamizerAnimationFrame extends TUnstreamizer
   {
      
      public function TUnstreamizerAnimationFrame()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPeform_Properties(param1,param2,param3);
      }
      
      protected function UnstreamizationPeform_Properties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TAnimationFrame = null;
         var _loc5_:BitmapData = null;
         var _loc6_:TBounds = null;
         var _loc7_:TCoordinate = null;
         var _loc8_:int = 0;
         _loc4_ = param2 as TAnimationFrame;
         _loc5_ = param3 as BitmapData;
         _loc6_ = _loc4_.Bounds;
         _loc7_ = _loc4_.Pivot;
         _loc6_.X = param1.readShort();
         _loc6_.Y = param1.readShort();
         _loc6_.Width = param1.readUnsignedShort();
         _loc6_.Height = param1.readUnsignedShort();
         _loc7_.X = param1.readShort();
         _loc7_.Y = param1.readShort();
         _loc8_ = int(param1.readUnsignedShort());
         _loc4_.CoerceProperties(_loc5_,_loc8_);
      }
   }
}

