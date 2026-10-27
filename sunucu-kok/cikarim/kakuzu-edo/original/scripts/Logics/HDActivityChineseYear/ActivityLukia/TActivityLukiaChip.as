package Logics.HDActivityChineseYear.ActivityLukia
{
   public class TActivityLukiaChip
   {
      
      protected var FIndex:int;
      
      protected var FChipNum:int;
      
      public function TActivityLukiaChip(param1:Object)
      {
         super();
         this.FIndex = param1.index;
      }
      
      public function get Index() : int
      {
         return this.FIndex;
      }
      
      public function set Index(param1:int) : void
      {
         this.FIndex = param1;
      }
      
      public function get ChipNum() : int
      {
         return this.FChipNum;
      }
      
      public function set ChipNum(param1:int) : void
      {
         this.FChipNum = param1;
      }
      
      public function UpdateState(param1:int, param2:int) : void
      {
      }
      
      public function FlushActivityData(param1:int, param2:int) : void
      {
         if(this.FIndex == param1)
         {
            this.FChipNum = param2;
         }
      }
   }
}

