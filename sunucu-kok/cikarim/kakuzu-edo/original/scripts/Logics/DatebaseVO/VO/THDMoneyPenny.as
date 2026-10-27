package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDActivitySoulBox.TActivityMoneyPennyBox;
   import Logics.HDActivitySoulBox.TActivityMoneyPennyCondition;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDMoneyPenny extends THDActivityBase
   {
      
      protected var FBoxStatus:Vector.<TActivityMoneyPennyBox>;
      
      protected var FBoxConditions:Vector.<TActivityMoneyPennyCondition>;
      
      protected var FPayDay:uint;
      
      protected var FAdditional:uint;
      
      protected var FShowStr:Vector.<String>;
      
      public function THDMoneyPenny()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:TActivityMoneyPennyBox = null;
         var _loc7_:TActivityMoneyPennyCondition = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         this.FBoxStatus = new Vector.<TActivityMoneyPennyBox>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = new TActivityMoneyPennyBox(_loc5_[_loc2_].index);
            _loc6_.GetType = _loc5_[_loc2_].getType;
            _loc6_.Limit = _loc5_[_loc2_].limit;
            this.FBoxStatus[_loc2_] = _loc6_;
            _loc2_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         this.FBoxConditions = new Vector.<TActivityMoneyPennyCondition>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc7_ = new TActivityMoneyPennyCondition();
            _loc7_.Condition = _loc5_[_loc2_].condition;
            _loc7_.Rate = _loc5_[_loc2_].rate;
            _loc7_.Prompt = _loc5_[_loc2_].prompt;
            this.FBoxConditions[_loc2_] = _loc7_;
            _loc2_++;
         }
         this.FPayDay = param1.readUnsignedInt();
         this.FAdditional = param1.readUnsignedInt();
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         this.FShowStr = new Vector.<String>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FShowStr[_loc2_] = _loc5_[_loc2_];
            _loc2_++;
         }
      }
      
      public function get BoxStatus() : Vector.<TActivityMoneyPennyBox>
      {
         return this.FBoxStatus;
      }
      
      public function get BoxConditions() : Vector.<TActivityMoneyPennyCondition>
      {
         return this.FBoxConditions;
      }
      
      public function get PayDay() : uint
      {
         return this.FPayDay;
      }
      
      public function get Additional() : uint
      {
         return this.FAdditional;
      }
      
      public function get ShowStr() : Vector.<String>
      {
         return this.FShowStr;
      }
   }
}

