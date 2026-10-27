package Logics.HDJigSaw
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityJSScore extends TActivityEntity
   {
      
      protected var FScore:uint;
      
      public function TActivityJSScore(param1:uint)
      {
         super(param1);
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
   }
}

