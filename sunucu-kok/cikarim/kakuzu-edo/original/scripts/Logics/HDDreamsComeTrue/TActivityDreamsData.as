package Logics.HDDreamsComeTrue
{
   import Logics.DatebaseVO.VO.THDDreamsComeTrue;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDDreamsComeTrue.vo.TAwardExchangeVo;
   import Logics.HDDreamsComeTrue.vo.TFontIMGVo;
   import Logics.HDDreamsComeTrue.vo.TScorePlayerRankVo;
   import Logics.HDDreamsComeTrue.vo.TScoreRankAwardVo;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_DREAMS;
   
   public class TActivityDreamsData extends TActivityOSBase
   {
      
      protected var FActivityConfig:THDDreamsComeTrue;
      
      protected var FExchangeList:Vector.<TAwardExchangeVo>;
      
      protected var FGetFontImgList:Vector.<TFontIMGVo>;
      
      protected var FTotalScore:int;
      
      protected var FRankAwardList:Vector.<TScoreRankAwardVo>;
      
      protected var FPlayerScoreRankList:Vector.<TScorePlayerRankVo>;
      
      protected var FPlayeCurrentRank:int;
      
      protected var FLowFreeTime:int;
      
      protected var FHighFreeTime:int;
      
      public function TActivityDreamsData()
      {
         super();
         this.FExchangeList = new Vector.<TAwardExchangeVo>();
         this.FGetFontImgList = new Vector.<TFontIMGVo>();
         this.FRankAwardList = new Vector.<TScoreRankAwardVo>();
         this.FPlayerScoreRankList = new Vector.<TScorePlayerRankVo>();
      }
      
      public function get ActivityConfig() : THDDreamsComeTrue
      {
         return this.FActivityConfig;
      }
      
      public function set ActivityConfig(param1:THDDreamsComeTrue) : void
      {
         this.FActivityConfig = param1;
      }
      
      public function get ExchangeList() : Vector.<TAwardExchangeVo>
      {
         return this.FExchangeList;
      }
      
      public function set ExchangeList(param1:Vector.<TAwardExchangeVo>) : void
      {
         this.FExchangeList = param1;
      }
      
      public function get GetFontImgList() : Vector.<TFontIMGVo>
      {
         return this.FGetFontImgList;
      }
      
      public function set GetFontImgList(param1:Vector.<TFontIMGVo>) : void
      {
         this.FGetFontImgList = param1;
      }
      
      public function get PlayeCurrentRank() : int
      {
         return this.FPlayeCurrentRank;
      }
      
      public function get TotalScore() : int
      {
         return this.FTotalScore;
      }
      
      public function set TotalScore(param1:int) : void
      {
         this.FTotalScore = param1;
      }
      
      public function get LowFreeTime() : int
      {
         return this.FLowFreeTime;
      }
      
      public function set LowFreeTime(param1:int) : void
      {
         this.FLowFreeTime = param1;
      }
      
      public function get HighFreeTime() : int
      {
         return this.FHighFreeTime;
      }
      
      public function set HighFreeTime(param1:int) : void
      {
         this.FHighFreeTime = param1;
      }
      
      public function get PlayerScoreRankList() : Vector.<TScorePlayerRankVo>
      {
         return this.FPlayerScoreRankList;
      }
      
      public function get RankAwardList() : Vector.<TScoreRankAwardVo>
      {
         return this.FRankAwardList;
      }
      
      public function set RankAwardList(param1:Vector.<TScoreRankAwardVo>) : void
      {
         this.FRankAwardList = param1;
      }
      
      public function GetCurTypeExchangeList(param1:int) : Vector.<TAwardExchangeVo>
      {
         var _loc2_:Vector.<TAwardExchangeVo> = null;
         var _loc3_:TAwardExchangeVo = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc2_ = new Vector.<TAwardExchangeVo>();
         _loc5_ = int(this.FExchangeList.length);
         _loc4_ = 0;
         while(_loc4_ < _loc5_)
         {
            _loc3_ = this.FExchangeList[_loc4_];
            if(_loc3_.AwardType == param1)
            {
               _loc2_.push(_loc3_);
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function GetCurFontVo(param1:int) : TFontIMGVo
      {
         var _loc2_:TFontIMGVo = null;
         for each(_loc2_ in this.FGetFontImgList)
         {
            if(param1 == _loc2_.FontIndex)
            {
               break;
            }
         }
         return _loc2_;
      }
      
      public function SetScoreRankData(param1:Vector.<Vector.<Object>>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:TScorePlayerRankVo = null;
         _loc3_ = int(param1[0].length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TScorePlayerRankVo();
            _loc4_ = param1[0][_loc2_];
            _loc5_.PlayerName = _loc4_.Name;
            _loc5_.PlayerRank = _loc4_.Rank;
            _loc5_.PlayerBellValue = _loc4_.Value;
            this.FPlayerScoreRankList[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FPlayerScoreRankList[_loc2_];
            if(_loc5_.PlayerName == SLogicsCore.Character.NickName)
            {
               this.FPlayeCurrentRank = _loc5_.PlayerRank;
               break;
            }
            this.FPlayeCurrentRank = CONST_DREAMS.NO_RANK;
            _loc2_++;
         }
      }
   }
}

