package Foundation.Resources.Streamization.Textures
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Resources.Textures.*;
   import Foundation.Streamization.*;
   import flash.display.*;
   import flash.utils.*;
   
   use namespace ResourcesSpace;
   
   public class TUnstreamizerAnimationSequence extends TUnstreamizer
   {
      
      protected var FUnstreamizerFrame:TUnstreamizer;
      
      public function TUnstreamizerAnimationSequence()
      {
         super();
         this.FUnstreamizerFrame = new TUnstreamizerAnimationFrame();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPeform_Properties(param1,param2,param3);
         this.UnstreamizationPeform_Traversal(param1,param2,param3);
      }
      
      protected function UnstreamizationPeform_Properties(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:TAnimationSequence = null;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         _loc4_ = param2 as TAnimationSequence;
         _loc5_ = param1.readUnsignedInt();
         _loc6_ = int(param1.readUnsignedByte());
         _loc4_.Coerce(_loc5_);
         _loc4_.CoerceProperties(_loc6_);
      }
      
      protected function UnstreamizationPeform_Traversal(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TAnimationSequence = null;
         var _loc7_:TAnimationFrame = null;
         var _loc8_:Vector.<BitmapData> = null;
         _loc6_ = param2 as TAnimationSequence;
         _loc8_ = param3 as Vector.<BitmapData>;
         _loc4_ = int(param1.readUnsignedShort());
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc7_ = new TAnimationFrame(null);
            this.FUnstreamizerFrame.Unstreamize(param1,_loc7_,_loc8_[_loc5_]);
            _loc6_.FrameAppend(_loc7_);
            _loc5_++;
         }
      }
   }
}

