package Rendering.HyperStrings.Data
{
   import Foundation.Fonts.TFont;
   import Foundation.Fonts.TFontEffect;
   import Foundation.Registries.TRegistryClassAutomatic;
   import Foundation.Registries.TRegistryRoutine;
   import Foundation.Utilities.TUtilityRTTI;
   import Logics.HyperStrings.Elements.THyperStringElement;
   
   public class THyperStringFontSheet
   {
      
      protected static const FONTCOLOR_Default:uint = 4278190080;
      
      protected var FFontingClasses:TRegistryClassAutomatic;
      
      protected var FFontingRoutines:TRegistryRoutine;
      
      protected var FFontDefault:TFont;
      
      protected var FFontEffectDefault:TFontEffect;
      
      public function THyperStringFontSheet()
      {
         super();
         this.ConstructFonts();
         this.ConstructFontEffects();
         this.FFontingClasses = new TRegistryClassAutomatic();
         this.FFontingRoutines = new TRegistryRoutine();
         this.FontingRegisterRoutines();
      }
      
      protected function ConstructFonts() : void
      {
         this.FFontDefault = new TFont();
         this.FFontDefault.Name = "Tahoma";
         this.FFontDefault.Size = 12;
         this.FFontDefault.Color = FONTCOLOR_Default;
      }
      
      protected function ConstructFontEffects() : void
      {
         this.FFontEffectDefault = new TFontEffect();
      }
      
      protected function FontingRegisterRoutines() : void
      {
      }
      
      protected function FontingRegisterRoutine(param1:Class, param2:Function) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = this.FFontingClasses.Count;
         _loc4_ = this.FFontingClasses.Register(param1);
         if(_loc4_ < _loc3_)
         {
            return;
         }
         this.FFontingRoutines.Register(_loc4_,param2);
      }
      
      protected function FontingPerform(param1:THyperStringElement, param2:TFont, param3:TFontEffect) : void
      {
         var _loc4_:Class = null;
         var _loc5_:int = 0;
         var _loc6_:Function = null;
         _loc4_ = TUtilityRTTI.GetClassByInstance(param1);
         _loc5_ = this.FFontingClasses.GetIndexByClass(_loc4_);
         if(_loc5_ < 0)
         {
            _loc6_ = null;
         }
         else
         {
            _loc6_ = this.FFontingRoutines.GetRoutineByIndex(_loc5_);
         }
         if(_loc6_ != null)
         {
            _loc6_(param1,param2,param3);
         }
         else
         {
            this.FontingPerform_Default(param1,param2,param3);
         }
      }
      
      protected function FontingPerform_Default(param1:THyperStringElement, param2:TFont, param3:TFontEffect) : void
      {
         param2.Assign(this.FFontDefault);
         param3.Assign(this.FFontEffectDefault);
      }
      
      public function FlushFont(param1:THyperStringElement, param2:TFont, param3:TFontEffect) : void
      {
         this.FontingPerform(param1,param2,param3);
      }
   }
}

