package com.tencent.morefun.naruto.plugin.miaokiyama
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import naruto.component.controls.ButtonClose;
   import naruto.component.controls.ButtonNormalYellow;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol759")]
   public dynamic class MiaokiyamaBonusUI extends MovieClip
   {
      
      public var background:MovieClip;
      
      public var getBtn:ButtonNormalYellow;
      
      public var iconMC:MovieClip;
      
      public var close_btn:ButtonClose;
      
      public function MiaokiyamaBonusUI()
      {
         super();
         this.__setProp_getBtn_();
      }
      
      internal function __setProp_getBtn_() : *
      {
         try
         {
            this.getBtn["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.getBtn.clickSound = "click";
         this.getBtn.enabled = true;
         this.getBtn.label = "Claim Surprise";
         this.getBtn.overSound = "none";
         this.getBtn.visible = true;
         this.getBtn.clickSoundId = 0;
         this.getBtn.overSoundId = 0;
         try
         {
            this.getBtn["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

