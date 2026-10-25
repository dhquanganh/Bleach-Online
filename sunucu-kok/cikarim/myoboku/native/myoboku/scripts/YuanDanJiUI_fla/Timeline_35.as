package YuanDanJiUI_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol78")]
   public dynamic class Timeline_35 extends MovieClip
   {
      
      public function Timeline_35()
      {
         super();
         addFrameScript(0,this.frame1,59,this.frame60);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame60() : *
      {
         stop();
         this.dispatchEvent(new Event("PLAY_END"));
      }
   }
}

