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
   import naruto.component.controls.ButtonClose;
   import naruto.component.controls.ButtonNormalYellow;
   import ui.activity.tryLuck.ItemAnimation;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol146")]
   public dynamic class TryLuckPanelUI extends Sprite
   {
      
      public var itemRect2:MovieClip;
      
      public var itemRect0:MovieClip;
      
      public var tryButton:SimpleButton;
      
      public var rollAnimation:MovieClip;
      
      public var itemRect1:MovieClip;
      
      public var itemAnimation:ItemAnimation;
      
      public var awardButton:ButtonNormalYellow;
      
      public var tf_times:TextField;
      
      public var closeButton:ButtonClose;
      
      public var light:MovieClip;
      
      public function TryLuckPanelUI()
      {
         super();
         this.__setProp_awardButton_TryLuckPanelUI_content_0();
      }
      
      internal function __setProp_awardButton_TryLuckPanelUI_content_0() : *
      {
         try
         {
            this.awardButton["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.awardButton.clickSound = "click";
         this.awardButton.enabled = true;
         this.awardButton.label = "Claim";
         this.awardButton.overSound = "none";
         this.awardButton.visible = true;
         this.awardButton.clickSoundId = 0;
         this.awardButton.overSoundId = 0;
         try
         {
            this.awardButton["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

