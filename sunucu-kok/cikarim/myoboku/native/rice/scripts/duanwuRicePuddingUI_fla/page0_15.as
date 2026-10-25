package duanwuRicePuddingUI_fla
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
   import naruto.component.controls.ButtonNormalBlue;
   import naruto.component.controls.ButtonNormalYellow;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol74")]
   public dynamic class page0_15 extends MovieClip
   {
      
      public var mcHad0:MovieClip;
      
      public var mcHad1:MovieClip;
      
      public var mcHad2:MovieClip;
      
      public var mcHad3:MovieClip;
      
      public var btnGive:ButtonNormalBlue;
      
      public var mcHad4:MovieClip;
      
      public var linkLb:TextField;
      
      public var mcHad5:MovieClip;
      
      public var mcHad6:MovieClip;
      
      public var btnGet:ButtonNormalYellow;
      
      public function page0_15()
      {
         super();
         this.__setProp_btnGet_page0_();
         this.__setProp_btnGive_page0_();
      }
      
      internal function __setProp_btnGet_page0_() : *
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
         this.btnGet.label = "Obtain";
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
      
      internal function __setProp_btnGive_page0_() : *
      {
         try
         {
            this.btnGive["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnGive.clickSound = "click";
         this.btnGive.enabled = true;
         this.btnGive.label = "Gift";
         this.btnGive.overSound = "none";
         this.btnGive.visible = true;
         this.btnGive.clickSoundId = 0;
         this.btnGive.overSoundId = 0;
         try
         {
            this.btnGive["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

