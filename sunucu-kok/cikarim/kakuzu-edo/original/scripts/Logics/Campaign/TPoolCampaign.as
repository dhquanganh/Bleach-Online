package Logics.Campaign
{
   import Foundation.Pools.TPoolAutomatic;
   import Logics.Spaces.LogicsSpace;
   
   use namespace LogicsSpace;
   
   public class TPoolCampaign extends TPoolAutomatic
   {
      
      protected var FIndexStars:int;
      
      protected var FIndexCampaigns:int;
      
      protected var FIndexMonsters:int;
      
      public function TPoolCampaign()
      {
         super();
      }
      
      override protected function RegisterClasses() : void
      {
         this.FIndexStars = RegisterClass(TStar);
         this.FIndexCampaigns = RegisterClass(TCampaign);
         this.FIndexMonsters = RegisterClass(TMonster);
      }
      
      public function AcquireStar(param1:uint) : TStar
      {
         var _loc2_:TStar = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexStars) as TStar;
         if(_loc2_ != null)
         {
            _loc2_.Coerce(param1);
         }
         else
         {
            _loc2_ = new TStar(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireCampaign(param1:uint) : TCampaign
      {
         var _loc2_:TCampaign = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexCampaigns) as TCampaign;
         if(_loc2_ != null)
         {
            _loc2_.Coerce(param1);
         }
         else
         {
            _loc2_ = new TCampaign(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
      
      public function AcquireMonster(param1:uint) : TMonster
      {
         var _loc2_:TMonster = null;
         _loc2_ = InstanceAcquireByIndex(this.FIndexMonsters) as TMonster;
         if(_loc2_ != null)
         {
            _loc2_.Coerce(param1);
         }
         else
         {
            _loc2_ = new TMonster(param1);
         }
         FStubsReferences.push(_loc2_.StubReferences);
         return _loc2_;
      }
   }
}

