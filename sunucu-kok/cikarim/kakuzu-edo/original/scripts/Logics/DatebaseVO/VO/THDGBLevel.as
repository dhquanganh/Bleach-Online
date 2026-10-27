package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class THDGBLevel extends THDActivityBase
   {
      
      protected static const KIND_BAG:uint = 3;
      
      protected var FActAward:String;
      
      protected var FActAwardVect:Vector.<Object>;
      
      protected var FAwardCondVect:Vector.<uint>;
      
      protected var FAwardValueVect:Vector.<Vector.<uint>>;
      
      protected var FAwardValueArrVect:Vector.<uint>;
      
      protected var FAwardPromptVect:Vector.<String>;
      
      public function THDGBLevel()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FActAward = TUtilityString.FetchUTF(param1);
         this.FActAwardVect = Vector.<Object>(Json.decode(this.FActAward));
         _loc4_ = int(this.FActAwardVect.length);
         this.FAwardCondVect = new Vector.<uint>(_loc4_);
         this.FAwardValueVect = new Vector.<Vector.<uint>>();
         this.FAwardPromptVect = new Vector.<String>(_loc4_);
         _loc3_ = 0;
         while(_loc3_ < KIND_BAG)
         {
            this.FAwardValueArrVect = new Vector.<uint>(_loc4_);
            this.FAwardValueVect.push(this.FAwardValueArrVect);
            _loc3_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            this.FAwardCondVect[_loc2_] = this.FActAwardVect[_loc2_].condition;
            this.FAwardPromptVect[_loc2_] = this.FActAwardVect[_loc2_].prompt;
            this.FAwardValueVect[0][_loc2_] = this.FActAwardVect[_loc2_].award[0];
            this.FAwardValueVect[1][_loc2_] = this.FActAwardVect[_loc2_].award[1];
            this.FAwardValueVect[2][_loc2_] = this.FActAwardVect[_loc2_].award[2];
            _loc2_++;
         }
      }
      
      public function get AwardCondVect() : Vector.<uint>
      {
         return this.FAwardCondVect;
      }
      
      public function get AwardValueVect() : Vector.<Vector.<uint>>
      {
         return this.FAwardValueVect;
      }
      
      public function get AwardPromptVect() : Vector.<String>
      {
         return this.FAwardPromptVect;
      }
      
      public function get ActAwardVect() : Vector.<Object>
      {
         return this.FActAwardVect;
      }
   }
}

