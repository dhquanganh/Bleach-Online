package Logics.HDThanksGivingDay2016
{
   import Logics.DatebaseVO.VO.THDTGD_2;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Logics.Inventories.TInventory;
   import Processors.Game.Utilities.EffectTextReward.SToolReward;
   
   public class TTGD_2 extends TActivityOSBase
   {
      
      protected var FPerviewIns:Vector.<TInventories>;
      
      protected var FCurIns:Vector.<TInventory>;
      
      protected var FCurInsIndex:Vector.<int>;
      
      protected var FHaveCard_0:int;
      
      protected var FHaveCard_1:int;
      
      protected var FHaveCard_2:int;
      
      protected var FHaveCard_3:int;
      
      protected var FMailStatus:Vector.<int>;
      
      protected var FMailInvs:TInventories;
      
      protected var FCurCard:int;
      
      protected var FFreeCount:int;
      
      protected var FConfig:THDTGD_2;
      
      public function TTGD_2()
      {
         super();
         this.FPerviewIns = new Vector.<TInventories>();
         this.FCurIns = new Vector.<TInventory>(5);
         this.FCurInsIndex = new Vector.<int>();
         this.FMailInvs = new TInventories();
      }
      
      public function get PerviewIns() : Vector.<TInventories>
      {
         return this.FPerviewIns;
      }
      
      public function set PerviewIns(param1:Vector.<TInventories>) : void
      {
         this.FPerviewIns = param1;
      }
      
      public function get CurInsIndex() : Vector.<int>
      {
         return this.FCurInsIndex;
      }
      
      public function set CurInsIndex(param1:Vector.<int>) : void
      {
         this.FCurInsIndex = param1;
      }
      
      public function get HaveCard_0() : int
      {
         return this.FHaveCard_0;
      }
      
      public function set HaveCard_0(param1:int) : void
      {
         this.FHaveCard_0 = param1;
      }
      
      public function get HaveCard_1() : int
      {
         return this.FHaveCard_1;
      }
      
      public function set HaveCard_1(param1:int) : void
      {
         this.FHaveCard_1 = param1;
      }
      
      public function get HaveCard_2() : int
      {
         return this.FHaveCard_2;
      }
      
      public function set HaveCard_2(param1:int) : void
      {
         this.FHaveCard_2 = param1;
      }
      
      public function get HaveCard_3() : int
      {
         return this.FHaveCard_3;
      }
      
      public function set HaveCard_3(param1:int) : void
      {
         this.FHaveCard_3 = param1;
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
      
      public function get Config() : THDTGD_2
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDTGD_2) : void
      {
         this.FConfig = param1;
      }
      
      public function get CurCard() : int
      {
         return this.FCurCard;
      }
      
      public function set CurCard(param1:int) : void
      {
         this.FCurCard = param1;
      }
      
      public function get FreeCount() : int
      {
         return this.FFreeCount;
      }
      
      public function set FreeCount(param1:int) : void
      {
         this.FFreeCount = param1;
      }
      
      public function get CurIns() : Vector.<TInventory>
      {
         return this.FCurIns;
      }
      
      public function set CurIns(param1:Vector.<TInventory>) : void
      {
         this.FCurIns = param1;
      }
      
      public function GetCurItemsInfo() : Vector.<Object>
      {
         var _loc1_:Object = null;
         var _loc2_:Vector.<Object> = null;
         var _loc3_:TInventories = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = 5;
         _loc2_ = new Vector.<Object>(_loc4_);
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            _loc1_ = new Object();
            _loc3_ = new TInventories();
            if(this.CurInsIndex[_loc5_] != 0)
            {
               SToolReward.GetAwardsByAwardID(this.FConfig.Items[this.CurInsIndex[_loc5_] - 10].award,_loc3_);
               _loc1_ = _loc3_.GetInventoryByIndex(0);
            }
            else
            {
               _loc1_ = null;
            }
            _loc2_[_loc5_] = _loc1_;
            _loc5_++;
         }
         return _loc2_;
      }
   }
}

