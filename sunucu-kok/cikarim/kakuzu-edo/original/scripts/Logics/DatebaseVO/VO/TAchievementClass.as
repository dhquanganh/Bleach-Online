package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TAchievementClass extends TDatebaseVO
   {
      
      protected var FName:String;
      
      protected var FAchievementGroupsID:Vector.<uint>;
      
      public function TAchievementClass()
      {
         super();
         this.FAchievementGroupsID = new Vector.<uint>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         this.FName = TUtilityString.FetchUTF(param1);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_) as Array;
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            this.FAchievementGroupsID[_loc4_] = _loc3_[_loc4_];
            _loc4_++;
         }
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function get AchievementGroupsID() : Vector.<uint>
      {
         return this.FAchievementGroupsID;
      }
   }
}

