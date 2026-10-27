package Processors.Game.Lobby.MainSceneTwo
{
   import Foundation.Resources.Textures.TAnimationFrame;
   import Foundation.Resources.Textures.TTexture;
   import flash.display.BitmapData;
   import flash.net.FileReference;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class TBitmapBinFile
   {
      
      public function TBitmapBinFile()
      {
         super();
      }
      
      protected static function CreateBinByBitmapData(param1:TAnimationFrame, param2:ByteArray) : ByteArray
      {
         var _loc3_:BitmapData = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         _loc3_ = param1.Surface;
         param2.writeUnsignedInt(_loc3_.width);
         param2.writeUnsignedInt(_loc3_.height);
         param2.writeUnsignedInt(param1.Pivot.X);
         param2.writeUnsignedInt(param1.Pivot.Y);
         _loc5_ = _loc3_.height;
         _loc7_ = _loc3_.width;
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc6_ = 0;
            while(_loc6_ < _loc7_)
            {
               _loc8_ = _loc3_.getPixel32(_loc6_,_loc4_);
               param2.writeUnsignedInt(_loc8_);
               _loc6_++;
            }
            _loc4_++;
         }
         return param2;
      }
      
      protected static function getfff() : void
      {
      }
      
      public static function CreateBinFileByTexture(param1:TTexture, param2:uint) : void
      {
         var _loc3_:TAnimationFrame = null;
         var _loc4_:ByteArray = null;
         var _loc5_:ByteArray = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc4_ = new ByteArray();
         _loc4_.endian = Endian.LITTLE_ENDIAN;
         _loc7_ = param1.GetAnimationSequenceByIndex(0).Count;
         _loc4_.writeUnsignedInt(_loc7_);
         while(_loc6_ < _loc7_)
         {
            CreateBinByBitmapData(param1.GetAnimationSequenceByIndex(0).GetAnimationFrameByIndex(_loc6_),_loc4_);
            _loc6_++;
         }
         _loc4_.position = 0;
         new FileReference().save(_loc4_,param2.toString(16) + ".plib");
      }
   }
}

