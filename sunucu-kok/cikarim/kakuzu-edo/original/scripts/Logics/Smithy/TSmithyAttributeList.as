package Logics.Smithy
{
   import Logics.Inventories.TEquipmentAppendAttributes;
   
   public class TSmithyAttributeList
   {
      
      protected var FAttributeList:Vector.<TEquipmentAppendAttributes>;
      
      protected var FCount:int;
      
      public function TSmithyAttributeList(param1:int)
      {
         var _loc2_:int = 0;
         super();
         this.FAttributeList = new Vector.<TEquipmentAppendAttributes>();
         _loc2_ = 0;
         while(_loc2_ < param1)
         {
            this.FAttributeList.push(new TEquipmentAppendAttributes());
            _loc2_++;
         }
      }
      
      public function get Count() : int
      {
         return this.FCount;
      }
      
      public function set Count(param1:int) : void
      {
         this.FCount = param1;
      }
      
      public function Clear() : void
      {
         this.FAttributeList.length = 0;
      }
      
      public function Add(param1:TEquipmentAppendAttributes) : void
      {
         this.FAttributeList.push(param1);
      }
      
      public function GetAttributesByIndex(param1:int) : TEquipmentAppendAttributes
      {
         return this.FAttributeList[param1];
      }
   }
}

