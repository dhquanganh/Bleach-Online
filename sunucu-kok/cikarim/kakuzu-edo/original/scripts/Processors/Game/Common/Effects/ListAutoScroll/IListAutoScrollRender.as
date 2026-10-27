package Processors.Game.Common.Effects.ListAutoScroll
{
   import flash.display.Sprite;
   
   public interface IListAutoScrollRender
   {
      
      function get Substrate() : Sprite;
      
      function SetData(param1:IListAutoScrollDataRender) : void;
   }
}

