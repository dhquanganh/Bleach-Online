package YuanDanJiUI_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol179")]
   public dynamic class itemAnimation_60 extends MovieClip
   {
      
      public var itemContainer:MovieClip;
      
      public function itemAnimation_60()
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

