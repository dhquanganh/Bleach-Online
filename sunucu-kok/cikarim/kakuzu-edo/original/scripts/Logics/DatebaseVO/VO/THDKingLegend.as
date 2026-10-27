package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDKingLegend extends THDActivityBase
   {
      
      private var FRechargeGold:int;
      
      private var FRechargeAwardIndex:int;
      
      private var FGetGold:int;
      
      private var FRechargeAwardArr:Vector.<int>;
      
      private var FExchargeIndexArr:Vector.<int>;
      
      private var FOrderArr:Vector.<int>;
      
      private var FTicketArr:Vector.<int>;
      
      private var FCostGoldAwardIndex:int;
      
      private var FCostGoldValue:int;
      
      private var FCostGoldAwardArr:Vector.<int>;
      
      private var FTurntableIndex:int;
      
      private var FTurnTableGold:int;
      
      private var FTurnAwardArr:Vector.<int>;
      
      private var FCurDayIndex:int;
      
      private var FCurCostIndex:int;
      
      private var FBagIndex:int;
      
      private var FBagArr:Vector.<int>;
      
      public function THDKingLegend()
      {
         super();
         this.FExchargeIndexArr = new Vector.<int>();
         this.FOrderArr = new Vector.<int>();
         this.FTicketArr = new Vector.<int>();
         this.FTurnAwardArr = new Vector.<int>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FRechargeGold = _loc6_.gold;
         this.FRechargeAwardIndex = _loc6_.index;
         this.FGetGold = _loc6_.getGold;
         this.FRechargeAwardArr = Vector.<int>(_loc6_.award);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FExchargeIndexArr[_loc2_] = _loc4_[_loc2_].index;
            this.FOrderArr[_loc2_] = _loc4_[_loc2_].order;
            this.FTicketArr[_loc2_] = _loc4_[_loc2_].ticket;
            _loc2_++;
         }
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FCostGoldAwardIndex = _loc6_.index;
         this.FCostGoldValue = _loc6_.cost;
         this.FCostGoldAwardArr = Vector.<int>(_loc6_.award);
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FTurntableIndex = _loc6_.index;
         this.FTurnTableGold = _loc6_.gold;
         _loc4_ = _loc6_.award as Array;
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FTurnAwardArr[_loc2_] = _loc4_[_loc2_].awardId;
            _loc2_++;
         }
         this.FCurDayIndex = param1.readUnsignedInt();
         this.FCurCostIndex = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FBagIndex = _loc6_.index;
         this.FBagArr = Vector.<int>(_loc6_.award);
      }
      
      public function get RechargeGold() : int
      {
         return this.FRechargeGold;
      }
      
      public function get RechargeAwardIndex() : int
      {
         return this.FRechargeAwardIndex;
      }
      
      public function get GetGold() : int
      {
         return this.FGetGold;
      }
      
      public function get RechargeAwardArr() : Vector.<int>
      {
         return this.FRechargeAwardArr;
      }
      
      public function get ExchargeIndexArr() : Vector.<int>
      {
         return this.FExchargeIndexArr;
      }
      
      public function get OrderArr() : Vector.<int>
      {
         return this.FOrderArr;
      }
      
      public function get TicketArr() : Vector.<int>
      {
         return this.FTicketArr;
      }
      
      public function get CostGoldAwardIndex() : int
      {
         return this.FCostGoldAwardIndex;
      }
      
      public function get CostGoldValue() : int
      {
         return this.FCostGoldValue;
      }
      
      public function get CostGoldAwardArr() : Vector.<int>
      {
         return this.FCostGoldAwardArr;
      }
      
      public function get TurntableIndex() : int
      {
         return this.FTurntableIndex;
      }
      
      public function get TurnTableGold() : int
      {
         return this.FTurnTableGold;
      }
      
      public function get TurnAwardArr() : Vector.<int>
      {
         return this.FTurnAwardArr;
      }
      
      public function get CurDayIndex() : int
      {
         return this.FCurDayIndex;
      }
      
      public function get CurCostIndex() : int
      {
         return this.FCurCostIndex;
      }
      
      public function get BagIndex() : int
      {
         return this.FBagIndex;
      }
      
      public function get BagArr() : Vector.<int>
      {
         return this.FBagArr;
      }
   }
}

