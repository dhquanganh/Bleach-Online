package Logics.Mentorship
{
   import Logics.Mentorship.Elements.TArrestPlayer;
   
   public class TArrest
   {
      
      protected var FArrestList:Vector.<TArrestPlayer>;
      
      public function TArrest()
      {
         super();
         this.FArrestList = new Vector.<TArrestPlayer>();
      }
      
      public function get ArrestList() : Vector.<TArrestPlayer>
      {
         return this.FArrestList;
      }
      
      public function set ArrestList(param1:Vector.<TArrestPlayer>) : void
      {
         this.FArrestList = param1;
      }
   }
}

