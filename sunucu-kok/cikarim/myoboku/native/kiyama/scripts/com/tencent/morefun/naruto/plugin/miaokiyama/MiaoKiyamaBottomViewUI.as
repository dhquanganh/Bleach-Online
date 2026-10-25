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
   import naruto.component.controls.ButtonLittle;
   import naruto.component.controls.ButtonLittleYellow;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol1366")]
   public dynamic class MiaoKiyamaBottomViewUI extends MovieClip
   {
      
      public var itemNumlb:TextField;
      
      public var hamaMC1:MovieClip;
      
      public var tishulb:TextField;
      
      public var hamaMC2:MovieClip;
      
      public var xianlb:TextField;
      
      public var hamaMC3:MovieClip;
      
      public var kanglb:TextField;
      
      public var deflb:TextField;
      
      public var onekeyBtn:ButtonLittleYellow;
      
      public var hamaMC4:MovieClip;
      
      public var lianjilb:TextField;
      
      public var hamaMC5:MovieClip;
      
      public var mcBg:MovieClip;
      
      public var stopOnekeyBtn:ButtonLittle;
      
      public var hplb:TextField;
      
      public var ctrlb:TextField;
      
      public var attlb:TextField;
      
      public var renlb:TextField;
      
      public var renshulb:TextField;
      
      public var baojilb:TextField;
      
      public var daojuicon:MovieClip;
      
      public var gainItemBtn:ButtonLittleYellow;
      
      public var baoshanglb:TextField;
      
      public var miaoGuanKaItemSP:MovieClip;
      
      public var hamaMC0:MovieClip;
      
      public function MiaoKiyamaBottomViewUI()
      {
         super();
         addFrameScript(0,this.frame1);
         this.__setProp_gainItemBtn_MiaoKiyamaBottomViewUI_();
         this.__setProp_stopOnekeyBtn_MiaoKiyamaBottomViewUI_();
         this.__setProp_onekeyBtn_MiaoKiyamaBottomViewUI_();
      }
      
      internal function __setProp_gainItemBtn_MiaoKiyamaBottomViewUI_() : *
      {
         try
         {
            this.gainItemBtn["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.gainItemBtn.clickSound = "none";
         this.gainItemBtn.enabled = true;
         this.gainItemBtn.label = "<b>Obtain Resources</b>";
         this.gainItemBtn.overSound = "none";
         this.gainItemBtn.visible = true;
         this.gainItemBtn.clickSoundId = 0;
         this.gainItemBtn.overSoundId = 0;
         try
         {
            this.gainItemBtn["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_stopOnekeyBtn_MiaoKiyamaBottomViewUI_() : *
      {
         try
         {
            this.stopOnekeyBtn["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.stopOnekeyBtn.clickSound = "none";
         this.stopOnekeyBtn.enabled = true;
         this.stopOnekeyBtn.label = "Interrupt Cultivation";
         this.stopOnekeyBtn.overSound = "none";
         this.stopOnekeyBtn.visible = true;
         this.stopOnekeyBtn.clickSoundId = 0;
         this.stopOnekeyBtn.overSoundId = 0;
         try
         {
            this.stopOnekeyBtn["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_onekeyBtn_MiaoKiyamaBottomViewUI_() : *
      {
         try
         {
            this.onekeyBtn["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.onekeyBtn.clickSound = "none";
         this.onekeyBtn.enabled = true;
         this.onekeyBtn.label = "<b>One-Click Cultivation</b>";
         this.onekeyBtn.overSound = "none";
         this.onekeyBtn.visible = true;
         this.onekeyBtn.clickSoundId = 0;
         this.onekeyBtn.overSoundId = 0;
         try
         {
            this.onekeyBtn["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function frame1() : *
      {
         this.mcBg.mouseEnabled = this.mcBg.mouseChildren = false;
      }
   }
}

