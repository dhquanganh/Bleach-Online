package Logics.HDNewHalloween
{
   import Logics.DatebaseVO.VO.THDNewHalloweenConsume;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Streamization.HDActivityNewHalloween.ConsumeVo.TCandyShopVo;
   import Logics.Streamization.HDActivityNewHalloween.ConsumeVo.TPumpkinShopVo;
   
   public class THDNewHalloweenConsumeData extends TActivityOSBase
   {
      
      private var FActivityConfig:THDNewHalloweenConsume;
      
      private var FScore:int;
      
      private var FCurDay:int;
      
      private var FAwardState:int;
      
      private var FPumpkinDataVec:Vector.<TPumpkinShopVo>;
      
      private var FCandyDataVec:Vector.<TCandyShopVo>;
      
      public function THDNewHalloweenConsumeData()
      {
         super();
         this.FPumpkinDataVec = new Vector.<TPumpkinShopVo>();
         this.FCandyDataVec = new Vector.<TCandyShopVo>();
      }
      
      public function set ActivityConfig(param1:THDNewHalloweenConsume) : void
      {
         this.FActivityConfig = param1;
      }
      
      public function get ActivityConfig() : THDNewHalloweenConsume
      {
         return this.FActivityConfig;
      }
      
      public function set Score(param1:int) : void
      {
         this.FScore = param1;
      }
      
      public function get Score() : int
      {
         return this.FScore;
      }
      
      public function set CurDay(param1:int) : void
      {
         this.FCurDay = param1;
      }
      
      public function get CurDay() : int
      {
         return this.FCurDay;
      }
      
      public function set AwardState(param1:int) : void
      {
         this.FAwardState = param1;
      }
      
      public function get AwardState() : int
      {
         return this.FAwardState;
      }
      
      public function set PumpkinDataVec(param1:Vector.<TPumpkinShopVo>) : void
      {
         this.FPumpkinDataVec = param1;
      }
      
      public function get PumpkinDataVec() : Vector.<TPumpkinShopVo>
      {
         return this.FPumpkinDataVec;
      }
      
      public function set CandyDataVec(param1:Vector.<TCandyShopVo>) : void
      {
         this.FCandyDataVec = param1;
      }
      
      public function get CandyDataVec() : Vector.<TCandyShopVo>
      {
         return this.FCandyDataVec;
      }
      
      public function GlobalShopSpendGold() : int
      {
         return this.GlobalTotalGold() - this.GlobalSpareGold().SpareGold;
      }
      
      public function GlobalExtraScore() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TPumpkinShopVo = null;
         var _loc4_:int = 0;
         _loc2_ = int(this.FPumpkinDataVec.length);
         _loc4_ = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FPumpkinDataVec[_loc1_];
            if(_loc3_.ShopCartAmount > 0)
            {
               if(_loc3_.IsDouble)
               {
                  _loc4_ += _loc3_.ShopCartAmount * _loc3_.Gold;
               }
            }
            _loc1_++;
         }
         return _loc4_ / this.ActivityConfig.Rate;
      }
      
      public function GlobalTotalGold() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TPumpkinShopVo = null;
         var _loc4_:TCandyShopVo = null;
         var _loc5_:int = 0;
         _loc2_ = int(this.FPumpkinDataVec.length);
         _loc5_ = 0;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FPumpkinDataVec[_loc1_];
            if(_loc3_.ShopCartAmount > 0)
            {
               _loc5_ += _loc3_.ShopCartAmount * _loc3_.Gold;
            }
            _loc1_++;
         }
         _loc2_ = int(this.FCandyDataVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FCandyDataVec[_loc1_];
            if(_loc4_.ShopCartAmount > 0)
            {
               _loc5_ += _loc4_.ShopCartAmount * _loc4_.Gold;
            }
            _loc1_++;
         }
         return _loc5_;
      }
      
      public function GlobalSpareGold(param1:int = 0) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TCandyShopVo = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:Boolean = false;
         var _loc9_:Object = null;
         _loc9_ = new Object();
         _loc3_ = int(this.CandyDataVec.length);
         _loc6_ = 0;
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = this.CandyDataVec[_loc2_];
            if(_loc4_.ShopCartAmount > 0)
            {
               if(_loc4_.IsDiscount)
               {
                  _loc5_ = _loc4_.Gold * _loc4_.ShopCartAmount;
                  if(_loc5_ >= _loc4_.Condition)
                  {
                     _loc6_ += _loc4_.Minus;
                  }
               }
            }
            _loc2_++;
         }
         _loc7_ = this.GlobalTotalGold() - _loc6_;
         if(_loc7_ >= this.ActivityConfig.ShopCartDiscountObj.condition)
         {
            _loc8_ = true;
            _loc6_ += this.ActivityConfig.ShopCartDiscountObj.discount;
         }
         else
         {
            _loc8_ = false;
         }
         _loc9_.IsSatisfyCondition = _loc8_;
         if(param1 == 0)
         {
            _loc9_.SpareGold = _loc6_;
         }
         else
         {
            _loc9_.SpareGold = this.ActivityConfig.ShopCartDiscountObj.condition - _loc7_;
         }
         return _loc9_;
      }
      
      public function GetShopCartData() : Vector.<Object>
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Vector.<Object> = null;
         var _loc4_:TPumpkinShopVo = null;
         var _loc5_:TCandyShopVo = null;
         _loc3_ = new Vector.<Object>();
         _loc2_ = int(this.FPumpkinDataVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc4_ = this.FPumpkinDataVec[_loc1_];
            if(_loc4_.ShopCartAmount > 0)
            {
               _loc3_.push(_loc4_);
            }
            _loc1_++;
         }
         _loc2_ = int(this.FCandyDataVec.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc5_ = this.FCandyDataVec[_loc1_];
            if(_loc5_.ShopCartAmount > 0)
            {
               _loc3_.push(_loc5_);
            }
            _loc1_++;
         }
         return _loc3_;
      }
   }
}

