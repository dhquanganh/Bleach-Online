package YuanDanJiUI_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol82")]
   public dynamic class content_38 extends MovieClip
   {
      
      public function content_38()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame5() : *
      {
         this.dispatchEvent(new Event("HIT"));
      }
   }
}

