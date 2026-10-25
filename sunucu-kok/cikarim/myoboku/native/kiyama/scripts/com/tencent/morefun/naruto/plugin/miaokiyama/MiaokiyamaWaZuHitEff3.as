package com.tencent.morefun.naruto.plugin.miaokiyama
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1434")]
   public dynamic class MiaokiyamaWaZuHitEff3 extends MovieClip
   {
      
      public function MiaokiyamaWaZuHitEff3()
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

