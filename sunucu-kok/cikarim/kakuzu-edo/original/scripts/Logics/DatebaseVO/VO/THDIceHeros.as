package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.DatebaseVO.VO.Json.TDoubleFishRank;
   import Logics.HDIceHeros.TActivityIHAward;
   import Logics.HDIceHeros.TActivityIHChipBox;
   import Logics.HDIceHeros.TActivityLoot;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDIceHeros extends THDActivityBase
   {
      
      protected var FTotalPlayer:uint;
      
      protected var FRankList:Vector.<TDoubleFishRank>;
      
      protected var FAwards:Vector.<TActivityIHAward>;
      
      protected var FChipBoxes:Vector.<TActivityIHChipBox>;
      
      protected var FHeroIDs:Vector.<uint>;
      
      protected var FHeroTypes:Vector.<uint>;
      
      protected var FRankDesc:String;
      
      protected var FAddValue:uint;
      
      protected var FLoot:TActivityLoot;
      
      protected var FIsRankShow:uint;
      
      protected var FReports:Vector.<String>;
      
      public function THDIceHeros()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:Object = null;
         var _loc7_:TDoubleFishRank = null;
         var _loc8_:TActivityIHAward = null;
         var _loc9_:TActivityIHChipBox = null;
         var _loc10_:Vector.<String> = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         this.FRankList = new Vector.<TDoubleFishRank>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc7_ = new TDoubleFishRank(_loc5_[_loc2_]);
            this.FRankList[_loc2_] = _loc7_;
            _loc2_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         this.FAwards = new Vector.<TActivityIHAward>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc8_ = new TActivityIHAward(_loc5_[_loc2_].index);
            _loc8_.GetType = _loc5_[_loc2_].getType;
            _loc8_.Limit = _loc5_[_loc2_].limit;
            _loc8_.Condition = _loc5_[_loc2_].condition;
            _loc8_.Awards = _loc5_[_loc2_].award[0];
            this.FAwards[_loc2_] = _loc8_;
            _loc2_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         this.FChipBoxes = new Vector.<TActivityIHChipBox>(_loc3_);
         _loc10_ = new Vector.<String>(1);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc9_ = new TActivityIHChipBox(_loc5_[_loc2_].index);
            _loc9_.Cost = _loc5_[_loc2_].cost;
            _loc9_.Awards = _loc5_[_loc2_].award[0];
            _loc9_.Name = _loc5_[_loc2_].name;
            this.FChipBoxes[_loc2_] = _loc9_;
            this.FChipBoxes[_loc2_].Prompts.push(_loc5_[_loc2_].prompt);
            _loc2_++;
         }
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc4_);
         _loc3_ = int(_loc5_.length);
         this.FHeroIDs = new Vector.<uint>(_loc3_);
         this.FHeroTypes = new Vector.<uint>(_loc3_);
         this.FReports = new Vector.<String>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FHeroIDs[_loc2_] = _loc5_[_loc2_].awardID;
            this.FHeroTypes[_loc2_] = _loc5_[_loc2_].awardType;
            this.FAwards[_loc2_].HeroID = this.FHeroIDs[_loc2_];
            this.FAwards[_loc2_].HeroType = this.FHeroTypes[_loc2_];
            _loc2_++;
         }
         this.FTotalPlayer = param1.readUnsignedInt();
         this.FRankDesc = TUtilityString.FetchUTF(param1);
         _loc4_ = TUtilityString.FetchUTF(param1);
         _loc6_ = Json.decode(_loc4_);
         this.FLoot = new TActivityLoot(_loc6_.index);
         this.FLoot.ChipFrame = _loc6_.chipFrame;
         this.FAddValue = param1.readUnsignedInt();
         this.FIsRankShow = param1.readUnsignedInt();
      }
      
      public function get TotalPlayer() : uint
      {
         return this.FTotalPlayer;
      }
      
      public function get RankList() : Vector.<TDoubleFishRank>
      {
         return this.FRankList;
      }
      
      public function get Awards() : Vector.<TActivityIHAward>
      {
         return this.FAwards;
      }
      
      public function get ChipBoxes() : Vector.<TActivityIHChipBox>
      {
         return this.FChipBoxes;
      }
      
      public function get RankDesc() : String
      {
         return this.FRankDesc;
      }
      
      public function get AddValue() : uint
      {
         return this.FAddValue;
      }
      
      public function get HeroIDs() : Vector.<uint>
      {
         return this.FHeroIDs;
      }
      
      public function get IsRankShow() : uint
      {
         return this.FIsRankShow;
      }
      
      public function get HeroTypes() : Vector.<uint>
      {
         return this.FHeroTypes;
      }
      
      public function get Reports() : Vector.<String>
      {
         return this.FReports;
      }
   }
}

