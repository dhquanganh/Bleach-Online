package Logics.HDTeamBuy
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityTBBox extends TActivityEntity
   {
      
      protected var FBoxStatus:int;
      
      public function TActivityTBBox(param1:uint)
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

