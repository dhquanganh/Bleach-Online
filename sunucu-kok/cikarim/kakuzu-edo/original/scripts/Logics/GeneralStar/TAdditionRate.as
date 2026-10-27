package Logics.GeneralStar
{
   public class TAdditionRate
   {
      
      protected var TKey:int;
      
      protected var TValue:int;
      
      public function TAdditionRate()
      {
         super();
      }
      
      public function get Key() : int
      {
         return this.TKey;
      }
      
      public function set Key(param1:int) : void
      {
         this.TKey = param1;
      }
      
      public function get Value() : int
      {
         return this.TValue;
      }
      
      public function set Value(param1:int) : void
      {
         this.TValue = param1;
      }
   }
}

