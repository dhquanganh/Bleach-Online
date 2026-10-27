package Foundation.Resources.Common
{
   import Foundation.Common.TEntity;
   import Foundation.Resources.Spaces.ResourcesSpace;
   
   use namespace ResourcesSpace;
   
   public class TResourceRequest extends TEntity
   {
      
      protected var FParameters:uint;
      
      public function TResourceRequest(param1:uint)
      {
         super(param1);
      }
      
      ResourcesSpace function Coerce(param1:uint) : void
      {
         FIdentifier = param1;
         this.FParameters = 0;
      }
      
      public function get Parameters() : uint
      {
         return this.FParameters;
      }
      
      public function set Parameters(param1:uint) : void
      {
         this.FParameters = param1;
      }
   }
}

