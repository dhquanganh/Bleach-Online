package Logics.MiniBattle
{
   import Processors.Game.MiniBattle.ScriptAction.*;
   import Resources.Constants.*;
   import flash.utils.getDefinitionByName;
   
   public class TPoolScript
   {
      
      protected static const ScripActionClass:Vector.<Class> = CONST_MINIBATTLE.ScripActionClass;
      
      protected var FPools:Vector.<Vector.<TScriptAction>>;
      
      public function TPoolScript()
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         super();
         this.FPools = new Vector.<Vector.<TScriptAction>>();
         _loc2_ = int(ScripActionClass.length);
         _loc1_ = 0;
         while(_loc1_ < _loc2_)
         {
            this.FPools.push(new Vector.<TScriptAction>());
            _loc1_++;
         }
      }
      
      public function AcquireScript(param1:int) : TScriptAction
      {
         var _loc2_:Vector.<TScriptAction> = null;
         _loc2_ = this.FPools[param1];
         if(_loc2_.length > 0)
         {
            return _loc2_.pop();
         }
         return new ScripActionClass[param1]();
      }
      
      public function Release(param1:Object) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = int(ScripActionClass.length);
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            if(param1 is ScripActionClass[_loc2_])
            {
               this.FPools[_loc2_].push(param1);
               return;
            }
            _loc2_++;
         }
      }
   }
}

