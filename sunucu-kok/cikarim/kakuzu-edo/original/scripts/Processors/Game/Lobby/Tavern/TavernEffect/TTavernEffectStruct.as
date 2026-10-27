package Processors.Game.Lobby.Tavern.TavernEffect
{
   public class TTavernEffectStruct
   {
      
      protected var FHeroId:uint;
      
      protected var FIsWin:Boolean;
      
      protected var FReturnType:uint;
      
      protected var FReturnMoney:uint;
      
      protected var FAwardSoulType:uint;
      
      protected var FAwardSoulValue:uint;
      
      protected var FPosX:uint;
      
      protected var FPosY:uint;
      
      public function TTavernEffectStruct()
      {
         super();
      }
      
      public function get HeroId() : uint
      {
         return this.FHeroId;
      }
      
      public function set HeroId(param1:uint) : void
      {
         this.FHeroId = param1;
      }
      
      public function get IsWin() : Boolean
      {
         return this.FIsWin;
      }
      
      public function set IsWin(param1:Boolean) : void
      {
         this.FIsWin = param1;
      }
      
      public function get ReturnType() : uint
      {
         return this.FReturnType;
      }
      
      public function set ReturnType(param1:uint) : void
      {
         this.FReturnType = param1;
      }
      
      public function get ReturnMoney() : uint
      {
         return this.FReturnMoney;
      }
      
      public function set ReturnMoney(param1:uint) : void
      {
         this.FReturnMoney = param1;
      }
      
      public function get AwardSoulType() : uint
      {
         return this.FAwardSoulType;
      }
      
      public function set AwardSoulType(param1:uint) : void
      {
         this.FAwardSoulType = param1;
      }
      
      public function get AwardSoulValue() : uint
      {
         return this.FAwardSoulValue;
      }
      
      public function set AwardSoulValue(param1:uint) : void
      {
         this.FAwardSoulValue = param1;
      }
      
      public function get PosX() : uint
      {
         return this.FPosX;
      }
      
      public function set PosX(param1:uint) : void
      {
         this.FPosX = param1;
      }
      
      public function get PosY() : uint
      {
         return this.FPosY;
      }
      
      public function set PosY(param1:uint) : void
      {
         this.FPosY = param1;
      }
   }
}

