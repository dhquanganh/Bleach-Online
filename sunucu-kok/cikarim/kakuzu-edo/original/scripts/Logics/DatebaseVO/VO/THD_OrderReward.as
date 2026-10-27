package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THD_OrderReward extends THDActivityBase
   {
      
      protected var FCondition:Vector.<uint>;
      
      protected var FAward:Vector.<uint>;
      
      protected var FPrompt:String;
      
      public function THD_OrderReward()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FCondition = Vector.<uint>(_loc3_[0].condition);
         this.FAward = Vector.<uint>(_loc3_[0].award);
         this.FPrompt = _loc3_[0].prompt;
      }
      
      public function get Condition() : Vector.<uint>
      {
         return this.FCondition;
      }
      
      public function get Award() : Vector.<uint>
      {
         return this.FAward;
      }
      
      public function get Prompt() : String
      {
         return this.FPrompt;
      }
   }
}

