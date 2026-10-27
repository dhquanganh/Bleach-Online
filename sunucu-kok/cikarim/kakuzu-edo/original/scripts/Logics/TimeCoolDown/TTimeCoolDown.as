package Logics.TimeCoolDown
{
   import Foundation.Common.TEntity;
   import Foundation.Timing.STimingCore;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TTimeCoolDown extends TEntity
   {
      
      protected var FTimingTime:uint;
      
      protected var FTimingReferenceTick:int;
      
      protected var FTimingReferenceTime:int;
      
      public function TTimeCoolDown(param1:uint)
      {
         super(param1);
      }
      
      LogicsSpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
      }
      
      LogicsSpace function TimingUpdate() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.FTimingTime > 0)
         {
            _loc1_ = STimingCore.TickCount - this.FTimingReferenceTick;
            _loc2_ = _loc1_ / 1000;
            _loc3_ = this.FTimingReferenceTime - _loc2_;
            if(_loc3_ <= 0)
            {
               this.FTimingTime = 0;
            }
            else
            {
               this.FTimingTime = _loc3_;
            }
         }
      }
      
      public function get TimingTime() : uint
      {
         return this.FTimingTime;
      }
      
      public function set TimingTime(param1:uint) : void
      {
         this.FTimingReferenceTick = STimingCore.TickCount;
         this.FTimingReferenceTime = param1;
         this.FTimingTime = param1;
      }
   }
}

