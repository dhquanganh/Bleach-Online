package Logics.Inventories
{
   public class TEquipmentAppendAttributes
   {
      
      protected var FAttributes:Vector.<TEquipmentAppendAttribute>;
      
      public function TEquipmentAppendAttributes()
      {
         super();
         this.FAttributes = new Vector.<TEquipmentAppendAttribute>();
      }
      
      public function get Count() : int
      {
         return this.FAttributes.length;
      }
      
      public function GetAttributeByIndex(param1:int) : TEquipmentAppendAttribute
      {
         return this.FAttributes[param1];
      }
      
      public function Clear() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:TEquipmentAppendAttribute = null;
         _loc1_ = int(this.FAttributes.length);
         _loc2_ = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.FAttributes[_loc2_];
            if(_loc3_ != null)
            {
               _loc3_.StubReferences.Dereference(this);
            }
            _loc2_++;
         }
         this.FAttributes.length = 0;
      }
      
      public function Add(param1:TEquipmentAppendAttribute) : void
      {
         param1.StubReferences.Reference(this);
         this.FAttributes.push(param1);
      }
   }
}

