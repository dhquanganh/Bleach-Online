package Logics.Affairs
{
   public class TAffairDelay extends TAffair
   {
      
      protected var FDelayTicks:int;
      
      protected var FReferenceTick:int;
      
      public function TAffairDelay(param1:uint)
      {
         super(param1);
      }
      
      public function get DelayTicks() : int
      {
         return this.FDelayTicks;
      }
      
      public function set DelayTicks(param1:int) : void
      {
         this.FDelayTicks = param1;
      }
      
      public function get ReferenceTick() : int
      {
         return this.FReferenceTick;
      }
      
      public function set ReferenceTick(param1:int) : void
      {
         this.FReferenceTick = param1;
      }
   }
}

