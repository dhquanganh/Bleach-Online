package com.tencent.morefun.naruto.plugin.miaokiyama
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1422")]
   public dynamic class MiaokiyamaWaZuHitEff4 extends MovieClip
   {
      
      public function MiaokiyamaWaZuHitEff4()
      {
         super();
         addFrameScript(26,this.frame27);
      }
      
      internal function frame27() : *
      {
         stop();
         this.dispatchEvent(new Event("miaoHitEff_end"));
      }
   }
}

