package TurntableUI_old_fla
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
   
   [Embed(source="/_assets/assets.swf", symbol="symbol162")]
   public dynamic class getReward_mc_52 extends MovieClip
   {
      
      public var getRewardAll_btn:ButtonNormalYellow;
      
      public var luck_mc:MovieClip;
      
      public var rankListRect:MovieClip;
      
      public function getReward_mc_52()
      {
         super();
         this.__setProp_getRewardAll_btn_getReward_mc_();
      }
      
      internal function __setProp_getRewardAll_btn_getReward_mc_() : *
      {
         try
         {
            this.getRewardAll_btn["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.getRewardAll_btn.clickSound = "click";
         this.getRewardAll_btn.enabled = true;
         this.getRewardAll_btn.label = "One-Click Claim";
         this.getRewardAll_btn.overSound = "none";
         this.getRewardAll_btn.visible = true;
         this.getRewardAll_btn.clickSoundId = 0;
         this.getRewardAll_btn.overSoundId = 0;
         try
         {
            this.getRewardAll_btn["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

