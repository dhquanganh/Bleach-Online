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
   
   public class THyperStringFontSheetChatView extends THyperStringFontSheet
   {
      
      protected static const FONT_DefaultName:String = CONST_CHAT.FONT_DefaultName;
      
      protected static const FONT_DefaultSize:uint = CONST_CHAT.FONT_DefaultSize;
      
      protected static const FONT_DefaultColor:uint = CONST_CHAT.FONT_DefaultColor;
      
      protected static const FONT_ColorURL:uint = 4278223103;
      
      public function THyperStringFontSheetChatView()
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
         FFontEffectDefault.Shadowed = true;
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
         param2.Color = (param1 as THyperStringElementLinkCharacter).Color;
         param2.Underline = true;
         param3.Assign(FFontEffectDefault);
      }
      
      protected function FontingPerform_LinkHero(param1:THyperStringElement, param2:TFont, param3:TFontEffect) : void
      {
         param2.Assign(FFontDefault);
         param2.Color = (param1 as THyperStringElementLinkHero).Color;
         param2.Underline = true;
         param3.Assign(FFontEffectDefault);
      }
      
      protected function FontingPerform_LinkEvent(param1:THyperStringElement, param2:TFont, param3:TFontEffect) : void
      {
         param2.Assign(FFontDefault);
         param2.Underline = true;
         param3.Assign(FFontEffectDefault);
      }
      
      protected function FontingPerform_LinkURL(param1:THyperStringElement, param2:TFont, param3:TFontEffect) : void
      {
         param2.Assign(FFontDefault);
         param2.Color = FONT_ColorURL;
         param2.Underline = true;
         param3.Assign(FFontEffectDefault);
      }
   }
}

