package Logics.ReveredBook
{
   public class TReveredBookQuestion
   {
      
      protected var FID:uint;
      
      protected var FLable:String;
      
      protected var FLevel:int;
      
      protected var FQuestion:String;
      
      protected var FAnswers:Vector.<String>;
      
      protected var FResponded:Vector.<String>;
      
      protected var FRewards:Vector.<String>;
      
      protected var FInitialIndex:Vector.<int>;
      
      public function TReveredBookQuestion()
      {
         super();
         this.FRewards = new Vector.<String>();
         this.FInitialIndex = new Vector.<int>();
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function set Level(param1:int) : void
      {
         this.FLevel = param1;
      }
      
      public function get Question() : String
      {
         return this.FQuestion;
      }
      
      public function set Question(param1:String) : void
      {
         this.FQuestion = param1;
      }
      
      public function get Responded() : Vector.<String>
      {
         return this.FResponded;
      }
      
      public function set Responded(param1:Vector.<String>) : void
      {
         this.FResponded = param1;
      }
      
      public function get Rewards() : Vector.<String>
      {
         return this.FRewards;
      }
      
      public function get Answers() : Vector.<String>
      {
         return this.FAnswers;
      }
      
      public function set Answers(param1:Vector.<String>) : void
      {
         this.FAnswers = param1;
      }
      
      public function get Lable() : String
      {
         return this.FLable;
      }
      
      public function set Lable(param1:String) : void
      {
         this.FLable = param1;
      }
      
      public function get InitialIndex() : Vector.<int>
      {
         return this.FInitialIndex;
      }
      
      public function get ID() : uint
      {
         return this.FID;
      }
      
      public function set ID(param1:uint) : void
      {
         this.FID = param1;
      }
   }
}

