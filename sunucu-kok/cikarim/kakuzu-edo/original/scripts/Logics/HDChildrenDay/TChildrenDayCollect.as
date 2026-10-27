package Logics.HDChildrenDay
{
   import Logics.DatebaseVO.VO.THDChildrenDayCollect;
   import Logics.HDActivityOS.TActivityOSBase;
   
   public class TChildrenDayCollect extends TActivityOSBase
   {
      
      protected var FBagStatus:Vector.<int>;
      
      protected var FConfig:THDChildrenDayCollect;
      
      public function TChildrenDayCollect()
      {
         super();
         this.FBagStatus = new Vector.<int>(2);
      }
      
      public function get BagStatus() : Vector.<int>
      {
         return this.FBagStatus;
      }
      
      public function set BagStatus(param1:Vector.<int>) : void
      {
         this.FBagStatus = param1;
      }
      
      public function get Config() : THDChildrenDayCollect
      {
         return this.FConfig;
      }
      
      public function set Config(param1:THDChildrenDayCollect) : void
      {
         this.FConfig = param1;
      }
   }
}

