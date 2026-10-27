package Logics.ReveredBook
{
   public class TReveredBookStrategy
   {
      
      protected var FTabNames:Vector.<String>;
      
      protected var FContents:Vector.<String>;
      
      public function TReveredBookStrategy()
      {
         super();
         this.FTabNames = new Vector.<String>();
         this.FContents = new Vector.<String>();
      }
      
      public function get TabNames() : Vector.<String>
      {
         return this.FTabNames;
      }
      
      public function get Contents() : Vector.<String>
      {
         return this.FContents;
      }
   }
}

