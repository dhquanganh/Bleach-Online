package Logics.HDPyramid
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class THDPyramidData extends TActivityOSBase
   {
      
      protected var FRechargeNum:uint;
      
      protected var FExtractNum:uint;
      
      protected var FScoreNum:uint;
      
      protected var FPosition:int;
      
      protected var FCurLine:uint;
      
      protected var FPreLine:int;
      
      protected var FGiftStatus:Vector.<int>;
      
      public function THDPyramidData()
      {
         super();
      }
      
      public function get RechargeNum() : uint
      {
         return this.FRechargeNum;
      }
      
      public function set RechargeNum(param1:uint) : void
      {
         this.FRechargeNum = param1;
      }
      
      public function get ExtractNum() : uint
      {
         return this.FExtractNum;
      }
      
      public function set ExtractNum(param1:uint) : void
      {
         this.FExtractNum = param1;
      }
      
      public function get ScoreNum() : uint
      {
         return this.FScoreNum;
      }
      
      public function set ScoreNum(param1:uint) : void
      {
         this.FScoreNum = param1;
      }
      
      public function get Position() : int
      {
         return this.FPosition;
      }
      
      public function set Position(param1:int) : void
      {
         this.FPosition = param1;
      }
      
      public function get CurLine() : uint
      {
         return this.FCurLine;
      }
      
      public function set CurLine(param1:uint) : void
      {
         this.FCurLine = param1;
      }
      
      public function get PreLine() : int
      {
         return this.FPreLine;
      }
      
      public function set PreLine(param1:int) : void
      {
         this.FPreLine = param1;
      }
      
      public function get GiftStatus() : Vector.<int>
      {
         return this.FGiftStatus;
      }
      
      public function set GiftStatus(param1:Vector.<int>) : void
      {
         this.FGiftStatus = param1;
      }
   }
}

