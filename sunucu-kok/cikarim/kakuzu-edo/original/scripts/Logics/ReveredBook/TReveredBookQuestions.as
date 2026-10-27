package Logics.ReveredBook
{
   public class TReveredBookQuestions
   {
      
      protected var FQuestions:Vector.<TReveredBookQuestion>;
      
      public function TReveredBookQuestions()
      {
         super();
         this.FQuestions = new Vector.<TReveredBookQuestion>();
      }
      
      public function get Questions() : Vector.<TReveredBookQuestion>
      {
         return this.FQuestions;
      }
   }
}

