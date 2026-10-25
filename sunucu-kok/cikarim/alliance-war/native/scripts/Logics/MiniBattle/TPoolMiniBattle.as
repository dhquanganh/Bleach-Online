package Logics.MiniBattle
{
   import Processors.Game.MiniBattle.Mode.*;
   
   public class TPoolMiniBattle
   {
      
      protected static const CLASSNUM:int = 4;
      
      protected static const ClassReference:Vector.<Class> = Vector.<Class>([TOneScreenBattle,TOneBattle,TOneAttrack,TSoliderReward]);
      
      protected var FPoolOneScreenBattle:Vector.<TOneScreenBattle>;
      
      protected var FPoolOneBattle:Vector.<TOneBattle>;
      
      protected var FPoolOneAttrack:Vector.<TOneAttrack>;
      
      protected var FPoolSoliderReward:Vector.<TSoliderReward>;
      
      protected var FPools:Vector.<Object>;
      
      public function TPoolMiniBattle()
      {
         super();
         this.FPools = new Vector.<Object>();
         this.FPoolOneScreenBattle = new Vector.<TOneScreenBattle>();
         this.FPoolOneBattle = new Vector.<TOneBattle>();
         this.FPoolOneAttrack = new Vector.<TOneAttrack>();
         this.FPoolSoliderReward = new Vector.<TSoliderReward>();
         this.FPools.push(this.FPoolOneScreenBattle);
         this.FPools.push(this.FPoolOneBattle);
         this.FPools.push(this.FPoolOneAttrack);
         this.FPools.push(this.FPoolSoliderReward);
      }
      
      public function AcquireOneScreenBattle() : TOneScreenBattle
      {
         if(this.FPoolOneScreenBattle.length > 0)
         {
            return this.FPoolOneScreenBattle.pop();
         }
         return new TOneScreenBattle();
      }
      
      public function AcquireOneBattle() : TOneBattle
      {
         if(this.FPoolOneBattle.length > 0)
         {
            return this.FPoolOneBattle.pop();
         }
         return new TOneBattle();
      }
      
      public function AcquireOneAttrack() : TOneAttrack
      {
         if(this.FPoolOneAttrack.length > 0)
         {
            return this.FPoolOneAttrack.pop();
         }
         return new TOneAttrack();
      }
      
      public function AcquireSoliderReward() : TSoliderReward
      {
         if(this.FPoolSoliderReward.length > 0)
         {
            return this.FPoolSoliderReward.pop();
         }
         return new TSoliderReward();
      }
      
      public function Release(param1:Object) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < CLASSNUM)
         {
            if(param1 is ClassReference[_loc2_])
            {
               this.FPools[_loc2_].push(param1);
               return;
            }
            _loc2_++;
         }
      }
   }
}

