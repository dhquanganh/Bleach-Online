package Logics.HDChristmas
{
   import Logics.DatebaseVO.VO.THDChristmasWish;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.HDChristmas.VO.TBellExchangeVo;
   import Logics.HDChristmas.VO.TBellPlayerRankVo;
   import Logics.HDChristmas.VO.TBellVo;
   import Logics.HDChristmas.VO.TRankAwardVo;
   import Logics.Inventories.TInventories;
   import Logics.SLogicsCore;
   import Resources.Constants.CONST_CHRISTMAS;
   
   public class TActivityChristmasWishData extends TActivityOSBase
   {
      
      private var FActivityConfig:THDChristmasWish;
      
      private var FExtractInventories:Vector.<TInventories>;
      
      private var FTotalBellValue:int;
      
      private var FExchangeBellValue:int;
      
      private var FFreeWishValue:int;
      
      private var FAllServerBellValue:int;
      
      private var FBellAwardList:Vector.<TBellVo>;
      
      private var FExchangeList:Vector.<TBellExchangeVo>;
      
      private var FRankAwardList:Vector.<TRankAwardVo>;
      
      private var FPlayerBellRankList:Vector.<TBellPlayerRankVo>;
      
      private var FTurntablePos:int;
      
      private var FPlayeCurrentRank:int;
      
      public function TActivityChristmasWishData()
      {
         super();
         this.FExtractInventories = new Vector.<TInventories>();
         this.FBellAwardList = new Vector.<TBellVo>();
         this.FExchangeList = new Vector.<TBellExchangeVo>();
         this.FRankAwardList = new Vector.<TRankAwardVo>();
         this.FPlayerBellRankList = new Vector.<TBellPlayerRankVo>();
      }
      
      public function get ActivityConfig() : THDChristmasWish
      {
         return this.FActivityConfig;
      }
      
      public function set ActivityConfig(param1:THDChristmasWish) : void
      {
         this.FActivityConfig = param1;
      }
      
      public function get ExtractInventories() : Vector.<TInventories>
      {
         return this.FExtractInventories;
      }
      
      public function set ExtractInventories(param1:Vector.<TInventories>) : void
      {
         this.FExtractInventories = param1;
      }
      
      public function get BellAwardList() : Vector.<TBellVo>
      {
         return this.FBellAwardList;
      }
      
      public function set BellAwardList(param1:Vector.<TBellVo>) : void
      {
         this.FBellAwardList = param1;
      }
      
      public function get TotalBellValue() : int
      {
         return this.FTotalBellValue;
      }
      
      public function set TotalBellValue(param1:int) : void
      {
         this.FTotalBellValue = param1;
      }
      
      public function get ExchangeBellValue() : int
      {
         return this.FExchangeBellValue;
      }
      
      public function set ExchangeBellValue(param1:int) : void
      {
         this.FExchangeBellValue = param1;
      }
      
      public function get FreeWishValue() : int
      {
         return this.FFreeWishValue;
      }
      
      public function set FreeWishValue(param1:int) : void
      {
         this.FFreeWishValue = param1;
      }
      
      public function get AllServerBellValue() : int
      {
         return this.FAllServerBellValue;
      }
      
      public function set AllServerBellValue(param1:int) : void
      {
         this.FAllServerBellValue = param1;
      }
      
      public function get ExchangeList() : Vector.<TBellExchangeVo>
      {
         return this.FExchangeList;
      }
      
      public function set ExchangeList(param1:Vector.<TBellExchangeVo>) : void
      {
         this.FExchangeList = param1;
      }
      
      public function get RankAwardList() : Vector.<TRankAwardVo>
      {
         return this.FRankAwardList;
      }
      
      public function set RankAwardList(param1:Vector.<TRankAwardVo>) : void
      {
         this.FRankAwardList = param1;
      }
      
      public function get TurntablePos() : int
      {
         return this.FTurntablePos;
      }
      
      public function set TurntablePos(param1:int) : void
      {
         this.FTurntablePos = param1;
      }
      
      public function SetBellRankData(param1:Vector.<Vector.<Object>>) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc5_:TBellPlayerRankVo = null;
         _loc3_ = int(param1[0].length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = new TBellPlayerRankVo();
            _loc4_ = param1[0][_loc2_];
            _loc5_.PlayerName = _loc4_.Name;
            _loc5_.PlayerRank = _loc4_.Rank;
            _loc5_.PlayerBellValue = _loc4_.Value;
            this.FPlayerBellRankList[_loc2_] = _loc5_;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            _loc5_ = this.FPlayerBellRankList[_loc2_];
            if(_loc5_.PlayerName == SLogicsCore.Character.NickName)
            {
               this.FPlayeCurrentRank = _loc5_.PlayerRank;
               break;
            }
            this.FPlayeCurrentRank = CONST_CHRISTMAS.NO_RANK;
            _loc2_++;
         }
      }
      
      public function get PlayeCurrentRank() : int
      {
         return this.FPlayeCurrentRank;
      }
      
      public function get PlayerBellRankList() : Vector.<TBellPlayerRankVo>
      {
         return this.FPlayerBellRankList;
      }
   }
}

