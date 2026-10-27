package Logics.DatebaseVO.VO.Json
{
   public class TConditionStyleA
   {
      
      protected var FKey:uint;
      
      protected var FValue:Vector.<uint>;
      
      protected var FPrompt:String;
      
      public function TConditionStyleA(param1:Object)
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         super();
         this.FKey = param1.key;
         if(param1.value != null)
         {
            _loc4_ = param1.value as Array;
            _loc3_ = int(_loc4_.length);
            this.FValue = new Vector.<uint>(_loc3_);
            _loc2_ = 0;
            while(_loc2_ < _loc3_)
            {
               this.FValue[_loc2_] = _loc4_[_loc2_];
               _loc2_++;
            }
         }
         this.FPrompt = param1.prompt;
      }
      
      public function get Key() : uint
      {
         return this.FKey;
      }
      
      public function get Value() : Vector.<uint>
      {
         return this.FValue;
      }
      
      public function get Prompt() : String
      {
         return this.FPrompt;
      }
   }
}

