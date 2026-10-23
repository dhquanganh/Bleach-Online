package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import Logics.DatebaseVO.VO.Json.*;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class TDailyTask extends TDatebaseVO
   {
      
      protected var FType:int;
      
      protected var FEventType:int;
      
      protected var FRewardVect:Vector.<TFixedAward>;
      
      protected var FSmallpicture:int;
      
      protected var FPoint:int;
      
      protected var FCancel:int;
      
      protected var FTaskname:String;
      
      protected var FRate:int;
      
      protected var FIsgoto:int;
      
      protected var FInstantVect:Array;
      
      protected var FComplete:int;
      
      protected var FDescription:String;
      
      protected var FRewards:String;
      
      protected var FInstant:String;
      
      public function TDailyTask()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:TFixedAward = null;
         this.FType = param1.readUnsignedInt();
         this.FEventType = param1.readUnsignedInt();
         this.FRewards = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(this.FRewards);
         _loc5_ = _loc4_ as Array;
         _loc3_ = int(_loc5_.length);
         this.FRewardVect = new Vector.<TFixedAward>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = new TFixedAward(_loc5_[_loc2_]);
            this.FRewardVect[_loc2_] = _loc6_;
            _loc2_++;
         }
         this.FSmallpicture = param1.readUnsignedInt();
         this.FPoint = param1.readUnsignedInt();
         this.FCancel = param1.readUnsignedInt();
         this.FTaskname = TUtilityString.FetchUTF(param1);
         this.FRate = param1.readUnsignedInt();
         this.FIsgoto = param1.readUnsignedInt();
         this.FInstant = TUtilityString.FetchUTF(param1);
         this.FInstantVect = Json.decode(this.FInstant) as Array;
         this.FComplete = param1.readUnsignedInt();
         this.FDescription = TUtilityString.FetchUTF(param1);
      }
      
      public function get Type() : int
      {
         return this.FType;
      }
      
      public function get EventType() : int
      {
         return this.FEventType;
      }
      
      public function get RewardVect() : Vector.<TFixedAward>
      {
         return this.FRewardVect;
      }
      
      public function get Smallpicture() : int
      {
         return this.FSmallpicture;
      }
      
      public function get Point() : int
      {
         return this.FPoint;
      }
      
      public function get Cancel() : int
      {
         return this.FCancel;
      }
      
      public function get Taskname() : String
      {
         return this.FTaskname;
      }
      
      public function get Rate() : int
      {
         return this.FRate;
      }
      
      public function get Isgoto() : int
      {
         return this.FIsgoto;
      }
      
      public function get InstantVect() : Array
      {
         return this.FInstantVect;
      }
      
      public function get Complete() : int
      {
         return this.FComplete;
      }
      
      public function get Description() : String
      {
         return this.FDescription;
      }
      
      public function get Rewards() : String
      {
         return this.FRewards;
      }
      
      public function get Instant() : String
      {
         return this.FInstant;
      }
   }
}

