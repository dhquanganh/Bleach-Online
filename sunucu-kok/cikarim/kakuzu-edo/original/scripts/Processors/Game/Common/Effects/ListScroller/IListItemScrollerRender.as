package Processors.Game.Common.Effects.ListScroller
{
   public interface IListItemScrollerRender
   {
      
      function SetData(... rest) : void;
      
      function get x() : Number;
      
      function set x(param1:Number) : void;
      
      function get y() : Number;
      
      function set y(param1:Number) : void;
      
      function get width() : Number;
      
      function set width(param1:Number) : void;
      
      function get height() : Number;
      
      function set height(param1:Number) : void;
   }
}

