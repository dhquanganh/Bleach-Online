package Logics.HDServerPay
{
   public class TActivitySPAwards
   {
      
      protected var FValue:uint;
      
      protected var FPrompt:String;
      
      protected var FAwardDesc:String;
      
      public function TActivitySPAwards()
      {
         super();
         this.FPrompt = "";
         this.FAwardDesc = "";
      }
      
      public function get Value() : uint
      {
         return this.FValue;
      }
      
      public function set Value(param1:uint) : void
      {
         this.FValue = param1;
      }
      
      public function get Prompt() : String
      {
         return this.FPrompt;
      }
      
      public function set Prompt(param1:String) : void
      {
         this.FPrompt = param1;
      }
      
      public function get AwardDesc() : String
      {
         return this.FAwardDesc;
      }
      
      public function set AwardDesc(param1:String) : void
      {
         this.FAwardDesc = param1;
      }
   }
}

