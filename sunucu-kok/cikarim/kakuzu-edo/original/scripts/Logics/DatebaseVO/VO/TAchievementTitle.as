package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import Logics.DatebaseVO.VO.Json.TAddOther;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TAchievementTitle extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FLevelTitle:int;
      
      protected var FNotOrProp:int;
      
      protected var FTitleTypeGroup:int;
      
      protected var FTimeLimitNot:int;
      
      protected var FValTimeLimit:int;
      
      protected var FFormationType:int;
      
      protected var FAddOtherArray:Vector.<TAddOther>;
      
      public function TAchievementTitle()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:TAddOther = null;
         this.FName = TUtilityString.FetchUTF(param1);
         this.FLevelTitle = param1.readInt();
         this.FNotOrProp = param1.readInt();
         this.FTitleTypeGroup = param1.readInt();
         this.FTimeLimitNot = param1.readInt();
         this.FValTimeLimit = param1.readInt();
         this.FFormationType = param1.readInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FAddOtherArray = new Vector.<TAddOther>(_loc3_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = new TAddOther(_loc3_[_loc4_]);
            this.FAddOtherArray[_loc4_] = _loc5_;
            _loc4_++;
         }
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get NotOrProp() : int
      {
         return this.FNotOrProp;
      }
      
      public function get TimeLimitNot() : int
      {
         return this.FTimeLimitNot;
      }
      
      public function get ValTimeLimit() : int
      {
         return this.FValTimeLimit;
      }
      
      public function get FormationType() : int
      {
         return this.FFormationType;
      }
      
      public function get AddOtherArray() : Vector.<TAddOther>
      {
         return this.FAddOtherArray;
      }
      
      public function get TitleTypeGroup() : int
      {
         return this.FTitleTypeGroup;
      }
      
      public function get LevelTitle() : int
      {
         return this.FLevelTitle;
      }
   }
}

