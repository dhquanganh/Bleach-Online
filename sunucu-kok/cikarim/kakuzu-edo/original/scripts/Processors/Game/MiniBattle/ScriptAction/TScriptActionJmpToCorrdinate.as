package Processors.Game.MiniBattle.ScriptAction
{
   import Processors.Game.MiniBattle.Mode.TFileScriptAction;
   
   public class TScriptActionJmpToCorrdinate extends TScriptAction
   {
      
      protected var FX:int;
      
      protected var FY:int;
      
      public function TScriptActionJmpToCorrdinate()
      {
         super();
      }
      
      override public function Trigger() : void
      {
         FSoldierMeView.x += this.FX;
         FSoldierMeView.y += this.FY;
      }
      
      override public function Init(param1:TFileScriptAction) : void
      {
         super.Init(param1);
         this.FX = param1.Next();
         this.FY = param1.Next();
      }
      
      override public function Reset() : void
      {
         super.Reset();
         this.FX = 0;
         this.FY = 0;
      }
   }
}

