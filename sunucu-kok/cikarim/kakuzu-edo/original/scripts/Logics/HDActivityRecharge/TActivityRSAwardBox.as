package Logics.HDActivityRecharge
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityRSAwardBox extends TActivityEntity
   {
      
      protected var FBoxStatus:int;
      
      public function TActivityRSAwardBox(param1:uint)
      {
         super(param1);
      }
      
      public function get BoxStatus() : int
      {
         return this.FBoxStatus;
      }
      
      public function set BoxStatus(param1:int) : void
      {
         this.FBoxStatus = param1;
      }
   }
}

