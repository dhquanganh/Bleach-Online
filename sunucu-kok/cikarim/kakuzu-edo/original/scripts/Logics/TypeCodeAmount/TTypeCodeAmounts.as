package Logics.TypeCodeAmount
{
   public class TTypeCodeAmounts
   {
      
      protected var FDatas:Vector.<TTypeCodeAmount>;
      
      public function TTypeCodeAmounts()
      {
         super();
         this.FDatas = new Vector.<TTypeCodeAmount>();
      }
      
      public function get Count() : int
      {
         return this.FDatas.length;
      }
      
      public function DataByIndex(param1:int) : TTypeCodeAmount
      {
         return this.FDatas[param1];
      }
      
      public function Clear() : void
      {
         this.FDatas.length = 0;
      }
      
      public function Add(param1:TTypeCodeAmount) : void
      {
         this.FDatas.push(param1);
      }
   }
}

