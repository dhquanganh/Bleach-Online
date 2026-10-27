package Foundation.Registries
{
   public class TRegistryClassAutomatic extends TRegistryClass
   {
      
      public function TRegistryClassAutomatic()
      {
         super();
      }
      
      public function Register(param1:Class) : int
      {
         var _loc2_:int = 0;
         _loc2_ = FClasses.indexOf(param1);
         if(_loc2_ >= 0)
         {
            return _loc2_;
         }
         _loc2_ = int(FClasses.length);
         FClasses.push(param1);
         return _loc2_;
      }
   }
}

