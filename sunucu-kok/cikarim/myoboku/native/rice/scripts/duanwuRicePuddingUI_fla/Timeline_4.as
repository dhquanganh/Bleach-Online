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
   import naruto.component.controls.CheckBox_1;
   import ui.activity.DuanwuRiceMateralIconUI;
   import ui.activity.DuanwuRiceMateralTxt1UI;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol127")]
   public dynamic class Timeline_4 extends MovieClip
   {
      
      public var txtCount:TextField;
      
      public var checkBox:CheckBox_1;
      
      public var mcTxt:DuanwuRiceMateralTxt1UI;
      
      public var mcIcon:DuanwuRiceMateralIconUI;
      
      public function Timeline_4()
      {
         super();
         this.__setProp_checkBox_();
      }
      
      internal function __setProp_checkBox_() : *
      {
         try
         {
            this.checkBox["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.checkBox.enabled = true;
         this.checkBox.label = "";
         this.checkBox.labelY = 3;
         this.checkBox.selected = false;
         this.checkBox.visible = true;
         this.checkBox.labelX = 28;
         try
         {
            this.checkBox["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

