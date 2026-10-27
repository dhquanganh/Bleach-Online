package Logics.HDLaborDay2016
{
   import Logics.DatebaseVO.VO.THDLaborDayPet;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   
   public class TLaborDayPet extends TActivityOSBase
   {
      
      protected var FBagStatus:Vector.<int>;
      
      protected var FBarStatus:Vector.<int>;
      
      protected var FCurPeriod:uint;
      
      protected var FScore:uint;
      
      protected var FRecharged:uint;
      
      protected var FConsumed:uint;
      
      protected var FPetStatus:int;
      
      protected var FGifts:Vector.<int>;
      
      protected var FFunds:Vector.<TInventories>;
      
      protected var FConfig:THDLaborDayPet;
      
      public function TLaborDayPet()
      {
         super();
         this.FGifts = new Vector.<int>();
         this.FFunds = new Vector.<TInventories>();
         this.FBagStatus = new Vector.<int>();
         this.FBarStatus = new Vector.<int>();
      }
      
      public function get BagStatus() : Vector.<int>
      {
         return this.FBagStatus;
      }
      
      public function set BagStatus(param1:Vector.<int>) : void
      {
         this.FBagStatus = param1;
      }
      
      public function get BarStatus() : Vector.<int>
      {
         return this.FBarStatus;
      }
      
      public function set BarStatus(param1:Vector.<int>) : void
      {
         this.FBarStatus = param1;
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
      
      public function get PetStatus() : int
      {
         return this.FPetStatus;
      }
      
      public function set PetStatus(param1:int) : void
      {
         this.FPetStatus = param1;
      }
      
      public function get CurPeriod() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc1_ = 6;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.FScore >= this.FConfig.Gift.score[_loc2_])
            {
               this.FCurPeriod = _loc2_;
            }
            _loc2_++;
         }
         return this.FCurPeriod + 1;
      }
      
      public function get Gifts() : Vector.<int>
      {
         return this.FGifts;
      }
      
      public function set Gifts(param1:Vector.<int>) : void
      {
         this.FGifts = param1;
      }
      
      public function get Recharged() : uint
      {
         return this.FRecharged;
      }
      
      public function set Recharged(param1:uint) : void
      {
         this.FRecharged = param1;
      }
      
      public function get Consumed() : uint
      {
         return this.FConsumed;
      }
      
      public function set Consumed(param1:uint) : void
      {
         this.FConsumed = param1;
      }
      
      public function get Config() : THDLaborDayPet
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDLaborDayPet) : void
      {
         this.FConfig = param1;
      }
      
      public function get Funds() : Vector.<TInventories>
      {
         return this.FFunds;
      }
      
      public function set Funds(param1:Vector.<TInventories>) : void
      {
         this.FFunds = param1;
      }
   }
}

