package ui.plugin.operatingActivity.miaoback
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
   import naruto.component.controls.ButtonLittleYellow;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol40")]
   public dynamic class MiaoJieBanUI extends MovieClip
   {
      
      public var ninjaBox1:MovieClip;
      
      public var ninjaBox2:MovieClip;
      
      public var ninjaBox3:MovieClip;
      
      public var jbclose_btn:ButtonClose;
      
      public var timelb:TextField;
      
      public var btn_back:SimpleButton;
      
      public var dispatchInfo:MovieClip;
      
      public var yaoqingBtn:ButtonLittleYellow;
      
      public var ninjaBox0:MovieClip;
      
      public function MiaoJieBanUI()
      {
         super();
         this.__setProp_yaoqingBtn_();
      }
      
      internal function __setProp_yaoqingBtn_() : *
      {
         try
         {
            this.yaoqingBtn["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.yaoqingBtn.clickSound = "none";
         this.yaoqingBtn.enabled = true;
         this.yaoqingBtn.label = "邀 请";
         this.yaoqingBtn.overSound = "none";
         this.yaoqingBtn.visible = true;
         this.yaoqingBtn.clickSoundId = 0;
         this.yaoqingBtn.overSoundId = 0;
         try
         {
            this.yaoqingBtn["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

