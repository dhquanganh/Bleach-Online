package Logics.HDIceHeros
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityLoot extends TActivityEntity
   {
      
      protected var FChipFrame:uint;
      
      public function TActivityLoot(param1:uint)
      {
         super(param1);
      }
      
      public function get ChipFrame() : uint
      {
         return this.FChipFrame;
      }
      
      public function set ChipFrame(param1:uint) : void
      {
         this.FChipFrame = param1;
      }
   }
}

