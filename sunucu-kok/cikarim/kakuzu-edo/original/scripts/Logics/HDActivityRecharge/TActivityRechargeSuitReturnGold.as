package Logics.HDActivityRecharge
{
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TActivityRechargeSuitReturnGold extends TActivityOSBase
   {
      
      protected var FAwardBox:TActivityRSAwardBox;
      
      public function TActivityRechargeSuitReturnGold()
      {
         super();
      }
      
      public function get AwardBox() : TActivityRSAwardBox
      {
         return this.FAwardBox;
      }
      
      public function SetData(param1:TActivityRSAwardBox) : void
      {
         this.FAwardBox = param1;
      }
      
      public function UpdateData(param1:int) : void
      {
         if(this.FAwardBox == null)
         {
            return;
         }
         this.FAwardBox.BoxStatus = param1;
      }
   }
}

