package Logics.InteractionLog
{
   import Foundation.Common.Stubs.TStubReferences;
   import Foundation.Common.TEntity64;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TInteractionLog extends TEntity64
   {
      
      protected var FTime:uint;
      
      protected var FHtmlText:String;
      
      protected var FStubReferences:TStubReferences;
      
      public function TInteractionLog(param1:uint, param2:uint)
      {
         super(param1,param2);
         this.FStubReferences = new TStubReferences(this);
         this.FHtmlText = "";
      }
      
      LogicsSpace function Coerce(param1:uint, param2:uint) : void
      {
         FIdentifier0 = param1;
         FIdentifier1 = param2;
      }
      
      public function get StubReferences() : TStubReferences
      {
         return this.FStubReferences;
      }
      
      public function get Time() : uint
      {
         return this.FTime;
      }
      
      public function set Time(param1:uint) : void
      {
         this.FTime = param1;
      }
      
      public function get HtmlText() : String
      {
         return this.FHtmlText;
      }
      
      public function set HtmlText(param1:String) : void
      {
         this.FHtmlText = param1;
      }
      
      public function Reset() : void
      {
         this.FTime = 0;
         this.FHtmlText = "";
         FIdentifier0 = 0;
         FIdentifier1 = 0;
      }
   }
}

