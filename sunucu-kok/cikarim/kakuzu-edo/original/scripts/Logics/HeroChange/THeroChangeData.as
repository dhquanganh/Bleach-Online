package Logics.HeroChange
{
   import Foundation.Registries.TRegistryInstance;
   import Logics.Inventories.TInventory;
   
   public class THeroChangeData
   {
      
      protected var FAllHeroRegistry:TRegistryInstance;
      
      protected var FPowerfulChip:int;
      
      protected var FNormalSoulPillNum:int;
      
      protected var FGradeSoulPillNum:int;
      
      protected var FFightTime:int;
      
      protected var FBuyTime:int;
      
      protected var FCurrentBattleID:int;
      
      protected var FCurrentBattleHeroID:int;
      
      protected var FCanFightTimeEveryDay:int;
      
      protected var FNormalSoulPillInventory:TInventory;
      
      protected var FGradeSoulPillInventory:TInventory;
      
      protected var FInit:Boolean;
      
      public function THeroChangeData()
      {
         super();
         this.FAllHeroRegistry = new TRegistryInstance();
      }
      
      public function get PowerfulChip() : int
      {
         return this.FPowerfulChip;
      }
      
      public function set PowerfulChip(param1:int) : void
      {
         this.FPowerfulChip = param1;
      }
      
      public function get NormalSoulPillNum() : int
      {
         return this.FNormalSoulPillNum;
      }
      
      public function set NormalSoulPillNum(param1:int) : void
      {
         this.FNormalSoulPillNum = param1;
      }
      
      public function get GradeSoulPillNum() : int
      {
         return this.FGradeSoulPillNum;
      }
      
      public function set GradeSoulPillNum(param1:int) : void
      {
         this.FGradeSoulPillNum = param1;
      }
      
      public function get AllHeroRegistry() : TRegistryInstance
      {
         return this.FAllHeroRegistry;
      }
      
      public function get Init() : Boolean
      {
         return this.FInit;
      }
      
      public function set Init(param1:Boolean) : void
      {
         this.FInit = param1;
      }
      
      public function get NormalSoulPillInventory() : TInventory
      {
         return this.FNormalSoulPillInventory;
      }
      
      public function set NormalSoulPillInventory(param1:TInventory) : void
      {
         this.FNormalSoulPillInventory = param1;
      }
      
      public function get GradeSoulPillInventory() : TInventory
      {
         return this.FGradeSoulPillInventory;
      }
      
      public function set GradeSoulPillInventory(param1:TInventory) : void
      {
         this.FGradeSoulPillInventory = param1;
      }
      
      public function get FightTime() : int
      {
         return this.FFightTime;
      }
      
      public function set FightTime(param1:int) : void
      {
         this.FFightTime = param1;
      }
      
      public function get BuyTime() : int
      {
         return this.FBuyTime;
      }
      
      public function set BuyTime(param1:int) : void
      {
         this.FBuyTime = param1;
      }
      
      public function get CurrentBattleID() : int
      {
         return this.FCurrentBattleID;
      }
      
      public function set CurrentBattleID(param1:int) : void
      {
         this.FCurrentBattleID = param1;
      }
      
      public function get CurrentBattleHeroID() : int
      {
         return this.FCurrentBattleHeroID;
      }
      
      public function set CurrentBattleHeroID(param1:int) : void
      {
         this.FCurrentBattleHeroID = param1;
      }
      
      public function get CanFightTimeEveryDay() : int
      {
         return this.FCanFightTimeEveryDay;
      }
      
      public function set CanFightTimeEveryDay(param1:int) : void
      {
         this.FCanFightTimeEveryDay = param1;
      }
      
      public function GetHeroChangeByChipID(param1:uint, param2:Vector.<THeroChange>) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Vector.<THeroChange> = null;
         var _loc8_:THeroChange = null;
         _loc4_ = this.FAllHeroRegistry.Count;
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            _loc7_ = this.FAllHeroRegistry.GetInstanceByIndex(_loc3_) as Vector.<THeroChange>;
            _loc6_ = int(_loc7_.length);
            _loc5_ = 0;
            while(_loc5_ < _loc6_)
            {
               _loc8_ = _loc7_[_loc5_];
               if(_loc8_.HeroChangeAttr.ChipID == param1)
               {
                  param2.push(_loc8_);
               }
               _loc5_++;
            }
            _loc3_++;
         }
      }
      
      public function GetHeroChangeByHeroID(param1:uint) : THeroChange
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<THeroChange> = null;
         var _loc7_:THeroChange = null;
         _loc3_ = this.FAllHeroRegistry.Count;
         _loc2_ = 0;
         loop0:
         while(_loc2_ < _loc3_)
         {
            _loc6_ = this.FAllHeroRegistry.GetInstanceByIndex(_loc2_) as Vector.<THeroChange>;
            _loc5_ = int(_loc6_.length);
            _loc4_ = 0;
            while(true)
            {
               if(_loc4_ >= _loc5_)
               {
                  _loc2_++;
                  continue loop0;
               }
               _loc7_ = _loc6_[_loc4_];
               if(_loc7_.Hero.Identifier == param1)
               {
                  break;
               }
               _loc4_++;
            }
            return _loc7_;
         }
         return null;
      }
      
      public function GetHeroChangeByCityID(param1:uint) : THeroChange
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Vector.<THeroChange> = null;
         var _loc7_:THeroChange = null;
         _loc3_ = this.FAllHeroRegistry.Count;
         _loc2_ = 0;
         loop0:
         while(_loc2_ < _loc3_)
         {
            _loc6_ = this.FAllHeroRegistry.GetInstanceByIndex(_loc2_) as Vector.<THeroChange>;
            _loc5_ = int(_loc6_.length);
            _loc4_ = 0;
            while(true)
            {
               if(_loc4_ >= _loc5_)
               {
                  _loc2_++;
                  continue loop0;
               }
               _loc7_ = _loc6_[_loc4_];
               if(_loc7_.HeroChangeAttr.CityID == param1)
               {
                  break;
               }
               _loc4_++;
            }
            return _loc7_;
         }
         return null;
      }
   }
}

