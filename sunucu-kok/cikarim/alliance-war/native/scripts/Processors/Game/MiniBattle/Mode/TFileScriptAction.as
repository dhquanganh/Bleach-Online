package Processors.Game.MiniBattle.Mode
{
   public class TFileScriptAction
   {
      
      protected var FScriptAction:Vector.<int>;
      
      protected var FPoint:int;
      
      public function TFileScriptAction()
      {
         super();
      }
      
      public function set ScriptAction(param1:Vector.<int>) : void
      {
         this.FScriptAction = param1;
      }
      
      public function Reset() : void
      {
         this.FPoint = 0;
         this.FScriptAction = null;
      }
      
      public function Next() : int
      {
         var _loc1_:int = 0;
         _loc1_ = this.FScriptAction[this.FPoint];
         ++this.FPoint;
         return _loc1_;
      }
      
      public function HaveNext() : Boolean
      {
         return this.FPoint < this.FScriptAction.length;
      }
   }
}

