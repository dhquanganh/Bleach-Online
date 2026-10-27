package Logics.Pet.Train
{
   import Foundation.Common.TEntity;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TTrainData extends TEntity
   {
      
      public static const TYPE_UNOPEN:uint = 0;
      
      public static const TYPE_USABLE:uint = 1;
      
      public static const TYPE_USED:uint = 2;
      
      public static const TYPE_COMPLETED:uint = 3;
      
      protected var FVicePetHighID:uint;
      
      protected var FVicePetLowID:uint;
      
      protected var FTrainTypeID:int;
      
      protected var FConsumeGoldIndex:int;
      
      protected var FTrainCD:int;
      
      protected var FCurrentServerTick:int;
      
      protected var FNeedTime:int;
      
      protected var FExp:int;
      
      protected var FStatus:uint;
      
      public function TTrainData(param1:uint)
      {
         super(param1);
      }
      
      LogicsSpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      public function get VicePetHighID() : uint
      {
         return this.FVicePetHighID;
      }
      
      public function set VicePetHighID(param1:uint) : void
      {
         this.FVicePetHighID = param1;
      }
      
      public function get VicePetLowID() : uint
      {
         return this.FVicePetLowID;
      }
      
      public function set VicePetLowID(param1:uint) : void
      {
         this.FVicePetLowID = param1;
      }
      
      public function get TrainType() : int
      {
         return this.FTrainTypeID % 180000 - 1;
      }
      
      public function get TrainTypeID() : int
      {
         return this.FTrainTypeID;
      }
      
      public function set TrainTypeID(param1:int) : void
      {
         this.FTrainTypeID = param1;
      }
      
      public function get ConsumeGoldIndex() : int
      {
         return this.FConsumeGoldIndex;
      }
      
      public function set ConsumeGoldIndex(param1:int) : void
      {
         this.FConsumeGoldIndex = param1;
      }
      
      public function get TrainCD() : int
      {
         return this.FTrainCD;
      }
      
      public function set TrainCD(param1:int) : void
      {
         this.FTrainCD = param1;
      }
      
      public function get NeedTime() : int
      {
         return this.FNeedTime;
      }
      
      public function set NeedTime(param1:int) : void
      {
         this.FNeedTime = param1;
      }
      
      public function get Exp() : int
      {
         return this.FExp;
      }
      
      public function set Exp(param1:int) : void
      {
         this.FExp = param1;
      }
      
      public function get Status() : uint
      {
         return this.FStatus;
      }
      
      public function set Status(param1:uint) : void
      {
         this.FStatus = param1;
      }
      
      public function get CurrentServerTick() : int
      {
         return this.FCurrentServerTick;
      }
      
      public function set CurrentServerTick(param1:int) : void
      {
         this.FCurrentServerTick = param1;
      }
      
      public function Clear() : void
      {
         this.FVicePetHighID = 0;
         this.FVicePetLowID = 0;
         this.FTrainTypeID = 0;
         this.FConsumeGoldIndex = 0;
         this.FTrainCD = 0;
         this.FCurrentServerTick = 0;
         this.FExp = 0;
         this.FStatus = TYPE_USABLE;
      }
   }
}

