package Logics.HDBleachJigsaw
{
   import Logics.HDActivityMode.TActivityEntity;
   
   public class TActivityBJItem extends TActivityEntity
   {
      
      protected var FCost:uint;
      
      protected var FIsHad:int;
      
      protected var FNum:uint;
      
      protected var FAward:uint;
      
      public function TActivityBJItem(param1:uint)
      {
         super(param1);
      }
      
      public function get Cost() : uint
      {
         return this.FCost;
      }
      
      public function set Cost(param1:uint) : void
      {
         this.FCost = param1;
      }
      
      public function get IsHad() : int
      {
         return this.FIsHad;
      }
      
      public function set IsHad(param1:int) : void
      {
         this.FIsHad = param1;
      }
      
      public function get Num() : uint
      {
         return this.FNum;
      }
      
      public function set Num(param1:uint) : void
      {
         this.FNum = param1;
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

