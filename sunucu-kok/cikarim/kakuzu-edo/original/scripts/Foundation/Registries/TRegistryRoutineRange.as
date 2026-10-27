package Foundation.Registries
{
   public class TRegistryRoutineRange extends TRegistryRoutine
   {
      
      protected var FIdentifiersUpperBound:Vector.<uint>;
      
      public function TRegistryRoutineRange()
      {
         super();
         this.FIdentifiersUpperBound = new Vector.<uint>();
      }
      
      override public function Register(param1:uint, param2:Function) : void
      {
         FIdentifiers.push(param1);
         this.FIdentifiersUpperBound.push(param1);
         FRoutines.push(param2);
      }
      
      override public function GetRoutineByIndentifier(param1:uint) : Function
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc2_ = int(FIdentifiers.length);
         _loc3_ = 0;
         while(_loc3_ < _loc2_)
         {
            if(param1 >= FIdentifiers[_loc3_] && param1 <= this.FIdentifiersUpperBound[_loc3_])
            {
               return FRoutines[_loc3_];
            }
            _loc3_++;
         }
         return null;
      }
      
      public function RegisterRange(param1:uint, param2:uint, param3:Function) : void
      {
         FIdentifiers.push(param1);
         this.FIdentifiersUpperBound.push(param2);
         FRoutines.push(param3);
      }
   }
}

