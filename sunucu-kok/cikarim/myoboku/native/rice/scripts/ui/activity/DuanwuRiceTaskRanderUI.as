package ui.activity
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
   import naruto.component.controls.ButtonNormalYellow;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol24")]
   public dynamic class DuanwuRiceTaskRanderUI extends MovieClip
   {
      
      public var txtDsc:TextField;
      
      public var btnGo:ButtonLittle;
      
      public var mcName:MovieClip;
      
      public var btnGet:ButtonNormalYellow;
      
      public function DuanwuRiceTaskRanderUI()
      {
         super();
         this.__setProp_btnGo_DuanwuRiceTaskRanderUI_();
         this.__setProp_btnGet_DuanwuRiceTaskRanderUI_();
      }
      
      internal function __setProp_btnGo_DuanwuRiceTaskRanderUI_() : *
      {
         try
         {
            this.btnGo["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnGo.clickSound = "none";
         this.btnGo.enabled = true;
         this.btnGo.label = "Go";
         this.btnGo.overSound = "none";
         this.btnGo.visible = true;
         this.btnGo.clickSoundId = 0;
         this.btnGo.overSoundId = 0;
         try
         {
            this.btnGo["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_btnGet_DuanwuRiceTaskRanderUI_() : *
      {
         try
         {
            this.btnGet["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnGet.clickSound = "click";
         this.btnGet.enabled = true;
         this.btnGet.label = "Claim";
         this.btnGet.overSound = "none";
         this.btnGet.visible = true;
         this.btnGet.clickSoundId = 0;
         this.btnGet.overSoundId = 0;
         try
         {
            this.btnGet["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

