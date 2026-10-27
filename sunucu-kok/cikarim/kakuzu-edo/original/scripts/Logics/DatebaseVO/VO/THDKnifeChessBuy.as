package Logics.DatebaseVO.VO
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Utilities.TUtilityString;
   import flash.utils.ByteArray;
   import ghostcat.util.data.Json;
   
   use namespace ResourcesSpace;
   
   public class THDKnifeChessBuy extends THDActivityBase
   {
      
      protected var FRecharge:int;
      
      protected var FStepGold:int;
      
      protected var FStepIndex:int;
      
      protected var FCurStep:int;
      
      protected var FStageIndex:int;
      
      protected var FOpenStageIndex:int;
      
      protected var FOperIndex:int;
      
      protected var FOnekeyIndex:int;
      
      protected var FNormalAward:int;
      
      protected var FStageAward:Vector.<int>;
      
      protected var FStageGold:Vector.<int>;
      
      protected var FStageScore:Vector.<int>;
      
      protected var FStageScoreID:int;
      
      protected var FMall:Vector.<Object>;
      
      public function THDKnifeChessBuy()
      {
         super();
      }
      
      override ResourcesSpace function ReadDataByStream(param1:ByteArray) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         super.ResourcesSpace::ReadDataByStream(param1);
         this.FRecharge = param1.readInt();
         this.FStepGold = param1.readInt();
         this.FStepIndex = param1.readInt();
         this.FCurStep = param1.readInt();
         this.FStageIndex = param1.readInt();
         this.FOpenStageIndex = param1.readInt();
         this.FOperIndex = param1.readInt();
         this.FOnekeyIndex = param1.readInt();
         this.FNormalAward = param1.readInt();
         this.FStageAward = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FStageGold = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FStageScore = Vector.<int>(Json.decode(TUtilityString.FetchUTF(param1)));
         this.FStageScoreID = param1.readInt();
         this.FMall = Vector.<Object>(Json.decode(TUtilityString.FetchUTF(param1)));
      }
      
      public function get Recharge() : int
      {
         return this.FRecharge;
      }
      
      public function get StepIndex() : int
      {
         return this.FStepIndex;
      }
      
      public function get CurStep() : int
      {
         return this.FCurStep;
      }
      
      public function get StageIndex() : int
      {
         return this.FStageIndex;
      }
      
      public function get OperIndex() : int
      {
         return this.FOperIndex;
      }
      
      public function get OnekeyIndex() : int
      {
         return this.FOnekeyIndex;
      }
      
      public function get NormalAward() : int
      {
         return this.FNormalAward;
      }
      
      public function get StageAward() : Vector.<int>
      {
         return this.FStageAward;
      }
      
      public function get StageGold() : Vector.<int>
      {
         return this.FStageGold;
      }
      
      public function get Mall() : Vector.<Object>
      {
         return this.FMall;
      }
      
      public function get StepGold() : int
      {
         return this.FStepGold;
      }
      
      public function get OpenStageIndex() : int
      {
         return this.FOpenStageIndex;
      }
      
      public function get StageScore() : Vector.<int>
      {
         return this.FStageScore;
      }
      
      public function set StageScore(param1:Vector.<int>) : void
      {
         this.FStageScore = param1;
      }
      
      public function get StageScoreID() : int
      {
         return this.FStageScoreID;
      }
      
      public function set StageScoreID(param1:int) : void
      {
         this.FStageScoreID = param1;
      }
   }
}

