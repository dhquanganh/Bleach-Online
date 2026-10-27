package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.TDatebaseVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THomeGamble extends TDatebaseVO
   {
      
      protected var FBoxID:int;
      
      protected var FLevel:int;
      
      protected var FWeekDay:int;
      
      protected var FAwardBox:String;
      
      protected var FAwardBoxVect:Vector.<Object>;
      
      public function THomeGamble()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         this.FBoxID = param1.readUnsignedInt();
         this.FLevel = param1.readUnsignedInt();
         this.FWeekDay = param1.readInt();
         this.FAwardBox = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(this.FAwardBox) as Array;
         this.FAwardBoxVect = new Vector.<Object>();
         _loc3_ = int(_loc5_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAwardBoxVect.push(_loc5_[_loc2_]);
            _loc2_++;
         }
      }
      
      public function get Level() : int
      {
         return this.FLevel;
      }
      
      public function get WeekDay() : int
      {
         return this.FWeekDay;
      }
      
      public function get AwardBox() : String
      {
         return this.FAwardBox;
      }
      
      public function get AwardBoxVect() : Vector.<Object>
      {
         return this.FAwardBoxVect;
      }
      
      public function get BoxID() : int
      {
         return this.FBoxID;
      }
   }
}

