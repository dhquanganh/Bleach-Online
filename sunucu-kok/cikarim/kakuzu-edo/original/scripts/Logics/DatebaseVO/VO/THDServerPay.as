package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDIceHeros.TActivityIHAward;
   import Logics.HDServerPay.TActivitySPAwards;
   import Logics.HDServerPay.TActivitySPExchangeShop;
   import Logics.HDServerPay.TActivitySPHero;
   import Logics.HDServerPay.TActivitySPPrompts;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDServerPay extends THDActivityBase
   {
      
      protected var FRankAwards:Vector.<TActivitySPAwards>;
      
      protected var FExchangeShops:Vector.<TActivitySPExchangeShop>;
      
      protected var FHeros:Vector.<TActivitySPHero>;
      
      protected var FHerosData:Vector.<TActivityIHAward>;
      
      protected var FRankNum:uint;
      
      protected var FRankDesc:String;
      
      protected var FExchangeDesc:String;
      
      protected var FPrompts:TActivitySPPrompts;
      
      protected var FIsOpenRank:Boolean;
      
      public function THDServerPay()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:TActivitySPAwards = null;
         var _loc8_:TActivitySPExchangeShop = null;
         var _loc9_:TActivitySPHero = null;
         var _loc10_:TActivityIHAward = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc6_) as Array;
         _loc3_ = int(_loc5_.length);
         this.FRankAwards = new Vector.<TActivitySPAwards>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc7_ = new TActivitySPAwards();
            _loc7_.Value = _loc5_[_loc2_].value[0];
            _loc7_.Prompt = _loc5_[_loc2_].prompt;
            this.FRankAwards[_loc2_] = _loc7_;
            _loc2_++;
         }
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc6_) as Array;
         _loc3_ = int(_loc5_.length);
         this.FExchangeShops = new Vector.<TActivitySPExchangeShop>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc8_ = new TActivitySPExchangeShop(_loc5_[_loc2_].index);
            _loc8_.GetType = _loc5_[_loc2_].getType;
            _loc8_.Limit = _loc5_[_loc2_].limit;
            _loc8_.Condition = _loc5_[_loc2_].condition;
            _loc8_.Awards.push(_loc5_[_loc2_].award[0]);
            _loc8_.Name = _loc5_[_loc2_].name;
            this.FExchangeShops[_loc2_] = _loc8_;
            _loc2_++;
         }
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc6_) as Array;
         _loc3_ = int(_loc5_.length);
         this.FHeros = new Vector.<TActivitySPHero>(_loc3_);
         this.FHerosData = new Vector.<TActivityIHAward>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc9_ = new TActivitySPHero(_loc5_[_loc2_].index);
            _loc9_.GetType = _loc5_[_loc2_].getType;
            _loc9_.Limit = _loc5_[_loc2_].limit;
            _loc9_.Condition = _loc5_[_loc2_].condition;
            _loc9_.AwardType = _loc5_[_loc2_].awardType;
            _loc9_.AwardID = _loc5_[_loc2_].awardID;
            _loc9_.ReportAddr = _loc5_[_loc2_].reportId;
            _loc10_ = new TActivityIHAward(_loc9_.Index);
            _loc10_.GetType = _loc9_.GetType;
            _loc10_.Limit = _loc9_.Limit;
            _loc10_.Condition = _loc9_.Condition;
            _loc10_.HeroType = _loc9_.AwardType;
            _loc10_.HeroID = _loc9_.AwardID;
            _loc10_.ReportID = _loc9_.ReportAddr;
            this.FHeros[_loc2_] = _loc9_;
            this.FHerosData[_loc2_] = _loc10_;
            _loc2_++;
         }
         this.FRankNum = param1.readUnsignedInt();
         this.FRankDesc = TUtilityString.FetchUTF(param1);
         this.FExchangeDesc = TUtilityString.FetchUTF(param1);
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc6_) as Array;
         _loc3_ = int(_loc5_.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FRankAwards[_loc2_].AwardDesc = _loc5_[_loc2_];
            _loc2_++;
         }
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc4_ = Json.decode(_loc6_) as Object;
         this.FPrompts = new TActivitySPPrompts(_loc4_);
         this.FIsOpenRank = Boolean(param1.readUnsignedInt());
      }
      
      public function get RankAwards() : Vector.<TActivitySPAwards>
      {
         return this.FRankAwards;
      }
      
      public function get ExchangeShops() : Vector.<TActivitySPExchangeShop>
      {
         return this.FExchangeShops;
      }
      
      public function get Heros() : Vector.<TActivitySPHero>
      {
         return this.FHeros;
      }
      
      public function get RankNum() : uint
      {
         return this.FRankNum;
      }
      
      public function get RankDesc() : String
      {
         return this.FRankDesc;
      }
      
      public function get ExchangeDesc() : String
      {
         return this.FExchangeDesc;
      }
      
      public function get Prompts() : TActivitySPPrompts
      {
         return this.FPrompts;
      }
      
      public function get IsOpenRank() : Boolean
      {
         return this.FIsOpenRank;
      }
      
      public function get HerosData() : Vector.<TActivityIHAward>
      {
         return this.FHerosData;
      }
   }
}

