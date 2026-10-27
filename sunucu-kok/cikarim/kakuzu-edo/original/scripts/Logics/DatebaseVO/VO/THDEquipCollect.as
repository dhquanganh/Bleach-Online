package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import Logics.DatebaseVO.VO.Json.TConditionStyleB;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class THDEquipCollect extends THDActivityBase
   {
      
      protected var FConditions:Vector.<TConditionStyleB>;
      
      protected var FAwardValueVect:Vector.<uint>;
      
      protected var FAwardPromptVect:Vector.<String>;
      
      public function THDEquipCollect()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Vector.<Object> = null;
         var _loc6_:TConditionStyleB = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Vector.<Object>(Json.decode(_loc4_));
         _loc3_ = int(_loc5_.length);
         this.FConditions = new Vector.<TConditionStyleB>(_loc3_);
         this.FAwardValueVect = new Vector.<uint>(_loc3_);
         this.FAwardPromptVect = new Vector.<String>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = new TConditionStyleB(_loc5_[_loc2_]);
            this.FConditions[_loc2_] = _loc6_;
            if(_loc6_.Awards != null)
            {
               this.FAwardValueVect[_loc2_] = this.FConditions[_loc2_].Awards[0];
            }
            if(_loc6_.Prompt != null)
            {
               this.FAwardPromptVect[_loc2_] = this.FConditions[_loc2_].Prompt;
            }
            _loc2_++;
         }
      }
      
      public function get Conditions() : Vector.<TConditionStyleB>
      {
         return this.FConditions;
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

