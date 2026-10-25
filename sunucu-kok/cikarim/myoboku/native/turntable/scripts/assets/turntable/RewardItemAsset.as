package assets.turntable
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
   import naruto.component.controls.ButtonNormalYellow;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol152")]
   public dynamic class RewardItemAsset extends MovieClip
   {
      
      public var get_btn:ButtonNormalYellow;
      
      public var tf:TextField;
      
      public function RewardItemAsset()
      {
         super();
         this.__setProp_get_btn_RewardItemAsset_();
      }
      
      internal function __setProp_get_btn_RewardItemAsset_() : *
      {
         try
         {
            this.get_btn["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.get_btn.clickSound = "click";
         this.get_btn.enabled = true;
         this.get_btn.label = "Claimed";
         this.get_btn.overSound = "none";
         this.get_btn.visible = true;
         this.get_btn.clickSoundId = 0;
         this.get_btn.overSoundId = 0;
         try
         {
            this.get_btn["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

