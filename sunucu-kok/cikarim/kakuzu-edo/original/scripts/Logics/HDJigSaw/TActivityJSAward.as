package Logics.HDJigSaw
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityJSAward extends TActivityEntity
   {
      
      protected var FAward:uint;
      
      protected var FValue:uint;
      
      protected var FStatus:int;
      
      public function TActivityJSAward(param1:uint)
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
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
   }
}

