package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDTeamBuy.TActivityTBAward;
   import Logics.HDTeamBuy.TActivityTBOffRate;
   import Logics.HDTeamBuy.TActivityTBPrompt;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDTeamBuy extends THDActivityBase
   {
      
      protected static const COUNT_FORMATE_TIME:uint = 2;
      
      protected var FTBAwards:Vector.<TActivityTBAward>;
      
      protected var FTBOffRates:Vector.<TActivityTBOffRate>;
      
      protected var FTBSignStartTime:Vector.<uint>;
      
      protected var FTBSignEndTime:Vector.<uint>;
      
      protected var FTBBuyStartTime:Vector.<uint>;
      
      protected var FTBBuyEndTime:Vector.<uint>;
      
      protected var FTBPrompt:TActivityTBPrompt;
      
      public function THDTeamBuy()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Object = null;
         var _loc10_:TActivityTBAward = null;
         var _loc11_:TActivityTBOffRate = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc6_);
         _loc3_ = int(_loc7_.length);
         this.FTBAwards = new Vector.<TActivityTBAward>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc10_ = new TActivityTBAward(_loc7_[_loc2_]);
            this.FTBAwards[_loc2_] = _loc10_;
            _loc2_++;
         }
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc6_);
         _loc3_ = int(_loc7_.length);
         this.FTBOffRates = new Vector.<TActivityTBOffRate>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc11_ = new TActivityTBOffRate(_loc7_[_loc2_]);
            this.FTBOffRates[_loc2_] = _loc11_;
            _loc2_++;
         }
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc6_);
         this.FTBSignStartTime = new Vector.<uint>(COUNT_FORMATE_TIME);
         this.FTBSignEndTime = new Vector.<uint>(COUNT_FORMATE_TIME);
         _loc8_ = _loc7_[0] as Array;
         _loc5_ = int(_loc8_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FTBSignStartTime[_loc4_] = _loc8_[_loc4_];
            _loc4_++;
         }
         _loc8_ = _loc7_[1] as Array;
         _loc5_ = int(_loc8_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FTBSignEndTime[_loc4_] = _loc8_[_loc4_];
            _loc4_++;
         }
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc7_ = Json.decode(_loc6_);
         this.FTBBuyStartTime = new Vector.<uint>(COUNT_FORMATE_TIME);
         this.FTBBuyEndTime = new Vector.<uint>(COUNT_FORMATE_TIME);
         _loc8_ = _loc7_[0] as Array;
         _loc5_ = int(_loc8_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FTBBuyStartTime[_loc4_] = _loc8_[_loc4_];
            _loc4_++;
         }
         _loc8_ = _loc7_[1] as Array;
         _loc5_ = int(_loc8_.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            this.FTBBuyEndTime[_loc4_] = _loc8_[_loc4_];
            _loc4_++;
         }
         _loc6_ = TUtilityString.FetchUTF(param1);
         _loc9_ = Json.decode(_loc6_);
         this.FTBPrompt = new TActivityTBPrompt(_loc9_);
      }
      
      public function get TBAwards() : Vector.<TActivityTBAward>
      {
         return this.FTBAwards;
      }
      
      public function get TBOffRates() : Vector.<TActivityTBOffRate>
      {
         return this.FTBOffRates;
      }
      
      public function get TBSignStartTime() : Vector.<uint>
      {
         return this.FTBSignStartTime;
      }
      
      public function get TBSignEndTime() : Vector.<uint>
      {
         return this.FTBSignEndTime;
      }
      
      public function get TBBuyStartTime() : Vector.<uint>
      {
         return this.FTBBuyStartTime;
      }
      
      public function get TBBuyEndTime() : Vector.<uint>
      {
         return this.FTBBuyEndTime;
      }
      
      public function get TBPrompt() : TActivityTBPrompt
      {
         return this.FTBPrompt;
      }
   }
}

