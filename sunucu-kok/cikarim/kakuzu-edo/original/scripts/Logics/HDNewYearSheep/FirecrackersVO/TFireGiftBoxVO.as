package Logics.HDNewYearSheep.FirecrackersVO
{
   import Logics.ActivityVO.THDGiftVO;
   
   public class TFireGiftBoxVO extends THDGiftVO
   {
      
      protected var FLastState:int;
      
      public function TFireGiftBoxVO()
      {
         super();
      }
      
      public function get LastState() : int
      {
         return this.FLastState;
      }
      
      public function set LastState(param1:int) : void
      {
         this.FLastState = param1;
      }
   }
}

