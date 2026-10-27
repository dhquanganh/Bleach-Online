package ghostcat.display
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public interface IGBase extends IDisplayObject, IData, ICursorManagerClient, IToolTipManagerClient
   {
      
      function set enabled(param1:Boolean) : void;
      
      function get enabled() : Boolean;
      
      function set paused(param1:Boolean) : void;
      
      function get paused() : Boolean;
      
      function set owner(param1:DisplayObject) : void;
      
      function get owner() : DisplayObject;
      
      function set enabledTick(param1:Boolean) : void;
      
      function get enabledTick() : Boolean;
      
      function get position() : Point;
      
      function get oldPosition() : Point;
      
      function setPosition(param1:Point, param2:Boolean = false) : void;
      
      function destory() : void;
      
      function invalidatePosition() : void;
      
      function invalidateSize() : void;
      
      function invalidateDisplayList() : void;
      
      function vaildPosition(param1:Boolean = false) : void;
      
      function vaildSize(param1:Boolean = false) : void;
      
      function vaildDisplayList(param1:Boolean = false) : void;
   }
}

