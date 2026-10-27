package Logics.HDNewYearSheep
{
   import Logics.DatebaseVO.VO.TFirecrackersConfig;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDNewYearSheep.FirecrackersVO.TFireGiftBoxVO;
   import Rendering.Overlayers.HDGiftBox.TOverlayerGiftBox;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TFirecrackersData extends TActivityOSBase
   {
      
      public static const FireState_OFF:int = 0;
      
      public static const FireState_ON:int = 1;
      
      public static const BoxCount:int = 24;
      
      public static const FireCount:int = 25;
      
      protected var FBoxList:Vector.<TFireGiftBoxVO>;
      
      protected var FFireState:Vector.<int>;
      
      protected var FFireTotal:int;
      
      protected var FNeedFire:int;
      
      protected var FRemainFreeFire:int;
      
      protected var FOneFireCost:int;
      
      protected var FRemainFreeReset:int;
      
      protected var FResetCost:int;
      
      protected var FAwardType:int;
      
      protected var FAwardID:int;
      
      protected var FShowAwardID:int;
      
      protected var FGiftType:int;
      
      protected var FFightReportAddr:String;
      
      protected var FAwardState:int;
      
      protected var FConfig:TFirecrackersConfig;
      
      protected var FDay:int;
      
      protected var FInit:Boolean;
      
      public function TFirecrackersData()
      {
         var _loc1_:int = 0;
         var _loc2_:TFireGiftBoxVO = null;
         super();
         this.FGiftType = TOverlayerGiftBox.TYPE_ALL;
         this.FBoxList = new Vector.<TFireGiftBoxVO>(BoxCount);
         this.FFireState = new Vector.<int>(FireCount);
         _loc1_ = 0;
         while(_loc1_ < BoxCount)
         {
            _loc2_ = new TFireGiftBoxVO();
            this.FBoxList[_loc1_] = _loc2_;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < FireCount)
         {
            this.FFireState[_loc1_] = FireState_OFF;
            _loc1_++;
         }
      }
      
      public function get BoxList() : Vector.<TFireGiftBoxVO>
      {
         return this.FBoxList;
      }
      
      public function set BoxList(param1:Vector.<TFireGiftBoxVO>) : void
      {
         this.FBoxList = param1;
      }
      
      public function get FireState() : Vector.<int>
      {
         return this.FFireState;
      }
      
      public function set FireState(param1:Vector.<int>) : void
      {
         this.FFireState = param1;
      }
      
      public function get FireTotal() : int
      {
         return this.FFireTotal;
      }
      
      public function set FireTotal(param1:int) : void
      {
         this.FFireTotal = param1;
      }
      
      public function get NeedFire() : int
      {
         return this.FNeedFire;
      }
      
      public function set NeedFire(param1:int) : void
      {
         this.FNeedFire = param1;
      }
      
      public function get RemainFreeFire() : int
      {
         return this.FRemainFreeFire;
      }
      
      public function set RemainFreeFire(param1:int) : void
      {
         this.FRemainFreeFire = param1;
      }
      
      public function get OneFireCost() : int
      {
         return this.FOneFireCost;
      }
      
      public function set OneFireCost(param1:int) : void
      {
         this.FOneFireCost = param1;
      }
      
      public function get AllFireCost() : int
      {
         var _loc1_:Object = null;
         _loc1_ = this.FConfig.LightingAndReset[0];
         return _loc1_.costGold * this.GetRemainFireCount() * this.FConfig.Discount / 100;
      }
      
      public function get RemainFreeReset() : int
      {
         return this.FRemainFreeReset;
      }
      
      public function set RemainFreeReset(param1:int) : void
      {
         this.FRemainFreeReset = param1;
      }
      
      public function get ResetCost() : int
      {
         return this.FResetCost;
      }
      
      public function set ResetCost(param1:int) : void
      {
         this.FResetCost = param1;
      }
      
      public function get AwardType() : int
      {
         return this.FAwardType;
      }
      
      public function set AwardType(param1:int) : void
      {
         this.FAwardType = param1;
      }
      
      public function get AwardID() : int
      {
         return this.FAwardID;
      }
      
      public function set AwardID(param1:int) : void
      {
         this.FAwardID = param1;
      }
      
      public function get GiftType() : int
      {
         return this.FGiftType;
      }
      
      public function set GiftType(param1:int) : void
      {
         this.FGiftType = param1;
      }
      
      public function get AwardState() : int
      {
         return this.FAwardState;
      }
      
      public function set AwardState(param1:int) : void
      {
         this.FAwardState = param1;
      }
      
      public function get ShowAwardID() : int
      {
         return this.FShowAwardID;
      }
      
      public function set ShowAwardID(param1:int) : void
      {
         this.FShowAwardID = param1;
      }
      
      public function get Day() : int
      {
         return this.FDay;
      }
      
      public function set Day(param1:int) : void
      {
         this.FDay = param1;
      }
      
      public function get Config() : TFirecrackersConfig
      {
         return this.FConfig;
      }
      
      public function set Config(param1:TFirecrackersConfig) : void
      {
         this.FConfig = param1;
      }
      
      public function get Init() : Boolean
      {
         return this.FInit;
      }
      
      public function set Init(param1:Boolean) : void
      {
         this.FInit = param1;
      }
      
      public function get FightReportAddr() : String
      {
         return this.FFightReportAddr;
      }
      
      public function set FightReportAddr(param1:String) : void
      {
         this.FFightReportAddr = param1;
      }
      
      public function IsAllFire() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FFireState.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FFireState[_loc1_] == FireState_OFF)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function HasCanReceive() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TFireGiftBoxVO = null;
         _loc2_ = int(this.FBoxList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            _loc3_ = this.FBoxList[_loc1_];
            if(_loc3_.State == CONST_ACTIVITY_MODE.Activity_CanReceive)
            {
               return true;
            }
            _loc1_++;
         }
         return false;
      }
      
      public function GetRemainFireCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = 0;
         _loc2_ = int(this.FFireState.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FFireState[_loc1_] == FireState_OFF)
            {
               _loc3_++;
            }
            _loc1_++;
         }
         return _loc3_;
      }
      
      public function AllReceive() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc2_ = int(this.FBoxList.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FBoxList[_loc1_].State == CONST_ACTIVITY_MODE.Activity_CanReceive)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
   }
}

