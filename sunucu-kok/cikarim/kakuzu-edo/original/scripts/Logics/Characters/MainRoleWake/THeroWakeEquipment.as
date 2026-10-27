package Logics.Characters.MainRoleWake
{
   import Logics.DatebaseVO.VO.TLeaderWakeUp;
   import Logics.Inventories.TInventory;
   
   public class THeroWakeEquipment extends TInventory
   {
      
      protected var FCurStreng:uint;
      
      protected var FWakeUpConfig:TLeaderWakeUp;
      
      public function THeroWakeEquipment(param1:uint)
      {
         super(param1);
      }
      
      public function get CurStreng() : uint
      {
         return this.FCurStreng;
      }
      
      public function set CurStreng(param1:uint) : void
      {
         this.FCurStreng = param1;
      }
      
      public function get WakeUpConfig() : TLeaderWakeUp
      {
         return this.FWakeUpConfig;
      }
      
      public function set WakeUpConfig(param1:TLeaderWakeUp) : void
      {
         this.FWakeUpConfig = param1;
      }
   }
}

