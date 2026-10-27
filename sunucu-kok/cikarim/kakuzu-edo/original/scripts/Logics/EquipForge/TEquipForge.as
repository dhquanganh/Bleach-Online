package Logics.EquipForge
{
   import Processors.Game.Lobby.Utilities.TUtilityLobby;
   
   public class TEquipForge
   {
      
      protected var FGetCount:uint;
      
      protected var FBuyCount:uint;
      
      protected var FTimeStamp:uint;
      
      protected var FEnergy:uint;
      
      public function TEquipForge()
      {
         super();
      }
      
      public function get GetCount() : uint
      {
         return this.FGetCount;
      }
      
      public function set GetCount(param1:uint) : void
      {
         this.FGetCount = param1;
      }
      
      public function get BuyCount() : uint
      {
         return (TUtilityLobby.GetConfigValue(62100001) as int) - this.FBuyCount;
      }
      
      public function set BuyCount(param1:uint) : void
      {
         this.FBuyCount = param1;
      }
      
      public function get TimeStamp() : uint
      {
         return this.FTimeStamp;
      }
      
      public function set TimeStamp(param1:uint) : void
      {
         this.FTimeStamp = param1;
      }
      
      public function get Energy() : uint
      {
         return this.FEnergy;
      }
      
      public function set Energy(param1:uint) : void
      {
         this.FEnergy = param1;
      }
   }
}

