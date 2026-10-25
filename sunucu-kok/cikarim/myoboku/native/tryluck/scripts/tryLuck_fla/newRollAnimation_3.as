package tryLuck_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol44")]
   public dynamic class newRollAnimation_3 extends MovieClip
   {
      
      public function newRollAnimation_3()
      {
         super();
         addFrameScript(199,this.frame200,227,this.frame228,278,this.frame279);
      }
      
      internal function frame200() : *
      {
         dispatchEvent(new Event("stop1"));
      }
      
      internal function frame228() : *
      {
         dispatchEvent(new Event("stop0"));
      }
      
      internal function frame279() : *
      {
         dispatchEvent(new Event("stop2"));
      }
   }
}

