package Logics.Home.LuckyCat
{
   public class TLuckyCat
   {
      
      protected var FMaxLuckyCatCount:uint;
      
      protected var FDesc:String;
      
      public function TLuckyCat()
      {
         super();
      }
      
      public function get MaxLuckyCatCount() : uint
      {
         return this.FMaxLuckyCatCount;
      }
      
      public function set MaxLuckyCatCount(param1:uint) : void
      {
         this.FMaxLuckyCatCount = param1;
      }
      
      public function get Desc() : String
      {
         return this.FDesc;
      }
      
      public function set Desc(param1:String) : void
      {
         this.FDesc = param1;
      }
   }
}

