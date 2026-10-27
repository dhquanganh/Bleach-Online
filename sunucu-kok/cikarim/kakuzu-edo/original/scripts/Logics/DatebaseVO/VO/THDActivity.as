package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class THDActivity extends TDatebaseVO
   {
      
      protected var FActId:uint;
      
      protected var FActName:String;
      
      protected var FActType:uint;
      
      protected var FTimeType:uint;
      
      protected var FStartTime:String;
      
      protected var FEndTime:String;
      
      protected var FActIcon:uint;
      
      protected var FPosition:uint;
      
      protected var FActPosition:uint;
      
      protected var FPlayerLv:uint;
      
      protected var FVipLv:uint;
      
      protected var FStartTimeShow:uint;
      
      protected var FStartTimeVect:Vector.<uint>;
      
      protected var FEndTimeVect:Vector.<uint>;
      
      public function THDActivity()
      {
         super();
         this.FStartTimeVect = new Vector.<uint>();
         this.FEndTimeVect = new Vector.<uint>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         this.FActId = param1.readUnsignedInt();
         this.FActName = TUtilityString.FetchUTF(param1);
         this.FActType = param1.readUnsignedInt();
         this.FTimeType = param1.readUnsignedInt();
         this.FStartTime = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(this.FStartTime) as Array;
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FStartTimeVect[_loc2_] = _loc4_[_loc2_];
            _loc2_++;
         }
         this.FEndTime = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(this.FEndTime) as Array;
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FEndTimeVect[_loc2_] = _loc4_[_loc2_];
            _loc2_++;
         }
         this.FActIcon = param1.readUnsignedInt();
         this.FPosition = param1.readUnsignedInt();
         this.FActPosition = param1.readUnsignedInt();
         this.FPlayerLv = param1.readUnsignedInt();
         this.FVipLv = param1.readUnsignedInt();
         this.FStartTimeShow = param1.readUnsignedInt();
      }
      
      public function get ActId() : uint
      {
         return this.FActId;
      }
      
      public function get ActName() : String
      {
         return this.FActName;
      }
      
      public function get ActType() : uint
      {
         return this.FActType;
      }
      
      public function get TimeType() : uint
      {
         return this.FTimeType;
      }
      
      public function get StartTime() : String
      {
         return this.FStartTime;
      }
      
      public function get EndTime() : String
      {
         return this.FEndTime;
      }
      
      public function get ActIcon() : uint
      {
         return this.FActIcon;
      }
      
      public function get Position() : uint
      {
         return this.FPosition;
      }
      
      public function get ActPosition() : uint
      {
         return this.FActPosition;
      }
      
      public function get PlayerLv() : uint
      {
         return this.FPlayerLv;
      }
      
      public function get VipLv() : uint
      {
         return this.FVipLv;
      }
      
      public function get StartTimeVect() : Vector.<uint>
      {
         return this.FStartTimeVect;
      }
      
      public function get EndTimeVect() : Vector.<uint>
      {
         return this.FEndTimeVect;
      }
      
      public function get StartTimeShow() : uint
      {
         return this.FStartTimeShow;
      }
   }
}

