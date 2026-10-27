package Logics.HDActivityGambling
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityDataWins extends TActivityEntity
   {
      
      protected var FWinCount:int;
      
      public function TActivityDataWins(param1:uint)
      {
         super(param1);
         this.FWinCount = 0;
      }
      
      public function get WinCount() : int
      {
         return this.FWinCount;
      }
      
      public function set WinCount(param1:int) : void
      {
         if(param1 < 0)
         {
            this.FWinCount = 0;
         }
         else
         {
            this.FWinCount = param1;
         }
      }
   }
}

