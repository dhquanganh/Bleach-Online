package plugin.operatingActivity.yuanDanJi
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol311")]
   public dynamic class MovePointEffUI extends MovieClip
   {
      
      public function MovePointEffUI()
      {
         super();
         addFrameScript(12,this.frame13);
      }
      
      internal function frame13() : *
      {
         this.dispatchEvent(new Event("PLAY_END"));
      }
   }
}

