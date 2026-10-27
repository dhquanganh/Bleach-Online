package Logics.HDNewYear2017
{
   import Logics.DatebaseVO.VO.THDNewYear2017Discount;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TNewYear2017Discount extends TActivityOSBase
   {
      
      protected var FScore:uint;
      
      protected var FDiscount:uint;
      
      protected var FCurItemsIndex:Vector.<uint>;
      
      protected var FCurInvs:Vector.<TInventories>;
      
      protected var FCurCosts:Vector.<uint>;
      
      protected var FPerviewInvs:Vector.<TInventories>;
      
      protected var FConfig:THDNewYear2017Discount;
      
      public function TNewYear2017Discount()
      {
         super();
         this.FCurInvs = new Vector.<TInventories>();
         this.FCurInvs[0] = new TInventories();
         this.FPerviewInvs = new Vector.<TInventories>();
         this.FCurItemsIndex = new Vector.<uint>();
         this.FCurCosts = new Vector.<uint>();
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
      
      public function get Discount() : uint
      {
         return this.FDiscount;
      }
      
      public function set Discount(param1:uint) : void
      {
         this.FDiscount = param1;
      }
      
      public function get CurInvs() : Vector.<TInventories>
      {
         return this.FCurInvs;
      }
      
      public function set CurInvs(param1:Vector.<TInventories>) : void
      {
         this.FCurInvs = param1;
      }
      
      public function get CurCosts() : Vector.<uint>
      {
         return this.FCurCosts;
      }
      
      public function set CurCosts(param1:Vector.<uint>) : void
      {
         this.FCurCosts = param1;
      }
      
      public function get PerviewInvs() : Vector.<TInventories>
      {
         return this.FPerviewInvs;
      }
      
      public function set PerviewInvs(param1:Vector.<TInventories>) : void
      {
         this.FPerviewInvs = param1;
      }
      
      public function get Config() : THDNewYear2017Discount
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDNewYear2017Discount) : void
      {
         this.FConfig = param1;
      }
      
      public function get CurItemsIndex() : Vector.<uint>
      {
         return this.FCurItemsIndex;
      }
      
      public function set CurItemsIndex(param1:Vector.<uint>) : void
      {
         this.FCurItemsIndex = param1;
      }
      
      public function GetInfo(param1:uint) : Object
      {
         var _loc2_:Object = null;
         var _loc3_:TInventories = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         _loc2_ = new Object();
         _loc3_ = new TInventories();
         if(param1 > 0 && param1 < 10)
         {
            _loc4_ = uint(this.FConfig.FOneAward[param1 - 1].awardid);
            _loc5_ = uint(this.FConfig.FOneAward[param1 - 1].cost);
         }
         if(param1 >= 10 && param1 < 20)
         {
            _loc4_ = uint(this.FConfig.FTwoAward[param1 - 10].awardid);
            _loc5_ = uint(this.FConfig.FTwoAward[param1 - 10].cost);
         }
         if(param1 >= 20 && param1 < 30)
         {
            _loc4_ = uint(this.FConfig.FThreeAward[param1 - 20].awardid);
            _loc5_ = uint(this.FConfig.FThreeAward[param1 - 20].cost);
         }
         SToolReward.GetAwardsByAwardID(_loc4_,_loc3_);
         _loc2_.inv = _loc3_.GetInventoryByIndex(0);
         _loc2_.cost = _loc5_;
         return _loc2_;
      }
   }
}

