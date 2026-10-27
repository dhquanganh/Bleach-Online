package Foundation.Utilities
{
   import Foundation.Common.Spaces.CommonSpace;
   import Foundation.Common.TBounds;
   import Foundation.Common.TCoordinate;
   import flash.display.DisplayObject;
   
   use namespace CommonSpace;
   
   public class TUtilityCartisian
   {
      
      public function TUtilityCartisian()
      {
         super();
         throw new Error("UtilityCartisian Class Is Static Container Only");
      }
      
      public static function CoordinateSet(param1:TCoordinate, param2:int, param3:int) : void
      {
         param1.FX = param2;
         param1.FY = param3;
      }
      
      public static function CoordinateSetByBoundsCenter(param1:TCoordinate, param2:TBounds) : void
      {
         param1.FX = param2.FX + param2.FWidth / 2;
         param1.FY = param2.FY + param2.FHeight / 2;
      }
      
      public static function CoordinateTranslate(param1:TCoordinate, param2:int, param3:int) : void
      {
         param1.FX += param2;
         param1.FY += param3;
      }
      
      public static function CoordinateDistance(param1:TCoordinate, param2:TCoordinate) : Number
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = param1.FX - param2.FX;
         _loc4_ = param1.FY - param2.FY;
         return Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_);
      }
      
      public static function CoordinateInterpolate(param1:TCoordinate, param2:TCoordinate, param3:TCoordinate, param4:Number) : void
      {
         param1.FX = param2.FX + (param3.FX - param2.FX) * param4;
         param1.FY = param2.FY + (param3.FY - param2.FY) * param4;
      }
      
      public static function BoundsSet(param1:TBounds, param2:int, param3:int, param4:int, param5:int) : void
      {
         param1.FX = param2;
         param1.FY = param3;
         param1.FWidth = param4;
         param1.FHeight = param5;
      }
      
      public static function BoundsSetSize(param1:TBounds, param2:int, param3:int) : void
      {
         param1.FWidth = param2;
         param1.FHeight = param3;
      }
      
      public static function BoundsInflate(param1:TBounds, param2:int, param3:int) : void
      {
         param1.FX -= param2;
         param1.FY -= param3;
         param1.FWidth += param2 * 2;
         param1.FHeight += param3 * 2;
      }
      
      public static function BoundsUnion(param1:TBounds, param2:TBounds, param3:TBounds) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         _loc4_ = Math.min(param2.FX,param3.FX);
         _loc5_ = Math.min(param2.FY,param3.FY);
         _loc6_ = Math.max(param2.FX + param2.FWidth,param3.FX + param3.FWidth);
         _loc7_ = Math.max(param2.FY + param2.FHeight,param3.FY + param3.FHeight);
         param1.FX = _loc4_;
         param1.FY = _loc5_;
         param1.FWidth = _loc6_ - _loc4_;
         param1.FHeight = _loc7_ - _loc5_;
      }
      
      public static function BoundsIntersect(param1:TBounds, param2:TBounds, param3:TBounds) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Boolean = false;
         _loc4_ = Math.max(param2.FX,param3.FX);
         _loc5_ = Math.max(param2.FY,param3.FY);
         _loc6_ = Math.min(param2.FX + param2.FWidth,param3.FX + param3.FWidth);
         _loc7_ = Math.min(param2.FY + param2.FHeight,param3.FY + param3.FHeight);
         _loc8_ = _loc6_ - _loc4_;
         _loc9_ = _loc7_ - _loc5_;
         _loc10_ = _loc8_ > 0 && _loc9_ > 0;
         if((_loc10_) && param1 != null)
         {
            param1.FX = _loc4_;
            param1.FY = _loc5_;
            param1.FWidth = _loc8_;
            param1.FHeight = _loc9_;
         }
         return _loc10_;
      }
      
      public static function BoundsContainsCoordinate(param1:TBounds, param2:TCoordinate) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         _loc3_ = param1.FX;
         _loc4_ = param1.FY;
         _loc5_ = param2.FX;
         _loc6_ = param2.FY;
         return _loc5_ >= _loc3_ && _loc5_ < _loc3_ + param1.FWidth && _loc6_ >= _loc4_ && _loc6_ < _loc4_ + param1.FHeight;
      }
      
      public static function GetScreenCoordinateByDisplayObject(param1:DisplayObject) : TCoordinate
      {
         var _loc2_:TCoordinate = null;
         if(param1.parent == null)
         {
            return new TCoordinate();
         }
         _loc2_ = GetScreenCoordinateByDisplayObject(param1.parent);
         _loc2_.X += param1.x;
         _loc2_.Y += param1.y;
         return _loc2_;
      }
      
      public static function CheckTwoBoundsCollision(param1:TBounds, param2:TBounds) : Boolean
      {
         if(param1.XEnd < param2.X || param1.YEnd < param2.Y || param1.X > param2.XEnd || param1.Y > param2.YEnd)
         {
            return false;
         }
         return true;
      }
   }
}

