package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TBeautifulClothes extends TDatebaseVO
   {
      
      protected var FFactor:int;
      
      protected var FScores:Vector.<Vector.<int>>;
      
      protected var FQuestion:String;
      
      protected var FAnswers:Vector.<String>;
      
      public function TBeautifulClothes()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         this.FFactor = param1.readUnsignedInt();
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         this.FScores = new Vector.<Vector.<int>>();
         _loc2_ = 0;
         while(_loc2_ < _loc5_.length)
         {
            this.FScores.push(Vector.<int>(_loc5_[_loc2_]));
            _loc2_++;
         }
         this.FQuestion = TUtilityString.FetchUTF(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         if(_loc4_ != "0")
         {
            _loc5_ = Json.decode(_loc4_);
            this.FAnswers = Vector.<String>(_loc5_);
         }
      }
      
      public function get Factor() : int
      {
         return this.FFactor;
      }
      
      public function get Scores() : Vector.<Vector.<int>>
      {
         return this.FScores;
      }
      
      public function get Question() : String
      {
         return this.FQuestion;
      }
      
      public function get Answers() : Vector.<String>
      {
         return this.FAnswers;
      }
   }
}

