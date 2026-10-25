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
   import naruto.component.controls.ButtonLittleYellow;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol57")]
   public dynamic class MiaoJieBanTaskUI extends MovieClip
   {
      
      public var lingquBonusBtn:ButtonLittleYellow;
      
      public var taskIcon:MovieClip;
      
      public var desclb:TextField;
      
      public function MiaoJieBanTaskUI()
      {
         super();
         this.__setProp_lingquBonusBtn_();
      }
      
      internal function __setProp_lingquBonusBtn_() : *
      {
         try
         {
            this.lingquBonusBtn["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.lingquBonusBtn.clickSound = "none";
         this.lingquBonusBtn.enabled = true;
         this.lingquBonusBtn.label = "领 取";
         this.lingquBonusBtn.overSound = "none";
         this.lingquBonusBtn.visible = true;
         this.lingquBonusBtn.clickSoundId = 0;
         this.lingquBonusBtn.overSoundId = 0;
         try
         {
            this.lingquBonusBtn["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

