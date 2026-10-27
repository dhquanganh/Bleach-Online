package Logics.HDRandCard
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityRCScore extends TActivityEntity
   {
      
      protected var FGetType:uint;
      
      protected var FCondition:uint;
      
      protected var FNum:uint;
      
      public function TActivityRCScore(param1:uint)
      {
         super(param1);
      }
      
      public function get GetType() : uint
      {
         return this.FGetType;
      }
      
      public function set GetType(param1:uint) : void
      {
         this.FGetType = param1;
      }
      
      public function get Condition() : uint
      {
         return this.FCondition;
      }
      
      public function set Condition(param1:uint) : void
      {
         this.FCondition = param1;
      }
      
      public function get Num() : uint
      {
         return this.FNum;
      }
      
      public function set Num(param1:uint) : void
      {
         this.FNum = param1;
      }
   }
}

