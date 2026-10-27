package Logics.KillHero
{
   public class TKillHero
   {
      
      protected var FIsInit:Boolean;
      
      protected var FNeedMilitaryOrder:int;
      
      protected var FCurHeroId:int;
      
      protected var FKillHeroInfo:Vector.<TSingleKillHero>;
      
      public function TKillHero()
      {
         super();
         this.FIsInit = false;
         this.FKillHeroInfo = new Vector.<TSingleKillHero>();
      }
      
      public function get IsInit() : Boolean
      {
         return this.FIsInit;
      }
      
      public function set IsInit(param1:Boolean) : void
      {
         this.FIsInit = param1;
      }
      
      public function get NeedMilitaryOrder() : int
      {
         return this.FNeedMilitaryOrder;
      }
      
      public function set NeedMilitaryOrder(param1:int) : void
      {
         this.FNeedMilitaryOrder = param1;
      }
      
      public function get CurHeroId() : int
      {
         return this.FCurHeroId;
      }
      
      public function set CurHeroId(param1:int) : void
      {
         this.FCurHeroId = param1;
      }
      
      public function get KillHeroInfo() : Vector.<TSingleKillHero>
      {
         return this.FKillHeroInfo;
      }
      
      public function set KillHeroInfo(param1:Vector.<TSingleKillHero>) : void
      {
         this.FKillHeroInfo = param1;
      }
      
      public function get NewKillHeroIndex() : int
      {
         var _loc1_:int = 0;
         var _loc2_:TSingleKillHero = null;
         if(this.FCurHeroId <= 0)
         {
            return 0;
         }
         _loc1_ = 0;
         while(_loc1_ < this.FKillHeroInfo.length)
         {
            _loc2_ = this.FKillHeroInfo[_loc1_];
            if(_loc2_.KillHeroId == this.FCurHeroId)
            {
               return _loc1_;
            }
            _loc1_++;
         }
         return _loc1_;
      }
      
      public function ResetHero(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:TSingleKillHero = null;
         _loc2_ = 0;
         while(_loc2_ < this.FKillHeroInfo.length)
         {
            _loc3_ = this.FKillHeroInfo[_loc2_];
            if(_loc3_.KillHeroId == param1)
            {
               _loc3_.ResetCount += 1;
               return;
            }
            _loc2_++;
         }
      }
      
      public function GetIndexById(param1:uint) : uint
      {
         var _loc2_:int = 0;
         var _loc3_:TSingleKillHero = null;
         _loc2_ = 0;
         while(_loc2_ < this.FKillHeroInfo.length)
         {
            _loc3_ = this.FKillHeroInfo[_loc2_];
            if(_loc3_.KillHeroId == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return _loc2_;
      }
      
      public function GetSingleKillHeroById(param1:uint) : TSingleKillHero
      {
         var _loc2_:int = 0;
         var _loc3_:TSingleKillHero = null;
         _loc2_ = 0;
         while(_loc2_ < this.FKillHeroInfo.length)
         {
            _loc3_ = this.FKillHeroInfo[_loc2_];
            if(_loc3_.KillHeroId == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
   }
}

