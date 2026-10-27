package Processors.Game.ComponentNew
{
   import Foundation.Utilities.TUtilityMath;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   
   public class TUtilityMovieClip
   {
      
      public function TUtilityMovieClip()
      {
         super();
      }
      
      public static function StopMovieClipAction(param1:DisplayObject, param2:int = 0) : void
      {
         var _loc4_:MovieClip = null;
         var _loc3_:* = 0;
         if(param1 == null)
         {
            return;
         }
         if(param1 is MovieClip)
         {
            _loc4_ = param1 as MovieClip;
            _loc4_.tabEnabled = false;
            if(param2 != 0)
            {
               _loc4_.gotoAndStop(param2);
            }
            else
            {
               _loc4_.stop();
            }
            while(_loc3_ < _loc4_.numChildren)
            {
               StopMovieClipAction(_loc4_.getChildAt(_loc3_++));
            }
            return;
         }
      }
      
      public static function PlayMovieClipAction(param1:DisplayObject, param2:int = 0, param3:Boolean = false, param4:Boolean = true) : void
      {
         var _loc6_:MovieClip = null;
         var _loc5_:* = 0;
         if(param1 == null)
         {
            return;
         }
         _loc6_ = param1 as MovieClip;
         if(param4)
         {
            if(!(param1 is MovieClip))
            {
               return;
            }
            _loc6_.tabEnabled = false;
            if(param3)
            {
               param2 = TUtilityMath.RandomRange(1,_loc6_.totalFrames - 1);
            }
            if(param2 != 0)
            {
               _loc6_.gotoAndPlay(param2);
            }
            else
            {
               _loc6_.play();
            }
         }
         while(_loc5_ < _loc6_.numChildren)
         {
            PlayMovieClipAction(_loc6_.getChildAt(_loc5_++));
         }
      }
   }
}

