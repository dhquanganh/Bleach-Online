package Logics.HonorShop
{
   import Logics.DatebaseVO.VO.TMall;
   
   public class THonorShopItem
   {
      
      protected var FBoughtCount:uint;
      
      protected var FMall:TMall;
      
      public function THonorShopItem()
      {
         super();
         this.FMall = new TMall();
         this.FBoughtCount = 0;
      }
      
      public function get BoughtCount() : uint
      {
         return this.FBoughtCount;
      }
      
      public function set BoughtCount(param1:uint) : void
      {
         this.FBoughtCount = param1;
      }
      
      public function get Mall() : TMall
      {
         return this.FMall;
      }
      
      public function set Mall(param1:TMall) : void
      {
         this.FMall = param1;
      }
   }
}

