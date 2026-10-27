package Logics.HDActivitySingle
{
   public class TStatusInfo
   {
      
      protected var FIndex:uint;
      
      protected var FCount:uint;
      
      public function TStatusInfo()
      {
         super();
         this.FIndex = 0;
         this.FCount = 0;
      }
      
      public function get Index() : uint
      {
         return this.FIndex;
      }
      
      public function set Index(param1:uint) : void
      {
         this.FIndex = param1;
      }
      
      public function get Count() : uint
      {
         return this.FCount;
      }
      
      public function set Count(param1:uint) : void
      {
         this.FCount = param1;
      }
   }
}

