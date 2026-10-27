package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class THomeGirlInteract extends TDatebaseVO
   {
      
      protected var FScoreBlank:int;
      
      protected var FNameTitle:String;
      
      protected var FTitleColor:int;
      
      protected var FAdded:Number;
      
      public function THomeGirlInteract()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         this; //unpopped
         this.FScoreBlank = param1.readInt();
         this.FNameTitle = TUtilityString.FetchUTF(param1);
         this.FTitleColor = param1.readInt();
         this.FAdded = param1.readFloat();
      }
      
      public function get ScoreBlank() : int
      {
         return this.FScoreBlank;
      }
      
      public function get NameTitle() : String
      {
         return this.FNameTitle;
      }
      
      public function get TitleColor() : int
      {
         return this.FTitleColor;
      }
      
      public function get Added() : Number
      {
         return this.FAdded;
      }
   }
}

