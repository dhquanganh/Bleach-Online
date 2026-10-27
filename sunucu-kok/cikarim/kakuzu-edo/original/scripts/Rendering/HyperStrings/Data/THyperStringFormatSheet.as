package Rendering.HyperStrings.Data
{
   import Foundation.Registries.TRegistryClassAutomatic;
   import Foundation.Registries.TRegistryRoutine;
   import Foundation.Utilities.TUtilityRTTI;
   import Logics.HyperStrings.Elements.THyperStringElementTextual;
   
   public class THyperStringFormatSheet
   {
      
      protected var FFormattingClasses:TRegistryClassAutomatic;
      
      protected var FFormattingRoutines:TRegistryRoutine;
      
      public function THyperStringFormatSheet()
      {
         super();
         this.FFormattingClasses = new TRegistryClassAutomatic();
         this.FFormattingRoutines = new TRegistryRoutine();
         this.FormattingRegisterRoutines();
      }
      
      protected function FormattingRegisterRoutines() : void
      {
      }
      
      protected function FormattingRegisterRoutine(param1:Class, param2:Function) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = this.FFormattingClasses.Count;
         _loc4_ = this.FFormattingClasses.Register(param1);
         if(_loc4_ < _loc3_)
         {
            return;
         }
         this.FFormattingRoutines.Register(_loc4_,param2);
      }
      
      protected function FormattingPerform(param1:Class, param2:THyperStringElementTextual) : String
      {
         var _loc3_:int = 0;
         var _loc4_:Function = null;
         _loc3_ = this.FFormattingClasses.GetIndexByClass(param1);
         if(_loc3_ < 0)
         {
            _loc4_ = null;
         }
         else
         {
            _loc4_ = this.FFormattingRoutines.GetRoutineByIndex(_loc3_);
         }
         if(_loc4_ != null)
         {
            return _loc4_(param2);
         }
         return this.FormattingPerform_Default(param2);
      }
      
      protected function FormattingPerform_Default(param1:THyperStringElementTextual) : String
      {
         return param1.Text;
      }
      
      public function Format(param1:THyperStringElementTextual) : String
      {
         var _loc2_:Class = null;
         _loc2_ = TUtilityRTTI.GetClassByInstance(param1);
         return this.FormattingPerform(_loc2_,param1);
      }
   }
}

