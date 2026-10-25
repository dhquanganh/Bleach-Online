package com.tencent.morefun.naruto.plugin.miaokiyama
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1456")]
   public dynamic class MiaokiyamaHitEff1 extends MovieClip
   {
      
      public function MiaokiyamaHitEff1()
      {
         super();
         addFrameScript(25,this.frame26);
      }
      
      internal function frame26() : *
      {
         stop();
         this.dispatchEvent(new Event("miaoHitEff_end"));
      }
   }
}

