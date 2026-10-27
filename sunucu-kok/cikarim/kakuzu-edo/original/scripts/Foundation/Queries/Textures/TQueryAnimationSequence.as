package Foundation.Queries.Textures
{
   import Foundation.Queries.TQueryUnknown;
   import Foundation.Resources.Textures.TAnimationSequence;
   
   public class TQueryAnimationSequence extends TQueryUnknown
   {
      
      protected var FValue:TAnimationSequence;
      
      public function TQueryAnimationSequence()
      {
         super();
         this.FValue = null;
      }
      
      public function get Value() : TAnimationSequence
      {
         return this.FValue;
      }
      
      public function set Value(param1:TAnimationSequence) : void
      {
         this.FValue = param1;
      }
   }
}

