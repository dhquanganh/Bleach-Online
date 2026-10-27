package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class TNightmareTrialConfig extends TDatebaseVO
   {
      
      protected var FNameDesc:String;
      
      protected var FNormalCityId:int;
      
      protected var FHardCityId:int;
      
      protected var FNightmareCityId:int;
      
      protected var FDeadCityId:int;
      
      protected var FAwardIdVec:Vector.<int>;
      
      protected var FChapterSwitch:int;
      
      protected var FWordTxtSysId:int;
      
      protected var FTitleTxtSysId:int;
      
      public function TNightmareTrialConfig()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         this.FNameDesc = TUtilityString.FetchUTF(param1);
         this.FNormalCityId = param1.readUnsignedInt();
         this.FHardCityId = param1.readUnsignedInt();
         this.FNightmareCityId = param1.readUnsignedInt();
         this.FDeadCityId = param1.readUnsignedInt();
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc4_);
         this.FAwardIdVec = Vector.<int>(_loc3_);
         this.FChapterSwitch = param1.readUnsignedInt();
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc4_);
         this.FTitleTxtSysId = _loc3_[0];
         this.FWordTxtSysId = _loc3_[1];
      }
      
      public function get NormalCityId() : int
      {
         return this.FNormalCityId;
      }
      
      public function get HardCityId() : int
      {
         return this.FHardCityId;
      }
      
      public function get NightmareCityId() : int
      {
         return this.FNightmareCityId;
      }
      
      public function get DeadCityId() : int
      {
         return this.FDeadCityId;
      }
      
      public function get WordTxtSysId() : int
      {
         return this.FWordTxtSysId;
      }
      
      public function get TitleTxtSysId() : int
      {
         return this.FTitleTxtSysId;
      }
      
      public function get ChapterSwitch() : int
      {
         return this.FChapterSwitch;
      }
      
      public function get NameDesc() : String
      {
         return this.FNameDesc;
      }
      
      public function get AwardIdVec() : Vector.<int>
      {
         return this.FAwardIdVec;
      }
   }
}

