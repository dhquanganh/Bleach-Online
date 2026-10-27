package Logics.HDChristmas2015
{
   import Logics.DatebaseVO.VO.THDSnowBattle;
   import Logics.HDActivityOS.TActivityOSBase;
   import Logics.Inventories.TInventories;
   import Resources.Constants.CONST_ACTIVITY_MODE;
   
   public class TSnowBattleData extends TActivityOSBase
   {
      
      public const CardsIndex:int = 97;
      
      protected var FTotalScore:uint;
      
      protected var FGameCount:uint;
      
      protected var FWheel:uint;
      
      protected var FTitleState:int;
      
      protected var FArticleState:Vector.<int>;
      
      protected var FConfig:THDSnowBattle;
      
      protected var FCurGetScore:int;
      
      protected var FInvs:TInventories;
      
      protected var FCardsBtnState:int;
      
      public function TSnowBattleData()
      {
         super();
         this.FArticleState = new Vector.<int>();
         this.FInvs = new TInventories();
         this.Reset();
      }
      
      public function get Config() : THDSnowBattle
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDSnowBattle) : void
      {
         this.FConfig = param1;
      }
      
      public function get TotalScore() : uint
      {
         return this.FTotalScore;
      }
      
      public function set TotalScore(param1:uint) : void
      {
         this.FTotalScore = param1;
      }
      
      public function get GameCount() : uint
      {
         return this.FGameCount;
      }
      
      public function set GameCount(param1:uint) : void
      {
         this.FGameCount = param1;
      }
      
      public function get Wheel() : uint
      {
         return this.FWheel;
      }
      
      public function set Wheel(param1:uint) : void
      {
         this.FWheel = param1;
      }
      
      public function get CurGetScore() : int
      {
         return this.FCurGetScore;
      }
      
      public function set CurGetScore(param1:int) : void
      {
         this.FCurGetScore = param1;
      }
      
      public function get ArticleState() : Vector.<int>
      {
         return this.FArticleState;
      }
      
      public function get TitleState() : int
      {
         return this.FTitleState;
      }
      
      public function set TitleState(param1:int) : void
      {
         this.FTitleState = param1;
      }
      
      public function get Invs() : TInventories
      {
         return this.FInvs;
      }
      
      public function get CardsBtnState() : int
      {
         return this.FCardsBtnState;
      }
      
      public function set CardsBtnState(param1:int) : void
      {
         this.FCardsBtnState = param1;
      }
      
      public function AllReceive() : Boolean
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = this.FArticleState.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            if(this.FArticleState[_loc1_] != CONST_ACTIVITY_MODE.Activity_AlreadyReceive)
            {
               return false;
            }
            _loc1_++;
         }
         return true;
      }
      
      public function ResetReceive() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         _loc2_ = this.FArticleState.length;
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FArticleState[_loc1_] = 0;
            _loc1_++;
         }
      }
      
      public function Reset() : void
      {
         this.FCurGetScore = -1;
      }
   }
}

