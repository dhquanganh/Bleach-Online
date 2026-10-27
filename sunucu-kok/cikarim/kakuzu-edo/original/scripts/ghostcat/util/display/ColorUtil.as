package ghostcat.util.display
{
   import flash.display.BitmapData;
   import flash.display.GradientType;
   import flash.display.IBitmapDrawable;
   import flash.display.Shape;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   
   public final class ColorUtil
   {
      
      public static const RED:uint = 16711680;
      
      public static const GREEN:uint = 65280;
      
      public static const BLUE:uint = 255;
      
      public function ColorUtil()
      {
         super();
      }
      
      public static function RGB(param1:uint, param2:uint, param3:uint) : uint
      {
         return param1 << 16 | param2 << 8 | param3;
      }
      
      public static function RYB(param1:uint, param2:uint, param3:uint) : uint
      {
         return 255 - param3 << 16 | 255 - param1 << 8 | 255 - param2;
      }
      
      public static function getChannel(param1:uint, param2:uint) : uint
      {
         switch(param2)
         {
            case RED:
               return param1 >> 16 & 0xFF;
            case GREEN:
               return param1 >> 8 & 0xFF;
            case BLUE:
               return param1 & 0xFF;
            default:
               return 0;
         }
      }
      
      public static function getColorTransform(param1:uint, param2:Number = 1) : ColorTransform
      {
         var _loc3_:Number = param1 >> 16 & 0xFF;
         var _loc4_:Number = param1 >> 8 & 0xFF;
         var _loc5_:Number = param1 & 0xFF;
         return new ColorTransform(_loc3_ / 255,_loc4_ / 255,_loc5_ / 255,param2);
      }
      
      public static function getColorTransform2(param1:uint, param2:Number = 1) : ColorTransform
      {
         var _loc3_:Number = param1 >> 16 & 255 * param2;
         var _loc4_:Number = param1 >> 8 & 255 * param2;
         var _loc5_:Number = param1 & 255 * param2;
         return new ColorTransform(1,1,1,1,_loc3_,_loc4_,_loc5_);
      }
      
      public static function adjustColor(param1:uint, param2:uint, param3:uint) : uint
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if((RED & param1) == param1)
         {
            _loc4_ = Math.max(Math.min((param2 >> 16 & 0xFF) + param3,255),0);
         }
         else
         {
            _loc4_ = param2 >> 16 & 0xFF;
         }
         if((GREEN & param1) == param1)
         {
            _loc5_ = Math.max(Math.min((param2 >> 8 & 0xFF) + param3,255),0);
         }
         else
         {
            _loc5_ = param2 >> 8 & 0xFF;
         }
         if((BLUE & param1) == param1)
         {
            _loc6_ = Math.max(Math.min((param2 & 0xFF) + param3,255),0);
         }
         else
         {
            _loc6_ = param2 & 0xFF;
         }
         return RGB(_loc4_,_loc5_,_loc6_);
      }
      
      public static function adjustBrightness(param1:uint, param2:Number) : uint
      {
         var _loc3_:Number = Math.max(Math.min((param1 >> 16 & 0xFF) + param2,255),0);
         var _loc4_:Number = Math.max(Math.min((param1 >> 8 & 0xFF) + param2,255),0);
         var _loc5_:Number = Math.max(Math.min((param1 & 0xFF) + param2,255),0);
         return RGB(_loc3_,_loc4_,_loc5_);
      }
      
      public static function adjustBrightness2(param1:uint, param2:Number) : uint
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         if(param2 == 0)
         {
            return param1;
         }
         if(param2 < 0)
         {
            param2 = (100 + param2) / 100;
            _loc3_ = (param1 >> 16 & 0xFF) * param2;
            _loc4_ = (param1 >> 8 & 0xFF) * param2;
            _loc5_ = (param1 & 0xFF) * param2;
         }
         else
         {
            param2 /= 100;
            _loc3_ = param1 >> 16 & 0xFF;
            _loc4_ = param1 >> 8 & 0xFF;
            _loc5_ = param1 & 0xFF;
            _loc3_ += (255 - _loc3_) * param2;
            _loc4_ += (255 - _loc4_) * param2;
            _loc5_ += (255 - _loc5_) * param2;
            _loc3_ = Math.min(_loc3_,255);
            _loc4_ = Math.min(_loc4_,255);
            _loc5_ = Math.min(_loc5_,255);
         }
         return RGB(_loc3_,_loc4_,_loc5_);
      }
      
      public static function rgbMultiply(param1:uint, param2:uint) : uint
      {
         var _loc3_:Number = param1 >> 16 & 0xFF;
         var _loc4_:Number = param1 >> 8 & 0xFF;
         var _loc5_:Number = param1 & 0xFF;
         var _loc6_:Number = param2 >> 16 & 0xFF;
         var _loc7_:Number = param2 >> 8 & 0xFF;
         var _loc8_:Number = param2 & 0xFF;
         return _loc3_ * _loc6_ / 255 << 16 | _loc4_ * _loc7_ / 255 << 8 | _loc5_ * _loc8_ / 255;
      }
      
      public static function getPaletteArray(param1:Array, param2:Array, param3:Array) : Array
      {
         var _loc4_:Matrix = new Matrix();
         _loc4_.createGradientBox(256,1);
         var _loc5_:Shape = new Shape();
         _loc5_.graphics.beginGradientFill(GradientType.LINEAR,param1,param2,param3,_loc4_);
         _loc5_.graphics.drawRect(0,0,256,1);
         _loc5_.graphics.endFill();
         var _loc6_:BitmapData = new BitmapData(256,1);
         _loc6_.draw(_loc5_);
         var _loc7_:Array = [];
         var _loc8_:int = 0;
         while(_loc8_ < 256)
         {
            _loc7_.push(_loc6_.getPixel(_loc8_,0));
            _loc8_++;
         }
         _loc6_.dispose();
         return _loc7_;
      }
      
      public static function getColorBetween(param1:uint, param2:uint, param3:Number) : uint
      {
         var _loc4_:Number = param1 >> 16 & 0xFF;
         var _loc5_:Number = param1 >> 8 & 0xFF;
         var _loc6_:Number = param1 & 0xFF;
         var _loc7_:Number = param2 >> 16 & 0xFF;
         var _loc8_:Number = param2 >> 8 & 0xFF;
         var _loc9_:Number = param2 & 0xFF;
         return _loc4_ + (_loc7_ - _loc4_) * param3 << 16 | _loc5_ + (_loc8_ - _loc5_) * param3 << 8 | _loc6_ + (_loc9_ - _loc6_) * param3;
      }
      
      public static function getColorAtPoint(param1:IBitmapDrawable, param2:int, param3:int) : uint
      {
         var _loc4_:BitmapData = new BitmapData(1,1);
         var _loc5_:Matrix = new Matrix();
         _loc5_.translate(-param2,-param3);
         _loc4_.draw(param1,_loc5_);
         return _loc4_.getPixel(0,0);
      }
   }
}

