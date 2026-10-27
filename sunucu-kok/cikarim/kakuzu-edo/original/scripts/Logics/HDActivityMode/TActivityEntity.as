package Logics.HDActivityMode
{
   public class TActivityEntity
   {
      
      protected var FIndex:uint;
      
      public function TActivityEntity(param1:uint)
      {
         super();
         this.FIndex = param1;
      }
      
      public function get Index() : uint
      {
         return this.FIndex;
      }
   }
}

