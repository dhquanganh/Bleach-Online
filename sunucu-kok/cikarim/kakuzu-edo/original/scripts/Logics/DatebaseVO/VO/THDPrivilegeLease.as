package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDPrivilegeLease extends THDActivityBase
   {
      
      private var FActAwardIndexList:Vector.<int>;
      
      private var FActAwardHeroIdList:Vector.<int>;
      
      private var FPromptLists:Array;
      
      public function THDPrivilegeLease()
      {
         super();
         this.FActAwardIndexList = new Vector.<int>();
         this.FActAwardHeroIdList = new Vector.<int>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FActAwardIndexList[_loc2_] = _loc4_[_loc2_].index;
            this.FActAwardHeroIdList[_loc2_] = _loc4_[_loc2_].hero;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         this.FPromptLists = _loc4_;
      }
      
      public function get ActAwardIndexList() : Vector.<int>
      {
         return this.FActAwardIndexList;
      }
      
      public function get ActAwardHeroIdList() : Vector.<int>
      {
         return this.FActAwardHeroIdList;
      }
      
      public function get PromptLists() : Array
      {
         return this.FPromptLists;
      }
   }
}

