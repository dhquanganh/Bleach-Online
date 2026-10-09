package Logics.VoidSoulWorld
{
   import Logics.SLogicsCore;
   import Logics.VoidSoulWorld.VO.TFrontVO;
   import Logics.VoidSoulWorld.VO.TPlayerHurtVO;
   import Resources.Constants.CONST_VOIDSOULWORLD;
   
   public class TVoidSoulWorldData
   {
      
      protected var FBossHP:Number;
      
      protected var FHurtRank:Vector.<TPlayerHurtVO>;
      
      protected var FReportId:Vector.<String>;
      
      protected var FFront:Vector.<TFrontVO>;
      
      protected var FSubmitTime:uint;
      
      protected var FDeadTime:uint;
      
      protected var FForm:TVoidWorldForm;
      
      protected var FRewardIndex:uint;
      
      protected var FJoinAwardIndex:uint;
      
      protected var FJoinAwardState:uint;
      
      protected var FMyHurt:Number;
      
      public function TVoidSoulWorldData()
      {
         var _loc1_:uint = 0;
         var _loc2_:TFrontVO = null;
         super();
         this.FHurtRank = new Vector.<TPlayerHurtVO>(CONST_VOIDSOULWORLD.COUNT_HurlRank);
         this.FReportId = new Vector.<String>(CONST_VOIDSOULWORLD.COUNT_ReportId);
         this.FFront = new Vector.<TFrontVO>(CONST_VOIDSOULWORLD.COUNT_Front);
         this.FForm = new TVoidWorldForm();
         _loc1_ = 0;
         while(_loc1_ < CONST_VOIDSOULWORLD.COUNT_Front)
         {
            _loc2_ = new TFrontVO();
            this.FFront[_loc1_] = _loc2_;
            _loc1_++;
         }
      }
      
      public function get BossHP() : Number
      {
         return this.FBossHP;
      }
      
      public function set BossHP(param1:Number) : void
      {
         this.FBossHP = param1;
      }
      
      public function get HurtRank() : Vector.<TPlayerHurtVO>
      {
         return this.FHurtRank;
      }
      
      public function get ReportId() : Vector.<String>
      {
         return this.FReportId;
      }
      
      public function get Front() : Vector.<TFrontVO>
      {
         return this.FFront;
      }
      
      public function get SubmitTime() : uint
      {
         return this.FSubmitTime;
      }
      
      public function set SubmitTime(param1:uint) : void
      {
         this.FSubmitTime = param1;
      }
      
      public function get DeadTime() : uint
      {
         return this.FDeadTime;
      }
      
      public function set DeadTime(param1:uint) : void
      {
         this.FDeadTime = param1;
      }
      
      public function get Form() : TVoidWorldForm
      {
         return this.FForm;
      }
      
      public function get RewardIndex() : uint
      {
         return this.FRewardIndex;
      }
      
      public function set RewardIndex(param1:uint) : void
      {
         this.FRewardIndex = param1;
      }
      
      public function get JoinAwardState() : uint
      {
         return this.FJoinAwardState;
      }
      
      public function set JoinAwardState(param1:uint) : void
      {
         this.FJoinAwardState = param1;
      }
      
      public function get JoinAwardIndex() : uint
      {
         return this.FJoinAwardIndex;
      }
      
      public function set JoinAwardIndex(param1:uint) : void
      {
         this.FJoinAwardIndex = param1;
      }
      
      public function get MyHurt() : Number
      {
         return this.FMyHurt;
      }
      
      public function set MyHurt(param1:Number) : void
      {
         this.FMyHurt = param1;
      }
      
      public function FullHP() : void
      {
         this.FBossHP = -1;
      }
      
      public function IsMyself(param1:uint, param2:uint) : Boolean
      {
         if(param1 == SLogicsCore.Character.Identifier0 && param2 == SLogicsCore.Character.Identifier1)
         {
            return true;
         }
         return false;
      }
      
      public function HaveForm() : Boolean
      {
         return this.FForm.Heros.length > 0;
      }
      
      public function GameStart() : Boolean
      {
         return true;
      }
   }
}

