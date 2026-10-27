package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.ActivityVO.THDShowAwardVO;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDDailyHero extends THDActivityBase
   {
      
      protected var FAwards:Vector.<THDShowAwardVO>;
      
      protected var FScoreIndex:uint;
      
      protected var FProportion:uint;
      
      public function THDDailyHero()
      {
         super();
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
         _loc3_ = int(_loc6_.length);
         this.FAwards = new Vector.<THDShowAwardVO>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAwards[_loc2_] = new THDShowAwardVO();
            this.FAwards[_loc2_].AwardID = _loc6_[_loc2_].awardId;
            this.FAwards[_loc2_].FightReportAddr = _loc6_[_loc2_].fightReportAddr;
            this.FAwards[_loc2_].ShowAwardID = _loc6_[_loc2_].showID;
            this.FAwards[_loc2_].AwardType = _loc6_[_loc2_].showType;
            this.FAwards[_loc2_].Condition[0] = _loc6_[_loc2_].costScore;
            this.FAwards[_loc2_].CS_Index = _loc6_[_loc2_].index;
            _loc2_++;
         }
         this.FScoreIndex = param1.readUnsignedInt();
         this.FProportion = param1.readUnsignedInt();
      }
      
      public function get Awards() : Vector.<THDShowAwardVO>
      {
         return this.FAwards;
      }
      
      public function get ScoreIndex() : uint
      {
         return this.FScoreIndex;
      }
      
      public function get Proportion() : uint
      {
         return this.FProportion;
      }
   }
}

