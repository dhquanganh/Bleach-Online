package Processors.Game.MiniBattle.Mode
{
   import Logics.SLogicsCore;
   
   public class TOneScreenBattle
   {
      
      protected var FBattles:Vector.<TOneBattle>;
      
      public function TOneScreenBattle()
      {
         super();
         this.FBattles = new Vector.<TOneBattle>();
      }
      
      public function get Battles() : Vector.<TOneBattle>
      {
         return this.FBattles;
      }
      
      public function get Count() : int
      {
         return this.FBattles.length;
      }
      
      public function Reset() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         this.FBattles.length = 0;
         _loc2_ = int(this.FBattles.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FBattles[_loc1_].Reset();
            SLogicsCore.PoolMiniBattle.Release(this.FBattles[_loc1_]);
            _loc1_++;
         }
         this.FBattles.length = 0;
      }
   }
}

