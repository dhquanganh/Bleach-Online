package Processors.Game.Battle.Effect
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class TPoolBitmap
   {
      
      protected static var FPoolBitmap:Vector.<Bitmap> = new Vector.<Bitmap>();
      
      protected static var FPoolSprite:Vector.<Sprite> = new Vector.<Sprite>();
      
      public function TPoolBitmap()
      {
         super();
      }
      
      public static function GetBitmap() : Bitmap
      {
         var _loc1_:Bitmap = null;
         if(FPoolBitmap.length > 0)
         {
            _loc1_ = FPoolBitmap.pop();
         }
         else
         {
            _loc1_ = new Bitmap();
         }
         return _loc1_;
      }
      
      public static function SaveBitmap(param1:Bitmap) : void
      {
         var _loc2_:int = 0;
         if(param1 == null)
         {
            return;
         }
         _loc2_ = FPoolBitmap.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return;
         }
         if(param1.parent != null)
         {
            param1.parent.removeChild(param1);
         }
         param1.x = 0;
         param1.y = 0;
         param1.bitmapData = null;
         param1.scaleX = 1;
         param1.scaleY = 1;
         FPoolBitmap.push(param1);
      }
      
      public static function GetBitmapSprite() : Sprite
      {
         var _loc1_:Sprite = null;
         if(FPoolSprite.length > 0)
         {
            _loc1_ = FPoolSprite.pop();
         }
         else
         {
            _loc1_ = new Sprite();
            _loc1_.addChild(new Bitmap());
            _loc1_.mouseChildren = false;
            _loc1_.mouseEnabled = false;
         }
         return _loc1_;
      }
      
      public static function SaveBitmapSprite(param1:Sprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Bitmap = null;
         if(param1 == null)
         {
            return;
         }
         _loc2_ = FPoolSprite.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return;
         }
         if(param1.parent != null)
         {
            param1.parent.removeChild(param1);
         }
         param1.mouseChildren = false;
         param1.mouseEnabled = false;
         _loc3_ = param1.getChildAt(0) as Bitmap;
         _loc3_.x = 0;
         _loc3_.y = 0;
         _loc3_.bitmapData = null;
         FPoolSprite.push(param1);
      }
   }
}

