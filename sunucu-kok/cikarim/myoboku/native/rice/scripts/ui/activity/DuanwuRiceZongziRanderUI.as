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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol6")]
   public dynamic class DuanwuRiceZongziRanderUI extends MovieClip
   {
      
      public var mcComplete:MovieClip;
      
      public var btnMake:ButtonLittle;
      
      public var btnGet:ButtonNormalYellow;
      
      public function DuanwuRiceZongziRanderUI()
      {
         super();
         this.__setProp_btnMake_DuanwuRiceZongziRanderUI_();
         this.__setProp_btnGet_DuanwuRiceZongziRanderUI_();
      }
      
      internal function __setProp_btnMake_DuanwuRiceZongziRanderUI_() : *
      {
         try
         {
            this.btnMake["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnMake.clickSound = "none";
         this.btnMake.enabled = true;
         this.btnMake.label = "Produce";
         this.btnMake.overSound = "none";
         this.btnMake.visible = true;
         this.btnMake.clickSoundId = 0;
         this.btnMake.overSoundId = 0;
         try
         {
            this.btnMake["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_btnGet_DuanwuRiceZongziRanderUI_() : *
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

