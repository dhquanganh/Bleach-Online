package Foundation.Resources.XML
{
   import Foundation.Resources.Common.TResource;
   import Foundation.Resources.Spaces.ResourcesSpace;
   
   use namespace ResourcesSpace;
   
   public class TXml extends TResource
   {
      
      protected var FValue:XML;
      
      public function TXml(param1:uint)
      {
         super(param1);
      }
      
      ResourcesSpace function XMLAppend(param1:XML) : void
      {
         this.FValue = param1;
      }
      
      public function get Value() : XML
      {
         return this.FValue;
      }
   }
}

