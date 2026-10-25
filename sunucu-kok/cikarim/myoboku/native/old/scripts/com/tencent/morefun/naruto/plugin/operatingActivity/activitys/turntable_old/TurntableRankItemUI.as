package com.tencent.morefun.naruto.plugin.operatingActivity.activitys.turntable_old
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol201")]
   public dynamic class TurntableRankItemUI extends MovieClip
   {
      
      public var playerNameTf:TextField;
      
      public var rankTf:TextField;
      
      public var rewards:MovieClip;
      
      public var friendValueTf:TextField;
      
      public function TurntableRankItemUI()
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

