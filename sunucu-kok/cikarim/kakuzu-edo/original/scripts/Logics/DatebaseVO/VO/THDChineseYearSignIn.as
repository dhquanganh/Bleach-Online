package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDActivityChineseYear.TActivityDateSign;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDChineseYearSignIn extends THDActivityBase
   {
      
      protected var FDateSigns:Vector.<TActivityDateSign>;
      
      public function THDChineseYearSignIn()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:TActivityDateSign = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_) as Array;
         _loc3_ = int(_loc5_.length);
         this.FDateSigns = new Vector.<TActivityDateSign>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = new TActivityDateSign(_loc5_[_loc2_].index);
            _loc6_.Award[0] = _loc5_[_loc2_].award[0];
            this.FDateSigns[_loc2_] = _loc6_;
            _loc2_++;
         }
      }
      
      public function get DateSigns() : Vector.<TActivityDateSign>
      {
         return this.FDateSigns;
      }
   }
}

