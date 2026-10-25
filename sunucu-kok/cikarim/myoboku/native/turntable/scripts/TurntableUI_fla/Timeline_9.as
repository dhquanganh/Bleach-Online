package TurntableUI_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol123")]
   public dynamic class Timeline_9 extends MovieClip
   {
      
      public var mc:MovieClip;
      
      public function Timeline_9()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}

