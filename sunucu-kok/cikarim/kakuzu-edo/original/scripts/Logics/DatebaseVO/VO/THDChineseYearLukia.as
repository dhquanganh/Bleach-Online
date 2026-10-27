package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDActivityChineseYear.ActivityLukia.TActivityExchangeBag;
   import Logics.HDActivityChineseYear.ActivityLukia.TActivityLukia;
   import Logics.HDActivityChineseYear.ActivityLukia.TActivityLukiaChip;
   import Logics.HDActivityChineseYear.ActivityLukia.TActivityNiceBag;
   import Logics.HDActivityChineseYear.ActivityLukia.TActivitySuperBag;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDChineseYearLukia extends THDActivityBase
   {
      
      protected var FActivityLukia:TActivityLukia;
      
      protected var FActivitySuperBag:TActivitySuperBag;
      
      protected var FActivityNiceBag:TActivityNiceBag;
      
      protected var FActivityExchangeBag:TActivityExchangeBag;
      
      protected var FActivityLukiaChip:TActivityLukiaChip;
      
      public function THDChineseYearLukia()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FActivitySuperBag = new TActivitySuperBag(_loc3_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FActivityNiceBag = new TActivityNiceBag(_loc3_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FActivityExchangeBag = new TActivityExchangeBag(_loc3_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FActivityLukia = new TActivityLukia(_loc3_);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_);
         this.FActivityLukiaChip = new TActivityLukiaChip(_loc3_);
      }
      
      public function get ActivityLukia() : TActivityLukia
      {
         return this.FActivityLukia;
      }
      
      public function get ActivitySuperBag() : TActivitySuperBag
      {
         return this.FActivitySuperBag;
      }
      
      public function get ActivityNiceBag() : TActivityNiceBag
      {
         return this.FActivityNiceBag;
      }
      
      public function get ActivityExchangeBag() : TActivityExchangeBag
      {
         return this.FActivityExchangeBag;
      }
      
      public function get ActivityLukiaChip() : TActivityLukiaChip
      {
         return this.FActivityLukiaChip;
      }
   }
}

