package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class THDCampBattle extends THDActivityBase
   {
      
      protected var FCondition:String;
      
      protected var FCarbonLine:String;
      
      protected var FPrizeNum:uint;
      
      protected var FConditionVect:Vector.<Object>;
      
      protected var FAwardValueVect:Vector.<uint>;
      
      protected var FAwardPromptVect:Vector.<String>;
      
      public function THDCampBattle()
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
         this.FCarbonLine = TUtilityString.FetchUTF(param1);
         this.FPrizeNum = param1.readUnsignedInt();
         _loc3_ = int(this.FConditionVect.length);
         this.FAwardPromptVect = new Vector.<String>(_loc3_);
         this.FAwardValueVect = new Vector.<uint>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAwardPromptVect[_loc2_] = this.FConditionVect[_loc2_].prompt;
            this.FAwardValueVect[_loc2_] = this.FConditionVect[_loc2_].value[0];
            _loc2_++;
         }
      }
      
      public function get CarbonLine() : String
      {
         return this.FCarbonLine;
      }
      
      public function get PrizeNum() : uint
      {
         return this.FPrizeNum;
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
   }
}

