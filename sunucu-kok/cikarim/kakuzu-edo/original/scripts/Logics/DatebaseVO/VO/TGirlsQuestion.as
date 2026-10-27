package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TRewards;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TGirlsQuestion extends TDatebaseVO
   {
      
      protected var FLevel:int;
      
      protected var FQuestion:String;
      
      protected var FAnswers:Vector.<String>;
      
      protected var FResponds:Vector.<String>;
      
      protected var FRewards:Vector.<TRewards>;
      
      public function TGirlsQuestion()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this.FLevel = param1.readUnsignedInt();
         this.FQuestion = TUtilityString.FetchUTF(param1);
         this.FAnswers = new Vector.<String>();
         this.FResponds = new Vector.<String>();
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FAnswers.push(_loc2_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FResponds.push(_loc2_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FAnswers.push(_loc2_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FResponds.push(_loc2_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FAnswers.push(_loc2_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FResponds.push(_loc2_);
         this.FRewards = new Vector.<TRewards>();
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FRewards.push(new TRewards(_loc2_));
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FRewards.push(new TRewards(_loc2_));
         _loc2_ = TUtilityString.FetchUTF(param1);
         this.FRewards.push(new TRewards(_loc2_));
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function get Question() : String
      {
         return this.FQuestion;
      }
      
      public function get Answers() : Vector.<String>
      {
         return this.FAnswers;
      }
      
      public function get Responds() : Vector.<String>
      {
         return this.FResponds;
      }
      
      public function get Rewards() : Vector.<TRewards>
      {
         return this.FRewards;
      }
   }
}

