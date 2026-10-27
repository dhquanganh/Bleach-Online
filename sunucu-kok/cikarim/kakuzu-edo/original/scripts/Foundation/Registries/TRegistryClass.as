package Foundation.Registries
{
   import Foundation.Utilities.*;
   
   public class TRegistryClass
   {
      
      protected var FClasses:Vector.<Class>;
      
      public function TRegistryClass()
      {
         super();
         this.FClasses = new Vector.<Class>();
      }
      
      public function get Count() : int
      {
         return this.FClasses.length;
      }
      
      public function GetClassByIndex(param1:int) : Class
      {
         return this.FClasses[param1];
      }
      
      public function GetIndexByClass(param1:Class) : int
      {
         return this.FClasses.indexOf(param1);
      }
      
      public function GetIndexByInstance(param1:Object) : int
      {
         var _loc2_:Class = null;
         _loc2_ = TUtilityRTTI.GetClassByInstance(param1);
         return this.FClasses.indexOf(_loc2_);
      }
      
      public function GetClassByInstance(param1:Object) : Class
      {
         var _loc2_:Class = null;
         var _loc3_:int = 0;
         _loc2_ = TUtilityRTTI.GetClassByInstance(param1);
         _loc3_ = this.FClasses.indexOf(_loc2_);
         if(_loc3_ >= 0)
         {
            return this.FClasses[_loc3_];
         }
         return null;
      }
   }
}

