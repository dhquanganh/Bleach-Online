package com.tencent.morefun.naruto.plugin.operatingActivity.activitys.turntable_old
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
   import naruto.component.controls.Background_4;
   import naruto.component.controls.ButtonClose;
   import naruto.component.controls.TitleBar_1;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol188")]
   public dynamic class ruleViewUI extends MovieClip
   {
      
      public var rule:TextField;
      
      public var background:Background_4;
      
      public var __id0_:TitleBar_1;
      
      public var closeButton:ButtonClose;
      
      public function ruleViewUI()
      {
         super();
         this.__setProp___id0__ruleViewUI_();
      }
      
      internal function __setProp___id0__ruleViewUI_() : *
      {
         try
         {
            this.__id0_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.__id0_.enabled = true;
         this.__id0_.label = "rule";
         this.__id0_.visible = true;
         try
         {
            this.__id0_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

