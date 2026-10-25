package YuanDanJiUI_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol96")]
   public dynamic class Timeline_39 extends MovieClip
   {
      
      public function Timeline_39()
      {
         super();
         addFrameScript(0,this.frame1,29,this.frame30,69,this.frame70,109,this.frame110,149,this.frame150);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame30() : *
      {
         this.dispatchEvent(new Event("PLAY_END"));
      }
      
      internal function frame70() : *
      {
         this.dispatchEvent(new Event("PLAY_END"));
      }
      
      internal function frame110() : *
      {
         this.dispatchEvent(new Event("PLAY_END"));
      }
      
      internal function frame150() : *
      {
         this.dispatchEvent(new Event("PLAY_END"));
      }
   }
}

