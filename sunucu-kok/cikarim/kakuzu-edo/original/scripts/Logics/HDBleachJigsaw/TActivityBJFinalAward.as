package Logics.HDBleachJigsaw
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityBJFinalAward extends TActivityEntity
   {
      
      protected var FAward:uint;
      
      public function TActivityBJFinalAward(param1:uint)
      {
         super(param1);
      }
      
      public function get Award() : uint
      {
         return this.FAward;
      }
      
      public function set Award(param1:uint) : void
      {
         this.FAward = param1;
      }
   }
}

