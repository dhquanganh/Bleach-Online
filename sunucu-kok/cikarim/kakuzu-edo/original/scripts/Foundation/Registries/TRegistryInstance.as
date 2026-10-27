package Foundation.Registries
{
   public class TRegistryInstance
   {
      
      protected var FIdentifiers:Vector.<uint>;
      
      protected var FInstances:Vector.<Object>;
      
      public function TRegistryInstance()
      {
         super();
         this.FIdentifiers = new Vector.<uint>();
         this.FInstances = new Vector.<Object>();
      }
      
      public function get Count() : int
      {
         return this.FIdentifiers.length;
      }
      
      public function GetInstanceByIndex(param1:int) : Object
      {
         return this.FInstances[param1];
      }
      
      public function GetIdentifierByIndex(param1:int) : uint
      {
         return this.FIdentifiers[param1];
      }
      
      public function Register(param1:uint, param2:Object) : void
      {
         this.FIdentifiers.push(param1);
         this.FInstances.push(param2);
      }
      
      public function GetIdentifierByInstance(param1:Object) : int
      {
         var _loc2_:int = 0;
         _loc2_ = this.FInstances.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return this.FIdentifiers[_loc2_];
         }
         return -1;
      }
      
      public function GetInstanceByIdentifier(param1:uint) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = this.FIdentifiers.indexOf(param1);
         if(_loc3_ >= 0)
         {
            return this.FInstances[_loc3_];
         }
         return null;
      }
      
      public function DeleteInstanceByIdentifier(param1:uint) : Boolean
      {
         var _loc2_:int = 0;
         _loc2_ = this.FIdentifiers.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.FInstances.splice(_loc2_,1);
            this.FIdentifiers.splice(_loc2_,1);
            return true;
         }
         return false;
      }
      
      public function Clear() : void
      {
         this.FInstances.length = 0;
         this.FIdentifiers.length = 0;
      }
   }
}

