package Foundation.Resources.SWF
{
   import Foundation.Resources.Common.TResource;
   import Foundation.Resources.Spaces.ResourcesSpace;
   import flash.display.DisplayObject;
   
   use namespace ResourcesSpace;
   
   public class TSwf extends TResource
   {
      
      protected var FValue:DisplayObject;
      
      public function TSwf(param1:uint)
      {
         super(param1);
      }
      
      ResourcesSpace function SWFAppend(param1:DisplayObject) : void
      {
         this.FValue = param1;
      }
      
      public function get Value() : DisplayObject
      {
         return this.FValue;
      }
   }
}

