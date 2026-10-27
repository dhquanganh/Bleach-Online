package Logics.HDRandCard
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityRCButton extends TActivityEntity
   {
      
      protected var FStatus:int;
      
      public function TActivityRCButton(param1:uint)
      {
         super(param1);
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
   }
}

