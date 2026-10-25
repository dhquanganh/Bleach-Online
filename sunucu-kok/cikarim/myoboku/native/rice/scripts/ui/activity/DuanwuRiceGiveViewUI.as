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
   import naruto.component.controls.Background_4;
   import naruto.component.controls.ButtonClose;
   import naruto.component.controls.ButtonLittle;
   import naruto.component.controls.TitleBar_3;
   
   [Embed(source="/_assets/assets.swf", symbol="symbol129")]
   public dynamic class DuanwuRiceGiveViewUI extends MovieClip
   {
      
      public var item5:MovieClip;
      
      public var background:Background_4;
      
      public var item6:MovieClip;
      
      public var txtDsc:TextField;
      
      public var __id1_:TitleBar_3;
      
      public var btnGiev:ButtonLittle;
      
      public var closeButton:ButtonClose;
      
      public var item0:MovieClip;
      
      public var item1:MovieClip;
      
      public var item2:MovieClip;
      
      public var endTime:TextField;
      
      public var friendName:TextField;
      
      public var item3:MovieClip;
      
      public var item4:MovieClip;
      
      public function DuanwuRiceGiveViewUI()
      {
         super();
         this.__setProp___id1__DuanwuRiceGiveViewUI_BG_0();
         this.__setProp_btnGiev_DuanwuRiceGiveViewUI_();
      }
      
      internal function __setProp___id1__DuanwuRiceGiveViewUI_BG_0() : *
      {
         try
         {
            this.__id1_["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.__id1_.enabled = true;
         this.__id1_.label = "Ingredients";
         this.__id1_.visible = true;
         try
         {
            this.__id1_["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
      
      internal function __setProp_btnGiev_DuanwuRiceGiveViewUI_() : *
      {
         try
         {
            this.btnGiev["componentInspectorSetting"] = true;
         }
         catch(e:Error)
         {
         }
         this.btnGiev.clickSound = "none";
         this.btnGiev.enabled = true;
         this.btnGiev.label = "Gift";
         this.btnGiev.overSound = "none";
         this.btnGiev.visible = true;
         this.btnGiev.clickSoundId = 0;
         this.btnGiev.overSoundId = 0;
         try
         {
            this.btnGiev["componentInspectorSetting"] = false;
         }
         catch(e:Error)
         {
         }
      }
   }
}

