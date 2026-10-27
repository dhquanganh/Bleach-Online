package Logics.HDServerPay
{
   public class TActivitySPPrompts
   {
      
      protected var FPromptScore:String;
      
      protected var FPromptHeroCondition:String;
      
      protected var FPromptNeedScore:String;
      
      protected var FPrompt0:String;
      
      protected var FPrompt1:String;
      
      protected var FPrompt2:String;
      
      protected var FPrompt3:String;
      
      protected var FPrompt4:String;
      
      protected var FPrompt5:String;
      
      protected var FPrompt6:String;
      
      protected var FPrompt7:String;
      
      protected var FPrompt8:String;
      
      protected var FPrompt9:String;
      
      public function TActivitySPPrompts(param1:Object)
      {
         super();
         if(param1.promptScore != null)
         {
            this.FPromptScore = param1.promptScore;
         }
         if(param1.promptHeroCondition != null)
         {
            this.FPromptHeroCondition = param1.promptHeroCondition;
         }
         if(param1.promptNeedScore != null)
         {
            this.FPromptNeedScore = param1.promptNeedScore;
         }
         if(param1.prompt0 != null)
         {
            this.FPrompt0 = param1.prompt0;
         }
         if(param1.prompt1 != null)
         {
            this.FPrompt1 = param1.prompt1;
         }
         if(param1.prompt2 != null)
         {
            this.FPrompt2 = param1.prompt2;
         }
         if(param1.prompt3 != null)
         {
            this.FPrompt3 = param1.prompt3;
         }
         if(param1.prompt4 != null)
         {
            this.FPrompt4 = param1.prompt4;
         }
         if(param1.prompt5 != null)
         {
            this.FPrompt5 = param1.prompt5;
         }
         if(param1.prompt6 != null)
         {
            this.FPrompt6 = param1.prompt6;
         }
         if(param1.prompt7 != null)
         {
            this.FPrompt7 = param1.prompt7;
         }
         if(param1.prompt8 != null)
         {
            this.FPrompt8 = param1.prompt8;
         }
         if(param1.prompt9 != null)
         {
            this.FPrompt9 = param1.prompt9;
         }
      }
      
      public function get PromptScore() : String
      {
         return this.FPromptScore;
      }
      
      public function get PromptHeroCondition() : String
      {
         return this.FPromptHeroCondition;
      }
      
      public function get PromptNeedScore() : String
      {
         return this.FPromptNeedScore;
      }
      
      public function get Prompt0() : String
      {
         return this.FPrompt0;
      }
      
      public function get Prompt1() : String
      {
         return this.FPrompt1;
      }
      
      public function get Prompt2() : String
      {
         return this.FPrompt2;
      }
      
      public function get Prompt3() : String
      {
         return this.FPrompt3;
      }
      
      public function get Prompt4() : String
      {
         return this.FPrompt4;
      }
      
      public function get Prompt5() : String
      {
         return this.FPrompt5;
      }
      
      public function get Prompt6() : String
      {
         return this.FPrompt6;
      }
      
      public function get Prompt7() : String
      {
         return this.FPrompt7;
      }
      
      public function get Prompt8() : String
      {
         return this.FPrompt8;
      }
      
      public function get Prompt9() : String
      {
         return this.FPrompt9;
      }
   }
}

