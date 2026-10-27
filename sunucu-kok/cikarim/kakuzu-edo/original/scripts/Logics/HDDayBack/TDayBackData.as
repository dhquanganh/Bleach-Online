package Logics.HDDayBack
{
   import Logics.ActivityVO.THDGiftVO;
   import Logics.ActivityVO.THDShowAwardVO;
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TDayBackData extends TActivityOSBase
   {
      
      protected var FDay:uint;
      
      protected var FLoginGiftVO:THDGiftVO;
      
      protected var FProg:uint;
      
      protected var FLink:uint;
      
      protected var FRechGifts:Vector.<THDShowAwardVO>;
      
      protected var FFinalGift:THDShowAwardVO;
      
      protected var FCurrentRechGiftsState:int;
      
      public function TDayBackData()
      {
         super();
         this.FRechGifts = new Vector.<THDShowAwardVO>();
         this.FLoginGiftVO = new THDGiftVO();
         this.FFinalGift = new THDShowAwardVO();
         this.FCurrentRechGiftsState = -1;
      }
      
      public function get Day() : uint
      {
         return this.FDay;
      }
      
      public function set Day(param1:uint) : void
      {
         this.FDay = param1;
      }
      
      public function get LoginGiftVO() : THDGiftVO
      {
         return this.FLoginGiftVO;
      }
      
      public function set LoginGiftVO(param1:THDGiftVO) : void
      {
         this.FLoginGiftVO = param1;
      }
      
      public function get Prog() : uint
      {
         return this.FProg;
      }
      
      public function set Prog(param1:uint) : void
      {
         this.FProg = param1;
      }
      
      public function get Link() : uint
      {
         return this.FLink;
      }
      
      public function set Link(param1:uint) : void
      {
         this.FLink = param1;
      }
      
      public function get RechGifts() : Vector.<THDShowAwardVO>
      {
         return this.FRechGifts;
      }
      
      public function set RechGifts(param1:Vector.<THDShowAwardVO>) : void
      {
         this.FRechGifts = param1;
      }
      
      public function get FinalGift() : THDShowAwardVO
      {
         return this.FFinalGift;
      }
      
      public function set FinalGift(param1:THDShowAwardVO) : void
      {
         this.FFinalGift = param1;
      }
      
      public function get CurrentRechGiftsState() : int
      {
         return this.FCurrentRechGiftsState;
      }
      
      public function set CurrentRechGiftsState(param1:int) : void
      {
         this.FCurrentRechGiftsState = param1;
      }
   }
}

