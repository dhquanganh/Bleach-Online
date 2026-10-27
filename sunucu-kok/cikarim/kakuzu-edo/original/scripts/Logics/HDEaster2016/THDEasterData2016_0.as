package Logics.HDEaster2016
{
   import Logics.DatebaseVO.VO.THDEaster2016_0;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class THDEasterData2016_0 extends TActivityOSBase
   {
      
      protected var FRebirth:int;
      
      protected var FServerLimit:uint;
      
      protected var FLastItemlevel_1:int;
      
      protected var FLastItemlevel_2:int;
      
      protected var FLastItemlevel_3:int;
      
      protected var FLastBigAward:int;
      
      protected var FLastTime:int;
      
      protected var FTimePeriod:int;
      
      protected var FCurDay:uint;
      
      protected var FHaveEgg:uint;
      
      protected var FHaveEgg02:uint;
      
      protected var FHaveEgg03:uint;
      
      protected var FRebirthGift:TInventories;
      
      protected var FGift00:TInventories;
      
      protected var FGift01:Vector.<TInventories>;
      
      protected var FGift02:Vector.<TInventories>;
      
      protected var FGift03:Vector.<TInventories>;
      
      protected var FConfig:THDEaster2016_0;
      
      public function THDEasterData2016_0()
      {
         super();
      }
      
      public function get Rebirth() : int
      {
         return this.FRebirth;
      }
      
      public function set Rebirth(param1:int) : void
      {
         this.FRebirth = param1;
      }
      
      public function get LastItemlevel_1() : int
      {
         return this.FLastItemlevel_1;
      }
      
      public function set LastItemlevel_1(param1:int) : void
      {
         this.FLastItemlevel_1 = param1;
      }
      
      public function get LastItemlevel_2() : int
      {
         return this.FLastItemlevel_2;
      }
      
      public function set LastItemlevel_2(param1:int) : void
      {
         this.FLastItemlevel_2 = param1;
      }
      
      public function get LastItemlevel_3() : int
      {
         return this.FLastItemlevel_3;
      }
      
      public function set LastItemlevel_3(param1:int) : void
      {
         this.FLastItemlevel_3 = param1;
      }
      
      public function get LastTime() : int
      {
         return this.FLastTime;
      }
      
      public function set LastTime(param1:int) : void
      {
         this.FLastTime = param1;
      }
      
      public function get TimePeriod() : int
      {
         return this.FTimePeriod;
      }
      
      public function set TimePeriod(param1:int) : void
      {
         if(param1 == 3)
         {
            param1 = 2;
         }
         if(param1 == 7)
         {
            param1 = 2;
         }
         this.FTimePeriod = param1;
      }
      
      public function get CurDay() : uint
      {
         return this.FCurDay;
      }
      
      public function set CurDay(param1:uint) : void
      {
         this.FCurDay = param1;
      }
      
      public function get Config() : THDEaster2016_0
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDEaster2016_0) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         this.FConfig = param1;
         this.FGift00 = new TInventories();
         SToolReward.GetAwardsByAwardID(this.FConfig.Gift00.awardId,this.FGift00);
         _loc2_ = uint(this.FConfig.Gift01.awardId.length);
         this.FGift01 = new Vector.<TInventories>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FGift01[_loc3_] = new TInventories();
            SToolReward.GetAwardsByAwardID(this.FConfig.Gift01.awardId[_loc3_],this.FGift01[_loc3_]);
            _loc3_++;
         }
         _loc2_ = uint(this.FConfig.Gift02.awardId.length);
         this.FGift02 = new Vector.<TInventories>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FGift02[_loc3_] = new TInventories();
            SToolReward.GetAwardsByAwardID(this.FConfig.Gift02.awardId[_loc3_],this.FGift02[_loc3_]);
            _loc3_++;
         }
         _loc2_ = uint(this.FConfig.Gift03.awardId.length);
         this.FGift03 = new Vector.<TInventories>(_loc2_);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            this.FGift03[_loc3_] = new TInventories();
            SToolReward.GetAwardsByAwardID(this.FConfig.Gift03.awardId[_loc3_],this.FGift03[_loc3_]);
            _loc3_++;
         }
         this.FRebirthGift = new TInventories();
         SToolReward.GetAwardsByAwardID(this.FConfig.Gift00.awardId,this.FRebirthGift);
      }
      
      public function get Gift01() : Vector.<TInventories>
      {
         return this.FGift01;
      }
      
      public function get Gift02() : Vector.<TInventories>
      {
         return this.FGift02;
      }
      
      public function get Gift03() : Vector.<TInventories>
      {
         return this.FGift03;
      }
      
      public function get HaveEgg() : uint
      {
         return this.FHaveEgg;
      }
      
      public function set HaveEgg(param1:uint) : void
      {
         this.FHaveEgg = param1;
      }
      
      public function get LastBigAward() : int
      {
         return this.FLastBigAward;
      }
      
      public function set LastBigAward(param1:int) : void
      {
         this.FLastBigAward = param1;
      }
      
      public function get ServerLimit() : uint
      {
         return this.FServerLimit;
      }
      
      public function set ServerLimit(param1:uint) : void
      {
         this.FServerLimit = param1;
      }
      
      public function get HaveEgg02() : uint
      {
         return this.FHaveEgg02;
      }
      
      public function set HaveEgg02(param1:uint) : void
      {
         this.FHaveEgg02 = param1;
      }
      
      public function get HaveEgg03() : uint
      {
         return this.FHaveEgg03;
      }
      
      public function set HaveEgg03(param1:uint) : void
      {
         this.FHaveEgg03 = param1;
      }
      
      public function get RebirthGift() : TInventories
      {
         return this.FRebirthGift;
      }
      
      public function set RebirthGift(param1:TInventories) : void
      {
         this.FRebirthGift = param1;
      }
      
      public function get Gift00() : TInventories
      {
         return this.FGift00;
      }
   }
}

