package Logics.HyperStrings.Elements
{
   public class THyperStringElementLinkURL extends THyperStringElementTextual
   {
      
      protected var FHyperlinkAddress:String;
      
      public function THyperStringElementLinkURL()
      {
         super();
         this.FHyperlinkAddress = "";
      }
      
      public function get HyperlinkAddress() : String
      {
         return this.FHyperlinkAddress;
      }
      
      public function set HyperlinkAddress(param1:String) : void
      {
         if(param1 == null)
         {
            param1 = "";
         }
         this.FHyperlinkAddress = param1;
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FHyperlinkAddress = "";
      }
      
      override public function FlushElement(param1:THyperStringElement) : void
      {
         var _loc2_:THyperStringElementLinkURL = null;
         super.FlushElement(param1);
         _loc2_ = param1 as THyperStringElementLinkURL;
         _loc2_.HyperlinkAddress = this.FHyperlinkAddress;
      }
   }
}

