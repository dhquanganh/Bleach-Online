package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import Logics.HDRandCard.TActivityRCAwardCard;
   import Logics.HDRandCard.TActivityRCButton;
   import Logics.HDRandCard.TActivityRCGoldAward;
   import Logics.HDRandCard.TActivityRCScore;
   import Logics.HDRandCard.TActivityRCSuperAward;
   import Logics.HDServerPay.TActivitySPPrompts;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDRandCard extends THDActivityBase
   {
      
      protected var FGoldAwards:Vector.<TActivityRCGoldAward>;
      
      protected var FSuperAwards:TActivityRCSuperAward;
      
      protected var FSelectCost:uint;
      
      protected var FDeleteCost:uint;
      
      protected var FRefreshCost:uint;
      
      protected var FCanDeleteCount:uint;
      
      protected var FScore:TActivityRCScore;
      
      protected var FFreeTime:TActivityRCButton;
      
      protected var FGoldStartBtn:TActivityRCButton;
      
      protected var FGoldRefreshbtn:TActivityRCButton;
      
      protected var FGoldSelectBtn:TActivityRCButton;
      
      protected var FGoldRestartBtn:TActivityRCButton;
      
      protected var FSuperStartBtn:TActivityRCButton;
      
      protected var FSuperSelectBtn:TActivityRCButton;
      
      protected var FSuperRestartBtn:TActivityRCButton;
      
      protected var FPrompts:TActivitySPPrompts;
      
      public function THDRandCard()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:String = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Object = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:TActivityRCAwardCard = null;
         var _loc11_:TActivityRCGoldAward = null;
         super.ResourcesSpace::ReadDataByStream(param1);
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc3_ = Json.decode(_loc2_) as Array;
         _loc7_ = int(_loc3_.length);
         this.FGoldAwards = new Vector.<TActivityRCGoldAward>(_loc7_);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc4_ = _loc3_[_loc6_] as Array;
            _loc11_ = new TActivityRCGoldAward(_loc6_);
            _loc9_ = int(_loc4_.length);
            _loc8_ = 0;
            while(_loc8_ < _loc9_)
            {
               _loc10_ = new TActivityRCAwardCard(_loc8_);
               _loc10_.Award = _loc4_[_loc8_].award;
               _loc11_.AwardCard.push(_loc10_);
               _loc8_++;
            }
            this.FGoldAwards[_loc6_] = _loc11_;
            _loc6_++;
         }
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc2_) as Object;
         this.FSuperAwards = new TActivityRCSuperAward();
         this.FSuperAwards.FixAward = _loc5_.fixAward;
         _loc3_ = _loc5_.randAward as Array;
         _loc7_ = int(_loc3_.length);
         _loc6_ = 0;
         while(_loc6_ < _loc7_)
         {
            _loc10_ = new TActivityRCAwardCard(_loc6_);
            _loc10_.Award = _loc3_[_loc6_].award;
            this.FSuperAwards.RandAwards.push(_loc10_);
            _loc6_++;
         }
         _loc10_ = new TActivityRCAwardCard(_loc7_ - 1);
         _loc10_.Award = this.FSuperAwards.FixAward;
         this.FSuperAwards.FixedAward = _loc10_;
         this.FSelectCost = param1.readUnsignedInt();
         this.FDeleteCost = param1.readUnsignedInt();
         this.FRefreshCost = param1.readUnsignedInt();
         this.FCanDeleteCount = param1.readUnsignedInt();
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc2_);
         this.FScore = new TActivityRCScore(_loc5_.index);
         this.FScore.GetType = _loc5_.getType;
         this.FScore.Condition = _loc5_.condition;
         this.FFreeTime = new TActivityRCButton(param1.readUnsignedInt());
         this.FGoldStartBtn = new TActivityRCButton(param1.readUnsignedInt());
         this.FGoldRefreshbtn = new TActivityRCButton(param1.readUnsignedInt());
         this.FGoldSelectBtn = new TActivityRCButton(param1.readUnsignedInt());
         this.FGoldRestartBtn = new TActivityRCButton(param1.readUnsignedInt());
         this.FSuperStartBtn = new TActivityRCButton(param1.readUnsignedInt());
         this.FSuperSelectBtn = new TActivityRCButton(param1.readUnsignedInt());
         this.FSuperRestartBtn = new TActivityRCButton(param1.readUnsignedInt());
         _loc2_ = TUtilityString.FetchUTF(param1);
         _loc5_ = Json.decode(_loc2_);
         this.FPrompts = new TActivitySPPrompts(_loc5_);
      }
      
      public function get GoldAwards() : Vector.<TActivityRCGoldAward>
      {
         return this.FGoldAwards;
      }
      
      public function get SuperAwards() : TActivityRCSuperAward
      {
         return this.FSuperAwards;
      }
      
      public function get SelectCost() : uint
      {
         return this.FSelectCost;
      }
      
      public function get DeleteCost() : uint
      {
         return this.FDeleteCost;
      }
      
      public function get RefreshCost() : uint
      {
         return this.FRefreshCost;
      }
      
      public function get CanDeleteCount() : uint
      {
         return this.FCanDeleteCount;
      }
      
      public function get Score() : TActivityRCScore
      {
         return this.FScore;
      }
      
      public function get FreeTime() : TActivityRCButton
      {
         return this.FFreeTime;
      }
      
      public function get GoldStartBtn() : TActivityRCButton
      {
         return this.FGoldStartBtn;
      }
      
      public function get GoldRefreshbtn() : TActivityRCButton
      {
         return this.FGoldRefreshbtn;
      }
      
      public function get GoldSelectBtn() : TActivityRCButton
      {
         return this.FGoldSelectBtn;
      }
      
      public function get GoldRestartBtn() : TActivityRCButton
      {
         return this.FGoldRestartBtn;
      }
      
      public function get SuperStartBtn() : TActivityRCButton
      {
         return this.FSuperStartBtn;
      }
      
      public function get SuperSelectBtn() : TActivityRCButton
      {
         return this.FSuperSelectBtn;
      }
      
      public function get SuperRestartBtn() : TActivityRCButton
      {
         return this.FSuperRestartBtn;
      }
      
      public function get Prompts() : TActivitySPPrompts
      {
         return this.FPrompts;
      }
   }
}

