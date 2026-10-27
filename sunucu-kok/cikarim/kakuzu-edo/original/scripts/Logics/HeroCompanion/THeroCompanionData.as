package Logics.HeroCompanion
{
   import Foundation.Resources.SResourcesCore;
   import Logics.DatebaseVO.VO.TCompanionCard;
   import Logics.DatebaseVO.VO.TCompanionChip;
   import Logics.DatebaseVO.VO.TCompanionEncounter;
   import Resources.Constants.*;
   
   public class THeroCompanionData
   {
      
      public var EncounterStatus:Boolean;
      
      public var ServerState:int;
      
      public var SilverOneCount:int;
      
      public var SilverTenCount:int;
      
      public var GoldOneCount:int;
      
      public var GoldTenCount:int;
      
      public var EncounterOneCount:int;
      
      public var EncounterTenCount:int;
      
      public var SilverOneCosts:Vector.<int>;
      
      public var SilverTenCosts:Vector.<int>;
      
      public var GoldOneCosts:Vector.<int>;
      
      public var GoldTenCosts:Vector.<int>;
      
      public var EncounterOneCosts:Vector.<int>;
      
      public var EncounterTenCosts:Vector.<int>;
      
      protected var FEncounterVipLevel:int;
      
      protected var FTotalFever:int;
      
      protected var FEncounterTime:int;
      
      protected var FSilverEmployTime:int;
      
      protected var FGoldEmployTime:int;
      
      protected var FSeatCount:int;
      
      protected var FFever:int;
      
      protected var FEncounterId:int;
      
      protected var FEncounterIds:Vector.<int>;
      
      protected var FCardDatas:THeroCompanionCardDatas;
      
      protected var FSeatDatas:Vector.<THeroCompanionSeatData>;
      
      protected var FSeatVips:Vector.<THeroCompanionSeatData>;
      
      protected var FSeatFevers:Vector.<THeroCompanionSeatData>;
      
      protected var FChipDatas:Vector.<THeroCompanionChipData>;
      
      protected var FCardResults:Vector.<TCompanionCard>;
      
      protected var FChipResults:Vector.<THeroCompanionChipData>;
      
      public function THeroCompanionData()
      {
         super();
         this.FCardDatas = new THeroCompanionCardDatas();
         this.FSeatDatas = new Vector.<THeroCompanionSeatData>();
         this.FSeatVips = new Vector.<THeroCompanionSeatData>();
         this.FSeatFevers = new Vector.<THeroCompanionSeatData>();
         this.FChipDatas = new Vector.<THeroCompanionChipData>();
         this.FEncounterIds = new Vector.<int>();
         this.FCardResults = new Vector.<TCompanionCard>();
         this.FChipResults = new Vector.<THeroCompanionChipData>();
      }
      
      public function get ChipCount() : int
      {
         return this.FChipDatas.length;
      }
      
      public function get EncounterId() : int
      {
         return this.FEncounterId;
      }
      
      public function set EncounterId(param1:int) : void
      {
         var _loc2_:TCompanionEncounter = null;
         var _loc3_:Date = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this.FEncounterId = param1;
         this.FEncounterIds.length = 0;
         _loc2_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CompanionEncounter,this.FEncounterId) as TCompanionEncounter;
         _loc5_ = int(_loc2_.EncounterCards.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FEncounterIds.push(_loc2_.EncounterCards[_loc4_]);
            _loc4_++;
         }
         _loc3_ = new Date(_loc2_.EndTime[0],_loc2_.EndTime[1] - 1,_loc2_.EndTime[2]);
         this.EncounterTime = _loc3_.getTime() / 1000;
      }
      
      public function get EncounterCardIds() : Vector.<int>
      {
         return this.FEncounterIds;
      }
      
      public function get CardDatas() : THeroCompanionCardDatas
      {
         return this.FCardDatas;
      }
      
      public function get SeatDatas() : Vector.<THeroCompanionSeatData>
      {
         return this.FSeatDatas;
      }
      
      public function get SeatVips() : Vector.<THeroCompanionSeatData>
      {
         return this.FSeatVips;
      }
      
      public function get SeatFever() : Vector.<THeroCompanionSeatData>
      {
         return this.FSeatFevers;
      }
      
      public function get SeatCount() : int
      {
         return this.FSeatCount;
      }
      
      public function set SeatCount(param1:int) : void
      {
         var _loc2_:int = 0;
         var _loc3_:THeroCompanionSeatData = null;
         this.FSeatCount = param1;
         _loc2_ = int(this.FSeatDatas.length);
         while(_loc2_ < this.FSeatCount)
         {
            _loc3_ = new THeroCompanionSeatData();
            _loc3_.NeedFever = 0;
            _loc3_.NeedVip = 0;
            _loc3_.SeatCardId = 0;
            this.FSeatDatas.push(_loc3_);
            _loc2_++;
         }
      }
      
      public function get Fever() : int
      {
         return this.FFever;
      }
      
      public function set Fever(param1:int) : void
      {
         var _loc2_:int = 0;
         this.FFever = param1;
         _loc2_ = 0;
         while(_loc2_ < this.FSeatFevers.length)
         {
            if(this.FSeatFevers[_loc2_].NeedFever > this.FFever)
            {
               return;
            }
            this.FSeatFevers.splice(_loc2_,1);
            _loc2_++;
         }
      }
      
      public function get SilverEmployTime() : int
      {
         return this.FSilverEmployTime;
      }
      
      public function set SilverEmployTime(param1:int) : void
      {
         this.FSilverEmployTime = param1;
      }
      
      public function get GoldEmployTime() : int
      {
         return this.FGoldEmployTime;
      }
      
      public function set GoldEmployTime(param1:int) : void
      {
         this.FGoldEmployTime = param1;
      }
      
      public function get EncounterTime() : int
      {
         return this.FEncounterTime;
      }
      
      public function set EncounterTime(param1:int) : void
      {
         this.FEncounterTime = param1;
      }
      
      public function get CardResults() : Vector.<TCompanionCard>
      {
         return this.FCardResults;
      }
      
      public function get ChipResults() : Vector.<THeroCompanionChipData>
      {
         return this.FChipResults;
      }
      
      public function get TotalFever() : int
      {
         return this.FTotalFever;
      }
      
      public function set TotalFever(param1:int) : void
      {
         this.FTotalFever = param1;
      }
      
      public function get EncounterVipLevel() : int
      {
         return this.FEncounterVipLevel;
      }
      
      public function set EncounterVipLevel(param1:int) : void
      {
         this.FEncounterVipLevel = param1;
      }
      
      public function AddSeatData(param1:int, param2:int) : void
      {
         if(param2 > 0)
         {
            this.FSeatDatas[param2 - 1].SeatCardId = param1;
         }
      }
      
      public function GetChipByIndex(param1:int) : THeroCompanionChipData
      {
         return this.FChipDatas[param1];
      }
      
      public function GetChipByChipId(param1:int) : THeroCompanionChipData
      {
         var _loc2_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.FChipDatas.length)
         {
            if(this.FChipDatas[_loc2_].ChipId == param1)
            {
               return this.FChipDatas[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
      
      public function AddChipData(param1:int, param2:int, param3:int = 0, param4:Boolean = false) : THeroCompanionChipData
      {
         var _loc5_:THeroCompanionChipData = null;
         var _loc6_:int = 0;
         var _loc7_:TCompanionChip = null;
         _loc5_ = this.GetChipByChipId(param1);
         if(_loc5_ == null)
         {
            _loc7_ = SResourcesCore.ResourceBin.GetDatebase(CONST_DATEBASEVO.RESOURCEID_CompanionChip,param1) as TCompanionChip;
            _loc5_ = new THeroCompanionChipData();
            _loc5_.ChipId = param1;
            _loc5_.ChipData = _loc7_;
            this.FChipDatas.push(_loc5_);
         }
         if(param3 != 0)
         {
            _loc5_.LastId = param3;
         }
         if(param4)
         {
            _loc5_.Amount += param2;
         }
         else
         {
            _loc5_.Amount = param2;
         }
         return _loc5_;
      }
   }
}

