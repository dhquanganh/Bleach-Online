package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class THDRecruitPartner extends THDActivityBase
   {
      
      protected var FCondition:String;
      
      protected var FConditionVect:Vector.<Object>;
      
      protected var FAwardValueVect:Vector.<uint>;
      
      protected var FAwardPromptVect:Vector.<String>;
      
      protected var FConditionQualityVect:Vector.<uint>;
      
      protected var FConditionCountVect:Vector.<uint>;
      
      public function THDRecruitPartner()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FCondition = TUtilityString.FetchUTF(param1);
         this.FConditionVect = Vector.<Object>(Json.decode(this.FCondition));
         _loc3_ = int(this.FConditionVect.length);
         this.FAwardPromptVect = new Vector.<String>(_loc3_);
         this.FAwardValueVect = new Vector.<uint>(_loc3_);
         this.FConditionQualityVect = new Vector.<uint>(_loc3_);
         this.FConditionCountVect = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAwardPromptVect[_loc2_] = this.FConditionVect[_loc2_].prompt;
            this.FAwardValueVect[_loc2_] = this.FConditionVect[_loc2_].reward[0];
            this.FConditionQualityVect[_loc2_] = this.FConditionVect[_loc2_].quality;
            this.FConditionCountVect[_loc2_] = this.FConditionVect[_loc2_].count;
            _loc2_++;
         }
      }
      
      public function get ConditionVect() : Vector.<Object>
      {
         return this.FConditionVect;
      }
      
      public function get AwardValueVect() : Vector.<uint>
      {
         return this.FAwardValueVect;
      }
      
      public function get AwardPromptVect() : Vector.<String>
      {
         return this.FAwardPromptVect;
      }
      
      public function get ConditionQualityVect() : Vector.<uint>
      {
         return this.FConditionQualityVect;
      }
      
      public function get ConditionCountVect() : Vector.<uint>
      {
         return this.FConditionCountVect;
      }
   }
}

