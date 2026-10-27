package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class THDLevelRank extends THDActivityBase
   {
      
      protected var FActAward:String;
      
      protected var FRankNum:uint;
      
      protected var FActAwardVect:Vector.<Object>;
      
      protected var FAwardValueVect:Vector.<uint>;
      
      protected var FAwardPromptVect:Vector.<String>;
      
      public function THDLevelRank()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FActAward = TUtilityString.FetchUTF(param1);
         this.FActAwardVect = Vector.<Object>(Json.decode(this.FActAward));
         _loc3_ = int(this.FActAwardVect.length);
         this.FAwardValueVect = new Vector.<uint>(_loc3_);
         this.FAwardPromptVect = new Vector.<String>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAwardValueVect[_loc2_] = this.FActAwardVect[_loc2_].value[0];
            this.FAwardPromptVect[_loc2_] = this.FActAwardVect[_loc2_].prompt;
            _loc2_++;
         }
         this.FRankNum = param1.readUnsignedInt();
      }
      
      public function get RankNum() : uint
      {
         return this.FRankNum;
      }
      
      public function get ActAwardVect() : Vector.<Object>
      {
         return this.FActAwardVect;
      }
      
      public function get AwardValueVect() : Vector.<uint>
      {
         return this.FAwardValueVect;
      }
      
      public function get AwardPromptVect() : Vector.<String>
      {
         return this.FAwardPromptVect;
      }
   }
}

