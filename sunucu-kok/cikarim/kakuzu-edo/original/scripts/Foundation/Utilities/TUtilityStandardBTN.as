package Foundation.Utilities
{
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class TUtilityStandardBTN
   {
      
      public static const FRAME_ENABLE:int = 1;
      
      public static const FRAME_OVER:int = 2;
      
      public static const FRAME_CLICK:int = 3;
      
      public static const FRAME_DISABLE:int = 4;
      
      public function TUtilityStandardBTN()
      {
         super();
         throw new Error("TUtilityStandardBTN Class Is Static Class Only");
      }
      
      protected static function OnMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = MovieClip(param1.currentTarget);
         if(_loc2_.currentFrame != FRAME_DISABLE)
         {
            _loc2_.gotoAndStop(FRAME_CLICK);
         }
      }
      
      protected static function OnMouseUp(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = MovieClip(param1.currentTarget);
         if(_loc2_.currentFrame != FRAME_DISABLE)
         {
            _loc2_.gotoAndStop(FRAME_ENABLE);
         }
      }
      
      protected static function OnMouseOver(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = MovieClip(param1.currentTarget);
         if(_loc2_.currentFrame != FRAME_DISABLE)
         {
            _loc2_.gotoAndStop(FRAME_OVER);
            _loc2_.addEventListener(MouseEvent.MOUSE_OUT,OnMouseOut);
         }
      }
      
      protected static function OnMouseOut(param1:MouseEvent) : void
      {
         var _loc2_:MovieClip = null;
         _loc2_ = MovieClip(param1.currentTarget);
         _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,OnMouseOut);
         if(_loc2_.currentFrame != FRAME_DISABLE)
         {
            _loc2_.gotoAndStop(FRAME_ENABLE);
         }
      }
      
      public static function SetBtnEventListener(param1:MovieClip, param2:Function = null) : void
      {
         param1.addEventListener(MouseEvent.MOUSE_DOWN,OnMouseDown);
         param1.addEventListener(MouseEvent.CLICK,param2);
         param1.addEventListener(MouseEvent.MOUSE_UP,OnMouseUp);
         param1.addEventListener(MouseEvent.MOUSE_OVER,OnMouseOver);
         param1.buttonMode = true;
         param1.mouseChildren = false;
      }
   }
}

