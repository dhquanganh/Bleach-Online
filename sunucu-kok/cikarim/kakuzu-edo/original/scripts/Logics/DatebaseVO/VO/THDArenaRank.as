package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.*;
   import Foundation.Utilities.*;
   import Logics.DatebaseVO.*;
   import Logics.DatebaseVO.VO.Json.TFixedAward;
   import flash.utils.*;
   import ghostcat.util.data.*;
   
   use namespace ResourcesSpace;
   
   public class THDArenaRank extends THDActivityBase
   {
      
      protected var FActAward:String;
      
      protected var FRankDay:String;
      
      protected var FLucky:String;
      
      protected var FLuckItem:String;
      
      protected var FActAwardVect:Vector.<Object>;
      
      protected var FRankDayVect:Vector.<uint>;
      
      protected var FLuckyVect:Vector.<Vector.<String>>;
      
      protected var FLuckyItemVect:Vector.<TFixedAward>;
      
      protected var FAwardValueVect:Vector.<uint>;
      
      protected var FAwardPromptVect:Vector.<String>;
      
      public function THDArenaRank()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:TFixedAward = null;
         var _loc7_:Vector.<Array> = null;
         var _loc8_:Vector.<String> = null;
         var _loc9_:Vector.<uint> = null;
         var _loc10_:Vector.<Object> = null;
         var _loc11_:String = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FActAward = TUtilityString.FetchUTF(param1);
         this.FActAwardVect = Vector.<Object>(Json.decode(this.FActAward));
         _loc3_ = int(this.FActAwardVect.length);
         this.FAwardValueVect = new Vector.<uint>(_loc3_);
         this.FAwardPromptVect = new Vector.<String>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAwardValueVect[_loc2_] = this.FActAwardVect[_loc2_].value[0];
            this.FAwardPromptVect[_loc2_] = this.FActAwardVect[_loc2_].prompt;
            _loc2_++;
         }
         this.FRankDay = TUtilityString.FetchUTF(param1);
         this.FRankDayVect = Vector.<uint>(Json.decode(this.FRankDay));
         this.FLucky = TUtilityString.FetchUTF(param1);
         _loc7_ = Vector.<Array>(Json.decode(this.FLucky));
         _loc3_ = int(_loc7_.length);
         this.FLuckyVect = new Vector.<Vector.<String>>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc8_ = new Vector.<String>(1);
            _loc5_ = int(_loc7_[_loc2_].length);
            _loc11_ = "";
            _loc4_ = 0;
            while(_loc4_ < _loc5_)
            {
               _loc11_ += String(_loc7_[_loc2_][_loc4_]);
               if(_loc4_ < _loc5_ - 1)
               {
                  _loc11_ += ",";
               }
               _loc4_++;
            }
            _loc8_[0] = _loc11_;
            this.FLuckyVect[_loc2_] = _loc8_;
            _loc2_++;
         }
         this.FLuckItem = TUtilityString.FetchUTF(param1);
         _loc10_ = Vector.<Object>(Json.decode(this.FLuckItem));
         _loc3_ = int(_loc10_.length);
         this.FLuckyItemVect = new Vector.<TFixedAward>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc6_ = new TFixedAward(_loc10_[_loc2_]);
            this.FLuckyItemVect[_loc2_] = _loc6_;
            _loc2_++;
         }
      }
      
      public function get ActAwardVect() : Vector.<Object>
      {
         return this.FActAwardVect;
      }
      
      public function get RankDayVect() : Vector.<uint>
      {
         return this.FRankDayVect;
      }
      
      public function get LuckyItemVect() : Vector.<TFixedAward>
      {
         return this.FLuckyItemVect;
      }
      
      public function get LuckyVect() : Vector.<Vector.<String>>
      {
         return this.FLuckyVect;
      }
      
      public function get AwardValueVect() : Vector.<uint>
      {
         return this.FAwardValueVect;
      }
      
      public function get AwardPromptVect() : Vector.<String>
      {
         return this.FAwardPromptVect;
      }
   }
}

