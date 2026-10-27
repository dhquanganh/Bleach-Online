package Logics.HyperStrings.Elements
{
   public class THyperStringElementLinkEvent extends THyperStringElementText
   {
      
      protected var FEventID:uint;
      
      public function THyperStringElementLinkEvent()
      {
         super();
      }
      
      public function get EventID() : uint
      {
         return this.FEventID;
      }
      
      public function set EventID(param1:uint) : void
      {
         this.FEventID = param1;
      }
   }
}

