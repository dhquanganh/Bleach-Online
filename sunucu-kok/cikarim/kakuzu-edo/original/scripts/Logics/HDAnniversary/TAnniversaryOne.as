package Logics.HDAnniversary
{
   import Logics.DatebaseVO.VO.THDAnniversaryOne;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TAnniversaryOne extends TActivityOSBase
   {
      
      protected var FRushStatus:int;
      
      protected var FStepAwardStatus:Vector.<int>;
      
      protected var FBigAwardStatus:Vector.<int>;
      
      protected var FStepAwards:Vector.<TInventories>;
      
      protected var FBigAwards:Vector.<TInventories>;
      
      protected var FConfig:THDAnniversaryOne;
      
      public function TAnniversaryOne()
      {
         super();
         this.FBigAwardStatus = new Vector.<int>();
         this.FStepAwardStatus = new Vector.<int>();
         this.FStepAwards = new Vector.<TInventories>();
         this.FBigAwards = new Vector.<TInventories>();
      }
      
      public function get RushStatus() : int
      {
         return this.FRushStatus;
      }
      
      public function set RushStatus(param1:int) : void
      {
         this.FRushStatus = param1;
      }
      
      public function get BigAwardStatus() : Vector.<int>
      {
         return this.FBigAwardStatus;
      }
      
      public function set BigAwardStatus(param1:Vector.<int>) : void
      {
         this.FBigAwardStatus = param1;
      }
      
      public function get StepAwardStatus() : Vector.<int>
      {
         return this.FStepAwardStatus;
      }
      
      public function set StepAwardStatus(param1:Vector.<int>) : void
      {
         this.FStepAwardStatus = param1;
      }
      
      public function get Config() : THDAnniversaryOne
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDAnniversaryOne) : void
      {
         this.FConfig = param1;
      }
      
      public function CurProgress() : int
      {
         var _loc1_:* = 0;
         var _loc2_:uint = 0;
         _loc2_ = 9;
         _loc1_ = int(_loc2_ - 1);
         while(_loc1_ >= 0)
         {
            if(this.FStepAwardStatus[_loc1_] == -1)
            {
               if(this.FStepAwardStatus[0] == 0)
               {
                  return -1;
               }
               return _loc1_;
            }
            _loc1_--;
         }
         return -1;
      }
      
      public function CurBagPos() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         _loc2_ = 3;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FBigAwardStatus[_loc1_] == 0)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return 0;
      }
      
      public function CurExtraProgress() : uint
      {
         var _loc1_:int = 0;
         var _loc2_:uint = 0;
         if(this.FRushStatus == 1 && this.CurProgress() != 8)
         {
            return this.CurProgress() + 1;
         }
         return this.CurProgress();
      }
      
      public function get StepAwards() : Vector.<TInventories>
      {
         return this.FStepAwards;
      }
      
      public function set StepAwards(param1:Vector.<TInventories>) : void
      {
         this.FStepAwards = param1;
      }
      
      public function get BigAwards() : Vector.<TInventories>
      {
         return this.FBigAwards;
      }
      
      public function set BigAwards(param1:Vector.<TInventories>) : void
      {
         this.FBigAwards = param1;
      }
   }
}

