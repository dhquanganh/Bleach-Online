package Foundation.Resources.Streamization.XML
{
   import Foundation.Resources.Spaces.ResourcesSpace;
   import Foundation.Resources.Streamization.TResourceUnstreamizer;
   import Foundation.Resources.XML.TXml;
   import flash.utils.ByteArray;
   
   use namespace ResourcesSpace;
   
   public class TResourceUnstreamizerXml extends TResourceUnstreamizer
   {
      
      public function TResourceUnstreamizerXml()
      {
         super();
      }
      
      override protected function UnstreamizationPerform(param1:ByteArray, param2:Object, param3:Object) : void
      {
         this.UnstreamizationPerform_Traversal(param1,param2,param3);
      }
      
      protected function UnstreamizationPerform_Traversal(param1:ByteArray, param2:Object, param3:Object) : void
      {
         var _loc4_:int = 0;
         var _loc5_:TXml = null;
         var _loc6_:XML = null;
         var _loc7_:uint = 0;
         var _loc8_:ByteArray = null;
         _loc8_ = new ByteArray();
         _loc5_ = param2 as TXml;
         _loc7_ = param1.readUnsignedInt();
         _loc4_ = int(param1.readUnsignedInt());
         param1.readBytes(_loc8_,0,_loc4_);
         _loc6_ = new XML(_loc8_);
         _loc5_.XMLAppend(_loc6_);
         ResourceNotifyUnstreamized(_loc5_);
      }
   }
}

