package Logics.HyperStrings.Elements
{
   import Foundation.Common.TBounds;
   
   public class THyperStringElementMonolithic extends THyperStringElement
   {
      
      public function THyperStringElementMonolithic()
      {
         super();
      }
      
      protected function RenderingPerform(param1:TBounds) : void
      {
      }
      
      public function Evaluate(param1:TBounds) : void
      {
      }
      
      public function Render(param1:TBounds) : void
      {
         this.RenderingPerform(param1);
      }
   }
}

