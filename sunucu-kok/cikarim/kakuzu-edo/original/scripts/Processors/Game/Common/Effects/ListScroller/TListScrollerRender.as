package Processors.Game.Common.Effects.ListScroller
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class TListScrollerRender extends Sprite
   {
      
      protected var FSpace:int;
      
      protected var FOffsetX:int;
      
      protected var FOffsetY:int;
      
      protected var FCurCount:int;
      
      protected var FItems:Vector.<IListItemScrollerRender>;
      
      public function TListScrollerRender(param1:int, param2:int, param3:int)
      {
         super();
         this.FSpace = param1;
         this.FOffsetX = param2;
         this.FOffsetY = param3;
         this.FItems = new Vector.<IListItemScrollerRender>();
      }
      
      public function AddItem(param1:IListItemScrollerRender) : void
      {
         param1.x = this.FOffsetX + (param1.width + this.FSpace) * this.FCurCount;
         param1.y = this.FOffsetY;
         this.addChild(param1 as DisplayObject);
         this.FItems[this.FCurCount] = param1;
         ++this.FCurCount;
      }
      
      public function Reset() : void
      {
         this.removeChildren();
         this.FCurCount = 0;
      }
   }
}

