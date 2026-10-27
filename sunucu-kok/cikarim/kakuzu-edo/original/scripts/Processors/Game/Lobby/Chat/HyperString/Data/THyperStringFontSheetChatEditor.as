package Processors.Game.Lobby.Chat.HyperString.Data
{
   import Foundation.Fonts.TFont;
   import Foundation.Fonts.TFontEffect;
   import Logics.HyperStrings.Elements.THyperStringElement;
   import Logics.HyperStrings.Elements.THyperStringElementLinkCharacter;
   import Logics.HyperStrings.Elements.THyperStringElementLinkEvent;
   import Logics.HyperStrings.Elements.THyperStringElementLinkHero;
   import Logics.HyperStrings.Elements.THyperStringElementLinkURL;
   import Logics.HyperStrings.Elements.THyperStringElementText;
   import Rendering.HyperStrings.Data.THyperStringFontSheet;
   import Resources.Constants.CONST_CHAT;
   
   public class THyperStringFontSheetChatEditor extends THyperStringFontSheet
   {
      
      protected static const FONT_DefaultName:String = CONST_CHAT.FONT_DefaultName;
      
      protected static const FONT_DefaultSize:uint = CONST_CHAT.FONT_DefaultSize;
      
      protected static const FONT_DefaultColor:uint = CONST_CHAT.FONT_DefaultColor;
      
      protected static const FONTEFFECT_DefaultOutlineSize:uint = 1;
      
      protected static const FONTEFFECT_DefaultOutlineIntensity:uint = 1;
      
      protected static const FONTEFFECT_DefaultShadowDistance:uint = 1;
      
      public function THyperStringFontSheetChatEditor()
      {
         super();
      }
      
      override protected function ConstructFonts() : void
      {
         super.ConstructFonts();
         FFontDefault.Name = FONT_DefaultName;
         FFontDefault.Size = FONT_DefaultSize;
         FFontDefault.Color = FONT_DefaultColor;
      }
      
      override protected function ConstructFontEffects() : void
      {
         super.ConstructFontEffects();
         FFontEffectDefault.AntiAliased = true;
         FFontEffectDefault.Outlined = true;
         FFontEffectDefault.OutlineSize = FONTEFFECT_DefaultOutlineSize;
         FFontEffectDefault.OutlineIntensity = FONTEFFECT_DefaultOutlineIntensity;
         FFontEffectDefault.Shadowed = true;
         FFontEffectDefault.ShadowDistance = FONTEFFECT_DefaultShadowDistance;
      }
      
      override protected function FontingRegisterRoutines() : void
      {
         FontingRegisterRoutine(THyperStringElementText,this.FontingPerform_Text);
         FontingRegisterRoutine(THyperStringElementLinkCharacter,this.FontingPerform_LinkCharacter);
         FontingRegisterRoutine(THyperStringElementLinkURL,this.FontingPerform_LinkURL);
         FontingRegisterRoutine(THyperStringElementLinkHero,this.FontingPerform_LinkHero);
         FontingRegisterRoutine(THyperStringElementLinkEvent,this.FontingPerform_LinkEvent);
      }
      
      protected function FontingPerform_Text(param1:THyperStringElement, param2:TFont, param3:TFontEffect) : void
      {
         param2.Assign(FFontDefault);
         param3.Assign(FFontEffectDefault);
      }
      
      protected function FontingPerform_LinkCharacter(param1:THyperStringElement, param2:TFont, param3:TFontEffect) : void
      {
         param2.Assign(FFontDefault);
         param2.Color = 4283045842;
         param2.Underline = true;
         param3.Assign(FFontEffectDefault);
      }
      
      protected function FontingPerform_LinkHero(param1:THyperStringElement, param2:TFont, param3:TFontEffect) : void
      {
         param2.Assign(FFontDefault);
         param2.Color = 4283045842;
         param2.Underline = true;
         param3.Assign(FFontEffectDefault);
      }
      
      protected function FontingPerform_LinkEvent(param1:THyperStringElement, param2:TFont, param3:TFontEffect) : void
      {
         param2.Assign(FFontDefault);
         param2.Color = 4283045842;
         param2.Underline = true;
         param3.Assign(FFontEffectDefault);
      }
      
      protected function FontingPerform_LinkURL(param1:THyperStringElement, param2:TFont, param3:TFontEffect) : void
      {
         param2.Assign(FFontDefault);
         param2.Underline = true;
         param3.Assign(FFontEffectDefault);
      }
   }
}

