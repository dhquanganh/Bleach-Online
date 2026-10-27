package Processors.Game.MiniBattle.ScriptAction
{
   import Processors.Game.MiniBattle.Mode.TFileScriptAction;
   
   public class TScriptActionPlaySound extends TScriptAction
   {
      
      protected var FSoundID:uint;
      
      public function TScriptActionPlaySound()
      {
         super();
      }
      
      override public function Trigger() : void
      {
         PlaySound(this.FSoundID);
      }
      
      override public function Init(param1:TFileScriptAction) : void
      {
         super.Init(param1);
         this.FSoundID = param1.Next();
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FSoundID = 0;
      }
   }
}

