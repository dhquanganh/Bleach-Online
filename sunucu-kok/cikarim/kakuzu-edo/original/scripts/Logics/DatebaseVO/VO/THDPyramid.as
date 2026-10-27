package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDPyramid extends THDActivityBase
   {
      
      protected var FAwards:Vector.<uint>;
      
      protected var FSmashOne:uint;
      
      protected var FSmashTen:uint;
      
      protected var FSmashFifty:uint;
      
      protected var FGiftIndex:Vector.<uint>;
      
      protected var FGiftId:Vector.<uint>;
      
      protected var FGiftLimit:Vector.<uint>;
      
      protected var FGiftCost:Vector.<uint>;
      
      protected var FGift:Vector.<Object>;
      
      protected var FRechargeIndex:uint;
      
      protected var FExtractIndex:uint;
      
      protected var FScoreIndex:uint;
      
      protected var FPositionIndex:uint;
      
      protected var FProportion:uint;
      
      protected var FAwardId:uint;
      
      protected var FShowID:uint;
      
      protected var FShowType:uint;
      
      protected var FFightReportAddr:String;
      
      public function THDPyramid()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc7_ = TUtilityString.FetchUTF(param1);
         _loc8_ = Json.decode(_loc7_);
         _loc6_ = _loc8_[0].awardRate;
         _loc4_ = int(_loc6_.length);
         this.FAwards = new Vector.<uint>();
         _loc2_ = 0;
         while(_loc2_ < _loc4_)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc6_[_loc2_].length)
            {
               this.FAwards.push(_loc6_[_loc2_][_loc3_].awardId);
               _loc3_++;
            }
            _loc2_++;
         }
         this.FSmashFifty = param1.readUnsignedInt();
         this.FSmashTen = param1.readUnsignedInt();
         this.FSmashOne = param1.readUnsignedInt();
         _loc7_ = TUtilityString.FetchUTF(param1);
         _loc8_ = Json.decode(_loc7_);
         this.FGift = new Vector.<Object>();
         _loc2_ = 0;
         while(_loc2_ < _loc8_.length)
         {
            this.FGift.push(_loc8_[_loc2_]);
            _loc2_++;
         }
         this.FRechargeIndex = param1.readUnsignedInt();
         this.FExtractIndex = param1.readUnsignedInt();
         this.FScoreIndex = param1.readUnsignedInt();
         this.FPositionIndex = param1.readUnsignedInt();
         this.FProportion = param1.readUnsignedInt();
         _loc7_ = TUtilityString.FetchUTF(param1);
         _loc8_ = Json.decode(_loc7_);
         this.FAwardId = _loc8_[0].awardId;
         this.FShowID = _loc8_[0].showID;
         this.FShowType = _loc8_[0].showType;
         this.FFightReportAddr = _loc8_[0].fightReportAddr;
      }
      
      public function get Awards() : Vector.<uint>
      {
         return this.FAwards;
      }
      
      public function get SmashOne() : uint
      {
         return this.FSmashOne;
      }
      
      public function get SmashTen() : uint
      {
         return this.FSmashTen;
      }
      
      public function get SmashFifty() : uint
      {
         return this.FSmashFifty;
      }
      
      public function get Gift() : Vector.<Object>
      {
         return this.FGift;
      }
      
      public function get RechargeIndex() : uint
      {
         return this.FRechargeIndex;
      }
      
      public function get ExtractIndex() : uint
      {
         return this.FExtractIndex;
      }
      
      public function get PositionIndex() : uint
      {
         return this.FPositionIndex;
      }
      
      public function get Proportion() : uint
      {
         return this.FProportion;
      }
      
      public function get ScoreIndex() : uint
      {
         return this.FScoreIndex;
      }
      
      public function get AwardId() : uint
      {
         return this.FAwardId;
      }
      
      public function get ShowID() : uint
      {
         return this.FShowID;
      }
      
      public function get ShowType() : uint
      {
         return this.FShowType;
      }
      
      public function get FightReportAddr() : String
      {
         return this.FFightReportAddr;
      }
   }
}

