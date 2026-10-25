package YuanDanJiUI_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol66")]
   public dynamic class Timeline_32 extends MovieClip
   {
      
      public function Timeline_32()
      {
         super();
         addFrameScript(0,this.frame1,9,this.frame10);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame10() : *
      {
         this.dispatchEvent(new Event("PLAY_END"));
      }
   }
}

