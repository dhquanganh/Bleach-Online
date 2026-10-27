package Logics.HDRandCard
{
   import Foundation.Timing.STimingCore;
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityRandCard extends TActivityOSBase
   {
      
      protected var FGoldAwards:Vector.<TActivityRCGoldAward>;
      
      protected var FSuperAwards:TActivityRCSuperAward;
      
      protected var FScore:TActivityRCScore;
      
      protected var FFreeTime:TActivityRCButton;
      
      protected var FFreeCoolingTime:int;
      
      protected var FGoldStartBtn:TActivityRCButton;
      
      protected var FGoldRefreshBtn:TActivityRCButton;
      
      protected var FGoldSelectBtn:TActivityRCButton;
      
      protected var FGoldRestartBtn:TActivityRCButton;
      
      protected var FSuperStartBtn:TActivityRCButton;
      
      protected var FSuperSelectBtn:TActivityRCButton;
      
      protected var FSuperRestartBtn:TActivityRCButton;
      
      protected var FGoldStage:TActivityRCStageData;
      
      protected var FSuperStage:TActivityRCStageData;
      
      protected var FCurGoldAwards:TActivityRCGoldAward;
      
      public function TActivityRandCard()
      {
         super();
         this.FGoldStage = new TActivityRCStageData();
         this.FSuperStage = new TActivityRCStageData();
      }
      
      public function set GoldAwards(param1:Vector.<TActivityRCGoldAward>) : void
      {
         this.FGoldAwards = param1;
      }
      
      public function set SuperAwards(param1:TActivityRCSuperAward) : void
      {
         this.FSuperAwards = param1;
      }
      
      public function set Score(param1:TActivityRCScore) : void
      {
         this.FScore = param1;
      }
      
      public function set FreeTime(param1:TActivityRCButton) : void
      {
         this.FFreeTime = param1;
      }
      
      public function set GoldStartBtn(param1:TActivityRCButton) : void
      {
         this.FGoldStartBtn = param1;
      }
      
      public function set GoldRefreshBtn(param1:TActivityRCButton) : void
      {
         this.FGoldRefreshBtn = param1;
      }
      
      public function set GoldSelectBtn(param1:TActivityRCButton) : void
      {
         this.FGoldSelectBtn = param1;
      }
      
      public function set GoldRestartBtn(param1:TActivityRCButton) : void
      {
         this.FGoldRestartBtn = param1;
      }
      
      public function set SuperStartBtn(param1:TActivityRCButton) : void
      {
         this.FSuperStartBtn = param1;
      }
      
      public function set SuperSelectBtn(param1:TActivityRCButton) : void
      {
         this.FSuperSelectBtn = param1;
      }
      
      public function set SuperRestartBtn(param1:TActivityRCButton) : void
      {
         this.FSuperRestartBtn = param1;
      }
      
      public function set GoldStage(param1:TActivityRCStageData) : void
      {
         this.FGoldStage = param1;
      }
      
      public function set SuperStage(param1:TActivityRCStageData) : void
      {
         this.FSuperStage = param1;
      }
      
      public function get CurGoldAwards() : TActivityRCGoldAward
      {
         return this.FCurGoldAwards;
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
      
      public function get GoldRefreshBtn() : TActivityRCButton
      {
         return this.FGoldRefreshBtn;
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
      
      public function get GoldStage() : TActivityRCStageData
      {
         return this.FGoldStage;
      }
      
      public function get SuperStage() : TActivityRCStageData
      {
         return this.FSuperStage;
      }
      
      public function get GoldAwards() : Vector.<TActivityRCGoldAward>
      {
         return this.FGoldAwards;
      }
      
      public function get SuperAwards() : TActivityRCSuperAward
      {
         return this.FSuperAwards;
      }
      
      public function get FreeCoolingTime() : int
      {
         return this.FFreeCoolingTime;
      }
      
      public function SetGoldAward(param1:uint) : void
      {
         if(param1 < this.FGoldAwards.length)
         {
            this.FCurGoldAwards = this.FGoldAwards[param1];
         }
      }
      
      public function SetData(param1:uint, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.FCurGoldAwards != null)
         {
            _loc4_ = int(this.FCurGoldAwards.AwardCard.length);
            _loc3_ = 0;
            while(_loc3_ < _loc4_)
            {
               if(param1 == this.FCurGoldAwards.AwardCard[_loc3_].Index)
               {
                  this.FCurGoldAwards.AwardCard[_loc3_].IsDelete = !Boolean(param2);
               }
               _loc3_++;
            }
         }
         if(param1 == this.FScore.Index)
         {
            this.FScore.Num = param2 < 0 ? 0 : uint(param2);
         }
         if(param1 == this.FFreeTime.Index)
         {
            this.FFreeTime.Status = param2;
            this.FFreeCoolingTime = STimingCore.ServerTick + param2;
         }
      }
      
      public function GetGoldCardByUIndex(param1:uint) : TActivityRCAwardCard
      {
         return this.FCurGoldAwards.AwardCard[param1];
      }
      
      public function GetSuperCardByUIndex(param1:uint) : TActivityRCAwardCard
      {
         if(param1 >= this.FSuperAwards.RandAwards.length)
         {
            return null;
         }
         return this.FSuperAwards.RandAwards[param1];
      }
   }
}

