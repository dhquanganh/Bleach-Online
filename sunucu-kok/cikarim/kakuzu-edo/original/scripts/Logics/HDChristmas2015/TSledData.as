package Logics.HDChristmas2015
{
   import Logics.DatebaseVO.VO.THDSled;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChristmas2015.VO.TSledVO;
   import Logics.HDChristmas2015.VO.TSledVOPool;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   
   public class TSledData extends TActivityOSBase
   {
      
      protected var FSledVOs:Vector.<TSledVO>;
      
      protected var FCurTransportType:uint;
      
      protected var FRemainSnatch:uint;
      
      protected var FCurFreeTransport:uint;
      
      protected var FCurHaveChristmasCards:uint;
      
      protected var FCurTransporting:Boolean;
      
      protected var FGiftState:int;
      
      protected var FHaveTransportReward:Boolean;
      
      protected var FConfig:THDSled;
      
      protected var FShopStates:Vector.<int>;
      
      protected var FScoreShop:TInventories;
      
      protected var FCurWheelSnatched:Boolean;
      
      protected var FSledGifts:Vector.<TInventories>;
      
      public function TSledData()
      {
         super();
         this.FSledVOs = new Vector.<TSledVO>();
         this.FShopStates = new Vector.<int>();
         this.FScoreShop = new TInventories();
         this.FSledGifts = new Vector.<TInventories>();
      }
      
      public function get SledVOs() : Vector.<TSledVO>
      {
         return this.FSledVOs;
      }
      
      public function get CurTransportType() : uint
      {
         return this.FCurTransportType;
      }
      
      public function set CurTransportType(param1:uint) : void
      {
         this.FCurTransportType = param1;
      }
      
      public function get RemainSnatch() : uint
      {
         return this.FRemainSnatch;
      }
      
      public function set RemainSnatch(param1:uint) : void
      {
         this.FRemainSnatch = param1;
      }
      
      public function get CurFreeTransport() : uint
      {
         return this.FCurFreeTransport;
      }
      
      public function set CurFreeTransport(param1:uint) : void
      {
         this.FCurFreeTransport = param1;
      }
      
      public function get CurHaveChristmasCards() : uint
      {
         return this.FCurHaveChristmasCards;
      }
      
      public function set CurHaveChristmasCards(param1:uint) : void
      {
         this.FCurHaveChristmasCards = param1;
      }
      
      public function get CurTransporting() : Boolean
      {
         return this.FCurTransporting;
      }
      
      public function set CurTransporting(param1:Boolean) : void
      {
         this.FCurTransporting = param1;
      }
      
      public function get GiftState() : int
      {
         return this.FGiftState;
      }
      
      public function set GiftState(param1:int) : void
      {
         this.FGiftState = param1;
      }
      
      public function get HaveTransportReward() : Boolean
      {
         return this.FHaveTransportReward;
      }
      
      public function set HaveTransportReward(param1:Boolean) : void
      {
         this.FHaveTransportReward = param1;
      }
      
      public function get Config() : THDSled
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDSled) : void
      {
         this.FConfig = param1;
      }
      
      public function get ShopStates() : Vector.<int>
      {
         return this.FShopStates;
      }
      
      public function get ScoreShop() : TInventories
      {
         return this.FScoreShop;
      }
      
      public function get CurWheelSnatched() : Boolean
      {
         return this.FCurWheelSnatched;
      }
      
      public function set CurWheelSnatched(param1:Boolean) : void
      {
         this.FCurWheelSnatched = param1;
      }
      
      public function get SledGifts() : Vector.<TInventories>
      {
         return this.FSledGifts;
      }
      
      public function GetSledObjByType(param1:uint) : Object
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.FConfig.SledInfos.infos)
         {
            if(_loc2_.type == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function GetSledIndexByType(param1:uint) : int
      {
         var _loc2_:Object = null;
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         _loc4_ = this.FConfig.SledInfos.infos;
         _loc5_ = _loc4_.length;
         _loc3_ = 0;
         while(_loc3_ < _loc5_)
         {
            _loc2_ = _loc4_[_loc3_];
            if(_loc2_.type == param1)
            {
               return _loc3_;
            }
            _loc3_++;
         }
         return -1;
      }
      
      public function GetMySled() : TSledVO
      {
         var _loc1_:TSledVO = null;
         for each(_loc1_ in this.FSledVOs)
         {
            if(_loc1_.HighID == SLogicsCore.Character.Identifier0 && _loc1_.LowID == SLogicsCore.Character.Identifier1)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function GetSledByID(param1:int, param2:int) : TSledVO
      {
         var _loc3_:TSledVO = null;
         for each(_loc3_ in this.FSledVOs)
         {
            if(_loc3_.HighID == param1 && _loc3_.LowID == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function GetTransportTimestamp() : Number
      {
         var _loc1_:TSledVO = null;
         for each(_loc1_ in this.FSledVOs)
         {
            if(_loc1_.HighID == SLogicsCore.Character.Identifier0 && _loc1_.LowID == SLogicsCore.Character.Identifier1)
            {
               return _loc1_.StartTime;
            }
         }
         return 0;
      }
      
      public function MySledArrivals() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:TSledVO = null;
         this.FCurTransporting = false;
         this.FHaveTransportReward = true;
         _loc2_ = this.FSledVOs.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FSledVOs[_loc1_];
            TSledVOPool.RelObj(_loc3_);
            _loc1_++;
         }
         this.FSledVOs.length = 0;
      }
   }
}

