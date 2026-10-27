package Logics.HDChess
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityChess extends TActivityOSBase
   {
      
      protected var FBoxes:Vector.<uint>;
      
      protected var FFinalAward:Vector.<uint>;
      
      protected var FAchieveAward:Vector.<TActivityChessAward>;
      
      protected var FMaxDiceNum:uint;
      
      protected var FNormalCost:uint;
      
      protected var FControlCost:uint;
      
      protected var FLocationIndex:uint;
      
      protected var FLocationPos:uint;
      
      protected var FFinalBoxIndex:uint;
      
      protected var FCoolDown:uint;
      
      public function TActivityChess()
      {
         super();
      }
      
      public function get Boxes() : Vector.<uint>
      {
         return this.FBoxes;
      }
      
      public function set Boxes(param1:Vector.<uint>) : void
      {
         this.FBoxes = param1;
      }
      
      public function get FinalAward() : Vector.<uint>
      {
         return this.FFinalAward;
      }
      
      public function set FinalAward(param1:Vector.<uint>) : void
      {
         this.FFinalAward = param1;
      }
      
      public function get AchieveAward() : Vector.<TActivityChessAward>
      {
         return this.FAchieveAward;
      }
      
      public function set AchieveAward(param1:Vector.<TActivityChessAward>) : void
      {
         this.FAchieveAward = param1;
      }
      
      public function get MaxDiceNum() : uint
      {
         return this.FMaxDiceNum;
      }
      
      public function set MaxDiceNum(param1:uint) : void
      {
         this.FMaxDiceNum = param1;
      }
      
      public function get NormalCost() : uint
      {
         return this.FNormalCost;
      }
      
      public function set NormalCost(param1:uint) : void
      {
         this.FNormalCost = param1;
      }
      
      public function get ControlCost() : uint
      {
         return this.FControlCost;
      }
      
      public function set ControlCost(param1:uint) : void
      {
         this.FControlCost = param1;
      }
      
      public function get LocationIndex() : uint
      {
         return this.FLocationIndex;
      }
      
      public function set LocationIndex(param1:uint) : void
      {
         this.FLocationIndex = param1;
      }
      
      public function get LocationPos() : uint
      {
         return this.FLocationPos;
      }
      
      public function set LocationPos(param1:uint) : void
      {
         this.FLocationPos = param1;
      }
      
      public function get FinalBoxIndex() : uint
      {
         return this.FFinalBoxIndex;
      }
      
      public function set FinalBoxIndex(param1:uint) : void
      {
         this.FFinalBoxIndex = param1;
      }
      
      public function get CoolDown() : uint
      {
         return this.FCoolDown;
      }
      
      public function set CoolDown(param1:uint) : void
      {
         this.FCoolDown = param1;
      }
      
      public function SetLocationPos(param1:int) : void
      {
         this.FLocationPos = param1;
      }
      
      public function SetFinalBoxIndex(param1:int) : void
      {
         this.FFinalBoxIndex = param1;
      }
      
      public function SetStatusByUIndex(param1:uint, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc4_ = int(this.FAchieveAward.length);
         _loc3_ = 0;
         while(_loc3_ < _loc4_)
         {
            if(param1 == this.FAchieveAward[_loc3_].Index)
            {
               this.FAchieveAward[_loc3_].Status = param2;
               return;
            }
            _loc3_++;
         }
      }
   }
}

