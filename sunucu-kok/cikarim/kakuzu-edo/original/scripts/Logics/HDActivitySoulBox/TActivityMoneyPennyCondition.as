package Logics.HDActivitySoulBox
{
   public class TActivityMoneyPennyCondition
   {
      
      protected var FCondition:uint;
      
      protected var FRate:uint;
      
      protected var FPrompt:String;
      
      public function TActivityMoneyPennyCondition()
      {
         super();
         this.FPrompt = "";
      }
      
      public function get Condition() : uint
      {
         return this.FCondition;
      }
      
      public function set Condition(param1:uint) : void
      {
         this.FCondition = param1;
      }
      
      public function get Rate() : uint
      {
         return this.FRate;
      }
      
      public function set Rate(param1:uint) : void
      {
         this.FRate = param1;
      }
      
      public function get Prompt() : String
      {
         return this.FPrompt;
      }
      
      public function set Prompt(param1:String) : void
      {
         this.FPrompt = param1;
      }
   }
}

