package TurntableUI_old_fla
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol128")]
   public dynamic class Timeline_16 extends MovieClip
   {
      
      public var mc:MovieClip;
      
      public function Timeline_16()
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

