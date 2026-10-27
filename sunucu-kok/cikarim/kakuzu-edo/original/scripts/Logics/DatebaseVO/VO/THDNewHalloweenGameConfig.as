package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDNewHalloweenGameConfig extends THDActivityBase
   {
      
      private var FCandyIndex:int;
      
      private var FBuyIndex:int;
      
      private var FNotifyIndex:int;
      
      private var FTitleObj:Object;
      
      private var FGiftIndexVec:Vector.<int>;
      
      private var FGiftCandyVec:Vector.<int>;
      
      private var FGiftAwardVec:Vector.<int>;
      
      private var FTurnIndex:int;
      
      private var FBuyGameGold:int;
      
      private var FCountdown:int;
      
      private var FVicePet:Object;
      
      public function THDNewHalloweenGameConfig()
      {
         super();
         this.FGiftIndexVec = new Vector.<int>();
         this.FGiftCandyVec = new Vector.<int>();
         this.FGiftAwardVec = new Vector.<int>();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FCandyIndex = param1.readUnsignedInt();
         this.FBuyIndex = param1.readUnsignedInt();
         this.FNotifyIndex = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FTitleObj = _loc6_;
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc5_);
         _loc3_ = int(_loc4_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FGiftIndexVec[_loc2_] = _loc4_[_loc2_].index;
            this.FGiftCandyVec[_loc2_] = _loc4_[_loc2_].candy;
            this.FGiftAwardVec[_loc2_] = _loc4_[_loc2_].award;
            _loc2_++;
         }
         this.FTurnIndex = param1.readUnsignedInt();
         this.FBuyGameGold = param1.readUnsignedInt();
         this.FCountdown = param1.readUnsignedInt();
         _loc5_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc5_);
         this.FVicePet = _loc6_;
      }
      
      public function get CandyIndex() : int
      {
         return this.FCandyIndex;
      }
      
      public function get BuyIndex() : int
      {
         return this.FBuyIndex;
      }
      
      public function get NotifyIndex() : int
      {
         return this.FNotifyIndex;
      }
      
      public function get TitleObj() : Object
      {
         return this.FTitleObj;
      }
      
      public function get GiftIndexVec() : Vector.<int>
      {
         return this.FGiftIndexVec;
      }
      
      public function get GiftCandyVec() : Vector.<int>
      {
         return this.FGiftCandyVec;
      }
      
      public function get GiftAwardVec() : Vector.<int>
      {
         return this.FGiftAwardVec;
      }
      
      public function get TurnIndex() : int
      {
         return this.FTurnIndex;
      }
      
      public function get BuyGameGold() : int
      {
         return this.FBuyGameGold;
      }
      
      public function get Countdown() : int
      {
         return this.FCountdown;
      }
      
      public function get VicePet() : Object
      {
         return this.FVicePet;
      }
   }
}

