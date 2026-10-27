package Logics.HDActivityMode
{
   import Foundation.Common.TEntity;
   
   public class TActivityAtoms extends TEntity
   {
      
      protected var FActivityNumber:uint;
      
      protected var FActivityID:uint;
      
      protected var FActivityName:String;
      
      protected var FActivityType:uint;
      
      protected var FTimeType:uint;
      
      protected var FStartTime:uint;
      
      protected var FEndTime:uint;
      
      protected var FIconID:uint;
      
      protected var FIconLocation:uint;
      
      protected var FIconSort:uint;
      
      protected var FPlayerLevel:uint;
      
      protected var FVipLevel:uint;
      
      protected var FIsOpen:Boolean;
      
      protected var FIconType:uint;
      
      protected var FMainType:uint;
      
      protected var FSecondType:uint;
      
      protected var FStatus:int;
      
      protected var FTimeShowType:uint;
      
      protected var FEffectCoolingDown:int;
      
      protected var FStartTimeVect:Vector.<uint>;
      
      protected var FEndTimeVect:Vector.<uint>;
      
      public function TActivityAtoms(param1:uint)
      {
         super(param1);
      }
      
      public function get ActivityNumber() : uint
      {
         return this.FActivityNumber;
      }
      
      public function set ActivityNumber(param1:uint) : void
      {
         this.FActivityNumber = param1;
      }
      
      public function get ActivityName() : String
      {
         return this.FActivityName;
      }
      
      public function set ActivityName(param1:String) : void
      {
         this.FActivityName = param1;
      }
      
      public function get TimeType() : uint
      {
         return this.FTimeType;
      }
      
      public function set TimeType(param1:uint) : void
      {
         this.FTimeType = param1;
      }
      
      public function get StartTime() : uint
      {
         return this.FStartTime;
      }
      
      public function set StartTime(param1:uint) : void
      {
         this.FStartTime = param1;
      }
      
      public function get EndTime() : uint
      {
         return this.FEndTime;
      }
      
      public function set EndTime(param1:uint) : void
      {
         this.FEndTime = param1;
      }
      
      public function get IconID() : uint
      {
         return this.FIconID;
      }
      
      public function set IconID(param1:uint) : void
      {
         this.FIconID = param1;
      }
      
      public function get IconLocation() : uint
      {
         return this.FIconLocation;
      }
      
      public function set IconLocation(param1:uint) : void
      {
         this.FIconLocation = param1;
      }
      
      public function get IconSort() : uint
      {
         return this.FIconSort;
      }
      
      public function set IconSort(param1:uint) : void
      {
         this.FIconSort = param1;
      }
      
      public function get PlayerLevel() : uint
      {
         return this.FPlayerLevel;
      }
      
      public function set PlayerLevel(param1:uint) : void
      {
         this.FPlayerLevel = param1;
      }
      
      public function get VipLevel() : uint
      {
         return this.FVipLevel;
      }
      
      public function set VipLevel(param1:uint) : void
      {
         this.FVipLevel = param1;
      }
      
      public function get IsOpen() : Boolean
      {
         return this.FIsOpen;
      }
      
      public function set IsOpen(param1:Boolean) : void
      {
         this.FIsOpen = param1;
      }
      
      public function get ActivityType() : uint
      {
         return this.FActivityType;
      }
      
      public function set ActivityType(param1:uint) : void
      {
         this.FActivityType = param1;
      }
      
      public function get IconType() : uint
      {
         return this.FIconType;
      }
      
      public function set IconType(param1:uint) : void
      {
         this.FIconType = param1;
      }
      
      public function get MainType() : uint
      {
         return this.FMainType;
      }
      
      public function set MainType(param1:uint) : void
      {
         this.FMainType = param1;
      }
      
      public function get SecondType() : uint
      {
         return this.FSecondType;
      }
      
      public function set SecondType(param1:uint) : void
      {
         this.FSecondType = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
      
      public function get ActivityID() : uint
      {
         return this.FActivityID;
      }
      
      public function set ActivityID(param1:uint) : void
      {
         this.FActivityID = param1;
      }
      
      public function get StartTimeVect() : Vector.<uint>
      {
         return this.FStartTimeVect;
      }
      
      public function set StartTimeVect(param1:Vector.<uint>) : void
      {
         this.FStartTimeVect = param1;
      }
      
      public function get EndTimeVect() : Vector.<uint>
      {
         return this.FEndTimeVect;
      }
      
      public function set EndTimeVect(param1:Vector.<uint>) : void
      {
         this.FEndTimeVect = param1;
      }
      
      public function get TimeShowType() : uint
      {
         return this.FTimeShowType;
      }
      
      public function set TimeShowType(param1:uint) : void
      {
         this.FTimeShowType = param1;
      }
      
      public function get EffectCoolingDown() : int
      {
         return this.FEffectCoolingDown;
      }
      
      public function set EffectCoolingDown(param1:int) : void
      {
         this.FEffectCoolingDown = param1;
      }
   }
}

