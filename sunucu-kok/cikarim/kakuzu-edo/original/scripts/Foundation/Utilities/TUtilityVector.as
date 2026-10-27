package Foundation.Utilities
{
   import flash.display.BitmapData;
   import flash.utils.*;
   
   public class TUtilityVector
   {
      
      public function TUtilityVector()
      {
         super();
         throw new Error("UtilityVector Class Is Static Container Only");
      }
      
      public static function CloneBitmapDataVector(param1:Vector.<BitmapData>, param2:Vector.<BitmapData>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            param2[_loc3_] = param1[_loc3_].clone();
            _loc3_++;
         }
      }
      
      public static function CopyBitmapDataVector(param1:Vector.<BitmapData>, param2:Vector.<BitmapData>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(param1.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            param2[_loc3_] = param1[_loc3_];
            _loc3_++;
         }
      }
   }
}

