package Foundation.Registries
{
   import Foundation.Utilities.*;
   
   public class TRegistryClassManual extends TRegistryClass
   {
      
      protected var FIdentifiers:Vector.<uint>;
      
      public function TRegistryClassManual()
      {
         super();
         this.FIdentifiers = new Vector.<uint>();
      }
      
      protected function RegisterClass(param1:uint, param2:Class) : Boolean
      {
         var _loc3_:int = 0;
         _loc3_ = this.FIdentifiers.indexOf(param1);
         if(_loc3_ >= 0)
         {
            return false;
         }
         _loc3_ = FClasses.indexOf(param2);
         if(_loc3_ >= 0)
         {
            return false;
         }
         FClasses.push(param2);
         this.FIdentifiers.push(param1);
         return true;
      }
      
      public function GetIdentifierByIndex(param1:int) : uint
      {
         return this.FIdentifiers[param1];
      }
      
      public function Register(param1:uint, param2:Class) : Boolean
      {
         return this.RegisterClass(param1,param2);
      }
      
      public function GetIndexByIdentifier(param1:uint) : int
      {
         return this.FIdentifiers.indexOf(param1);
      }
      
      public function GetClassByIdentifier(param1:uint) : Class
      {
         var _loc2_:int = 0;
         _loc2_ = this.FIdentifiers.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return FClasses[_loc2_];
         }
         return null;
      }
      
      public function GetIdentifierByClass(param1:Class) : uint
      {
         var _loc2_:int = 0;
         _loc2_ = FClasses.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return this.FIdentifiers[_loc2_];
         }
         return null;
      }
      
      public function GetIdentifierByInstance(param1:Object) : uint
      {
         var _loc2_:Class = null;
         var _loc3_:int = 0;
         _loc2_ = TUtilityRTTI.GetClassByInstance(param1);
         _loc3_ = FClasses.indexOf(_loc2_);
         if(_loc3_ >= 0)
         {
            return this.FIdentifiers[_loc3_];
         }
         return null;
      }
   }
}

