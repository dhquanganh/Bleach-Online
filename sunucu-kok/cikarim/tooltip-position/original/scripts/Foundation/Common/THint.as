package Foundation.Common
{
   import Foundation.Utilities.TUtilityString;
   
   public class THint
   {
      
      protected var FCaption:String;
      
      protected var FContent:String;
      
      public function THint()
      {
         super();
      }
      
      public function get Caption() : String
      {
         return this.FCaption;
      }
      
      public function set Caption(param1:String) : void
      {
         this.FCaption = param1;
      }
      
      public function get Content() : String
      {
         return this.FContent;
      }
      
      public function set Content(param1:String) : void
      {
         this.FContent = param1;
      }
      
      public function get Empty() : Boolean
      {
         var _loc1_:Boolean = false;
         return TUtilityString.Empty(this.FCaption) && TUtilityString.Empty(this.FContent);
      }
   }
}

