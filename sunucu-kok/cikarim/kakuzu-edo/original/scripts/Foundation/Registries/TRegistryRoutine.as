package Foundation.Registries
{
   public class TRegistryRoutine
   {
      
      protected var FIdentifiers:Vector.<uint>;
      
      protected var FRoutines:Vector.<Function>;
      
      public function TRegistryRoutine()
      {
         super();
         this.FIdentifiers = new Vector.<uint>();
         this.FRoutines = new Vector.<Function>();
      }
      
      public function get Count() : int
      {
         return this.FIdentifiers.length;
      }
      
      public function GetRoutineByIndex(param1:int) : Function
      {
         return this.FRoutines[param1];
      }
      
      public function Register(param1:uint, param2:Function) : void
      {
         this.FIdentifiers.push(param1);
         this.FRoutines.push(param2);
      }
      
      public function GetRoutineByIndentifier(param1:uint) : Function
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = this.FIdentifiers.indexOf(param1);
         if(_loc3_ >= 0)
         {
            return this.FRoutines[_loc3_];
         }
         return null;
      }
   }
}

