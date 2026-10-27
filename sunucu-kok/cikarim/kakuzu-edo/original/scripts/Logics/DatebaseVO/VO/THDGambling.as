package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDActivityGambling.TActivityDataAward;
   import Logics.HDActivityGambling.TActivityDataButton;
   import Logics.HDActivityGambling.TActivityDataCount;
   import Logics.HDActivityGambling.TActivityDataWins;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDGambling extends THDActivityBase
   {
      
      public static const BUTTONTYPE_Gambling_Start:uint = CONST_ACTIVITY_MODE.BUTTONTYPE_Gambling_Start;
      
      public static const BUTTONTYPE_Gambling_Small:uint = CONST_ACTIVITY_MODE.BUTTONTYPE_Gambling_Small;
      
      public static const BUTTONTYPE_Gambling_Big:uint = CONST_ACTIVITY_MODE.BUTTONTYPE_Gambling_Big;
      
      protected var FDataAwards:Vector.<TActivityDataAward>;
      
      protected var FDataFailOverCount:TActivityDataCount;
      
      protected var FDataStartCount:TActivityDataCount;
      
      protected var FDataButtons:Vector.<TActivityDataButton>;
      
      protected var FDataWins:TActivityDataWins;
      
      protected var FAutoBuyPrompt:Vector.<String>;
      
      public function THDGambling()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TActivityDataAward = null;
         var _loc5_:TActivityDataCount = null;
         var _loc6_:TActivityDataButton = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:Object = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc7_ = TUtilityString.FetchUTF(param1);
         _loc8_ = Json.decode(_loc7_) as Array;
         _loc3_ = int(_loc8_.length);
         this.FDataAwards = new Vector.<TActivityDataAward>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc4_ = new TActivityDataAward(_loc8_[_loc2_].index);
            _loc4_.Condition = _loc8_[_loc2_].condition;
            _loc4_.Prompt = _loc8_[_loc2_].prompt;
            _loc4_.Awards[0] = _loc8_[_loc2_].award;
            this.FDataAwards[_loc2_] = _loc4_;
            _loc2_++;
         }
         _loc7_ = TUtilityString.FetchUTF(param1);
         _loc9_ = Json.decode(_loc7_) as Object;
         this.FDataFailOverCount = new TActivityDataCount(_loc9_.index);
         this.FDataFailOverCount.GetType = _loc9_.getType;
         this.FDataFailOverCount.Limit = _loc9_.limit;
         this.FDataFailOverCount.Cost = _loc9_.cost;
         _loc7_ = TUtilityString.FetchUTF(param1);
         _loc9_ = Json.decode(_loc7_) as Object;
         this.FDataStartCount = new TActivityDataCount(_loc9_.index);
         this.FDataStartCount.GetType = _loc9_.getType;
         this.FDataStartCount.Limit = _loc9_.limit;
         this.FDataStartCount.Cost = _loc9_.cost;
         _loc7_ = TUtilityString.FetchUTF(param1);
         _loc9_ = Json.decode(_loc7_) as Object;
         this.FDataWins = new TActivityDataWins(_loc9_.index);
         _loc7_ = TUtilityString.FetchUTF(param1);
         _loc8_ = Json.decode(_loc7_) as Array;
         _loc3_ = int(_loc8_.length);
         this.FAutoBuyPrompt = new Vector.<String>(_loc3_);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.FAutoBuyPrompt[_loc2_] = _loc8_[_loc2_];
            _loc2_++;
         }
         this.FDataButtons = new Vector.<TActivityDataButton>();
         _loc6_ = new TActivityDataButton(param1.readUnsignedInt());
         _loc6_.ButtonType = BUTTONTYPE_Gambling_Start;
         this.FDataButtons.push(_loc6_);
         _loc6_ = new TActivityDataButton(param1.readUnsignedInt());
         _loc6_.ButtonType = BUTTONTYPE_Gambling_Small;
         this.FDataButtons.push(_loc6_);
         _loc6_ = new TActivityDataButton(param1.readUnsignedInt());
         _loc6_.ButtonType = BUTTONTYPE_Gambling_Big;
         this.FDataButtons.push(_loc6_);
      }
      
      public function get DataAwards() : Vector.<TActivityDataAward>
      {
         return this.FDataAwards;
      }
      
      public function get DataButtons() : Vector.<TActivityDataButton>
      {
         return this.FDataButtons;
      }
      
      public function get DataFailOverCount() : TActivityDataCount
      {
         return this.FDataFailOverCount;
      }
      
      public function get DataStartCount() : TActivityDataCount
      {
         return this.FDataStartCount;
      }
      
      public function get AutoBuyPrompt() : Vector.<String>
      {
         return this.FAutoBuyPrompt;
      }
      
      public function get DataWins() : TActivityDataWins
      {
         return this.FDataWins;
      }
   }
}

