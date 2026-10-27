package Foundation.Utilities
{
   import flash.display.BitmapData;
   
   public class TUtilityBitmap
   {
      
      public function TUtilityBitmap()
      {
         super();
         throw new Error("TUtilityBitmap Class Is Static Container Only");
      }
      
      public static function IsMouseOnNoAlphaPixel(param1:BitmapData, param2:int, param3:int, param4:uint = 128) : Boolean
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         _loc5_ = param1.getPixel32(param2,param3);
         _loc6_ = TUtilityColor.GetAlphaFromARGB(_loc5_);
         if(_loc6_ < param4)
         {
            return false;
         }
         return true;
      }
   }
}

