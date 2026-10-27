package Foundation.Resources.Streamization
{
   import Foundation.Resources.Common.TResource;
   import Foundation.Streamization.TUnstreamizer;
   
   public class TResourceUnstreamizer extends TUnstreamizer
   {
      
      protected var FOnResourceUnstreamized:Function;
      
      public function TResourceUnstreamizer()
      {
         super();
      }
      
      protected function ResourceNotifyUnstreamized(param1:TResource) : void
      {
         if(this.FOnResourceUnstreamized != null)
         {
            this.FOnResourceUnstreamized(this,param1);
         }
      }
      
      public function get Unstreamizing() : Boolean
      {
         return false;
      }
      
      public function get OnResourceUnstreamized() : Function
      {
         return this.FOnResourceUnstreamized;
      }
      
      public function set OnResourceUnstreamized(param1:Function) : void
      {
         this.FOnResourceUnstreamized = param1;
      }
      
      public function Process() : void
      {
      }
   }
}

