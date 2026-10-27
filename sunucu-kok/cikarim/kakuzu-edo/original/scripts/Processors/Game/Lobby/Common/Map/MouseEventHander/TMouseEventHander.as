package Processors.Game.Lobby.Common.Map.MouseEventHander
{
   public class TMouseEventHander
   {
      
      protected var FCallback:Function;
      
      public function TMouseEventHander()
      {
         super();
      }
      
      public function get Callback() : Function
      {
         return this.FCallback;
      }
      
      public function set Callback(param1:Function) : void
      {
         this.FCallback = param1;
      }
      
      public function HandleOnMouseOver(param1:Object) : void
      {
      }
      
      public function HandleOnMouseMove(param1:Object) : void
      {
      }
      
      public function HandleOnMouseOut(param1:Object) : void
      {
      }
      
      public function HandleOnMouseClick(param1:Object) : void
      {
      }
   }
}

