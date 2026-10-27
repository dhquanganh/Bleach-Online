package Logics.HDChess
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityChessAward extends TActivityEntity
   {
      
      protected var FCondition:Vector.<uint>;
      
      protected var FAward:uint;
      
      protected var FStatus:int;
      
      public function TActivityChessAward(param1:uint)
      {
         super(param1);
         this.FCondition = new Vector.<uint>(3);
      }
      
      public function get Condition() : Vector.<uint>
      {
         return this.FCondition;
      }
      
      public function set Condition(param1:Vector.<uint>) : void
      {
         this.FCondition = param1;
      }
      
      public function get Award() : uint
      {
         return this.FAward;
      }
      
      public function set Award(param1:uint) : void
      {
         this.FAward = param1;
      }
      
      public function get Status() : int
      {
         return this.FStatus;
      }
      
      public function set Status(param1:int) : void
      {
         this.FStatus = param1;
      }
   }
}

