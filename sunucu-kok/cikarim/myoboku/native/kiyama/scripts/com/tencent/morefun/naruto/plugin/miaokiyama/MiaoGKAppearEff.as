package com.tencent.morefun.naruto.plugin.miaokiyama
{
   import flash.display.MovieClip;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1142")]
   public dynamic class MiaoGKAppearEff extends MovieClip
   {
      
      public function MiaoGKAppearEff()
      {
         super();
         addFrameScript(50,this.frame51);
      }
      
      internal function frame51() : *
      {
         stop();
      }
   }
}

