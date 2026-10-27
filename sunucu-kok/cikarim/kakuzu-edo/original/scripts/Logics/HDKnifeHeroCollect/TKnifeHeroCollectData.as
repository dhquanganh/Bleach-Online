package Logics.HDKnifeHeroCollect
{
   import Logics.DatebaseVO.VO.Json.TRewards;
   import Logics.DatebaseVO.VO.THDKnifeHeroCollect;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   import flash.utils.Dictionary;
   
   public class TKnifeHeroCollectData extends TActivityOSBase
   {
      
      protected var FConfig:THDKnifeHeroCollect;
      
      protected var FCurConsumeGold:uint;
      
      protected var FCurRechargeGold:uint;
      
      protected var FConsumeGoldState:Array;
      
      protected var FRechargeGoldState:Array;
      
      protected var FKnifeInventoriesDict:Dictionary;
      
      protected var FHeroInventoriesDict:Dictionary;
      
      public function TKnifeHeroCollectData()
      {
         super();
         this.FConsumeGoldState = [];
         this.FRechargeGoldState = [];
         this.FKnifeInventoriesDict = new Dictionary();
         this.FHeroInventoriesDict = new Dictionary();
      }
      
      protected function ParsingConfig() : void
      {
         this.ParsingCondition(this.FKnifeInventoriesDict,this.FConfig.KnifeConditionDict);
         this.ParsingCondition(this.FHeroInventoriesDict,this.FConfig.HeroConditionDict);
      }
      
      protected function ParsingCondition(param1:Dictionary, param2:Dictionary) : void
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:TRewards = null;
         var _loc6_:TInventories = null;
         for(_loc4_ in param2)
         {
            _loc3_ = param2[_loc4_];
            _loc5_ = new TRewards(_loc3_);
            _loc6_ = new TInventories();
            SToolReward.CreateRewardInventoryByRewardInfor(_loc5_,_loc6_);
            param1[_loc4_] = _loc6_;
         }
      }
      
      public function get Config() : THDKnifeHeroCollect
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDKnifeHeroCollect) : void
      {
         if(this.FConfig != null)
         {
            return;
         }
         this.FConfig = param1;
         this.ParsingConfig();
      }
      
      public function get CurConsumeGold() : uint
      {
         return this.FCurConsumeGold;
      }
      
      public function set CurConsumeGold(param1:uint) : void
      {
         this.FCurConsumeGold = param1;
      }
      
      public function get CurRechargeGold() : uint
      {
         return this.FCurRechargeGold;
      }
      
      public function set CurRechargeGold(param1:uint) : void
      {
         this.FCurRechargeGold = param1;
      }
      
      public function get ConsumeGoldState() : Array
      {
         return this.FConsumeGoldState;
      }
      
      public function get RechargeGoldState() : Array
      {
         return this.FRechargeGoldState;
      }
      
      public function get KnifeInventoriesDict() : Dictionary
      {
         return this.FKnifeInventoriesDict;
      }
      
      public function get HeroInventoriesDict() : Dictionary
      {
         return this.FHeroInventoriesDict;
      }
   }
}

