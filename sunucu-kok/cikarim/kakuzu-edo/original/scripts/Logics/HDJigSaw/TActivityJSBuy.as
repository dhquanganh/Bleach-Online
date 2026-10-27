package Logics.HDJigSaw
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityJSBuy extends TActivityEntity
   {
      
      protected var FAward:uint;
      
      protected var FValue:uint;
      
      public function TActivityJSBuy(param1:uint)
      {
         super(param1);
      }
      
      public function get Award() : uint
      {
         return this.FAward;
      }
      
      public function set Award(param1:uint) : void
      {
         this.FAward = param1;
      }
      
      public function get Value() : uint
      {
         return this.FValue;
      }
      
      public function set Value(param1:uint) : void
      {
         this.FValue = param1;
      }
   }
}

