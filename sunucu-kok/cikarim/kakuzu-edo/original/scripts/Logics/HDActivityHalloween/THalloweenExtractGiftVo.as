package Logics.HDActivityHalloween
{
   import Logics.Inventories.TInventories;
   
   public class THalloweenExtractGiftVo
   {
      
      protected var FIsScanExtract:Boolean;
      
      protected var FAwardId:int;
      
      protected var FInventories:TInventories;
      
      public function THalloweenExtractGiftVo()
      {
         super();
      }
      
      public function get IsScanExtract() : Boolean
      {
         return this.FIsScanExtract;
      }
      
      public function set IsScanExtract(param1:Boolean) : void
      {
         this.FIsScanExtract = param1;
      }
      
      public function get AwardId() : int
      {
         return this.FAwardId;
      }
      
      public function set AwardId(param1:int) : void
      {
         this.FAwardId = param1;
      }
      
      public function get Inventories() : TInventories
      {
         return this.FInventories;
      }
      
      public function set Inventories(param1:TInventories) : void
      {
         this.FInventories = param1;
      }
   }
}

