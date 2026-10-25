package ui.activity.tryLuck
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol3")]
   public dynamic class ItemAnimation extends MovieClip
   {
      
      public var itemContainer:MovieClip;
      
      public function ItemAnimation()
      {
         super();
         addFrameScript(31,this.frame32);
      }
      
      internal function frame32() : *
      {
         stop();
         dispatchEvent(new Event("itemAnimation_stop"));
      }
   }
}

