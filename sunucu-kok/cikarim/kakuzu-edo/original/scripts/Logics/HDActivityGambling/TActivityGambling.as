package Logics.HDActivityGambling
{
   import Logics.DatebaseVO.VO.Json.THDOSRank;
   import Logics.HDActivityOS.TActivityOSBase;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TActivityGambling extends TActivityOSBase
   {
      
      protected var FDataAwards:Vector.<TActivityDataAward>;
      
      protected var FDataFailOverCount:TActivityDataCount;
      
      protected var FDataStartCount:TActivityDataCount;
      
      protected var FDataButtons:Vector.<TActivityDataButton>;
      
      protected var FDataWinCount:TActivityDataWins;
      
      protected var FDataRankList:Vector.<THDOSRank>;
      
      protected var FDataStage:int;
      
      protected var FDataDicePoint:uint;
      
      protected var FDataIsWin:int;
      
      public function TActivityGambling()
      {
         super();
         this.FDataAwards = new Vector.<TActivityDataAward>();
         this.FDataButtons = new Vector.<TActivityDataButton>();
         this.FDataStage = CONST_ACTIVITY_MODE.STAGE_Gambling_None;
         this.FDataIsWin = CONST_ACTIVITY_MODE.STATUS_Gambling_None;
         this.FDataRankList = new Vector.<THDOSRank>();
      }
      
      public function set DataAwards(param1:Vector.<TActivityDataAward>) : void
      {
         this.FDataAwards = param1;
      }
      
      public function set DataButtons(param1:Vector.<TActivityDataButton>) : void
      {
         this.FDataButtons = param1;
      }
      
      public function set DataFailOverCount(param1:TActivityDataCount) : void
      {
         this.FDataFailOverCount = param1;
      }
      
      public function set DataStartCount(param1:TActivityDataCount) : void
      {
         this.FDataStartCount = param1;
      }
      
      public function set DataStage(param1:int) : void
      {
         this.FDataStage = param1;
      }
      
      public function set DataIsWin(param1:int) : void
      {
         this.FDataIsWin = param1;
      }
      
      public function set DataWinCount(param1:TActivityDataWins) : void
      {
         this.FDataWinCount = param1;
      }
      
      public function get DataStage() : int
      {
         return this.FDataStage;
      }
      
      public function get DataIsWin() : int
      {
         return this.FDataIsWin;
      }
      
      public function get DataDicePoint() : uint
      {
         return this.FDataDicePoint;
      }
      
      public function set DataDicePoint(param1:uint) : void
      {
         this.FDataDicePoint = param1;
      }
      
      public function get DataRankList() : Vector.<THDOSRank>
      {
         return this.FDataRankList;
      }
      
      public function set DataRankList(param1:Vector.<THDOSRank>) : void
      {
         this.FDataRankList = param1;
      }
      
      public function get DataWinCount() : TActivityDataWins
      {
         return this.FDataWinCount;
      }
      
      public function get DataStartCount() : TActivityDataCount
      {
         return this.FDataStartCount;
      }
      
      public function get DataFailOverCount() : TActivityDataCount
      {
         return this.FDataFailOverCount;
      }
      
      public function SetDataByUniqueIndex(param1:uint, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(this.FDataAwards == null)
         {
            return false;
         }
         _loc4_ = int(this.FDataAwards.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1 == this.FDataAwards[_loc3_].Index)
            {
               this.FDataAwards[_loc3_].Status = param2;
               return true;
            }
            _loc3_++;
         }
         if(param1 == this.FDataFailOverCount.Index)
         {
            this.FDataFailOverCount.UsedCount = param2;
            return true;
         }
         if(param1 == this.FDataStartCount.Index)
         {
            this.FDataStartCount.UsedCount = param2;
            return true;
         }
         if(param1 == this.FDataWinCount.Index)
         {
            this.FDataWinCount.WinCount = param2;
            return true;
         }
         return false;
      }
      
      public function SetDataByParameterVec(param1:Vector.<int>) : void
      {
         this.FDataStage = param1[0];
         this.FDataDicePoint = param1[1];
         this.FDataIsWin = param1[2];
      }
      
      public function GetAwardDataByIndex(param1:int) : TActivityDataAward
      {
         if(this.FDataAwards.length <= 0)
         {
            return null;
         }
         return this.FDataAwards[param1];
      }
      
      public function GetButtonDataByType(param1:uint) : TActivityDataButton
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(this.FDataButtons.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(this.FDataButtons[_loc2_].ButtonType == param1)
            {
               return this.FDataButtons[_loc2_];
            }
            _loc2_++;
         }
         return null;
      }
   }
}

