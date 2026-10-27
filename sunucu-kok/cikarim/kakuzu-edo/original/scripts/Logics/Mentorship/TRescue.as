package Logics.Mentorship
{
   import Logics.Mentorship.Elements.TRescuePlayer;
   
   public class TRescue
   {
      
      protected var FRescueList:Vector.<TRescuePlayer>;
      
      public function TRescue()
      {
         super();
         this.FRescueList = new Vector.<TRescuePlayer>();
      }
      
      public function get RescueList() : Vector.<TRescuePlayer>
      {
         return this.FRescueList;
      }
      
      public function set RescueList(param1:Vector.<TRescuePlayer>) : void
      {
         this.FRescueList = param1;
      }
   }
}

