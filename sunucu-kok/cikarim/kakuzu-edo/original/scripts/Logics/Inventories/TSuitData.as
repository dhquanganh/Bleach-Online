package Logics.Inventories
{
   public class TSuitData
   {
      
      protected var FName:String;
      
      protected var FMaxCount:uint;
      
      protected var FSuitEffects:TSuitEffects;
      
      public function TSuitData()
      {
         super();
         this.FName = "";
         this.FSuitEffects = new TSuitEffects();
      }
      
      public function get Name() : String
      {
         return this.FName;
      }
      
      public function set Name(param1:String) : void
      {
         this.FName = param1;
      }
      
      public function get MaxCount() : uint
      {
         return this.FMaxCount;
      }
      
      public function set MaxCount(param1:uint) : void
      {
         this.FMaxCount = param1;
      }
      
      public function get SuitEffects() : TSuitEffects
      {
         return this.FSuitEffects;
      }
      
      public function Reset() : void
      {
         this.FName = "";
         this.FMaxCount = 0;
         this.FSuitEffects.Clear();
      }
   }
}

