package Logics.HDEveryDayAward
{
   import Logics.DatebaseVO.VO.THDEveryDayAward;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TEveryDayAwardData extends TActivityOSBase
   {
      
      protected var FConfig:THDEveryDayAward;
      
      protected var FRecharge:uint;
      
      protected var FRechargeGift:int;
      
      protected var FParticipate:uint;
      
      protected var FShareGiftState:Vector.<int>;
      
      protected var FRechargeGiftInv:Vector.<TInventories>;
      
      protected var FShareGiftInvs:Vector.<Vector.<TInventories>>;
      
      protected var FDay:uint;
      
      public function TEveryDayAwardData()
      {
         super();
         this.FRechargeGiftInv = new Vector.<TInventories>();
         this.FShareGiftInvs = new Vector.<Vector.<TInventories>>();
      }
      
      public function get Recharge() : uint
      {
         return this.FRecharge;
      }
      
      public function set Recharge(param1:uint) : void
      {
         this.FRecharge = param1;
      }
      
      public function get RechargeGift() : int
      {
         return this.FRechargeGift;
      }
      
      public function set RechargeGift(param1:int) : void
      {
         this.FRechargeGift = param1;
      }
      
      public function get Participate() : uint
      {
         return this.FParticipate;
      }
      
      public function set Participate(param1:uint) : void
      {
         this.FParticipate = param1;
      }
      
      public function get ShareGiftState() : Vector.<int>
      {
         return this.FShareGiftState;
      }
      
      public function set ShareGiftState(param1:Vector.<int>) : void
      {
         this.FShareGiftState = param1;
      }
      
      public function get Day() : uint
      {
         return this.FDay;
      }
      
      public function set Day(param1:uint) : void
      {
         this.FDay = param1;
      }
      
      public function get Config() : THDEveryDayAward
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDEveryDayAward) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:Vector.<Object> = null;
         var _loc5_:TInventories = null;
         var _loc6_:Vector.<TInventories> = null;
         if(this.FConfig != null)
         {
            return;
         }
         this.FConfig = param1;
         this.FShareGiftState = new Vector.<int>(this.FConfig.ShareGift.length);
         for each(_loc2_ in this.FConfig.RechargeGift)
         {
            _loc5_ = new TInventories();
            SToolReward.GetAwardsByAwardID(_loc2_.award,_loc5_);
            this.FRechargeGiftInv.push(_loc5_);
         }
         for each(_loc2_ in this.FConfig.ShareGift)
         {
            _loc6_ = new Vector.<TInventories>();
            _loc4_ = Vector.<Object>(_loc2_);
            for each(_loc3_ in _loc4_)
            {
               _loc5_ = new TInventories();
               SToolReward.GetAwardsByAwardID(_loc3_.award,_loc5_);
               _loc6_.push(_loc5_);
            }
            this.FShareGiftInvs.push(_loc6_);
         }
      }
      
      public function get RechargeGiftInv() : Vector.<TInventories>
      {
         return this.FRechargeGiftInv;
      }
      
      public function get ShareGiftInvs() : Vector.<Vector.<TInventories>>
      {
         return this.FShareGiftInvs;
      }
   }
}

