package Logics.HDNationalDay2017
{
   import Logics.DatebaseVO.VO.THDNationalDayThree2017;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TNationalDay2017Three extends TActivityOSBase
   {
      
      protected var FScore:uint;
      
      protected var FItemsID:Vector.<int>;
      
      protected var FItems:TInventories;
      
      protected var FItemsStatus:Vector.<int>;
      
      protected var FLotteryCount:int;
      
      protected var FLotteryPos:int;
      
      protected var FLotteryStatus:Vector.<int>;
      
      protected var FMailStatus:Vector.<int>;
      
      protected var FMailInvs:TInventories;
      
      protected var FConfig:THDNationalDayThree2017;
      
      public function TNationalDay2017Three()
      {
         super();
         this.FItemsID = new Vector.<int>();
         this.FItems = new TInventories();
         this.FItemsStatus = new Vector.<int>();
         this.FLotteryStatus = new Vector.<int>();
         this.FMailStatus = new Vector.<int>();
         this.FMailInvs = new TInventories();
      }
      
      public function get Config() : THDNationalDayThree2017
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDNationalDayThree2017) : void
      {
         this.FConfig = param1;
      }
      
      public function get Score() : uint
      {
         return this.FScore;
      }
      
      public function set Score(param1:uint) : void
      {
         this.FScore = param1;
      }
      
      public function get ItemsID() : Vector.<int>
      {
         return this.FItemsID;
      }
      
      public function set ItemsID(param1:Vector.<int>) : void
      {
         this.FItemsID = param1;
      }
      
      public function get ItemsStatus() : Vector.<int>
      {
         return this.FItemsStatus;
      }
      
      public function set ItemsStatus(param1:Vector.<int>) : void
      {
         this.FItemsStatus = param1;
      }
      
      public function get LotteryCount() : int
      {
         return this.FLotteryCount;
      }
      
      public function set LotteryCount(param1:int) : void
      {
         this.FLotteryCount = param1;
      }
      
      public function get LotteryStatus() : Vector.<int>
      {
         return this.FLotteryStatus;
      }
      
      public function set LotteryStatus(param1:Vector.<int>) : void
      {
         this.FLotteryStatus = param1;
      }
      
      public function get MailStatus() : Vector.<int>
      {
         return this.FMailStatus;
      }
      
      public function set MailStatus(param1:Vector.<int>) : void
      {
         this.FMailStatus = param1;
      }
      
      public function get MailInvs() : TInventories
      {
         return this.FMailInvs;
      }
      
      public function set MailInvs(param1:TInventories) : void
      {
         this.FMailInvs = param1;
      }
      
      public function get LotteryPos() : int
      {
         return this.FLotteryPos;
      }
      
      public function set LotteryPos(param1:int) : void
      {
         this.FLotteryPos = param1;
      }
      
      public function GetItems() : Vector.<Object>
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:TInventories = null;
         var _loc8_:Vector.<Object> = null;
         _loc1_ = this.Config.ItemsIndex.length;
         _loc3_ = this.Config.Pool.length;
         _loc8_ = new Vector.<Object>(_loc1_);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc8_[_loc2_] = new Object();
            _loc7_ = new TInventories();
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               if(this.FItemsID[_loc2_] == this.Config.Pool[_loc4_].index)
               {
                  _loc6_ = uint(this.Config.Pool[_loc4_].awardid);
                  SToolReward.GetAwardsByAwardID(_loc6_,_loc7_);
                  _loc8_[_loc2_].inv = _loc7_.GetInventoryByIndex(0);
                  _loc8_[_loc2_].cost = this.Config.Pool[_loc4_].cost;
               }
               _loc4_++;
            }
            _loc2_++;
         }
         return _loc8_;
      }
      
      public function IsEmpty() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         _loc1_ = this.FLotteryStatus.length;
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            if(this.FLotteryStatus[_loc2_] != -1)
            {
               return false;
            }
            _loc2_++;
         }
         return true;
      }
   }
}

