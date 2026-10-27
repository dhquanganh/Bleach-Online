package Logics.GirlGame
{
   public class TGirlClothes
   {
      
      protected var FID:int;
      
      protected var FQuestionTitle:String;
      
      protected var FQuestionAnswers:Vector.<String>;
      
      protected var FGameBarScore:Vector.<Vector.<int>>;
      
      protected var FCurrentSchedule:int;
      
      protected var FTotalSchedule:int;
      
      protected var FRewardString:String;
      
      protected var FCurrentScore:int;
      
      public function TGirlClothes()
      {
         super();
      }
      
      public function get QuestionTitle() : String
      {
         return this.FQuestionTitle;
      }
      
      public function set QuestionTitle(param1:String) : void
      {
         this.FQuestionTitle = param1;
      }
      
      public function get QuestionAnswers() : Vector.<String>
      {
         return this.FQuestionAnswers;
      }
      
      public function set QuestionAnswers(param1:Vector.<String>) : void
      {
         this.FQuestionAnswers = param1;
      }
      
      public function get CurrentSchedule() : int
      {
         return this.FCurrentSchedule;
      }
      
      public function set CurrentSchedule(param1:int) : void
      {
         this.FCurrentSchedule = param1;
      }
      
      public function get CurrentScore() : int
      {
         return this.FCurrentScore;
      }
      
      public function set CurrentScore(param1:int) : void
      {
         this.FCurrentScore = param1;
      }
      
      public function get ID() : int
      {
         return this.FID;
      }
      
      public function set ID(param1:int) : void
      {
         this.FID = param1;
      }
      
      public function get GameBarScore() : Vector.<Vector.<int>>
      {
         return this.FGameBarScore;
      }
      
      public function set GameBarScore(param1:Vector.<Vector.<int>>) : void
      {
         this.FGameBarScore = param1;
      }
      
      public function get TotalSchedule() : int
      {
         return this.FTotalSchedule;
      }
      
      public function set TotalSchedule(param1:int) : void
      {
         this.FTotalSchedule = param1;
      }
      
      public function get RewardString() : String
      {
         return this.FRewardString;
      }
      
      public function set RewardString(param1:String) : void
      {
         this.FRewardString = param1;
      }
   }
}

